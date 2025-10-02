import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../convert_complete_controller.dart';

class ImagePreviewWidget extends StatelessWidget {
  final ConvertCompleteController controller;

  const ImagePreviewWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.imageUrl.value.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
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
          errorBuilder: (context, error, stackTrace) => Container(
            child: Center(
              child: Text(
                'image_load_failed'.tr,
                style: TextStyle(
                  color: Color(0xFF6B7684),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
