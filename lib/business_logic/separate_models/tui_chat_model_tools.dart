import 'dart:convert';
import 'dart:io';

import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_cloud_custom_data.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';

class TUIChatModelTools {
  final TUIChatGlobalModel globalModel = serviceLocator<TUIChatGlobalModel>();
  final CoreServicesImpl _coreServices = serviceLocator<CoreServicesImpl>();

  OfflinePushInfo buildMessagePushInfo(
      V2TimMessage message, String convID, ConvType convType) {
    String createJSON(String convID) {
      return "{\"conversationID\": \"$convID\"}";
    }

    if (globalModel.chatConfig.offlinePushInfo != null) {
      final customData =
          globalModel.chatConfig.offlinePushInfo!(message, convID, convType);
      if (customData != null) {
        return customData;
      }
    }

    String title = globalModel.chatConfig.notificationTitle;

    // If user provides null, use default ext.
    String ext = globalModel.chatConfig.notificationExt != null
        ? globalModel.chatConfig.notificationExt!(message, convID, convType) ??
            (convType == ConvType.c2c
                ? createJSON("c2c_${message.sender}")
                : createJSON("group_$convID"))
        : (convType == ConvType.c2c
            ? createJSON("c2c_${message.sender}")
            : createJSON("group_$convID"));

    String desc = message.userID ?? message.groupID ?? "";
    String messageSummary = "";
    switch (message.elemType) {
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        messageSummary = TIM_t("自定义消息");
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        messageSummary = TIM_t("表情消息");
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        messageSummary = TIM_t("文件消息");
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS:
        messageSummary = TIM_t("群提示消息");
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        messageSummary = TIM_t("图片消息");
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        messageSummary = TIM_t("位置消息");
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        messageSummary = TIM_t("合并转发消息");
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        messageSummary = TIM_t("语音消息");
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        messageSummary = message.textElem!.text!;
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        messageSummary = TIM_t("视频消息");
        break;
    }

    if (globalModel.chatConfig.notificationBody != null) {
      desc =
          globalModel.chatConfig.notificationBody!(message, convID, convType) ??
              messageSummary;
    } else {
      desc = messageSummary;
    }

    return OfflinePushInfo.fromJson({
      "title": title,
      "desc": desc,
      "disablePush": false,
      "ext": ext,
      "iOSSound": globalModel.chatConfig.notificationIOSSound,
      "androidSound": globalModel.chatConfig.notificationAndroidSound,
      "ignoreIOSBadge": false,
      "androidOPPOChannelID": globalModel.chatConfig.notificationOPPOChannelID,
    });
  }

  V2TimMessage setUserInfoForMessage(V2TimMessage messageInfo, String? id) {
    final loginUserInfo = _coreServices.loginUserInfo;
    if (loginUserInfo != null) {
      messageInfo.faceUrl = loginUserInfo.faceUrl;
      messageInfo.nickName = loginUserInfo.nickName;
      messageInfo.sender = loginUserInfo.userID;
    }
    messageInfo.timestamp =
        (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
    messageInfo.isSelf = true;
    messageInfo.status = MessageStatus.V2TIM_MSG_STATUS_SENDING;
    messageInfo.id = id;

    return messageInfo;
  }

  String getMessageSummary(V2TimMessage message,
      String? Function(V2TimMessage message)? abstractMessageBuilder) {
    final String? customAbstractMessage =
        abstractMessageBuilder != null ? abstractMessageBuilder(message) : null;
    if (customAbstractMessage != null) {
      return customAbstractMessage;
    }

    final elemType = message.elemType;
    switch (elemType) {
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return "[表情消息]";
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return "[自定义消息]";
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        return "[文件消息]";
      case MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS:
        return "[群消息]";
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return "[图片消息]";
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        return "[位置消息]";
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        return "[合并消息]";
      case MessageElemType.V2TIM_ELEM_TYPE_NONE:
        return "[没有元素]";
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return "[语音消息]";
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return message.textElem?.text ?? "[文本消息]";
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        return "[视频消息]";
      default:
        return "";
    }
  }

  String getMessageAbstract(V2TimMessage message,
      String? Function(V2TimMessage message)? abstractMessageBuilder) {
    final messageAbstract = RepliedMessageAbstract(
        summary: TIM_t(getMessageSummary(message, abstractMessageBuilder)),
        elemType: message.elemType,
        msgID: message.msgID,
        timestamp: message.timestamp,
        seq: message.seq);
    return jsonEncode(messageAbstract.toJson());
  }

  Future<V2TimMessage?> getExistingMessageByID(
      {required String msgID,
      required String conversationID,
      required ConvType conversationType}) async {
    final currentHistoryMsgList =
        globalModel.messageListMap[conversationID] ?? [];
    final int? targetIndex = currentHistoryMsgList.indexWhere((item) {
      return item.msgID == msgID;
    });

    if (targetIndex != null &&
        targetIndex > -1 &&
        currentHistoryMsgList.isNotEmpty) {
      return currentHistoryMsgList[targetIndex];
    } else {
      return null;
    }
  }

  Future<bool> hasZeroSize(String filePath) async {
    try {
      final file = File(filePath);
      final fileSize = await file.length();
      return fileSize == 0;
    } catch (e) {
      return false;
    }
  }
}
