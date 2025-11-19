const Map<String, String> zhTranslations = {
  // App Basic
  'app_title': 'WebP Me!',
  'select_video': '选择视频',
  'convert': '转换',
  'cancel': '取消',
  'other_video': '其他视频',
  'converting': '转换中...',
  'conversion_complete': '转换完成！',
  'download': '下载',
  'continue': '继续',
  'confirm': '确认',
  'get_started': '开始使用',

  // Status Messages
  'success': '成功',
  'error': '错误',
  'warning': '警告',
  'info': '信息',
  'failure': '失败',

  // Video Settings
  'fps': 'FPS',
  'quality': '质量',
  'resolution': '分辨率',
  'playback_speed': '播放速度',
  'estimated_file_size': '预计文件大小: @size',
  'convert_options': '转换选项',

  // File Operations
  'uploading': '上传中...',
  'saved_to_gallery': '已保存到相册。',
  'failed_to_save': '保存到相册失败。',
  'download_error': '下载时发生错误: ',
  'no_download_link': '没有可用的下载链接。',
  'browser_open_error': '打开浏览器失败: ',
  'tap_to_select': '点击选择',
  'file_select_prompt': '请选择要转换的视频文件！🎬',

  // Privacy & Consent
  'welcome_title': '欢迎使用 WebP Me!',
  'service_description':
      '在使用我们的视频转WebP动画服务之前，请查看以下信息。',
  'data_processing_info': '数据处理信息',
  'data_processing_details':
      '• 您选择的视频将临时上传到我们的服务器进行转换\n• 原始视频在转换后24小时内自动删除\n• 不收集个人信息，所有处理都是匿名的',
  'terms_agreement': '我同意服务条款',
  'privacy_agreement': '我同意隐私政策',
  'view_privacy_policy': '查看隐私政策',
  'privacy_policy_title': '隐私政策',
  'privacy_policy_content':
      'WebP Me! 应用优先保护用户隐私。\n\n1. 收集的信息\n• 不收集个人信息\n• 视频文件仅用于转换目的临时使用\n\n2. 信息使用目的\n• 提供视频转WebP格式转换服务\n• 不用于其他目的\n\n3. 信息保存期限\n• 转换完成后24小时内自动删除\n• 每天00:00删除所有文件\n\n4. 信息共享\n• 不与第三方共享\n• 仅在法律要求时提供\n\n联系方式: idlepoe@gmail.com',

  // File Size & Limits
  'privacy_file_limits': '隐私和文件限制',
  'file_limit_info':
      '• 最大文件大小: 20MB (由于处理成本限制)\n• 您的视频将安全处理，转换后自动删除\n• 不收集个人信息',
  'file_limit_info_premium':
      '• 最大文件大小: 50MB (高级会员)\n• 您的视频将安全处理，转换后自动删除\n• 不收集个人信息',
  'file_size_error':
      '由于处理成本，无法处理超过20MB的视频。请选择较小的视频。',
  'secure_processing_info':
      '您的视频将安全处理，转换后自动删除。',

  // Loading & Progress
  'progress_estimate':
      '进度条是估算值。实际转换速度可能有所不同。',
  'still_working': '仍在努力转换您的视频！🚀',
  'server_conversion_warning':
      '如果进程长时间没有进展，可能存在服务器转换问题。',
  'conversion_timeout': '转换时间比预期更长',
  'timeout_reason':
      '这可能是由于服务器负载或文件大小造成的。请稍等片刻。',
  'server_issues': '服务器可能遇到问题',
  'server_issues_advice':
      '如果转换没有进展，请尝试不同的设置（较低的分辨率、质量或FPS）。',
  'try_different_settings': '尝试不同设置',
  'retry_different_settings': '请使用不同的转换设置重试。',

  // Auto Download
  'auto_download': '自动下载',
  'starting_download': '开始自动下载...',
  'auto_downloading': '正在自动下载到相册...',
  'downloaded_complete': '已下载到相册！',
  'file_ready': '文件已准备好下载',
  'already_downloaded': '已下载',
  're_download': '重新下载',
  'browser': '浏览器',
  'convert_another': '转换其他视频',
  'conversion_success': '转换成功',
  'converted_file_size': '文件大小',
  'opening_browser': '正在浏览器中打开下载链接...',

  // File Size Prediction
  'predicting': '预测中...',
  'predict_converted_size': '预测转换后大小',
  'predicted_size_result': '预计转换后大小: @size',
  'prediction_failed': '预测失败: @error',

  // File Deletion Notice
  'file_deletion_notice': '文件删除通知',
  'file_deletion_details':
      '为保护隐私，上传的文件将在24小时内自动删除。',

  // Video Information
  'file_name': '文件名: @fileName',
  'video_resolution': '分辨率: @width x @height',
  'video_duration': '时长: @seconds 秒',
  'file_size': '文件大小: @size',
  'original_resolution': '原始 (@width x @height)',
  '720p_resolution': '720p (@width x 720)',
  '480p_resolution': '480p (@width x 480)',
  '320p_resolution': '320p (@width x 320)',
  'original_file_size': '原始文件大小: @size',

  // Video Trim
  'video_trim': '视频裁剪',
  'trim_start': '开始: @time',
  'trim_end': '结束: @time',
  'trim_start_frame': '开始帧',
  'trim_end_frame': '结束帧',
  'trim_success': '裁剪成功',
  'trim_applied_message': '视频已成功裁剪！',
  'trim_error': '裁剪错误',
  'trim_error_message': '视频裁剪失败。请重试。',
  'restore_original': '恢复原始',
  'no_original_file': '未找到原始文件。',
  'original_restored': '原始视频已恢复。',
  'restore_error': '恢复原始视频时发生错误。',
  'complete': '完成',
  'start_time': '开始时间',
  'end_time': '结束时间',
  'processing': '处理中...',
  'complete_video_trim': '完成视频裁剪',

  // Error Messages
  'initialization_error': '初始化未完成。请稍后重试。',
  'select_file_error': '请选择视频文件。',
  'login_required': '需要登录。',
  'upload_error': '文件上传时发生错误。请重试。',
  'conversion_error': '转换时发生错误。',
  'conversion_complete_notification': '视频转换完成！',
  'notification_permission_required': '推送通知需要通知权限。',
  'convert_complete_title': '转换完成',
  'convert_complete_message': '您的视频已成功转换为WebP！',
  'notification_subscribe': '获取转换通知',
  'notification_subscribe_message': '请随意离开！转换完成后我们会通知您！',

  // Media Scan
  'media_scan_title': '相册刷新',
  'media_scan_info': '如果找不到最近下载的视频，请点击此按钮刷新您的相册。',
  'refresh_gallery': '刷新相册',
  'scanning_media_files': '正在扫描媒体文件...',
  'media_scan_complete': '相册刷新完成！',
  'media_scan_failed': '相册刷新失败。请重试。',

  // Video Rotate
  'video_rotate': '视频旋转',
  'rotate_angle_selection': '旋转角度选择',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video': '旋转视频',
  'rotate_video_processing': '正在旋转视频...',
  'rotate_video_complete': '视频已旋转 @angle°。',
  'rotate_video_error': '旋转视频时发生错误: @error',
  'rotate_video_ffmpeg_error': 'FFmpeg执行失败: @error',
  'rotate_video_file_not_created': '未创建旋转文件。',
  'rotate_video_unsupported_angle': '不支持的旋转角度: @angle',
  'rotate_video_initializing': '初始化中...',
  'rotate_video_preparing_ffmpeg': '准备FFmpeg命令...',
  'rotate_video_processing_ffmpeg': '处理视频旋转...',
  'rotate_video_checking_result': '检查结果...',
  'rotate_video_complete_status': '完成！',
  'rotate_video_processing_status': '处理中...',
  'rotate_video_thumbnail_warning_title': '⚠️ 关于屏幕上视频分辨率失真',
  'rotate_video_thumbnail_warning_line1': '• 在屏幕上旋转视频时看到的分辨率失真是UI显示问题',
  'rotate_video_thumbnail_warning_line2': '• 实际上，原始视频分辨率和质量得到保持',
  'rotate_video_thumbnail_warning_line3': '• FFmpeg处理的最终文件以与原始相同的质量旋转',
  'rotate_video_audio_preserved': '按所选角度旋转视频。保留原始音频。',
  'rotate_video_file_size_calculating': '计算大小中...',
  'rotate_video_play_pause': '播放/暂停',
  'rotate_video_rotate_angle': '@angle°',

  // Privacy & Email
  'email_app_open_error': '无法打开邮件应用。请直接通过 @email 联系我们。',
  'email_query_subject': 'VideoToWebp 咨询',

  // FCM Service
  'fcm_convert_complete_channel': '转换完成通知',
  'fcm_convert_complete_channel_description': '视频转换完成时显示的通知',

  // File Select
  'quick_scan': '快速扫描',
  'scan_method_selection': '扫描方法选择',
  'quick_scan_option': '快速扫描',
  'quick_scan_subtitle': '仅快速扫描主要文件夹',
  'hybrid_scan_option': '混合扫描',
  'hybrid_scan_subtitle': '固定路径 + 动态探索（推荐）',
  'full_scan_option': '完整扫描',
  'full_scan_subtitle': '完全扫描所有可能的路径',
  'cancel_button': '取消',
  'scan_options': '扫描选项',
  'scanning_in_progress': '扫描中...',
  'quick_scan_default_value': '快速扫描',
  'fixed_path_scan_start_progress': '固定路径扫描开始...',
  'fixed_path_scanning_progress': '固定路径扫描中: @folder',
  'skip_folder_progress': '跳过: @folder',
  'error_folder_progress': '错误: @folder',
  'fixed_path_scan_complete_progress': '固定路径扫描完成！@count 个文件夹成功',
  'media_scan_preparing': '准备媒体扫描...',
  'media_scan_complete_status': '媒体扫描完成！',
  'media_scan_error_status': '扫描错误: @error',
  'dynamic_directory_exploration_start_progress': '动态目录探索开始...',
  'dynamic_exploration_progress': '动态探索: @dir',
  'dynamic_exploration_complete_progress': '动态探索完成！发现 @found 个视频文件夹',
  'dynamic_exploration_error_progress': '动态探索错误: @error',
  'sample_file_save_failed_error': '样本文件保存失败',
  'login_required_error': '需要登录。',
  'sample_conversion_failed_error': '样本转换失败。',
  'sample_conversion_monitoring_error': '样本转换监控错误: @error',
  'sample_conversion_timeout_error': '样本转换超时。',
  'sample_conversion_error': '样本转换发生错误: @error',

  // Convert Complete
  'image_load_failed': '图片加载失败',

  // Premium Subscription
  'premium_upgrade_title': '升级到高级版',
  'premium_benefit_remove_ads_title': '移除所有广告',
  'premium_benefit_remove_ads_desc': '所有插屏广告和横幅广告将被移除',
  'premium_benefit_upload_capacity_title': '增加上传容量',
  'premium_benefit_upload_capacity_desc': '上传容量从20MB增加到50MB',
  'premium_benefit_server_title': '高性能服务器',
  'premium_benefit_server_desc': '从512MiB升级到4096MiB高性能服务器',
  'premium_benefit_priority_title': '优先处理',
  'premium_benefit_priority_desc': '转换请求将优先处理',
  'premium_subscribe_button': '订阅',
  'premium_subscribe_button_with_price': '以@price订阅',
  'premium_product_loading': '正在加载产品信息...',
  'premium_subscribe_success': '订阅完成',
  'premium_subscribe_success_message': '高级功能已激活。',
  'premium_subscribe_failed': '订阅失败',
  'premium_subscribe_failed_message': '无法完成订阅。请重试。',
  'premium_subscribe_error': '错误',
  'premium_subscribe_error_message': '处理订阅时发生错误。',
  'premium_restore_button': '恢复订阅',
  'premium_restore_success': '恢复完成',
  'premium_restore_success_message': '高级功能已恢复。',
  'premium_restore_failed': '恢复失败',
  'premium_restore_failed_message': '没有可恢复的订阅历史记录。',
  'premium_restore_error_message': '恢复订阅时发生错误。',
  'premium_user_tooltip': '高级用户',
  'premium_subscribe_tooltip': '高级订阅',
};
