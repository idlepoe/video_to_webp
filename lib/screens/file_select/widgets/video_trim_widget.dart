import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VideoTrimWidget extends StatefulWidget {
  final String filePath;
  final String fileName;
  final Function(String) onTrimComplete;
  final Function() onCancel;

  const VideoTrimWidget({
    Key? key,
    required this.filePath,
    required this.fileName,
    required this.onTrimComplete,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<VideoTrimWidget> createState() => _VideoTrimWidgetState();
}

class _VideoTrimWidgetState extends State<VideoTrimWidget> {
  final Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: File(widget.filePath));
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputPath = '${directory.path}/trimmed_video_$timestamp.mp4';

      await _trimmer.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        onSave: (String? outputPath) {
          setState(() {
            _progressVisibility = false;
          });

          if (outputPath != null) {
            // trim된 파일 경로를 콜백으로 전달
            widget.onTrimComplete(outputPath);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('trim_error_message'.tr)),
            );
          }
        },
      );
    } catch (e) {
      setState(() {
        _progressVisibility = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'trim_error_message'.tr}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'video_trim'.tr,
          style: const TextStyle(
            color: Color(0xFF191F28),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF191F28)),
          onPressed: widget.onCancel,
        ),
        actions: [
          TextButton(
            onPressed: _progressVisibility ? null : _saveVideo,
            child: Text(
              'complete'.tr,
              style: TextStyle(
                color:
                    _progressVisibility ? Colors.grey : const Color(0xFF3182F6),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3182F6),
              ),
            )
          : Column(
              children: [
                // 비디오 뷰어 (재생 버튼 overlay 포함)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // 비디오 뷰어
                          VideoViewer(trimmer: _trimmer),

                          // 재생 버튼 overlay
                          Positioned.fill(
                            child: Center(
                              child: GestureDetector(
                                onTap: () async {
                                  bool playbackState =
                                      await _trimmer.videoPlaybackControl(
                                    startValue: _startValue,
                                    endValue: _endValue,
                                  );
                                  setState(() => _isPlaying = playbackState);
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 컨트롤 영역
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // 파일 정보
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E8EB)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3182F6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.video_file,
                                color: Color(0xFF3182F6),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.fileName,
                                    style: const TextStyle(
                                      color: Color(0xFF191F28),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatFileSize(
                                        File(widget.filePath).lengthSync()),
                                    style: const TextStyle(
                                      color: Color(0xFF8B95A1),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Trim 슬라이더 섹션
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E8EB)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 섹션 제목
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3182F6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'video_trim'.tr,
                                  style: const TextStyle(
                                    color: Color(0xFF191F28),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // TrimViewer - 예제와 같은 방식으로 수정
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TrimViewer(
                                  trimmer: _trimmer,
                                  viewerHeight: 60.0,
                                  viewerWidth:
                                      MediaQuery.of(context).size.width - 64.0,
                                  durationStyle: DurationStyle.FORMAT_MM_SS,
                                  maxVideoLength: const Duration(seconds: 300),
                                  editorProperties: TrimEditorProperties(
                                    borderPaintColor: const Color(0xFF3182F6),
                                    borderWidth: 4,
                                    borderRadius: 8,
                                    circlePaintColor: const Color(0xFF1E40AF),
                                  ),
                                  areaProperties: TrimAreaProperties.edgeBlur(
                                    thumbnailQuality: 50,
                                  ),
                                  onChangeStart: (value) {
                                    setState(() {
                                      _startValue = value;
                                    });
                                  },
                                  onChangeEnd: (value) {
                                    setState(() {
                                      _endValue = value;
                                    });
                                  },
                                  onChangePlaybackState: (value) {
                                    setState(() {
                                      _isPlaying = value;
                                    });
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // 시간 표시
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'start_time'.tr,
                                      style: const TextStyle(
                                        color: Color(0xFF8B95A1),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_startValue),
                                      style: const TextStyle(
                                        color: Color(0xFF191F28),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'end_time'.tr,
                                      style: const TextStyle(
                                        color: Color(0xFF8B95A1),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_endValue),
                                      style: const TextStyle(
                                        color: Color(0xFF191F28),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 저장 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _progressVisibility ? null : _saveVideo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3182F6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: const Color(0xFFE5E8EB),
                          ),
                          child: _progressVisibility
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'processing'.tr,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.cut, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'complete_video_trim'.tr,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
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

  String _formatDuration(double totalSeconds) {
    // video_trimmer는 밀리초 단위로 값을 전달
    totalSeconds = totalSeconds / 1000;

    final minutes = (totalSeconds / 60).floor();
    final seconds = totalSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    // 초 부분을 올바르게 포맷 (padLeft 제거)
    String formattedSeconds = seconds.toStringAsFixed(1);
    if (seconds < 10) {
      formattedSeconds = '0$formattedSeconds';
    }

    return "${twoDigits(minutes)}:$formattedSeconds";
  }

  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }
}
