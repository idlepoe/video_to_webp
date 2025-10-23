import 'package:get/get.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/file_select/file_select_screen.dart';
import '../screens/video_trim/video_trim_screen.dart';
import '../screens/loading/loading_screen.dart';
import '../screens/convert_complete/convert_complete_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.fileSelect,
      page: () => FileSelectScreen(),
    ),
    GetPage(
      name: AppRoutes.videoTrim,
      page: () => VideoTrimScreen(),
    ),
    GetPage(
      name: AppRoutes.loading,
      page: () => LoadingScreen(),
    ),
    GetPage(
      name: AppRoutes.complete,
      page: () => ConvertCompleteScreen(),
    ),
  ];
}
