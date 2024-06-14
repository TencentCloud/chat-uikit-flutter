import 'dart:convert';

import 'package:zhaopin/im/tencent_cloud_chat_uikit.dart';
import 'package:zhaopin/im/ui/controller/tim_uikit_chat_controller.dart';
import 'package:zhaopin/net/index.dart';
import 'package:zhaopin/services/services_locator.dart';

class IMMessageServices {
  final TIMUIKitChatController _chatController = TIMUIKitChatController();

  // messageService类
  // final MessageService _messageService = serviceLocator<MessageService>();

  TIMUIKitChatController get chatController => _chatController;

  V2TIMManager get _sdkInstance => TIMUIKitCore.getSDKInstance();

  Future<V2TimMsgCreateInfoResult?> createCustomMessage({
    required Object data,
    String? desc,
    String? extension,
  }) async {
    final res = await _sdkInstance.getMessageManager().createCustomMessage(
        data: json.encode(data), desc: desc ?? '', extension: extension ?? '');
    if (res.code == 0) {
      return res.data;
    }
    return null;
  }

  Future<V2TimValueCallback<V2TimMessage>?>? sendTextMessage({
    required String text,
    String? groupID,
    String? userID,
  }) async {
    final res =
        await _sdkInstance.getMessageManager().createTextMessage(text: text);
    if (res.code == 0 && res.data?.messageInfo != null) {
      final result = await sendMessage(
        messageInfo: res.data?.messageInfo!,
        userID: userID,
        groupID: groupID,
      );
      return result;
    }
    return null;
  }

  Future<V2TimValueCallback<V2TimMessage>?>? sendMessage({
    required V2TimMessage? messageInfo,
    String? userID,
    String? groupID,
    MessagePriorityEnum priority = MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    bool needReadReceipt = true,
    OfflinePushInfo? offlinePushInfo,
    String? cloudCustomData,
    String? localCustomData,
  }) async {
    final result = await _chatController.sendMessage(
      messageInfo: messageInfo,
      userID: userID,
      groupID: groupID,
      priority: priority,
      onlineUserOnly: onlineUserOnly,
      offlinePushInfo: offlinePushInfo,
      needReadReceipt: needReadReceipt,
      localCustomData: localCustomData,
      cloudCustomData: cloudCustomData,
    );
    return result;
  }

  Future<V2TimCallback> markC2CMessageAsRead({
    required String userID,
  }) async {
    final result = await _sdkInstance
        .getMessageManager()
        .markC2CMessageAsRead(userID: userID);
    return result;
  }

  Future<V2TimCallback> markGroupMessageAsRead({
    required String groupID,
  }) async {
    final result = await _sdkInstance
        .getMessageManager()
        .markGroupMessageAsRead(groupID: groupID);
    return result;
  }

  Future<List<V2TimMessage>> findMessages({
    required List<String> messageIDList,
  }) async {
    final res = await _sdkInstance
        .getMessageManager()
        .findMessages(messageIDList: messageIDList);
    if (res.code == 0) {
      return res.data ?? [];
    }
    return [];
  }

  Future<V2TimValueCallback<V2TimMessageChangeInfo>> modifyMessage(
      {required V2TimMessage message}) async {
    final result =
        await _sdkInstance.getMessageManager().modifyMessage(message: message);
    return result;
  }

  Future<V2TimCallback> clearC2CHistoryMessage({
    required String userID,
  }) async {
    final result = await _sdkInstance
        .getMessageManager()
        .clearC2CHistoryMessage(userID: userID);
    return result;
  }

  Future<V2TimCallback> clearGroupHistoryMessage({
    required String groupID,
  }) async {
    final result = await _sdkInstance
        .getMessageManager()
        .clearGroupHistoryMessage(groupID: groupID);
    return result;
  }

  Future<V2TimValueCallback<V2TimMessageOnlineUrl>> getMessageOnlineUrl(
      {required String msgID}) async {
    final result = await _sdkInstance
        .getMessageManager()
        .getMessageOnlineUrl(msgID: msgID);

    return result;
  }

  Future<V2TimCallback> downloadMessage(
      {required String msgID,
      required int messageType,
      required int imageType,
      required bool isSnapshot}) async {
    final result = await _sdkInstance.getMessageManager().downloadMessage(
        msgID: msgID,
        messageType: messageType,
        imageType: imageType,
        isSnapshot: isSnapshot);
    return result;
  }

  // 通过服务器发送消息(自定义消息)
  Future<bool> sendMessageByServer({
    // 1：把消息同步到 From_Account 在线终端和漫游上；
    // 2：消息不同步至 From_Account；
    // 若不填写默认情况下会将消息存 From_Account 漫游
    int syncOtherMachine = 2,
    // true表示该条消息不计入未读数
    bool noRead = true,
    String? from,
    required String to,
    String? cloudCustomData,
    Map<String, dynamic> data = const {},
  }) async {
    final fromUserID = from ?? ServiceLocator.imCoreServices.userID;
    final body = {
      'SyncOtherMachine': syncOtherMachine,
      'From_Account': fromUserID,
      'To_Account': to,
      'MsgBody': [
        {
          'MsgType': 'TIMCustomElem',
          'MsgContent': {
            'Data': json.encode(data),
            'Desc': null,
            'Ext': null,
            'Sound': null
          }
        }
      ],
      'SendMsgControl': [if (noRead) 'NoUnread'],
      'CloudCustomData': cloudCustomData
    };
    final res = await HttpUtils()
        .post(HttpApi.sendMessageByService, data: body, showLoading: false);
    if (isHttpResError(res)) return false;
    return true;
  }

  // 通过服务器修改消息(自定义消息)
  Future<bool> modifyMessageByServer({

    String? from,
    required String to,
    String? cloudCustomData,
    Map<String, dynamic> data = const {},
  }) async {
    final fromUserID = from ?? ServiceLocator.imCoreServices.userID;
    final body = {
      'from': fromUserID,
      'to': to,
      'payload': {'data': json.encode(data)},
      'cloudCustomData': cloudCustomData
    };
    final res = await HttpUtils()
        .post(HttpApi.modifyMessageByService, data: body, showLoading: false);
    if (isHttpResError(res)) return false;
    return true;
  }
}
