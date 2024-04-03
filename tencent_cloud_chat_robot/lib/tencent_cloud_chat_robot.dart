library tencent_cloud_chat_robot;

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_robot/tencent_cloud_chat_robot_message.dart';
import 'package:tencent_cloud_chat_robot/tencent_cloud_chat_robot_model.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

/// A TencentCloudChatRobot.
class TencentCloudChatRobotPlugin extends TencentCloudChatPlugin {
  @override
  Future<Map<String, dynamic>> callMethod(
      {required String methodName, String? data}) async {
    if (methodName == 'isRobotMessage') {
      if (data == null) {
        print(
            "the isRobotMessage method for robot plugin must include data  param");
        return Map<String, dynamic>.from({});
      }
      late bool res;
      try {
        res = isRobotMessage(V2TimMessage.fromJson(json.decode(data)));
      } catch (err) {
        // err
        res = false;
      }
      return Map<String, dynamic>.from({
        "isRobotMessageResult": res,
      });
    } else if (methodName == "ignoreRenderMessage") {
      if (data == null) {
        print(
            "the ignoreRenderMessage method for robot plugin must include data param");
        return Map<String, dynamic>.from({});
      }
      late bool res;
      try {
        res = ignoreRenderMessage(V2TimMessage.fromJson(json.decode(data)));
      } catch (err) {
        // err
        res = false;
      }
      return Map<String, dynamic>.from({
        "ignoreRenderMessageResult": res,
      });
    } else if (methodName == "sendHelloMsgToRobot") {
      if (data == null) {
        print(
            "the sendHelloMsgToRobot method for robot plugin must include data and data.receiver  param");
        return Map<String, dynamic>.from({});
      }
      V2TimMessage? res;
      try {
        var dataMap = Map<String, dynamic>.from(json.decode(data));
        var receiver = dataMap["receiver"];
        var isTextMsg = dataMap["isTextMsg"];
        if (receiver == null) {
          print(
              "the sendHelloMsgToRobot method for robot plugin must include data and data.receiver  param");
          return Map<String, dynamic>.from({});
        }
        res = await sendHelloMsgToRobot(
            receiver: receiver as String, isTextMsg: isTextMsg ?? false);
      } catch (err) {
        debugPrint(err.toString());
      }
      return Map<String, dynamic>.from({
        "sendHelloMsgToRobotResult": json.encode(res?.toJson() ?? {}),
      });
    }
    return Map<String, dynamic>.from({});
  }

  @override
  TencentCloudChatPlugin getInstance() {
    return TencentCloudChatRobotPlugin();
  }

  @override
  Future<Map<String, dynamic>> init(String? data) async {
    print("the robot plugin init ignore");
    return Map<String, dynamic>.from({});
  }

  @override
  Future<Map<String, dynamic>> unInit(String? data) async {
    print("the robot plugin unInit ignore");
    return Map<String, dynamic>.from({});
  }

  bool isRobotMessage(V2TimMessage message) {
    bool res = false;
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
      if (message.customElem != null) {
        if (message.customElem!.data != null) {
          var data = message.customElem!.data!;
          try {
            var jsonData = json.decode(data);
            var isChatbotPlugin = jsonData["chatbotPlugin"] ?? "";
            if (isChatbotPlugin.toString() == "1") {
              res = true;
            }
          } catch (err) {
            //err
          }
        }
      }
    }
    return res;
  }

  Widget? renderRobotMessage(V2TimMessage message) {
    if (isRobotMessage(message) && !ignoreRenderMessage(message)) {
      return TencentCloudChatRobotMessage(message: message);
    }
    return null;
  }

  /// if the bobot message need ignore to render
  /// [message] message instance
  ///
  bool ignoreRenderMessage(V2TimMessage message) {
    bool res = false;
    if (isRobotMessage(message)) {
      Map<String, dynamic> data = json.decode(message.customElem!.data!);
      var robotData = TencentCloudChatRobotData.fromJson(data);
      if (robotData.src ==
              TencentCloudChatRobotSrcEnum.welcomeCardMsgSendToRobot ||
          robotData.src ==
              TencentCloudChatRobotSrcEnum.welcomeTextMsgSendToRobot) {
        res = true;
      }
    }
    return res;
  }

  /// send hello message to robot
  /// [isTextMsg] send only text message to robot. send a card message by default
  /// [receiver] the robot id
  ///
  Future<V2TimMessage?> sendHelloMsgToRobot({
    bool? isTextMsg,
    required String receiver,
  }) async {
    var data = TencentCloudChatRobotData.fromJson(Map<String, dynamic>.from({
      "chatbotPlugin": 1,
      "src": isTextMsg == true
          ? TencentCloudChatRobotSrcEnum.welcomeTextMsgSendToRobot.index
          : TencentCloudChatRobotSrcEnum.welcomeCardMsgSendToRobot.index,
    }));
    var createCustomMessage = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createCustomMessage(data: json.encode(data.toJson()));
    if (createCustomMessage.code == 0) {
      if (createCustomMessage.data != null) {
        if (createCustomMessage.data!.id != null) {
          var sendRes = await TencentImSDKPlugin.v2TIMManager
              .getMessageManager()
              .sendMessage(
                  id: createCustomMessage.data!.id!,
                  receiver: receiver,
                  groupID: "");
          if (sendRes.code == 0) {
            if (sendRes.data != null) {
              return sendRes.data!;
            }
          }
        }
      }
    }
    return null;
  }

  @override
  Future<Widget?> getWidget(
      {required String methodName,
      Map<String, String>? data,
      Map<String, TencentCloudChatPluginTapFn>? fns}) async {
    if (methodName == "robotMessageItem") {
      if (data == null) {
        print("the robot plugin must have a data param. break");
        return null;
      }
      var message = data["message"];
      if (message == null) {
        print("the robot plugin must have a data.message param. break");
        return null;
      }
      return renderRobotMessage(V2TimMessage.fromJson(json.decode(message)));
    }
    return null;
  }
}
