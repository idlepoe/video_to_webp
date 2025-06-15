import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';

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
      Get.snackbar('Download Error'.tr, 'No download link available.'.tr);
      return;
    }

    try {
      isDownloading.value = true;
      final bool? success = await GallerySaver.saveImage(url);
      if (success == true) {
        Get.snackbar('Success'.tr, 'Saved to gallery.'.tr);
      } else {
        Get.snackbar('Failure'.tr, 'Failed to save to gallery.'.tr);
      }
    } catch (e) {
      Get.snackbar('Error'.tr, 'An error occurred during download: $e'.tr);
    } finally {
      isDownloading.value = false;
    }
  }
} 