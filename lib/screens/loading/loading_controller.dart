import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../routes/app_routes.dart';
import '../../services/fcm_service.dart';

class LoadingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isCancelled = false.obs;
  final RxInt progress = 0.obs;

  // InterstitialAd 관련 변수들
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;
  static String testAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-4105607341592624/4163285520';

  @override
  void onInit() {
    super.onInit();

    // InterstitialAd 생성
    _createInterstitialAd();

    // FCM 서비스에 현재 화면 알림 (안전하게 처리)
    try {
      if (Get.isRegistered<FCMService>()) {
        final fcmService = Get.find<FCMService>();
        fcmService.updateCurrentScreen('/loading');
      } else {
        print('FCM 서비스가 아직 초기화되지 않았습니다.');
      }
    } catch (e) {
      print('FCM 서비스 접근 오류: $e');
      // FCM 서비스가 없어도 앱은 정상 동작
    }

    final args = Get.arguments as Map<String, dynamic>?;
    final requestId = args?['requestId'] as String?;
    if (requestId != null) {
      // InterstitialAd 표시를 비동기적으로 시작 (다른 작업과 동시 진행)
      _showInterstitialAd();
      listenToConvertRequest(requestId);
    }
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
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
        'fileSize': data?['fileSize'],
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
          'fileSize': data?['fileSize'],
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

  // InterstitialAd 생성 메서드
  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: testAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('InterstitialAd loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  // InterstitialAd 표시 메서드 (비동기)
  Future<void> _showInterstitialAd() async {
    // 광고가 로드될 때까지 최대 5초 대기
    int waitTime = 0;
    while (_interstitialAd == null && waitTime < 5000) {
      await Future.delayed(const Duration(milliseconds: 100));
      waitTime += 100;
    }

    print('InterstitialAd: $_interstitialAd');

    if (_interstitialAd == null) {
      print('Warning: InterstitialAd not loaded within timeout period.');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
