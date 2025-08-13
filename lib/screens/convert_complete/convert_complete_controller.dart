import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/common_snackbar.dart';
import '../../services/fcm_service.dart';

class ConvertCompleteController extends GetxController {
  final RxString imageUrl = ''.obs;
  final RxString downloadUrl = ''.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final RxBool downloadCompleted = false.obs;
  final RxInt fileSize = 0.obs;

  @override
  void onInit() {
    super.onInit();
    
    // FCM 서비스에 현재 화면 알림 (안전하게 처리)
    try {
      if (Get.isRegistered<FCMService>()) {
        final fcmService = Get.find<FCMService>();
        fcmService.updateCurrentScreen('/complete');
      } else {
        print('FCM 서비스가 아직 초기화되지 않았습니다.');
      }
    } catch (e) {
      print('FCM 서비스 접근 오류: $e');
      // FCM 서비스가 없어도 앱은 정상 동작
    }
    
    final args = Get.arguments;
    if (args != null) {
      if (args['publicUrl'] != null) {
        imageUrl.value = args['publicUrl'];
      }
      if (args['downloadUrl'] != null) {
        downloadUrl.value = args['downloadUrl'];
      }
      if (args['fileSize'] != null) {
        fileSize.value = args['fileSize'] is int
            ? args['fileSize']
            : int.tryParse(args['fileSize'].toString()) ?? 0;
      }

      // 푸시 알림으로 전달된 데이터 처리
      print('변환 완료 화면 초기화 - 전달된 데이터: $args');
    }

    // 자동 다운로드 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoDownload();
    });
  }

  void _startAutoDownload() {
    // 다운로드 URL이 있으면 자동으로 다운로드 시작
    if (downloadUrl.value.isNotEmpty) {
      // CommonSnackBar.info('auto_download'.tr, 'starting_download'.tr);
      downloadFile();
    }
  }

  Future<void> downloadFile() async {
    final url = downloadUrl.value;
    if (url == null || url.isEmpty) {
      // CommonSnackBar.warn('warning'.tr, 'no_download_link'.tr);
      return;
    }

    try {
      isDownloading.value = true;
      downloadCompleted.value = false;
      final bool? success = await GallerySaver.saveImage(url);
      if (success == true) {
        downloadCompleted.value = true;
        // CommonSnackBar.success('success'.tr, 'saved_to_gallery'.tr);
      } else {
        // CommonSnackBar.error('failure'.tr, 'failed_to_save'.tr);
      }
    } catch (e) {
      // CommonSnackBar.error('error'.tr, '${'download_error'.tr}${e.toString()}');
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> openInBrowser() async {
    final url = downloadUrl.value;
    if (url.isEmpty) {
      // CommonSnackBar.warn('warning'.tr, 'no_download_link'.tr);
      return;
    }

    try {
      final uri = Uri.parse(url);
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      // CommonSnackBar.info('browser'.tr, 'opening_browser'.tr);
    } catch (e) {
      // CommonSnackBar.error(
      //     'error'.tr, '${'browser_open_error'.tr}${e.toString()}');
    }
  }

  // 파일 크기 포맷팅 함수
  String formatFileSize(int size) {
    if (size < 1024) {
      return "$size bytes";
    } else if (size < 1024 * 1024) {
      return "${(size / 1024).toStringAsFixed(2)} KB";
    } else if (size < 1024 * 1024 * 1024) {
      return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else {
      return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
    }
  }
}
