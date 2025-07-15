import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_snackbar.dart';

class LoadingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isCancelled = false.obs;
  final RxInt progress = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final requestId = args?['requestId'] as String?;
    if (requestId != null) {
      listenToConvertRequest(requestId);
    }
  }

  void cancelConversion() {
    isCancelled.value = true;
    Get.back();
  }

  void listenToConvertRequest(String requestId) async {
    final docRef = _firestore.collection('convertRequests').doc(requestId);
    final docSnap = await docRef.get();
    if (!docSnap.exists) {
      return;
    }
    final data = docSnap.data();
    final status = data?['status'];
    progress.value = data?['progress'] ?? 0;
    if (status == 'completed') {
      Get.offAllNamed(AppRoutes.complete, arguments: {
        'requestId': docSnap.id,
        'convertedFile': data?['convertedFile'],
        'publicUrl': data?['publicUrl'],
        'downloadUrl': data?['downloadUrl'],
      });
      return;
    } else if (status == 'error') {
      Get.back();
      // CommonSnackBar.error(
      //     'Error'.tr, 'An error occurred during conversion.'.tr);
      return;
    }

    // 아직 완료/에러가 아니면 실시간 구독 시작
    docRef.snapshots().listen((doc) {
      if (!doc.exists) return;
      final data = doc.data();
      final status = data?['status'];
      final newProgress = data?['progress'] ?? 0;

      // 진행률 업데이트
      if (newProgress != progress.value) {
        progress.value = newProgress;
      }

      if (status == 'completed') {
        Get.offAllNamed(AppRoutes.complete, arguments: {
          'requestId': doc.id,
          'convertedFile': data?['convertedFile'],
          'publicUrl': data?['publicUrl'],
          'downloadUrl': data?['downloadUrl'],
        });
      } else if (status == 'error') {
        Get.back();
        // CommonSnackBar.error(
        //     'Error'.tr, 'An error occurred during conversion.'.tr);
      }
    }, onError: (e) {
      // Firestore listen 오류 처리
    });
  }
}
