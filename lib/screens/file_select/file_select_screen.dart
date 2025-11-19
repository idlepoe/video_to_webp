import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'file_select_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/in_app_purchase_service.dart';
import 'widgets/widgets.dart';
import 'widgets/premium_promo_modal.dart';

class FileSelectScreen extends StatefulWidget {
  @override
  State<FileSelectScreen> createState() => _FileSelectScreenState();
}

class _FileSelectScreenState extends State<FileSelectScreen> {
  final FileSelectController controller = Get.put(FileSelectController());

  @override
  void initState() {
    super.initState();
    // 화면이 빌드된 후 모달 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPremiumPromo();
    });
  }

  Future<void> _checkAndShowPremiumPromo() async {
    final prefs = await SharedPreferences.getInstance();
    final promoShown = prefs.getBool('premium_promo_shown') ?? false;
    final purchaseService = InAppPurchaseService();
    final isPremium = await purchaseService.isPremiumUser();

    // 이미 프리미엄 사용자이거나 이미 모달을 보여준 경우 표시하지 않음
    if (isPremium || promoShown) {
      return;
    }

    // 모달 표시
    if (mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const PremiumPromoModal(),
      ).then((_) {
        // 모달이 닫힌 후 표시 여부 저장
        prefs.setBool('premium_promo_shown', true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxVideoHeight = MediaQuery.of(context).size.height * 0.35;
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
        actions: [
          FutureBuilder<bool>(
            future: InAppPurchaseService().isPremiumUser(),
            builder: (context, snapshot) {
              final isPremium = snapshot.data ?? false;
              if (isPremium) {
                return IconButton(
                  icon: Icon(Icons.star, color: Colors.amber),
                  tooltip: '프리미엄 사용자',
                  onPressed: null,
                );
              }
              return IconButton(
                icon: Icon(Icons.star_border, color: Colors.grey[700]),
                tooltip: '프리미엄 구매',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const PremiumPromoModal(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.videoFile.value == null) {
          return EmptyVideoWidget(
            onPickVideo: controller.pickVideo,
          );
        } else {
          final videoController = controller.videoPlayerController.value;
          if (videoController == null ||
              !videoController.value.isInitialized) {
            return Center(child: CircularProgressIndicator());
          }
    
          return SimpleVideoPlayerWidget(
            key: ValueKey(controller.videoFile.value!.path), // 파일 경로를 키로 사용
            videoController: videoController,
            maxVideoHeight: maxVideoHeight,
            fileName: controller.videoFile.value!.name,
            videoWidth: controller.videoWidth.value,
            videoHeight: controller.videoHeight.value,
            videoDuration: controller.videoDuration.value,
            filePath: controller.videoFile.value!.path,
          );
        }
      }),
      bottomNavigationBar: Obx(() {
        if (controller.videoFile.value == null) return SizedBox.shrink();
        return BottomNavigationWidget(
          onPickOtherVideo: controller.pickVideo,
          onConvert: () => _showConvertDialog(context),
          onRotate: controller.openRotateScreen,
          onTrim: controller.openTrimScreen,
          onRestoreOriginal: controller.restoreOriginal,
          showRestoreButton: controller.isTrimmed.value,
        );
      }),
      // floatingActionButton: kDebugMode
      //     ? Row(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           FloatingActionButton(
      //             onPressed: () {
      //               Get.toNamed(AppRoutes.loading, arguments: {
      //                 'requestId': 'dummy_request_id',
      //                 'fileName': 'dummy_video.mp4',
      //                 'fileSize': 1024000,
      //                 'isDebug': true,
      //               });
      //             },
      //             backgroundColor: Colors.orange,
      //             child: Icon(Icons.hourglass_empty, color: Colors.white),
      //           ),
      //           SizedBox(width: 16),
      //           FloatingActionButton(
      //             onPressed: () {
      //               Get.offAllNamed(AppRoutes.complete);
      //             },
      //             backgroundColor: Colors.red,
      //             child: Icon(Icons.bug_report, color: Colors.white),
      //           ),
      //         ],
      //       )
      //     : null,
    );
  }

  void _showConvertDialog(BuildContext context) async {
    final originalWidth = controller.videoWidth.value;
    final originalHeight = controller.videoHeight.value;
    final videoDurationSeconds = controller.videoDuration.value.inSeconds;
    final videoFilePath = controller.videoFile.value!.path;

    // 저장된 설정 불러오기
    final savedSettings = await controller.loadConvertSettings();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Obx(() => ConvertOptionsDialog(
              originalWidth: originalWidth,
              originalHeight: originalHeight,
              videoDurationSeconds: videoDurationSeconds,
              videoFilePath: videoFilePath,
              savedSettings: savedSettings,
              isUploading: controller.isUploading.value,
              uploadPercent: controller.uploadPercent.value,
              onConvert: (options) async {
                controller.uploadAndRequestConvert(options);
              },
            ));
      },
    );
  }
}
