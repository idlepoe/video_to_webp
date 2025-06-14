import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/convert_request.dart';

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

  Future<void> uploadAndRequestConvert({
    required ConvertOptions options,
  }) async {
    final user = FirebaseAuth.instance.currentUser ?? await FirebaseAuth.instance.signInAnonymously().then((c) => c.user);
    if (videoFile.value == null) return;
    final file = File(videoFile.value!.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${videoFile.value!.name}';
    final storageRef = FirebaseStorage.instance.ref().child('original/$fileName');
    final uploadTask = await storageRef.putFile(file);
    final uploadedPath = uploadTask.ref.fullPath;
    final now = DateTime.now();
    final request = ConvertRequest(
      userId: user!.uid,
      originalFile: uploadedPath,
      status: 'pending',
      options: options,
      createdAt: now,
    );
    await FirebaseFirestore.instance.collection('convertRequests').add({
      'userId': request.userId,
      'originalFile': request.originalFile,
      'status': request.status,
      'options': {
        'format': request.options.format,
        'quality': request.options.quality,
        'fps': request.options.fps,
        'resolution': request.options.resolution,
      },
      'createdAt': now.toIso8601String(),
    });
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