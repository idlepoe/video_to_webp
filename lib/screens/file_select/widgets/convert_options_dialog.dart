import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../models/convert_request.dart';
import '../file_select_controller.dart';
import 'dart:math';

class ConvertOptionsDialog extends StatefulWidget {
  final int originalWidth;
  final int originalHeight;
  final int videoDurationSeconds;
  final String videoFilePath;
  final Map<String, dynamic> savedSettings;
  final Function(ConvertOptions) onConvert;
  final bool isUploading;
  final double uploadPercent;

  const ConvertOptionsDialog({
    Key? key,
    required this.originalWidth,
    required this.originalHeight,
    required this.videoDurationSeconds,
    required this.videoFilePath,
    required this.savedSettings,
    required this.onConvert,
    this.isUploading = false,
    this.uploadPercent = 0.0,
  }) : super(key: key);

  @override
  State<ConvertOptionsDialog> createState() => _ConvertOptionsDialogState();
}

class _ConvertOptionsDialogState extends State<ConvertOptionsDialog> {
  late int selectedResolution;
  late double fps;
  late double quality;
  late double speed;
  late String selectedFormat;
  late List<Map<String, dynamic>> resolutions;

  @override
  void initState() {
    super.initState();
    _initializeResolutions();
    _loadSettings();
  }

  void _initializeResolutions() {
    final aspectRatio = widget.originalWidth / widget.originalHeight;
    resolutions = [];

    resolutions.add({
      'label': 'original_resolution'.trParams({
        'width': widget.originalWidth.toString(),
        'height': widget.originalHeight.toString(),
      }),
      'width': widget.originalWidth,
      'height': widget.originalHeight,
    });

    if (widget.originalHeight > 720) {
      final width = (aspectRatio * 720).round();
      resolutions.add({
        'label': '720p_resolution'.trParams({
          'width': width.toString(),
          'height': '720',
        }),
        'width': width,
        'height': 720
      });
    }

    if (widget.originalHeight > 480) {
      final width = (aspectRatio * 480).round();
      resolutions.add({
        'label': '480p_resolution'.trParams({
          'width': width.toString(),
          'height': '480',
        }),
        'width': width,
        'height': 480
      });
    }

    if (widget.originalHeight > 320) {
      final width = (aspectRatio * 320).round();
      resolutions.add({
        'label': '320p_resolution'.trParams({
          'width': width.toString(),
          'height': '320',
        }),
        'width': width,
        'height': 320
      });
    }
  }

  void _loadSettings() {
    selectedResolution = widget.savedSettings['selectedResolution'] as int;
    fps = widget.savedSettings['fps'] as double;
    quality = widget.savedSettings['quality'] as double;
    speed = widget.savedSettings['speed'] as double? ?? 1.0;
    selectedFormat = widget.savedSettings['format'] as String;

    // 저장된 해상도가 현재 비디오의 해상도 옵션에서 사용할 수 없는 경우 원본으로 설정
    if (selectedResolution < 0 || selectedResolution >= resolutions.length) {
      selectedResolution = 0; // 원본 해상도 선택
    }
  }

  String _calculateEstimatedSize() {
    int duration = widget.videoDurationSeconds;
    if (duration <= 0) duration = 1;

    int width = resolutions[selectedResolution]['width'];
    int height = resolutions[selectedResolution]['height'];

    // 원본 파일 크기
    double originalSize = File(widget.videoFilePath).lengthSync().toDouble();
    print('원본 크기: ${originalSize / (1024 * 1024)}MB');

    // quality에 따른 크기 배율 계산
    double qualityMultiplier;
    if (quality >= 99) {
      // 99-100 구간: 약 8-8.15배
      qualityMultiplier = 8.0 + ((quality - 99) * 0.15);
    } else if (quality >= 90) {
      // 90-98 구간: 3.24-8배로 선형 증가
      qualityMultiplier = 3.24 + ((quality - 90) * (8.0 - 3.24) / 9);
    } else if (quality >= 50) {
      // 50-89 구간: 1.03-3.24배로 선형 증가
      qualityMultiplier = 1.03 + ((quality - 50) * (3.24 - 1.03) / 40);
    } else {
      // 50 미만: 1.03배에서 선형 감소
      qualityMultiplier = (quality / 50) * 1.03;
    }
    print('품질 배율 (quality: ${quality.round()}): $qualityMultiplier');

    // 해상도 비율에 따른 조정 (기준: 540x720)
    double baseWidth = 540.0;
    double baseHeight = 720.0;
    double resolutionRatio = sqrt((width * height) / (baseWidth * baseHeight));
    // 해상도 비율의 제곱근을 사용하여 실제 크기 증가 반영
    double resolutionMultiplier = pow(resolutionRatio, 1.5).toDouble();
    print(
        '해상도 비율 ($width x $height -> ${baseWidth.round()} x ${baseHeight.round()}): $resolutionRatio');
    print('해상도 배율: $resolutionMultiplier');

    // FPS에 따른 조정 (기준 30fps)
    double fpsRatio = fps / 30.0;
    print('FPS 비율 (${fps.round()}fps): $fpsRatio');

    // 최종 예상 크기 계산
    double estimatedSize =
        originalSize * qualityMultiplier * resolutionMultiplier * fpsRatio;
    print('예상 크기: ${estimatedSize / (1024 * 1024)}MB');

    if (estimatedSize <= 0) {
      print('계산된 크기가 0 이하입니다. 계산 과정 확인 필요');
      print('- originalSize: $originalSize');
      print('- qualityMultiplier: $qualityMultiplier');
      print('- resolutionMultiplier: $resolutionMultiplier');
      print('- fpsRatio: $fpsRatio');
    }

    return estimatedSize > 0
        ? (estimatedSize > 1024 * 1024
            ? '${(estimatedSize / (1024 * 1024)).toStringAsFixed(2)}MB'
            : '${(estimatedSize / 1024).toStringAsFixed(1)}KB')
        : '-';
  }

  String _formatFileSize(int size) {
    if (size < 1024) {
      return "$size bytes";
    } else if (size < 1024 * 1024) {
      return "${(size / 1024).toStringAsFixed(2)} KB";
    } else if (size < 1024 * 1024 * 1024) {
      return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else {
      return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'convert_options'.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                Text(
                  'resolution'.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                Column(
                  children: List.generate(resolutions.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: widget.isUploading
                            ? null
                            : () => setState(() => selectedResolution = i),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: selectedResolution == i
                                ? Colors.blue[50]
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedResolution == i
                                  ? Colors.blue
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(resolutions[i]['label'],
                                      style: TextStyle(fontSize: 16))),
                              if (selectedResolution == i)
                                Icon(Icons.check_circle, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 12),
                Text(
                  'fps'.tr,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Color(0xFF3182F6),
                            inactiveTrackColor: Color(0xFFE5E8EB),
                            thumbColor: Color(0xFF3182F6),
                          ),
                          child: Slider(
                            min: 1,
                            max: 60,
                            divisions: 59,
                            value: fps,
                            label: fps.round().toString(),
                            onChanged: widget.isUploading
                                ? null
                                : (v) => setState(() => fps = v),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        width: 48,
                        alignment: Alignment.centerRight,
                        child: Text('${fps.round()}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'quality'.tr,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Color(0xFF3182F6),
                            inactiveTrackColor: Color(0xFFE5E8EB),
                            thumbColor: Color(0xFF3182F6),
                          ),
                          child: Slider(
                            min: 1,
                            max: 100,
                            divisions: 99,
                            value: quality,
                            label: quality.round().toString(),
                            onChanged: widget.isUploading
                                ? null
                                : (v) => setState(() => quality = v),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        width: 48,
                        alignment: Alignment.centerRight,
                        child: Text('${quality.round()}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'playback_speed'.tr,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Color(0xFF3182F6),
                            inactiveTrackColor: Color(0xFFE5E8EB),
                            thumbColor: Color(0xFF3182F6),
                          ),
                          child: Slider(
                            min: 0.5,
                            max: 2.0,
                            divisions: 15,
                            value: speed,
                            label: '${speed.toStringAsFixed(2)}x',
                            onChanged: widget.isUploading
                                ? null
                                : (v) => setState(() => speed = v),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        width: 48,
                        alignment: Alignment.centerRight,
                        child: Text('${speed.toStringAsFixed(2)}x',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 24),
                // Text(
                //   'estimated_file_size'
                //       .trParams({'size': _calculateEstimatedSize()}),
                //   style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.grey[700]),
                // ),
                SizedBox(height: 8),
                Text(
                  'original_file_size'.trParams({
                    'size':
                        _formatFileSize(File(widget.videoFilePath).lengthSync())
                  }),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: widget.isUploading
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.black,
                            elevation: 0,
                          ),
                          child: Text(
                            'cancel'.tr,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: widget.isUploading
                              ? null
                              : () async {
                                  // FileSelectController에서 trim 설정 가져오기
                                  final controller =
                                      Get.find<FileSelectController>();

                                  final options = ConvertOptions(
                                    format: selectedFormat,
                                    quality: quality.round(),
                                    fps: fps.round(),
                                    resolution:
                                        '${resolutions[selectedResolution]['width']}x${resolutions[selectedResolution]['height']}',
                                    startTime: controller.trimStartTime.value,
                                    endTime: controller.trimEndTime.value,
                                    speed: speed,
                                  );

                                  // 설정 저장
                                  await controller.saveConvertSettings(
                                    selectedResolution: selectedResolution,
                                    fps: fps,
                                    quality: quality,
                                    format: selectedFormat,
                                    speed: speed,
                                  );

                                  widget.onConvert(options);
                                },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                          child: Text(
                            'convert'.tr,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // 업로드 중일 때 로딩 오버레이
        if (widget.isUploading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.85),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            value: widget.uploadPercent,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey[200],
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        Text(
                          '${(widget.uploadPercent * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'uploading'.tr,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
