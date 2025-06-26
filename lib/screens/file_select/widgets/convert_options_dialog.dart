import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../models/convert_request.dart';
import '../file_select_controller.dart';

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
    selectedFormat = widget.savedSettings['format'] as String;

    // 첫 사용인 경우 480p를 기본값으로 설정
    if (selectedResolution == -1) {
      selectedResolution = _find480pIndex();
    }

    // 해상도 인덱스가 현재 비디오의 해상도 옵션 수를 초과하면 0으로 초기화
    if (selectedResolution >= resolutions.length) {
      selectedResolution = 0;
    }
  }

  // 480p 해상도의 인덱스를 찾는 메서드
  int _find480pIndex() {
    for (int i = 0; i < resolutions.length; i++) {
      final height = resolutions[i]['height'] as int;
      if (height == 480) {
        return i;
      }
    }
    // 480p가 없으면 원본보다 작은 해상도 중 가장 큰 것을 선택
    for (int i = 1; i < resolutions.length; i++) {
      return i;
    }
    // 그래도 없으면 원본 해상도 선택
    return 0;
  }

  String _calculateEstimatedSize() {
    int duration = widget.videoDurationSeconds;
    if (duration <= 0) duration = 1;

    int width = resolutions[selectedResolution]['width'];
    int height = resolutions[selectedResolution]['height'];

    // 애니메이션 WebP 용량 계산
    double baseFrameSize = width * height * 0.1;
    double qualityFactor = (quality / 75) * 0.5;
    int totalFrames = (duration * fps).round();
    double estimatedSize = baseFrameSize * qualityFactor * totalFrames;

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
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
              SizedBox(height: 24),
              Text(
                'fps'.tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
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
              SizedBox(height: 24),
              Text(
                'quality'.tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
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
              SizedBox(height: 24),
              Text(
                'estimated_file_size'
                    .trParams({'size': _calculateEstimatedSize()}),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]),
              ),
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
                            : () {
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
