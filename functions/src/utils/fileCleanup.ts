import * as admin from 'firebase-admin';

export async function cleanupOldFiles(): Promise<void> {
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
    throw error;
  }
}

