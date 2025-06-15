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
                                final maxImageHeight = MediaQuery.of(context).size.height * 0.5;
                                return SizedBox(
                                  width: double.infinity,
                                  height: maxImageHeight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      controller.imageUrl.value,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Text('이미지 로드 실패'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          SizedBox(height: 32),
                          Text('Conversion is complete!'.tr, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                // 하단 고정 버튼
                Container(
                  padding: EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => Get.offAllNamed('/'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.grey[100],
                              foregroundColor: Colors.black,
                              elevation: 0,
                            ),
                            child: Text('Home'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: controller.isDownloading.value ? null : controller.downloadFile,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                            ),
                            child: Text('Download'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // 다운로드 진행률 오버레이
            if (controller.isDownloading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              value: controller.downloadProgress.value,
                              strokeWidth: 6,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          Text(
                            '${(controller.downloadProgress.value * 100).toStringAsFixed(0)}%',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Downloading...'.tr,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
} 