import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/media_download_util.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

import 'fijk_panel.dart';

class KangXunVideoScreen extends StatefulWidget {
  const KangXunVideoScreen(
      {required this.message,
      required this.heroTag,
      required this.videoElement,
      Key? key})
      : super(key: key);

  final V2TimMessage message;
  final dynamic heroTag;
  final V2TimVideoElem videoElement;

  @override
  State<StatefulWidget> createState() => _KangXunVideoScreenState();
}

class _KangXunVideoScreenState extends TIMUIKitState<KangXunVideoScreen>
    with WidgetsBindingObserver {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
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
    WidgetsBinding.instance.addObserver(this); // 注册监听器
  }

  Future<void> _saveVideo() async {
    return MediaDownloadUtil.of.saveVideo(
      context,
      videoElement: widget.videoElement,
      message: widget.message,
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

  final FijkPlayer fijkPlayer = FijkPlayer();

  setVideoPlayerController() async {
    fijkPlayer.addListener(
      () {
        if (fijkPlayer.state == FijkState.started) {
          setState(() {
            isInit = true;
          });
        }
      },
    );

    String videoPath = PlatformUtils().isWeb
        ? ((TencentUtils.checkString(widget.videoElement.videoPath) != null) ||
                widget.message.status == MessageStatus.V2TIM_MSG_STATUS_SENDING
            ? widget.videoElement.videoPath!
            : (TencentUtils.checkString(widget.videoElement.localVideoUrl) ==
                    null)
                ? widget.videoElement.videoUrl!
                : widget.videoElement.localVideoUrl!)
        : (TencentUtils.checkString(widget.videoElement.videoPath) != null ||
                widget.message.status == MessageStatus.V2TIM_MSG_STATUS_SENDING)
            ? widget.videoElement.videoPath!
            : (TencentUtils.checkString(widget.videoElement.localVideoUrl) ==
                    null)
                ? widget.videoElement.videoUrl!
                : widget.videoElement.localVideoUrl!;

    fijkPlayer.setDataSource(
      videoPath,
      autoPlay: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // double w = getVideoWidth();
      // double h = getVideoHeight();

      // setState(() {
      //   isInit = true;
      // });
    });
  }

  @override
  didUpdateWidget(oldWidget) {
    if (oldWidget.videoElement.videoUrl != widget.videoElement.videoUrl ||
        oldWidget.videoElement.videoPath != widget.videoElement.videoPath) {
      setVideoPlayerController();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (Platform.isIOS) {
      return;
    }
    switch (state) {
      case AppLifecycleState.inactive:
      //
      case AppLifecycleState.resumed:
        //在前台
        fijkPlayer.start();
      case AppLifecycleState.paused:
        // 在后台
        fijkPlayer.pause();
      default:
        break;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WidgetsBinding.instance.removeObserver(this); // 移除监听器
    if (isInit) {
      if (fijkPlayer.state == FijkState.started) {
        fijkPlayer.stop();
      }

      fijkPlayer.release();
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
                  opacity = offset.distance /
                      (Offset(size.width, size.height).distance / 2.0);
                  return Colors.black
                      .withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
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
                          ? FijkView(
                              player: fijkPlayer,
                              color: Colors.black,
                              panelBuilder: (player, data, context, viewSize,
                                  texturePos) {
                                return kangXunFijkPanelBuilder(
                                    player, data, context, viewSize, texturePos,
                                    () async {
                                  return await _saveVideo();
                                });
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white))),
                  heroBuilderForSlidingPage: (Widget result) {
                    return Hero(
                      tag: widget.heroTag,
                      child: result,
                      flightShuttleBuilder: (BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext) {
                        final Hero hero =
                            (flightDirection == HeroFlightDirection.pop
                                ? fromHeroContext.widget
                                : toHeroContext.widget) as Hero;

                        return hero.child;
                      },
                    );
                  },
                )),
          ));
    }));
  }
}
