import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadProductInfo();
  }

  Future<void> _loadProductInfo() async {
    setState(() {
      _isProductLoading = true;
    });

    final success = await _purchaseService.loadProducts();
    if (success) {
      final product = _purchaseService.getProductDetails();
      if (product != null) {
        setState(() {
          _productPrice = product.price;
          _isProductLoading = false;
        });
      } else {
        setState(() {
          _isProductLoading = false;
        });
      }
    } else {
      setState(() {
        _isProductLoading = false;
      });
    }
  }

  Future<void> _handlePurchase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _purchaseService.buyProduct();

      if (success) {
        // 구매 성공
        if (mounted) {
          Navigator.of(context).pop();
          Get.snackbar(
            '구매 완료',
            '프리미엄 기능이 활성화되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        // 구매 실패
        if (mounted) {
          Get.snackbar(
            '구매 실패',
            '구매를 완료할 수 없습니다. 다시 시도해주세요.',
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
          '오류',
          '구매 처리 중 오류가 발생했습니다.',
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
                  const Expanded(
                    child: Text(
                      '프리미엄으로 업그레이드',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
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
                    '모든 광고 제거',
                    '전면 광고와 배너 광고가 모두 제거됩니다',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.file_upload,
                    '업로드 용량 확대',
                    '20MB에서 50MB로 업로드 용량이 증가합니다',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.dns,
                    '고성능 서버 사용',
                    '512MiB 서버에서 4096MiB 고성능 서버로 업그레이드',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.speed,
                    '빠른 변환 처리',
                    '변환 요청이 우선적으로 처리됩니다',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 구매 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isLoading || _isProductLoading)
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
                          ? const Text(
                              '상품 정보 로딩 중...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _productPrice != null
                                  ? '$_productPrice에 구매하기'
                                  : '구매하기',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                ),
              ),
            ),

            // 복원 버튼
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
                                '복원 완료',
                                '프리미엄 기능이 복원되었습니다.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                            } else {
                              Get.snackbar(
                                '복원 실패',
                                '복원할 구매 내역이 없습니다.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                            }
                          } else {
                            Get.snackbar(
                              '오류',
                              '구매 복원 중 오류가 발생했습니다.',
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
                child: const Text(
                  '구매 복원',
                  style: TextStyle(
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
