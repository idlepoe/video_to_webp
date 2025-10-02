const Map<String, String> enTranslations = {
  // App Basic
  'app_title': 'WebP Me!',
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
  'playback_speed': 'Playback Speed',
  'estimated_file_size': 'Estimated File Size: @size',
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
  'welcome_title': 'Welcome to WebP Me!',
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
      'The WebP Me! app prioritizes user privacy protection.\n\n1. Information Collected\n• No personal information is collected\n• Video files are used temporarily only for conversion purposes\n\n2. Purpose of Information Use\n• Providing video to WebP format conversion services\n• Not used for any other purposes\n\n3. Information Retention Period\n• Automatically deleted within 24 hours after conversion\n• All files are deleted daily at 00:00\n\n4. Information Sharing\n• Not shared with third parties\n• Only provided when legally required\n\nContact: idlepoe@gmail.com',

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
  'already_downloaded': 'Already downloaded',
  're_download': 'Re-download',
  'browser': 'Browser',
  'convert_another': 'Convert Another Video',
  'conversion_success': 'Conversion Successful',
  'converted_file_size': 'File Size',
  'opening_browser': 'Opening download link in browser...',

  // File Size Prediction
  'predicting': 'Predicting...',
  'predict_converted_size': 'Predict Converted Size',
  'predicted_size_result': 'Predicted Converted Size: @size',
  'prediction_failed': 'Prediction Failed: @error',

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
  'conversion_complete_notification': 'Video conversion completed!',
  'notification_permission_required':
      'Notification permission is required for push notifications.',
  'convert_complete_title': 'Conversion Complete',
  'convert_complete_message':
      'Your video has been successfully converted to WebP!',
  'notification_subscribe':
      'Get notification when conversion is complete',
  'notification_subscribe_message':
      'Feel free to step out! We\'ll notify you when the conversion is done!',

  // Media Scan
  'media_scan_title': 'Gallery Refresh',
  'media_scan_info':
      'If you can\'t find recently downloaded videos, tap this button to refresh your gallery.',
  'refresh_gallery': 'Refresh Gallery',
  'scanning_media_files': 'Scanning media files...',
  'media_scan_complete': 'Gallery refresh completed!',
  'media_scan_failed': 'Gallery refresh failed. Please try again.',

  // Video Rotate
  'video_rotate': 'Video Rotate',
  'rotate_angle_selection': 'Rotate Angle Selection',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video': 'Rotate Video',
  'rotate_video_processing': 'Rotating video...',
  'rotate_video_complete': 'Video has been rotated @angle°.',
  'rotate_video_error':
      'An error occurred while rotating video: @error',
  'rotate_video_ffmpeg_error': 'FFmpeg execution failed: @error',
  'rotate_video_file_not_created': 'Rotated file was not created.',
  'rotate_video_unsupported_angle':
      'Unsupported rotation angle: @angle',
  'rotate_video_initializing': 'Initializing...',
  'rotate_video_preparing_ffmpeg': 'Preparing FFmpeg command...',
  'rotate_video_processing_ffmpeg': 'Processing video rotation...',
  'rotate_video_checking_result': 'Checking result...',
  'rotate_video_complete_status': 'Complete!',
  'rotate_video_processing_status': 'Processing...',
  'rotate_video_thumbnail_warning_title':
      '⚠️ About Video Resolution Distortion on Screen',
  'rotate_video_thumbnail_warning_line1':
      '• The resolution distortion you see when rotating video on screen is a UI display issue',
  'rotate_video_thumbnail_warning_line2':
      '• Actually, the original video resolution and quality are maintained',
  'rotate_video_thumbnail_warning_line3':
      '• The final file processed by FFmpeg is rotated with the same quality as the original',
  'rotate_video_audio_preserved':
      'Rotate video by the selected angle. Original audio is preserved.',
  'rotate_video_file_size_calculating': 'Calculating size...',
  'rotate_video_play_pause': 'Play/Pause',
  'rotate_video_rotate_angle': '@angle°',

  // Privacy & Email
  'email_app_open_error':
      'Cannot open email app. Please contact us directly at @email.',
  'email_query_subject': 'VideoToWebp Inquiry',

  // FCM Service
  'fcm_convert_complete_channel': 'Conversion Complete Notification',
  'fcm_convert_complete_channel_description':
      'Notification displayed when video conversion is complete',

  // File Select
  'quick_scan': 'Quick Scan',

  // Convert Complete
  'image_load_failed': 'Image load failed',
};


