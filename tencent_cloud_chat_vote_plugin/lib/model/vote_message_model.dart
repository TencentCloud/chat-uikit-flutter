// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_message/vote_message.dart';
import 'package:tencent_cloud_chat_vote_plugin/struct/vote_custom_struct.dart';

class TencentCloudChatVoteMessageModel extends ChangeNotifier {
  TencentCloudChatVoteMessageModel({
    required message,
    OnOptionsItemTap? onTap,
  }) {
    addOrUpdateMssage(message, onTap);
  }

  addOrUpdateMssage(V2TimMessage message, OnOptionsItemTap? onTap) {
    if (message.msgID == null) {
      return;
    }
    String msgID = message.msgID!;
    if (onTap != null) {
      onTapFunc[msgID] = onTap;
    }
    messageMap[msgID] = TencentCloudChatVoteLogic(
      message: message,
    );
  }

  Map<String, TencentCloudChatVoteLogic> messageMap = Map<String, TencentCloudChatVoteLogic>.from({});

  Map<String, OnOptionsItemTap> onTapFunc = Map<String, OnOptionsItemTap>.from({});

  TencentCloudChatVoteLogic? getTencentCloudChatVoteLogic(String msgID) {
    return messageMap[msgID];
  }

  updateTencentCloudChatVoteLogic(TencentCloudChatVoteLogic data) {
    messageMap[data.msg.msgID!] = data;
    notifyListeners();
  }

  OnOptionsItemTap? getMessageOnTap(String msgID) {
    return onTapFunc[msgID];
  }
}
