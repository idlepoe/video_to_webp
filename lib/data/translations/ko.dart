const Map<String, String> koTranslations = {
  // App Basic
  'app_title': 'WebP Me!',
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
  'playback_speed': '재생 속도',
  'estimated_file_size': '예상 파일 크기: @size',
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
  'welcome_title': 'WebP Me!에 오신 것을 환영합니다!',
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
      'WebP Me! 앱은 사용자의 개인정보 보호를 최우선으로 합니다.\n\n1. 수집하는 정보\n• 개인정보를 수집하지 않습니다\n• 비디오 파일은 변환 목적으로만 임시 사용됩니다\n\n2. 정보 사용 목적\n• 비디오를 WebP 형식으로 변환하는 서비스 제공\n• 기타 목적으로는 사용하지 않습니다\n\n3. 정보 보관 기간\n• 변환 완료 후 최대 24시간 이내 자동 삭제\n• 매일 00시에 모든 파일 일괄 삭제\n\n4. 정보 공유\n• 제3자와 공유하지 않습니다\n• 법적 요구사항이 있는 경우에만 제공\n\n문의: idlepoe@gmail.com',

  // File Size & Limits
  'privacy_file_limits': '개인정보 보호 및 파일 제한',
  'file_limit_info':
      '• 최대 파일 크기: 20MB (처리 비용으로 인한 제한)\n• 선택하신 비디오는 안전하게 처리되며 변환 후 자동으로 삭제됩니다\n• 개인정보는 수집하지 않습니다',
  'file_limit_info_premium':
      '• 최대 파일 크기: 50MB (프리미엄 회원)\n• 선택하신 비디오는 안전하게 처리되며 변환 후 자동으로 삭제됩니다\n• 개인정보는 수집하지 않습니다',
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
  'already_downloaded': '이미 다운로드됨',
  're_download': '재다운로드',
  'browser': '브라우저',
  'convert_another': '다른 비디오 변환하기',
  'conversion_success': '변환 성공',
  'converted_file_size': '파일 크기',
  'conversion_time': '변환 시간',
  'opening_browser': '브라우저에서 다운로드 링크를 여는 중...',

  // File Size Prediction
  'predicting': '예측 중...',
  'predict_converted_size': '변환 후 용량 예측',
  'predicted_size_result': '예상 변환 후 용량: @size',
  'prediction_failed': '예측 실패: @error',

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
  'conversion_complete_notification': '비디오 변환이 완료되었습니다!',
  'notification_permission_required': '푸시 알림을 위해 알림 권한이 필요합니다.',
  'convert_complete_title': '변환 완료',
  'convert_complete_message': '비디오가 성공적으로 WebP로 변환되었습니다!',
  'notification_subscribe': '변환 알림 받기',
  'notification_subscribe_message': '잠시 외출하셔도 돼요. 변환이 끝나면 바로 알려드릴게요!',

  // Media Scan
  'media_scan_title': '갤러리 새로고침',
  'media_scan_info': '최근에 다운로드한 비디오를 찾을 수 없다면, 이 버튼을 탭하여 갤러리를 새로고침하세요.',
  'refresh_gallery': '갤러리 새로고침',
  'scanning_media_files': '미디어 파일 스캔 중...',
  'media_scan_complete': '갤러리 새로고침이 완료되었습니다!',
  'media_scan_failed': '갤러리 새로고침에 실패했습니다. 다시 시도해주세요.',

  // Video Rotate
  'video_rotate': '비디오 회전',
  'rotate_angle_selection': '회전 각도 선택',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video': '비디오 회전하기',
  'rotate_video_processing': '비디오 회전 중...',
  'rotate_video_complete': '비디오가 @angle° 회전되었습니다.',
  'rotate_video_error': '비디오 회전 중 오류가 발생했습니다: @error',
  'rotate_video_ffmpeg_error': 'FFmpeg 실행에 실패했습니다: @error',
  'rotate_video_file_not_created': '회전된 파일이 생성되지 않았습니다.',
  'rotate_video_unsupported_angle': '지원하지 않는 회전 각도입니다: @angle',
  'rotate_video_initializing': '초기화 중...',
  'rotate_video_preparing_ffmpeg': 'FFmpeg 명령어 준비 중...',
  'rotate_video_processing_ffmpeg': '비디오 회전 처리 중...',
  'rotate_video_checking_result': '결과 확인 중...',
  'rotate_video_complete_status': '완료!',
  'rotate_video_processing_status': '처리 중...',
  'rotate_video_thumbnail_warning_title':
      '⚠️ 화면에서 보이는 비디오 해상도 깨짐 현상에 대해',
  'rotate_video_thumbnail_warning_line1':
      '• 화면에서 비디오가 회전할 때 해상도가 깨져 보이는 것은 UI 표시상의 문제입니다',
  'rotate_video_thumbnail_warning_line2':
      '• 실제로는 원본 비디오의 해상도와 품질이 그대로 유지됩니다',
  'rotate_video_thumbnail_warning_line3':
      '• FFmpeg로 처리된 최종 파일은 원본과 동일한 품질로 회전됩니다',
  'rotate_video_audio_preserved': '선택한 각도로 비디오를 회전합니다. 원본 오디오는 유지됩니다.',
  'rotate_video_file_size_calculating': '크기 계산 중...',
  'rotate_video_play_pause': '재생/일시정지',
  'rotate_video_rotate_angle': '@angle°',

  // Privacy & Email
  'email_app_open_error': '메일 앱을 열 수 없습니다. @email로 직접 문의해주세요.',
  'email_query_subject': 'VideoToWebp 문의',

  // FCM Service
  'fcm_convert_complete_channel': '변환 완료 알림',
  'fcm_convert_complete_channel_description': '비디오 변환이 완료되었을 때 표시되는 알림',

  // File Select
  'quick_scan': '빠른 스캔',
  'scan_method_selection': '스캔 방식 선택',
  'quick_scan_option': '빠른 스캔',
  'quick_scan_subtitle': '주요 폴더만 빠르게 스캔',
  'hybrid_scan_option': '하이브리드 스캔',
  'hybrid_scan_subtitle': '고정 경로 + 동적 탐색 (권장)',
  'full_scan_option': '전체 스캔',
  'full_scan_subtitle': '모든 가능한 경로를 완전히 스캔',
  'cancel_button': '취소',
  'scan_options': '스캔 옵션',
  'scanning_in_progress': '스캔 중...',
  'quick_scan_default_value': '빠른 스캔',
  'fixed_path_scan_start_progress': '고정 경로 스캔 시작...',
  'fixed_path_scanning_progress': '고정 경로 스캔 중: @folder',
  'skip_folder_progress': '건너뜀: @folder',
  'error_folder_progress': '오류: @folder',
  'fixed_path_scan_complete_progress': '고정 경로 스캔 완료! @count개 폴더 성공',
  'media_scan_preparing': '미디어 스캔 준비 중...',
  'media_scan_complete_status': '미디어 스캔 완료!',
  'media_scan_error_status': '스캔 오류: @error',
  'dynamic_directory_exploration_start_progress': '동적 디렉토리 탐색 시작...',
  'dynamic_exploration_progress': '동적 탐색 중: @dir',
  'dynamic_exploration_complete_progress': '동적 탐색 완료! @found개 비디오 폴더 발견',
  'dynamic_exploration_error_progress': '동적 탐색 오류: @error',
  'sample_file_save_failed_error': '샘플 파일 저장 실패',
  'login_required_error': '로그인이 필요합니다.',
  'sample_conversion_failed_error': '샘플 변환에 실패했습니다.',
  'sample_conversion_monitoring_error': '샘플 변환 모니터링 중 오류: @error',
  'sample_conversion_timeout_error': '샘플 변환 시간이 초과되었습니다.',
  'sample_conversion_error': '샘플 변환 중 오류가 발생했습니다: @error',

  // Convert Complete
  'image_load_failed': 'Image load failed',

  // Premium Subscription
  'premium_upgrade_title': '프리미엄으로 업그레이드',
  'premium_benefit_remove_ads_title': '모든 광고 제거',
  'premium_benefit_remove_ads_desc': '전면 광고와 배너 광고가 모두 제거됩니다',
  'premium_benefit_upload_capacity_title': '업로드 용량 확대',
  'premium_benefit_upload_capacity_desc': '20MB에서 50MB로 업로드 용량이 증가합니다',
  'premium_benefit_server_title': '고성능 서버 사용',
  'premium_benefit_server_desc': '512MiB 서버에서 4096MiB 고성능 서버로 업그레이드',
  'premium_benefit_priority_title': '빠른 변환 처리',
  'premium_benefit_priority_desc': '변환 요청이 우선적으로 처리됩니다',
  'premium_subscribe_button': '구독하기',
  'premium_subscribe_button_with_price': '@price에 구독하기',
  'premium_product_loading': '상품 정보 로딩 중...',
  'premium_subscribe_success': '구독 완료',
  'premium_subscribe_success_message': '프리미엄 기능이 활성화되었습니다.',
  'premium_subscribe_failed': '구독 실패',
  'premium_subscribe_failed_message': '구독을 완료할 수 없습니다. 다시 시도해주세요.',
  'premium_subscribe_error': '오류',
  'premium_subscribe_error_message': '구독 처리 중 오류가 발생했습니다.',
  'premium_restore_button': '구독 복원',
  'premium_restore_success': '복원 완료',
  'premium_restore_success_message': '프리미엄 기능이 복원되었습니다.',
  'premium_restore_failed': '복원 실패',
  'premium_restore_failed_message': '복원할 구독 내역이 없습니다.',
  'premium_restore_error_message': '구독 복원 중 오류가 발생했습니다.',
  'premium_user_tooltip': '프리미엄 사용자',
  'premium_subscribe_tooltip': '프리미엄 구독',
};


