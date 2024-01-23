import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_robot/tencent_cloud_chat_robot_card_message.dart';
import 'package:tencent_cloud_chat_robot/tencent_cloud_chat_robot_model.dart';
import 'package:tencent_cloud_chat_robot/tencent_cloud_chat_robot_stream_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

class TencentCloudChatRobotMessage extends StatefulWidget {
  final V2TimMessage message;
  const TencentCloudChatRobotMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatRobotMessageState();
}

class TencentCloudChatRobotMessageState
    extends State<TencentCloudChatRobotMessage> {
  late TencentCloudChatRobotData robotData;
  List<String> getChunksFromMessage() {
    return robotData.chunks;
  }

  TencentCloudChatRobotSrcEnum getSrcFromMessage() {
    return robotData.src;
  }

  initRobotData() {
    var mapData = json.decode(widget.message.customElem!.data!);
    mapData["robotID"] = widget.message.sender ?? "";
    mapData["msgID"] = widget.message.msgID ?? "";

    robotData = TencentCloudChatRobotData.fromJson(mapData);
  }

  @override
  void initState() {
    super.initState();
    initRobotData();
    // only handle src is 2 or src is 15
  }

  @override
  Widget build(BuildContext context) {
    if (robotData.src == TencentCloudChatRobotSrcEnum.robotCardMessage) {
      return TencentCloudChatRobotCardMessage(
        robotData: robotData,
      );
    }
    if (robotData.src == TencentCloudChatRobotSrcEnum.robotChunkMessage) {
      return TencentCloudChatRobotStreamMessage(
        robotData: robotData,
      );
    }
    return Container();
  }
}
