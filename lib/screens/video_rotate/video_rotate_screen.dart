import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:math' as math;

class VideoRotateScreen extends StatefulWidget {
  final String filePath;
  final String fileName;
  final Function(String) onRotateComplete;
  final Function() onCancel;

  const VideoRotateScreen({
    Key? key,
    required this.filePath,
    required this.fileName,
    required this.onRotateComplete,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<VideoRotateScreen> createState() => _VideoRotateScreenState();
}

class _VideoRotateScreenState extends State<VideoRotateScreen> {
  VideoPlayerController? _videoPlayerController;
  bool _isLoading = true;
  bool _isProcessing = false;
  int _selectedRotation = 90; // 기본값: 90도
  double _progress = 0.0; // 진행률
  String _progressText = ''; // 진행률 텍스트

  final List<Map<String, dynamic>> _rotationOptions = [
    {
      'value': 90,
      'label': 'rotate_90_degrees',
      'icon': Icons.rotate_90_degrees_ccw
    },
    {'value': 180, 'label': 'rotate_180_degrees', 'icon': Icons.rotate_right},
    {
      'value': 270,
      'label': 'rotate_270_degrees',
      'icon': Icons.rotate_90_degrees_cw
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.filePath));
      await _videoPlayerController!.initialize();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('비디오 플레이어 초기화 오류: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 회전 각도를 라디안으로 변환
  double _getRotationInRadians() {
    return _selectedRotation * math.pi / 180;
  }

  // 회전된 비디오의 크기 계산
  Size _getRotatedVideoSize() {
    if (_videoPlayerController == null) return Size.zero;

    final originalSize = _videoPlayerController!.value.size;
    final rotation = _selectedRotation;

    // 90도 또는 270도 회전 시 가로세로가 바뀜
    if (rotation == 90 || rotation == 270) {
      return Size(originalSize.height, originalSize.width);
    }

    // 180도 회전 시 크기 변화 없음
    return originalSize;
  }

  // 회전 각도에 따른 비디오 플레이어 크기 조정
  Widget _buildRotatedVideoPlayer() {
    if (_videoPlayerController == null) return Container();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // 원본 비디오 크기
        final originalSize = _videoPlayerController!.value.size;
        if (originalSize.width == 0 || originalSize.height == 0) {
          return Container();
        }

        // 회전된 비디오의 실제 크기
        final rotatedSize = _getRotatedVideoSize();

        // 회전된 비디오의 aspect ratio
        final aspectRatio = rotatedSize.width / rotatedSize.height;

        // 컨테이너 크기 계산 (aspect ratio 유지하면서 화면에 맞춤)
        double containerWidth, containerHeight;

        if (maxWidth / maxHeight > aspectRatio) {
          // 높이에 맞춤
          containerHeight = maxHeight;
          containerWidth = maxHeight * aspectRatio;
        } else {
          // 너비에 맞춤
          containerWidth = maxWidth;
          containerHeight = maxWidth / aspectRatio;
        }

        // 90도/270도 회전 시 비디오가 잘리지 않도록 조정
        if (_selectedRotation == 90 || _selectedRotation == 270) {
          // 회전된 비디오가 화면에 완전히 들어가도록 크기 조정
          final rotatedAspectRatio = rotatedSize.width / rotatedSize.height;

          if (maxWidth / maxHeight > rotatedAspectRatio) {
            // 높이에 맞춤
            containerHeight = maxHeight;
            containerWidth = maxHeight * rotatedAspectRatio;
          } else {
            // 너비에 맞춤
            containerWidth = maxWidth;
            containerHeight = maxWidth / rotatedAspectRatio;
          }
        }

        return Center(
          child: Container(
            width: containerWidth,
            height: containerHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Transform.rotate(
                angle: _getRotationInRadians(),
                child: SizedBox(
                  width: originalSize.width,
                  height: originalSize.height,
                  child: VideoPlayer(_videoPlayerController!),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _rotateVideo() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _progress = 0.0;
      _progressText = 'rotate_video_initializing'.tr;
    });

    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputPath = '${directory.path}/rotated_video_$timestamp.mp4';

      // FFmpeg를 사용하여 비디오 회전
      print('비디오 회전 시작: $_selectedRotation도');

      setState(() {
        _progress = 0.1;
        _progressText = 'rotate_video_preparing_ffmpeg'.tr;
      });

      // 회전 각도에 따른 FFmpeg 명령어 생성
      String ffmpegCommand;
      switch (_selectedRotation) {
        case 90:
          ffmpegCommand =
              '-i "${widget.filePath}" -vf "transpose=1" -c:a copy "$outputPath"';
          break;
        case 180:
          ffmpegCommand =
              '-i "${widget.filePath}" -vf "transpose=1,transpose=1" -c:a copy "$outputPath"';
          break;
        case 270:
          ffmpegCommand =
              '-i "${widget.filePath}" -vf "transpose=2" -c:a copy "$outputPath"';
          break;
        default:
          throw Exception('rotate_video_unsupported_angle'
              .trParams({'angle': _selectedRotation.toString()}));
      }

      print('FFmpeg 명령어: $ffmpegCommand');

      setState(() {
        _progress = 0.2;
        _progressText = 'rotate_video_processing_ffmpeg'.tr;
      });

      // FFmpeg 실행
      final session = await FFmpegKit.execute(ffmpegCommand);

      setState(() {
        _progress = 0.8;
        _progressText = 'rotate_video_checking_result'.tr;
      });

      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        setState(() {
          _progress = 1.0;
          _progressText = 'rotate_video_complete_status'.tr;
        });

        print('비디오 회전 완료: $outputPath');

        // 회전된 파일이 실제로 생성되었는지 확인
        final outputFile = File(outputPath);
        if (await outputFile.exists()) {
          final fileSize = await outputFile.length();
          print('회전된 파일 크기: ${_formatFileSize(fileSize)}');

          // 성공 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('rotate_video_complete'
                  .trParams({'angle': _selectedRotation.toString()})),
              backgroundColor: Colors.green,
            ),
          );

          // 회전된 파일 경로 반환
          widget.onRotateComplete(outputPath);
        } else {
          throw Exception('rotate_video_file_not_created'.tr);
        }
      } else {
        final output = await session.getOutput();
        final failStackTrace = await session.getFailStackTrace();
        print('FFmpeg 실행 실패: $output');
        print('오류 스택: $failStackTrace');
        throw Exception('rotate_video_ffmpeg_error'
            .trParams({'error': output ?? 'Unknown error'}));
      }
    } catch (e) {
      print('비디오 회전 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('rotate_video_error'.trParams({'error': e.toString()})),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
        _progress = 0.0;
        _progressText = '';
      });
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
          'video_rotate'.tr,
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
            onPressed: _isProcessing ? null : _rotateVideo,
            child: Text(
              'complete'.tr,
              style: TextStyle(
                color: _isProcessing ? Colors.grey : const Color(0xFF3182F6),
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
                // 비디오 뷰어 (회전 적용)
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
                          // 회전된 비디오 뷰어 (aspect ratio 유지)
                          _buildRotatedVideoPlayer(),

                          // 재생/일시정지 버튼 overlay
                          Positioned.fill(
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_videoPlayerController!
                                        .value.isPlaying) {
                                      _videoPlayerController!.pause();
                                    } else {
                                      _videoPlayerController!.play();
                                    }
                                  });
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
                                    _videoPlayerController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
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
                                  FutureBuilder<int>(
                                    future: File(widget.filePath).length(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          _formatFileSize(snapshot.data),
                                          style: const TextStyle(
                                            color: Color(0xFF8B95A1),
                                            fontSize: 12,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          'rotate_video_file_size_calculating'
                                              .tr,
                                          style: const TextStyle(
                                            color: Color(0xFF8B95A1),
                                            fontSize: 12,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 회전 옵션 선택 섹션
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
                                  'rotate_angle_selection'.tr,
                                  style: const TextStyle(
                                    color: Color(0xFF191F28),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // 회전 옵션 버튼들
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _rotationOptions.map((option) {
                                final isSelected =
                                    _selectedRotation == option['value'];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedRotation = option['value'];
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF3182F6)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF3182F6)
                                            : const Color(0xFFE5E8EB),
                                        width: 2,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF3182F6)
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          option['icon'],
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFF8B95A1),
                                          size: 24,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          option['label'].toString().tr,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF191F28),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 16),

                            // 설명 텍스트
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF5F5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFFF6B6B),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: const Color(0xFFE53E3E),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'rotate_video_thumbnail_warning_title'
                                              .tr,
                                          style: TextStyle(
                                            color: const Color(0xFFE53E3E),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${'rotate_video_thumbnail_warning_line1'.tr}\n${'rotate_video_thumbnail_warning_line2'.tr}\n${'rotate_video_thumbnail_warning_line3'.tr}',
                                          style: TextStyle(
                                            color: const Color(0xFFE53E3E),
                                            fontSize: 11,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 진행률 표시 (처리 중일 때만)
                      if (_isProcessing) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E8EB)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.rotate_right,
                                    color: const Color(0xFF3182F6),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'rotate_video_processing'.tr,
                                    style: const TextStyle(
                                      color: Color(0xFF191F28),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: _progress,
                                backgroundColor: const Color(0xFFE5E8EB),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF3182F6)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _progressText.isNotEmpty
                                    ? _progressText
                                    : 'rotate_video_processing_status'.tr,
                                style: const TextStyle(
                                  color: Color(0xFF8B95A1),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // 회전 실행 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : _rotateVideo,
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
                          child: _isProcessing
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
                                      'rotate_video_processing'.tr,
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
                                    Icon(
                                      _getRotationIcon(_selectedRotation),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'rotate_video_rotate_angle'.trParams({
                                        'angle': _selectedRotation.toString()
                                      }),
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

  IconData _getRotationIcon(int rotation) {
    switch (rotation) {
      case 90:
        return Icons.rotate_90_degrees_ccw;
      case 180:
        return Icons.rotate_right;
      case 270:
        return Icons.rotate_90_degrees_cw;
      default:
        return Icons.rotate_right;
    }
  }

  String _formatFileSize(int? size) {
    if (size == null || size < 1024) {
      return "${size ?? 0} bytes";
    } else if (size < 1024 * 1024) {
      return "${(size / 1024).toStringAsFixed(2)} KB";
    } else if (size < 1024 * 1024 * 1024) {
      return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else {
      return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
