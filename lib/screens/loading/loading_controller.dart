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
    _listenToConversionStatus();
  }

  void _listenToConversionStatus() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore
        .collection('users')
        .doc(userId)
        .collection('convertRequests')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) return;

      final doc = snapshot.docs.first;
      final status = doc.data()['status'] as String;

      if (status == 'completed' && !isCancelled.value) {
        Get.offAllNamed(AppRoutes.complete);
      } else if (status == 'error' && !isCancelled.value) {
        Get.back();
        Get.snackbar(
          '오류',
          '변환 중 오류가 발생했습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  void cancelConversion() {
    isCancelled.value = true;
    Get.back();
  }
} 