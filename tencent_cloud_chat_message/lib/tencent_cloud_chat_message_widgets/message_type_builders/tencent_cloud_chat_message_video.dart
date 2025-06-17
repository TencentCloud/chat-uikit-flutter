import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_download_utils.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/cacheImage/tencent_cloud_chat_cache_image.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_viewer/tencent_cloud_chat_message_viewer.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

enum TimVideoCurrentRenderType {
  online,
  local,
  path,
}

class TimVideoCurrentRenderInfo {
  final TimVideoCurrentRenderType type;
  final double width;
  final double height;
  final String path;

  TimVideoCurrentRenderInfo({
    required this.height,
    required this.path,
    required this.width,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return Map.from({
      "width": width,
      "height": height,
      "path": path,
      "type": type.name,
    });
  }
}

class TencentCloudChatMessageVideo extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageVideo({
    super.key,
    required super.data,
    required super.methods,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageVideoState();
}

class _TencentCloudChatMessageVideoState extends TencentCloudChatMessageState<TencentCloudChatMessageVideo> {
  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData<dynamic>>("TencentCloudChatMessageData");
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? __messageDataSubscription;

  final String _tag = "TencentCloudChatMessageVideo";

  bool isErrorMessage = false;

  late double localDefaultWidth;

  late double localDefaultHeight;

  TimVideoCurrentRenderInfo? currentRenderVideoInfo;

  void console(String log) {
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

  int renderRandom = Random().nextInt(100000);

  Map<String, dynamic>? setLocalDelayData;

  @override
  void didUpdateWidget(covariant TencentCloudChatMessageVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.sendingMessageData != null) {
      if (setLocalDelayData != null && widget.data.sendingMessageData!.isSendComplete) {
        Future.delayed(const Duration(seconds: 1), () {
          setLocalCustomData(
            messageid: widget.data.sendingMessageData!.sdkID,
            key: setLocalDelayData!['key']!,
            value: setLocalDelayData!['value']!,
            currentValue: setLocalDelayData!['currentValue']!,
            setType: setLocalDelayData!['setType']!,
          );
          setLocalDelayData = null;
        });
      }
    }
  }

  (double, double) getDefaultWidthAndHeight() {
    console(widget.data.message.toJson().toString());
    double h = 266;
    double w = 200;
    bool isRotate = false;
    if (TencentCloudChatUtils.checkString(widget.data.message.localCustomData) != null) {
      String local = widget.data.message.localCustomData!;
      try {
        console("local url $local");
        Map<String, dynamic> localObj = json.decode(local);
        var renderInfo = localObj["renderInfo"]; // renderInfo
        if (TencentCloudChatUtils.checkString(renderInfo) != null) {
          var renderInfoObj = json.decode(renderInfo);
          isRotate = (renderInfoObj['rotate'] == "1");
          w = renderInfoObj['w'] ?? 200;
          h = renderInfoObj['h'] ?? 266;
          console("use local wh. $w $h $renderInfo $isRotate");
          (w, h) = formatwh(w, h, 'getDefaultWidthAndHeight');
          return (w, h);
        }
      } catch (err) {
        // err
        console("get wh from localCustomData error ${err.toString()}");
      }
    }
    if (widget.data.message.videoElem != null) {
      String cloudCustomdata = widget.data.message.cloudCustomData ?? "";
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
      if (widget.data.message.videoElem!.snapshotHeight != null) {
        if (widget.data.message.videoElem!.snapshotHeight! > 0) {
          h = widget.data.message.videoElem!.snapshotHeight!.toDouble();
        }
      }
      if (widget.data.message.videoElem!.snapshotWidth != null) {
        if (widget.data.message.videoElem!.snapshotWidth! > 0) {
          w = widget.data.message.videoElem!.snapshotWidth!.toDouble();
        }
      }
      if (needRotate) {
        (w, h) = (h, w);
      }
    }

    (w, h) = formatwh(w, h, 'getDefaultWidthAndHeight');
    console("use element wh. $w $h");
    return (w, h);
  }

  DownloadMessageQueueData generateDownloadData({
    required int type,
    required int conversationType,
    required String key,
    V2TimMessage? message,
    required bool isSnapshot,
  }) {
    message ??= widget.data.message;
    return DownloadMessageQueueData(
      conversationType: conversationType,
      msgID: message.msgID ?? "",
      messageType: MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
      imageType: type,
      // download origin image
      isSnapshot: isSnapshot,
      key: key,
      convID: key,
    );
  }

  addDownloadMessageToQueue() {
    if (kIsWeb) {
      return;
    }

    bool hasLocal = hasLocalVideo();

    if (isSendingMessage()) {
      console("message is sending. download break .");
      return;
    }
    bool hasThumbLocal = hasLocalSnapShot();
    if (hasThumbLocal && hasLocal) {
      console("message has both thumb and play url. download break .");
      return;
    }
    String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
    int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
    if (key.isEmpty) {
      console("add to download queue error. key is empty.");
      return;
    }
    bool isSnapshot = false;
    if (!hasThumbLocal) {
      isSnapshot = true;
    }

    if (!hasLocalSnapShot()) {
      // no snapshot download
      TencentCloudChatDownloadUtils.addDownloadMessageToQueue(
        data: generateDownloadData(
          type: 0,
          conversationType: conversationType,
          key: key,
          isSnapshot: isSnapshot,
        ),
      );
    }
  }

  bool isSendingMessage() {
    if (widget.data.message.status == 1) {
      return true;
    }
    return false;
  }

  bool hasSelfClientPath() {
    bool hasSPath = false;
    if (widget.data.message.videoElem != null) {
      if (TencentCloudChatUtils.checkString(widget.data.message.videoElem!.snapshotPath) != null) {
        if (!kIsWeb) {
          if (File(widget.data.message.videoElem!.snapshotPath!).existsSync()) {
            hasSPath = true;
          }
        }
      }
    }
    return hasSPath;
  }

  bool hasLocalVideo() {
    bool resVideo = false;
    if (widget.data.message.videoElem != null) {
      V2TimVideoElem videoElement = widget.data.message.videoElem!;
      String localVideoUrl = "";
      if (TencentCloudChatUtils.checkString(videoElement.localVideoUrl) != null) {
        localVideoUrl = videoElement.localVideoUrl!;
      }

      if (localVideoUrl.isNotEmpty) {
        resVideo = true;
      }
    }
    if (currentdownload?.path != null && currentdownload?.downloadFinish == true) {
      resVideo = true;
    }

    return resVideo;
  }

  hasLocalSnapShot() {
    if (kIsWeb) {
      return false;
    }
    if (widget.data.message.videoElem == null) {
      return false;
    }
    return TencentCloudChatUtils.checkString(widget.data.message.videoElem!.localSnapshotUrl) != null;
  }

  getLocalSnapUrl() {
    if (kIsWeb) {
      return false;
    }
    return widget.data.message.videoElem!.localSnapshotUrl!;
  }

  getLocalSnapPath() {
    if (kIsWeb) {
      return false;
    }
    return widget.data.message.videoElem!.snapshotPath!;
  }

  setLocalCustomData({
    required String messageid,
    required String key,
    required String value,
    required String currentValue,
    required String setType,
    bool? delay,
  }) {
    if (kIsWeb) {
      return;
    }
    String convkey = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
    int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;

    if (delay == true) {
      setLocalDelayData = {
        "msgID": widget.data.message.msgID,
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
      currentMemoreyMsgId: widget.data.message.msgID ?? "",
    );
  }

  getVideoUrl() async {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      // check if exits local url . if not get online url

      bool hasLocalSnap = hasLocalSnapShot();
      bool hasClientPath = hasSelfClientPath();
      if (hasLocalSnap) {
        String localSnapUrl = getLocalSnapUrl();
        console("render local url");
        safeSetState(() {
          currentRenderVideoInfo = TimVideoCurrentRenderInfo(height: localDefaultHeight, path: localSnapUrl, width: localDefaultWidth, type: TimVideoCurrentRenderType.local);
        });
        return;
      }

      if (hasClientPath) {
        String localSnapPath = getLocalSnapPath();
        String currentLocalCustomData = widget.data.message.localCustomData ?? "";
        final fileBytes = File(localSnapPath).readAsBytesSync();

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
            ImageExifInfo? imageExifInfo = await TencentCloudChatUtils.getImageExifInfoByBuffer(fileBuffer: fileBytes);
            if (imageExifInfo != null) {
              owidth = imageExifInfo.width;
              oheight = imageExifInfo.height;
              isRotate = imageExifInfo.isRotate;
            }
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
              messageid: widget.data.message.msgID ?? "",
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
          currentRenderVideoInfo = TimVideoCurrentRenderInfo(height: oheight, path: getLocalSnapPath(), width: owidth, type: TimVideoCurrentRenderType.path);
        });
        return;
      }
      if (widget.data.message.videoElem != null) {
        if (widget.data.message.videoElem!.snapshotUrl != null) {
          double ohei = widget.data.message.videoElem!.snapshotHeight?.toDouble() ?? 0;
          double owid = widget.data.message.videoElem!.snapshotWidth?.toDouble() ?? 0;
          console("rendern online url by self souce. height $ohei width $owid");
          safeSetState(() {
            currentRenderVideoInfo = TimVideoCurrentRenderInfo(
              height: ohei,
              path: widget.data.message.videoElem!.snapshotUrl!,
              width: owid,
              type: TimVideoCurrentRenderType.online,
            );
          });
          return;
        }
      }
      if (!kIsWeb) {
        V2TimMessageOnlineUrl? data = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getMessageOnlineUrl(msgID: widget.data.message.msgID ?? "");
        if (data == null) {
          console("get online url null");
          safeSetState(() {
            isErrorMessage = true;
          });
        } else {
          if (data.videoElem != null) {
            if (TencentCloudChatUtils.checkString(data.videoElem!.snapshotUrl) != null) {
              bool isRotate = false;
              var thumbUrl = data.videoElem!.snapshotUrl!;

              double owidth = 200;
              double oheight = 266;

              String currentLocalCustomData = widget.data.message.localCustomData ?? "";
              if (thumbUrl.isNotEmpty) {
                var response = await http.get(Uri.parse(thumbUrl));
                if (response.statusCode == 200) {
                  var imageBytes = response.bodyBytes;

                  ImageExifInfo? imageExifInfo = await TencentCloudChatUtils.getImageExifInfoByBuffer(fileBuffer: imageBytes);

                  if (imageExifInfo != null) {
                    owidth = imageExifInfo.width;
                    oheight = imageExifInfo.height;
                    isRotate = imageExifInfo.isRotate;
                  }

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
                        messageid: widget.data.message.msgID ?? "",
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
                currentRenderVideoInfo = TimVideoCurrentRenderInfo(height: oheight, path: data.videoElem!.snapshotUrl!, width: owidth, type: TimVideoCurrentRenderType.online);
              });
            } else {
              console("get messame online url return. by no snapshotUrl please check.");
              safeSetState(() {
                isErrorMessage = true;
              });
            }
          } else {
            safeSetState(() {
              isErrorMessage = true;
            });
            console("get messame online url return. by no video elem  please check.");
          }
        }
      }
    } else {
      console("the video message has no message id. please check.");
      safeSetState(() {
        isErrorMessage = true;
      });
    }
  }

  videoNameWidget(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    var videoName = '';

    return Expanded(
      child: Container(
        height: getHeight(22),
        padding: EdgeInsets.symmetric(horizontal: getSquareSize(4)),
        child: Text(
          videoName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: textStyle.fontsize_14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget renderOnlineVideo(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle, String url) {
    console("render online video snapshot $url");
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Positioned(
          child: Container(
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
                Stack(
                  children:[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(getSquareSize(16)),
                        topRight: Radius.circular(getSquareSize(16)),
                        bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
                        bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
                      ),
                      child: TencentCloudChatCacheImage(
                        width: getWidth(localDefaultWidth),
                        height: getHeight(localDefaultHeight),
                        url: url,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
                          console("network video render failed. please check the path is right . path: $url");
                          return getErrorWidget(localDefaultWidth, localDefaultHeight);
                        },
                        progressIndicatorBuilder: (context, child, loadingProgress) {
                          console("progressIndicatorBuilder");
                          return getLoadingWidget(localDefaultWidth, localDefaultHeight);
                        },
                      ),
                    ),
                    Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Center(
                            child: downloadStatus(colorTheme, textStyle),
                          ),
                        ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: messageInfo(),
                    ),
                  ] 
                ),
                messageReactionList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget renderLocalVideo(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle, String p) {
    console("render local video snapshot $p");
    var fw = getWidth(localDefaultWidth);
    var fh = getHeight(localDefaultHeight);
    return SizedBox(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            child: Container(
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
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(getSquareSize(16)),
                  topRight: Radius.circular(getSquareSize(16)),
                  bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
                  bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.file(
                          fit: BoxFit.cover,
                          width: fw,
                          height: fh,
                          cacheWidth: fw.toInt(),
                          cacheHeight: fh.toInt(),
                          File(p),
                          errorBuilder: (context, error, stackTrace) {
                            console("local video render failed. please check the path is right . path: $p");
                            return getErrorWidget(localDefaultWidth, localDefaultHeight);
                          },
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Center(
                            child: downloadStatus(colorTheme, textStyle),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: messageInfo(),
                        ),
                      ],
                    ),
                    messageReactionList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  openVideo() {}

  Widget renderVideo(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    console("render video start");
    if (currentRenderVideoInfo?.type == TimVideoCurrentRenderType.path || currentRenderVideoInfo?.type == TimVideoCurrentRenderType.local) {
      return renderLocalVideo(colorTheme, textStyle, currentRenderVideoInfo!.path);
    } else {
      return renderOnlineVideo(colorTheme, textStyle, currentRenderVideoInfo!.path);
    }
  }

  (double, double) formatwh(double originw, double originh, String from) {
    return (200.toDouble(), ((200 * originh) / originw).floor().toDouble());
  }

  getLoadingWidget(double w, double h) {
    (w, h) = formatwh(w, h, 'getLoadingWidget');

    console("render image loading $w $h");
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
    (w, h) = formatwh(w, h, 'getErrorWidget');

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

  showVideo() {
    String convKey = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
    int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return TencentCloudChatMessageViewer(
            key: ValueKey(widget.data.message.msgID),
            convKey: convKey,
            message: widget.data.message,
            convType: conversationType,
            isSending: widget.data.message.status == 1,
          );
        },
      ),
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
    showVideo();
  }

  Widget videoLayout(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    if (currentRenderVideoInfo == null) {
      return getLoadingWidget(localDefaultWidth, localDefaultHeight);
    }
    if (isErrorMessage) {
      return getErrorWidget(localDefaultWidth, localDefaultHeight);
    } else {
      return GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        child: renderVideo(colorTheme, textStyle),
      );
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
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      bool hasThumbLocal = hasLocalSnapShot();
      bool isSnapshot = false;
      if (!hasThumbLocal) {
        isSnapshot = true;
      }
      int idx = data.currentDownloadMessage.indexWhere(
        (ele) =>
            ele.getUniqueueKey() ==
            generateDownloadData(
              type: 0,
              conversationType: conversationType,
              key: key,
              isSnapshot: isSnapshot,
            ).getUniqueueKey(),
      );

      if (idx > -1) {
        safeSetState(() {
          currentdownload = data.currentDownloadMessage[idx];
        });
      }
    }
  }

  void addDownloadListener() {
    __messageDataSubscription = _messageDataStream?.listen(downloadCallback);
  }

  bool isDownloading() {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      bool hasThumbLocal = hasLocalSnapShot();
      bool isSnapshot = false;
      if (!hasThumbLocal) {
        isSnapshot = true;
      }
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      return TencentCloudChatDownloadUtils.isDownloading(
          data: generateDownloadData(
        type: 0,
        conversationType: conversationType,
        key: key,
        isSnapshot: isSnapshot,
      ));
    }
    return false;
  }

  bool isInDownloadQueue() {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      bool hasThumbLocal = hasLocalSnapShot();
      bool isSnapshot = false;
      if (!hasThumbLocal) {
        isSnapshot = true;
      }
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      return TencentCloudChatDownloadUtils.isInDownloadQueue(
        data: generateDownloadData(
          type: 0,
          conversationType: conversationType,
          key: key,
          isSnapshot: isSnapshot,
        ),
      );
    }
    return false;
  }

  removeFromDownloadQueue() {
    bool inQueue = isInDownloadQueue();
    if (inQueue == true && TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      bool hasThumbLocal = hasLocalSnapShot();
      bool isSnapshot = false;
      if (!hasThumbLocal) {
        isSnapshot = true;
      }
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      TencentCloudChatDownloadUtils.removeFromDownloadQueue(
        data: generateDownloadData(
          type: 0,
          conversationType: conversationType,
          key: key,
          isSnapshot: isSnapshot,
        ),
      );
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
        width: getSquareSize(36),
        height: getSquareSize(36),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
    return GestureDetector(
      onTap: removeFromDownloadQueue,
      child: SizedBox(
        width: getSquareSize(36),
        height: getSquareSize(36),
        child: CircularProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          strokeWidth: 2,
        ),
      ),
    );
  }

  bool isCurrentVideoOpen() {
    return false;
  }

  Widget downloadStatus(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    return Container(
      width: getSquareSize(36),
      height: getSquareSize(36),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.all(
          Radius.circular(
            getSquareSize(18),
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.play_arrow_sharp,
          size: getSquareSize(20),
          color: Colors.white,
        ),
      ),
    );
  }

  String getCurrentVideoVideoSize() {
    int videoSizeInKB = 0;
    if (widget.data.message.videoElem != null) {
      videoSizeInKB = widget.data.message.videoElem!.videoSize ?? 0;
    }
    videoSizeInKB = (videoSizeInKB / 1024).floor();
    if (videoSizeInKB < 1024) {
      return '$videoSizeInKB KB';
    } else if (videoSizeInKB < 1024 * 1024) {
      double videoSizeInMB = videoSizeInKB / 1024;
      return '${videoSizeInMB.toStringAsFixed(2)} MB';
    } else {
      double videoSizeInGB = videoSizeInKB / (1024 * 1024);
      return '${videoSizeInGB.toStringAsFixed(2)} GB';
    }
  }

  @override
  void initState() {
    super.initState();

    var (w, h) = getDefaultWidthAndHeight();
    localDefaultHeight = h;
    localDefaultWidth = w;
    addDownloadListener();
    getVideoUrl();
    addDownloadMessageToQueue();
  }

  @override
  void dispose() {
    super.dispose();
    __messageDataSubscription?.cancel();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    console("render default builder");
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return videoLayout(colorTheme, textStyle);
    });
  }
}
