import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loading_controller.dart';

class LoadingScreen extends StatelessWidget {
  final LoadingController controller = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              '변환 중...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 32),
            TextButton(
              onPressed: controller.cancelConversion,
              child: Text(
                '취소',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 