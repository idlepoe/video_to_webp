import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackBarType { info, warn, success, error }

class CommonSnackBar {
  static void show({
    required String title,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(milliseconds: 500),
    BuildContext? context,
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

    final targetContext = context ?? Get.context;
    if (targetContext != null) {
      ScaffoldMessenger.of(targetContext).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: textColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  // 편의 메서드들
  static void info(String title, String message, {Duration? duration, BuildContext? context}) {
    show(
      title: title,
      message: message,
      type: SnackBarType.info,
      duration: duration ?? const Duration(milliseconds: 500),
      context: context,
    );
  }

  static void warn(String title, String message, {Duration? duration, BuildContext? context}) {
    show(
      title: title,
      message: message,
      type: SnackBarType.warn,
      duration: duration ?? const Duration(milliseconds: 500),
      context: context,
    );
  }

  static void success(String title, String message, {Duration? duration, BuildContext? context}) {
    show(
      title: title,
      message: message,
      type: SnackBarType.success,
      duration: duration ?? const Duration(milliseconds: 500),
      context: context,
    );
  }

  static void error(String title, String message, {Duration? duration, BuildContext? context}) {
    show(
      title: title,
      message: message,
      type: SnackBarType.error,
      duration: duration ?? const Duration(milliseconds: 500),
      context: context,
    );
  }
}
