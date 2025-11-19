import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../services/in_app_purchase_service.dart';

class PremiumPromoModal extends StatefulWidget {
  const PremiumPromoModal({super.key});

  @override
  State<PremiumPromoModal> createState() => _PremiumPromoModalState();
}

class _PremiumPromoModalState extends State<PremiumPromoModal> {
  final InAppPurchaseService _purchaseService = InAppPurchaseService();
  bool _isLoading = false;
  bool _isProductLoading = true;
  String? _productPrice;
  bool _isPremium = false;
  StreamSubscription<bool>? _premiumSubscription;

  @override
  void initState() {
    super.initState();
    // Reactive 상태로 초기화
    _isPremium = _purchaseService.isPremium.value;
    _loadProductInfo();

    // Reactive 상태 관찰
    _premiumSubscription = _purchaseService.isPremium.listen((isPremium) {
      if (mounted) {
        setState(() {
          _isPremium = isPremium;
        });
      }
    });
  }

  @override
  void dispose() {
    _premiumSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadProductInfo() async {
    if (!mounted) return;

    setState(() {
      _isProductLoading = true;
    });

    try {
      final success = await _purchaseService.loadProducts();

      if (!mounted) return;

      if (success) {
        final product = _purchaseService.getProductDetails();
        if (product != null) {
          setState(() {
            _productPrice = product.price;
            _isProductLoading = false;
          });
        } else {
          // 상품 정보를 찾을 수 없는 경우
          if (mounted) {
            setState(() {
              _isProductLoading = false;
            });
            debugPrint('Product details not found after successful load');
          }
        }
      } else {
        // 로드 실패 시 재시도 (최대 2번)
        await _retryLoadProductInfo();
      }
    } catch (e) {
      debugPrint('Error in _loadProductInfo: $e');
      if (mounted) {
        setState(() {
          _isProductLoading = false;
        });
      }
    }
  }

  Future<void> _retryLoadProductInfo({int retryCount = 0}) async {
    if (retryCount >= 2) {
      // 재시도 실패 시 로딩 상태 해제하고 사용자에게 알림
      if (mounted) {
        setState(() {
          _isProductLoading = false;
        });
        // 상품 정보를 찾을 수 없는 경우에도 구독 시도 가능하도록 함
        debugPrint(
            'Failed to load product info after retries. User can still try to subscribe.');
      }
      return;
    }

    // 2초 대기 후 재시도
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final success = await _purchaseService.loadProducts();

    if (!mounted) return;

    if (success) {
      final product = _purchaseService.getProductDetails();
      if (product != null) {
        setState(() {
          _productPrice = product.price;
          _isProductLoading = false;
        });
      } else {
        // 재시도
        await _retryLoadProductInfo(retryCount: retryCount + 1);
      }
    } else {
      // 재시도
      await _retryLoadProductInfo(retryCount: retryCount + 1);
    }
  }

  Future<void> _handlePurchase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _purchaseService.buyProduct();

      if (success) {
        // 구독 성공
        if (mounted) {
          Navigator.of(context).pop();
          Get.snackbar(
            'premium_subscribe_success'.tr,
            'premium_subscribe_success_message'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        // 구독 실패
        if (mounted) {
          Get.snackbar(
            'premium_subscribe_failed'.tr,
            'premium_subscribe_failed_message'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'premium_subscribe_error'.tr,
          'premium_subscribe_error_message'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 드래그 핸들
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 제목
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'premium_upgrade_title'.tr,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        if (_isPremium)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '이미 프리미엄 회원입니다',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // 혜택 목록
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBenefitItem(
                    Icons.block,
                    'premium_benefit_remove_ads_title'.tr,
                    'premium_benefit_remove_ads_desc'.tr,
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.file_upload,
                    'premium_benefit_upload_capacity_title'.tr,
                    'premium_benefit_upload_capacity_desc'.tr,
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.dns,
                    'premium_benefit_server_title'.tr,
                    'premium_benefit_server_desc'.tr,
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.speed,
                    'premium_benefit_priority_title'.tr,
                    'premium_benefit_priority_desc'.tr,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 구매 버튼 (프리미엄 회원이 아닐 때만 표시)
            if (!_isPremium)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_isLoading ||
                            _isProductLoading ||
                            _productPrice == null)
                        ? null
                        : _handlePurchase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : _isProductLoading
                            ? Text(
                                'premium_product_loading'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : _productPrice == null
                                ? Text(
                                    'premium_subscribe_button'.tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  )
                                : Text(
                                    'premium_subscribe_button_with_price'
                                        .tr
                                        .replaceAll('@price', _productPrice!),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                  ),
                ),
              ),

            // 복원 버튼 (프리미엄 회원이 아닐 때만 표시)
            if (!_isPremium)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          final success =
                              await _purchaseService.restorePurchases();

                          if (mounted) {
                            if (success) {
                              final isPremium =
                                  await _purchaseService.isPremiumUser();
                              if (isPremium) {
                                Navigator.of(context).pop();
                                Get.snackbar(
                                  'premium_restore_success'.tr,
                                  'premium_restore_success_message'.tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                );
                              } else {
                                Get.snackbar(
                                  'premium_restore_failed'.tr,
                                  'premium_restore_failed_message'.tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            } else {
                              Get.snackbar(
                                'premium_subscribe_error'.tr,
                                'premium_restore_error_message'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                            }

                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                  child: Text(
                    'premium_restore_button'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4CAF50), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
