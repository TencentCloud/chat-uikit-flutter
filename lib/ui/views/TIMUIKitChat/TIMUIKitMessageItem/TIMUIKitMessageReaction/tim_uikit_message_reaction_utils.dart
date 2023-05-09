import 'dart:convert';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_cloud_custom_data.dart';

class MessageReactionUtils {
  static final TUISelfInfoViewModel selfInfoModel =
      serviceLocator<TUISelfInfoViewModel>();
  static final MessageService _messageService =
      serviceLocator<MessageService>();

  static CloudCustomData getCloudCustomData(V2TimMessage message) {
    CloudCustomData messageCloudCustomData;
    try {
      messageCloudCustomData = CloudCustomData.fromJson(json.decode(
          TencentUtils.checkString(message.cloudCustomData) != null
              ? message.cloudCustomData!
              : "{}"));
    } catch (e) {
      messageCloudCustomData = CloudCustomData();
    }

    return messageCloudCustomData;
  }

  static Map<String, dynamic> getMessageReaction(V2TimMessage message) {
    return getCloudCustomData(message).messageReaction ?? {};
  }

  static Future<V2TimValueCallback<V2TimMessageChangeInfo>> clickOnSticker(
      V2TimMessage message, int sticker) async {
    final CloudCustomData messageCloudCustomData = getCloudCustomData(message);
    final Map<String, dynamic> messageReaction =
        messageCloudCustomData.messageReaction ?? {};
    List targetList = messageReaction["$sticker"] ?? [];
    if (targetList.contains(selfInfoModel.loginInfo!.userID!)) {
      targetList.remove(selfInfoModel.loginInfo!.userID!);
    } else {
      targetList = [selfInfoModel.loginInfo!.userID!, ...targetList];
    }
    messageReaction["$sticker"] = targetList;

    if (PlatformUtils().isWeb) {
      final decodedMessage = jsonDecode(message.messageFromWeb!);
      decodedMessage["cloudCustomData"] =
          jsonEncode(messageCloudCustomData.toMap());
      message.messageFromWeb = jsonEncode(decodedMessage);
    } else {
      message.cloudCustomData = json.encode(messageCloudCustomData.toMap());
    }
    return await _messageService.modifyMessage(message: message);
  }
}
