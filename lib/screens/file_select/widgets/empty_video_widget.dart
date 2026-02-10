import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../file_select_controller.dart';
import '../../../services/in_app_purchase_service.dart';

class EmptyVideoWidget extends StatelessWidget {
  final VoidCallback onPickVideo;

  const EmptyVideoWidget({
    Key? key,
    required this.onPickVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FileSelectController controller = Get.find<FileSelectController>();

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: GestureDetector(
                onTap: onPickVideo,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.blue.withOpacity(0.3), width: 2),
                    color: Colors.blue.withOpacity(0.05),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.video_library_outlined,
                        color: Colors.blue,
                        size: 36,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'file_select_prompt'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'tap_to_select'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
          child: Column(
            children: [
              // Media scan 안내 및 버튼
              ...[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.refresh, color: Colors.orange, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'media_scan_title'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        'media_scan_info'.tr,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange[700],
                          height: 1.3,
                        ),
                      ),
                      // 미디어 스캔 진행 상황 표시
                      Obx(() {
                        if (controller.isMediaScanning.value) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              // 진행 상황 텍스트
                              Text(
                                controller.mediaScanStatus.value,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 6),
                              // Progress Bar
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: controller.mediaScanProgress.value,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.orange[700]!,
                                    ),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3),
                              // 진행률 텍스트
                              Text(
                                '${controller.mediaScanCurrent.value}/${controller.mediaScanTotal.value}',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.orange[600],
                                ),
                              ),
                            ],
                          );
                        } else if (controller
                            .mediaScanStatus.value.isNotEmpty) {
                          // 스캔 완료 또는 오류 상태 표시
                          return Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              controller.mediaScanStatus.value,
                              style: TextStyle(
                                fontSize: 10,
                                color: controller.mediaScanStatus.value
                                        .contains('complete'.tr)
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // 스캔 옵션 선택 버튼
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: Obx(() => OutlinedButton.icon(
                              onPressed: controller.isMediaScanning.value
                                  ? null
                                  : () => controller.showScanOptionsDialog(),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: controller.isMediaScanning.value
                                      ? Colors.orange.withOpacity(0.3)
                                      : Colors.orange,
                                ),
                                foregroundColor:
                                    controller.isMediaScanning.value
                                        ? Colors.orange.withOpacity(0.3)
                                        : Colors.orange,
                              ),
                              icon: Icon(Icons.tune, size: 16),
                              label: Text(
                                'scan_options'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: Obx(() => OutlinedButton.icon(
                              onPressed: controller.isMediaScanning.value
                                  ? null
                                  : () =>
                                      controller.executeSelectedScanOption(),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: controller.isMediaScanning.value
                                      ? Colors.orange.withOpacity(0.3)
                                      : Colors.orange,
                                ),
                                foregroundColor:
                                    controller.isMediaScanning.value
                                        ? Colors.orange.withOpacity(0.3)
                                        : Colors.orange,
                              ),
                              icon: controller.isMediaScanning.value
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.orange.withOpacity(0.3),
                                        ),
                                      ),
                                    )
                                  : Icon(Icons.refresh, size: 16),
                              label: Text(
                                controller.isMediaScanning.value
                                    ? 'scanning_in_progress'.tr
                                    : controller.selectedScanOption.value,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
              // 개인정보 보호 안내
              Obx(() {
                final purchaseService = InAppPurchaseService();
                final isPremium = purchaseService.isPremium.value;

                // 프리미엄 색상 (골드/앰버)
                final premiumColor = Colors.amber;
                final normalColor = Colors.blue;

                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isPremium
                        ? premiumColor.withOpacity(0.1)
                        : normalColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isPremium
                          ? premiumColor.withOpacity(0.3)
                          : normalColor.withOpacity(0.2),
                      width: isPremium ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isPremium ? Icons.star : Icons.security,
                            color: isPremium ? premiumColor : normalColor,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'privacy_file_limits'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isPremium
                                    ? premiumColor[700]
                                    : normalColor[700],
                              ),
                            ),
                          ),
                          if (isPremium)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: premiumColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'PREMIUM',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        isPremium
                            ? 'file_limit_info_premium'.tr
                            : 'file_limit_info'.tr,
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              isPremium ? premiumColor[700] : normalColor[700],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: onPickVideo,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Text(
                    'select_video'.tr,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
