import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../models/convert_request.dart';
import '../../routes/app_routes.dart';
import '../loading/loading_controller.dart';
import '../video_trim/video_trim_screen.dart';
import '../../widgets/common_snackbar.dart';

class FileSelectController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final Rx<XFile?> videoFile = Rx<XFile?>(null);
  final Rx<XFile?> originalVideoFile = Rx<XFile?>(null); // 원본 파일 보존
  final Rx<VideoPlayerController?> videoPlayerController =
      Rx<VideoPlayerController?>(null);
  final Rx<Duration> videoDuration = Duration.zero.obs;
  final RxInt videoWidth = 0.obs;
  final RxInt videoHeight = 0.obs;
  final RxBool isInitialized = false.obs;
  final RxDouble uploadPercent = 0.0.obs;
  final RxBool isUploading = false.obs;
  final RxBool isTrimmed = false.obs; // Trim 여부 추적

  // Trim 설정 (서버사이드 호환성을 위해 유지)
  final RxDouble trimStartTime = 0.0.obs;
  final Rx<double?> trimEndTime = Rx<double?>(null);

  @override
  void onReady() {
    super.onReady();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      final auth = FirebaseAuth.instance;

      if (auth.currentUser == null) {
        final userCredential = await auth.signInAnonymously();
      }

      isInitialized.value = true;
    } catch (e) {
      CommonSnackBar.error('Error'.tr, 'Initialization failed.'.tr);
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        videoFile.value = file;
        originalVideoFile.value = file; // 원본 파일 저장
        isTrimmed.value = false; // Trim 상태 초기화
        await _initVideoPlayer(file);
      }
    } catch (e) {
      CommonSnackBar.error(
          'error'.tr, 'An error occurred while selecting the video.'.tr);
    }
  }

  Future<void> _initVideoPlayer(XFile file) async {
    try {
      videoPlayerController.value?.dispose();
      final controller = VideoPlayerController.file(File(file.path));
      await controller.initialize();
      videoPlayerController.value = controller;
      videoDuration.value = controller.value.duration;
      videoWidth.value = controller.value.size.width.toInt();
      videoHeight.value = controller.value.size.height.toInt();
    } catch (e) {
      // 비디오 플레이어 초기화 오류 처리
    }
  }

  // Trim 설정 업데이트 (서버사이드 호환성을 위해 유지하지만 사용되지 않음)
  void updateTrimSettings(double startTime, double? endTime) {
    trimStartTime.value = startTime;
    trimEndTime.value = endTime;
  }

  // Trim 화면으로 이동
  void openTrimScreen() async {
    if (videoFile.value == null) {
      CommonSnackBar.error('error'.tr, 'select_file_error'.tr);
      return;
    }

    // Trim 화면으로 네비게이션 (Get.to 사용하여 기존 컨트롤러 유지)
    final result = await Get.to(
      () => VideoTrimScreen(),
      arguments: {
        'filePath': videoFile.value!.path,
        'fileName': videoFile.value!.name,
      },
    );

    if (result != null && result is String) {
      // Trim된 파일로 교체
      final trimmedFile = XFile(result);
      videoFile.value = trimmedFile;
      isTrimmed.value = true; // Trim 상태 업데이트
      await _initVideoPlayer(trimmedFile);

      CommonSnackBar.success('success'.tr, 'trim_applied_message'.tr);
    }
  }

  // 원본으로 되돌리기
  Future<void> restoreOriginal() async {
    if (originalVideoFile.value == null) {
      CommonSnackBar.error('error'.tr, 'no_original_file'.tr);
      return;
    }

    try {
      videoFile.value = originalVideoFile.value;
      isTrimmed.value = false;
      await _initVideoPlayer(originalVideoFile.value!);
      CommonSnackBar.success('success'.tr, 'original_restored'.tr);
    } catch (e) {
      CommonSnackBar.error('error'.tr, 'restore_error'.tr);
    }
  }

  // 업로드 전 파일 크기 확인
  bool validateFileSize(String filePath) {
    final fileSize = File(filePath).lengthSync();
    final fileSizeMB = fileSize / (1024 * 1024);

    if (fileSizeMB > 20) {
      CommonSnackBar.error('error'.tr, 'file_size_error'.tr);
      return false;
    }
    return true;
  }

  Future<void> uploadAndRequestConvert(ConvertOptions options) async {
    if (!isInitialized.value) {
      CommonSnackBar.error('error'.tr, 'initialization_error'.tr);
      return;
    }

    if (videoFile.value == null) {
      CommonSnackBar.error('error'.tr, 'select_file_error'.tr);
      return;
    }

    // 업로드 직전 파일 크기 확인
    if (!validateFileSize(videoFile.value!.path)) {
      return;
    }

    try {
      isUploading.value = true;
      uploadPercent.value = 0.0;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        CommonSnackBar.error('error'.tr, 'login_required'.tr);
        isUploading.value = false;
        return;
      }

      final requestRef =
          FirebaseFirestore.instance.collection('convertRequests').doc();
      final requestId = requestRef.id;
      final originalFilePath = 'original/${user.uid}/$requestId.mp4';
      await requestRef.set({
        'userId': user.uid,
        'status': 'pending',
        'options': options.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'originalFile': originalFilePath,
      });

      // LoadingController를 find로 가져와 구독 시작
      final loadingController = Get.find<LoadingController>();
      loadingController.listenToConvertRequest(requestId);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('original')
          .child(user.uid)
          .child('$requestId.mp4');

      bool updated = false;
      storageRef
          .putFile(
            File(videoFile.value!.path),
            SettableMetadata(
              contentType: 'video/mp4',
              customMetadata: {
                'uploadedAt': DateTime.now().toIso8601String(),
              },
            ),
          )
          .snapshotEvents
          .listen((TaskSnapshot snapshot) async {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        uploadPercent.value = progress;
        if (progress >= 1.0 && !updated) {
          updated = true;
          isUploading.value = false;
          uploadPercent.value = 0.0;
          // 다이얼로그 닫고 로딩 화면 이동
          if (Get.isDialogOpen ?? false) Get.back();
          await Get.toNamed(AppRoutes.loading,
              arguments: {'requestId': requestId});
        }
      }, onError: (uploadError) {
        isUploading.value = false;
        uploadPercent.value = 0.0;
        CommonSnackBar.error('error'.tr, 'upload_error'.tr,
            duration: Duration(seconds: 5));
      });
    } catch (e, stack) {
      isUploading.value = false;
      uploadPercent.value = 0.0;
      CommonSnackBar.error('error'.tr, 'upload_error'.tr,
          duration: Duration(seconds: 5));
    }
  }

  // 설정 저장
  Future<void> saveConvertSettings({
    required int selectedResolution,
    required double fps,
    required double quality,
    required String format,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('convert_resolution', selectedResolution);
      await prefs.setDouble('convert_fps', fps);
      await prefs.setDouble('convert_quality', quality);
      await prefs.setString('convert_format', format);
    } catch (e) {
      // 변환 설정 저장 중 오류 처리
    }
  }

  // 설정 불러오기
  Future<Map<String, dynamic>> loadConvertSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 첫 사용인지 확인 (해상도 설정이 저장되어 있지 않으면 첫 사용)
      final isFirstUse = !prefs.containsKey('convert_resolution');

      return {
        'selectedResolution': prefs.getInt('convert_resolution') ??
            (isFirstUse ? -1 : 0), // -1은 480p 찾기 신호
        'fps': prefs.getDouble('convert_fps') ?? 30.0,
        'quality': prefs.getDouble('convert_quality') ?? 75.0,
        'format': prefs.getString('convert_format') ?? 'webp',
        'isFirstUse': isFirstUse,
      };
    } catch (e) {
      return {
        'selectedResolution': -1, // 첫 사용으로 간주하여 480p 찾기
        'fps': 30.0,
        'quality': 75.0,
        'format': 'webp',
        'isFirstUse': true,
      };
    }
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }
}
