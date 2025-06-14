import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        print('익명 로그인 시도');
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        currentUser = userCredential.user;
        print('익명 로그인 성공: ${currentUser?.uid}');
      } else {
        print('이미 로그인된 사용자: ${currentUser.uid}');
      }

      // 로딩 완료 후 파일 선택 화면으로 이동
      // await Future.delayed(const Duration(seconds: 2));
      _isLoading.value = false;
      Get.offAllNamed(AppRoutes.fileSelect);
    } catch (e) {
      print('초기화 중 오류 발생: $e');
      _isLoading.value = false;
      // 오류 발생 시에도 파일 선택 화면으로 이동
      Get.offAllNamed(AppRoutes.fileSelect);
    }
  }
} 