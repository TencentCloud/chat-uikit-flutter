import 'dart:io';
import 'dart:math';

import 'package:chewie_for_us/chewie_for_us.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/im_media_msg_browser/image_item.dart';
import 'package:video_player/video_player.dart';

import 'bottom_actions.dart';
import 'video_custom_controls.dart';

class IMMediaMsgBrowser extends StatefulWidget {
  const IMMediaMsgBrowser({
    super.key,
    this.onDownloadFile,
    this.onImgLongPress,
    required this.curMsg,
    this.isFrom,
    this.userID,
    this.groupID,
    this.onDownloadImage,
  });

  final V2TimMessage curMsg;
  final String? isFrom;
  final String? userID;
  final String? groupID;
  final ValueChanged<String>? onDownloadFile;
  final ValueChanged<V2TimMessage>? onImgLongPress;
  final ValueChanged<V2TimMessage>? onDownloadImage;

  @override
  IMMediaMsgBrowserState createState() => IMMediaMsgBrowserState();
}

class IMMediaMsgBrowserState extends TIMUIKitState<IMMediaMsgBrowser>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _messageManager = TencentImSDKPlugin.v2TIMManager.getMessageManager();

  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  double _imageDetailY = 0;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  ExtendedPageController? _pageController;

  bool _isNewerFinished = false;
  bool _isOldFinished = false;
  bool _isLoadingOld = false;
  bool _isLoadingNewer = false;
  bool _isFirstLoading = true;
  final List<V2TimMessage> _msgs = [];
  final _isDownloadingImg = ValueNotifier(false);

  int _currentIndex = 0;

  bool get _isCurMsgVideo =>
      widget.curMsg.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO;

  bool isInit = false;
  bool get isTest {
    return Platform.isAndroid;
  }

  // final FijkPlayer _fijkPlayer = FijkPlayer();

  void _safeSetState(void Function() fn) {
    if (mounted) {
      setState(fn);
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

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (Platform.isIOS) {
      return;
    }

    // switch (state) {
    //   case AppLifecycleState.inactive:
    //   //
    //   case AppLifecycleState.resumed:
    //     //在前台
    //     _fijkPlayer.start();
    //   case AppLifecycleState.paused:
    //     // 在后台
    //     _fijkPlayer.pause();
    //   default:
    //     break;
    // }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // if (isTest) {
    //   _fijkPlayer.stop();
    //   _fijkPlayer.dispose();
    // }

    if (isInit) {
      videoPlayerController?.dispose();
      chewieController?.dispose();
    }

    _pageController?.dispose();
    clearGestureDetailsCache();
    _isDownloadingImg.dispose();
    super.dispose();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: _isFirstLoading
          ? InkWell(
              onTap: _close,
              child: const SizedBox.expand(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            )
          : ExtendedImageSlidePage(
              key: slidePagekey,
              slideAxis: SlideAxis.vertical,
              slidePageBackgroundHandler: (Offset offset, Size size) {
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
              child: Stack(
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
                        return const Center(
                          child: Text('敬请期待'),
                        );
                        // final videoElement = msg.videoElem;
                        // return VideoItem(
                        //   isInit: isInit,
                        //   isTest: isTest,
                        //   fijkPlayer: _fijkPlayer,
                        //   chewieController: chewieController,
                        //   videoUrl: videoElement?.videoUrl ?? '',
                        //   coverUrl: videoElement?.snapshotUrl ?? '',
                        //   onDownloadFile: widget.onDownloadFile,
                        //   heroTag: heroTag,
                        // );
                      } else if (msg.imageElem != null) {
                        return ImageItem(
                          message: msg,
                          size: size,
                          heroTag: heroTag,
                          slidePagekey: slidePagekey,
                          imageDetailY: _imageDetailY,
                          canScaleImage: (_) => _imageDetailY == 0,
                          onImgTap: () {
                            if (_imageDetailY != 0) {
                              _imageDetailY = 0;
                            } else {
                              _close();
                            }
                          },
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
                        onDownload: _saveImg,
                      ),
                    ),
                  ),
                  Align(
                    child: ValueListenableBuilder(
                      valueListenable: _isDownloadingImg,
                      builder: (context, isDownloadingImg, child) {
                        return isDownloadingImg
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircularProgressIndicator(
                                        color: Colors.white),
                                    const SizedBox(height: 4),
                                    Text(
                                      TIM_t("正在下载中"),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

extension _IMMediaMsgBrowserStateEvents on IMMediaMsgBrowserState {
  _close() {
    slidePagekey.currentState?.popPage();
    Navigator.pop(context);
  }

  Future<void> _onLongPress() async {
    final msg = _msgs[_currentIndex];
    widget.onImgLongPress?.call(msg);
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
}

extension _IMMediaMsgBrowserStateApi on IMMediaMsgBrowserState {
  Future<void> _getInitialMsgs() async {
    final curMsg = _msgs[_currentIndex];
    await _getOldMsg(widget.curMsg.msgID);
    await _getNewerMsg(widget.curMsg.msgID);
    final newIndex =
        _msgs.indexWhere((element) => element.msgID == curMsg.msgID);
    if (newIndex != -1) {
      _currentIndex = newIndex;
      _pageController = ExtendedPageController(initialPage: newIndex);
    }
    _safeSetState(() {
      _isFirstLoading = false;
    });
  }

  Future<void> _getOldMsg(
    String? lastMsgID,
  ) async {
    if (_isLoadingOld) return;
    if (_isOldFinished) return;
    _isLoadingOld = true;

    final res = await _getMediaMsgList(lastMsgID: lastMsgID);
    _isOldFinished = res.$1;
    final msgs = res.$2;

    final curMsg = _msgs[_currentIndex];
    if (msgs.isNotEmpty) {
      _msgs.insertAll(0, msgs.reversed);

      _safeSetState(() {
        final curMsgIndex =
            _msgs.indexWhere((element) => element.msgID == curMsg.msgID);
        if (curMsgIndex != -1 && !_isFirstLoading) {
          _currentIndex = curMsgIndex;
          _pageController = ExtendedPageController(initialPage: curMsgIndex);
          // _pageController.jumpToPage(msgs.length + _currentIndex);
        }
      });
    }
    _isLoadingOld = false;
  }

  Future<void> _getNewerMsg(
    String? lastMsgID,
  ) async {
    if (_isLoadingNewer) return;
    if (_isNewerFinished) return;
    _isLoadingNewer = true;

    final res = await _getMediaMsgList(
      lastMsgID: widget.curMsg.msgID,
      getType: HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_NEWER_MSG,
    );
    _isNewerFinished = res.$1;
    final msgs = res.$2;
    if (msgs.isNotEmpty) {
      _msgs.addAll(msgs);
      _safeSetState(() {});
    }

    _isLoadingNewer = false;
  }

  /// 获取媒体消息：图片、视频
  Future<(bool isFinished, List<V2TimMessage> msgs)> _getMediaMsgList({
    String? lastMsgID,
    HistoryMsgGetTypeEnum getType =
        HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
  }) async {
    // merger、reply 两种情况不需要请求更多图片
    if (widget.isFrom != null && widget.isFrom != '') {
      debugPrint('_getMediaMsgList isFrom: ${widget.isFrom}');
      return (true, <V2TimMessage>[]);
    }
    // userID 和 groupID 不合法的情况下不需要请求更多图片
    if ((widget.userID == null || widget.userID == '') &&
        (widget.groupID == null || widget.groupID == '')) {
      return (true, <V2TimMessage>[]);
    }

    try {
      final res = await _messageManager.getHistoryMessageListV2(
        count: 100,
        userID: widget.userID,
        groupID: widget.groupID,
        getType: getType,
        lastMsgID: lastMsgID,
        messageTypeList: [
          MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
          // MessageElemType.V2TIM_ELEM_TYPE_VIDEO,
        ],
      );
      if (res.code != 0) {
        debugPrint('getMediaMsgList: code = ${res.code}, desc = ${res.desc}');
      }

      // 过滤被删除和撤回的消息
      final msgList = List.of((res.data?.messageList ?? []).where((element) =>
          element.status != MessageStatus.V2TIM_MSG_STATUS_HAS_DELETED &&
          element.status != MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED));
      return (
        res.data?.isFinished ?? true,
        msgList,
      );
    } catch (e) {
      debugPrint('_getMediaMsgList error: $e');
      return (true, <V2TimMessage>[]);
    }
  }
}

extension _IMMediaMsgBrowserStatePrivate on IMMediaMsgBrowserState {
  Future<void> _setVideoPlayerController(String url) async {
    if (url.isEmpty) return;
    if (isTest) {
      // _fijkPlayer.addListener(
      //   () {
      //     if (_fijkPlayer.state == FijkState.started) {
      //       _safeSetState(() {
      //         isInit = true;
      //       });
      //     }
      //   },
      // );

      // _fijkPlayer.setDataSource(url, autoPlay: true);
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

extension IMMediaMsgBrowserStateDownloadImg on IMMediaMsgBrowserState {
  Future<void> _saveImg() async {
    final msg = _msgs[_currentIndex];
    widget.onDownloadImage?.call(msg);
  }
}
