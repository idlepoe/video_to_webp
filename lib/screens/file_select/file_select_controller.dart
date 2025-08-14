import 'package:flutter/material.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:media_scanner/media_scanner.dart';
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

  // 미디어 스캔 진행 상황 추적
  final RxBool isMediaScanning = false.obs;
  final RxDouble mediaScanProgress = 0.0.obs;
  final RxString mediaScanStatus = ''.obs;
  final RxInt mediaScanCurrent = 0.obs;
  final RxInt mediaScanTotal = 0.obs;

  // 스캔 옵션 관련 변수 추가
  final RxString selectedScanOption = '빠른 스캔'.obs;
  final RxString selectedScanOptionKey = 'quick_scan'.obs;

  @override
  void onInit() {
    super.onInit();

    // FCM 서비스에 현재 화면 알림 (안전하게 처리)
    try {
      if (Get.isRegistered<FCMService>()) {
        final fcmService = Get.find<FCMService>();
        fcmService.updateCurrentScreen('/file_select');
      } else {
        print('FCM 서비스가 아직 초기화되지 않았습니다.');
      }
    } catch (e) {
      print('FCM 서비스 접근 오류: $e');
      // FCM 서비스가 없어도 앱은 정상 동작
    }
  }

  @override
  void onReady() {
    super.onReady();
    _initializeFirebase();
    _loadNotificationPreference();
    _requestPermissions();
  }

  // 권한 요청
  Future<void> _requestPermissions() async {
    try {
      // Android 13+ 에서는 READ_MEDIA_VIDEO 권한 필요
      if (Platform.isAndroid) {
        final status = await Permission.videos.status;
        if (status.isDenied) {
          await Permission.videos.request();
        }

        // 저장소 권한도 요청 (하위 버전 호환성)
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isDenied) {
          await Permission.storage.request();
        }
      }
    } catch (e) {
      print('권한 요청 오류: $e');
    }
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

    // 스캔 옵션 로드
    final scanOptionKey =
        prefs.getString('selected_scan_option') ?? 'quick_scan';
    final scanOptionName =
        prefs.getString('selected_scan_option_name') ?? '빠른 스캔';
    selectedScanOptionKey.value = scanOptionKey;
    selectedScanOption.value = scanOptionName;
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

  // 스캔 옵션 설정 및 저장
  Future<void> setScanOption(String optionKey, String optionName) async {
    selectedScanOptionKey.value = optionKey;
    selectedScanOption.value = optionName;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_scan_option', optionKey);
    await prefs.setString('selected_scan_option_name', optionName);
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

  // Media scan 실행으로 최신 영상 파일들을 갤러리에 인덱싱 (Android 전용)
  Future<void> _triggerMediaScan() async {
    try {
      // Android에서만 실행
      if (Platform.isAndroid) {
        _startMediaScan(); // 스캔 시작
        await _scanAndroidWithMediaScanner();
        _completeMediaScan(); // 스캔 완료
      }
    } catch (e) {
      print('Media scan 오류: $e');
      _errorMediaScan(e.toString());
    }
  }

  // Android: media_scanner 라이브러리를 사용한 미디어 스캔 (하이브리드 방식)
  Future<void> _scanAndroidWithMediaScanner() async {
    try {
      print('Android Media Scanner 시작 (하이브리드 방식)...');

      // 스캔된 디렉토리 목록 초기화
      _clearScannedDirectories();

      // 1단계: 기존 고정 경로 스캔
      await _scanFixedPaths();

      // 2단계: 동적 디렉토리 탐색 스캔
      await _scanDynamicDirectories();

      print('하이브리드 미디어 스캔 완료!');
    } catch (e) {
      print('Android Media Scanner 오류: $e');
      _errorMediaScan(e.toString());
    }
  }

  // 기존 고정 경로 스캔
  Future<void> _scanFixedPaths() async {
    try {
      print('고정 경로 스캔 시작...');

      // 주요 미디어 디렉토리들을 스캔 (중복 경로 제거)
      final List<String> scanPaths = [
        // 기본 시스템 폴더
        '/storage/emulated/0/Download',
        '/storage/emulated/0/DCIM',
        '/storage/emulated/0/Pictures',
        '/storage/emulated/0/Movies',
        '/storage/emulated/0/Videos',

        // 소셜 미디어 앱
        '/storage/emulated/0/Android/data/com.zhiliaoapp.musically/files/videos', // TikTok
        '/storage/emulated/0/Android/data/com.instagram.android/files/DCIM/Camera', // Instagram
        '/storage/emulated/0/Android/data/com.facebook.katana/files/videos', // Facebook
        '/storage/emulated/0/Android/data/com.twitter.android/files/videos', // Twitter/X
        '/storage/emulated/0/Android/data/com.snapchat.android/files/videos', // Snapchat
        '/storage/emulated/0/Android/data/com.google.android.youtube/files/videos', // YouTube

        // 메신저 앱
        '/storage/emulated/0/WhatsApp/Media/WhatsApp Video',
        '/storage/emulated/0/Telegram/Telegram Video',
        '/storage/emulated/0/Android/data/org.thoughtcrime.securesms/files/videos', // Signal
        '/storage/emulated/0/Android/data/jp.naver.line.android/files/videos', // Line
        '/storage/emulated/0/Android/data/com.tencent.mm/files/videos', // WeChat
        '/storage/emulated/0/Android/data/com.discord/files/videos', // Discord

        // 음악/비디오 스트리밍 앱
        '/storage/emulated/0/Android/data/com.spotify.music/files/videos', // Spotify
        '/storage/emulated/0/Android/data/com.apple.android.music/files/videos', // Apple Music
        '/storage/emulated/0/Android/data/com.netflix.mediaclient/files/videos', // Netflix
        '/storage/emulated/0/Android/data/com.amazon.avod.thirdpartyclient/files/videos', // Amazon Prime
        '/storage/emulated/0/Android/data/com.disney.disneyplus/files/videos', // Disney+

        // 기타 인기 앱
        '/storage/emulated/0/Android/data/com.pinterest/files/videos', // Pinterest
        '/storage/emulated/0/Android/data/com.reddit.frontpage/files/videos', // Reddit
        '/storage/emulated/0/Android/data/com.linkedin.android/files/videos', // LinkedIn
        '/storage/emulated/0/Android/data/com.microsoft.teams/files/videos', // Microsoft Teams
        '/storage/emulated/0/Android/data/com.skype.raider/files/videos', // Skype

        // 외부 SD카드 (있는 경우)
        '/sdcard/Download',
        '/sdcard/DCIM',
        '/sdcard/Pictures',
        '/sdcard/Movies',
        '/sdcard/Videos',

        // 사용자 정의 폴더 (일반적인 위치)
        '/storage/emulated/0/My Videos',
        '/storage/emulated/0/Video',
        '/storage/emulated/0/Recordings',
        '/storage/emulated/0/Screen Recordings',
        '/storage/emulated/0/Bluetooth',
        '/storage/emulated/0/Shareit',
        '/storage/emulated/0/Xender',
      ];

      int successCount = 0;
      int totalPaths = scanPaths.length;

      // 스캔 시작
      _updateMediaScanProgress(0, totalPaths, '고정 경로 스캔 시작...');

      for (int i = 0; i < scanPaths.length; i++) {
        String path = scanPaths[i];
        try {
          final directory = Directory(path);
          if (await directory.exists()) {
            // 진행 상황 업데이트
            _updateMediaScanProgress(
                i + 1, totalPaths, '고정 경로 스캔 중: ${path.split('/').last}');

            print('디렉토리 스캔 중: $path');

            // media_scanner 라이브러리를 사용하여 디렉토리 스캔
            await MediaScanner.loadMedia(path: path);
            print('디렉토리 스캔 완료: $path');
            successCount++;

            // 스캔된 디렉토리 목록에 추가
            _addScannedDirectory(path);
          } else {
            print('디렉토리가 존재하지 않음: $path');
            _updateMediaScanProgress(
                i + 1, totalPaths, '건너뜀: ${path.split('/').last}');
          }
        } catch (e) {
          print('디렉토리 스캔 실패: $path - $e');
          _updateMediaScanProgress(
              i + 1, totalPaths, '오류: ${path.split('/').last}');
        }
      }

      print('고정 경로 스캔 완료: $successCount/$totalPaths 디렉토리 스캔 성공');

      // 성공한 스캔이 있으면 사용자에게 알림
      if (successCount > 0) {
        _updateMediaScanProgress(
            totalPaths, totalPaths, '고정 경로 스캔 완료! $successCount개 폴더 성공');
      }
    } catch (e) {
      print('고정 경로 스캔 오류: $e');
      throw e;
    }
  }

  // 수동 Media scan 실행 (사용자가 직접 실행할 수 있는 기능)
  Future<void> manualMediaScan() async {
    try {
      // 사용자에게 스캔 중임을 알림
      // CommonSnackBar.info('info'.tr, 'scanning_media_files'.tr);

      print('수동 미디어 스캔 시작...');
      await _triggerMediaScan();

      // CommonSnackBar.success('success'.tr, 'media_scan_complete'.tr);
      print('수동 미디어 스캔 완료');
    } catch (e) {
      // CommonSnackBar.error('error'.tr, 'media_scan_failed'.tr);
      print('수동 Media scan 오류: $e');
    }
  }

  // 선택된 스캔 옵션에 따라 스캔 실행
  Future<void> executeSelectedScanOption() async {
    try {
      switch (selectedScanOptionKey.value) {
        case 'quick_scan':
          await quickMediaScan();
          break;
        case 'hybrid_scan':
          await hybridMediaScan();
          break;
        case 'full_scan':
          await fullMediaScan();
          break;
        default:
          await quickMediaScan(); // 기본값
      }
    } catch (e) {
      print('선택된 스캔 옵션 실행 오류: $e');
    }
  }

  // 특정 파일을 미디어 스캔에 추가 (고급 기능)
  Future<void> scanSpecificFile(String filePath) async {
    try {
      if (Platform.isAndroid) {
        print('특정 파일 스캔: $filePath');

        // 파일이 존재하는지 확인
        final file = File(filePath);
        if (await file.exists()) {
          // media_scanner로 특정 파일 스캔
          await MediaScanner.loadMedia(path: filePath);
          print('파일 스캔 완료: $filePath');
        } else {
          print('파일이 존재하지 않음: $filePath');
        }
      }
    } catch (e) {
      print('특정 파일 스캔 오류: $filePath - $e');
    }
  }

  // 최근 다운로드된 비디오 파일들을 찾아서 스캔 (고급 기능)
  Future<void> scanRecentVideoFiles() async {
    try {
      if (Platform.isAndroid) {
        print('최근 비디오 파일 스캔 시작...');

        // 다운로드 폴더에서 최근 비디오 파일들 찾기
        final downloadDir = Directory('/storage/emulated/0/Download');
        if (await downloadDir.exists()) {
          final List<FileSystemEntity> videoFiles = [];

          await for (FileSystemEntity entity in downloadDir.list()) {
            if (entity is File) {
              final extension = entity.path.split('.').last.toLowerCase();
              if ([
                'mp4',
                'avi',
                'mov',
                'mkv',
                'wmv',
                'flv',
                'webm',
                '3gp',
                'm4v'
              ].contains(extension)) {
                // 최근 24시간 내에 수정된 파일만
                final stat = await entity.stat();
                final now = DateTime.now();
                final difference = now.difference(stat.modified);

                if (difference.inHours < 24) {
                  videoFiles.add(entity);
                }
              }
            }
          }

          print('최근 비디오 파일 ${videoFiles.length}개 발견');

          // 각 파일을 개별적으로 스캔
          for (FileSystemEntity file in videoFiles) {
            try {
              await MediaScanner.loadMedia(path: file.path);
              print('비디오 파일 스캔 완료: ${file.path}');
            } catch (e) {
              print('비디오 파일 스캔 실패: ${file.path} - $e');
            }
          }

          print('최근 비디오 파일 스캔 완료');
        }
      }
    } catch (e) {
      print('최근 비디오 파일 스캔 오류: $e');
    }
  }

  // 동적으로 설치된 앱의 비디오 폴더를 감지하여 스캔 (고급 기능)
  Future<void> scanInstalledAppsVideoFolders() async {
    try {
      if (Platform.isAndroid) {
        print('설치된 앱의 비디오 폴더 스캔 시작...');

        // 주요 앱들의 패키지명과 비디오 폴더 경로 매핑
        final Map<String, List<String>> appVideoPaths = {
          'com.zhiliaoapp.musically': [
            // TikTok
            '/storage/emulated/0/Android/data/com.zhiliaoapp.musically/files/videos',
            '/storage/emulated/0/Android/data/com.zhiliaoapp.musically/files/DCIM',
          ],
          'com.instagram.android': [
            // Instagram
            '/storage/emulated/0/Android/data/com.instagram.android/files/DCIM/Camera',
            '/storage/emulated/0/Android/data/com.instagram.android/files/DCIM/Instagram',
          ],
          'com.facebook.katana': [
            // Facebook
            '/storage/emulated/0/Android/data/com.facebook.katana/files/videos',
            '/storage/emulated/0/Android/data/com.facebook.katana/files/DCIM',
          ],
          'com.twitter.android': [
            // Twitter/X
            '/storage/emulated/0/Android/data/com.twitter.android/files/videos',
            '/storage/emulated/0/Android/data/com.twitter.android/files/DCIM',
          ],
          'com.snapchat.android': [
            // Snapchat
            '/storage/emulated/0/Android/data/com.snapchat.android/files/videos',
            '/storage/emulated/0/Android/data/com.snapchat.android/files/DCIM',
          ],
          'com.google.android.youtube': [
            // YouTube
            '/storage/emulated/0/Android/data/com.google.android.youtube/files/videos',
            '/storage/emulated/0/Android/data/com.google.android.youtube/files/DCIM',
          ],
          'com.whatsapp': [
            // WhatsApp
            '/storage/emulated/0/WhatsApp/Media/WhatsApp Video',
            '/storage/emulated/0/WhatsApp/Media/WhatsApp Images',
          ],
          'org.telegram.messenger': [
            // Telegram
            '/storage/emulated/0/Telegram/Telegram Video',
            '/storage/emulated/0/Telegram/Telegram Images',
          ],
          'org.thoughtcrime.securesms': [
            // Signal
            '/storage/emulated/0/Android/data/org.thoughtcrime.securesms/files/videos',
            '/storage/emulated/0/Android/data/org.thoughtcrime.securesms/files/DCIM',
          ],
          'jp.naver.line.android': [
            // Line
            '/storage/emulated/0/Android/data/jp.naver.line.android/files/videos',
            '/storage/emulated/0/Android/data/jp.naver.line.android/files/DCIM',
          ],
          'com.tencent.mm': [
            // WeChat
            '/storage/emulated/0/Android/data/com.tencent.mm/files/videos',
            '/storage/emulated/0/Android/data/com.tencent.mm/files/DCIM',
          ],
          'com.discord': [
            // Discord
            '/storage/emulated/0/Android/data/com.discord/files/videos',
            '/storage/emulated/0/Android/data/com.discord/files/DCIM',
          ],
          'com.spotify.music': [
            // Spotify
            '/storage/emulated/0/Android/data/com.spotify.music/files/videos',
            '/storage/emulated/0/Android/data/com.spotify.music/files/DCIM',
          ],
          'com.netflix.mediaclient': [
            // Netflix
            '/storage/emulated/0/Android/data/com.netflix.mediaclient/files/videos',
            '/storage/emulated/0/Android/data/com.netflix.mediaclient/files/DCIM',
          ],
          'com.pinterest': [
            // Pinterest
            '/storage/emulated/0/Android/data/com.pinterest/files/videos',
            '/storage/emulated/0/Android/data/com.pinterest/files/DCIM',
          ],
          'com.reddit.frontpage': [
            // Reddit
            '/storage/emulated/0/Android/data/com.reddit.frontpage/files/videos',
            '/storage/emulated/0/Android/data/com.reddit.frontpage/files/DCIM',
          ],
        };

        int totalScanned = 0;
        int totalFound = 0;

        // 각 앱의 비디오 폴더를 순회하며 스캔
        for (String packageName in appVideoPaths.keys) {
          final paths = appVideoPaths[packageName]!;

          for (String path in paths) {
            try {
              final directory = Directory(path);
              if (await directory.exists()) {
                print('앱 비디오 폴더 스캔 중: $path');

                // media_scanner로 디렉토리 스캔
                await MediaScanner.loadMedia(path: path);
                print('앱 비디오 폴더 스캔 완료: $path');
                totalScanned++;
              }
            } catch (e) {
              print('앱 비디오 폴더 스캔 실패: $path - $e');
            }
          }
          totalFound++;
        }

        print('설치된 앱 비디오 폴더 스캔 완료: $totalScanned개 폴더 스캔, $totalFound개 앱 처리');
      }
    } catch (e) {
      print('설치된 앱 비디오 폴더 스캔 오류: $e');
    }
  }

  // 특정 앱의 비디오 폴더만 스캔 (사용자 지정)
  Future<void> scanSpecificAppVideos(
      String appName, List<String> videoPaths) async {
    try {
      if (Platform.isAndroid) {
        print('$appName 앱 비디오 폴더 스캔 시작...');

        int successCount = 0;
        for (String path in videoPaths) {
          try {
            final directory = Directory(path);
            if (await directory.exists()) {
              print('$appName 비디오 폴더 스캔 중: $path');

              await MediaScanner.loadMedia(path: path);
              print('$appName 비디오 폴더 스캔 완료: $path');
              successCount++;
            } else {
              print('$appName 비디오 폴더가 존재하지 않음: $path');
            }
          } catch (e) {
            print('$appName 비디오 폴더 스캔 실패: $path - $e');
          }
        }

        print(
            '$appName 앱 비디오 폴더 스캔 완료: $successCount/${videoPaths.length} 폴더 성공');
      }
    } catch (e) {
      print('$appName 앱 비디오 폴더 스캔 오류: $e');
    }
  }

  // 고급 미디어 스캔 실행 (모든 기능 포함)
  Future<void> advancedMediaScan() async {
    try {
      print('고급 미디어 스캔 시작...');

      // 1. 기본 시스템 폴더 스캔
      await _scanAndroidWithMediaScanner();

      // 2. 설치된 앱의 비디오 폴더 스캔
      await scanInstalledAppsVideoFolders();

      // 3. 최근 비디오 파일 스캔
      await scanRecentVideoFiles();

      print('고급 미디어 스캔 완료!');
    } catch (e) {
      print('고급 미디어 스캔 오류: $e');
    }
  }

  // TikTok 전용 스캔
  Future<void> scanTikTokVideos() async {
    await scanSpecificAppVideos('TikTok', [
      '/storage/emulated/0/Android/data/com.zhiliaoapp.musically/files/videos',
      '/storage/emulated/0/Android/data/com.zhiliaoapp.musically/files/DCIM',
      '/storage/emulated/0/Android/data/com.zhiliaoapp.musically/files/downloads',
    ]);
  }

  // Instagram 전용 스캔
  Future<void> scanInstagramVideos() async {
    await scanSpecificAppVideos('Instagram', [
      '/storage/emulated/0/Android/data/com.instagram.android/files/DCIM/Camera',
      '/storage/emulated/0/Android/data/com.instagram.android/files/DCIM/Instagram',
      '/storage/emulated/0/Android/data/com.instagram.android/files/videos',
    ]);
  }

  // WhatsApp 전용 스캔
  Future<void> scanWhatsAppVideos() async {
    await scanSpecificAppVideos('WhatsApp', [
      '/storage/emulated/0/WhatsApp/Media/WhatsApp Video',
      '/storage/emulated/0/WhatsApp/Media/WhatsApp Images',
      '/storage/emulated/0/WhatsApp/Media/WhatsApp Documents',
    ]);
  }

  // Telegram 전용 스캔
  Future<void> scanTelegramVideos() async {
    await scanSpecificAppVideos('Telegram', [
      '/storage/emulated/0/Telegram/Telegram Video',
      '/storage/emulated/0/Telegram/Telegram Images',
      '/storage/emulated/0/Telegram/Telegram Documents',
    ]);
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

  // 미디어 스캔 진행 상황 업데이트
  void _updateMediaScanProgress(int current, int total, String status) {
    mediaScanCurrent.value = current;
    mediaScanTotal.value = total;
    mediaScanProgress.value = total > 0 ? current / total : 0.0;
    mediaScanStatus.value = status;
  }

  // 미디어 스캔 시작
  void _startMediaScan() {
    isMediaScanning.value = true;
    mediaScanProgress.value = 0.0;
    mediaScanCurrent.value = 0;
    mediaScanTotal.value = 0;
    mediaScanStatus.value = '미디어 스캔 준비 중...';
  }

  // 미디어 스캔 완료
  void _completeMediaScan() {
    isMediaScanning.value = false;
    mediaScanProgress.value = 1.0;
    mediaScanStatus.value = '미디어 스캔 완료!';
  }

  // 미디어 스캔 오류
  void _errorMediaScan(String error) {
    isMediaScanning.value = false;
    mediaScanStatus.value = '스캔 오류: $error';
  }

  // 동적 디렉토리 탐색을 통한 미디어 스캔 (고급 기능)
  Future<void> _scanDynamicDirectories() async {
    try {
      print('동적 디렉토리 탐색 시작...');
      _updateMediaScanProgress(0, 0, '동적 디렉토리 탐색 시작...');

      // 탐색할 루트 디렉토리들
      final List<String> rootDirectories = [
        '/storage/emulated/0',
        '/sdcard',
      ];

      int totalScanned = 0;
      int totalFound = 0;

      for (int i = 0; i < rootDirectories.length; i++) {
        String rootDir = rootDirectories[i];
        try {
          final directory = Directory(rootDir);
          if (await directory.exists()) {
            _updateMediaScanProgress(
                0, 0, '동적 탐색 중: ${rootDir.split('/').last}');
            print('루트 디렉토리 탐색 중: $rootDir');
            final scanResult =
                await _scanDirectoryRecursively(directory, maxDepth: 3);
            totalScanned += scanResult['scanned'] ?? 0;
            totalFound += scanResult['found'] ?? 0;
          }
        } catch (e) {
          print('루트 디렉토리 접근 실패: $rootDir - $e');
        }
      }

      _updateMediaScanProgress(0, 0, '동적 탐색 완료! $totalFound개 비디오 폴더 발견');
      print('동적 디렉토리 탐색 완료: $totalScanned개 폴더 스캔, $totalFound개 비디오 폴더 발견');
    } catch (e) {
      print('동적 디렉토리 탐색 오류: $e');
      _updateMediaScanProgress(0, 0, '동적 탐색 오류: $e');
    }
  }

  // 재귀적으로 디렉토리를 탐색하여 비디오 파일이 있는 폴더 찾기
  Future<Map<String, int>> _scanDirectoryRecursively(Directory directory,
      {int maxDepth = 3, int currentDepth = 0}) async {
    Map<String, int> result = {'scanned': 0, 'found': 0};

    try {
      if (currentDepth >= maxDepth) return result;

      // 디렉토리 내 파일/폴더 목록 가져오기
      await for (FileSystemEntity entity in directory.list()) {
        try {
          if (entity is Directory) {
            // 하위 디렉토리 재귀 탐색
            final subResult = await _scanDirectoryRecursively(entity,
                maxDepth: maxDepth, currentDepth: currentDepth + 1);
            result['scanned'] =
                (result['scanned'] ?? 0) + (subResult['scanned'] ?? 0);
            result['found'] =
                (result['found'] ?? 0) + (subResult['found'] ?? 0);
          } else if (entity is File) {
            // 비디오 파일인지 확인
            if (_isVideoFile(entity.path)) {
              // 비디오 파일이 있는 디렉토리 발견
              final parentDir = entity.parent.path;
              if (!_isSystemDirectory(parentDir) &&
                  !_isAlreadyScanned(parentDir)) {
                try {
                  print('비디오 파일 발견: ${entity.path}');
                  print('해당 디렉토리 스캔: $parentDir');

                  // media_scanner로 디렉토리 스캔
                  await MediaScanner.loadMedia(path: parentDir);
                  print('동적 디렉토리 스캔 완료: $parentDir');

                  result['found'] = (result['found'] ?? 0) + 1;
                  _addScannedDirectory(parentDir);
                } catch (e) {
                  print('동적 디렉토리 스캔 실패: $parentDir - $e');
                }
              }
            }
          }
        } catch (e) {
          // 개별 엔티티 처리 실패는 무시하고 계속 진행
          continue;
        }
      }

      result['scanned'] = (result['scanned'] ?? 0) + 1;
    } catch (e) {
      print('디렉토리 탐색 실패: ${directory.path} - $e');
    }

    return result;
  }

  // 비디오 파일인지 확인
  bool _isVideoFile(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return [
      'mp4',
      'avi',
      'mov',
      'mkv',
      'wmv',
      'flv',
      'webm',
      '3gp',
      'm4v',
      'ts',
      'mts',
      'm2ts',
      'vob',
      'ogv',
      'mxf',
      'rm',
      'rmvb',
      'asf'
    ].contains(extension);
  }

  // 시스템 디렉토리인지 확인 (스캔에서 제외할 디렉토리)
  bool _isSystemDirectory(String path) {
    final lowerPath = path.toLowerCase();
    return lowerPath.contains('/android/') ||
        lowerPath.contains('/system/') ||
        lowerPath.contains('/data/') ||
        lowerPath.contains('/cache/') ||
        lowerPath.contains('/temp/') ||
        lowerPath.contains('/tmp/') ||
        lowerPath.contains('/.') || // 숨김 폴더
        lowerPath.contains('/bin/') ||
        lowerPath.contains('/lib/') ||
        lowerPath.contains('/etc/') ||
        lowerPath.contains('/proc/') ||
        lowerPath.contains('/sys/');
  }

  // 이미 스캔된 디렉토리인지 확인
  final Set<String> _scannedDirectories = <String>{};

  bool _isAlreadyScanned(String path) {
    return _scannedDirectories.contains(path);
  }

  // 스캔된 디렉토리 목록에 추가
  void _addScannedDirectory(String path) {
    _scannedDirectories.add(path);
  }

  // 스캔된 디렉토리 목록 초기화
  void _clearScannedDirectories() {
    _scannedDirectories.clear();
  }

  // 하이브리드 미디어 스캔 (기본 + 동적 탐색)
  Future<void> hybridMediaScan() async {
    try {
      print('하이브리드 미디어 스캔 시작...');
      _startMediaScan();

      // 1단계: 기존 고정 경로 스캔
      await _scanFixedPaths();

      // 2단계: 동적 디렉토리 탐색 스캔
      await _scanDynamicDirectories();

      _completeMediaScan();
      print('하이브리드 미디어 스캔 완료!');
    } catch (e) {
      print('하이브리드 미디어 스캔 오류: $e');
      _errorMediaScan(e.toString());
    }
  }

  // 빠른 스캔 (고정 경로만)
  Future<void> quickMediaScan() async {
    try {
      print('빠른 미디어 스캔 시작...');
      _startMediaScan();
      await _scanFixedPaths();
      _completeMediaScan();
      print('빠른 미디어 스캔 완료!');
    } catch (e) {
      print('빠른 미디어 스캔 오류: $e');
      _errorMediaScan(e.toString());
    }
  }

  // 전체 스캔 (고정 경로 + 동적 탐색 + 앱별 스캔)
  Future<void> fullMediaScan() async {
    try {
      print('전체 미디어 스캔 시작...');
      _startMediaScan();

      // 1단계: 기존 고정 경로 스캔
      await _scanFixedPaths();

      // 2단계: 동적 디렉토리 탐색 스캔
      await _scanDynamicDirectories();

      // 3단계: 설치된 앱의 비디오 폴더 스캔
      await scanInstalledAppsVideoFolders();

      // 4단계: 최근 비디오 파일 스캔
      await scanRecentVideoFiles();

      _completeMediaScan();
      print('전체 미디어 스캔 완료!');
    } catch (e) {
      print('전체 미디어 스캔 오류: $e');
      _errorMediaScan(e.toString());
    }
  }

  // 스캔 방식 선택 다이얼로그
  void showScanOptionsDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('스캔 방식 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.flash_on, color: Colors.blue),
              title: Text('빠른 스캔'),
              subtitle: Text('주요 폴더만 빠르게 스캔'),
              onTap: () async {
                await setScanOption('quick_scan', '빠른 스캔');
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.balance, color: Colors.orange),
              title: Text('하이브리드 스캔'),
              subtitle: Text('고정 경로 + 동적 탐색 (권장)'),
              onTap: () async {
                await setScanOption('hybrid_scan', '하이브리드 스캔');
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.explore, color: Colors.green),
              title: Text('전체 스캔'),
              subtitle: Text('모든 가능한 경로를 완전히 스캔'),
              onTap: () async {
                await setScanOption('full_scan', '전체 스캔');
                Get.back();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('취소'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }
}
