import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_download_utils.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_viewer/tencent_cloud_chat_message_viewer.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

// static final int 	V2TIM_IMAGE_TYPE_ORIGIN = 0

// static final int 	V2TIM_IMAGE_TYPE_THUMB = 1

// static final int 	V2TIM_IMAGE_TYPE_LARGE = 2

enum ImageType {
  origin,
  thumb,
  large,
}

enum ImageCurrentRenderType {
  online,
  local,
  path,
}

class ImageCurrentRenderInfo {
  final ImageCurrentRenderType type;
  final String path;

  ImageCurrentRenderInfo({
    required this.path,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return Map.from({
      "type": type.name,
      "path": path,
    });
  }
}

class TencentCloudChatMessageImage extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageImage({
    super.key,
    required super.data,
    required super.methods,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageImageState();
}

class _TencentCloudChatMessageImageState extends TencentCloudChatMessageState<TencentCloudChatMessageImage> {
  @override
  void didUpdateWidget(covariant TencentCloudChatMessageImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.sendingMessageData != null) {
      if ((oldWidget.data.sendingMessageData == null || !oldWidget.data.sendingMessageData!.isSendComplete || oldWidget.data.sendingMessageData!.progress != 100) &&
          widget.data.sendingMessageData != null &&
          widget.data.sendingMessageData!.isSendComplete) {
        _getImageUrl();
      }
    }
  }

  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData<dynamic>>("TencentCloudChatMessageData");
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? __messageDataSubscription;
  final String _tag = "TencentCloudChatMessageImage";

  bool isErrorMessage = false;

  bool? onlineRenderResult;
  static int onlineRenderKey = 0;

  int renderRandom = Random().nextInt(100000);

  ImageCurrentRenderInfo? currentRenderImageInfo;

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: json.encode(
        {
          "msgID": widget.data.message.msgID,
          "log": log,
        },
      ),
    );
  }

  Map<String, dynamic>? setLocalDelayData;

  DownloadMessageQueueData generateDownloadData({
    required int type,
    required int conversationType,
    required String key,
    V2TimMessage? message,
  }) {
    message ??= widget.data.message;
    return DownloadMessageQueueData(
      conversationType: conversationType,
      msgID: message.msgID ?? "",
      messageType: MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
      imageType: type,
      // download origin image
      isSnapshot: false,
      key: key,
      convID: key,
    );
  }

  addDownloadMessageToQueue({
    required bool isOrigin,
  }) {
    if (isSendingMessage()) {
      console("message is sending. download break.");
      return;
    }

    bool hasLocalImagePath = hasLocalImage(isOrigin: isOrigin);
    if (hasLocalImagePath) {
      console("message has local url. isOrigin:${isOrigin}.");
      return;
    }

    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return;
      }

      int type = ImageType.thumb.index;
      if (isOrigin) {
        type = ImageType.origin.index;
      }

      TencentCloudChatDownloadUtils.addDownloadMessageToQueue(
        data: generateDownloadData(type: type, conversationType: conversationType, key: key),
      );
    }
  }

  bool isSendingMessage() {
    if (widget.data.message.status == 1) {
      return true;
    }
    return false;
  }

  Future<bool> hasSelfClientPath() async {
    if (widget.data.message.imageElem != null && !TencentCloudChatPlatformAdapter().isWeb) {
      if (TencentCloudChatUtils.checkString(widget.data.message.imageElem!.path) != null) {
        if (File(widget.data.message.imageElem!.path!).existsSync()) {
          return true;
        }
      }
    }
    return false;
  }

  bool hasLocalImage({
    bool? isOrigin,
  }) {
    bool res = false;
    if (widget.data.message.imageElem != null && !TencentCloudChatPlatformAdapter().isWeb) {
      V2TimImageElem images = widget.data.message.imageElem!;
      String localUrl = "";
      List<V2TimImage?> imageLists = images.imageList ?? [];
      if (imageLists.isNotEmpty) {
        for (var i = 0; i < imageLists.length; i++) {
          V2TimImage? image = imageLists[i];
          if (image != null) {
            int type = isOrigin == true ? ImageType.origin.index : ImageType.thumb.index;
            if (image.type == type) {
              if (TencentCloudChatUtils.checkString(image.localUrl) != null) {
                localUrl = image.localUrl!;
              }
              break;
            }
          }
        }
      }
      if (localUrl.isNotEmpty && File(localUrl).existsSync()) {
        res = true;
      }
    }

    return res;
  }

  String getRenderLocalUrlFormImageElem(V2TimImageElem image, int type) {
    String res = '';
    if (image.imageList != null) {
      if (image.imageList!.isNotEmpty) {
        for (var i = 0; i < image.imageList!.length; i++) {
          var img = image.imageList![i];
          if (img != null) {
            if (img.type == type) {
              if (img.localUrl != null) {
                if (img.localUrl!.isNotEmpty) {
                  res = img.localUrl!;
                }
              }
            }
          }
        }
      }
    }
    return res;
  }

  String getOnlineThumbUrl() {
    var res = '';
    var imgElem = widget.data.message.imageElem!;
    var imgList = imgElem.imageList ?? [];
    for (var i = 0; i < imgList.length; i++) {
      var img = imgList[i];
      if (img != null) {
        if (img.type == ImageType.thumb.index) {}
        if (img.url != null) {
          if (img.url!.isNotEmpty) {
            res = img.url!;
          }
        }
      }
    }
    return res;
  }

  _getImageUrl() async {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      // check if exits local url . if not get online url

      bool hasLocal = hasLocalImage();
      bool hasClientPath = await hasSelfClientPath();
      console("hasLocal: $hasLocal, hasClientPath: $hasClientPath");
      if (hasClientPath) {
        var imageInfo = ImageCurrentRenderInfo(path: widget.data.message.imageElem!.path!, type: ImageCurrentRenderType.path);
        safeSetState(() {
          currentRenderImageInfo = imageInfo;
        });

        console("message has self local path. render by path");
      } else if (hasLocal) {
        var localUrl = getRenderLocalUrlFormImageElem(widget.data.message.imageElem!, ImageType.thumb.index);
        var imageInfo = ImageCurrentRenderInfo(path: localUrl, type: ImageCurrentRenderType.local);
        safeSetState(() {
          currentRenderImageInfo = imageInfo;
        });

        console("message has localUrl. render by local.");
      } else if (widget.data.message.imageElem != null) {
        var thumbUrl = getOnlineThumbUrl();
        if (thumbUrl.isNotEmpty) {
          var imageInfo = ImageCurrentRenderInfo(path: thumbUrl, type: ImageCurrentRenderType.online);
          safeSetState(() {
            currentRenderImageInfo = imageInfo;
          });

          console("message render by online url.");
        }
      } else {
        safeSetState(() {
          isErrorMessage = true;
        });
      }
    } else {
      safeSetState(() {
        isErrorMessage = true;
      });
    }
  }

  Widget renderLocalImage(String path) {
    console("render local image. path: $path");
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(getSquareSize(16)),
        topRight: Radius.circular(getSquareSize(16)),
        bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
        bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
      ),
      child: Image.file(
        fit: BoxFit.cover,
        width: min(widget.data.messageRowWidth * 0.7, 198),
        File(path),
        errorBuilder: (context, error, stackTrace) {
          console("local image render failed. please check the path is right. path: $path");
          return getErrorWidget();
        },
      ),
    );
  }

  getLoadingWidget() {
    double placeholderWidth = min(widget.data.messageRowWidth * 0.7, 198).toDouble();
    double placeholderHeight = placeholderWidth * 1.33;
    return Container(
      width: getWidth(placeholderWidth),
      height: getHeight(placeholderHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(getSquareSize(16)),
          topRight: Radius.circular(getSquareSize(16)),
          bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
          bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
        ),
        color: Colors.transparent,
      ),
      child: Center(
        child: SizedBox(
          width: getWidth(20),
          height: getHeight(20),
          child: const CircularProgressIndicator(
            strokeWidth: 1,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  getErrorWidget() {
    console("render image error");
    double placeholderWidth = min(widget.data.messageRowWidth * 0.7, 198).toDouble();
    double placeholderHeight = placeholderWidth * 1.33;
    return InkWell(
      onTap: () {
        if (onlineRenderResult != null && onlineRenderResult == false) {
          onlineRenderResult = true;
          onlineRenderKey++;
          _getImageUrl();
        }
      },
      child: Container(
        width: getWidth(placeholderWidth),
        height: getHeight(placeholderHeight),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getSquareSize(16)),
            topRight: Radius.circular(getSquareSize(16)),
            bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
            bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
          ),
          color: Colors.grey.withOpacity(0.2),
        ),
        child: Center(
          child: SizedBox(
            width: getWidth(20),
            height: getHeight(20),
            child: const Icon(
              Icons.error,
              color: Color(0xFFD32F2F),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderOnlineImage(String url) {
    console("render online image. url: $url");
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(getSquareSize(16)),
        topRight: Radius.circular(getSquareSize(16)),
        bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
        bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
      ),
      child: CachedNetworkImage(
          key: ValueKey(onlineRenderKey),
          imageUrl: url,
          fit: BoxFit.cover,
          width: min(widget.data.messageRowWidth * 0.7, 198),
          errorWidget: (context, error, stackTrace) {
            console("network image render failed. please check the path is right. url: $url");
            onlineRenderResult = false;
            return getErrorWidget();
          },
          progressIndicatorBuilder: (context, child, loadingProgress) {
            return getLoadingWidget();
          },
        ),
    );
  }

  showImage() {
    String convkey = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
    int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return TencentCloudChatMessageViewer(
          convKey: convkey,
          message: widget.data.message,
          convType: conversationType,
          isSending: widget.data.message.status == 1,
        );
      },
    );
  }

  int onTapDownTime = 0;

  onTapDown(TapDownDetails details) {
    if (!widget.data.inSelectMode) {
      onTapDownTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  onTapUp(TapUpDetails details) {
    if (widget.data.inSelectMode) {
      return;
    }
    int onTapUpTime = DateTime.now().millisecondsSinceEpoch;
    if (onTapUpTime - onTapDownTime > 300 && onTapDownTime > 0) {
      console("tap to long break.");
      return;
    }
    if (widget.data.renderOnMenuPreview) {
      return;
    }
    onTapDownTime = 0;
    showImage();
  }

  Widget renderImage() {
    if (!TencentCloudChatPlatformAdapter().isWeb && (currentRenderImageInfo?.type == ImageCurrentRenderType.path || currentRenderImageInfo?.type == ImageCurrentRenderType.local)) {
      return GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        child: renderLocalImage(currentRenderImageInfo?.path ?? ""),
      );
    } else {
      return GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        child: renderOnlineImage(currentRenderImageInfo?.path ?? ""),
      );
    }
  }

  Widget imageLayout() {
    if (currentRenderImageInfo == null) {
      return getLoadingWidget();
    }
    if (isErrorMessage) {
      return getErrorWidget();
    } else {
      return renderImage();
    }
  }

  Widget messageInfo() {
    return Row(
      mainAxisAlignment: sentFromSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!sentFromSelf)
          SizedBox(
            width: getWidth(4),
          ),
        if (sentFromSelf) messageStatusIndicator(),
        messageTimeIndicator(
          textColor: Colors.white,
          shadow: [
            const Shadow(
              color: Colors.black,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        if (sentFromSelf)
          SizedBox(
            width: getWidth(8),
          ),
      ],
    );
  }

  DownloadMessageQueueData? currentDownloadData;

  handleDownloadEvent(TencentCloudChatMessageData data) {
    if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.downloadMessage) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      bool hasThumbLocal = hasLocalImage();
      bool hasOriginLocal = hasLocalImage(isOrigin: true);
      int type = ImageType.thumb.index;
      if (!hasOriginLocal && hasThumbLocal) {
        type = ImageType.origin.index;
      }

      int idx = data.currentDownloadMessage.indexWhere((ele) => ele.getUniqueueKey() == generateDownloadData(type: type, conversationType: conversationType, key: key).getUniqueueKey());

      if (idx > -1) {
        safeSetState(() {
          currentDownloadData = data.currentDownloadMessage[idx];
        });
      }
    } else if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.networkConnectSuccess) {
        if (onlineRenderResult != null && onlineRenderResult == false) {
          onlineRenderResult = true;
          onlineRenderKey++;
          _getImageUrl();
        }
    }
  }

  void addDownloadListener() {
    __messageDataSubscription = _messageDataStream?.listen(handleDownloadEvent);
  }

  bool isDownloading() {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      bool hasThumbLocal = hasLocalImage();
      bool hasOriginLocal = hasLocalImage(isOrigin: true);
      int type = ImageType.thumb.index;
      if (!hasOriginLocal && hasThumbLocal) {
        type = ImageType.origin.index;
        console("thumb has been download . download origin local");
      }
      return TencentCloudChatDownloadUtils.isDownloading(data: generateDownloadData(type: type, conversationType: conversationType, key: key));
    }
    return false;
  }

  bool isInDownloadQueue() {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      bool hasThumbLocal = hasLocalImage();
      bool hasOriginLocal = hasLocalImage(isOrigin: true);
      int type = ImageType.thumb.index;
      if (!hasOriginLocal && hasThumbLocal) {
        type = ImageType.origin.index;
        console("thumb has been download . download origin local");
      }
      return TencentCloudChatDownloadUtils.isInDownloadQueue(data: generateDownloadData(type: type, conversationType: conversationType, key: key));
    }
    return false;
  }

  removeFromDownloadQueue() {
    bool inQueue = isInDownloadQueue();
    if (inQueue == true && TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      bool hasThumbLocal = hasLocalImage();
      bool hasOriginLocal = hasLocalImage(isOrigin: true);
      int type = ImageType.thumb.index;
      if (!hasOriginLocal && hasThumbLocal) {
        type = ImageType.origin.index;
        console("thumb has been download . download origin local");
      }
      TencentCloudChatDownloadUtils.removeFromDownloadQueue(data: generateDownloadData(type: type, conversationType: conversationType, key: key));
      safeSetState(() {
        renderRandom = Random().nextInt(10000);
      });
    }
  }

  Widget getDownloadingWidget({
    required double progress,
    bool? inQueue,
  }) {
    if (progress == 0) {
      return SizedBox(
        width: getSquareSize(22),
        height: getSquareSize(22),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
    return GestureDetector(
      onTap: removeFromDownloadQueue,
      child: SizedBox(
        width: getSquareSize(22),
        height: getSquareSize(22),
        child: CircularProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget downloadStatus() {
    // TODO use theme color

    Widget needDownload = GestureDetector(
      onTap: () {
        addDownloadMessageToQueue(isOrigin: true);
        setState(() {
          renderRandom = Random().nextInt(100000);
        });
      },
      child: Icon(
        Icons.download_for_offline_outlined,
        color: Colors.white,
        size: getSquareSize(20),
      ),
    );

    late Widget finalRenderDownloadStatusWidget;

    if ((hasLocalImage() && hasLocalImage(isOrigin: true)) || isErrorMessage || isSendingMessage() || TencentCloudChatUtils.checkString(widget.data.message.id) != null) {
      return Container();
    } else {
      if (isDownloading()) {
        finalRenderDownloadStatusWidget = getDownloadingWidget(
          progress: currentDownloadData == null ? 0 : (currentDownloadData!.downloadFinish ? 1 : (currentDownloadData!.currentDownloadSize / (currentDownloadData!.totalSize == 0 ? 1 : currentDownloadData!.totalSize))),
        );
      } else if (isInDownloadQueue()) {
        finalRenderDownloadStatusWidget = getDownloadingWidget(progress: 0);
      } else {
        finalRenderDownloadStatusWidget = needDownload;
      }
    }
    return Container(
      width: getSquareSize(20),
      height: getSquareSize(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(getSquareSize(15)),
        ),
        color: Colors.black.withOpacity((hasLocalImage() || currentDownloadData?.downloadFinish == true) ? 0 : 0.2),
      ),
      child: finalRenderDownloadStatusWidget,
    );
  }

  bool canrender = false;

  @override
  void initState() {
    super.initState();
    console(widget.data.message.imageElem?.toJson().toString() ?? "no image info");
    _getImageUrl();
    if (!TencentCloudChatPlatformAdapter().isWeb) {
      addDownloadListener();
      addDownloadMessageToQueue(isOrigin: false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!TencentCloudChatPlatformAdapter().isWeb) {
      __messageDataSubscription?.cancel();
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final maxBubbleWidth = widget.data.messageRowWidth * 0.8;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(4), vertical: getHeight(4)),
        decoration: BoxDecoration(
          color: showHighlightStatus ? colorTheme.info : (sentFromSelf ? colorTheme.selfMessageBubbleColor : colorTheme.othersMessageBubbleColor),
          border: Border.all(
            color: sentFromSelf ? colorTheme.selfMessageBubbleBorderColor : colorTheme.othersMessageBubbleBorderColor,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getSquareSize(16)),
            topRight: Radius.circular(getSquareSize(16)),
            bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
            bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                  Stack(
                    children: [
                      Positioned(
                        child: imageLayout(),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: messageInfo(),
                      ),
                      if (!TencentCloudChatPlatformAdapter().isWeb)
                        Positioned(
                          top: getHeight(4),
                          left: getWidth(4),
                          child: downloadStatus(),
                        )
                    ],
                  ),
              ],
            ),
            messageReactionList(),
          ],
        ),
      );
    });
  }
}
