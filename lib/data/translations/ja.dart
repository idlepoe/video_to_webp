const Map<String, String> jaTranslations = {
  // App Basic
  'app_title': 'WebP Me!',
  'select_video': '動画を選択',
  'convert': '変換',
  'cancel': 'キャンセル',
  'other_video': '他の動画',
  'converting': '変換中...',
  'conversion_complete': '変換が完了しました！',
  'download': 'ダウンロード',
  'continue': '続行',
  'confirm': '確認',
  'get_started': '始める',

  // Status Messages
  'success': '成功',
  'error': 'エラー',
  'warning': '警告',
  'info': '情報',
  'failure': '失敗',

  // Video Settings
  'fps': 'FPS',
  'quality': '品質',
  'resolution': '解像度',
  'playback_speed': '再生速度',
  'estimated_file_size': '推定ファイルサイズ: @size',
  'convert_options': '変換オプション',

  // File Operations
  'uploading': 'アップロード中...',
  'saved_to_gallery': 'ギャラリーに保存されました。',
  'failed_to_save': 'ギャラリーへの保存に失敗しました。',
  'download_error': 'ダウンロード中にエラーが発生しました: ',
  'no_download_link': 'ダウンロードリンクが利用できません。',
  'browser_open_error': 'ブラウザを開くのに失敗しました: ',
  'tap_to_select': 'タップして選択',
  'file_select_prompt': '変換する動画ファイルを選択してください！🎬',

  // Privacy & Consent
  'welcome_title': 'WebP Me!へようこそ！',
  'service_description':
      '動画をWebPアニメーションに変換するサービスをご利用になる前に、以下の情報をご確認ください。',
  'data_processing_info': 'データ処理情報',
  'data_processing_details':
      '• 選択された動画は変換のために一時的にサーバーにアップロードされます\n• 元の動画は変換後24時間以内に自動的に削除されます\n• 個人情報は収集されず、すべての処理は匿名で行われます',
  'terms_agreement': '利用規約に同意します',
  'privacy_agreement': 'プライバシーポリシーに同意します',
  'view_privacy_policy': 'プライバシーポリシーを表示',
  'privacy_policy_title': 'プライバシーポリシー',
  'privacy_policy_content':
      'WebP Me!アプリはユーザーのプライバシー保護を最優先にします。\n\n1. 収集する情報\n• 個人情報は収集しません\n• 動画ファイルは変換目的でのみ一時的に使用されます\n\n2. 情報使用目的\n• 動画をWebP形式に変換するサービス提供\n• その他の目的では使用しません\n\n3. 情報保存期間\n• 変換完了後24時間以内に自動削除\n• 毎日00:00にすべてのファイルを一括削除\n\n4. 情報共有\n• 第三者と共有しません\n• 法的要件がある場合のみ提供\n\nお問い合わせ: idlepoe@gmail.com',

  // File Size & Limits
  'privacy_file_limits': 'プライバシーとファイル制限',
  'file_limit_info':
      '• 最大ファイルサイズ: 20MB（処理コストによる制限）\n• 選択された動画は安全に処理され、変換後に自動削除されます\n• 個人情報は収集しません',
  'file_limit_info_premium':
      '• 最大ファイルサイズ: 50MB（プレミアム会員）\n• 選択された動画は安全に処理され、変換後に自動削除されます\n• 個人情報は収集しません',
  'file_size_error':
      '処理コストにより、20MBより大きい動画は処理できません。より小さな動画を選択してください。',
  'secure_processing_info':
      '選択された動画は安全に処理され、変換後に自動削除されます。',

  // Loading & Progress
  'progress_estimate':
      'プログレスバーは推定値です。実際の変換速度は異なる場合があります。',
  'still_working': 'まだ動画の変換に頑張って取り組んでいます！🚀',
  'server_conversion_warning':
      'プロセスが長時間進行しない場合、サーバー変換の問題が発生している可能性があります。',
  'conversion_timeout': '変換が予想より時間がかかっています',
  'timeout_reason':
      'サーバーの負荷やファイルサイズが原因の可能性があります。もう少しお待ちください。',
  'server_issues': 'サーバーに問題が発生している可能性があります',
  'server_issues_advice':
      '変換が進行しない場合は、異なる設定（低い解像度、品質、FPS）で再試行してください。',
  'try_different_settings': '異なる設定を試す',
  'retry_different_settings': '異なる変換設定で再試行してください。',

  // Auto Download
  'auto_download': '自動ダウンロード',
  'starting_download': '自動ダウンロードを開始しています...',
  'auto_downloading': 'ギャラリーに自動ダウンロード中...',
  'downloaded_complete': 'ギャラリーにダウンロード完了！',
  'file_ready': 'ファイルのダウンロード準備完了',
  'already_downloaded': '既にダウンロード済み',
  're_download': '再ダウンロード',
  'browser': 'ブラウザ',
  'convert_another': '他の動画を変換',
  'conversion_success': '変換成功',
  'converted_file_size': 'ファイルサイズ',
  'conversion_time': '変換時間',
  'opening_browser': 'ブラウザでダウンロードリンクを開いています...',

  // File Size Prediction
  'predicting': '予測中...',
  'predict_converted_size': '変換後サイズを予測',
  'predicted_size_result': '予想変換後サイズ: @size',
  'prediction_failed': '予測失敗: @error',

  // File Deletion Notice
  'file_deletion_notice': 'ファイル削除のお知らせ',
  'file_deletion_details':
      'プライバシー保護のため、アップロードされたファイルは24時間以内に自動削除されます。',

  // Video Information
  'file_name': 'ファイル名: @fileName',
  'video_resolution': '解像度: @width x @height',
  'video_duration': '再生時間: @seconds秒',
  'file_size': 'ファイルサイズ: @size',
  'original_resolution': 'オリジナル (@width x @height)',
  '720p_resolution': '720p (@width x 720)',
  '480p_resolution': '480p (@width x 480)',
  '320p_resolution': '320p (@width x 320)',
  'original_file_size': 'オリジナルファイルサイズ: @size',

  // Video Trim
  'video_trim': '動画トリム',
  'trim_start': '開始: @time',
  'trim_end': '終了: @time',
  'trim_start_frame': '開始フレーム',
  'trim_end_frame': '終了フレーム',
  'trim_success': 'トリム成功',
  'trim_applied_message': '動画が正常にトリムされました！',
  'trim_error': 'トリムエラー',
  'trim_error_message': '動画のトリムに失敗しました。再試行してください。',
  'restore_original': 'オリジナルに復元',
  'no_original_file': 'オリジナルファイルが見つかりません。',
  'original_restored': 'オリジナル動画が復元されました。',
  'restore_error': 'オリジナル動画の復元中にエラーが発生しました。',
  'complete': '完了',
  'start_time': '開始時間',
  'end_time': '終了時間',
  'processing': '処理中...',
  'complete_video_trim': '動画トリム完了',

  // Error Messages
  'initialization_error': '初期化が完了していません。後でもう一度お試しください。',
  'select_file_error': '動画ファイルを選択してください。',
  'login_required': 'ログインが必要です。',
  'upload_error': 'ファイルアップロード中に問題が発生しました。再試行してください。',
  'conversion_error': '変換中にエラーが発生しました。',
  'conversion_complete_notification': '動画変換が完了しました！',
  'notification_permission_required': 'プッシュ通知には通知権限が必要です。',
  'convert_complete_title': '変換完了',
  'convert_complete_message': '動画が正常にWebPに変換されました！',
  'notification_subscribe': '変換通知を受け取る',
  'notification_subscribe_message': 'お気軽にお出かけください！変換が完了したらすぐにお知らせします！',

  // Media Scan
  'media_scan_title': 'ギャラリー更新',
  'media_scan_info': '最近ダウンロードした動画が見つからない場合は、このボタンをタップしてギャラリーを更新してください。',
  'refresh_gallery': 'ギャラリー更新',
  'scanning_media_files': 'メディアファイルをスキャン中...',
  'media_scan_complete': 'ギャラリー更新が完了しました！',
  'media_scan_failed': 'ギャラリー更新に失敗しました。再試行してください。',

  // Video Rotate
  'video_rotate': '動画回転',
  'rotate_angle_selection': '回転角度選択',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video': '動画を回転',
  'rotate_video_processing': '動画を回転中...',
  'rotate_video_complete': '動画が@angle°回転されました。',
  'rotate_video_error': '動画回転中にエラーが発生しました: @error',
  'rotate_video_ffmpeg_error': 'FFmpeg実行に失敗しました: @error',
  'rotate_video_file_not_created': '回転されたファイルが作成されませんでした。',
  'rotate_video_unsupported_angle': 'サポートされていない回転角度: @angle',
  'rotate_video_initializing': '初期化中...',
  'rotate_video_preparing_ffmpeg': 'FFmpegコマンドを準備中...',
  'rotate_video_processing_ffmpeg': '動画回転処理中...',
  'rotate_video_checking_result': '結果を確認中...',
  'rotate_video_complete_status': '完了！',
  'rotate_video_processing_status': '処理中...',
  'rotate_video_thumbnail_warning_title': '⚠️ 画面上の動画解像度の歪みについて',
  'rotate_video_thumbnail_warning_line1': '• 画面上で動画を回転する際に見える解像度の歪みはUI表示の問題です',
  'rotate_video_thumbnail_warning_line2': '• 実際には、オリジナル動画の解像度と品質が維持されます',
  'rotate_video_thumbnail_warning_line3': '• FFmpegで処理された最終ファイルはオリジナルと同じ品質で回転されます',
  'rotate_video_audio_preserved': '選択した角度で動画を回転します。オリジナルオーディオは保持されます。',
  'rotate_video_file_size_calculating': 'サイズ計算中...',
  'rotate_video_play_pause': '再生/一時停止',
  'rotate_video_rotate_angle': '@angle°',

  // Privacy & Email
  'email_app_open_error': 'メールアプリを開けません。@emailに直接お問い合わせください。',
  'email_query_subject': 'VideoToWebpお問い合わせ',

  // FCM Service
  'fcm_convert_complete_channel': '変換完了通知',
  'fcm_convert_complete_channel_description': '動画変換が完了したときに表示される通知',

  // File Select
  'quick_scan': 'クイックスキャン',
  'scan_method_selection': 'スキャン方法選択',
  'quick_scan_option': 'クイックスキャン',
  'quick_scan_subtitle': 'メインフォルダのみを素早くスキャン',
  'hybrid_scan_option': 'ハイブリッドスキャン',
  'hybrid_scan_subtitle': '固定パス + 動的探索（推奨）',
  'full_scan_option': 'フルスキャン',
  'full_scan_subtitle': 'すべての可能なパスを完全にスキャン',
  'cancel_button': 'キャンセル',
  'scan_options': 'スキャンオプション',
  'scanning_in_progress': 'スキャン中...',
  'quick_scan_default_value': 'クイックスキャン',
  'fixed_path_scan_start_progress': '固定パススキャン開始中...',
  'fixed_path_scanning_progress': '固定パススキャン中: @folder',
  'skip_folder_progress': 'スキップ: @folder',
  'error_folder_progress': 'エラー: @folder',
  'fixed_path_scan_complete_progress': '固定パススキャン完了！@countフォルダ成功',
  'media_scan_preparing': 'メディアスキャン準備中...',
  'media_scan_complete_status': 'メディアスキャン完了！',
  'media_scan_error_status': 'スキャンエラー: @error',
  'dynamic_directory_exploration_start_progress': '動的ディレクトリ探索開始中...',
  'dynamic_exploration_progress': '動的探索: @dir',
  'dynamic_exploration_complete_progress': '動的探索完了！@found動画フォルダ発見',
  'dynamic_exploration_error_progress': '動的探索エラー: @error',
  'sample_file_save_failed_error': 'サンプルファイル保存失敗',
  'login_required_error': 'ログインが必要です。',
  'sample_conversion_failed_error': 'サンプル変換に失敗しました。',
  'sample_conversion_monitoring_error': 'サンプル変換監視エラー: @error',
  'sample_conversion_timeout_error': 'サンプル変換タイムアウト。',
  'sample_conversion_error': 'サンプル変換中にエラーが発生しました: @error',

  // Convert Complete
  'image_load_failed': '画像読み込み失敗',

  // Premium Subscription
  'premium_upgrade_title': 'プレミアムにアップグレード',
  'premium_benefit_remove_ads_title': 'すべての広告を削除',
  'premium_benefit_remove_ads_desc': 'インタースティシャル広告とバナー広告がすべて削除されます',
  'premium_benefit_upload_capacity_title': 'アップロード容量の増加',
  'premium_benefit_upload_capacity_desc': 'アップロード容量が20MBから50MBに増加します',
  'premium_benefit_server_title': '高性能サーバー',
  'premium_benefit_server_desc': '512MiBから4096MiBの高性能サーバーにアップグレード',
  'premium_benefit_priority_title': '優先処理',
  'premium_benefit_priority_desc': '変換リクエストが優先的に処理されます',
  'premium_subscribe_button': '購読',
  'premium_subscribe_button_with_price': '@priceで購読',
  'premium_product_loading': '商品情報を読み込み中...',
  'premium_subscribe_success': '購読完了',
  'premium_subscribe_success_message': 'プレミアム機能が有効になりました。',
  'premium_subscribe_failed': '購読失敗',
  'premium_subscribe_failed_message': '購読を完了できませんでした。もう一度お試しください。',
  'premium_subscribe_error': 'エラー',
  'premium_subscribe_error_message': '購読処理中にエラーが発生しました。',
  'premium_restore_button': '購読を復元',
  'premium_restore_success': '復元完了',
  'premium_restore_success_message': 'プレミアム機能が復元されました。',
  'premium_restore_failed': '復元失敗',
  'premium_restore_failed_message': '復元する購読履歴がありません。',
  'premium_restore_error_message': '購読の復元中にエラーが発生しました。',
  'premium_user_tooltip': 'プレミアムユーザー',
  'premium_subscribe_tooltip': 'プレミアム購読',
};
