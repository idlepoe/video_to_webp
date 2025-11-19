import { onSchedule } from 'firebase-functions/v2/scheduler';
import { cleanupOldFiles as cleanupOldFilesUtil } from '../utils/fileCleanup';

// 매일 00시에 자동으로 오래된 파일들을 삭제하는 스케줄링 함수
export const cleanupOldFiles = onSchedule({
  schedule: '0 0 * * *', // 매일 00시
  region: 'us-west1',
  timeoutSeconds: 540,
  memory: '512MiB'
}, async (event) => {
  try {
    await cleanupOldFilesUtil();
  } catch (error) {
    console.error('자동 파일 정리 중 오류 발생:', error);
  }
});

