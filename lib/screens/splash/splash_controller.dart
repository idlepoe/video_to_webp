import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 현재 로그인된 사용자 확인
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        // 익명 로그인 시도
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        currentUser = userCredential.user;
      }

      // 개인정보 동의 여부 확인
      final prefs = await SharedPreferences.getInstance();
      final privacyConsentGiven =
          prefs.getBool('privacy_consent_given') ?? false;

      // 로딩 완료 후 적절한 화면으로 이동
      _isLoading.value = false;

      if (privacyConsentGiven) {
        // 이미 동의한 경우 파일 선택 화면으로
        Get.offAllNamed(AppRoutes.fileSelect);
      } else {
        // 동의하지 않은 경우 개인정보 동의 화면으로
        Get.offAllNamed(AppRoutes.privacy);
      }
    } catch (e) {
      _isLoading.value = false;
      // 오류 발생 시 개인정보 동의 화면으로 이동
      Get.offAllNamed(AppRoutes.privacy);
    }
  }
}
