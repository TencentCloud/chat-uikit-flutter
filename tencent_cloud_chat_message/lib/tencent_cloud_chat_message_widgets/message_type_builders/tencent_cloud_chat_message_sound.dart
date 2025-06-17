import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_download_utils.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

enum TimSoundCurrentRenderType {
  online,
  local,
  path,
}

class TimSoundCurrentRenderInfo {
  final TimSoundCurrentRenderType type;
  final String path;
  final bool played;

  TimSoundCurrentRenderInfo({
    required this.path,
    required this.type,
    required this.played,
  });

  Map<String, dynamic> toJson() {
    return Map.from({
      "path": path,
      "type": type.name,
      "played": played,
    });
  }
}

class TencentCloudChatMessageSound extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageSound({
    super.key,
    required super.data,
    required super.methods,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageSoundState();
}

class _TencentCloudChatMessageSoundState extends TencentCloudChatMessageState<TencentCloudChatMessageSound> {
  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData<dynamic>>("TencentCloudChatMessageData");
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? __messageDataSubscription;

  final String _tag = "TencentCloudChatMessageSound";

  bool isErrorMessage = false;

  TimSoundCurrentRenderInfo? currentRenderSoundInfo;

  int renderRandom = Random().nextInt(100000);

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

  addDownloadMessageToQueue() {
    if (hasLocalSound()) {
      return;
    }
    if (isSendingMessage()) {
      return;
    }
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return;
      }
      TencentCloudChatDownloadUtils.addDownloadMessageToQueue(
        data: generateDownloadData(type: 0, conversationType: conversationType, key: key),
      );
    }
  }

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

  bool isSendingMessage() {
    if (widget.data.message.status == 1) {
      return true;
    }
    return false;
  }

  bool hasSelfClientPath() {
    if (widget.data.message.soundElem != null) {
      if (TencentCloudChatUtils.checkString(widget.data.message.soundElem!.path) != null) {
        return true;
      }
    }
    return false;
  }

  bool hasLocalSound() {
    bool res = false;
    if (widget.data.message.soundElem != null) {
      V2TimSoundElem sound = widget.data.message.soundElem!;
      String localUrl = "";

      if (TencentCloudChatUtils.checkString(sound.localUrl) != null) {
        localUrl = sound.localUrl!;
      }

      if (localUrl.isNotEmpty) {
        res = true;
      }
    }
    if (currentdownload?.path != null && currentdownload?.downloadFinish == true) {
      res = true;
    }
    return res;
  }

  String getLocalUrl() {
    if (TencentCloudChatUtils.checkString(widget.data.message.soundElem!.localUrl) != null) {
      return widget.data.message.soundElem!.localUrl!;
    }
    if (TencentCloudChatUtils.checkString(currentdownload?.path) != null) {
      return currentdownload?.path ?? "";
    }
    return "";
  }

  String getLocalPath() {
    return widget.data.message.soundElem!.path!;
  }

  bool isPlayed() {
    bool res = false;
    if (widget.data.message.localCustomData != null) {
      if (widget.data.message.localCustomData!.isNotEmpty) {
        String localData = widget.data.message.localCustomData!;
        Map<String, dynamic> localCustomDataObj;
        try {
          localCustomDataObj = Map<String, dynamic>.from(json.decode(localData));
        } catch (err) {
          localCustomDataObj = Map<String, dynamic>.from({});
        }

        if (localCustomDataObj["played"] != null) {
          res = true;
        }
      }
    }
    return res;
  }

  getSoundUrl() async {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      // check if exits local url . if not get online url
      bool hasLocal = hasLocalSound();
      bool isSending = isSendingMessage();
      bool hasClientPath = hasSelfClientPath();
      bool played = isPlayed();
      if (hasLocal) {
        safeSetState(() {
          currentRenderSoundInfo = TimSoundCurrentRenderInfo(
            path: getLocalUrl(),
            type: TimSoundCurrentRenderType.local,
            played: played,
          );
        });
        return;
      }

      if (isSending && hasClientPath) {
        safeSetState(() {
          currentRenderSoundInfo = TimSoundCurrentRenderInfo(
            path: getLocalPath(),
            type: TimSoundCurrentRenderType.path,
            played: played,
          );
        });
        return;
      }
      V2TimMessageOnlineUrl? data = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getMessageOnlineUrl(msgID: widget.data.message.msgID ?? "");
      if (data == null) {
        safeSetState(() {
          isErrorMessage = true;
        });
      } else {
        if (data.soundElem != null) {
          if (TencentCloudChatUtils.checkString(data.soundElem!.url) != null) {
            safeSetState(() {
              currentRenderSoundInfo = TimSoundCurrentRenderInfo(
                path: data.soundElem!.url!,
                type: TimSoundCurrentRenderType.online,
                played: played,
              );
            });
          } else {
            safeSetState(() {
              isErrorMessage = true;
            });
          }
        } else {
          safeSetState(() {
            isErrorMessage = true;
          });
          console("get message online url return. by no sound elem  please check.");
        }
      }
    } else {
      console("the sound message has no message id. please check.");
      safeSetState(() {
        isErrorMessage = true;
      });
    }
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
    playSound();
  }

  Widget renderSoundWidget(double maxBubbleWidth, int duration, TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle, bool isError, TimSoundCurrentRenderInfo? currentRenderInfo) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      child: Container(
        // width: generateSoundUILength(duration, maxBubbleWidth),
        height: getHeight(34),
        padding: EdgeInsets.symmetric(horizontal: getWidth(4), vertical: getHeight(4)),
        decoration: BoxDecoration(
          color: colorTheme.dividerColor,
          borderRadius: BorderRadius.all(Radius.circular(getSquareSize(16))),
        ),
        child: Row(
          children: [
            downloadStatus(colorTheme, textStyle),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(4)),
                child: LinearProgressIndicator(
                  value: getProgress(),
                  backgroundColor: colorTheme.appBarBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(colorTheme.primaryColor),
                ),
              ),
            ),
            Text(
              "${duration}s",
              style: TextStyle(
                fontSize: textStyle.fontsize_14,
                fontWeight: FontWeight.w400,
                color: colorTheme.appBarBackgroundColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  playSound() async {
    String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
    int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
    bool isPlaying = TencentCloudChat.instance.dataInstance.messageData.isPlaying(msgID: (widget.data.message.msgID ?? ""));
    bool isPause = TencentCloudChat.instance.dataInstance.messageData.isPause(msgID: (widget.data.message.msgID ?? ""));

    if (isPlaying) {
      return await TencentCloudChat.instance.dataInstance.messageData.pauseAudio();
    }

    if (isPause) {
      return await TencentCloudChat.instance.dataInstance.messageData.resumeAudio();
    }
    if (hasLocalSound()) {
      var localu = getLocalUrl();
      return await TencentCloudChat.instance.dataInstance.messageData.playAudio(
          source: AudioPlayInfo(
        type: AudioPlayType.path,
        path: localu,
        msgID: (widget.data.message.msgID ?? ""),
        totalSecond: widget.data.message.soundElem!.duration ?? 0,
        convKey: key,
        convType: conversationType,
      ));
    }
    if (hasSelfClientPath()) {
      var localp = getLocalPath();

      return await TencentCloudChat.instance.dataInstance.messageData.playAudio(
          source: AudioPlayInfo(
        type: AudioPlayType.path,
        path: localp,
        msgID: (widget.data.message.msgID ?? ""),
        totalSecond: widget.data.message.soundElem!.duration ?? 0,
        convKey: key,
        convType: conversationType,
      ));
    }

    if (currentRenderSoundInfo?.type == TimSoundCurrentRenderType.online) {
      return await TencentCloudChat.instance.dataInstance.messageData.playAudio(
          source: AudioPlayInfo(
        type: AudioPlayType.online,
        path: currentRenderSoundInfo?.path ?? "",
        msgID: (widget.data.message.msgID ?? ""),
        totalSecond: widget.data.message.soundElem!.duration ?? 0,
        convKey: key,
        convType: conversationType,
      ));
    }
    console("play error. ${currentRenderSoundInfo?.toJson()}");
  }

  DownloadMessageQueueData? currentdownload;
  CurrentPlayAudioInfo? currentPlayAudioInfo;

  messageDataChange(TencentCloudChatMessageData data) {
    if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.downloadMessage) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }

      int idx = data.currentDownloadMessage.indexWhere((ele) => ele.getUniqueueKey() == generateDownloadData(type: 0, conversationType: conversationType, key: key).getUniqueueKey());

      if (idx > -1) {
        safeSetState(() {
          currentdownload = data.currentDownloadMessage[idx];
        });
      }
    } else if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.currentPlayAudioInfo) {
      if (data.currentPlayAudioInfo != null) {
        if (data.currentPlayAudioInfo!.playInfo.msgID == (widget.data.message.msgID ?? "")) {
          console("current audio playing progress :${data.currentPlayAudioInfo!.progress}, isCompleted:${data.currentPlayAudioInfo!.isCompleted}, isPaused: ${data.currentPlayAudioInfo!.isPaused}");
          safeSetState(() {
            currentPlayAudioInfo = data.currentPlayAudioInfo;
          });
        }
      }
    }
  }

  void addMessageDataChangeListener() {
    __messageDataSubscription = _messageDataStream?.listen(messageDataChange);
  }

  bool isDownloading() {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      return TencentCloudChatDownloadUtils.isDownloading(data: generateDownloadData(type: 0, conversationType: conversationType, key: key));
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
      return TencentCloudChatDownloadUtils.isInDownloadQueue(data: generateDownloadData(type: 0, conversationType: conversationType, key: key));
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
      TencentCloudChatDownloadUtils.removeFromDownloadQueue(data: generateDownloadData(type: 0, conversationType: conversationType, key: key));
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

  bool isCurrentSoundPlaying() {
    if (currentPlayAudioInfo == null) {
      return false;
    }
    if (!currentPlayAudioInfo!.isCompleted) {
      if (currentPlayAudioInfo!.isPaused) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  Widget downloadStatus(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    return isCurrentSoundPlaying()
        ? GestureDetector(
            child: Icon(
              Icons.pause_circle_outlined,
              weight: getSquareSize(20),
              color: colorTheme.appBarBackgroundColor,
            ),
          )
        : GestureDetector(
            child: Icon(
              Icons.play_circle_outline,
              weight: getSquareSize(20),
              color: colorTheme.appBarBackgroundColor,
            ),
          );
  }

  double getProgress() {
    double res = 0;
    if (currentPlayAudioInfo == null) {
      return res;
    }
    return currentPlayAudioInfo!.progress;
  }

  int getCurrentSoundDuration() {
    int res = 0;
    if (widget.data.message.soundElem != null) {
      if (widget.data.message.soundElem!.duration != null) {
        res = widget.data.message.soundElem!.duration!;
      }
    }
    return res;
  }

  double generateSoundUILength(int duration, double maxBubbleWidth) {
    int maxDuration = 26;

    double item = (maxBubbleWidth / maxDuration).floorToDouble();

    double width = item * (duration > maxDuration ? maxDuration : duration);

    if (width < 100) {
      width = 100;
    }
    width = width.floorToDouble();

    return getWidth(width);
  }

  @override
  void initState() {
    super.initState();
    addMessageDataChangeListener();
    getSoundUrl();
    addDownloadMessageToQueue();
  }

  @override
  void dispose() {
    super.dispose();
    __messageDataSubscription?.cancel();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final maxBubbleWidth = widget.data.messageRowWidth * 0.8;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      int duration = getCurrentSoundDuration();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(8)),
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
                Expanded(
                  child: renderSoundWidget(maxBubbleWidth, duration, colorTheme, textStyle, isErrorMessage, currentRenderSoundInfo),
                )
              ],
            ),
            SizedBox(
              height: getHeight(4),
            ),
            Row(
              mainAxisAlignment: sentFromSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (sentFromSelf) messageStatusIndicator(),
                messageTimeIndicator(),
              ],
            ),
            messageReactionList(),
          ],
        ),
      );
    });
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    final maxBubbleWidth = widget.data.messageRowWidth * 0.4;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      int duration = getCurrentSoundDuration();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(8)),
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
                Expanded(
                  child: renderSoundWidget(maxBubbleWidth, duration, colorTheme, textStyle, isErrorMessage, currentRenderSoundInfo),
                )
              ],
            ),
            SizedBox(
              height: getHeight(4),
            ),
            Row(
              mainAxisAlignment: sentFromSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (sentFromSelf) messageStatusIndicator(),
                messageTimeIndicator(),
              ],
            ),
            messageReactionList(),
          ],
        ),
      );
    });
  }
}
