import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'convert_complete_controller.dart';

class ConvertCompleteScreen extends StatelessWidget {
  final controller = Get.put(ConvertCompleteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversion Complete'.tr),
      ),
      body: Obx(() {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.imageUrl.value.isNotEmpty)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final maxImageHeight =
                                    MediaQuery.of(context).size.height * 0.5;
                                return SizedBox(
                                  width: double.infinity,
                                  height: maxImageHeight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      controller.imageUrl.value,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Text('이미지 로드 실패'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          SizedBox(height: 32),
                          Text('Conversion is complete!'.tr,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          if (controller.isDownloading.value)
                            Column(
                              children: [
                                CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                                SizedBox(height: 12),
                                Text('Auto downloading to gallery...'.tr,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue)),
                                SizedBox(height: 16),
                              ],
                            )
                          else
                            Column(
                              children: [
                                Icon(
                                    controller.downloadCompleted.value
                                        ? Icons.check_circle
                                        : Icons.file_download_done,
                                    color: controller.downloadCompleted.value
                                        ? Colors.green
                                        : Colors.blue,
                                    size: 48),
                                SizedBox(height: 12),
                                Text(
                                    controller.downloadCompleted.value
                                        ? 'Downloaded to gallery!'.tr
                                        : 'File is ready for download'.tr,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            controller.downloadCompleted.value
                                                ? Colors.green
                                                : Colors.blue,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 24),
                                // 다운로드 버튼들
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: controller.downloadFile,
                                        icon: Icon(
                                            controller.downloadCompleted.value
                                                ? Icons.download_done
                                                : Icons.download,
                                            size: 20),
                                        label: Text(
                                            controller.downloadCompleted.value
                                                ? 'Re-download'.tr
                                                : 'Download'.tr),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              controller.downloadCompleted.value
                                                  ? Colors.green
                                                  : Colors.blue,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: controller.openInBrowser,
                                        icon: Icon(Icons.open_in_browser,
                                            size: 20),
                                        label: Text('Browser'.tr),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 하단 고정 버튼
                Container(
                  padding: EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Get.offAllNamed('/'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: Text('Convert Another Video'.tr,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
