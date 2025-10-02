const Map<String, String> ruTranslations = {
  // App Basic
  'app_title': 'WebP Me!',
  'select_video': 'Выбрать видео',
  'convert': 'Конвертировать',
  'cancel': 'Отмена',
  'other_video': 'Другое видео',
  'converting': 'Конвертация...',
  'conversion_complete': 'Конвертация завершена!',
  'download': 'Скачать',
  'continue': 'Продолжить',
  'confirm': 'Подтвердить',
  'get_started': 'Начать',

  // Status Messages
  'success': 'Успешно',
  'error': 'Ошибка',
  'warning': 'Предупреждение',
  'info': 'Информация',
  'failure': 'Неудача',

  // Video Settings
  'fps': 'FPS',
  'quality': 'Качество',
  'resolution': 'Разрешение',
  'playback_speed': 'Скорость воспроизведения',
  'estimated_file_size': 'Примерный размер файла: @size',
  'convert_options': 'Параметры конвертации',

  // File Operations
  'uploading': 'Загрузка...',
  'saved_to_gallery': 'Сохранено в галерею.',
  'failed_to_save': 'Не удалось сохранить в галерею.',
  'download_error': 'Произошла ошибка при скачивании: ',
  'no_download_link': 'Ссылка для скачивания недоступна.',
  'browser_open_error': 'Не удалось открыть браузер: ',
  'tap_to_select': 'Нажмите для выбора',
  'file_select_prompt': 'Пожалуйста, выберите видеофайл для конвертации! 🎬',

  // Privacy & Consent
  'welcome_title': 'Добро пожаловать в WebP Me!',
  'service_description':
      'Пожалуйста, ознакомьтесь со следующей информацией перед использованием нашего сервиса конвертации видео в WebP анимацию.',
  'data_processing_info': 'Информация об обработке данных',
  'data_processing_details':
      '• Выбранное вами видео будет временно загружено на наши серверы для конвертации\n• Оригинальные видео автоматически удаляются в течение 24 часов после конвертации\n• Личная информация не собирается, и вся обработка анонимна',
  'terms_agreement': 'Я согласен с Условиями обслуживания',
  'privacy_agreement': 'Я согласен с Политикой конфиденциальности',
  'view_privacy_policy': 'Просмотреть Политику конфиденциальности',
  'privacy_policy_title': 'Политика конфиденциальности',
  'privacy_policy_content':
      'Приложение WebP Me! приоритизирует защиту конфиденциальности пользователей.\n\n1. Собираемая информация\n• Личная информация не собирается\n• Видеофайлы используются только временно для целей конвертации\n\n2. Цель использования информации\n• Предоставление сервиса конвертации видео в формат WebP\n• Не используется для других целей\n\n3. Период хранения информации\n• Автоматически удаляется в течение 24 часов после конвертации\n• Все файлы удаляются ежедневно в 00:00\n\n4. Обмен информацией\n• Не передается третьим лицам\n• Предоставляется только при юридической необходимости\n\nКонтакт: idlepoe@gmail.com',

  // File Size & Limits
  'privacy_file_limits': 'Конфиденциальность и ограничения файлов',
  'file_limit_info':
      '• Максимальный размер файла: 20MB (из-за ограничений стоимости обработки)\n• Ваше видео будет безопасно обработано и автоматически удалено после конвертации\n• Личная информация не собирается',
  'file_size_error':
      'Видео размером более 20MB не может быть обработано из-за стоимости обработки. Пожалуйста, выберите видео меньшего размера.',
  'secure_processing_info':
      'Ваше видео будет безопасно обработано и автоматически удалено после конвертации.',

  // Loading & Progress
  'progress_estimate':
      'Полоса прогресса является приблизительной. Фактическая скорость конвертации может отличаться.',
  'still_working': 'Все еще усердно работаем над конвертацией вашего видео! 🚀',
  'server_conversion_warning':
      'Если процесс не продвигается в течение длительного времени, могут быть проблемы с серверной конвертацией.',
  'conversion_timeout': 'Конвертация занимает больше времени, чем ожидалось',
  'timeout_reason':
      'Это может быть связано с нагрузкой на сервер или размером файла. Пожалуйста, подождите еще немного.',
  'server_issues': 'Сервер может испытывать проблемы',
  'server_issues_advice':
      'Если конвертация не продвигается, попробуйте снова с другими настройками (более низкое разрешение, качество или FPS).',
  'try_different_settings': 'Попробовать другие настройки',
  'retry_different_settings': 'Пожалуйста, попробуйте снова с другими настройками конвертации.',

  // Auto Download
  'auto_download': 'Автоматическое скачивание',
  'starting_download': 'Запуск автоматического скачивания...',
  'auto_downloading': 'Автоматическое скачивание в галерею...',
  'downloaded_complete': 'Скачано в галерею!',
  'file_ready': 'Файл готов к скачиванию',
  'already_downloaded': 'Уже скачано',
  're_download': 'Скачать заново',
  'browser': 'Браузер',
  'convert_another': 'Конвертировать другое видео',
  'conversion_success': 'Конвертация успешна',
  'converted_file_size': 'Размер файла',
  'opening_browser': 'Открытие ссылки для скачивания в браузере...',

  // File Size Prediction
  'predicting': 'Прогнозирование...',
  'predict_converted_size': 'Прогноз размера после конвертации',
  'predicted_size_result': 'Предполагаемый размер после конвертации: @size',
  'prediction_failed': 'Прогноз не удался: @error',

  // File Deletion Notice
  'file_deletion_notice': 'Уведомление об удалении файлов',
  'file_deletion_details':
      'Загруженные файлы будут автоматически удалены в течение 24 часов для защиты конфиденциальности.',

  // Video Information
  'file_name': 'Имя файла: @fileName',
  'video_resolution': 'Разрешение: @width x @height',
  'video_duration': 'Длительность: @seconds секунд',
  'file_size': 'Размер файла: @size',
  'original_resolution': 'Оригинал (@width x @height)',
  '720p_resolution': '720p (@width x 720)',
  '480p_resolution': '480p (@width x 480)',
  '320p_resolution': '320p (@width x 320)',
  'original_file_size': 'Оригинальный размер файла: @size',

  // Video Trim
  'video_trim': 'Обрезка видео',
  'trim_start': 'Начало: @time',
  'trim_end': 'Конец: @time',
  'trim_start_frame': 'Начальный кадр',
  'trim_end_frame': 'Конечный кадр',
  'trim_success': 'Обрезка успешна',
  'trim_applied_message': 'Видео успешно обрезано!',
  'trim_error': 'Ошибка обрезки',
  'trim_error_message': 'Не удалось обрезать видео. Пожалуйста, попробуйте снова.',
  'restore_original': 'Восстановить оригинал',
  'no_original_file': 'Оригинальный файл не найден.',
  'original_restored': 'Оригинальное видео восстановлено.',
  'restore_error': 'Произошла ошибка при восстановлении оригинального видео.',
  'complete': 'Завершено',
  'start_time': 'Время начала',
  'end_time': 'Время окончания',
  'processing': 'Обработка...',
  'complete_video_trim': 'Обрезка видео завершена',

  // Error Messages
  'initialization_error': 'Инициализация не завершена. Пожалуйста, попробуйте позже.',
  'select_file_error': 'Пожалуйста, выберите видеофайл.',
  'login_required': 'Требуется вход в систему.',
  'upload_error': 'Произошла проблема при загрузке файла. Пожалуйста, попробуйте снова.',
  'conversion_error': 'Произошла ошибка при конвертации.',
  'conversion_complete_notification': 'Конвертация видео завершена!',
  'notification_permission_required': 'Для push-уведомлений требуется разрешение на уведомления.',
  'convert_complete_title': 'Конвертация завершена',
  'convert_complete_message': 'Ваше видео успешно конвертировано в WebP!',
  'notification_subscribe': 'Получать уведомления о конвертации',
  'notification_subscribe_message': 'Пожалуйста, выходите! Мы уведомим вас, когда конвертация завершится!',

  // Media Scan
  'media_scan_title': 'Обновление галереи',
  'media_scan_info': 'Если вы не можете найти недавно скачанные видео, нажмите эту кнопку для обновления вашей галереи.',
  'refresh_gallery': 'Обновить галерею',
  'scanning_media_files': 'Сканирование медиафайлов...',
  'media_scan_complete': 'Обновление галереи завершено!',
  'media_scan_failed': 'Обновление галереи не удалось. Пожалуйста, попробуйте снова.',

  // Video Rotate
  'video_rotate': 'Поворот видео',
  'rotate_angle_selection': 'Выбор угла поворота',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video': 'Повернуть видео',
  'rotate_video_processing': 'Поворот видео...',
  'rotate_video_complete': 'Видео повернуто на @angle°.',
  'rotate_video_error': 'Произошла ошибка при повороте видео: @error',
  'rotate_video_ffmpeg_error': 'Выполнение FFmpeg не удалось: @error',
  'rotate_video_file_not_created': 'Повернутый файл не создан.',
  'rotate_video_unsupported_angle': 'Неподдерживаемый угол поворота: @angle',
  'rotate_video_initializing': 'Инициализация...',
  'rotate_video_preparing_ffmpeg': 'Подготовка команды FFmpeg...',
  'rotate_video_processing_ffmpeg': 'Обработка поворота видео...',
  'rotate_video_checking_result': 'Проверка результата...',
  'rotate_video_complete_status': 'Завершено!',
  'rotate_video_processing_status': 'Обработка...',
  'rotate_video_thumbnail_warning_title': '⚠️ О искажении разрешения видео на экране',
  'rotate_video_thumbnail_warning_line1': '• Искажение разрешения, которое вы видите при повороте видео на экране, является проблемой отображения UI',
  'rotate_video_thumbnail_warning_line2': '• На самом деле, разрешение и качество оригинального видео сохраняются',
  'rotate_video_thumbnail_warning_line3': '• Финальный файл, обработанный FFmpeg, поворачивается с тем же качеством, что и оригинал',
  'rotate_video_audio_preserved': 'Повернуть видео на выбранный угол. Оригинальный звук сохраняется.',
  'rotate_video_file_size_calculating': 'Вычисление размера...',
  'rotate_video_play_pause': 'Воспроизведение/Пауза',
  'rotate_video_rotate_angle': '@angle°',

  // Privacy & Email
  'email_app_open_error': 'Не удалось открыть приложение электронной почты. Пожалуйста, свяжитесь с нами напрямую по @email.',
  'email_query_subject': 'Запрос VideoToWebp',

  // FCM Service
  'fcm_convert_complete_channel': 'Уведомление о завершении конвертации',
  'fcm_convert_complete_channel_description': 'Уведомление, отображаемое при завершении конвертации видео',

  // File Select
  'quick_scan': 'Быстрое сканирование',
  'scan_method_selection': 'Выбор метода сканирования',
  'quick_scan_option': 'Быстрое сканирование',
  'quick_scan_subtitle': 'Быстрое сканирование только основных папок',
  'hybrid_scan_option': 'Гибридное сканирование',
  'hybrid_scan_subtitle': 'Фиксированные пути + Динамическое исследование (Рекомендуется)',
  'full_scan_option': 'Полное сканирование',
  'full_scan_subtitle': 'Полное сканирование всех возможных путей',
  'cancel_button': 'Отмена',
  'scan_options': 'Параметры сканирования',
  'scanning_in_progress': 'Сканирование...',
  'quick_scan_default_value': 'Быстрое сканирование',
  'fixed_path_scan_start_progress': 'Запуск сканирования фиксированных путей...',
  'fixed_path_scanning_progress': 'Сканирование фиксированных путей: @folder',
  'skip_folder_progress': 'Пропустить: @folder',
  'error_folder_progress': 'Ошибка: @folder',
  'fixed_path_scan_complete_progress': 'Сканирование фиксированных путей завершено! @count папок успешно',
  'media_scan_preparing': 'Подготовка сканирования медиа...',
  'media_scan_complete_status': 'Сканирование медиа завершено!',
  'media_scan_error_status': 'Ошибка сканирования: @error',
  'dynamic_directory_exploration_start_progress': 'Запуск динамического исследования директорий...',
  'dynamic_exploration_progress': 'Динамическое исследование: @dir',
  'dynamic_exploration_complete_progress': 'Динамическое исследование завершено! @found видео папок найдено',
  'dynamic_exploration_error_progress': 'Ошибка динамического исследования: @error',
  'sample_file_save_failed_error': 'Не удалось сохранить файл образца',
  'login_required_error': 'Требуется вход в систему.',
  'sample_conversion_failed_error': 'Конвертация образца не удалась.',
  'sample_conversion_monitoring_error': 'Ошибка мониторинга конвертации образца: @error',
  'sample_conversion_timeout_error': 'Тайм-аут конвертации образца.',
  'sample_conversion_error': 'Произошла ошибка при конвертации образца: @error',

  // Convert Complete
  'image_load_failed': 'Не удалось загрузить изображение',
};
