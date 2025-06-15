import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loading_controller.dart';

class LoadingScreen extends GetView<LoadingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Converting...'.tr)),
      body: Center(
        child: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: controller.progress.value / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3182F6)),
                  ),
                ),
                Text(
                  '${controller.progress.value}%',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text('Converting...'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('The progress bar is an estimate. Actual conversion speed may vary.'.tr, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            SizedBox(height: 12),
            if (controller.progress.value < 99)
              Text('Still working hard on your video! 🚀'.tr, style: TextStyle(fontSize: 14, color: Colors.blue)),
          ],
        )),
      ),
    );
  }
} 