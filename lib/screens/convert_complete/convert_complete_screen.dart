import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConvertCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final imageUrl = args != null ? args['convertedFile'] as String? : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('변환 완료'),
      ),
      body: Center(
        child: imageUrl == null
            ? Text('이미지 URL이 없습니다.')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    width: 300,
                    height: 300,
                    errorBuilder: (context, error, stackTrace) =>
                        Text('이미지 로드 실패'),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // 다운로드 로직 (웹/모바일 분기 필요)
                      // 예시: 웹에서는 AnchorElement, 모바일은 url_launcher 등 사용
                      // 실제 다운로드 구현은 플랫폼별로 추가 필요
                      Get.snackbar('다운로드', '다운로드 기능은 구현 필요');
                    },
                    icon: Icon(Icons.download),
                    label: Text('다운로드'),
                  ),
                ],
              ),
      ),
    );
  }
} 