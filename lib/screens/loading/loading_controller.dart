import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../routes/app_routes.dart';

class LoadingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isCancelled = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final requestId = args?['requestId'] as String?;
    if (requestId != null) {
      listenToConvertRequest(requestId);
    } else {
      print('requestId가 전달되지 않음');
    }
  }

  void cancelConversion() {
    isCancelled.value = true;
    Get.back();
  }

  void listenToConvertRequest(String requestId) {
    print('변환 상태 구독 시작: $requestId');
    _firestore
        .collection('convertRequests')
        .doc(requestId)
        .snapshots()
        .listen((doc) {
      print('Firestore 문서 스냅샷 수신: exists=[0m${doc.exists}');
      if (!doc.exists) {
        print('문서가 존재하지 않음');
        return;
      }
      final data = doc.data();
      print('문서 데이터: $data');
      final status = data?['status'];
      print('현재 status: $status');
      if (status == 'completed') {
        print('변환 완료 감지! 결과 화면 이동');
        Get.offAllNamed(AppRoutes.complete, arguments: {
          'requestId': doc.id,
          'convertedFile': data?['convertedFile'],
        });
      } else if (status == 'error') {
        print('변환 오류 감지!');
        Get.back();
        Get.snackbar('오류', '변환 중 오류가 발생했습니다.');
      }
    }, onError: (e) {
      print('Firestore listen 에러: $e');
    });
  }
} 