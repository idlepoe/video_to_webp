import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          // App Basic
          'app_title': 'Video to WebP',
          'select_video': 'Select Video',
          'convert': 'Convert',
          'cancel': 'Cancel',
          'other_video': 'Other Video',
          'converting': 'Converting...',
          'conversion_complete': 'Conversion is complete!',
          'download': 'Download',
          'continue': 'Continue',
          'confirm': 'Confirm',
          'get_started': 'Get Started',

          // Status Messages
          'success': 'Success',
          'error': 'Error',
          'warning': 'Warning',
          'info': 'Info',
          'failure': 'Failure',

          // Video Settings
          'fps': 'FPS',
          'quality': 'Quality',
          'resolution': 'Resolution',
          'estimated_file_size': 'Estimated File Size: ',
          'convert_options': 'Convert Options',

          // File Operations
          'uploading': 'Uploading...',
          'saved_to_gallery': 'Saved to gallery.',
          'failed_to_save': 'Failed to save to gallery.',
          'download_error': 'An error occurred during download: ',
          'no_download_link': 'No download link available.',
          'browser_open_error': 'Failed to open browser: ',
          'tap_to_select': 'Tap to select',
          'file_select_prompt': 'Please select a video file to convert! 🎬',

          // Privacy & Consent
          'welcome_title': 'Welcome to VideoToWebp!',
          'service_description':
              'Please review the following information before using our video to WebP animation conversion service.',
          'data_processing_info': 'Data Processing Information',
          'data_processing_details':
              '• Your selected video will be temporarily uploaded to our servers for conversion\n• Original videos are automatically deleted within 24 hours after conversion\n• No personal information is collected and all processing is anonymous',
          'terms_agreement': 'I agree to the Terms of Service',
          'privacy_agreement': 'I agree to the Privacy Policy',
          'view_privacy_policy': 'View Privacy Policy',
          'privacy_policy_title': 'Privacy Policy',
          'privacy_policy_content':
              'The VideoToWebp app prioritizes user privacy protection.\n\n1. Information Collected\n• No personal information is collected\n• Video files are used temporarily only for conversion purposes\n\n2. Purpose of Information Use\n• Providing video to WebP format conversion services\n• Not used for any other purposes\n\n3. Information Retention Period\n• Automatically deleted within 24 hours after conversion\n• All files are deleted daily at 00:00\n\n4. Information Sharing\n• Not shared with third parties\n• Only provided when legally required\n\nContact: idlepoe@gmail.com',

          // File Size & Limits
          'privacy_file_limits': 'Privacy & File Limits',
          'file_limit_info':
              '• Maximum file size: 20MB (due to processing costs)\n• Your video will be securely processed and automatically deleted after conversion\n• No personal information is collected',
          'file_size_error':
              'Videos larger than 20MB cannot be processed due to processing costs. Please select a smaller video.',
          'secure_processing_info':
              'Your video will be securely processed and automatically deleted after conversion.',

          // Loading & Progress
          'progress_estimate':
              'The progress bar is an estimate. Actual conversion speed may vary.',
          'still_working': 'Still working hard on your video! 🚀',
          'server_conversion_warning':
              'If the process doesn\'t progress for an extended period, there may be server conversion issues.',
          'conversion_timeout': 'Conversion is taking longer than expected',
          'timeout_reason':
              'This might be due to server load or file size. Please wait a bit longer.',
          'server_issues': 'Server may be experiencing issues',
          'server_issues_advice':
              'If the conversion doesn\'t progress, try again with different settings (lower resolution, quality, or FPS).',
          'try_different_settings': 'Try Different Settings',
          'retry_different_settings':
              'Please try again with different conversion settings.',

          // Auto Download
          'auto_download': 'Auto Download',
          'starting_download': 'Starting automatic download...',
          'auto_downloading': 'Auto downloading to gallery...',
          'downloaded_complete': 'Downloaded to gallery!',
          'file_ready': 'File is ready for download',
          're_download': 'Re-download',
          'browser': 'Browser',
          'convert_another': 'Convert Another Video',
          'opening_browser': 'Opening download link in browser...',

          // File Deletion Notice
          'file_deletion_notice': 'File Deletion Notice',
          'file_deletion_details':
              'Uploaded files are automatically deleted within 24 hours for privacy protection.',

          // Video Information
          'file_name': 'File Name: @fileName',
          'video_resolution': 'Resolution: @width x @height',
          'video_duration': 'Duration: @seconds seconds',
          'file_size': 'File Size: @size',
          'original_resolution': 'original (@width x @height)',
          '720p_resolution': '720p (@width x 720)',
          '480p_resolution': '480p (@width x 480)',
          '320p_resolution': '320p (@width x 320)',
          'original_file_size': 'Original File Size: @size',

          // Video Trim
          'video_trim': 'Video Trim',
          'trim_start': 'Start: @time',
          'trim_end': 'End: @time',
          'trim_start_frame': 'Start Frame',
          'trim_end_frame': 'End Frame',
          'trim_success': 'Trim Success',
          'trim_applied_message': 'Video has been trimmed successfully!',
          'trim_error': 'Trim Error',
          'trim_error_message': 'Failed to trim video. Please try again.',
          'restore_original': 'Restore Original',
          'no_original_file': 'No original file found.',
          'original_restored': 'Original video has been restored.',
          'restore_error':
              'An error occurred while restoring the original video.',
          'complete': 'Complete',
          'start_time': 'Start Time',
          'end_time': 'End Time',
          'processing': 'Processing...',
          'complete_video_trim': 'Complete Video Trim',

          // Error Messages
          'initialization_error':
              'Initialization is not complete. Please try again later.',
          'select_file_error': 'Please select a video file.',
          'login_required': 'Login is required.',
          'upload_error':
              'An error occurred during file upload. Please try again.',
          'conversion_error': 'An error occurred during conversion.',
        },
        'ko_KR': {
          // App Basic
          'app_title': 'Video to WebP',
          'select_video': '비디오 선택',
          'convert': '변환',
          'cancel': '취소',
          'other_video': '다른 비디오',
          'converting': '변환 중...',
          'conversion_complete': '변환이 완료되었습니다!',
          'download': '다운로드',
          'continue': '계속',
          'confirm': '확인',
          'get_started': '시작하기',

          // Status Messages
          'success': '성공',
          'error': '오류',
          'warning': '경고',
          'info': '정보',
          'failure': '실패',

          // Video Settings
          'fps': 'FPS',
          'quality': '품질',
          'resolution': '해상도',
          'estimated_file_size': '예상 파일 크기: ',
          'convert_options': '변환 옵션',

          // File Operations
          'uploading': '업로드 중...',
          'saved_to_gallery': '갤러리에 저장되었습니다.',
          'failed_to_save': '갤러리 저장에 실패했습니다.',
          'download_error': '다운로드 중 오류가 발생했습니다: ',
          'no_download_link': '다운로드 링크를 사용할 수 없습니다.',
          'browser_open_error': '브라우저 열기 실패: ',
          'tap_to_select': '탭하여 선택',
          'file_select_prompt': '변환할 비디오 파일을 선택해주세요! 🎬',

          // Privacy & Consent
          'welcome_title': 'VideoToWebp에 오신 것을 환영합니다!',
          'service_description':
              '비디오를 WebP 애니메이션으로 변환하는 서비스를 이용하기 전에 다음 사항을 확인해주세요.',
          'data_processing_info': '데이터 처리 안내',
          'data_processing_details':
              '• 선택하신 비디오는 변환을 위해 임시로 서버에 업로드됩니다\n• 변환 완료 후 원본 비디오는 최대 24시간 이내에 자동으로 삭제됩니다\n• 개인정보는 수집하지 않으며, 익명으로 처리됩니다',
          'terms_agreement': '서비스 이용약관에 동의합니다',
          'privacy_agreement': '개인정보 처리방침에 동의합니다',
          'view_privacy_policy': '개인정보 처리방침 보기',
          'privacy_policy_title': '개인정보 처리방침',
          'privacy_policy_content':
              'VideoToWebp 앱은 사용자의 개인정보 보호를 최우선으로 합니다.\n\n1. 수집하는 정보\n• 개인정보를 수집하지 않습니다\n• 비디오 파일은 변환 목적으로만 임시 사용됩니다\n\n2. 정보 사용 목적\n• 비디오를 WebP 형식으로 변환하는 서비스 제공\n• 기타 목적으로는 사용하지 않습니다\n\n3. 정보 보관 기간\n• 변환 완료 후 최대 24시간 이내 자동 삭제\n• 매일 00시에 모든 파일 일괄 삭제\n\n4. 정보 공유\n• 제3자와 공유하지 않습니다\n• 법적 요구사항이 있는 경우에만 제공\n\n문의: idlepoe@gmail.com',

          // File Size & Limits
          'privacy_file_limits': '개인정보 보호 및 파일 제한',
          'file_limit_info':
              '• 최대 파일 크기: 20MB (처리 비용으로 인한 제한)\n• 선택하신 비디오는 안전하게 처리되며 변환 후 자동으로 삭제됩니다\n• 개인정보는 수집하지 않습니다',
          'file_size_error':
              '처리 비용으로 인해 20MB보다 큰 비디오는 처리할 수 없습니다. 더 작은 비디오를 선택해주세요.',
          'secure_processing_info': '선택하신 비디오는 안전하게 처리되며 변환 후 자동으로 삭제됩니다.',

          // Loading & Progress
          'progress_estimate': '진행률은 예측값입니다. 실제 변환 속도와 다를 수 있습니다.',
          'still_working': '여전히 열심히 변환 중입니다! 🚀',
          'server_conversion_warning':
              '프로세스가 오랫동안 진행되지 않으면 서버 변환 작업에 문제가 발생했을 가능성이 있습니다.',
          'conversion_timeout': '변환이 예상보다 오래 걸리고 있습니다',
          'timeout_reason': '서버 부하나 파일 크기 때문일 수 있습니다. 조금 더 기다려주세요.',
          'server_issues': '서버에 문제가 발생했을 수 있습니다',
          'server_issues_advice':
              '변환이 진행되지 않으면 다른 설정(낮은 해상도, 품질, FPS)으로 다시 시도해보세요.',
          'try_different_settings': '다른 설정으로 시도',
          'retry_different_settings': '다른 변환 설정으로 다시 시도해주세요.',

          // Auto Download
          'auto_download': '자동 다운로드',
          'starting_download': '자동 다운로드를 시작합니다...',
          'auto_downloading': '갤러리로 자동 다운로드 중...',
          'downloaded_complete': '갤러리에 다운로드 완료!',
          'file_ready': '파일 다운로드 준비 완료',
          're_download': '재다운로드',
          'browser': '브라우저',
          'convert_another': '다른 비디오 변환하기',
          'opening_browser': '브라우저에서 다운로드 링크를 여는 중...',

          // File Deletion Notice
          'file_deletion_notice': '파일 삭제 안내',
          'file_deletion_details': '업로드된 파일은 개인정보 보호를 위해 24시간 이내에 자동으로 삭제됩니다.',

          // Video Information
          'file_name': '파일명: @fileName',
          'video_resolution': '해상도: @width x @height',
          'video_duration': '재생시간: @seconds초',
          'file_size': '파일 크기: @size',
          'original_resolution': '원본 (@width x @height)',
          '720p_resolution': '720p (@width x 720)',
          '480p_resolution': '480p (@width x 480)',
          '320p_resolution': '320p (@width x 320)',
          'original_file_size': '원본 파일 크기: @size',

          // Video Trim
          'video_trim': '비디오 자르기',
          'trim_start': '시작: @time',
          'trim_end': '끝: @time',
          'trim_start_frame': '시작 프레임',
          'trim_end_frame': '종료 프레임',
          'trim_success': '자르기 완료',
          'trim_applied_message': 'Trim 설정이 적용되었습니다. 변환 시 서버에서 처리됩니다.',
          'trim_error': '자르기 오류',
          'trim_error_message': '비디오 자르기 중 오류가 발생했습니다.',
          'restore_original': '원본으로 되돌리기',
          'no_original_file': '원본 파일을 찾을 수 없습니다.',
          'original_restored': '원본 비디오로 복원되었습니다.',
          'restore_error': '원본 비디오 복원 중 오류가 발생했습니다.',
          'complete': '완료',
          'start_time': '시작 시간',
          'end_time': '종료 시간',
          'processing': '처리 중...',
          'complete_video_trim': '비디오 자르기 완료',

          // Error Messages
          'initialization_error': '초기화가 완료되지 않았습니다. 잠시 후 다시 시도해주세요.',
          'select_file_error': '비디오 파일을 선택해주세요.',
          'login_required': '로그인이 필요합니다.',
          'upload_error': '파일 업로드 중 문제가 발생했습니다. 다시 시도해주세요.',
          'conversion_error': '변환 중 오류가 발생했습니다.',
        }
      };
}
