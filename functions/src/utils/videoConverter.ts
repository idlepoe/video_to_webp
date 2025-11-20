import * as admin from 'firebase-admin';
import ffmpeg from 'fluent-ffmpeg';
import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';
import { getBitrateAndFps } from './ffmpeg';
import { sendPushNotification } from '../api/fcm';

export interface ConvertOptions {
  resolution: string;
  fps: number | string;
  quality: number | string;
  format: string;
  duration: number;
  startTime?: number;
  endTime?: number | null;
  speed?: number;
}

export interface ConvertRequestData {
  userId: string;
  options: ConvertOptions;
  isSample?: boolean;
}

export async function convertVideo(
  fileBucket: string,
  filePath: string,
  requestData: ConvertRequestData,
  docRef: FirebaseFirestore.DocumentReference,
  snapshot: FirebaseFirestore.QuerySnapshot
): Promise<void> {
  // 변환 시작 시간 기록
  const conversionStartTime = Date.now();
  
  const options = requestData.options;
  const isSample = requestData.isSample || false;
  console.log('변환 옵션:', options);
  console.log('샘플 변환 여부:', isSample);

  const duration = options.duration || 1;

  // 임시 파일 경로 설정
  const tempDir = os.tmpdir();
  const inputPath = path.join(tempDir, 'input.mp4');
  const outputPath = path.join(tempDir, 'output.webp');
  console.log('임시 파일 경로:', { inputPath, outputPath });

  try {
    // Storage에서 비디오 다운로드
    console.log('비디오 다운로드 시작');
    const bucket = admin.storage().bucket(fileBucket);
    await bucket.file(filePath).download({ destination: inputPath });
    console.log('비디오 다운로드 완료');

    // 변환 옵션 설정 (기존 호환성 유지)
    const { resolution, fps, quality, format, startTime = 0, endTime = null, speed = 1.0 } = options;
    const ffmpegFormat = typeof format === 'string' ? format.toLowerCase() : 'webp';
    const [width, height] = resolution.split('x').map(Number);
    console.log('변환 설정:', { width, height, fps, quality, format: ffmpegFormat, speed });
    
    // Trim 설정 로깅 (있는 경우만)
    if (startTime > 0 || endTime) {
      console.log('Trim 설정:', { startTime, endTime });
    }
    
    // 배속 설정 로깅 (1.0이 아닌 경우만)
    if (speed !== 1.0) {
      console.log('배속 설정:', { speed });
    }

    const { bitrate: originalBitrate, fps: originalFps } = await getBitrateAndFps(inputPath);
    console.log('원본 비트레이트:', originalBitrate, '원본 FPS:', originalFps);
    const qualityPercent = typeof quality === 'number' ? quality : parseInt(quality, 10); // 1~100
    
    // 비트레이트 계산 (qualityPercent는 영향 X, 100% 고정)
    let targetBitrate = originalBitrate; // qualityPercent 반영하지 않음
    const minBitrateK = Math.max(Math.round((width * height) / 1000), 200); // 해상도 기반 최소값
    let targetBitrateK = Math.max(Math.round(targetBitrate / 1000), minBitrateK);
    console.log('적용 변환 비트레이트:', targetBitrateK + 'k');

    // 변환 옵션의 fps가 원본보다 높으면 원본 fps로 강제
    let targetFps = fps;
    if (typeof targetFps === 'string') targetFps = parseFloat(targetFps);
    if (targetFps > originalFps) {
      console.log(`요청된 FPS(${targetFps})가 원본 FPS(${originalFps})보다 높아 원본 FPS로 변경합니다.`);
      targetFps = originalFps;
    }

    // FFmpeg 명령어 구성
    console.log('FFmpeg 변환 시작');
    let command = ffmpeg(inputPath);
    
    // Trim 설정이 있으면 적용
    const hasTrimSettings = (startTime && startTime > 0) || (endTime && endTime > 0);
    if (hasTrimSettings) {
      console.log('Trim 설정 감지 - 새로운 처리 방식 사용');
      
      if (startTime && startTime > 0) {
        console.log(`Trim 시작 시간: ${startTime}초`);
        command = command.seekInput(startTime);
      }
      
      if (endTime && endTime > startTime) {
        const duration = endTime - (startTime || 0);
        console.log(`Trim 지속 시간: ${duration}초`);
        command = command.duration(duration);
      }
    }

    // FFmpeg 옵션 설정 (qualityPercent만 -quality에 반영)
    let vfOptions = [`scale=${width}:${height}`];
    
    // 배속 설정이 1.0이 아닌 경우 setpts 필터 추가
    if (speed !== 1.0) {
      vfOptions.push(`setpts=${1/speed}*PTS`);
    }
    
    command = command
      .fps(targetFps)
      .videoBitrate(`${targetBitrateK}k`)
      .format(ffmpegFormat)
      .addOutputOptions([
        '-loop 0',
        '-progress', 'pipe:1',
        `-quality ${qualityPercent}`,
        `-vf ${vfOptions.join(',')}`
      ]);

    // 예상 용량 계산 (trim 및 배속 적용 시 조정)
    let actualDuration = duration;
    if (hasTrimSettings && endTime && startTime) {
      actualDuration = endTime - startTime;
      console.log(`Trim 적용으로 실제 변환 시간: ${actualDuration}초 (원본: ${duration}초)`);
    }
    
    // 배속 적용 시 실제 재생 시간 계산
    let playbackDuration = actualDuration;
    if (speed !== 1.0) {
      playbackDuration = actualDuration / speed;
      console.log(`배속 적용으로 실제 재생 시간: ${playbackDuration}초 (원본: ${actualDuration}초, 배속: ${speed}x)`);
    }
    
    const baseFrameSize = width * height * 0.1;
    const qualityFactor = (qualityPercent / 75) * 0.5;
    const totalFrames = Math.round(playbackDuration * targetFps);
    const estimatedSize = baseFrameSize * qualityFactor * totalFrames;

    // percent 변수를 함수 스코프에 선언
    let percent = 0;

    // 변환 실행
    await new Promise<void>((resolve, reject) => {
      command
        .on('start', (commandLine) => {
          console.log('FFmpeg 명령어:', commandLine);
        })
        .on('progress', async (progress) => {
          if (snapshot && !snapshot.empty) {
            try {
              let step = estimatedSize > 10 * 1024 * 1024 ? 1 : 2;
              percent += step;
              if (percent > 99) percent = 0;
              await snapshot.docs[0].ref.update({
                progress: percent,
              });
            } catch (e) {
              console.error('Firestore 진행률 업데이트 오류:', e);
            }
          }
        })
        .on('end', () => {
          console.log('FFmpeg 변환 완료');
          resolve();
        })
        .on('error', (err) => {
          console.error('FFmpeg 변환 오류:', err);
          reject(err);
        })
        .save(outputPath);
    });

    // 변환된 파일 확인
    if (!fs.existsSync(outputPath)) {
      throw new Error('변환된 파일이 생성되지 않았습니다.');
    }

    const stats = fs.statSync(outputPath);
    if (stats.size === 0) {
      throw new Error('변환된 파일의 크기가 0입니다.');
    }

    console.log('변환된 파일 크기:', stats.size, 'bytes');

    // 변환된 파일 업로드
    const outputFileName = `converted/${requestData.userId}/${docRef.id}.${ffmpegFormat}`;
    console.log('변환된 파일 업로드 시작:', outputFileName);
    await bucket.upload(outputPath, {
      destination: outputFileName,
      metadata: {
        contentType: ffmpegFormat === 'webp' ? 'image/webp' : 'video/webm',
      },
      predefinedAcl: 'publicRead',
    });
    console.log('변환된 파일 업로드 완료');

    // getSignedUrl 대신 public URL 직접 생성
    const publicUrl = `https://storage.googleapis.com/${bucket.name}/${outputFileName}`;
    const downloadUrl = `${publicUrl}?alt=media`;
    console.log('변환된 파일 공개 URL:', publicUrl);
    console.log('다운로드 URL:', downloadUrl);

    // Firestore 상태 업데이트
    console.log('Firestore 상태 업데이트');
    await docRef.update({
      status: 'completed',
      convertedFile: outputFileName,
      publicUrl: publicUrl, // 이미지 표시용 URL
      downloadUrl: downloadUrl, // 다운로드용 URL
      fileSize: stats.size, // 변환된 파일 크기 추가
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('Firestore 상태 업데이트 완료');

    // 변환 완료 시간 기록 및 경과 시간 계산
    const conversionEndTime = Date.now();
    const elapsedTime = Math.round((conversionEndTime - conversionStartTime) / 1000); // 초 단위
    console.log(`변환 완료 - 경과 시간: ${elapsedTime}초`);

    // FCM 푸시 알림 전송 (샘플 변환이 아닌 경우만)
    if (!isSample) {
      try {
        await sendPushNotification(requestData.userId, {
          publicUrl: publicUrl,
          downloadUrl: downloadUrl,
          convertedFile: outputFileName,
          requestId: docRef.id,
          fileSize: stats.size,
        }, {
          resolution: `${width}x${height}`,
          fps: targetFps,
          quality: qualityPercent,
          format: ffmpegFormat,
        }, elapsedTime);
        console.log('FCM 푸시 알림 전송 완료');
      } catch (error) {
        console.error('FCM 푸시 알림 전송 실패:', error);
      }
    } else {
      console.log('샘플 변환이므로 FCM 알림 전송 생략');
    }

    // 임시 파일 정리
    console.log('임시 파일 정리 시작');
    fs.unlinkSync(inputPath);
    fs.unlinkSync(outputPath);
    console.log('임시 파일 정리 완료');
  } catch (error) {
    // 에러 발생 시 임시 파일 정리
    try {
      if (fs.existsSync(inputPath)) fs.unlinkSync(inputPath);
      if (fs.existsSync(outputPath)) fs.unlinkSync(outputPath);
    } catch (cleanupError) {
      console.error('임시 파일 정리 중 오류:', cleanupError);
    }
    throw error;
  }
}

