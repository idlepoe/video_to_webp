import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
