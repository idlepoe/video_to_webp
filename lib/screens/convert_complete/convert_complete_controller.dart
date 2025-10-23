import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/fcm_service.dart';

class ConvertCompleteController extends GetxController {
  final RxString imageUrl = ''.obs;
  final RxString downloadUrl = ''.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final RxBool downloadCompleted = false.obs;
  final RxInt fileSize = 0.obs;
  final RxBool isAlreadyDownloaded = false.obs;

  static const String _downloadHistoryKey = 'download_history';

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

    // 다운로드 URL이 있는 경우 이미 다운로드되었는지 확인
    if (downloadUrl.value.isNotEmpty) {
      _checkDownloadHistory();
    }

    // 자동 다운로드 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoDownload();
    });
  }

  /// 다운로드 기록 확인
  Future<void> _checkDownloadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadHistory = prefs.getStringList(_downloadHistoryKey) ?? [];
      isAlreadyDownloaded.value = downloadHistory.contains(downloadUrl.value);
    } catch (e) {
      print('다운로드 기록 확인 오류: $e');
      isAlreadyDownloaded.value = false;
    }
  }

  /// 다운로드 기록에 URL 추가
  Future<void> _addToDownloadHistory(String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadHistory = prefs.getStringList(_downloadHistoryKey) ?? [];

      // 이미 존재하지 않는 경우에만 추가
      if (!downloadHistory.contains(url)) {
        downloadHistory.add(url);
        await prefs.setStringList(_downloadHistoryKey, downloadHistory);
        print('다운로드 기록에 추가됨: $url');
      }
    } catch (e) {
      print('다운로드 기록 저장 오류: $e');
    }
  }

  void _startAutoDownload() {
    // 다운로드 URL이 있고, 아직 다운로드되지 않은 경우에만 자동 다운로드 시작
    if (downloadUrl.value.isNotEmpty && !isAlreadyDownloaded.value) {
      Fluttertoast.showToast(
        msg: 'starting_download'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
      downloadFile(isAutoDownload: true);
    }
  }

  Future<void> downloadFile({bool isAutoDownload = false}) async {
    final url = downloadUrl.value;
    if (url == null || url.isEmpty) {
      Fluttertoast.showToast(
        msg: 'no_download_link'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    // 자동 다운로드인 경우 이미 다운로드된 URL이면 동작하지 않음
    if (isAutoDownload && isAlreadyDownloaded.value) {
      print('이미 다운로드된 파일입니다: $url');
      return;
    }

    try {
      isDownloading.value = true;
      downloadCompleted.value = false;
      final bool? success = await GallerySaver.saveImage(url);
      if (success == true) {
        downloadCompleted.value = true;
        isAlreadyDownloaded.value = true;

        // 다운로드 기록에 URL 추가
        await _addToDownloadHistory(url);

        Fluttertoast.showToast(
          msg: 'saved_to_gallery'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'failed_to_save'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${'download_error'.tr}${e.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  /// 수동 다운로드 (사용자가 다운로드 버튼을 눌렀을 때)
  Future<void> manualDownload() async {
    await downloadFile(isAutoDownload: false);
  }

  Future<void> openInBrowser() async {
    final url = downloadUrl.value;
    if (url.isEmpty) {
      Fluttertoast.showToast(
        msg: 'no_download_link'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final uri = Uri.parse(url);
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      Fluttertoast.showToast(
        msg: 'opening_browser'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${'browser_open_error'.tr}${e.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
