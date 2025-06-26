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
import '../../widgets/common_snackbar.dart';

class FileSelectController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final Rx<XFile?> videoFile = Rx<XFile?>(null);
  final Rx<VideoPlayerController?> videoPlayerController =
      Rx<VideoPlayerController?>(null);
  final Rx<Duration> videoDuration = Duration.zero.obs;
  final RxInt videoWidth = 0.obs;
  final RxInt videoHeight = 0.obs;
  final RxBool isInitialized = false.obs;
  final RxDouble uploadPercent = 0.0.obs;
  final RxBool isUploading = false.obs;

  // Trim 설정
  final RxDouble trimStartTime = 0.0.obs;
  final Rx<double?> trimEndTime = Rx<double?>(null);

  @override
  void onReady() {
    super.onReady();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      print('Firebase 초기화 시작');
      final auth = FirebaseAuth.instance;
      print('Firebase Auth 인스턴스 초기화 확인: ${auth.app.name}');

      if (auth.currentUser == null) {
        print('익명 로그인 시도');
        final userCredential = await auth.signInAnonymously();
        print('익명 로그인 성공: ${userCredential.user?.uid}');
      }

      isInitialized.value = true;
      print('Firebase 초기화 완료');
    } catch (e) {
      print('Firebase 초기화 중 오류 발생: $e');
      CommonSnackBar.error('Error'.tr, 'Initialization failed.'.tr);
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        final fileSize = File(file.path).lengthSync();
        final fileSizeMB = fileSize / (1024 * 1024);

        // 20MB 제한 적용
        if (fileSizeMB > 20) {
          CommonSnackBar.error(
              'Error'.tr,
              'Videos larger than 20MB cannot be processed due to processing costs. Please select a smaller video.'
                  .tr);
          return;
        }

        print('비디오 파일 선택됨: ${file.path} (${fileSizeMB.toStringAsFixed(1)}MB)');
        videoFile.value = file;
        await _initVideoPlayer(file);
      }
    } catch (e) {
      print('비디오 선택 중 오류 발생: $e');
      CommonSnackBar.error(
          'Error'.tr, 'An error occurred while selecting the video.'.tr);
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
      print(
          '비디오 정보: ${videoWidth.value}x${videoHeight.value}, ${videoDuration.value}');
    } catch (e) {
      print('비디오 플레이어 초기화 중 오류 발생: $e');
    }
  }

  // Trim 설정 업데이트
  void updateTrimSettings(double startTime, double? endTime) {
    trimStartTime.value = startTime;
    trimEndTime.value = endTime;
    print('Trim 설정 업데이트: 시작=${startTime}초, 끝=${endTime}초');
  }

  Future<void> uploadAndRequestConvert(ConvertOptions options) async {
    if (!isInitialized.value) {
      print('Firebase가 초기화되지 않음');
      CommonSnackBar.error('Error'.tr,
          'Initialization is not complete. Please try again later.'.tr);
      return;
    }

    if (videoFile.value == null) {
      print('오류: 비디오 파일이 선택되지 않음');
      CommonSnackBar.error('Error'.tr, 'Please select a video file.'.tr);
      return;
    }

    try {
      isUploading.value = true;
      uploadPercent.value = 0.0;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('오류: 사용자가 로그인되지 않음');
        CommonSnackBar.error('Error'.tr, 'Login is required.'.tr);
        isUploading.value = false;
        return;
      }

      print('Firestore 변환 요청 문서 먼저 생성');
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
      print('Firestore 문서 생성 완료: $requestId');

      // LoadingController를 find로 가져와 구독 시작
      final loadingController = Get.find<LoadingController>();
      loadingController.listenToConvertRequest(requestId);

      print('Storage에 파일 업로드 시작');
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
          print('파일 업로드 완료: ${await snapshot.ref.getDownloadURL()}');
          print('Firestore update 완료');
          isUploading.value = false;
          uploadPercent.value = 0.0;
          // 다이얼로그 닫고 로딩 화면 이동
          if (Get.isDialogOpen ?? false) Get.back();
          await Get.toNamed(AppRoutes.loading,
              arguments: {'requestId': requestId});
        }
      }, onError: (uploadError) {
        print('업로드 중 오류 발생: $uploadError');
        isUploading.value = false;
        uploadPercent.value = 0.0;
        CommonSnackBar.error('Error'.tr,
            'An error occurred during file upload. Please try again.'.tr,
            duration: Duration(seconds: 5));
      });
    } catch (e, stack) {
      isUploading.value = false;
      uploadPercent.value = 0.0;
      print('업로드 중 오류 발생: $e');
      print('스택 트레이스: $stack');
      CommonSnackBar.error('Error'.tr,
          'An error occurred during file upload. Please try again.'.tr,
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
      print(
          '변환 설정 저장 완료: resolution=$selectedResolution, fps=$fps, quality=$quality, format=$format');
    } catch (e) {
      print('변환 설정 저장 중 오류: $e');
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
      print('변환 설정 불러오기 중 오류: $e');
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
