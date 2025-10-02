const Map<String, String> esTranslations = {
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
};


