import 'package:flutter/foundation.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction_user_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudChatMessageReactionData extends ChangeNotifier {
  final Map<String, String> messageReactionLabelToAsset = {};
  final List<String> messageReactionStickerList = [];

  Map<String, List<V2TimMessageReaction>> _messageReactionMap = {};

  Map<String, List<V2TimMessageReaction>> get messageReactionMap => _messageReactionMap;

  List<String> updatedMessageReactions = [];

  List<(String, String)> messageReactionUpdatingList = [];

  /// ==== Init data and the listener ====
  V2TimAdvancedMsgListener? advancedMsgListener;

  void init() {
    advancedMsgListener = V2TimAdvancedMsgListener(
      onRecvMessageReactionsChanged: onReceivedMessageReactionChanged,
    );
    TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(listener: advancedMsgListener!);
  }

  /// Callback for receiving message reaction was updated
  /// function(V2TimMessage)
  void onReceivedMessageReactionChanged(
    List<V2TIMMessageReactionChangeInfo> changeInfos, [
    bool isLocalChange = false,
  ]) {
    if (isLocalChange) {
      for (final message in changeInfos) {
        for (final reaction in message.reactionList) {
          messageReactionUpdatingList.add((message.messageID, reaction.reactionID));
        }
      }
    } else {
      messageReactionUpdatingList.clear();
    }

    for (final e in changeInfos) {
      final List<V2TimMessageReaction> currentReactionList = _messageReactionMap[e.messageID] ?? [];
      for (final reaction in e.reactionList) {
        final targetIndex = currentReactionList.indexWhere((e) => e.reactionID == reaction.reactionID);
        if (targetIndex > -1) {
          if (reaction.totalUserCount > 0) {
            currentReactionList[targetIndex] = reaction;
          } else {
            currentReactionList.removeAt(targetIndex);
          }
        } else if (reaction.totalUserCount > 0) {
          currentReactionList.add(reaction);
        }
      }

      _messageReactionMap[e.messageID] = currentReactionList;

      if ((_messageReactionMap[e.messageID] ?? []).isEmpty) {
        _messageReactionMap.remove(e.messageID);
      }
    }
    setMessageReactionMap(null, (changeInfos.map((e) => e.messageID)).toList());
  }

  setMessageReactionMap(Map<String, List<V2TimMessageReaction>>? value, List<String> msgIDs) {
    if (value != null) {
      _messageReactionMap = value;
    }
    updatedMessageReactions = msgIDs;
    notifyListeners();
  }

  Future<void> loadMessageReactions({
    List<String>? msgIDList,
    List<String>? webMessageInstanceList,
  }) async {
    final reactionsRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageReactions(
          msgIDList: msgIDList ?? [],
          webMessageInstanceList: webMessageInstanceList,
          maxUserCountPerReaction: 10,
        );

    final List<V2TimMessageReactionResult>? reactions = reactionsRes.data;

    reactions?.forEach((e) {
      if ((e.reactionList ?? []).isNotEmpty) {
        _messageReactionMap[e.messageID] = e.reactionList ?? [];
      } else {
        _messageReactionMap.remove(e.messageID);
      }
    });
    setMessageReactionMap(null, (reactions?.map((e) => e.messageID) ?? []).toList());
    return;
  }

  Future<List<V2TimUserInfo>?> loadAllUserListOfMessageReaction({
    required String msgID,
    required String reactionID,
  }) async {
    final V2TimValueCallback<V2TimMessageReactionUserResult> messageReactionUserResult =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().getAllUserListOfMessageReaction(
              msgID: msgID,
              reactionID: reactionID,
              nextSeq: 0,
              count: 100,
            );
    final userList = messageReactionUserResult.data?.userInfoList;
    if(userList != null && userList.isNotEmpty){
      final index = messageReactionMap[msgID]?.indexWhere((e) => e.reactionID == reactionID) ?? -1;
      if((index) > -1){
        messageReactionMap[msgID]?[index].partialUserList = userList;
      }
    }
    return userList;
  }
}
