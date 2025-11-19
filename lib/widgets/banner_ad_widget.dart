import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/in_app_purchase_service.dart';

class BannerAdWidget extends StatefulWidget {
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final AdSize size;

  const BannerAdWidget({
    super.key, 
    this.height, 
    this.margin, 
    this.padding,
    this.size = AdSize.mediumRectangle,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // 광고 단위 ID (디버그 모드에 따라 분기)
  static String get _adUnitId {
    if (kDebugMode) {
      // 디버그 모드: 테스트 광고 ID
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      // 릴리즈 모드: 실제 광고 ID
      return 'ca-app-pub-4105607341592624/7662698404';
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPremiumAndLoadAd();
  }

  Future<void> _checkPremiumAndLoadAd() async {
    final purchaseService = InAppPurchaseService();
    final isPremium = await purchaseService.isPremiumUser();
    
    if (!isPremium) {
      _loadBannerAd();
    } else {
      debugPrint('프리미엄 사용자이므로 배너 광고를 표시하지 않습니다.');
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: widget.size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('BannerAd loaded successfully.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          debugPrint('Ad Unit ID: $_adUnitId');
          debugPrint('Error Code: ${error.code}');
          debugPrint('Error Message: ${error.message}');
          ad.dispose();
        },
        onAdOpened: (ad) {
          debugPrint('BannerAd opened.');
        },
        onAdClosed: (ad) {
          debugPrint('BannerAd closed.');
        },
        onAdImpression: (ad) {
          debugPrint('BannerAd impression.');
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 250,
      margin: widget.margin,
      padding: widget.padding,
      child: _isLoaded && _bannerAd != null
          ? AdWidget(ad: _bannerAd!)
          : const SizedBox.shrink(),
    );
  }
}
