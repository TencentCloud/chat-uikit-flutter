import 'dart:convert';

import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';

class TencentCloudChatMessageDataTools {
  static V2TimMessage setAdditionalInfoForMessage({
    required V2TimMessage messageInfo,
    String? id,
    V2TimMessage? repliedMessage,
    V2TimGroupInfo? groupInfo,
    String? groupID,
    bool? needReadReceipt,
    OfflinePushInfo? offlinePushInfo,
  }) {
    final loginUserInfo = TencentCloudChat.instance.dataInstance.basic.currentUser;
    if (loginUserInfo != null) {
      messageInfo.faceUrl =
          TencentCloudChatUtils.checkString(messageInfo.faceUrl) != null ? messageInfo.faceUrl : loginUserInfo.faceUrl;
      messageInfo.nickName = TencentCloudChatUtils.checkString(messageInfo.nickName) != null
          ? messageInfo.nickName
          : loginUserInfo.nickName;
      messageInfo.sender =
          TencentCloudChatUtils.checkString(messageInfo.sender) != null ? messageInfo.sender : loginUserInfo.userID;
    }
    messageInfo.timestamp = messageInfo.timestamp ?? (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
    messageInfo.isSelf = messageInfo.isSelf ?? true;
    messageInfo.status = messageInfo.status ?? MessageStatus.V2TIM_MSG_STATUS_SENDING;
    messageInfo.id = messageInfo.id ?? id;
    messageInfo.needReadReceipt = needReadReceipt;
    messageInfo.msgID = TencentCloudChatUtils.checkString(messageInfo.msgID) != null ? messageInfo.msgID : id;

    messageInfo.offlinePushInfo = OfflinePushInfo(
      ext: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.ext) ??
          TencentCloudChatUtils.checkString(offlinePushInfo?.ext) ??
          (TencentCloudChatUtils.checkString(groupID) != null
              ? "{\"conversationID\": \"group_$groupID\"}"
              : "{\"conversationID\": \"c2c_${loginUserInfo?.userID ?? ""}\"}"),
      title: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.title) ??
          TencentCloudChatUtils.checkString(offlinePushInfo?.title) ??
          (groupInfo != null
              ? (groupInfo.groupName ?? groupInfo.groupID)
              : (loginUserInfo?.nickName ?? loginUserInfo?.userID)),
      desc: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.desc) ??
          TencentCloudChatUtils.checkString(offlinePushInfo?.desc) ??
          (TencentCloudChatUtils.getMessageSummary(message: messageInfo)),
      disablePush: messageInfo.offlinePushInfo?.disablePush ?? offlinePushInfo?.disablePush,
      ignoreIOSBadge: messageInfo.offlinePushInfo?.ignoreIOSBadge ?? offlinePushInfo?.ignoreIOSBadge,
      iOSPushType: messageInfo.offlinePushInfo?.iOSPushType ?? offlinePushInfo?.iOSPushType,
      androidFCMChannelID: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.androidFCMChannelID) ??
          offlinePushInfo?.androidFCMChannelID,
      iOSSound: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.iOSSound) ?? offlinePushInfo?.iOSSound,
      androidSound:
          TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.androidSound) ?? offlinePushInfo?.androidSound,
      androidHuaWeiCategory: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.androidHuaWeiCategory) ??
          offlinePushInfo?.androidHuaWeiCategory,
      androidOPPOChannelID: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.androidOPPOChannelID) ??
          offlinePushInfo?.androidOPPOChannelID,
      androidVIVOCategory: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.androidVIVOCategory) ??
          offlinePushInfo?.androidVIVOCategory,
      androidVIVOClassification:
          messageInfo.offlinePushInfo?.androidVIVOClassification ?? offlinePushInfo?.androidVIVOClassification,
      androidXiaoMiChannelID: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.androidXiaoMiChannelID) ??
          offlinePushInfo?.androidXiaoMiChannelID,
      iOSImage: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.iOSImage) ??
          TencentCloudChatUtils.checkString(offlinePushInfo?.iOSImage) ??
          messageInfo.faceUrl,
      androidFCMImage: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.androidFCMImage) ??
          TencentCloudChatUtils.checkString(offlinePushInfo?.androidFCMImage) ??
          messageInfo.faceUrl,
      androidHonorImage: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.androidHonorImage) ??
          TencentCloudChatUtils.checkString(offlinePushInfo?.androidHonorImage) ??
          messageInfo.faceUrl,
      androidHuaWeiImage: TencentCloudChatUtils.checkString(messageInfo.offlinePushInfo?.androidHuaWeiImage) ??
          TencentCloudChatUtils.checkString(offlinePushInfo?.androidHuaWeiImage) ??
          messageInfo.faceUrl,
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

      messageInfo.cloudCustomData =
          TencentCloudChatUtils.checkString(messageInfo.cloudCustomData) ?? json.encode(cloudCustomData);
    }

    return messageInfo;
  }

  static Future<V2TimValueCallback<V2TimMessage>?> sendMessage({
    required V2TimMsgCreateInfoResult createdMessage,
    String? groupID,
    String? userID,
    String? topicID,
    V2TimMessage? repliedMessage,
    V2TimGroupInfo? groupInfo,
    OfflinePushInfo? offlinePushInfo,
    bool? needReadReceipt,
    TencentCloudChatMessageConfig? config,
    BeforeMessageSending? beforeMessageSendingHook,
    bool? isResend = false,
  }) async {
    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(
        key: TencentCloudChatUtils.checkString(topicID) ?? TencentCloudChatUtils.checkString(groupID) ?? userID ?? "");
    if (isResend ?? false) {
      currentHistoryMsgList.removeWhere((element) => element.msgID == createdMessage.messageInfo?.msgID);
    }

    final messageInfo = createdMessage.messageInfo;
    bool needSendRotate = false;
    final nRR = needReadReceipt ??
        (TencentCloudChatUtils.checkString(groupID) != null &&
            groupInfo != null &&
            (config?.enabledGroupTypesForMessageReadReceipt(
                      userID: userID,
                      groupID: groupID,
                      topicID: topicID,
                    ) ??
                    [])
                .contains(groupInfo.groupType));

    if (messageInfo != null) {
      V2TimMessage? messageInfoWithAdditionalInfo = TencentCloudChatMessageDataTools.setAdditionalInfoForMessage(
        messageInfo: messageInfo,
        id: createdMessage.id,
        repliedMessage: repliedMessage,
        groupID: groupID,
        needReadReceipt: nRR,
        offlinePushInfo: offlinePushInfo ??
            config?.messageOfflinePushInfo(userID: userID, groupID: groupID, topicID: topicID, message: messageInfo),
        groupInfo: groupInfo,
      );

      if (beforeMessageSendingHook != null) {
        messageInfoWithAdditionalInfo = beforeMessageSendingHook(
          createdMessage: messageInfoWithAdditionalInfo,
          repliedMessage: repliedMessage,
          userID: userID,
          groupID: groupID,
        );
      }

      if (messageInfoWithAdditionalInfo == null) {
        return null;
      }

      messageInfoWithAdditionalInfo.status = MessageStatus.V2TIM_MSG_STATUS_SENDING;

      currentHistoryMsgList.insert(0, messageInfoWithAdditionalInfo);
      TencentCloudChat.instance.dataInstance.messageData
          .updateMessageList(messageList: currentHistoryMsgList, userID: userID, groupID: groupID);

      return await sendMessageFinalPhase(
        userID: userID,
        groupID: groupID,
        messageInfo: messageInfoWithAdditionalInfo,
        needReadReceipt: nRR,
        id: createdMessage.id ?? "",
        offlinePushInfo: messageInfoWithAdditionalInfo.offlinePushInfo,
        cloudCustomData: needSendRotate
            ? TencentCloudChatUtils.addDataToStringFiled(
                key: "renderInfo",
                value: json.encode({
                  "rotate": "1",
                }),
                currentString: messageInfoWithAdditionalInfo.cloudCustomData ?? "",
              )
            : messageInfoWithAdditionalInfo.cloudCustomData,
        isResend: isResend,
      );
    }
    return null;
  }

  static Future<V2TimValueCallback<V2TimMessage>> sendMessageFinalPhase({
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
    bool? isResend = false,
  }) async {
    bool isNotResendMessage = !(isResend ?? false);
    final sendMsgRes = isNotResendMessage
      ? await TencentCloudChat.instance.chatSDKInstance.messageSDK.sendMessage(
        priority: priority,
        localCustomData: localCustomData,
        isExcludedFromUnreadCount: isExcludedFromUnreadCount ?? false,
        id: id,
        userID: userID,
        groupID: groupID,
        needReadReceipt: needReadReceipt ?? false,
        offlinePushInfo: offlinePushInfo,
        onlineUserOnly: onlineUserOnly ?? false,
        cloudCustomData: cloudCustomData,)
      : await TencentCloudChat.instance.chatSDKInstance.messageSDK.reSendMessage(msgID: messageInfo?.msgID ?? "");

    if (sendMsgRes.data != null && isCurrentConversation) {
      List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData
          .getMessageList(key: TencentCloudChatUtils.checkString(groupID) ?? userID ?? "");

      // Update the message in the currentHistoryMsgList with the same id.
      currentHistoryMsgList = currentHistoryMsgList.map((message) {
        if (message.id == id || message.msgID == sendMsgRes.data!.msgID) {
          return sendMsgRes.data!;
        }
        return message;
      }).toList();

      TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
        messageList: currentHistoryMsgList,
        userID: userID,
        groupID: groupID,
        disableNotify: true,
      );

      TencentCloudChat.instance.dataInstance.messageData.messageNeedUpdate = sendMsgRes.data!;

      TencentCloudChat.instance.dataInstance.messageData.onSendMessageProgress(
        message: sendMsgRes.data!,
        progress: 100,
        isSendComplete: true,
        id: id,
      );
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
