import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/video_custom_control.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({required this.message, required this.heroTag, required this.videoElement, Key? key}) : super(key: key);

  final V2TimMessage message;
  final dynamic heroTag;
  final V2TimVideoElem videoElement;

  @override
  State<StatefulWidget> createState() => _VideoScreenState();
}

class _VideoScreenState extends TIMUIKitState<VideoScreen> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  GlobalKey<ExtendedImageSlidePageState> slidePagekey = GlobalKey<ExtendedImageSlidePageState>();
  final TUIChatGlobalModel model = serviceLocator<TUIChatGlobalModel>();
  bool isInit = false;

  @override
  initState() {
    super.initState();
    setVideoPlayerController();
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
          var result = await ImageGallerySaver.saveFile(savePath);
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
        }
      } else {
        onTIMCallback(TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("the message is downloading"), infoCode: -1));
      }
      return;
    }
    var result = await ImageGallerySaver.saveFile(savePath);
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
    if (widget.videoElement.videoPath != '' && widget.videoElement.videoPath != null) {
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

  setVideoPlayerController() async {
    if (!PlatformUtils().isWeb) {
      if (TencentUtils.checkString(widget.message.msgID) != null && widget.videoElement.localVideoUrl == null) {
        String savePath = model.getFileMessageLocation(widget.message.msgID);
        File f = File(savePath);
        if (f.existsSync()) {
          widget.videoElement.localVideoUrl = savePath;
        }
      }
    }

    VideoPlayerController player = PlatformUtils().isWeb
        ? ((TencentUtils.checkString(widget.videoElement.videoPath) != null) || widget.message.status == MessageStatus.V2TIM_MSG_STATUS_SENDING
            ? VideoPlayerController.networkUrl(
                Uri.parse(widget.videoElement.videoPath!),
              )
            : (TencentUtils.checkString(widget.videoElement.localVideoUrl) == null)
                ? VideoPlayerController.networkUrl(
                    Uri.parse(widget.videoElement.videoUrl!),
                  )
                : VideoPlayerController.networkUrl(
                    Uri.parse(widget.videoElement.localVideoUrl!),
                  ))
        : (TencentUtils.checkString(widget.videoElement.videoPath) != null || widget.message.status == MessageStatus.V2TIM_MSG_STATUS_SENDING)
            ? VideoPlayerController.file(File(widget.videoElement.videoPath!))
            : (TencentUtils.checkString(widget.videoElement.localVideoUrl) == null)
                ? VideoPlayerController.networkUrl(
                    Uri.parse(widget.videoElement.videoUrl!),
                  )
                : VideoPlayerController.file(File(
                    widget.videoElement.localVideoUrl!,
                  ));
    await player.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double w = getVideoWidth();
      double h = getVideoHeight();
      ChewieController controller = ChewieController(
          videoPlayerController: player,
          autoPlay: true,
          looping: false,
          showControlsOnInitialize: false,
          allowPlaybackSpeedChanging: false,
          aspectRatio: w == 0 || h == 0 ? null : w / h,
          customControls: VideoCustomControls(downloadFn: () async {
            return await _saveVideo();
          }));
      setState(() {
        videoPlayerController = player;
        chewieController = controller;
        isInit = true;
      });
    });
  }

  @override
  didUpdateWidget(oldWidget) {
    if (oldWidget.videoElement.videoUrl != widget.videoElement.videoUrl || oldWidget.videoElement.videoPath != widget.videoElement.videoPath) {
      setVideoPlayerController();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (isInit) {
      videoPlayerController.dispose();
      chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return OrientationBuilder(builder: ((context, orientation) {
      return Material(
          color: Colors.transparent,
          child: Container(
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
                child: ExtendedImageSlidePageHandler(
                  child: Container(
                      color: Colors.black,
                      child: isInit
                          ? Chewie(
                              controller: chewieController,
                            )
                          : const Center(child: CircularProgressIndicator(color: Colors.white))),
                  heroBuilderForSlidingPage: (Widget result) {
                    return Hero(
                      tag: widget.heroTag,
                      child: result,
                      flightShuttleBuilder: (BuildContext flightContext, Animation<double> animation, HeroFlightDirection flightDirection, BuildContext fromHeroContext, BuildContext toHeroContext) {
                        final Hero hero = (flightDirection == HeroFlightDirection.pop ? fromHeroContext.widget : toHeroContext.widget) as Hero;

                        return hero.child;
                      },
                    );
                  },
                )),
          ));
    }));
  }
}
