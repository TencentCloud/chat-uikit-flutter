import 'dart:convert';

import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_message_sdk.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';

class TencentCloudChatMessageDataTools {
  static V2TimMessage setAdditionalInfoForMessage({
    required V2TimMessage messageInfo,
    String? id,
    V2TimMessage? repliedMessage,
    V2TimGroupInfo? groupInfo,
    String? groupID,
    required OfflinePushInfo offlinePushInfo,
  }) {
    final loginUserInfo = TencentCloudChat().dataInstance.basic.currentUser;
    if (loginUserInfo != null) {
      messageInfo.faceUrl = loginUserInfo.faceUrl;
      messageInfo.nickName = loginUserInfo.nickName;
      messageInfo.sender = loginUserInfo.userID;
    }
    messageInfo.timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
    messageInfo.isSelf = true;
    messageInfo.status = MessageStatus.V2TIM_MSG_STATUS_SENDING;
    messageInfo.id = id;
    messageInfo.msgID = id;

    messageInfo.offlinePushInfo = OfflinePushInfo(
      ext: offlinePushInfo.ext ?? (TencentCloudChatUtils.checkString(groupID) != null ? "{\"conversationID\": \"group_$groupID\"}" : "{\"conversationID\": \"c2c_${loginUserInfo?.userID ?? ""}\"}"),
      title: offlinePushInfo.title ?? (groupInfo != null ? (groupInfo.groupName ?? groupInfo.groupID) : (loginUserInfo?.nickName ?? loginUserInfo?.userID)),
      desc: offlinePushInfo.desc ?? (TencentCloudChatUtils.getMessageSummary(message: messageInfo)),
      disablePush: offlinePushInfo.disablePush,
      ignoreIOSBadge: offlinePushInfo.ignoreIOSBadge,
      iOSPushType: offlinePushInfo.iOSPushType,
      androidFCMChannelID: offlinePushInfo.androidFCMChannelID,
      iOSSound: offlinePushInfo.iOSSound,
      androidSound: offlinePushInfo.androidSound,
      androidHuaWeiCategory: offlinePushInfo.androidHuaWeiCategory,
      androidOPPOChannelID: offlinePushInfo.androidOPPOChannelID,
      androidVIVOCategory: offlinePushInfo.androidVIVOCategory,
      androidVIVOClassification: offlinePushInfo.androidVIVOClassification,
      androidXiaoMiChannelID: offlinePushInfo.androidXiaoMiChannelID,
    );

    if (repliedMessage != null) {
      final cloudCustomData = {
        "messageReply": {
          "messageID": repliedMessage.msgID,
          "messageTimestamp": repliedMessage.timestamp,
          "messageSeq": int.tryParse(repliedMessage.seq ?? ""),
          "messageAbstract": TencentCloudChatUtils.getMessageSummary(message: repliedMessage),
          "messageSender": TencentCloudChatUtils.checkString(repliedMessage.nickName) ?? repliedMessage.sender,
          "messageType": repliedMessage.elemType,
          "version": 1
        }
      };
      messageInfo.cloudCustomData = json.encode(cloudCustomData);
    }

    return messageInfo;
  }

  static Future<V2TimValueCallback<V2TimMessage>> sendMessage({
    required String id,
    bool isCurrentConversation = true,
    String? userID,
    String? groupID,
    V2TimMessage? messageInfo,
    OfflinePushInfo? offlinePushInfo,
    bool? onlineUserOnly = false,
    MessagePriorityEnum priority = MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
    bool? isExcludedFromUnreadCount,
    bool? needReadReceipt,
    String? cloudCustomData,
    String? localCustomData,
    bool? isEditStatusMessage = false,
  }) async {
    final sendMsgRes = await TencentCloudChatMessageSDK().sendMessage(
      priority: priority,
      localCustomData: localCustomData,
      isExcludedFromUnreadCount: isExcludedFromUnreadCount ?? false,
      id: id,
      userID: userID,
      groupID: groupID,
      needReadReceipt: needReadReceipt ?? false,
      offlinePushInfo: offlinePushInfo,
      onlineUserOnly: onlineUserOnly ?? false,
      cloudCustomData: cloudCustomData,
    );

    if (sendMsgRes.data != null && isCurrentConversation) {
      List<V2TimMessage> currentHistoryMsgList = TencentCloudChat().dataInstance.messageData.getMessageList(key: TencentCloudChatUtils.checkString(groupID) ?? userID ?? "");

      // Update the message in the currentHistoryMsgList with the same id.
      currentHistoryMsgList = currentHistoryMsgList.map((message) {
        if (message.id == id) {
          return sendMsgRes.data!;
        }
        return message;
      }).toList();

      TencentCloudChat().dataInstance.messageData.updateMessageList(
            messageList: currentHistoryMsgList,
            userID: userID,
            groupID: groupID,
            disableNotify: true,
          );

      TencentCloudChat().dataInstance.messageData.onSendMessageProgress(sendMsgRes.data!, 100, true);
    }
    return sendMsgRes;
  }

  static List<String> getAbstractList(List<V2TimMessage> selectedMessageList) {
    return selectedMessageList.map((e) {
      final sender = (e.nickName != null && e.nickName!.isNotEmpty) ? e.nickName : e.sender;
      return "$sender: ${TencentCloudChatUtils.getMessageSummary(message: e)}";
    }).toList();
  }
}
