import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../file_select/file_select_controller.dart';

class NotificationSubscribeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fileSelectController = Get.find<FileSelectController>();
    
    return Column(
      children: [
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
    );
  }
}
