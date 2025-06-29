import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'file_select_controller.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../../models/convert_request.dart';
import '../../routes/app_routes.dart';
import 'widgets/widgets.dart';

class FileSelectScreen extends StatefulWidget {
  @override
  State<FileSelectScreen> createState() => _FileSelectScreenState();
}

class _FileSelectScreenState extends State<FileSelectScreen> {
  final FileSelectController controller = Get.put(FileSelectController());

  @override
  Widget build(BuildContext context) {
    final maxVideoHeight = MediaQuery.of(context).size.height * 0.35;
    return Scaffold(
      appBar: AppBar(title: Text('app_title'.tr)),
      body: Obx(() {
        if (controller.videoFile.value == null) {
          return EmptyVideoWidget(
            onPickVideo: controller.pickVideo,
          );
        } else {
          final videoController = controller.videoPlayerController.value;
          if (videoController == null || !videoController.value.isInitialized) {
            return Center(child: CircularProgressIndicator());
          }

          return SimpleVideoPlayerWidget(
            key: ValueKey(controller.videoFile.value!.path), // 파일 경로를 키로 사용
            videoController: videoController,
            maxVideoHeight: maxVideoHeight,
            fileName: controller.videoFile.value!.name,
            videoWidth: controller.videoWidth.value,
            videoHeight: controller.videoHeight.value,
            videoDuration: controller.videoDuration.value,
            filePath: controller.videoFile.value!.path,
          );
        }
      }),
      bottomNavigationBar: Obx(() {
        if (controller.videoFile.value == null) return SizedBox.shrink();
        return BottomNavigationWidget(
          onPickOtherVideo: controller.pickVideo,
          onConvert: () => _showConvertDialog(context),
          onTrim: controller.openTrimScreen,
          onRestoreOriginal: controller.restoreOriginal,
          showRestoreButton: controller.isTrimmed.value,
        );
      }),
    );
  }

  void _showConvertDialog(BuildContext context) async {
    final originalWidth = controller.videoWidth.value ?? 0;
    final originalHeight = controller.videoHeight.value ?? 0;
    final videoDurationSeconds = controller.videoDuration.value?.inSeconds ?? 0;
    final videoFilePath = controller.videoFile.value!.path;

    // 저장된 설정 불러오기
    final savedSettings = await controller.loadConvertSettings();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Obx(() => ConvertOptionsDialog(
              originalWidth: originalWidth,
              originalHeight: originalHeight,
              videoDurationSeconds: videoDurationSeconds,
              videoFilePath: videoFilePath,
              savedSettings: savedSettings,
              isUploading: controller.isUploading.value,
              uploadPercent: controller.uploadPercent.value,
              onConvert: (options) async {
                controller.uploadAndRequestConvert(options);
              },
            ));
      },
    );
  }
}
