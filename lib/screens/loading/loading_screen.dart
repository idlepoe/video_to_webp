import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loading_controller.dart';
import '../file_select/file_select_controller.dart';

class LoadingScreen extends GetView<LoadingController> {
  @override
  Widget build(BuildContext context) {
    final fileSelectController = Get.find<FileSelectController>();
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 메인 진행률 표시
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        shape: BoxShape.circle,
                      ),
                      child: Obx(() => Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  value: controller.progress.value / 100,
                                  strokeWidth: 6,
                                  backgroundColor: Color(0xFFE9ECEF),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF3182F6),
                                  ),
                                ),
                              ),
                              Text(
                                '${controller.progress.value}%',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF191F28),
                                ),
                              ),
                            ],
                          )),
                    ),

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
                    Obx(() {
                      if (controller.progress.value < 99) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3182F6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'still_working'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF3182F6),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),

                    SizedBox(height: 32),

                    // Toss 스타일 알림 체크박스 + 안내문구
                    Obx(() => GestureDetector(
                          onTap: () {
                            fileSelectController.setNotificationSubscribed(
                                !fileSelectController
                                    .notificationSubscribed.value);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: fileSelectController
                                            .notificationSubscribed.value
                                        ? Colors.blue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: fileSelectController
                                              .notificationSubscribed.value
                                          ? Colors.blue
                                          : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: fileSelectController
                                          .notificationSubscribed.value
                                      ? Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'notification_subscribe'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    SizedBox(height: 4),
                    Text(
                      'notification_subscribe_message'.tr,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3182F6),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // 하단 안내 문구
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Color(0xFF6B7684),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'info'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF191F28),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'server_conversion_warning'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7684),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

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
    );
  }
}
