import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
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
        },
        'ko_KR': {
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
          'notification_subscribe': '변환 완료시 알림 받기',
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

          // Convert Complete
          'image_load_failed': 'Image load failed',
        },
        'es': {
          // App Basic
          'app_title': 'WebP Me!',
          'select_video': 'Seleccionar Video',
          'convert': 'Convertir',
          'cancel': 'Cancelar',
          'other_video': 'Otro Video',
          'converting': 'Convirtiendo...',
          'conversion_complete': '¡La conversión está completa!',
          'download': 'Descargar',
          'continue': 'Continuar',
          'confirm': 'Confirmar',
          'get_started': 'Comenzar',

          // Status Messages
          'success': 'Éxito',
          'error': 'Error',
          'warning': 'Advertencia',
          'info': 'Información',
          'failure': 'Fallo',

          // Video Settings
          'fps': 'FPS',
          'quality': 'Calidad',
          'resolution': 'Resolución',
          'playback_speed': 'Velocidad de Reproducción',
          'estimated_file_size': 'Tamaño Estimado del Archivo: @size',
          'convert_options': 'Opciones de Conversión',

          // File Operations
          'uploading': 'Subiendo...',
          'saved_to_gallery': 'Guardado en la galería.',
          'failed_to_save': 'Error al guardar en la galería.',
          'download_error': 'Ocurrió un error durante la descarga: ',
          'no_download_link': 'No hay enlace de descarga disponible.',
          'browser_open_error': 'Error al abrir el navegador: ',
          'tap_to_select': 'Toca para seleccionar',
          'file_select_prompt':
              '¡Por favor selecciona un archivo de video para convertir! 🎬',

          // Privacy & Consent
          'welcome_title': '¡Bienvenido a WebP Me!',
          'service_description':
              'Por favor revisa la siguiente información antes de usar nuestro servicio de conversión de video a animación WebP.',
          'data_processing_info': 'Información de Procesamiento de Datos',
          'data_processing_details':
              '• Tu video seleccionado será subido temporalmente a nuestros servidores para conversión\n• Los videos originales se eliminan automáticamente dentro de 24 horas después de la conversión\n• No se recopila información personal y todo el procesamiento es anónimo',
          'terms_agreement': 'Acepto los Términos de Servicio',
          'privacy_agreement': 'Acepto la Política de Privacidad',
          'view_privacy_policy': 'Ver Política de Privacidad',
          'privacy_policy_title': 'Política de Privacidad',
          'privacy_policy_content':
              'La aplicación WebP Me! prioriza la protección de la privacidad del usuario.\n\n1. Información Recopilada\n• No se recopila información personal\n• Los archivos de video se usan temporalmente solo para propósitos de conversión\n\n2. Propósito del Uso de la Información\n• Proporcionar servicios de conversión de video a formato WebP\n• No se usa para ningún otro propósito\n\n3. Período de Retención de la Información\n• Se elimina automáticamente dentro de 24 horas después de la conversión\n• Todos los archivos se eliminan diariamente a las 00:00\n\n4. Compartir Información\n• No se comparte con terceros\n• Solo se proporciona cuando es legalmente requerido\n\nContacto: idlepoe@gmail.com',

          // File Size & Limits
          'privacy_file_limits': 'Privacidad y Límites de Archivos',
          'file_limit_info':
              '• Tamaño máximo de archivo: 20MB (debido a costos de procesamiento)\n• Tu video será procesado de forma segura y eliminado automáticamente después de la conversión\n• No se recopila información personal',
          'file_size_error':
              'Los videos más grandes que 20MB no pueden ser procesados debido a los costos de procesamiento. Por favor selecciona un video más pequeño.',
          'secure_processing_info':
              'Tu video será procesado de forma segura y eliminado automáticamente después de la conversión.',

          // Loading & Progress
          'progress_estimate':
              'La barra de progreso es una estimación. La velocidad real de conversión puede variar.',
          'still_working': '¡Todavía trabajando duro en tu video! 🚀',
          'server_conversion_warning':
              'Si el proceso no progresa por un período extendido, puede haber problemas de conversión en el servidor.',
          'conversion_timeout':
              'La conversión está tomando más tiempo del esperado',
          'timeout_reason':
              'Esto podría deberse a la carga del servidor o al tamaño del archivo. Por favor espera un poco más.',
          'server_issues': 'El servidor puede estar experimentando problemas',
          'server_issues_advice':
              'Si la conversión no progresa, intenta de nuevo con diferentes configuraciones (resolución más baja, calidad o FPS).',
          'try_different_settings': 'Probar Configuraciones Diferentes',
          'retry_different_settings':
              'Por favor intenta de nuevo con diferentes configuraciones de conversión.',

          // Auto Download
          'auto_download': 'Descarga Automática',
          'starting_download': 'Iniciando descarga automática...',
          'auto_downloading': 'Descargando automáticamente a la galería...',
          'downloaded_complete': '¡Descargado a la galería!',
          'file_ready': 'El archivo está listo para descargar',
          'already_downloaded': 'Ya descargado',
          're_download': 'Re-descargar',
          'browser': 'Navegador',
          'convert_another': 'Convertir Otro Video',
          'conversion_success': 'Conversión Exitosa',
          'converted_file_size': 'Tamaño del Archivo',
          'opening_browser': 'Abriendo enlace de descarga en el navegador...',

          // File Size Prediction
          'predicting': 'Prediciendo...',
          'predict_converted_size': 'Predecir Tamaño Convertido',
          'predicted_size_result': 'Tamaño Convertido Predicho: @size',
          'prediction_failed': 'Predicción Fallida: @error',

          // File Deletion Notice
          'file_deletion_notice': 'Aviso de Eliminación de Archivos',
          'file_deletion_details':
              'Los archivos subidos se eliminan automáticamente dentro de 24 horas para protección de privacidad.',

          // Video Information
          'file_name': 'Nombre del Archivo: @fileName',
          'video_resolution': 'Resolución: @width x @height',
          'video_duration': 'Duración: @seconds segundos',
          'file_size': 'Tamaño del Archivo: @size',
          'original_resolution': 'original (@width x @height)',
          '720p_resolution': '720p (@width x 720)',
          '480p_resolution': '480p (@width x 480)',
          '320p_resolution': '320p (@width x 320)',
          'original_file_size': 'Tamaño del Archivo Original: @size',

          // Video Trim
          'video_trim': 'Recortar Video',
          'trim_start': 'Inicio: @time',
          'trim_end': 'Fin: @time',
          'trim_start_frame': 'Frame de Inicio',
          'trim_end_frame': 'Frame de Fin',
          'trim_success': 'Recorte Exitoso',
          'trim_applied_message': '¡El video ha sido recortado exitosamente!',
          'trim_error': 'Error de Recorte',
          'trim_error_message':
              'Error al recortar el video. Por favor intenta de nuevo.',
          'restore_original': 'Restaurar Original',
          'no_original_file': 'No se encontró el archivo original.',
          'original_restored': 'El video original ha sido restaurado.',
          'restore_error':
              'Ocurrió un error mientras se restauraba el video original.',
          'complete': 'Completo',
          'start_time': 'Tiempo de Inicio',
          'end_time': 'Tiempo de Fin',
          'processing': 'Procesando...',
          'complete_video_trim': 'Recorte de Video Completo',

          // Error Messages
          'initialization_error':
              'La inicialización no está completa. Por favor intenta de nuevo más tarde.',
          'select_file_error': 'Por favor selecciona un archivo de video.',
          'login_required': 'Se requiere inicio de sesión.',
          'upload_error':
              'Ocurrió un error durante la subida del archivo. Por favor intenta de nuevo.',
          'conversion_error': 'Ocurrió un error durante la conversión.',
          'conversion_complete_notification':
              '¡Conversión de video completada!',
          'notification_permission_required':
              'Se requiere permiso de notificación para notificaciones push.',
          'convert_complete_title': 'Conversión Completa',
          'convert_complete_message':
              '¡Tu video ha sido convertido exitosamente a WebP!',
          'notification_subscribe':
              'Recibir notificación cuando la conversión esté completa',
          'notification_subscribe_message':
              '¡Siéntete libre de salir! Te notificaremos cuando la conversión esté lista!',

          // Media Scan
          'media_scan_title': 'Actualizar Galería',
          'media_scan_info':
              'Si no puedes encontrar videos descargados recientemente, toca este botón para actualizar tu galería.',
          'refresh_gallery': 'Actualizar Galería',
          'scanning_media_files': 'Escaneando archivos de medios...',
          'media_scan_complete': '¡Actualización de galería completada!',
          'media_scan_failed':
              'Error al actualizar la galería. Por favor intenta de nuevo.',

          // Video Rotate
          'video_rotate': 'Rotar Video',
          'rotate_angle_selection': 'Selección de Ángulo de Rotación',
          'rotate_90_degrees': '90°',
          'rotate_180_degrees': '180°',
          'rotate_270_degrees': '270°',
          'rotate_video': 'Rotar Video',
          'rotate_video_processing': 'Rotando video...',
          'rotate_video_complete': 'El video ha sido rotado @angle°.',
          'rotate_video_error':
              'Ocurrió un error mientras se rotaba el video: @error',
          'rotate_video_ffmpeg_error': 'Falló la ejecución de FFmpeg: @error',
          'rotate_video_file_not_created': 'No se creó el archivo rotado.',
          'rotate_video_unsupported_angle':
              'Ángulo de rotación no soportado: @angle',
          'rotate_video_initializing': 'Inicializando...',
          'rotate_video_preparing_ffmpeg': 'Preparando comando FFmpeg...',
          'rotate_video_processing_ffmpeg': 'Procesando rotación de video...',
          'rotate_video_checking_result': 'Verificando resultado...',
          'rotate_video_complete_status': '¡Completo!',
          'rotate_video_processing_status': 'Procesando...',
          'rotate_video_thumbnail_warning_title':
              '⚠️ Acerca de la Distorsión de Resolución de Video en Pantalla',
          'rotate_video_thumbnail_warning_line1':
              '• La distorsión de resolución que ves al rotar video en pantalla es un problema de visualización de UI',
          'rotate_video_thumbnail_warning_line2':
              '• En realidad, la resolución y calidad original del video se mantienen',
          'rotate_video_thumbnail_warning_line3':
              '• El archivo final procesado por FFmpeg se rota con la misma calidad que el original',
          'rotate_video_audio_preserved':
              'Rota el video por el ángulo seleccionado. El audio original se preserva.',
          'rotate_video_file_size_calculating': 'Calculando tamaño...',
          'rotate_video_play_pause': 'Reproducir/Pausar',
          'rotate_video_rotate_angle': '@angle°',

          // Privacy & Email
          'email_app_open_error':
              'No se puede abrir la aplicación de correo. Por favor contáctanos directamente en @email.',
          'email_query_subject': 'Consulta VideoToWebp',

          // FCM Service
          'fcm_convert_complete_channel': 'Notificación de Conversión Completa',
          'fcm_convert_complete_channel_description':
              'Notificación mostrada cuando la conversión de video está completa',

          // File Select
          'quick_scan': 'Escaneo Rápido',

          // Convert Complete
          'image_load_failed': 'Error al cargar imagen',
        }
      };
}
