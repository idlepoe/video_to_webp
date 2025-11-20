import * as admin from 'firebase-admin';

export interface FileData {
  publicUrl: string;
  downloadUrl: string;
  convertedFile: string;
  requestId: string;
  fileSize: number;
}

export interface VideoInfo {
  resolution: string;
  fps: number;
  quality: number;
  format: string;
}

// FCM 푸시 알림 전송 함수
export async function sendPushNotification(
  userId: string,
  fileData: FileData,
  videoInfo?: VideoInfo,
  elapsedTimeSeconds?: number
): Promise<string> {
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
        fileSize: fileData.fileSize?.toString() || '0',
        // 비디오 정보도 데이터에 포함
        resolution: videoInfo?.resolution || '',
        fps: videoInfo?.fps?.toString() || '',
        quality: videoInfo?.quality?.toString() || '',
        format: videoInfo?.format || '',
        // 변환에 걸린 시간 (초 단위)
        elapsedTime: elapsedTimeSeconds?.toString() || '',
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

