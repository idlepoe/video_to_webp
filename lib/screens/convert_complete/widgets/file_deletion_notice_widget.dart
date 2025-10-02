import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileDeletionNoticeWidget extends StatelessWidget {
  const FileDeletionNoticeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE9ECEF)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Color(0xFF6C757D),
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'file_deletion_details'.tr,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6C757D),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
