import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'convert_complete_controller.dart';

class ConvertCompleteScreen extends StatelessWidget {
  final controller = Get.put(ConvertCompleteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.offAllNamed('/'),
        ),
        title: Text(
          'conversion_complete'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 메인 타이틀
                    Text(
                      'conversion_complete'.tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF191F28),
                      ),
                    ),

                    SizedBox(height: 8),

                    // 서브 텍스트
                    Text(
                      'file_ready'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7684),
                      ),
                    ),

                    SizedBox(height: 32),

                    // 이미지 미리보기 (고정 높이)
                    if (controller.imageUrl.value.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFFE9ECEF),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            controller.imageUrl.value,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              child: Center(
                                child: Text(
                                  'Image load failed',
                                  style: TextStyle(
                                    color: Color(0xFF6B7684),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: 16),

                    // 파일 정보 표시
                    if (controller.fileSize.value > 0)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8F5E8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF4CAF50),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF4CAF50),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'conversion_success'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'converted_file_size'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                Text(
                                  controller.formatFileSize(
                                      controller.fileSize.value),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1B5E20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 16),

                    // 파일 삭제 안내
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFE9ECEF)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF6C757D),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'file_deletion_details'.tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6C757D),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // 다운로드 상태 표시
                    if (controller.isDownloading.value)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F6FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF3182F6),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'auto_downloading'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3182F6),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (controller.isAlreadyDownloaded.value &&
                        !controller.downloadCompleted.value)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F8F0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Color(0xFF4CAF50),
                              size: 32,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'already_downloaded'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          // 다운로드 버튼들
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 56,
                                  child: ElevatedButton.icon(
                                    onPressed: controller.manualDownload,
                                    icon: Icon(
                                      controller.downloadCompleted.value
                                          ? Icons.download_done
                                          : Icons.download,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      controller.isAlreadyDownloaded.value
                                          ? 're_download'.tr
                                          : controller.downloadCompleted.value
                                              ? 're_download'.tr
                                              : 'download'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: controller
                                                  .isAlreadyDownloaded.value ||
                                              controller.downloadCompleted.value
                                          ? Color(0xFF00C851)
                                          : Color(0xFF3182F6),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  height: 56,
                                  child: OutlinedButton.icon(
                                    onPressed: controller.openInBrowser,
                                    icon: Icon(
                                      Icons.open_in_browser,
                                      size: 20,
                                      color: Color(0xFF6B7684),
                                    ),
                                    label: Text(
                                      'browser'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF6B7684),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Color(0xFFE9ECEF),
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // 하단 고정 버튼
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE9ECEF),
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3182F6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'convert_another'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
