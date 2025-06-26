import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../file_select/widgets/video_trim_widget.dart';

class VideoTrimScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final filePath = arguments['filePath'] as String;
    final fileName = arguments['fileName'] as String;

    return VideoTrimWidget(
      filePath: filePath,
      fileName: fileName,
      onTrimComplete: (String trimmedFilePath) {
        // trim 완료 시 파일 경로를 결과로 반환
        Get.back(result: trimmedFilePath);
      },
      onCancel: () {
        // 취소 시 null 반환
        Get.back(result: null);
      },
    );
  }
}
