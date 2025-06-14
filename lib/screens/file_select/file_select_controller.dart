import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/convert_request.dart';
import '../../routes/app_routes.dart';

class FileSelectController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final Rx<XFile?> videoFile = Rx<XFile?>(null);
  final Rx<VideoPlayerController?> videoPlayerController = Rx<VideoPlayerController?>(null);
  final Rx<Duration> videoDuration = Duration.zero.obs;
  final RxInt videoWidth = 0.obs;
  final RxInt videoHeight = 0.obs;
  final RxBool isInitialized = false.obs;

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
      Get.snackbar('오류', '초기화 중 문제가 발생했습니다.');
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        print('비디오 파일 선택됨: ${file.path}');
        videoFile.value = file;
        await _initVideoPlayer(file);
      }
    } catch (e) {
      print('비디오 선택 중 오류 발생: $e');
      Get.snackbar('오류', '비디오를 선택하는 중 오류가 발생했습니다.');
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
      print('비디오 정보: ${videoWidth.value}x${videoHeight.value}, ${videoDuration.value}');
    } catch (e) {
      print('비디오 플레이어 초기화 중 오류 발생: $e');
    }
  }

  Future<void> uploadAndRequestConvert() async {
    if (!isInitialized.value) {
      print('Firebase가 초기화되지 않음');
      Get.snackbar('오류', '초기화가 완료되지 않았습니다. 잠시 후 다시 시도해주세요.');
      return;
    }

    if (videoFile.value == null) {
      print('오류: 비디오 파일이 선택되지 않음');
      Get.snackbar('오류', '비디오 파일을 선택해주세요.');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('오류: 사용자가 로그인되지 않음');
        Get.snackbar('오류', '로그인이 필요합니다.');
        return;
      }

      print('업로드 시작 - 사용자: ${user.uid}');
      print('파일 경로: ${videoFile.value!.path}');
      print('파일 크기: ${await File(videoFile.value!.path).length()} bytes');

      // Firebase Storage 인스턴스 확인
      final storage = FirebaseStorage.instance;
      print('Firebase Storage 인스턴스 초기화 확인: ${storage.app.name}');

      // 파일 업로드
      final storageRef = storage
          .ref()
          .child('original')
          .child(user.uid)
          .child('${DateTime.now().millisecondsSinceEpoch}.mp4');

      print('Storage 참조 생성됨: ${storageRef.fullPath}');

      // 업로드 재시도 로직
      int maxRetries = 3;
      int currentRetry = 0;
      bool uploadSuccess = false;

      while (!uploadSuccess && currentRetry < maxRetries) {
        try {
          if (currentRetry > 0) {
            print('업로드 재시도 ${currentRetry}/${maxRetries}');
          }

          final uploadTask = storageRef.putFile(
            File(videoFile.value!.path),
            SettableMetadata(
              contentType: 'video/mp4',
              customMetadata: {
                'uploadedAt': DateTime.now().toIso8601String(),
              },
            ),
          );
          
          // 업로드 진행률 모니터링
          uploadTask.snapshotEvents.listen(
            (TaskSnapshot snapshot) {
              final progress = snapshot.bytesTransferred / snapshot.totalBytes;
              print('업로드 진행률: ${(progress * 100).toStringAsFixed(1)}%');
            },
            onError: (error) {
              print('업로드 진행률 모니터링 중 오류: $error');
            },
          );

          // 업로드 완료 대기
          print('업로드 완료 대기 중...');
          final snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();
          print('파일 업로드 완료: $downloadUrl');
          uploadSuccess = true;

          // Firestore에 변환 요청 저장
          print('Firestore 요청 저장 시작');
          final requestRef = await FirebaseFirestore.instance
              .collection('convertRequests')
              .add({
            'userId': user.uid,
            'originalFile': 'original/${user.uid}/${snapshot.ref.name}',
            'status': 'pending',
            'options': {
              'resolution': '${videoWidth.value}x${videoHeight.value}',
              'fps': 30,
              'quality': 'medium',
              'format': 'webp',
            },
            'createdAt': FieldValue.serverTimestamp(),
          });
          print('Firestore 요청 저장 완료: ${requestRef.id}');

          // 업로드 완료 후 로딩 화면으로 이동
          print('로딩 화면으로 이동');
          await Get.toNamed(AppRoutes.loading, arguments: requestRef.id);
          print('로딩 화면 이동 완료');

        } catch (uploadError, uploadStack) {
          currentRetry++;
          print('업로드 시도 ${currentRetry} 실패: $uploadError');
          print('스택 트레이스: $uploadStack');
          
          if (currentRetry >= maxRetries) {
            throw uploadError; // 최대 재시도 횟수 초과 시 에러 전파
          }
          
          // 재시도 전 잠시 대기
          await Future.delayed(Duration(seconds: 2));
        }
      }

    } catch (e, stack) {
      print('업로드 중 오류 발생: $e');
      print('스택 트레이스: $stack');
      Get.snackbar(
        '오류',
        '파일 업로드 중 문제가 발생했습니다. 다시 시도해주세요.',
        duration: Duration(seconds: 5),
      );
    }
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }
} 