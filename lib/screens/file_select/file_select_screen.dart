import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'file_select_controller.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../../models/convert_request.dart';
import '../../routes/app_routes.dart';

class FileSelectScreen extends StatefulWidget {
  @override
  State<FileSelectScreen> createState() => _FileSelectScreenState();
}

class _FileSelectScreenState extends State<FileSelectScreen> {
  final FileSelectController controller = Get.put(FileSelectController());
  bool _wasPlaying = false;
  bool _isDragging = false;
  double _dragValue = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addVideoListener();
    });
  }

  void _addVideoListener() {
    controller.videoPlayerController.value?.removeListener(_videoListener);
    controller.videoPlayerController.value?.addListener(_videoListener);
  }

  void _videoListener() {
    if (mounted && !_isDragging) setState(() {});
  }

  @override
  void dispose() {
    controller.videoPlayerController.value?.removeListener(_videoListener);
    super.dispose();
  }

  void _showConvertDialog(BuildContext context) {
    final videoController = controller.videoPlayerController.value;
    final originalWidth = controller.videoWidth.value ?? 0;
    final originalHeight = controller.videoHeight.value ?? 0;
    final resolutions = <Map<String, dynamic>>[];
    resolutions.add({
      'label': 'original (${originalWidth}x${originalHeight})',
      'width': originalWidth,
      'height': originalHeight,
    });
    if (originalHeight > 720) {
      resolutions.add({'label': '720p (1280x720)', 'width': 1280, 'height': 720});
    }
    if (originalHeight > 480) {
      resolutions.add({'label': '480p (854x480)', 'width': 854, 'height': 480});
    }
    if (originalHeight > 320) {
      resolutions.add({'label': '320p (426x320)', 'width': 426, 'height': 320});
    }
    int selectedResolution = 0;
    double fps = 30;
    double quality = 75;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // 예상 파일 크기 계산 함수
            int originalFileSize = 0;
            if (controller.videoFile.value != null) {
              originalFileSize = File(controller.videoFile.value!.path).lengthSync();
            }
            // 비디오 길이(초) 가져오기
            int duration = controller.videoDuration.value.inSeconds;
            if (duration <= 0) duration = 1; // 0으로 나누기 방지
            // 비트레이트 계산 (bps)
            double originalBitrate = (originalFileSize * 8) / duration;
            // quality에 따른 target 비트레이트 계산
            double targetBitrate = originalBitrate * (quality / 100);
            // 최종 예상 용량 계산 (bytes)
            double estimatedSize = (targetBitrate * duration) / 8;
            String selectedFormat = 'webp';
            String estimatedSizeStr = estimatedSize > 0
                ? (estimatedSize > 1024 * 1024
                    ? '${(estimatedSize / (1024 * 1024)).toStringAsFixed(2)}MB'
                    : '${(estimatedSize / 1024).toStringAsFixed(1)}KB')
                : '-';
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
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
                      Text('변환 옵션', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 24),
                      Text('해상도', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 12),
                      Column(
                        children: List.generate(resolutions.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: GestureDetector(
                              onTap: controller.isUploading.value ? null : () => setModalState(() => selectedResolution = i),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: selectedResolution == i ? Colors.blue[50] : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedResolution == i ? Colors.blue : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(resolutions[i]['label'], style: TextStyle(fontSize: 16))),
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
                      Text('FPS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Color(0xFF3182F6), // Toss 블루
                                inactiveTrackColor: Color(0xFFE5E8EB),
                                thumbColor: Color(0xFF3182F6),
                              ),
                              child: Slider(
                                min: 1,
                                max: 60,
                                divisions: 59,
                                value: fps,
                                label: fps.round().toString(),
                                onChanged: controller.isUploading.value ? null : (v) => setModalState(() => fps = v),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: 48,
                            alignment: Alignment.centerRight,
                            child: Text('${fps.round()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text('Quality', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Color(0xFF3182F6), // Toss 블루
                                inactiveTrackColor: Color(0xFFE5E8EB),
                                thumbColor: Color(0xFF3182F6),
                              ),
                              child: Slider(
                                min: 1,
                                max: 100,
                                divisions: 99,
                                value: quality,
                                label: quality.round().toString(),
                                onChanged: controller.isUploading.value ? null : (v) => setModalState(() => quality = v),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: 48,
                            alignment: Alignment.centerRight,
                            child: Text('${quality.round()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text('예상 파일 크기: $estimatedSizeStr', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                      SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: controller.isUploading.value ? null : () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  backgroundColor: Colors.grey[100],
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                ),
                                child: Text('취소', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: controller.isUploading.value
                                    ? null
                                    : () {
                                        final options = ConvertOptions(
                                          format: selectedFormat,
                                          quality: quality.round(),
                                          fps: fps.round(),
                                          resolution: '${resolutions[selectedResolution]['width']}x${resolutions[selectedResolution]['height']}',
                                        );
                                        controller.uploadAndRequestConvert(options);
                                      },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                ),
                                child: Text('확인', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 업로드 중일 때 Toss 스타일 퍼센트+로딩 UI 전체 덮기
                Obx(() {
                  if (controller.isUploading.value) {
                    return Positioned.fill(
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
                                      value: controller.uploadPercent.value,
                                      strokeWidth: 6,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                    ),
                                  ),
                                  Text(
                                    '${(controller.uploadPercent.value * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text('업로드 중...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxVideoHeight = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      appBar: AppBar(title: Text('Video preview')),
      body: Obx(() {
        if (controller.videoFile.value == null) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      '변환할 비디오 파일을 골라주세요! 🎬',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.pickVideo,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Text('비디오 선택하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          );
        } else {
          final videoController = controller.videoPlayerController.value;
          if (videoController == null || !videoController.value.isInitialized) {
            return Center(child: CircularProgressIndicator());
          }
          _addVideoListener();
          final duration = videoController.value.duration;
          final position = _isDragging
              ? Duration(milliseconds: (_dragValue * duration.inMilliseconds).toInt())
              : videoController.value.position;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: maxVideoHeight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (videoController.value.isPlaying) {
                        videoController.pause();
                      } else {
                        videoController.play();
                      }
                      controller.videoPlayerController.refresh();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: VideoPlayer(videoController),
                        ),
                        if (!videoController.value.isPlaying)
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 72,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // 커스텀 progress bar (Slider)
              Container(
                height: 40,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        _formatDuration(position),
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.white)]),
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 16,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                          activeTrackColor: Color(0xFF3182F6), // Toss 블루
                          inactiveTrackColor: Color(0xFFE5E8EB),
                          thumbColor: Color(0xFF3182F6),
                        ),
                        child: Slider(
                          min: 0.0,
                          max: 1.0,
                          value: duration.inMilliseconds == 0
                              ? 0.0
                              : (_isDragging
                                  ? _dragValue
                                  : (videoController.value.position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)),
                          onChanged: (value) {
                            setState(() {
                              _isDragging = true;
                              _dragValue = value;
                            });
                          },
                          onChangeEnd: (value) async {
                            final newPosition = Duration(milliseconds: (value * duration.inMilliseconds).toInt());
                            await videoController.seekTo(newPosition);
                            setState(() {
                              _isDragging = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('파일명: ${controller.videoFile.value!.name}'),
                    Text('해상도: ${controller.videoWidth.value} x ${controller.videoHeight.value}'),
                    Text('길이: ${controller.videoDuration.value?.inSeconds ?? 0}초'),
                  ],
                ),
              ),
              Spacer(),
            ],
          );
        }
      }),
      bottomNavigationBar: Obx(() {
        if (controller.videoFile.value == null) return SizedBox.shrink();
        return Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.pickVideo,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                  child: Text('다른 비디오 선택', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _showConvertDialog(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Text('변환', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
} 