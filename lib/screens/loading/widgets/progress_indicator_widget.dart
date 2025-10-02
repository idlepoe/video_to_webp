import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../loading_controller.dart';

class ProgressIndicatorWidget extends GetView<LoadingController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        shape: BoxShape.circle,
      ),
      child: Obx(() => Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: controller.progress.value / 100,
                  strokeWidth: 6,
                  backgroundColor: Color(0xFFE9ECEF),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF3182F6),
                  ),
                ),
              ),
              Text(
                '${controller.progress.value}%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191F28),
                ),
              ),
            ],
          )),
    );
  }
}
