import 'dart:io';
import 'dart:math';

import 'package:chewie_for_us/chewie_for_us.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/history_message_constant.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/im_media_msg_browser/image_item.dart';
import 'package:video_player/video_player.dart';

import 'bottom_actions.dart';
import 'video_custom_controls.dart';
import 'video_item.dart';

class IMMediaMsgBrowser extends StatefulWidget {
  const IMMediaMsgBrowser({
    super.key,
    this.onDownloadFile,
    this.onImgLongPress,
    required this.curMsg,
    this.isFrom,
    this.userID,
    this.groupID,
  });

  final V2TimMessage curMsg;
  final String? isFrom;
  final String? userID;
  final String? groupID;
  final ValueChanged<String>? onDownloadFile;
  final ValueChanged<String>? onImgLongPress;

  @override
  IMMediaMsgBrowserState createState() => IMMediaMsgBrowserState();
}

class IMMediaMsgBrowserState extends State<IMMediaMsgBrowser>
    with TickerProviderStateMixin {
  final _messageManager = TencentImSDKPlugin.v2TIMManager.getMessageManager();
  late AnimationController _slideEndAnimationController;
  late Animation<double> _slideEndAnimation;
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  double _imageDetailY = 0;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  late final ExtendedPageController _pageController;

  bool _isNewerFinished = false;
  bool _isOldFinished = false;
  bool _isLoadingOld = false;
  bool _isLoadingNewer = false;
  bool _isFirstLoading = true;
  final List<V2TimMessage> _msgs = [];

  bool get _isCurMsgVideo =>
      widget.curMsg.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO;

  bool isInit = false;
  bool get isTest {
    return Platform.isAndroid;
  }

  final FijkPlayer fijkPlayer = FijkPlayer();

  void _safeSetState(void Function() fn) {
    if (mounted) {
      slidePagekey = GlobalKey<ExtendedImageSlidePageState>();
      setState(fn);
    }
  }

  int _currentIndex = 0;

  _onDownloadImg() {
    // TODO: 区分视频和图片调用单独的下载逻辑
  }

  Future<void> _onLongPress() async {
    final msg = _msgs[_currentIndex];
    final url = msg.imageElem?.imageList?.firstOrNull?.url ?? '';
    widget.onImgLongPress?.call(url);
  }

  void _onPageChanged(int index) {
    _currentIndex = index;
    if (_imageDetailY != 0) {
      _imageDetailY = 0;
    }

    if (_msgs.isEmpty) return;

    if (index <= 3) {
      _getOldMsg(_msgs.first.msgID);
    }
    if (index >= _msgs.length - 3) {
      _getNewerMsg(_msgs.last.msgID);
    }
  }

  @override
  void initState() {
    _msgs.add(widget.curMsg);
    _getInitialMsgs();

    if (_isCurMsgVideo) {
      _setVideoPlayerController(widget.curMsg.videoElem?.videoUrl ?? '');
      // 允许横屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    _slideEndAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _slideEndAnimationController.addListener(() {
      _imageDetailY = _slideEndAnimation.value;
      if (_imageDetailY == 0) {}
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (isTest) {
      fijkPlayer.dispose();
    }
    if (isInit) {
      videoPlayerController?.dispose();
      chewieController?.dispose();
    }

    _slideEndAnimationController.dispose();
    _pageController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ExtendedImageSlidePage(
        key: slidePagekey,
        slideAxis: SlideAxis.vertical,
        slideScaleHandler: _slideScaleHandler,
        slideOffsetHandler: _slideOffsetHandler,
        slideEndHandler: _slideEndHandler,
        onSlidingPage: _onSlidingPage,
        child: Material(
          color: Colors.black,
          shadowColor: Colors.transparent,
          child: _isFirstLoading
              ? InkWell(
                  onTap: () {
                    slidePagekey.currentState?.popPage();
                    Navigator.pop(context);
                  },
                  child: const SizedBox.expand(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ExtendedImageGesturePageView.builder(
                      itemCount: _msgs.length,
                      onPageChanged: _onPageChanged,
                      controller: _pageController,
                      physics: _msgs.length > 1
                          ? const BouncingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      canScrollPage: (GestureDetails? gestureDetails) {
                        return _imageDetailY >= 0;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final msg = _msgs[index];
                        final heroTag =
                            "${msg.msgID ?? msg.id ?? msg.timestamp ?? DateTime.now().millisecondsSinceEpoch}${widget.isFrom}";

                        if (msg.videoElem != null) {
                          final videoElement = msg.videoElem;
                          debugPrint('videoElement: ${videoElement?.toJson()}');
                          return VideoItem(
                            isInit: isInit,
                            isTest: isTest,
                            fijkPlayer: fijkPlayer,
                            chewieController: chewieController,
                            videoUrl: videoElement?.videoUrl ?? '',
                            coverUrl: videoElement?.snapshotUrl ?? '',
                            onDownloadFile: widget.onDownloadFile,
                            heroTag: heroTag,
                          );
                        } else if (msg.imageElem != null) {
                          final imageElement = msg.imageElem;
                          final smallImg = MessageUtils.getImageFromImgList(
                            imageElement?.imageList,
                            HistoryMessageDartConstant.smallImgPrior,
                          );
                          return ImageItem(
                            imgUrl: smallImg?.url ?? '',
                            size: size,
                            useHeroWrapper: index < min(9, _msgs.length),
                            canScaleImage: (_) => _imageDetailY == 0,
                            onImgTap: () {
                              if (_imageDetailY != 0) {
                                _imageDetailY = 0;
                              } else {
                                slidePagekey.currentState?.popPage();
                                Navigator.pop(context);
                              }
                            },
                            heroTag: heroTag,
                            slidePagekey: slidePagekey,
                            onLongPress: _onLongPress,
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 0,
                      child: SafeArea(
                        top: false,
                        child: BottomActions(
                          onDownload: _onDownloadImg,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

extension _IMMediaMsgBrowserStateEvents on IMMediaMsgBrowserState {
  double? _slideScaleHandler(
    Offset offset, {
    ExtendedImageSlidePageState? state,
  }) {
    if (state != null && state.scale == 1.0) {
      if (state.imageGestureState!.gestureDetails!.totalScale! > 1.0) {
        return 1.0;
      }
      if (offset.dy < 0 || _imageDetailY < 0) {
        return 1.0;
      }
    }

    return null;
  }

  void _onSlidingPage(ExtendedImageSlidePageState state) {}

  Offset? _slideOffsetHandler(
    Offset offset, {
    ExtendedImageSlidePageState? state,
  }) {
    if (state != null && state.scale == 1.0) {
      if (state.imageGestureState!.gestureDetails!.totalScale! > 1.0) {
        return Offset.zero;
      }

      if (offset.dy < 0 || _imageDetailY < 0) {
        return Offset.zero;
      }

      if (_imageDetailY != 0) {
        _imageDetailY = 0;
      }
    }
    return null;
  }

  bool? _slideEndHandler(
    Offset offset, {
    ExtendedImageSlidePageState? state,
    ScaleEndDetails? details,
  }) {
    if (_imageDetailY != 0 && state!.scale == 1) {
      if (!_slideEndAnimationController.isAnimating) {
        final double magnitude = details!.velocity.pixelsPerSecond.distance;
        if (magnitude.greaterThanOrEqualTo(minMagnitude)) {
          final Offset direction =
              details.velocity.pixelsPerSecond / magnitude * 1000;
          _slideEndAnimation = _slideEndAnimationController.drive(
            Tween<double>(
              begin: _imageDetailY,
              end: _imageDetailY + direction.dy,
            ),
          );
          _slideEndAnimationController.reset();
          _slideEndAnimationController.forward();
        }
      }
      return false;
    }
    return null;
  }
}

extension _IMMediaMsgBrowserStateApi on IMMediaMsgBrowserState {
  Future<void> _getInitialMsgs() async {
    final curMsg = _msgs[_currentIndex];
    await _getOldMsg(widget.curMsg.msgID);
    await _getNewerMsg(widget.curMsg.msgID);
    final newIndex =
        _msgs.indexWhere((element) => element.msgID == curMsg.msgID);
    debugPrint('_getInitialMsgs: newIndex: $newIndex');
    if (newIndex != -1) {
      await Future.delayed(const Duration(milliseconds: 300));
      _pageController = ExtendedPageController(initialPage: newIndex);
    }
    _safeSetState(() {
      _isFirstLoading = false;
    });
  }

  Future<void> _getOldMsg(
    String? lastMsgID,
  ) async {
    debugPrint('_getOldMsg');
    if (_isLoadingOld) return;
    if (_isOldFinished) return;
    _isLoadingOld = true;

    final res = await _getMediaMsgList(lastMsgID: lastMsgID);
    _isOldFinished = res?.isFinished ?? true;
    final msgs = res?.messageList ?? [];

    if (msgs.isNotEmpty) {
      _msgs.insertAll(0, msgs.reversed);
      _safeSetState(() {});
    }
    _isLoadingOld = false;
  }

  Future<void> _getNewerMsg(
    String? lastMsgID,
  ) async {
    debugPrint('_getNewerMsg');
    if (_isLoadingNewer) return;
    if (_isNewerFinished) return;
    _isLoadingNewer = true;

    final res = await _getMediaMsgList(
      lastMsgID: widget.curMsg.msgID,
      getType: HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_NEWER_MSG,
    );
    _isNewerFinished = res?.isFinished ?? true;
    final msgs = res?.messageList ?? [];
    if (msgs.isNotEmpty) {
      _msgs.addAll(msgs);
      _safeSetState(() {});
    }

    _isLoadingNewer = false;
  }

  /// 获取媒体消息：图片、视频
  Future<V2TimMessageListResult?> _getMediaMsgList({
    String? lastMsgID,
    HistoryMsgGetTypeEnum getType =
        HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
  }) async {
    final res = await _messageManager.getHistoryMessageListV2(
      count: 10,
      userID: widget.userID,
      groupID: widget.groupID,
      getType: getType,
      lastMsgID: lastMsgID,
      messageTypeList: [
        MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
        // MessageElemType.V2TIM_ELEM_TYPE_VIDEO,
      ],
    );

    debugPrint('getMediaMsgList: code = ${res.code}, desc = ${res.desc}');
    return res.data;
  }
}

extension _IMMediaMsgBrowserStatePrivate on IMMediaMsgBrowserState {
  Future<void> _setVideoPlayerController(String url) async {
    if (url.isEmpty) return;
    if (isTest) {
      fijkPlayer.addListener(
        () {
          if (fijkPlayer.state == FijkState.started) {
            _safeSetState(() {
              isInit = true;
            });
          }
        },
      );

      fijkPlayer.setDataSource(url, autoPlay: true);
      // await fijkPlayer.prepareAsync();
    } else {
      VideoPlayerController player = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );
      await player.initialize();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ChewieController controller = ChewieController(
            videoPlayerController: player,
            autoPlay: true,
            looping: false,
            showControlsOnInitialize: false,
            allowPlaybackSpeedChanging: false,
            customControls: VideoCustomControls(
              downloadFn: () async => widget.onDownloadFile?.call(url),
            ),
          );
          _safeSetState(
            () {
              videoPlayerController = player;
              chewieController = controller;
              isInit = true;
            },
          );
        },
      );
    }
  }
}
