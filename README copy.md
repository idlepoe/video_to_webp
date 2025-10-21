import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_converter/app/routes/app_pages.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';
import '../widgets/video_rotate_screen.dart';
import '../widgets/video_trim_screen.dart';
import '../dialogs/convert_options_dialog.dart';

class SelectVideoController extends GetxController {
  final _picker = ImagePicker();
  final videoFile = Rxn<XFile>();
  final originalVideoFile = Rxn<XFile>();
  final videoPlayerController = Rxn<VideoPlayerController>();
  final isVideoSelected = false.obs;
  final videoInfo = Rxn<Map<String, dynamic>>();
  final isTrimmed = false.obs;
  final videoWidth = Rxn<int>();
  final videoHeight = Rxn<int>();
  final videoDuration = Rxn<Duration>();

  @override
  void onInit() {
    super.onInit();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      // 업데이트 확인
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // 즉시 업데이트 수행
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      // 업데이트 실패 시 로그만 출력 (사용자에게는 알리지 않음)
      print('In-app update failed: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // 비디오 플레이어 컨트롤러 안전하게 dispose
    if (videoPlayerController.value != null) {
      videoPlayerController.value!.dispose();
      videoPlayerController.value = null;
    }
    super.onClose();
  }

  Future<void> _initVideoPlayer(XFile file) async {
    try {
      // 기존 컨트롤러가 있다면 안전하게 dispose
      if (videoPlayerController.value != null) {
        await videoPlayerController.value!.dispose();
        videoPlayerController.value = null;
      }

      final controller = VideoPlayerController.file(File(file.path));
      await controller.initialize();

      // 컨트롤러가 여전히 유효한지 확인
      if (controller.value.isInitialized) {
        videoPlayerController.value = controller;
        videoDuration.value = controller.value.duration;
        videoWidth.value = controller.value.size.width.toInt();
        videoHeight.value = controller.value.size.height.toInt();
        isVideoSelected.value = true;
      } else {
        await controller.dispose();
      }
    } catch (e) {
      // 비디오 플레이어 초기화 오류 처리
      print('Video player initialization error: $e');
      videoPlayerController.value = null;
      isVideoSelected.value = false;
    }
  }

  Future<void> selectOtherVideo() async {
    isVideoSelected.value = false;
    videoFile.value = null;
    originalVideoFile.value = null;

    // 비디오 플레이어 컨트롤러 안전하게 dispose
    if (videoPlayerController.value != null) {
      await videoPlayerController.value!.dispose();
      videoPlayerController.value = null;
    }

    videoInfo.value = null;
    isTrimmed.value = false;
    videoWidth.value = null;
    videoHeight.value = null;
    videoDuration.value = null;
  }

  void openRotateScreen() async {
    if (videoFile.value == null) {
      Get.snackbar('Error', 'Please select a video file first');
      return;
    }

    // 비디오 회전 화면으로 네비게이션
    await Get.to(
      () => VideoRotateScreen(
        filePath: videoFile.value!.path,
        fileName: videoFile.value!.name,
        onRotateComplete: (String rotatedFilePath) {
          // 회전된 파일로 교체
          final rotatedFile = XFile(rotatedFilePath);
          videoFile.value = rotatedFile;
          isTrimmed.value = false; // 회전 후에는 trim 상태 초기화
          _initVideoPlayer(rotatedFile);

          // 성공 메시지
          Get.back(); // 회전 화면 닫기
        },
        onCancel: () {
          Get.back(); // 회전 화면 닫기
        },
      ),
    );
  }

  Future<void> restoreOriginal() async {
    if (originalVideoFile.value == null) {
      Get.snackbar('Error', 'No original file available');
      return;
    }

    try {
      videoFile.value = originalVideoFile.value;
      isTrimmed.value = false;
      await _initVideoPlayer(originalVideoFile.value!);
      Get.snackbar('Success', 'Original video restored');
    } catch (e) {
      Get.snackbar('Error', 'Failed to restore original video');
    }
  }

  Future<void> saveConvertSettings({
    required int selectedResolution,
    required double fps,
    required double quality,
    required String format,
    required double speed,
    required String selectedFormat,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('convert_resolution', selectedResolution);
      await prefs.setDouble('convert_fps', fps);
      await prefs.setDouble('convert_quality', quality);
      await prefs.setString('convert_format', format);
      await prefs.setDouble('convert_speed', speed);
      await prefs.setString('convert_selected_format', selectedFormat);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save convert settings');
    }
  }

  // 설정 불러오기
  Future<Map<String, dynamic>> loadConvertSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return {
        'selectedResolution':
            prefs.getInt('convert_resolution') ?? 0, // 기본값은 원본 해상도
        'fps': prefs.getDouble('convert_fps') ?? 30.0,
        'quality': prefs.getDouble('convert_quality') ?? 75.0,
        'format': prefs.getString('convert_format') ?? 'webp',
        'speed': prefs.getDouble('convert_speed') ?? 1.0,
        'selectedFormat': prefs.getString('convert_selected_format') ?? 'WebP',
      };
    } catch (e) {
      return {
        'selectedResolution': 0, // 기본값은 원본 해상도
        'fps': 30.0,
        'quality': 75.0,
        'format': 'webp',
        'speed': 1.0,
        'selectedFormat': 'WebP',
      };
    }
  }

  // Trim 화면으로 이동
  void openTrimScreen() async {
    if (videoFile.value == null) {
      Get.snackbar('Error', 'Please select a video file first');
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

      Get.snackbar('Success', 'Video trimmed successfully');
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
      // CommonSnackBar.error(
      //     'error'.tr, 'An error occurred while selecting the video.'.tr);
      print('Error picking video: $e');
      isVideoSelected.value = false;
    }
  }

  void convertVideo() {
    if (videoFile.value != null) {
      // 비디오 변환 로직 구현
      Get.snackbar('Success', 'Video conversion started!');
    }
  }

  void showConvertDialog(BuildContext context) async {
    final originalWidth = videoWidth.value ?? 0;
    final originalHeight = videoHeight.value ?? 0;
    final videoDurationSeconds = videoDuration.value?.inSeconds ?? 0;
    final videoFilePath = videoFile.value!.path;

    // 저장된 설정 불러오기
    final savedSettings = await loadConvertSettings();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ConvertOptionsDialog(
          originalWidth: originalWidth,
          originalHeight: originalHeight,
          videoDurationSeconds: videoDurationSeconds,
          videoFilePath: videoFilePath,
          savedSettings: savedSettings,
          onConvert: (options) async {
            print('--------------------options: $options');
            await handleConvert(options);
          },
        );
      },
    );
  }

  Future<void> handleConvert(Map<String, dynamic> options) async {
    try {
      // 비디오 플레이어가 재생 중이라면 중지
      if (videoPlayerController.value != null && 
          videoPlayerController.value!.value.isPlaying) {
        await videoPlayerController.value!.pause();
      }

      // 변환 설정 저장
      await saveConvertSettings(
        selectedResolution: options['selectedResolution'],
        fps: options['fps'],
        quality: options['quality'],
        format: options['format'],
        speed: options['speed'],
        selectedFormat: options['selectedFormat'], // selectedFormat 추가
      );

      // LoadingView로 이동
      Get.toNamed(Routes.LOADING);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start conversion: $e');
    }
  }
}
