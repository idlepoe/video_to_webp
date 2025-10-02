import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../convert_complete_controller.dart';

class DownloadStatusWidget extends StatelessWidget {
  final ConvertCompleteController controller;

  const DownloadStatusWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.isDownloading.value) {
      return _buildDownloadingWidget();
    } else if (controller.isAlreadyDownloaded.value && !controller.downloadCompleted.value) {
      return _buildAlreadyDownloadedWidget();
    } else {
      return _buildDownloadButtonsWidget();
    }
  }

  Widget _buildDownloadingWidget() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF3182F6),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'auto_downloading'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3182F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlreadyDownloadedWidget() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF0F8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: Color(0xFF4CAF50),
            size: 32,
          ),
          SizedBox(height: 16),
          Text(
            'already_downloaded'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButtonsWidget() {
    return Column(
      children: [
        // 다운로드 버튼들
        Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: controller.manualDownload,
                  icon: Icon(
                    controller.downloadCompleted.value
                        ? Icons.download_done
                        : Icons.download,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    controller.isAlreadyDownloaded.value
                        ? 're_download'.tr
                        : controller.downloadCompleted.value
                            ? 're_download'.tr
                            : 'download'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isAlreadyDownloaded.value ||
                            controller.downloadCompleted.value
                        ? Color(0xFF00C851)
                        : Color(0xFF3182F6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: controller.openInBrowser,
                  icon: Icon(
                    Icons.open_in_browser,
                    size: 20,
                    color: Color(0xFF6B7684),
                  ),
                  label: Text(
                    'browser'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7684),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Color(0xFFE9ECEF),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
