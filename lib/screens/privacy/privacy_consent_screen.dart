import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../routes/app_routes.dart';
import '../../translations.dart';

class PrivacyConsentScreen extends StatefulWidget {
  @override
  _PrivacyConsentScreenState createState() => _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends State<PrivacyConsentScreen> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 제목
              Text(
                'welcome_title'.tr,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 16),

              // 설명
              Text(
                'service_description'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // 데이터 처리 안내
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF4CAF50),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'data_processing_info'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'data_processing_details'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 동의 체크박스들
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 이용약관 동의
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _termsAccepted = !_termsAccepted;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (value) {
                              setState(() {
                                _termsAccepted = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF4CAF50),
                          ),
                          Expanded(
                            child: Text(
                              'terms_agreement'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 개인정보 처리방침 동의
                    Row(
                      children: [
                        Checkbox(
                          value: _privacyAccepted,
                          onChanged: (value) {
                            setState(() {
                              _privacyAccepted = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF4CAF50),
                        ),
                        Expanded(
                          child: Text(
                            'privacy_agreement'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 개인정보 처리방침 보기 버튼
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showPrivacyPolicy,
                        icon: const Icon(Icons.description_outlined, size: 20),
                        label: Text('view_privacy_policy'.tr),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFF4CAF50)),
                          foregroundColor: const Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 시작하기 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_termsAccepted && _privacyAccepted)
                      ? _acceptAndContinue
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'get_started'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('privacy_policy_title'.tr),
          content: SingleChildScrollView(
            child: _buildPrivacyPolicyContent(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('confirm'.tr),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrivacyPolicyContent() {
    final content = 'privacy_policy_content'.tr;
    final emailAddress = 'idlepoe@gmail.com';
    final parts = content.split(emailAddress);

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          height: 1.5,
          color: Colors.black,
          fontSize: 14,
        ),
        children: [
          if (parts.isNotEmpty) TextSpan(text: parts[0]),
          if (parts.length > 1) ...[
            WidgetSpan(
              child: GestureDetector(
                onTap: () => _launchEmail(emailAddress),
                child: Text(
                  emailAddress,
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (parts.length > 1) TextSpan(text: parts[1]),
          ],
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${'email_query_subject'.tr}',
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('email_app_open_error'.trParams({'email': email})),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _acceptAndContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('privacy_consent_given', true);
    Get.offAllNamed('/file_select');
  }
}
