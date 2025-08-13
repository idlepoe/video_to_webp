import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../file_select_controller.dart';

class EmptyVideoWidget extends StatelessWidget {
  final VoidCallback onPickVideo;
  final VoidCallback? onMediaScan; // Media scan 콜백 추가

  const EmptyVideoWidget({
    Key? key,
    required this.onPickVideo,
    this.onMediaScan, // Media scan 콜백 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FileSelectController controller = Get.find<FileSelectController>();

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Center(
              child: GestureDetector(
                onTap: onPickVideo,
                child: Container(
                  padding: EdgeInsets.all(16),
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
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'file_select_prompt'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'tap_to_select'.tr,
                        style: TextStyle(
                          fontSize: 14,
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
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: Column(
            children: [
              // Media scan 안내 및 버튼
              if (onMediaScan != null) ...[
                Container(
                  padding: EdgeInsets.all(12),
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
                          Icon(Icons.refresh, color: Colors.orange, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'media_scan_title'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'media_scan_info'.tr,
                        style: TextStyle(
                          fontSize: 12,
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
                              SizedBox(height: 12),
                              // 진행 상황 텍스트
                              Text(
                                controller.mediaScanStatus.value,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Progress Bar
                              LinearProgressIndicator(
                                value: controller.mediaScanProgress.value,
                                backgroundColor: Colors.orange.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.orange[700]!,
                                ),
                                minHeight: 6,
                              ),
                              SizedBox(height: 4),
                              // 진행률 텍스트
                              Text(
                                '${controller.mediaScanCurrent.value}/${controller.mediaScanTotal.value}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange[600],
                                ),
                              ),
                            ],
                          );
                        } else if (controller
                            .mediaScanStatus.value.isNotEmpty) {
                          // 스캔 완료 또는 오류 상태 표시
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              controller.mediaScanStatus.value,
                              style: TextStyle(
                                fontSize: 11,
                                color: controller.mediaScanStatus.value
                                        .contains('완료')
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
                SizedBox(height: 12),
                // 스캔 옵션 선택 버튼
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
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
                              icon: Icon(Icons.tune, size: 20),
                              label: Text(
                                '스캔 옵션',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: Obx(() => OutlinedButton.icon(
                              onPressed: controller.isMediaScanning.value
                                  ? null
                                  : onMediaScan,
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
                                  : Icon(Icons.refresh, size: 20),
                              label: Text(
                                controller.isMediaScanning.value
                                    ? '스캔 중...'
                                    : '빠른 스캔',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
              // 개인정보 보호 안내
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: Colors.blue, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'privacy_file_limits'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'file_limit_info'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onPickVideo,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Text(
                    'select_video'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
