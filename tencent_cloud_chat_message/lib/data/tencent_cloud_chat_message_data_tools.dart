import 'dart:convert';
import 'dart:io';

import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
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
    final loginUserInfo = TencentCloudChat.instance.dataInstance.basic.currentUser;
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

  static Future<V2TimValueCallback<V2TimMessage>?> sendMessage({
    required V2TimMsgCreateInfoResult createdMessage,
    String? groupID,
    String? userID,
    V2TimMessage? repliedMessage,
    V2TimGroupInfo? groupInfo,
    OfflinePushInfo? offlinePushInfo,
    bool? needReadReceipt,
    TencentCloudChatMessageConfig? config,
  }) async {
    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance
        .dataInstance
        .messageData
        .getMessageList(
        key: TencentCloudChatUtils.checkString(groupID) ?? userID ?? "");
    final messageInfo = createdMessage.messageInfo;
    bool needSendRotate = false;
    if (messageInfo != null) {
      final messageInfoWithAdditionalInfo =
      TencentCloudChatMessageDataTools.setAdditionalInfoForMessage(
        messageInfo: messageInfo,
        id: createdMessage.id!,
        repliedMessage: repliedMessage,
        groupID: groupID,
        offlinePushInfo: offlinePushInfo ?? config?.messageOfflinePushInfo(
            userID: userID, groupID: groupID, message: messageInfo) ?? OfflinePushInfo(),
        groupInfo: groupInfo,
      );

      if (messageInfo.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
        if (messageInfo.imageElem != null) {
          if (TencentCloudChatUtils.checkString(messageInfo.imageElem!.path) !=
              null) {
            File image = File(messageInfo.imageElem!.path!);
            ImageExifInfo imageExifInfo =
            await TencentCloudChatUtils.getImageExifInfoByBuffer(
                fileBuffer: image.readAsBytesSync());
            String currentLocal = TencentCloudChatUtils.addDataToStringFiled(
              key: "renderInfo",
              value: json.encode({
                'h': imageExifInfo.height,
                'w': imageExifInfo.width,
                'rotate': imageExifInfo.isRotate ? "1" : "0",
                "from": "send",
              }),
              currentString:
              messageInfoWithAdditionalInfo.localCustomData ?? "",
            );

            if (imageExifInfo.isRotate) {
              needSendRotate = true;
            }
            messageInfoWithAdditionalInfo.localCustomData = currentLocal;

            TencentCloudChat.instance.logInstance.console(
                componentName: "TencentCloudChatMessageSeparateDataProvider",
                logs:
                "before send image message. get image info $currentLocal");
          }
        }
      }

      if (messageInfo.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
        if (messageInfo.videoElem != null) {
          if (TencentCloudChatUtils.checkString(
              messageInfo.videoElem!.snapshotPath) !=
              null) {
            File image = File(messageInfo.videoElem!.snapshotPath!);
            ImageExifInfo imageExifInfo =
            await TencentCloudChatUtils.getImageExifInfoByBuffer(
                fileBuffer: image.readAsBytesSync());
            String currentLocal = TencentCloudChatUtils.addDataToStringFiled(
              key: "renderInfo",
              value: json.encode({
                'h': imageExifInfo.height,
                'w': imageExifInfo.width,
                'rotate': imageExifInfo.isRotate ? "1" : "0",
                "from": "send",
              }),
              currentString:
              messageInfoWithAdditionalInfo.localCustomData ?? "",
            );
            if (imageExifInfo.isRotate) {
              needSendRotate = true;
            }
            messageInfoWithAdditionalInfo.localCustomData = currentLocal;
            TencentCloudChat.instance.logInstance.console(
                componentName: "TencentCloudChatMessageSeparateDataProvider",
                logs:
                "before send image message. get image info $currentLocal");
          }
        }
      }

      currentHistoryMsgList.insert(0, messageInfoWithAdditionalInfo);
      TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
          messageList: currentHistoryMsgList,
          userID: userID,
          groupID: groupID);

      final nRR = needReadReceipt ??
          (TencentCloudChatUtils.checkString(groupID) != null &&
              groupInfo != null &&
              (config
                  ?.enabledGroupTypesForMessageReadReceipt(
                  userID: userID, groupID: groupID) ?? [])
                  .contains(groupInfo.groupType));

      return await sendMessageFinalPhase(
        userID: userID,
        groupID: groupID,
        messageInfo: messageInfoWithAdditionalInfo,
        needReadReceipt: nRR,
        id: createdMessage.id as String,
        offlinePushInfo: messageInfoWithAdditionalInfo.offlinePushInfo,
        cloudCustomData: needSendRotate
            ? TencentCloudChatUtils.addDataToStringFiled(
          key: "renderInfo",
          value: json.encode({
            "rotate": "1",
          }),
          currentString:
          messageInfoWithAdditionalInfo.cloudCustomData ?? "",
        )
            : messageInfoWithAdditionalInfo.cloudCustomData,
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
  }) async {
    final sendMsgRes = await TencentCloudChat.instance.chatSDKInstance.messageSDK.sendMessage(
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
      List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(key: TencentCloudChatUtils.checkString(groupID) ?? userID ?? "");

      // Update the message in the currentHistoryMsgList with the same id.
      currentHistoryMsgList = currentHistoryMsgList.map((message) {
        if (message.id == id) {
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

      TencentCloudChat.instance.dataInstance.messageData.onSendMessageProgress(sendMsgRes.data!, 100, true);
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
