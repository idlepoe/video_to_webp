import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ConvertCompleteController extends GetxController {
  final RxString imageUrl = ''.obs;
  final RxString downloadUrl = ''.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args['publicUrl'] != null) {
        imageUrl.value = args['publicUrl'];
      }
      if (args['downloadUrl'] != null) {
        downloadUrl.value = args['downloadUrl'];
      }
    }
  }

  Future<void> downloadFile() async {
    final url = downloadUrl.value;
    if (url == null || url.isEmpty) {
      Get.snackbar('다운로드 오류', '다운로드 링크가 없습니다.');
      return;
    }
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
} 