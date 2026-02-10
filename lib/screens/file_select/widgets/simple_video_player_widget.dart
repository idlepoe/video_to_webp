import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class SimpleVideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoController;
  final double maxVideoHeight;
  final String fileName;
  final int? videoWidth;
  final int? videoHeight;
  final Duration? videoDuration;
  final String filePath;

  const SimpleVideoPlayerWidget({
    Key? key,
    required this.videoController,
    required this.maxVideoHeight,
    required this.fileName,
    required this.videoWidth,
    required this.videoHeight,
    required this.videoDuration,
    required this.filePath,
  }) : super(key: key);

  @override
  State<SimpleVideoPlayerWidget> createState() =>
      _SimpleVideoPlayerWidgetState();
}

class _SimpleVideoPlayerWidgetState extends State<SimpleVideoPlayerWidget> {
  bool _isDragging = false;
  double _dragValue = 0.0;
  VideoPlayerController? _currentController;

  @override
  void initState() {
    super.initState();
    _currentController = widget.videoController;
    _currentController?.addListener(_videoListener);
  }

  @override
  void didUpdateWidget(SimpleVideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoController != widget.videoController) {
      // 기존 컨트롤러에서 리스너 제거
      _currentController?.removeListener(_videoListener);
      // 새 컨트롤러에 리스너 추가
      _currentController = widget.videoController;
      _currentController?.addListener(_videoListener);
      // 드래그 상태 초기화
      setState(() {
        _isDragging = false;
        _dragValue = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _currentController?.removeListener(_videoListener);
    super.dispose();
  }

  void _videoListener() {
    if (mounted && !_isDragging) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.videoController.value.duration;
    final position = _isDragging
        ? Duration(milliseconds: (_dragValue * duration.inMilliseconds).toInt())
        : widget.videoController.value.position;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 비디오 플레이어
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: widget.maxVideoHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (widget.videoController.value.isPlaying) {
                    widget.videoController.pause();
                  } else {
                    widget.videoController.play();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: widget.maxVideoHeight,
                      color: Colors.black,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: widget.videoController.value.size.width,
                          height: widget.videoController.value.size.height,
                          child: VideoPlayer(widget.videoController),
                        ),
                      ),
                    ),
                    // 재생/일시정지 아이콘
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        widget.videoController.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 비디오 진행 슬라이더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Text(
                  _formatDuration(position),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF3182F6),
                      inactiveTrackColor: const Color(0xFFE5E8EB),
                      thumbColor: const Color(0xFF3182F6),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: duration.inMilliseconds > 0
                          ? position.inMilliseconds.toDouble() /
                              duration.inMilliseconds.toDouble()
                          : 0,
                      onChanged: (value) {
                        setState(() {
                          _isDragging = true;
                          _dragValue = value;
                        });
                      },
                      onChangeEnd: (value) {
                        final newPosition = Duration(
                          milliseconds:
                              (value * duration.inMilliseconds).toInt(),
                        );
                        widget.videoController.seekTo(newPosition);
                        setState(() {
                          _isDragging = false;
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  _formatDuration(duration),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // 비디오 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'file_name'.trParams({'fileName': widget.fileName}),
                  style: const TextStyle(fontSize: 11, height: 1.2),
                ),
                const SizedBox(height: 2),
                Text(
                  'video_resolution'.trParams({
                    'width': widget.videoWidth.toString(),
                    'height': widget.videoHeight.toString(),
                  }),
                  style: const TextStyle(fontSize: 11, height: 1.2),
                ),
                const SizedBox(height: 2),
                Text(
                  'video_duration'.trParams({
                    'seconds': (widget.videoDuration?.inSeconds ?? 0).toString(),
                  }),
                  style: const TextStyle(fontSize: 11, height: 1.2),
                ),
                const SizedBox(height: 2),
                Text(
                  'file_size'.trParams({
                    'size': _formatFileSize(File(widget.filePath).lengthSync()),
                  }),
                  style: const TextStyle(fontSize: 11, height: 1.2),
                ),
                const SizedBox(height: 8),

                // 파일 삭제 안내
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFF6C757D), size: 12),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'file_deletion_details'.tr,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6C757D),
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
}
