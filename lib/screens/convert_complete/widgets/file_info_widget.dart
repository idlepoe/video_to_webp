import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../convert_complete_controller.dart';

class FileInfoWidget extends StatelessWidget {
  final ConvertCompleteController controller;

  const FileInfoWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.fileSize.value <= 0) {
      return SizedBox.shrink();
    }

    return Container(
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
                controller.formatFileSize(controller.fileSize.value),
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
    );
  }
}
