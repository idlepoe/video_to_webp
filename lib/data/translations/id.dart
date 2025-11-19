const Map<String, String> idTranslations = {
  // App Basic
  'app_title': 'WebP Me!',
  'select_video': 'Pilih Video',
  'convert': 'Konversi',
  'cancel': 'Batal',
  'other_video': 'Video Lain',
  'converting': 'Mengkonversi...',
  'conversion_complete': 'Konversi selesai!',
  'download': 'Unduh',
  'continue': 'Lanjutkan',
  'confirm': 'Konfirmasi',
  'get_started': 'Mulai',

  // Status Messages
  'success': 'Berhasil',
  'error': 'Error',
  'warning': 'Peringatan',
  'info': 'Informasi',
  'failure': 'Gagal',

  // Video Settings
  'fps': 'FPS',
  'quality': 'Kualitas',
  'resolution': 'Resolusi',
  'playback_speed': 'Kecepatan Pemutaran',
  'estimated_file_size': 'Perkiraan Ukuran File: @size',
  'convert_options': 'Opsi Konversi',

  // File Operations
  'uploading': 'Mengunggah...',
  'saved_to_gallery': 'Disimpan ke galeri.',
  'failed_to_save': 'Gagal menyimpan ke galeri.',
  'download_error': 'Terjadi kesalahan saat mengunduh: ',
  'no_download_link': 'Tidak ada tautan unduhan yang tersedia.',
  'browser_open_error': 'Gagal membuka browser: ',
  'tap_to_select': 'Ketuk untuk memilih',
  'file_select_prompt': 'Silakan pilih file video untuk dikonversi! 🎬',

  // Privacy & Consent
  'welcome_title': 'Selamat datang di WebP Me!',
  'service_description':
      'Silakan tinjau informasi berikut sebelum menggunakan layanan konversi video ke animasi WebP kami.',
  'data_processing_info': 'Informasi Pemrosesan Data',
  'data_processing_details':
      '• Video yang Anda pilih akan diunggah sementara ke server kami untuk konversi\n• Video asli akan dihapus otomatis dalam 24 jam setelah konversi\n• Tidak ada informasi pribadi yang dikumpulkan dan semua pemrosesan bersifat anonim',
  'terms_agreement': 'Saya setuju dengan Ketentuan Layanan',
  'privacy_agreement': 'Saya setuju dengan Kebijakan Privasi',
  'view_privacy_policy': 'Lihat Kebijakan Privasi',
  'privacy_policy_title': 'Kebijakan Privasi',
  'privacy_policy_content':
      'Aplikasi WebP Me! memprioritaskan perlindungan privasi pengguna.\n\n1. Informasi yang Dikumpulkan\n• Tidak mengumpulkan informasi pribadi\n• File video hanya digunakan sementara untuk tujuan konversi\n\n2. Tujuan Penggunaan Informasi\n• Menyediakan layanan konversi video ke format WebP\n• Tidak digunakan untuk tujuan lain\n\n3. Periode Penyimpanan Informasi\n• Dihapus otomatis dalam 24 jam setelah konversi\n• Semua file dihapus setiap hari pada pukul 00:00\n\n4. Berbagi Informasi\n• Tidak dibagikan dengan pihak ketiga\n• Hanya disediakan jika diperlukan secara hukum\n\nKontak: idlepoe@gmail.com',

  // File Size & Limits
  'privacy_file_limits': 'Privasi & Batas File',
  'file_limit_info':
      '• Ukuran file maksimal: 20MB (karena batasan biaya pemrosesan)\n• Video Anda akan diproses dengan aman dan dihapus otomatis setelah konversi\n• Tidak ada informasi pribadi yang dikumpulkan',
  'file_size_error':
      'Video yang lebih besar dari 20MB tidak dapat diproses karena biaya pemrosesan. Silakan pilih video yang lebih kecil.',
  'secure_processing_info':
      'Video Anda akan diproses dengan aman dan dihapus otomatis setelah konversi.',

  // Loading & Progress
  'progress_estimate':
      'Bar kemajuan adalah perkiraan. Kecepatan konversi aktual mungkin berbeda.',
  'still_working': 'Masih bekerja keras mengkonversi video Anda! 🚀',
  'server_conversion_warning':
      'Jika proses tidak berjalan dalam waktu lama, mungkin ada masalah konversi server.',
  'conversion_timeout': 'Konversi memakan waktu lebih lama dari yang diharapkan',
  'timeout_reason':
      'Ini mungkin karena beban server atau ukuran file. Silakan tunggu sebentar lagi.',
  'server_issues': 'Server mungkin mengalami masalah',
  'server_issues_advice':
      'Jika konversi tidak berjalan, coba lagi dengan pengaturan yang berbeda (resolusi, kualitas, atau FPS yang lebih rendah).',
  'try_different_settings': 'Coba Pengaturan Berbeda',
  'retry_different_settings': 'Silakan coba lagi dengan pengaturan konversi yang berbeda.',

  // Auto Download
  'auto_download': 'Unduh Otomatis',
  'starting_download': 'Memulai unduhan otomatis...',
  'auto_downloading': 'Mengunduh otomatis ke galeri...',
  'downloaded_complete': 'Diunduh ke galeri!',
  'file_ready': 'File siap untuk diunduh',
  'already_downloaded': 'Sudah diunduh',
  're_download': 'Unduh Ulang',
  'browser': 'Browser',
  'convert_another': 'Konversi Video Lain',
  'conversion_success': 'Konversi Berhasil',
  'converted_file_size': 'Ukuran File',
  'opening_browser': 'Membuka tautan unduhan di browser...',

  // File Size Prediction
  'predicting': 'Memprediksi...',
  'predict_converted_size': 'Prediksi Ukuran Setelah Konversi',
  'predicted_size_result': 'Perkiraan Ukuran Setelah Konversi: @size',
  'prediction_failed': 'Prediksi Gagal: @error',

  // File Deletion Notice
  'file_deletion_notice': 'Pemberitahuan Penghapusan File',
  'file_deletion_details':
      'File yang diunggah akan dihapus otomatis dalam 24 jam untuk perlindungan privasi.',

  // Video Information
  'file_name': 'Nama File: @fileName',
  'video_resolution': 'Resolusi: @width x @height',
  'video_duration': 'Durasi: @seconds detik',
  'file_size': 'Ukuran File: @size',
  'original_resolution': 'Asli (@width x @height)',
  '720p_resolution': '720p (@width x 720)',
  '480p_resolution': '480p (@width x 480)',
  '320p_resolution': '320p (@width x 320)',
  'original_file_size': 'Ukuran File Asli: @size',

  // Video Trim
  'video_trim': 'Potong Video',
  'trim_start': 'Mulai: @time',
  'trim_end': 'Selesai: @time',
  'trim_start_frame': 'Frame Mulai',
  'trim_end_frame': 'Frame Akhir',
  'trim_success': 'Potong Berhasil',
  'trim_applied_message': 'Video berhasil dipotong!',
  'trim_error': 'Error Potong',
  'trim_error_message': 'Gagal memotong video. Silakan coba lagi.',
  'restore_original': 'Kembalikan Asli',
  'no_original_file': 'File asli tidak ditemukan.',
  'original_restored': 'Video asli telah dikembalikan.',
  'restore_error': 'Terjadi kesalahan saat mengembalikan video asli.',
  'complete': 'Selesai',
  'start_time': 'Waktu Mulai',
  'end_time': 'Waktu Akhir',
  'processing': 'Memproses...',
  'complete_video_trim': 'Potong Video Selesai',

  // Error Messages
  'initialization_error': 'Inisialisasi belum selesai. Silakan coba lagi nanti.',
  'select_file_error': 'Silakan pilih file video.',
  'login_required': 'Login diperlukan.',
  'upload_error': 'Terjadi masalah saat mengunggah file. Silakan coba lagi.',
  'conversion_error': 'Terjadi kesalahan saat konversi.',
  'conversion_complete_notification': 'Konversi video selesai!',
  'notification_permission_required': 'Izin notifikasi diperlukan untuk notifikasi push.',
  'convert_complete_title': 'Konversi Selesai',
  'convert_complete_message': 'Video Anda berhasil dikonversi ke WebP!',
  'notification_subscribe': 'Dapatkan notifikasi konversi',
  'notification_subscribe_message': 'Silakan keluar! Kami akan memberi tahu Anda ketika konversi selesai!',

  // Media Scan
  'media_scan_title': 'Refresh Galeri',
  'media_scan_info': 'Jika Anda tidak dapat menemukan video yang baru diunduh, ketuk tombol ini untuk me-refresh galeri Anda.',
  'refresh_gallery': 'Refresh Galeri',
  'scanning_media_files': 'Memindai file media...',
  'media_scan_complete': 'Refresh galeri selesai!',
  'media_scan_failed': 'Refresh galeri gagal. Silakan coba lagi.',

  // Video Rotate
  'video_rotate': 'Putar Video',
  'rotate_angle_selection': 'Pilihan Sudut Putar',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video': 'Putar Video',
  'rotate_video_processing': 'Memutar video...',
  'rotate_video_complete': 'Video telah diputar @angle°.',
  'rotate_video_error': 'Terjadi kesalahan saat memutar video: @error',
  'rotate_video_ffmpeg_error': 'Eksekusi FFmpeg gagal: @error',
  'rotate_video_file_not_created': 'File yang diputar tidak dibuat.',
  'rotate_video_unsupported_angle': 'Sudut putar tidak didukung: @angle',
  'rotate_video_initializing': 'Menginisialisasi...',
  'rotate_video_preparing_ffmpeg': 'Menyiapkan perintah FFmpeg...',
  'rotate_video_processing_ffmpeg': 'Memproses putaran video...',
  'rotate_video_checking_result': 'Memeriksa hasil...',
  'rotate_video_complete_status': 'Selesai!',
  'rotate_video_processing_status': 'Memproses...',
  'rotate_video_thumbnail_warning_title': '⚠️ Tentang Distorsi Resolusi Video di Layar',
  'rotate_video_thumbnail_warning_line1': '• Distorsi resolusi yang Anda lihat saat memutar video di layar adalah masalah tampilan UI',
  'rotate_video_thumbnail_warning_line2': '• Sebenarnya, resolusi dan kualitas video asli dipertahankan',
  'rotate_video_thumbnail_warning_line3': '• File akhir yang diproses oleh FFmpeg diputar dengan kualitas yang sama dengan aslinya',
  'rotate_video_audio_preserved': 'Putar video dengan sudut yang dipilih. Audio asli dipertahankan.',
  'rotate_video_file_size_calculating': 'Menghitung ukuran...',
  'rotate_video_play_pause': 'Putar/Jeda',
  'rotate_video_rotate_angle': '@angle°',

  // Privacy & Email
  'email_app_open_error': 'Tidak dapat membuka aplikasi email. Silakan hubungi kami langsung di @email.',
  'email_query_subject': 'Pertanyaan VideoToWebp',

  // FCM Service
  'fcm_convert_complete_channel': 'Notifikasi Konversi Selesai',
  'fcm_convert_complete_channel_description': 'Notifikasi yang ditampilkan ketika konversi video selesai',

  // File Select
  'quick_scan': 'Pindai Cepat',
  'scan_method_selection': 'Pilihan Metode Pindai',
  'quick_scan_option': 'Pindai Cepat',
  'quick_scan_subtitle': 'Pindai folder utama saja dengan cepat',
  'hybrid_scan_option': 'Pindai Hibrida',
  'hybrid_scan_subtitle': 'Jalur tetap + Eksplorasi dinamis (Direkomendasikan)',
  'full_scan_option': 'Pindai Lengkap',
  'full_scan_subtitle': 'Pindai semua jalur yang mungkin secara menyeluruh',
  'cancel_button': 'Batal',
  'scan_options': 'Opsi Pindai',
  'scanning_in_progress': 'Memindai...',
  'quick_scan_default_value': 'Pindai Cepat',
  'fixed_path_scan_start_progress': 'Memulai pindai jalur tetap...',
  'fixed_path_scanning_progress': 'Memindai jalur tetap: @folder',
  'skip_folder_progress': 'Lewati: @folder',
  'error_folder_progress': 'Error: @folder',
  'fixed_path_scan_complete_progress': 'Pindai jalur tetap selesai! @count folder berhasil',
  'media_scan_preparing': 'Menyiapkan pindai media...',
  'media_scan_complete_status': 'Pindai media selesai!',
  'media_scan_error_status': 'Error pindai: @error',
  'dynamic_directory_exploration_start_progress': 'Memulai eksplorasi direktori dinamis...',
  'dynamic_exploration_progress': 'Eksplorasi dinamis: @dir',
  'dynamic_exploration_complete_progress': 'Eksplorasi dinamis selesai! @found folder video ditemukan',
  'dynamic_exploration_error_progress': 'Error eksplorasi dinamis: @error',
  'sample_file_save_failed_error': 'Gagal menyimpan file sampel',
  'login_required_error': 'Login diperlukan.',
  'sample_conversion_failed_error': 'Konversi sampel gagal.',
  'sample_conversion_monitoring_error': 'Error pemantauan konversi sampel: @error',
  'sample_conversion_timeout_error': 'Timeout konversi sampel.',
  'sample_conversion_error': 'Terjadi error dalam konversi sampel: @error',

  // Convert Complete
  'image_load_failed': 'Gagal memuat gambar',

  // Premium Subscription
  'premium_upgrade_title': 'Tingkatkan ke Premium',
  'premium_benefit_remove_ads_title': 'Hapus Semua Iklan',
  'premium_benefit_remove_ads_desc': 'Semua iklan interstisial dan banner akan dihapus',
  'premium_benefit_upload_capacity_title': 'Kapasitas Upload Meningkat',
  'premium_benefit_upload_capacity_desc': 'Kapasitas upload meningkat dari 20MB menjadi 50MB',
  'premium_benefit_server_title': 'Server Berkinerja Tinggi',
  'premium_benefit_server_desc': 'Upgrade dari server 512MiB ke 4096MiB berkinerja tinggi',
  'premium_benefit_priority_title': 'Pemrosesan Prioritas',
  'premium_benefit_priority_desc': 'Permintaan konversi diproses dengan prioritas',
  'premium_subscribe_button': 'Berlangganan',
  'premium_subscribe_button_with_price': 'Berlangganan seharga @price',
  'premium_product_loading': 'Memuat informasi produk...',
  'premium_subscribe_success': 'Langganan Selesai',
  'premium_subscribe_success_message': 'Fitur premium telah diaktifkan.',
  'premium_subscribe_failed': 'Langganan Gagal',
  'premium_subscribe_failed_message': 'Tidak dapat menyelesaikan langganan. Silakan coba lagi.',
  'premium_subscribe_error': 'Error',
  'premium_subscribe_error_message': 'Terjadi kesalahan saat memproses langganan.',
  'premium_restore_button': 'Pulihkan Langganan',
  'premium_restore_success': 'Pemulihan Selesai',
  'premium_restore_success_message': 'Fitur premium telah dipulihkan.',
  'premium_restore_failed': 'Pemulihan Gagal',
  'premium_restore_failed_message': 'Tidak ada riwayat langganan untuk dipulihkan.',
  'premium_restore_error_message': 'Terjadi kesalahan saat memulihkan langganan.',
  'premium_user_tooltip': 'Pengguna Premium',
  'premium_subscribe_tooltip': 'Langganan Premium',
};
