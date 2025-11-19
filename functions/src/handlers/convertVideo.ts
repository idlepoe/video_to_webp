import { onObjectFinalized } from 'firebase-functions/v2/storage';
import * as admin from 'firebase-admin';
import { convertVideo as convertVideoUtil } from '../utils/videoConverter';

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
    const requestData = doc.data() as {
      userId: string;
      options: any;
      isSample?: boolean;
    };

    // 비디오 변환 실행
    await convertVideoUtil(
      fileBucket,
      filePath,
      {
        userId: requestData.userId,
        options: requestData.options,
        isSample: requestData.isSample || false,
      },
      doc.ref,
      snapshot
    );

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

