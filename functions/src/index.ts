import * as logger from "firebase-functions/logger";
import {onObjectFinalized} from "firebase-functions/v2/storage";
import * as admin from "firebase-admin";
import ffmpeg from "fluent-ffmpeg";
import * as ffmpegPath from "ffmpeg-static";
import * as path from "path";
import * as os from "os";
import * as fs from "fs";
import { setGlobalOptions } from "firebase-functions/options";

admin.initializeApp();
setGlobalOptions({ region: "asia-northeast3" });

export const convertVideo = onObjectFinalized(async (event) => {
  const fileBucket = event.data.bucket;
  const filePath = event.data.name;
  if (!filePath) return;
  const fileName = path.basename(filePath);
  const tempFilePath = path.join(os.tmpdir(), fileName);
  const bucket = admin.storage().bucket(fileBucket);
  let snapshot: FirebaseFirestore.QuerySnapshot | null = null;
  let outTempPath = '';

  try {
    // 1. 파일 다운로드
    await bucket.file(filePath).download({destination: tempFilePath});

    // 2. Firestore에서 변환 옵션 조회
    snapshot = await admin.firestore().collection('convertRequests')
      .where('originalFile', '==', filePath)
      .where('status', '==', 'pending')
      .limit(1)
      .get();
    if (snapshot.empty) {
      logger.info('No matching Firestore document for this file.');
      return;
    }
    const doc = snapshot.docs[0];
    const options = doc.data().options || {};
    const format = options.format || 'webp';
    const quality = options.quality || 80;
    const fps = options.fps || 24;
    const resolution = options.resolution || '720p';

    // 3. 변환 파일 경로 및 이름 지정
    const outFileName = `${path.parse(fileName).name}_converted.${format}`;
    outTempPath = path.join(os.tmpdir(), outFileName);
    const outStoragePath = `converted/${outFileName}`;

    // 4. ffmpeg 변환
    const ffmpegPathStr = ffmpegPath as unknown as string;
    if (!ffmpegPathStr) {
      throw new Error('FFmpeg path not found');
    }
    ffmpeg.setFfmpegPath(ffmpegPathStr);

    await new Promise((resolve, reject) => {
      ffmpeg(tempFilePath)
        .outputOptions([
          `-vf scale=-2:${resolution === 'original' ? null : resolution.replace('p','')}`,
          `-r ${fps}`,
          `-q:v ${quality}`,
          format === 'webp' ? '-vcodec libwebp' : '',
          format === 'gif' ? '-f gif' : '',
        ].filter(Boolean))
        .output(outTempPath)
        .on('end', resolve)
        .on('error', (err) => {
          logger.error('FFmpeg error:', err);
          reject(err);
        })
        .run();
    });

    // 5. 변환 파일 Storage에 업로드
    await bucket.upload(outTempPath, {destination: outStoragePath});

    // 6. Firestore 상태/결과 파일 URL 업데이트
    await doc.ref.update({
      status: 'done',
      convertedFile: outStoragePath,
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`Converted file uploaded to ${outStoragePath}`);
  } catch (error: any) {
    logger.error('Error processing video:', error);
    // 에러 발생 시 Firestore 상태 업데이트
    if (snapshot && !snapshot.empty) {
      await snapshot.docs[0].ref.update({
        status: 'error',
        error: error.message || 'Unknown error',
      });
    }
  } finally {
    // 7. 임시 파일 삭제
    try {
      if (fs.existsSync(tempFilePath)) {
        fs.unlinkSync(tempFilePath);
      }
      if (outTempPath && fs.existsSync(outTempPath)) {
        fs.unlinkSync(outTempPath);
      }
    } catch (error) {
      logger.error('Error cleaning up temporary files:', error);
    }
  }
});
