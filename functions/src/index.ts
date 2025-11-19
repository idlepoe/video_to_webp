import * as admin from 'firebase-admin';
import { initializeFFmpeg } from './utils/ffmpeg';

// Firebase 초기화
admin.initializeApp();

// FFmpeg 초기화
initializeFFmpeg();

// 트리거 및 스케줄러 함수 export
export { convertVideo } from './handlers/convertVideo';
export { convertVideoPremium } from './handlers/convertVideoPremium';
export { cleanupOldFiles } from './handlers/cleanupOldFiles';

