import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../routes/app_routes.dart';
import '../translations.dart';
import 'package:flutter/material.dart';

class FCMService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // 현재 화면 추적
  String? _currentScreen;

  @override
  void onInit() {
    super.onInit();

    try {
      _initializeLocalNotifications();
      _initializeFCM();
      _handleInitialMessage();

      // 초기 화면 설정
      _currentScreen = Get.currentRoute;
      print('FCM 서비스 초기화 완료');
    } catch (e) {
      print('FCM 서비스 초기화 중 오류 발생: $e');
      // 초기화 실패 시에도 기본 기능은 유지
      _currentScreen = Get.currentRoute;
    }
  }

  Future<void> _initializeLocalNotifications() async {
    try {
      // Android 설정
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('notification_icon');

      // iOS 설정
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // 초기화 설정
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // 플러그인 초기화
      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      print('로컬 알림 초기화 완료');
    } catch (e) {
      print('로컬 알림 초기화 오류: $e');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    try {
      print('로컬 알림 탭됨: ${response.payload}');

      // 이미 완료 화면이나 로딩 화면에 있는 경우 스킵
      if (_currentScreen == AppRoutes.complete ||
          _currentScreen == '/complete' ||
          _currentScreen == AppRoutes.loading ||
          _currentScreen == '/loading') {
        print('이미 완료/로딩 화면에 있으므로 네비게이션 스킵 (현재 화면: $_currentScreen)');
        return;
      }

      // 페이로드에서 메시지 데이터 추출
      if (response.payload != null) {
        try {
          // 간단한 페이로드 파싱 (실제로는 JSON 형태로 저장하는 것이 좋습니다)
          Map<String, String> data = {};
          List<String> pairs = response.payload!.split('&');
          for (String pair in pairs) {
            List<String> keyValue = pair.split('=');
            if (keyValue.length == 2) {
              data[keyValue[0]] = keyValue[1];
            }
          }

          // 변환 완료 화면으로 이동
          if (data.containsKey('screen') &&
              data['screen'] == 'convert_complete') {
            Map<String, dynamic> arguments = {
              'requestId': data['requestId'] ?? '',
              'convertedFile': data['convertedFile'] ?? '',
              'publicUrl': data['publicUrl'] ?? '',
              'downloadUrl': data['downloadUrl'] ?? '',
              'fileSize': int.tryParse(data['fileSize'] ?? '0') ?? 0,
            };

            Get.offAllNamed(AppRoutes.complete, arguments: arguments);
          }
        } catch (e) {
          print('알림 페이로드 파싱 오류: $e');
        }
      }
    } catch (e) {
      print('로컬 알림 처리 중 오류 발생: $e');
    }
  }

  Future<void> _initializeFCM() async {
    try {
      // 권한 요청
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('FCM 권한이 승인되었습니다.');

        // FCM 토큰 가져오기
        String? token = await _messaging.getToken();
        if (token != null) {
          print('FCM 토큰: $token');
          await _subscribeToUserTopic();
        }

        // 토큰 갱신 리스너
        _messaging.onTokenRefresh.listen((newToken) {
          print('FCM 토큰이 갱신되었습니다: $newToken');
          _subscribeToUserTopic();
        });

        // 포그라운드 메시지 핸들러
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // 백그라운드 메시지 핸들러
        FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

        // 알림 탭 핸들러
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      } else {
        print('FCM 권한이 거부되었습니다.');
      }
    } catch (e) {
      print('FCM 초기화 오류: $e');
    }
  }

  Future<void> _subscribeToUserTopic() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // 기존 토픽 구독 해제
        await _messaging.unsubscribeFromTopic('all');

        // 사용자별 토픽 구독
        await _messaging.subscribeToTopic(user.uid);
        print('사용자 토픽 구독 완료: ${user.uid}');
      }
    } catch (e) {
      print('토픽 구독 오류: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('포그라운드 메시지 수신: ${message.notification?.title}');

    // 포그라운드에서 로컬 알림 표시
    if (message.notification != null) {
      _showLocalNotification(message);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      // 알림 ID (고유한 값으로 설정)
      int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Android 알림 세부 설정
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'convert_complete_channel',
        'fcm_convert_complete_channel'.tr,
        channelDescription: 'fcm_convert_complete_channel_description'.tr,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: 'notification_icon',
        color: Color(0xFF3182F6),
      );

      // iOS 알림 세부 설정
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // 알림 세부 설정
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      // 페이로드 생성 (네비게이션을 위한 데이터)
      String payload = 'screen=convert_complete';
      if (message.data.containsKey('requestId')) {
        payload += '&requestId=${message.data['requestId']}';
      }
      if (message.data.containsKey('convertedFile')) {
        payload += '&convertedFile=${message.data['convertedFile']}';
      }
      if (message.data.containsKey('publicUrl')) {
        payload += '&publicUrl=${message.data['publicUrl']}';
      }
      if (message.data.containsKey('downloadUrl')) {
        payload += '&downloadUrl=${message.data['downloadUrl']}';
      }

      // 로컬 알림 표시
      await _localNotifications.show(
        notificationId,
        message.notification?.title ?? 'convert_complete_title'.tr,
        message.notification?.body ?? 'convert_complete_message'.tr,
        platformChannelSpecifics,
        payload: payload,
      );

      print('로컬 알림 표시 완료: ${message.notification?.title}');
    } catch (e) {
      print('로컬 알림 표시 오류: $e');
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('알림 탭으로 앱 열림: ${message.notification?.title}');
    _handleMessageNavigation(message);
  }

  Future<void> updateUserTopic() async {
    await _subscribeToUserTopic();
  }

  Future<void> subscribeToUser(String userId) async {
    try {
      await _messaging.subscribeToTopic(userId);
      print('사용자 토픽 구독: $userId');
    } catch (e) {
      print('사용자 토픽 구독 오류: $e');
    }
  }

  Future<void> unsubscribeFromUser(String userId) async {
    try {
      await _messaging.unsubscribeFromTopic(userId);
      print('사용자 토픽 구독 해제: $userId');
    } catch (e) {
      print('사용자 토픽 구독 해제 오류: $e');
    }
  }

  // 앱이 종료된 상태에서 알림을 탭했을 때 처리
  Future<void> _handleInitialMessage() async {
    try {
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        print('앱 종료 상태에서 알림 탭으로 앱 열림: ${initialMessage.notification?.title}');
        // 앱이 완전히 초기화된 후에 네비게이션 실행
        Future.delayed(Duration(seconds: 2), () {
          _handleMessageNavigation(initialMessage);
        });
      }
    } catch (e) {
      print('초기 메시지 처리 오류: $e');
    }
  }

  // 메시지 데이터를 기반으로 화면 이동 처리
  void _handleMessageNavigation(RemoteMessage message) {
    try {
      if (message.data.containsKey('screen')) {
        String screen = message.data['screen'];
        if (screen == 'convert_complete') {
          // 이미 완료 화면이나 로딩 화면에 있는 경우 스킵
          if (_currentScreen == AppRoutes.complete ||
              _currentScreen == '/complete' ||
              _currentScreen == AppRoutes.loading ||
              _currentScreen == '/loading') {
            print('이미 완료/로딩 화면에 있으므로 네비게이션 스킵 (현재 화면: $_currentScreen)');
            return;
          }

          // 변환 완료 화면으로 이동 (데이터 포함)
          Map<String, dynamic> arguments = {
            'requestId': message.data['requestId'] ?? '',
            'convertedFile': message.data['convertedFile'] ?? '',
            'publicUrl': message.data['publicUrl'] ?? '',
            'downloadUrl': message.data['downloadUrl'] ?? '',
            'fileSize': int.tryParse(message.data['fileSize'] ?? '0') ?? 0,
          };

          print('네비게이션 실행 - 화면: $screen, 데이터: $arguments');
          Get.offAllNamed(AppRoutes.complete, arguments: arguments);
        }
      }
    } catch (e) {
      print('메시지 네비게이션 처리 중 오류 발생: $e');
    }
  }

  // 화면 변경 감지를 위한 메서드 추가
  void updateCurrentScreen(String route) {
    _currentScreen = route;
    print('현재 화면 업데이트: $_currentScreen');
  }
}

// 백그라운드 메시지 핸들러 (최상위 레벨 함수여야 함)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('백그라운드 메시지 수신: ${message.notification?.title}');

  // 백그라운드에서는 FCM이 자동으로 알림을 표시하므로
  // 추가적인 로컬 알림은 필요하지 않습니다
  // 주로 데이터 처리나 로깅만 수행
}
