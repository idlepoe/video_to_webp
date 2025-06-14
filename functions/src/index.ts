import { onObjectFinalized } from 'firebase-functions/v2/storage';
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
  memory: '2GiB',
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

    // 변환 옵션 설정
    const { resolution, fps, quality, format } = options;
    const ffmpegFormat = typeof format === 'string' ? format.toLowerCase() : 'webp';
    const [width, height] = resolution.split('x').map(Number);
    console.log('변환 설정:', { width, height, fps, quality, format: ffmpegFormat });

    // ffprobe로 원본 비디오의 비트레이트 추출
    const getBitrate = (filePath: string): Promise<number> => {
      return new Promise((resolve, reject) => {
        ffmpeg.ffprobe(filePath, (err, metadata) => {
          if (err) return reject(err);
          const bitrate = metadata.format.bit_rate;
          resolve(Number(bitrate));
        });
      });
    };

    const originalBitrate = await getBitrate(inputPath); // bps
    console.log('원본 비트레이트:', originalBitrate);
    const qualityPercent = typeof quality === 'number' ? quality : parseInt(quality, 10); // 1~100
    let targetBitrate = Math.round(originalBitrate * (qualityPercent / 100)); // bps
    let targetBitrateK = Math.max(Math.round(targetBitrate / 1000), 200); // 최소 200k
    console.log('적용 변환 비트레이트:', targetBitrateK + 'k');

    // FFmpeg 명령어 구성
    console.log('FFmpeg 변환 시작');
    const command = ffmpeg(inputPath)
      .size(`${width}x${height}`)
      .fps(fps)
      .videoBitrate(`${targetBitrateK}k`)
      .format(ffmpegFormat);

    // 변환 실행
    await new Promise<void>((resolve, reject) => {
      command
        .on('start', (commandLine) => {
          console.log('FFmpeg 명령어:', commandLine);
        })
        .on('progress', async (progress) => {
          console.log('변환 진행률:', progress);
          if (typeof progress.percent === 'number' && snapshot && !snapshot.empty) {
            try {
              await snapshot.docs[0].ref.update({
                progress: Math.round(progress.percent),
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
    console.log('변환된 파일 공개 URL:', publicUrl);

    // Firestore 상태 업데이트
    console.log('Firestore 상태 업데이트');
    await doc.ref.update({
      status: 'completed',
      convertedFile: outputFileName,
      downloadUrl: publicUrl,
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('Firestore 상태 업데이트 완료');

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
