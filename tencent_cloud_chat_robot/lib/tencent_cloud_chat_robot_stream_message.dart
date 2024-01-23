import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_robot/tencent_cloud_chat_robot_model.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudChatRobotStreamMessage extends StatefulWidget {
  final TencentCloudChatRobotData robotData;
  const TencentCloudChatRobotStreamMessage({
    super.key,
    required this.robotData,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatRobotStreamMessageState();
}

class TencentCloudChatRobotStreamMessageState extends State<TencentCloudChatRobotStreamMessage> {
  static late V2TimAdvancedMsgListener listener;

  String messageString = "";
  int currentRenderIndex = 1;
  bool initedListener = false;
  late Timer timer;
  bool isFinished = false;
  addMessageModifyListener() {
    if (isFinished) {
      return;
    }
    initedListener = true;
    TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(listener: listener);
  }

  removeMessageModifyListener() {
    if (initedListener) {
      TencentImSDKPlugin.v2TIMManager.getMessageManager().removeAdvancedMsgListener(listener: listener);
    }
  }

  handleMessageModified(V2TimMessage message) {
    if (message.msgID == widget.robotData.msgID) {
      var latestRobotData = TencentCloudChatRobotData.fromJson(json.decode(message.customElem?.data ?? "{}"));
      messageString = latestRobotData.chunks.join();
      isFinished = latestRobotData.isFinished > 0;
    }
  }

  timerCancel() {
    if (timer.isActive) {
      timer.cancel();
    }
  }

  startChangeIndex() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (time) {
      if (currentRenderIndex < messageString.length) {
        setState(() {
          if (mounted) {
            currentRenderIndex = currentRenderIndex + 1;
          }
        });
      } else {
        if (isFinished) {
          timerCancel();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    removeMessageModifyListener();
    timerCancel();
  }

  @override
  void initState() {
    super.initState();
    listener = V2TimAdvancedMsgListener(onRecvMessageModified: handleMessageModified);
    messageString = widget.robotData.chunks.join();
    isFinished = widget.robotData.isFinished > 0;
    if (isFinished) {
      currentRenderIndex = messageString.length;
    }
    addMessageModifyListener();
    startChangeIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Text(messageString.substring(0, currentRenderIndex));
  }
}
