import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackBarType { info, warn, success, error }

class CommonSnackBar {
  static void show({
    required String title,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData icon;

    switch (type) {
      case SnackBarType.info:
        backgroundColor = const Color(0xFF2196F3); // 파란색
        icon = Icons.info_outline;
        break;
      case SnackBarType.warn:
        backgroundColor = const Color(0xFFFF9800); // 주황색
        icon = Icons.warning_outlined;
        break;
      case SnackBarType.success:
        backgroundColor = const Color(0xFF4CAF50); // 초록색
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        backgroundColor = const Color(0xFFF44336); // 빨간색
        icon = Icons.error_outline;
        break;
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: Icon(icon, color: textColor, size: 28),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      leftBarIndicatorColor: Colors.white.withOpacity(0.3),
    );
  }

  // 편의 메서드들
  static void info(String title, String message, {Duration? duration}) {
    show(
      title: title,
      message: message,
      type: SnackBarType.info,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void warn(String title, String message, {Duration? duration}) {
    show(
      title: title,
      message: message,
      type: SnackBarType.warn,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void success(String title, String message, {Duration? duration}) {
    show(
      title: title,
      message: message,
      type: SnackBarType.success,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void error(String title, String message, {Duration? duration}) {
    show(
      title: title,
      message: message,
      type: SnackBarType.error,
      duration: duration ?? const Duration(seconds: 5),
    );
  }
}
