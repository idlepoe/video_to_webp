import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'convert_complete_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/banner_ad_widget.dart';
import 'widgets/image_preview_widget.dart';
import 'widgets/file_info_widget.dart';
import 'widgets/file_deletion_notice_widget.dart';
import 'widgets/download_status_widget.dart';
import 'widgets/convert_another_button_widget.dart';

class ConvertCompleteScreen extends StatelessWidget {
  final controller = Get.put(ConvertCompleteController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(AppRoutes.splash);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Get.offAllNamed(AppRoutes.splash),
            ),
            title: Text(
              'conversion_complete'.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 메인 타이틀
                  Text(
                    'conversion_complete'.tr,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191F28),
                    ),
                  ),

                  SizedBox(height: 8),

                  // 서브 텍스트
                  Text(
                    'file_ready'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7684),
                    ),
                  ),

                  SizedBox(height: 32),

                  // 이미지 미리보기
                  ImagePreviewWidget(controller: controller),

                  SizedBox(height: 16),

                  // 파일 정보 표시
                  FileInfoWidget(controller: controller),

                  SizedBox(height: 16),

                  // 파일 삭제 안내
                  FileDeletionNoticeWidget(),

                  SizedBox(height: 24),

                  // 다운로드 상태 표시
                  DownloadStatusWidget(controller: controller),

                  SizedBox(height: 24),

                  // 배너 광고
                  BannerAdWidget(),

                  SizedBox(height: 16),

                  // 다른 비디오 변환하기 버튼
                  ConvertAnotherButtonWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
