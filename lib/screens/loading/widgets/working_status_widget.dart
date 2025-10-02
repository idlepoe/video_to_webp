import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../loading_controller.dart';

class WorkingStatusWidget extends GetView<LoadingController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.progress.value < 99) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF0F6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xFF3182F6),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'still_working'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3182F6),
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }
}
