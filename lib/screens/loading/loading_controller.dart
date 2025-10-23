import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  
  // 광고 표시 간격 관련 상수
  static const int _adIntervalMinutes = 10;
  static const String _lastAdTimeKey = 'last_interstitial_ad_time';

  @override
  void onInit() {
    super.onInit();
    print('LoadingController onInit() 호출됨');

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
    
    // 광고 생성은 onReady()에서만 수행
  }

  @override
  void onReady() {
    super.onReady();
    print('LoadingController onReady() 호출됨');
    
    final args = Get.arguments as Map<String, dynamic>?;
    final requestId = args?['requestId'] as String?;
    
    if (requestId != null) {
      print('requestId: $requestId');
      // InterstitialAd 표시를 비동기적으로 시작 (다른 작업과 동시 진행)
      listenToConvertRequest(requestId);
    }
    
    // InterstitialAd 생성 (로드 완료 시 자동으로 표시)
    _createInterstitialAd();
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }

  void cancelConversion() {
    isCancelled.value = true;
    Get.offAllNamed(AppRoutes.fileSelect);
  }

  // 마지막 광고 표시 시간을 저장하는 메서드
  Future<void> _saveLastAdTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastAdTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  // 마지막 광고 표시 시간을 확인하는 메서드
  Future<bool> _canShowAd() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAdTime = prefs.getInt(_lastAdTimeKey);
    
    if (lastAdTime == null) {
      // 처음 광고를 표시하는 경우
      return true;
    }
    
    final now = DateTime.now().millisecondsSinceEpoch;
    final timeDifference = now - lastAdTime;
    final intervalInMilliseconds = _adIntervalMinutes * 60 * 1000;
    
    return timeDifference >= intervalInMilliseconds;
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
    // 기존 광고가 있으면 먼저 정리
    if (_interstitialAd != null) {
      _interstitialAd!.dispose();
      _interstitialAd = null;
    }
    
    // 이미 로딩 중이면 중복 생성 방지
    if (_numInterstitialLoadAttempts > 0) {
      print('InterstitialAd is already being loaded, skipping...');
      return;
    }
    
    InterstitialAd.load(
      adUnitId: testAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('InterstitialAd loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
          
          // 광고가 로드되면 자동으로 표시
          _showInterstitialAd();
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
    print('showInterstitialAd');
    
    // 10분 간격 체크
    final canShow = await _canShowAd();
    if (!canShow) {
      print('광고 표시 간격이 10분을 채우지 않아 광고를 표시하지 않습니다.');
      return;
    }

    print('InterstitialAd: $_interstitialAd');

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('ad onAdShowedFullScreenContent.');
        // 광고가 표시되면 시간을 저장
        _saveLastAdTime();
      },
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
