import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoController;
  final double maxVideoHeight;
  final String fileName;
  final int? videoWidth;
  final int? videoHeight;
  final Duration? videoDuration;
  final String filePath;
  final Function(double, double?)? onTrimChanged; // trim 설정 변경 콜백

  const VideoPlayerWidget({
    Key? key,
    required this.videoController,
    required this.maxVideoHeight,
    required this.fileName,
    required this.videoWidth,
    required this.videoHeight,
    required this.videoDuration,
    required this.filePath,
    this.onTrimChanged,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isDragging = false;
  double _dragValue = 0.0;

  // Trim 관련 변수들
  double _trimStart = 0.0; // 0.0 ~ 1.0 (전체 비디오 대비 비율)
  double _trimEnd = 1.0; // 0.0 ~ 1.0 (전체 비디오 대비 비율)
  bool _isTrimEnabled = false;

  // Trim 프리뷰용 VideoPlayerController들
  VideoPlayerController? _startFrameController;
  VideoPlayerController? _endFrameController;

  @override
  void initState() {
    super.initState();
    widget.videoController.addListener(_videoListener);
  }

  @override
  void dispose() {
    widget.videoController.removeListener(_videoListener);
    _startFrameController?.dispose();
    _endFrameController?.dispose();
    super.dispose();
  }

  void _videoListener() {
    if (mounted && !_isDragging) setState(() {});
  }

  // trim 설정 변경 시 콜백 호출
  void _onTrimSettingsChanged() {
    if (widget.onTrimChanged != null && widget.videoDuration != null) {
      final startSeconds = _trimStart * widget.videoDuration!.inSeconds;
      final endSeconds = _trimEnd * widget.videoDuration!.inSeconds;
      widget.onTrimChanged!(
        startSeconds,
        _isTrimEnabled ? endSeconds : null,
      );
    }
  }

  // trim 범위 변경 시 비디오 위치 업데이트
  void _onTrimRangeChanged(RangeValues values) {
    setState(() {
      _trimStart = values.start;
      _trimEnd = values.end;
    });

    // 메인 비디오를 trim 시작 위치로 이동
    if (widget.videoDuration != null) {
      final seekPosition = Duration(
        milliseconds:
            (_trimStart * widget.videoDuration!.inMilliseconds).round(),
      );
      widget.videoController.seekTo(seekPosition);
    }

    // 프리뷰 프레임 즉시 업데이트
    _updateTrimPreviewFramesImmediate();
  }

  // trim 범위 변경 중 실시간 업데이트 (드래그 중)
  void _onTrimRangeChanging(RangeValues values) {
    setState(() {
      _trimStart = values.start;
      _trimEnd = values.end;
    });

    // 메인 비디오를 trim 시작 위치로 즉시 이동 (await 없이)
    if (widget.videoDuration != null) {
      final seekPosition = Duration(
        milliseconds:
            (_trimStart * widget.videoDuration!.inMilliseconds).round(),
      );
      widget.videoController.seekTo(seekPosition);
    }

    // 드래그 중에도 즉시 프리뷰 프레임 업데이트
    _updateTrimPreviewFrames();
  }

  // 디바운싱된 프리뷰 프레임 업데이트 (즉시 실행)
  void _updateTrimPreviewFramesImmediate() {
    _updateTrimPreviewFrames();
  }

  // trim 모드 토글
  void _onTrimModeToggle(bool value) async {
    setState(() {
      _isTrimEnabled = value;
      if (!value) {
        _trimStart = 0.0;
        _trimEnd = 1.0;
        // 프리뷰 컨트롤러 정리
        _startFrameController?.dispose();
        _endFrameController?.dispose();
        _startFrameController = null;
        _endFrameController = null;
      }
    });

    if (value) {
      // trim 모드 활성화 시 프리뷰 컨트롤러 초기화
      await _initTrimPreviewControllers();
    }

    _onTrimSettingsChanged(); // 설정 변경 시 자동 콜백
  }

  // trim 프리뷰 컨트롤러 초기화
  Future<void> _initTrimPreviewControllers() async {
    if (widget.videoDuration == null) return;

    try {
      // 시작 프레임 컨트롤러
      _startFrameController?.dispose();
      _startFrameController = VideoPlayerController.file(File(widget.filePath));
      await _startFrameController!.initialize();

      // 종료 프레임 컨트롤러
      _endFrameController?.dispose();
      _endFrameController = VideoPlayerController.file(File(widget.filePath));
      await _endFrameController!.initialize();

      // 초기 위치 설정
      await _updateTrimPreviewFrames();

      setState(() {});
    } catch (e) {
      print('Trim 프리뷰 컨트롤러 초기화 오류: $e');
    }
  }

  // trim 프리뷰 프레임 업데이트 (최적화됨)
  Future<void> _updateTrimPreviewFrames() async {
    if (_startFrameController == null ||
        _endFrameController == null ||
        widget.videoDuration == null) {
      return;
    }

    try {
      final startPosition = Duration(
        milliseconds:
            (_trimStart * widget.videoDuration!.inMilliseconds).round(),
      );
      final endPosition = Duration(
        milliseconds: (_trimEnd * widget.videoDuration!.inMilliseconds).round(),
      );

      // 동시에 두 프레임 업데이트 (await 없이)
      _startFrameController!.seekTo(startPosition);
      _endFrameController!.seekTo(endPosition);
    } catch (e) {
      print('Trim 프리뷰 프레임 업데이트 오류: $e');
    }
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
                    AspectRatio(
                      aspectRatio: widget.videoController.value.aspectRatio,
                      child: VideoPlayer(widget.videoController),
                    ),
                    if (!widget.videoController.value.isPlaying)
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
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 2, color: Colors.white)]),
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
                              : (widget.videoController.value.position
                                          .inMilliseconds /
                                      duration.inMilliseconds)
                                  .clamp(0.0, 1.0)),
                      onChanged: (value) {
                        setState(() {
                          _isDragging = true;
                          _dragValue = value;
                        });
                      },
                      onChangeEnd: (value) async {
                        final newPosition = Duration(
                            milliseconds:
                                (value * duration.inMilliseconds).toInt());
                        await widget.videoController.seekTo(newPosition);
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
                Text('file_name'.trParams({'fileName': widget.fileName})),
                Text('video_resolution'.trParams({
                  'width': widget.videoWidth.toString(),
                  'height': widget.videoHeight.toString(),
                })),
                Text('video_duration'.trParams({
                  'seconds': (widget.videoDuration?.inSeconds ?? 0).toString(),
                })),
                Text('file_size'.trParams({
                  'size': _formatFileSize(File(widget.filePath).lengthSync()),
                })),
                SizedBox(height: 12),

                // Trim 컨트롤
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'video_trim'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF495057),
                      ),
                    ),
                    Switch(
                      value: _isTrimEnabled,
                      onChanged: _onTrimModeToggle,
                      activeColor: Color(0xFF3182F6),
                    ),
                  ],
                ),

                if (_isTrimEnabled) ...[
                  SizedBox(height: 12),
                  // Trim 프리뷰 프레임들
                  if (_startFrameController != null &&
                      _endFrameController != null) ...[
                    Row(
                      children: [
                        // 시작 프레임
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'trim_start_frame'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF495057),
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Color(0xFF3182F6), width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: AspectRatio(
                                    aspectRatio: _startFrameController!
                                        .value.aspectRatio,
                                    child: VideoPlayer(_startFrameController!),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _formatDuration(Duration(
                                  seconds: (_trimStart *
                                          (widget.videoDuration?.inSeconds ??
                                              0))
                                      .round(),
                                )),
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF6C757D)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        // 종료 프레임
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'trim_end_frame'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF495057),
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Color(0xFFDC3545), width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: AspectRatio(
                                    aspectRatio:
                                        _endFrameController!.value.aspectRatio,
                                    child: VideoPlayer(_endFrameController!),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _formatDuration(Duration(
                                  seconds: (_trimEnd *
                                          (widget.videoDuration?.inSeconds ??
                                              0))
                                      .round(),
                                )),
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF6C757D)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                  SizedBox(height: 4),
                  // Trim 슬라이더
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 8,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                      activeTrackColor: Color(0xFF3182F6),
                      inactiveTrackColor: Color(0xFFE5E8EB),
                      thumbColor: Color(0xFF3182F6),
                    ),
                    child: RangeSlider(
                      values: RangeValues(_trimStart, _trimEnd),
                      onChanged: _onTrimRangeChanging, // 드래그 중 실시간 업데이트
                      onChangeEnd: (values) {
                        _onTrimRangeChanged(values); // 드래그 완료 시 최종 업데이트
                        _onTrimSettingsChanged(); // 슬라이더 변경 완료 시 콜백
                      },
                      activeColor: Color(0xFF3182F6),
                      inactiveColor: Color(0xFFE5E8EB),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
                // 파일 삭제 안내 (컴팩트)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Color(0xFFE9ECEF)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Color(0xFF6C757D), size: 14),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'file_deletion_details'.tr,
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6C757D),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16), // 하단 여백 추가
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
