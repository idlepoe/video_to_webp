import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loading_controller.dart';
import 'widgets/progress_indicator_widget.dart';
import 'widgets/working_status_widget.dart';
import 'widgets/notification_subscribe_widget.dart';
import 'widgets/info_card_widget.dart';

class LoadingScreen extends GetView<LoadingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: controller.cancelConversion,
        ),
        title: Text(
          'converting'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // 메인 진행률 표시
                  ProgressIndicatorWidget(),

                  SizedBox(height: 40),

                  // 메인 타이틀
                  Text(
                    'converting'.tr,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191F28),
                    ),
                  ),

                  SizedBox(height: 12),

                  // 서브 텍스트
                  Text(
                    'progress_estimate'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7684),
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 32),

                  // 작업 진행 메시지
                  WorkingStatusWidget(),

                  SizedBox(height: 32),

                  // Toss 스타일 알림 체크박스 + 안내문구
                  NotificationSubscribeWidget(),
                ]),

                SizedBox(height: 40),

                // 하단 안내 문구
                InfoCardWidget(),

                SizedBox(height: 16),

                // 취소 버튼
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    onPressed: controller.cancelConversion,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Color(0xFFE9ECEF),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'cancel'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7684),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
