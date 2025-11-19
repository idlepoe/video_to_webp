import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InAppPurchaseService {
  static const String premiumProductId = 'premium_remove_ads';
  static const String _isPremiumUserKey = 'is_premium_user';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  Completer<bool>? _purchaseUpdateCompleter;

  // 싱글톤 패턴
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  /// 초기화 및 구매 업데이트 리스너 설정
  Future<void> initialize() async {
    _isAvailable = await _inAppPurchase.isAvailable();

    if (!_isAvailable) {
      debugPrint('In-App Purchase is not available');
      return;
    }

    // 구매 업데이트 리스너
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => debugPrint('Purchase stream error: $error'),
    );

    // 기존 구매 복원 확인
    await restorePurchases();
  }

  /// 상품 정보 로드
  Future<bool> loadProducts() async {
    if (!_isAvailable) {
      debugPrint('In-App Purchase is not available');
      return false;
    }

    try {
      final Set<String> productIds = {premiumProductId};
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(productIds);

      if (response.error != null) {
        debugPrint('Error loading products: ${response.error}');
        return false;
      }

      if (response.productDetails.isEmpty) {
        debugPrint('No products found');
        return false;
      }

      _products = response.productDetails;
      return true;
    } catch (e) {
      debugPrint('Error loading products: $e');
      return false;
    }
  }

  /// 상품 정보 가져오기
  ProductDetails? getProductDetails() {
    if (_products.isEmpty) return null;
    return _products.firstWhere(
      (product) => product.id == premiumProductId,
      orElse: () => _products.first,
    );
  }

  /// 구매 처리 (구독 상품)
  Future<bool> buyProduct() async {
    if (!_isAvailable) {
      debugPrint('In-App Purchase is not available');
      return false;
    }

    final productDetails = getProductDetails();
    if (productDetails == null) {
      debugPrint('Product not found');
      return false;
    }

    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      // 새로운 Completer 생성
      _purchaseUpdateCompleter = Completer<bool>();

      // 구독 상품은 buyNonConsumable로 처리 (Android에서는 구독도 이 메서드 사용)
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!success) {
        debugPrint('Purchase failed to initiate');
        _purchaseUpdateCompleter = null;
        return false;
      }

      // 구매 완료 대기
      return await _purchaseUpdateCompleter!.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('Purchase timeout');
          _purchaseUpdateCompleter = null;
          return false;
        },
      );
    } catch (e) {
      debugPrint('Error buying product: $e');
      return false;
    }
  }

  /// 구매 업데이트 처리
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID != premiumProductId) {
        continue; // 프리미엄 상품이 아니면 무시
      }

      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint('Purchase pending: ${purchaseDetails.productID}');
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchaseDetails.error}');

        // 구독 취소나 만료의 경우 프리미엄 상태를 false로 설정
        // (실제로는 구독 취소 시에도 purchased 상태가 올 수 있으므로
        //  구독 만료는 별도로 확인해야 하지만, 여기서는 에러 시 비활성화)
        await _savePremiumStatus(false);

        if (_purchaseUpdateCompleter != null &&
            !_purchaseUpdateCompleter!.isCompleted) {
          _purchaseUpdateCompleter!.complete(false);
          _purchaseUpdateCompleter = null;
        }
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // 구매 완료 또는 복원
        // 정기 결제의 경우, 구독이 활성화되어 있으면 purchased 상태가 됩니다
        await _savePremiumStatus(true);
        debugPrint('Premium subscription active: ${purchaseDetails.productID}');

        // 구매 완료 처리
        if (_purchaseUpdateCompleter != null &&
            !_purchaseUpdateCompleter!.isCompleted) {
          _purchaseUpdateCompleter!.complete(true);
          _purchaseUpdateCompleter = null;
        }

        // 구매 완료 확인
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// 구매 복원
  Future<bool> restorePurchases() async {
    if (!_isAvailable) {
      debugPrint('In-App Purchase is not available');
      return false;
    }

    try {
      await _inAppPurchase.restorePurchases();
      // restorePurchases는 구매 스트림을 통해 결과를 반환하므로
      // _onPurchaseUpdate에서 처리됨
      return true;
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
      return false;
    }
  }

  /// 프리미엄 상태 저장
  Future<void> _savePremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPremiumUserKey, isPremium);
  }

  /// 프리미엄 사용자 여부 확인
  /// 실제 구매 내역을 확인하여 정확한 상태를 반환합니다
  Future<bool> isPremiumUser() async {
    if (!_isAvailable) {
      // 인앱 결제를 사용할 수 없는 경우 SharedPreferences만 확인
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isPremiumUserKey) ?? false;
    }

    try {
      // 최신 구매 상태 확인을 위해 restorePurchases 호출
      // 이는 구매 스트림을 통해 최신 상태를 받아옵니다
      await _inAppPurchase.restorePurchases();

      // 구매 스트림 업데이트를 기다리기 위해 짧은 대기
      await Future.delayed(const Duration(milliseconds: 500));

      // SharedPreferences에서 상태 확인
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isPremiumUserKey) ?? false;
    } catch (e) {
      debugPrint('Error checking premium status: $e');
      // 오류 발생 시 SharedPreferences만 확인
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isPremiumUserKey) ?? false;
    }
  }

  /// 구매 내역을 직접 확인하여 프리미엄 상태 검증
  /// restorePurchases를 호출하고 결과를 기다립니다
  Future<bool> verifyPremiumStatus() async {
    if (!_isAvailable) {
      return false;
    }

    try {
      // 구매 복원을 통해 최신 상태 확인
      bool? verifiedStatus;

      // 일시적으로 구매 업데이트 리스너 추가
      final tempSubscription = _inAppPurchase.purchaseStream.listen(
        (purchaseDetailsList) {
          for (final purchaseDetails in purchaseDetailsList) {
            if (purchaseDetails.productID == premiumProductId) {
              if (purchaseDetails.status == PurchaseStatus.purchased ||
                  purchaseDetails.status == PurchaseStatus.restored) {
                verifiedStatus = true;
              } else if (purchaseDetails.status == PurchaseStatus.error) {
                verifiedStatus = false;
              }
            }
          }
        },
      );

      await _inAppPurchase.restorePurchases();

      // 구매 스트림 업데이트 대기
      await Future.delayed(const Duration(seconds: 2));

      await tempSubscription.cancel();

      if (verifiedStatus != null) {
        await _savePremiumStatus(verifiedStatus!);
        return verifiedStatus!;
      }

      // 구매 내역이 없으면 SharedPreferences 확인
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isPremiumUserKey) ?? false;
    } catch (e) {
      debugPrint('Error verifying premium status: $e');
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isPremiumUserKey) ?? false;
    }
  }

  /// 리소스 정리
  void dispose() {
    _subscription.cancel();
  }
}
