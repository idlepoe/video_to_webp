import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _signInAnonymously();
  }

  Future<void> _signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      Get.offAllNamed(AppRoutes.fileSelect);
    } catch (e) {
      print('익명 로그인 실패: $e');
      // 에러 처리 로직 추가 가능
    } finally {
      isLoading.value = false;
    }
  }
} 