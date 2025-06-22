import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/common_snackbar.dart';

class ConvertCompleteController extends GetxController {
  final RxString imageUrl = ''.obs;
  final RxString downloadUrl = ''.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final RxBool downloadCompleted = false.obs;

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

    // 자동 다운로드 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoDownload();
    });
  }

  void _startAutoDownload() {
    // 다운로드 URL이 있으면 자동으로 다운로드 시작
    if (downloadUrl.value.isNotEmpty) {
      CommonSnackBar.info(
          'Auto Download'.tr, 'Starting automatic download...'.tr);
      downloadFile();
    }
  }

  Future<void> downloadFile() async {
    final url = downloadUrl.value;
    if (url == null || url.isEmpty) {
      CommonSnackBar.warn('Warning'.tr, 'No download link available.'.tr);
      return;
    }

    try {
      isDownloading.value = true;
      downloadCompleted.value = false;
      final bool? success = await GallerySaver.saveImage(url);
      if (success == true) {
        downloadCompleted.value = true;
        CommonSnackBar.success('Success'.tr, 'Saved to gallery.'.tr);
      } else {
        CommonSnackBar.error('Failure'.tr, 'Failed to save to gallery.'.tr);
      }
    } catch (e) {
      CommonSnackBar.error(
          'Error'.tr, 'An error occurred during download: $e'.tr);
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> openInBrowser() async {
    final url = downloadUrl.value;
    if (url.isEmpty) {
      CommonSnackBar.warn('Warning'.tr, 'No download link available.'.tr);
      return;
    }

    try {
      final uri = Uri.parse(url);
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      CommonSnackBar.info(
          'Browser'.tr, 'Opening download link in browser...'.tr);
    } catch (e) {
      CommonSnackBar.error('Error'.tr, 'Failed to open browser: $e'.tr);
    }
  }
}
