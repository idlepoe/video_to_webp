import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_to_webp/firebase_options.dart';
import 'package:video_to_webp/screens/convert_complete/convert_complete_screen.dart';
import 'package:video_to_webp/screens/privacy/privacy_consent_screen.dart';
import 'routes/app_routes.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/file_select/file_select_screen.dart';
import 'screens/loading/loading_screen.dart';
import 'screens/loading/loading_controller.dart';
import 'services/fcm_service.dart';
import 'translations.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // LoadingController를 앱 시작 시 put
    Get.put(LoadingController(), permanent: true);

    // FCM 서비스 초기화
    Get.put(FCMService(), permanent: true);

    runApp(MyApp());
  } catch (e, stackTrace) {
    // 오류가 발생해도 앱은 실행
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WebP Me!',
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('ko', 'KR'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
        GetPage(name: AppRoutes.privacy, page: () => PrivacyConsentScreen()),
        GetPage(name: AppRoutes.fileSelect, page: () => FileSelectScreen()),
        GetPage(name: AppRoutes.loading, page: () => LoadingScreen()),
        GetPage(name: AppRoutes.complete, page: () => ConvertCompleteScreen()),
      ],
    );
  }
}
