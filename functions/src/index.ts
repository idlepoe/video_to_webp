import { onObjectFinalized } from 'firebase-functions/v2/storage';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import * as admin from 'firebase-admin';
import ffmpeg from 'fluent-ffmpeg';
import ffmpegStatic from 'ffmpeg-static';
import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';

// Firebase 초기화
admin.initializeApp();

// FFmpeg 경로 설정 및 실행 권한 부여
const ffmpegPathStr = ffmpegStatic as string;
if (!ffmpegPathStr) {
  console.error('FFmpeg path not found');
  throw new Error('FFmpeg path not found');
}

try {
  // FFmpeg 바이너리 파일에 실행 권한 부여
  fs.chmodSync(ffmpegPathStr, '755');
  ffmpeg.setFfmpegPath(ffmpegPathStr);
  console.log('FFmpeg 설정 완료:', ffmpegPathStr);
} catch (error) {
  console.error('FFmpeg 설정 중 오류 발생:', error);
  throw new Error('FFmpeg 설정 실패');
}

// Storage 트리거 함수
export const convertVideo = onObjectFinalized({
  region: 'us-west1',
  timeoutSeconds: 540,
  memory: '512MiB'
}, async (event) => {
  const fileBucket = event.data.bucket;
  const filePath = event.data.name;
  console.log('파일 업로드 감지:', filePath);

  if (!filePath) {
    console.error('파일 경로가 없음');
    return;
  }

  // original/ 디렉토리의 파일만 처리
  if (!filePath.startsWith('original/')) {
    console.log('original/ 디렉토리가 아닌 파일 무시');
    return;
  }

  let snapshot: FirebaseFirestore.QuerySnapshot | null = null;

  try {
    // Firestore에서 변환 요청 정보 조회
    console.log('변환 요청 정보 조회 시작');
    snapshot = await admin.firestore()
      .collection('convertRequests')
      .where('originalFile', '==', filePath)
      .where('status', '==', 'pending')
      .limit(1)
      .get();

    if (snapshot.empty) {
      console.log('해당 파일에 대한 변환 요청을 찾을 수 없음');
      return;
    }

    const doc = snapshot.docs[0];
    const requestData = doc.data();
    const options = requestData.options;
    console.log('변환 옵션:', options);

    const duration = options.duration || 1;

    // 임시 파일 경로 설정
    const tempDir = os.tmpdir();
    const inputPath = path.join(tempDir, 'input.mp4');
    const outputPath = path.join(tempDir, 'output.webp');
    console.log('임시 파일 경로:', { inputPath, outputPath });

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

    // ffprobe로 원본 비디오의 비트레이트 및 fps 추출
    const getBitrateAndFps = (filePath: string): Promise<{bitrate: number, fps: number}> => {
      return new Promise((resolve, reject) => {
        ffmpeg.ffprobe(filePath, (err, metadata) => {
          if (err) return reject(err);
          const bitrate = Number(metadata.format.bit_rate);
          const videoStream = metadata.streams.find((s: any) => s.codec_type === 'video');
          let fps = 30;
          if (videoStream && videoStream.r_frame_rate) {
            const [num, den] = videoStream.r_frame_rate.split('/').map(Number);
            if (den && den !== 0) {
              fps = num / den;
            }
          }
          resolve({ bitrate, fps });
        });
      });
    };

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
    const qualityFactor = (quality / 75) * 0.5;
    const totalFrames = Math.round(playbackDuration * fps);
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
    const outputFileName = `converted/${requestData.userId}/${doc.id}.${ffmpegFormat}`;
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
    await doc.ref.update({
      status: 'completed',
      convertedFile: outputFileName,
      publicUrl: publicUrl, // 이미지 표시용 URL
      downloadUrl: downloadUrl, // 다운로드용 URL
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('Firestore 상태 업데이트 완료');

    // FCM 푸시 알림 전송
    try {
      await sendPushNotification(requestData.userId, {
        publicUrl: publicUrl,
        downloadUrl: downloadUrl,
        convertedFile: outputFileName,
        requestId: doc.id,
      }, {
        resolution: `${width}x${height}`,
        fps: targetFps,
        quality: qualityPercent,
        format: ffmpegFormat,
      });
      console.log('FCM 푸시 알림 전송 완료');
    } catch (error) {
      console.error('FCM 푸시 알림 전송 실패:', error);
    }

    // 임시 파일 정리
    console.log('임시 파일 정리 시작');
    fs.unlinkSync(inputPath);
    fs.unlinkSync(outputPath);
    console.log('임시 파일 정리 완료');

  } catch (error: any) {
    console.error('비디오 변환 중 오류 발생:', error);
    // 에러 발생 시 Firestore 상태 업데이트
    if (snapshot && !snapshot.empty) {
      await snapshot.docs[0].ref.update({
        status: 'error',
        error: error.message || 'Unknown error',
      });
    }
  }
});

// 매일 00시에 자동으로 오래된 파일들을 삭제하는 스케줄링 함수
export const cleanupOldFiles = onSchedule({
  schedule: '0 0 * * *', // 매일 00시
  region: 'us-west1',
  timeoutSeconds: 540,
  memory: '512MiB'
}, async (event) => {
  console.log('자동 파일 정리 시작:', new Date().toISOString());
  
  try {
    const bucket = admin.storage().bucket();
    
    // original/ 디렉토리의 모든 파일들 삭제
    console.log('original/ 디렉토리 정리 시작');
    const [originalFiles] = await bucket.getFiles({
      prefix: 'original/',
    });
    
    let deletedCount = 0;
    for (const file of originalFiles) {
      console.log('원본 파일 삭제:', file.name);
      await file.delete();
      deletedCount++;
    }
    console.log(`original/ 디렉토리에서 ${deletedCount}개 파일 삭제 완료`);
    
    // converted/ 디렉토리의 모든 파일들 삭제
    console.log('converted/ 디렉토리 정리 시작');
    const [convertedFiles] = await bucket.getFiles({
      prefix: 'converted/',
    });
    
    deletedCount = 0;
    for (const file of convertedFiles) {
      console.log('변환 파일 삭제:', file.name);
      await file.delete();
      deletedCount++;
    }
    console.log(`converted/ 디렉토리에서 ${deletedCount}개 파일 삭제 완료`);
    
    // Firestore에서 convertRequests 컬렉션의 모든 문서 일괄 삭제
    console.log('Firestore convertRequests 컬렉션 정리 시작');
    const allRequests = await admin.firestore()
      .collection('convertRequests')
      .limit(500) // 한 번에 최대 500개씩 처리
      .get();
    
    const batch = admin.firestore().batch();
    let firestoreDeletedCount = 0;
    
    allRequests.docs.forEach(doc => {
      batch.delete(doc.ref);
      firestoreDeletedCount++;
    });
    
    if (firestoreDeletedCount > 0) {
      await batch.commit();
      console.log(`Firestore에서 ${firestoreDeletedCount}개 문서 삭제 완료`);
    }
    
    console.log('자동 파일 정리 완료');
    
  } catch (error) {
    console.error('자동 파일 정리 중 오류 발생:', error);
  }
});

// FCM 푸시 알림 전송 함수
async function sendPushNotification(userId: string, fileData: {
  publicUrl: string;
  downloadUrl: string;
  convertedFile: string;
  requestId: string;
}, videoInfo?: {
  resolution: string;
  fps: number;
  quality: number;
  format: string;
}) {
  try {
    // 비디오 정보를 포함한 메시지 생성
    let body = 'Video conversion completed!';
    if (videoInfo) {
      body = `Video converted to ${videoInfo.format.toUpperCase()} (${videoInfo.resolution}, ${videoInfo.fps}fps, ${videoInfo.quality}% quality)`;
    }

    const message = {
      notification: {
        title: 'Conversion Complete',
        body: body,
      },
      android: {
        notification: {
          icon: 'notification_icon',
          color: '#3182F6',
          priority: 'high' as const,
          defaultSound: true,
          defaultVibrateTimings: true,
        },
      },
      data: {
        screen: 'convert_complete',
        userId: userId,
        timestamp: Date.now().toString(),
        publicUrl: fileData.publicUrl,
        downloadUrl: fileData.downloadUrl,
        convertedFile: fileData.convertedFile,
        requestId: fileData.requestId,
        // 비디오 정보도 데이터에 포함
        resolution: videoInfo?.resolution || '',
        fps: videoInfo?.fps?.toString() || '',
        quality: videoInfo?.quality?.toString() || '',
        format: videoInfo?.format || '',
      },
      topic: userId, // 사용자별 토픽으로 전송
    };

    const response = await admin.messaging().send(message);
    console.log('FCM 메시지 전송 성공:', response);
    return response;
  } catch (error) {
    console.error('FCM 메시지 전송 실패:', error);
    throw error;
  }
}
