import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_to_webp/firebase_options.dart';
import 'package:video_to_webp/screens/convert_complete/convert_complete_screen.dart';
import 'routes/app_routes.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/file_select/file_select_screen.dart';
import 'screens/loading/loading_screen.dart';
import 'screens/loading/loading_controller.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('Flutter 바인딩 초기화 완료');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase 초기화 성공');

    // LoadingController를 앱 시작 시 put
    Get.put(LoadingController(), permanent: true);

    runApp(MyApp());
  } catch (e, stackTrace) {
    print('초기화 중 오류 발생: $e');
    print('스택 트레이스: $stackTrace');
    // 오류가 발생해도 앱은 실행
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Video to WebP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
        GetPage(name: AppRoutes.fileSelect, page: () => FileSelectScreen()),
        GetPage(name: AppRoutes.loading, page: () => LoadingScreen()),
        GetPage(name: AppRoutes.complete, page: () => ConvertCompleteScreen()),
      ],
    );
  }
}
