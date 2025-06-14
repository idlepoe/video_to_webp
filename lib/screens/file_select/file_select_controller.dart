import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class FileSelectController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> videoFile = Rx<XFile?>(null);
  Rx<VideoPlayerController?> videoPlayerController = Rx<VideoPlayerController?>(null);
  Rx<Duration?> videoDuration = Rx<Duration?>(null);
  Rx<int?> videoWidth = Rx<int?>(null);
  Rx<int?> videoHeight = Rx<int?>(null);

  Future<void> pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videoFile.value = pickedFile;
      await _initVideoPlayer(pickedFile);
    }
  }

  Future<void> _initVideoPlayer(XFile file) async {
    videoPlayerController.value?.dispose();
    final controller = VideoPlayerController.file(
      File(file.path),
    );
    await controller.initialize();
    videoPlayerController.value = controller;
    videoDuration.value = controller.value.duration;
    videoWidth.value = controller.value.size.width.toInt();
    videoHeight.value = controller.value.size.height.toInt();
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }
} 