import ffmpeg from 'fluent-ffmpeg';
import ffmpegStatic from 'ffmpeg-static';
import * as fs from 'fs';

// FFmpeg 경로 설정 및 실행 권한 부여
export function initializeFFmpeg(): void {
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
}

// ffprobe로 원본 비디오의 비트레이트 및 fps 추출
export function getBitrateAndFps(filePath: string): Promise<{bitrate: number, fps: number}> {
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
}

