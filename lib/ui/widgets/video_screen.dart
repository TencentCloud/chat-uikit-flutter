import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_video_elem.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_video_elem.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_callback.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKITMessageItem/tim_uikit_chat_videoplayer.dart';
import 'package:universal_html/html.dart' as html;

class VideoScreen extends StatefulWidget {
  const VideoScreen({required this.message, required this.heroTag, required this.videoElement, Key? key})
      : super(key: key);

  final V2TimMessage message;
  final dynamic heroTag;
  final V2TimVideoElem videoElement;

  @override
  State<StatefulWidget> createState() => _VideoScreenState();
}

class _VideoScreenState extends TIMUIKitState<VideoScreen> {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey = GlobalKey<ExtendedImageSlidePageState>();
  final TUIChatGlobalModel model = serviceLocator<TUIChatGlobalModel>();

  @override
  initState() {
    super.initState();
    // 允许横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  //保存网络视频到本地
  Future<void> _saveNetworkVideo(
    context,
    String videoUrl, {
    bool isAsset = true,
  }) async {
    if (PlatformUtils().isWeb) {
      RegExp exp = RegExp(r"((\.){1}[^?]{2,4})");
      String? suffix = exp.allMatches(videoUrl).last.group(0);
      var xhr = html.HttpRequest();
      xhr.open('get', videoUrl);
      xhr.responseType = 'arraybuffer';
      xhr.onLoad.listen((event) {
        final a = html.AnchorElement(href: html.Url.createObjectUrl(html.Blob([xhr.response])));
        a.download = '${md5.convert(utf8.encode(videoUrl)).toString()}$suffix';
        a.click();
        a.remove();
      });
      xhr.send();
      return;
    }
    if (PlatformUtils().isMobile) {
      if (PlatformUtils().isIOS) {
        if (!await Permissions.checkPermission(
          context,
          Permission.photosAddOnly.value,
        )) {
          return;
        }
      } else {
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if ((androidInfo.version.sdkInt) >= 33) {
          final videos = await Permissions.checkPermission(
            context,
            Permission.videos.value,
          );

          if (!videos) {
            return;
          }
        } else {
          final storage = await Permissions.checkPermission(
            context,
            Permission.storage.value,
          );
          if (!storage) {
            return;
          }
        }
      }
    }
    String savePath = videoUrl;
    if (!isAsset) {
      if (widget.message.msgID == null || widget.message.msgID!.isEmpty) {
        return;
      }
      if (model.getMessageProgress(widget.message.msgID) == 100) {
        String savePath;
        if (widget.message.videoElem!.localVideoUrl != null && widget.message.videoElem!.localVideoUrl != '') {
          savePath = widget.message.videoElem!.localVideoUrl!;
        } else {
          savePath = model.getFileMessageLocation(widget.message.msgID);
        }
        File f = File(savePath);
        if (f.existsSync()) {
          var result = await ImageGallerySaverPlus.saveFile(savePath);
          if (PlatformUtils().isIOS) {
            if (result['isSuccess']) {
              onTIMCallback(
                  TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("视频保存成功"), infoCode: 6660402));
            } else {
              onTIMCallback(
                  TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("视频保存失败"), infoCode: 6660403));
            }
          } else {
            if (result != null) {
              onTIMCallback(
                  TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("视频保存成功"), infoCode: 6660402));
            } else {
              onTIMCallback(
                  TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("视频保存失败"), infoCode: 6660403));
            }
          }
        }
      } else {
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO, infoRecommendText: TIM_t("the message is downloading"), infoCode: -1));
      }
      return;
    }
    var result = await ImageGallerySaverPlus.saveFile(savePath);
    if (PlatformUtils().isIOS) {
      if (result['isSuccess']) {
        onTIMCallback(TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("视频保存成功"), infoCode: 6660402));
      } else {
        onTIMCallback(TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("视频保存失败"), infoCode: 6660403));
      }
    } else {
      if (result != null) {
        onTIMCallback(TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("视频保存成功"), infoCode: 6660402));
      } else {
        onTIMCallback(TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("视频保存失败"), infoCode: 6660403));
      }
    }
    return;
  }

  Future<void> _saveVideo() async {
    if (PlatformUtils().isWeb) {
      return await _saveNetworkVideo(
        context,
        widget.videoElement.videoPath!,
        isAsset: true,
      );
    }
    if (widget.videoElement.videoPath != '' &&
        widget.videoElement.videoPath != null &&
        File(widget.videoElement.videoPath!).existsSync()) {
      File f = File(widget.videoElement.videoPath!);
      if (f.existsSync()) {
        return await _saveNetworkVideo(
          context,
          widget.videoElement.videoPath!,
          isAsset: true,
        );
      }
    }
    if (widget.videoElement.localVideoUrl != '' && widget.videoElement.localVideoUrl != null) {
      File f = File(widget.videoElement.localVideoUrl!);
      if (f.existsSync()) {
        return await _saveNetworkVideo(
          context,
          widget.videoElement.localVideoUrl!,
          isAsset: true,
        );
      }
    }
    return await _saveNetworkVideo(
      context,
      widget.videoElement.videoUrl!,
      isAsset: false,
    );
  }

  double getVideoHeight() {
    double height = widget.videoElement.snapshotHeight!.toDouble();
    double width = widget.videoElement.snapshotWidth!.toDouble();
    // 横图
    if (width > height) {
      return height * 1.3;
    }
    return height;
  }

  double getVideoWidth() {
    double height = widget.videoElement.snapshotHeight!.toDouble();
    double width = widget.videoElement.snapshotWidth!.toDouble();
    // 横图
    if (width > height) {
      return width * 1.3;
    }
    return width;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return OrientationBuilder(builder: ((context, orientation) {
      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              child: ExtendedImageSlidePage(
                key: slidePagekey,
                slidePageBackgroundHandler: (Offset offset, Size size) {
                  if (orientation == Orientation.landscape) {
                    return Colors.black;
                  }
                  double opacity = 0.0;
                  opacity = offset.distance / (Offset(size.width, size.height).distance / 2.0);
                  return Colors.black.withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
                },
                slideType: SlideType.onlyImage,
                slideEndHandler: (
                  Offset offset, {
                  ExtendedImageSlidePageState? state,
                  ScaleEndDetails? details,
                }) {
                  final vy = details?.velocity.pixelsPerSecond.dy ?? 0;
                  final oy = offset.dy;
                  if (vy > 300 || oy > 100) {
                    return true;
                  }
                  return null;
                },
                child: TIMUIKitVideoPlayer(
                  message: widget.message,
                  controller: true,
                  isSending: widget.message.status == MessageStatus.V2TIM_MSG_STATUS_SENDING,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: IconButton(
                icon: Image.asset(
                  'images/close.png',
                  package: 'tencent_cloud_chat_uikit',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                icon: Image.asset(
                  'images/download.png',
                  package: 'tencent_cloud_chat_uikit',
                ),
                onPressed: () async {
                  await _saveVideo();
                },
              ),
            ),
          ],
        ),
      );
    }));
  }
}
