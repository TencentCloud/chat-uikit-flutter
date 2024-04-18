import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/cacheImage/tencent_cloud_chat_cache_image.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_viewer/tencent_cloud_chat_message_viewer.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';
// static final int 	V2TIM_IMAGE_TYPE_ORIGIN = 0

// static final int 	V2TIM_IMAGE_TYPE_THUMB = 1

// static final int 	V2TIM_IMAGE_TYPE_LARGE = 2

enum TimImageType {
  origin,
  thumb,
  large,
}

enum TimImageCurrentRenderType {
  online,
  local,
  path,
}

class TimImageCurrentRenderInfo {
  final TimImageCurrentRenderType type;
  final double width;
  final double height;
  final String path;

  TimImageCurrentRenderInfo({
    required this.height,
    required this.path,
    required this.type,
    required this.width,
  });

  Map<String, dynamic> toJson() {
    return Map.from({
      "type": type.name,
      "width": width,
      "height": height,
      "path": path,
    });
  }
}

class TencentCloudChatMessageImage extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageImage({
    super.key,
    super.userID,
    super.groupID,
    required super.message,
    required super.showMessageStatusIndicator,
    required super.showMessageTimeIndicator,
    required super.shouldBeHighlighted,
    required super.clearHighlightFunc,
    super.messageReceipt,
    required super.messageRowWidth,
    super.sendingMessageData,
    required super.renderOnMenuPreview,
    required super.inSelectMode,
    required super.onSelectMessage,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageImageState();
}

class _TencentCloudChatMessageImageState extends TencentCloudChatMessageState<TencentCloudChatMessageImage> {
  @override
  void didUpdateWidget(covariant TencentCloudChatMessageImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sendingMessageData != null) {
      if (setLocalDelayData != null && widget.sendingMessageData!.isSendComplete) {
        Future.delayed(const Duration(seconds: 1), () {
          setLocalCustomData(
            messageid: widget.sendingMessageData!.sdkID,
            key: setLocalDelayData!['key'] ?? "",
            value: setLocalDelayData!['value'] ?? "",
            currentValue: setLocalDelayData!['currentValue'] ?? "",
            setType: setLocalDelayData!['setType'] ?? "",
          );
          setLocalDelayData = null;
        });
      }
    }
  }

  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData<dynamic>>();
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? __messageDataSubscription;
  final String _tag = "TencentCloudChatMessageImage";

  bool isErrorMessage = false;

  int renderRandom = Random().nextInt(100000);

  TimImageCurrentRenderInfo? currentRenderImageInfo;

  late double localDefaultWidth;

  late double localDefaultHeight;

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: json.encode(
        {
          "msgID": msgID,
          "log": log,
        },
      ),
    );
  }

  Map<String, dynamic>? setLocalDelayData;

  setLocalCustomData({
    required String messageid,
    required String key,
    required String value,
    required String currentValue,
    required String setType,
    bool? delay,
  }) {
    String convkey = TencentCloudChatUtils.checkString(widget.message.userID) ?? widget.message.groupID ?? "";
    int conversationType = TencentCloudChatUtils.checkString(widget.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
    if (delay == true) {
      setLocalDelayData = {
        "msgID": messageid,
        "key": key,
        "value": value,
        "currentValue": currentValue,
        "setType": setType,
      };
      console("render local path. generate wh success. bug message not sended. delay to setCloudCustonData");
      return;
    }

    TencentCloudChat.instance.chatSDKInstance.messageSDK.setLocalCustomData(
      msgID: messageid,
      key: key,
      value: value,
      currentValue: currentValue,
      convKey: convkey,
      convType: conversationType,
      setType: setType,
      currentMemoreyMsgId: msgID,
    );
  }

  addDownloadMessageToQueue({
    bool? isClick,
    bool? isSnap,
  }) {
    if (isSendingMessage()) {
      console("message is sending. download break .");
      return;
    }
    bool hasThumbLocal = hasLocalImage();
    bool hasOriginLocal = hasLocalImage(isOrigin: true);

    if (hasThumbLocal && hasOriginLocal) {
      console("message has both local url. download break .");
      return;
    }

    if (TencentCloudChatUtils.checkString(msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.message.userID) ?? widget.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty. ");
        return;
      }
      int type = TimImageType.thumb.index;
      if (!hasOriginLocal && hasThumbLocal) {
        type = TimImageType.origin.index;
        console("thumb has been download . download origin local");
      }
      TencentCloudChat.instance.dataInstance.messageData.addDownloadMessageToQueue(
            data: DownloadMessageQueueData(
              conversationType: conversationType,
              msgID: widget.message.msgID ?? msgID,
              messageType: MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
              imageType: type,
              // download origin image
              isSnapshot: false,
              key: key,
            ),
            isClick: isClick,
          );
    }
  }

  bool isSendingMessage() {
    if (widget.message.status == 1) {
      return true;
    }
    return false;
  }

  Future<bool> hasSelfClientPath() async {
    if (widget.message.imageElem != null) {
      if (TencentCloudChatUtils.checkString(widget.message.imageElem!.path) != null) {
        if (File(widget.message.imageElem!.path!).existsSync()) {
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
    if (widget.message.imageElem != null) {
      V2TimImageElem images = widget.message.imageElem!;
      String localUrl = "";
      List<V2TimImage?> imageLists = images.imageList ?? [];
      if (imageLists.isNotEmpty) {
        for (var i = 0; i < imageLists.length; i++) {
          V2TimImage? image = imageLists[i];
          if (image != null) {
            int type = isOrigin == true ? TimImageType.origin.index : TimImageType.thumb.index;
            if (image.type == type) {
              if (TencentCloudChatUtils.checkString(image.localUrl) != null) {
                localUrl = image.localUrl!;
              }
              break;
            }
          }
        }
      }
      if (localUrl.isNotEmpty) {
        res = true;
      }
    }
    if (currentdownload?.path != null && currentdownload?.downloadFinish == true) {
      console("no local url. but has downloaded path in memery.");
      res = true;
    }
    return res;
  }

  getRenderLocalUrlFormImageElem(V2TimImageElem image, int type) {
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
    var imgElem = widget.message.imageElem!;
    var imgList = imgElem.imageList ?? [];
    for (var i = 0; i < imgList.length; i++) {
      var img = imgList[i];
      if (img != null) {
        if (img.type == TimImageType.thumb.index) {}
        if (img.url != null) {
          if (img.url!.isNotEmpty) {
            res = img.url!;
          }
        }
      }
    }
    return res;
  }

  getImageUrl() async {
    if (TencentCloudChatUtils.checkString(msgID) != null) {
      // check if exits local url . if not get online url
      bool hasLocal = hasLocalImage();
      bool hasClientPath = await hasSelfClientPath();
      if (hasClientPath) {
        String localPath = widget.message.imageElem!.path!;
        String currentLocalCustomData = widget.message.localCustomData ?? "";
        final fileBytes = File(localPath).readAsBytesSync();

        double owidth = 200;
        double oheight = 266;
        bool isRotate = false;
        String from = "";
        late Map<String, dynamic> obj;
        try {
          try {
            obj = json.decode(currentLocalCustomData);
          } catch (err) {
            // err
            obj = Map.from({});
          }
          var renderInfo = obj["renderInfo"];

          if (renderInfo == null) {
            ImageExifInfo imageExifInfo = await TencentCloudChatUtils.getImageExifInfoByBuffer(fileBuffer: fileBytes);

            owidth = imageExifInfo.width;
            oheight = imageExifInfo.height;
            isRotate = imageExifInfo.isRotate;
          } else {
            try {
              var renderInfoObj = Map<String, dynamic>.from(json.decode(renderInfo));
              owidth = renderInfoObj['w'] as double;
              oheight = renderInfoObj['h'] as double;
              isRotate = renderInfoObj['rotate'] == '1' ? true : false;
              from = renderInfoObj["from"] ?? "";
            } catch (err) {
              console("set info to local custom data error . client path render . ${err.toString()}");
            }
          }

          if (from == "send") {
            setLocalCustomData(
              messageid: msgID,
              key: 'renderInfo',
              value: json.encode({
                'h': oheight,
                'w': owidth,
                'rotate': isRotate ? "1" : "0",
              }),
              currentValue: currentLocalCustomData,
              setType: "path",
              delay: true,
            );
          }
        } catch (err) {
          // err
        }

        safeSetState(() {
          currentRenderImageInfo = TimImageCurrentRenderInfo(height: oheight, path: widget.message.imageElem!.path!, type: TimImageCurrentRenderType.path, width: owidth);
        });

        console("message has self local path. render by path");

        return;
      }
      if (hasLocal) {
        String currentLocalCustomData = widget.message.localCustomData ?? "";
        String localUrl = getRenderLocalUrlFormImageElem(widget.message.imageElem!, TimImageType.thumb.index);
        bool needGetExif = false;
        double owidth = 200;
        double oheight = 266;
        bool isRotate = false;
        if (currentLocalCustomData.isEmpty) {
          needGetExif = true;
        } else {
          try {
            late Map<String, dynamic> obj;
            try {
              obj = json.decode(currentLocalCustomData);
            } catch (err) {
              // err
              obj = Map.from({});
            }
            var renderInfo = obj["renderInfo"]; // renderInfo
            if (renderInfo == "" || renderInfo == null) {
              needGetExif = true;
            } else {
              var renderInfoObj = Map<String, dynamic>.from(json.decode(renderInfo));
              isRotate = (renderInfoObj['rotate'] == "1");
              owidth = renderInfoObj['w'] as double;
              oheight = renderInfoObj["h"] as double;
            }
          } catch (err) {
            needGetExif = true;
          }
        }
        if (needGetExif) {
          final fileBytes = File(localUrl).readAsBytesSync();
          ImageExifInfo imageExifInfo = await TencentCloudChatUtils.getImageExifInfoByBuffer(fileBuffer: fileBytes);

          owidth = imageExifInfo.width;
          oheight = imageExifInfo.height;
          isRotate = imageExifInfo.isRotate;

          setLocalCustomData(
            messageid: msgID,
            key: 'renderInfo',
            value: json.encode({
              'h': oheight,
              'w': owidth,
              'rotate': isRotate ? "1" : "0",
            }),
            currentValue: currentLocalCustomData,
            setType: "local",
          );
        }

        safeSetState(() {
          currentRenderImageInfo = TimImageCurrentRenderInfo(height: oheight, path: localUrl, type: TimImageCurrentRenderType.local, width: owidth);
        });

        console("message has localurl. render by local");
        return;
      }

      if (widget.message.imageElem != null) {
        bool isRotate = false;
        var thumbUrl = getOnlineThumbUrl();

        double owidth = 200;
        double oheight = 266;
        String currentLocalCustomData = widget.message.localCustomData ?? "";
        if (thumbUrl.isNotEmpty) {
          var response = await http.get(Uri.parse(thumbUrl));
          if (response.statusCode == 200) {
            var imageBytes = response.bodyBytes;
            ImageExifInfo imageExifInfo = await TencentCloudChatUtils.getImageExifInfoByBuffer(fileBuffer: imageBytes);
            owidth = imageExifInfo.width;
            oheight = imageExifInfo.height;
            isRotate = imageExifInfo.isRotate;

            try {
              late Map<String, dynamic> obj;
              try {
                obj = json.decode(currentLocalCustomData);
              } catch (err) {
                // err
                obj = Map.from({});
              }
              var renderInfo = obj["renderInfo"];
              if (renderInfo == "" || renderInfo == null) {
                setLocalCustomData(
                  messageid: msgID,
                  key: 'renderInfo',
                  value: json.encode({
                    'h': oheight,
                    'w': owidth,
                    'rotate': isRotate ? "1" : "0",
                  }),
                  currentValue: currentLocalCustomData,
                  setType: "online",
                );
              }
            } catch (err) {
              // err
            }
          } else {
            console("get online url bytes error ${response.statusCode}");
          }
        }
        safeSetState(() {
          currentRenderImageInfo = TimImageCurrentRenderInfo(height: oheight, path: getOnlineThumbUrl(), type: TimImageCurrentRenderType.online, width: owidth);
        });
      } else {
        safeSetState(() {
          isErrorMessage = true;
        });

        console("get messame online url return. by no image elem  please check.");
      }
    } else {
      console("the image message has no message id. please check.");
      safeSetState(() {
        isErrorMessage = true;
      });
    }
  }

  Widget renderLocalImage(String p, double w, double h) {
    var (fw, fh) = formatwh(w, h);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(getSquareSize(16)),
        topRight: Radius.circular(getSquareSize(16)),
        bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
        bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
      ),
      child: Image.file(
        fit: BoxFit.cover,
        width: fw,
        height: fh,
        cacheWidth: fw.toInt(),
        cacheHeight: fh.toInt(),
        File(p),
        errorBuilder: (context, error, stackTrace) {
          console("local image render failed. please check the path is right . path: $p");
          return getErrorWidget(fw, fh);
        },
      ),
    );
  }

  (double, double) formatwh(double originw, double originh) {
    if (originw <= 200) {
      return (originw, originh);
    }

    return (200.toDouble(), ((200 * originh) / originw).floor().toDouble());
  }

  getLoadingWidget(double w, double h) {
    (w, h) = formatwh(w, h);

    return Container(
      width: getWidth(w),
      height: getHeight(h),
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

  getErrorWidget(double w, double h) {
    (w, h) = formatwh(w, h);

    console("render image error $w $h");
    return Container(
      width: getWidth(w),
      height: getHeight(h),
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
    );
  }

  Widget renderOnlineImage(String url, double w, double h) {
    var (fw, fh) = formatwh(w, h);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(getSquareSize(16)),
        topRight: Radius.circular(getSquareSize(16)),
        bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
        bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
      ),
      child: TencentCloudChatCacheImage(
        fit: BoxFit.cover,
        width: getWidth(fw),
        height: getHeight(fh),
        memCacheWidth: fw.toInt(),
        memCacheHeight: fh.toInt(),
        url: url,
        errorWidget: (context, error, stackTrace) {
          console("network image render failed. please check the path is right . path: $url");
          return getErrorWidget(fw, fh);
        },
        progressIndicatorBuilder: (context, child, loadingProgress) {
          return getLoadingWidget(fw, fh);
        },
      ),
    );
  }

  showImage() {
    Navigator.push(
      context,
      ZoomPageRoute(builder: (BuildContext context) {
        String convkey = TencentCloudChatUtils.checkString(widget.message.userID) ?? widget.message.groupID ?? "";
        int conversationType = TencentCloudChatUtils.checkString(widget.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;

        return TencentCloudChatMessageViewer(
          convKey: convkey,
          message: widget.message,
          convType: conversationType,
          isSending: widget.message.status == 1,
        );
      }),
    );
  }

  int onTapDownTime = 0;

  onTapDown(TapDownDetails details) {
    if (widget.inSelectMode) {
      widget.onSelectMessage();
    } else {
      onTapDownTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  onTapUp(TapUpDetails details) {
    if (widget.inSelectMode) {
      widget.onSelectMessage();
      return;
    }
    int onTapUpTime = DateTime.now().millisecondsSinceEpoch;
    if (onTapUpTime - onTapDownTime > 300 && onTapDownTime > 0) {
      console("tap to long break.");
      return;
    }
    if (widget.renderOnMenuPreview) {
      return;
    }
    onTapDownTime = 0;
    showImage();
  }

  Widget renderImage() {
    if (currentRenderImageInfo?.type == TimImageCurrentRenderType.path || currentRenderImageInfo?.type == TimImageCurrentRenderType.local) {
      return GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        child: renderLocalImage(currentRenderImageInfo?.path ?? "", currentRenderImageInfo?.width ?? localDefaultWidth, currentRenderImageInfo?.height ?? localDefaultHeight),
      );
    } else {
      return GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        child: renderOnlineImage(currentRenderImageInfo?.path ?? "", currentRenderImageInfo?.width ?? localDefaultWidth, currentRenderImageInfo?.height ?? localDefaultHeight),
      );
    }
  }

  (double, double) getDefaultWidthAndHeight() {
    double h = 266;
    double w = 200;
    bool isRotate = false;
    if (TencentCloudChatUtils.checkString(widget.message.localCustomData) != null) {
      String local = widget.message.localCustomData!;
      try {
        Map<String, dynamic> localObj = json.decode(local);
        var renderInfo = localObj["renderInfo"]; // renderInfo
        if (TencentCloudChatUtils.checkString(renderInfo) != null) {
          var renderInfoObj = json.decode(renderInfo);
          isRotate = (renderInfoObj['rotate'] == "1");
          w = renderInfoObj['w'] ?? 200;
          h = renderInfoObj['h'] ?? 266;
          console("use local wh. $w $h $renderInfo $isRotate");
          return (w, h);
        }
      } catch (err) {
        // err
        console('get info errpr ${err.toString()}');
      }
    }
    if (widget.message.imageElem != null) {
      String cloudCustomdata = widget.message.cloudCustomData ?? "";
      bool needRotate = false;
      if (cloudCustomdata.isNotEmpty) {
        try {
          var obj = Map<String, dynamic>.from(json.decode(cloudCustomdata));
          var renderInfo = obj["renderInfo"]; // renderInfo
          if (TencentCloudChatUtils.checkString(renderInfo) != null) {
            var renderInfoObj = json.decode(renderInfo);
            needRotate = (renderInfoObj['rotate'] == "1");
            if (needRotate) {
              console("render message by element wh. need rotate.");
            }
          }
        } catch (err) {
          // err
        }
      }
      var imagelist = widget.message.imageElem!.imageList;
      if (imagelist != null) {
        for (var i = 0; i < imagelist.length; i++) {
          var image = imagelist[i];
          if (image != null) {
            if (image.type == TimImageType.thumb.index) {
              h = (image.height ?? 266).toDouble();
              w = (image.width ?? 200).toDouble();
              if (needRotate) {
                (w, h) = (h, w);
              }
            }
          }
        }
      }
    }
    console("use element wh. $w $h");
    return formatwh(w, h);
  }

  Widget imageLayout() {
    if (currentRenderImageInfo == null) {
      return getLoadingWidget(localDefaultWidth, localDefaultHeight);
    }
    if (isErrorMessage) {
      return getErrorWidget(localDefaultWidth, localDefaultHeight);
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

  DownloadMessageQueueData? currentdownload;

  downloadCallback(TencentCloudChatMessageData data) {
    if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.downloadMessage) {
      if (data.currentDownloadMessage?.msgID == (widget.message.msgID ?? msgID)) {
        console("downloading finished:${data.currentDownloadMessage?.downloadFinish}");
        safeSetState(() {
          currentdownload = data.currentDownloadMessage;
        });
      }
    }
  }

  void addDownloadListener() {
    __messageDataSubscription = _messageDataStream?.listen(downloadCallback);
  }

  bool isDownloading() {
    return TencentCloudChat.instance.dataInstance.messageData.isDownloading(msgID: (widget.message.msgID ?? msgID));
  }

  bool isInDownloadQueue() {
    return TencentCloudChat.instance.dataInstance.messageData.isInDownloadQueue(msgID: (widget.message.msgID ?? msgID));
  }

  removeFromDownloadQueue() {
    bool inQueue = isInDownloadQueue();
    if (inQueue == true) {
      TencentCloudChat.instance.dataInstance.messageData.removeFromDownloadQueue(msgID: (widget.message.msgID ?? msgID));
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
        addDownloadMessageToQueue(isClick: true);
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

    if (hasLocalImage() || currentdownload?.downloadFinish == true || isErrorMessage || isSendingMessage() || TencentCloudChatUtils.checkString(widget.message.id) != null) {
      return Container();
    } else {
      if (isDownloading()) {
        finalRenderDownloadStatusWidget = getDownloadingWidget(
          progress: currentdownload == null ? 0 : (currentdownload!.downloadFinish ? 1 : (currentdownload!.currentDownloadSize / (currentdownload!.totalSize == 0 ? 1 : currentdownload!.totalSize))),
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
        color: Colors.black.withOpacity((hasLocalImage() || currentdownload?.downloadFinish == true) ? 0 : 0.2),
      ),
      child: finalRenderDownloadStatusWidget,
    );
  }

  bool canrender = false;

  initImageRenderWH() {
    var (w, h) = getDefaultWidthAndHeight();
    localDefaultHeight = h;
    localDefaultWidth = w;
  }

  @override
  void initState() {
    super.initState();
    initImageRenderWH();
    addDownloadListener();
    getImageUrl();
    addDownloadMessageToQueue();
  }

  @override
  void dispose() {
    super.dispose();
    __messageDataSubscription?.cancel();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final maxBubbleWidth = widget.messageRowWidth * 0.8;
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: min(maxBubbleWidth * 0.9, maxBubbleWidth - getSquareSize(sentFromSelf ? 128 : 102))),
              child: Stack(
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
                  Positioned(
                    top: getHeight(4),
                    left: getWidth(4),
                    child: downloadStatus(),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
