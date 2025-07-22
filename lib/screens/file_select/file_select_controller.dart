import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../../models/convert_request.dart';
import '../../routes/app_routes.dart';
import '../loading/loading_controller.dart';
import '../video_trim/video_trim_screen.dart';
import '../../widgets/common_snackbar.dart';
import '../../services/fcm_service.dart';

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

  final RxBool notificationSubscribed = true.obs;

  @override
  void onReady() {
    super.onReady();
    _initializeFirebase();
    _loadNotificationPreference();
  }

  Future<void> _initializeFirebase() async {
    try {
      final auth = FirebaseAuth.instance;

      if (auth.currentUser == null) {
        final userCredential = await auth.signInAnonymously();
      }

      // FCM 토픽 업데이트
      final fcmService = Get.find<FCMService>();
      await fcmService.updateUserTopic();

      isInitialized.value = true;
    } catch (e) {
      // CommonSnackBar.error('Error'.tr, 'Initialization failed.'.tr);
    }
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('notification_subscribed') ?? true;
    notificationSubscribed.value = value;
  }

  Future<void> setNotificationSubscribed(bool value) async {
    notificationSubscribed.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_subscribed', value);
    final fcmService = Get.find<FCMService>();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (value) {
        await fcmService.subscribeToUser(user.uid);
      } else {
        await fcmService.unsubscribeFromUser(user.uid);
      }
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
      // CommonSnackBar.error('error'.tr, 'select_file_error'.tr);
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

      // CommonSnackBar.success('success'.tr, 'trim_applied_message'.tr);
    }
  }

  // 원본으로 되돌리기
  Future<void> restoreOriginal() async {
    if (originalVideoFile.value == null) {
      // CommonSnackBar.error('error'.tr, 'no_original_file'.tr);
      return;
    }

    try {
      videoFile.value = originalVideoFile.value;
      isTrimmed.value = false;
      await _initVideoPlayer(originalVideoFile.value!);
      // CommonSnackBar.success('success'.tr, 'original_restored'.tr);
    } catch (e) {
      // CommonSnackBar.error('error'.tr, 'restore_error'.tr);
    }
  }

  // 업로드 전 파일 크기 확인 (다이얼로그에서 이미 확인했으므로 단순화)
  bool validateFileSize(String filePath) {
    final fileSize = File(filePath).lengthSync();
    final fileSizeMB = fileSize / (1024 * 1024);
    return fileSizeMB <= 20;
  }

  Future<void> uploadAndRequestConvert(ConvertOptions options) async {
    if (!isInitialized.value) {
      // CommonSnackBar.error('error'.tr, 'initialization_error'.tr);
      return;
    }

    if (videoFile.value == null) {
      // CommonSnackBar.error('error'.tr, 'select_file_error'.tr);
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
        // CommonSnackBar.error('error'.tr, 'login_required'.tr);
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
        // CommonSnackBar.error('error'.tr, 'upload_error'.tr,
        //     duration: Duration(seconds: 5));
      });
    } catch (e, stack) {
      isUploading.value = false;
      uploadPercent.value = 0.0;
      // CommonSnackBar.error('error'.tr, 'upload_error'.tr,
      //     duration: Duration(seconds: 5));
    }
  }

  // 설정 저장
  Future<void> saveConvertSettings({
    required int selectedResolution,
    required double fps,
    required double quality,
    required String format,
    required double speed,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('convert_resolution', selectedResolution);
      await prefs.setDouble('convert_fps', fps);
      await prefs.setDouble('convert_quality', quality);
      await prefs.setString('convert_format', format);
      await prefs.setDouble('convert_speed', speed);
    } catch (e) {
      // 변환 설정 저장 중 오류 처리
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
      };
    } catch (e) {
      return {
        'selectedResolution': 0, // 기본값은 원본 해상도
        'fps': 30.0,
        'quality': 75.0,
        'format': 'webp',
        'speed': 1.0,
      };
    }
  }

  // 1초 샘플 생성 함수 (trim 기능 활용)
  Future<String> _createOnSecondSample(String originalFilePath) async {
    final trimmer = Trimmer();
    String? savedPath;

    try {
      // 비디오 로드
      await trimmer.loadVideo(videoFile: File(originalFilePath));

      // 임시 디렉토리에 샘플 파일 생성
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final samplePath = '${directory.path}/sample_${timestamp}.mp4';

      // Completer를 사용하여 비동기 콜백 처리
      final completer = Completer<String>();

      // 1초 샘플 생성 (0초부터 1초까지)
      await trimmer.saveTrimmedVideo(
        startValue: 0.0,
        endValue: 1000.0, // 1초 = 1000ms
        onSave: (String? outputPath) {
          if (outputPath != null) {
            savedPath = outputPath;
            completer.complete(outputPath);
          } else {
            completer.completeError('샘플 파일 저장 실패');
          }
        },
      );

      // 저장 완료까지 대기
      return await completer.future;
    } catch (e) {
      trimmer.dispose();
      throw Exception('1초 샘플 생성 실패: ${e.toString()}');
    } finally {
      trimmer.dispose();
    }
  }

  // 임시 파일 정리 함수
  void _cleanupTempFile(String filePath) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      // 임시 파일 정리 실패는 무시
      print('임시 파일 정리 실패: $e');
    }
  }

  // URL로부터 파일 크기 확인 함수 (dio 사용)
  Future<int?> _getFileSizeFromUrl(String url) async {
    try {
      final dio = Dio();
      print('파일 크기 확인 URL: $url');

      // HEAD 요청으로 Content-Length 헤더만 가져오기
      final response = await dio.head(url);

      if (response.statusCode == 200) {
        final contentLength = response.headers.value('content-length');
        print('Content-Length 헤더: $contentLength');

        if (contentLength != null) {
          final size = int.tryParse(contentLength);
          print('파싱된 파일 크기: $size bytes');
          return size;
        }
      }

      print('Content-Length 헤더를 찾을 수 없음');
      return null;
    } catch (e) {
      print('URL에서 파일 크기 확인 오류: $e');
      return null;
    }
  }

  // 1초 샘플 변환을 위한 API 호출 (trim 기능 활용)
  Future<Map<String, dynamic>?> convertVideoSample(
      String filePath, ConvertOptions options) async {
    if (!isInitialized.value) {
      throw Exception('Firebase가 초기화되지 않았습니다.');
    }

    String? sampleFilePath;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      // 1초 샘플 생성을 위해 trim 기능 사용
      sampleFilePath = await _createOnSecondSample(filePath);

      // 일반 변환 요청 컬렉션 사용 (샘플용 옵션으로)
      final requestRef =
          FirebaseFirestore.instance.collection('convertRequests').doc();
      final requestId = requestRef.id;
      final originalFilePath = 'original/${user.uid}/$requestId.mp4';

      // 샘플 변환 요청 생성 (기존 변환 API와 동일한 구조)
      await requestRef.set({
        'userId': user.uid,
        'status': 'pending',
        'options': options.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'originalFile': originalFilePath,
        'isSample': true, // 샘플임을 표시하는 플래그
      });

      // trim된 1초 샘플 파일을 Firebase Storage에 업로드
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('original')
          .child(user.uid)
          .child('$requestId.mp4');

      await storageRef.putFile(
        File(sampleFilePath),
        SettableMetadata(
          contentType: 'video/mp4',
          customMetadata: {
            'uploadedAt': DateTime.now().toIso8601String(),
            'isSample': 'true',
          },
        ),
      );

      // Completer를 사용하여 비동기 결과 처리
      final completer = Completer<Map<String, dynamic>>();
      StreamSubscription? listener;

      // 실시간 listener 설정 (LoadingController와 동일한 방식)
      listener = requestRef.snapshots().listen((doc) {
        if (!doc.exists) return;

        final data = doc.data();
        final status = data?['status'];

        if (status == 'completed') {
          print('샘플 변환 상태: completed');
          print('샘플 변환 데이터: $data');

          // Firestore 데이터에서 직접 size 확인
          if (data?['size'] != null && data!['size'] > 0) {
            print('샘플 변환 Firestore에서 직접 size: ${data!['size']}');
            if (!completer.isCompleted) {
              completer.complete({
                'size': data!['size'],
                'downloadUrl': data?['downloadUrl'] ?? '',
                'status': 'completed',
              });
            }
            return;
          }

          // Firestore에 downloadUrl이 있고 size가 0이거나 없는 경우 URL로부터 직접 확인
          if (data?['downloadUrl'] != null) {
            print('Firestore downloadUrl로부터 크기 확인: ${data!['downloadUrl']}');
            _getFileSizeFromUrl(data!['downloadUrl']).then((urlSize) {
              if (urlSize != null && urlSize > 0) {
                print('Firestore downloadUrl로부터 확인한 크기: $urlSize bytes');
                if (!completer.isCompleted) {
                  completer.complete({
                    'size': urlSize,
                    'downloadUrl': data['downloadUrl'],
                    'status': 'completed',
                  });
                }
              }
            }).catchError((e) {
              print('Firestore downloadUrl 크기 확인 오류: $e');
            });
            return;
          }

          // 변환된 파일의 메타데이터에서 크기 정보 가져오기
          if (data?['resultFile'] != null) {
            print('샘플 변환 resultFile: ${data!['resultFile']}');
            final resultRef = FirebaseStorage.instance.ref(data!['resultFile']);

            resultRef.getMetadata().then((metadata) {
              print(
                  '샘플 변환 메타데이터: size=${metadata.size}, name=${metadata.name}');
              print('샘플 변환 메타데이터 전체: $metadata');

              return resultRef.getDownloadURL().then((downloadUrl) async {
                print('샘플 변환 downloadUrl: $downloadUrl');

                // 메타데이터에서 크기를 가져올 수 없거나 0인 경우 URL로부터 직접 확인
                int finalSize = metadata.size ?? 0;
                if (finalSize == 0) {
                  print('메타데이터 크기가 0이므로 URL로부터 직접 확인');
                  final urlSize = await _getFileSizeFromUrl(downloadUrl);
                  if (urlSize != null && urlSize > 0) {
                    finalSize = urlSize;
                    print('URL로부터 확인한 파일 크기: $finalSize bytes');
                  }
                }

                if (!completer.isCompleted) {
                  completer.complete({
                    'size': finalSize,
                    'downloadUrl': downloadUrl,
                    'status': 'completed',
                  });
                }
              });
            }).catchError((e) {
              print('샘플 변환 메타데이터/URL 가져오기 오류: $e');
              print('샘플 변환 오류 스택: ${StackTrace.current}');
              if (!completer.isCompleted) {
                completer.complete({
                  'size': 0,
                  'status': 'completed',
                });
              }
            });
          } else {
            if (!completer.isCompleted) {
              completer.complete({
                'size': 0,
                'status': 'completed',
              });
            }
          }
        } else if (status == 'failed') {
          if (!completer.isCompleted) {
            completer.completeError(data?['error'] ?? '샘플 변환에 실패했습니다.');
          }
        }
      }, onError: (e) {
        if (!completer.isCompleted) {
          completer.completeError('샘플 변환 모니터링 중 오류: ${e.toString()}');
        }
      });

      // 타임아웃 설정 (30초)
      Timer(Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          completer.completeError('샘플 변환 시간이 초과되었습니다.');
        }
      });

      // 결과 대기
      final result = await completer.future;

      // 리스너 정리
      listener?.cancel();

      return result;
    } catch (e) {
      throw Exception('샘플 변환 중 오류가 발생했습니다: ${e.toString()}');
    } finally {
      // 임시 샘플 파일 정리
      if (sampleFilePath != null) {
        _cleanupTempFile(sampleFilePath);
      }
    }
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }
}
