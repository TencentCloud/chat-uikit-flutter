// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSimpleMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/get_group_message_read_member_list_filter.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_priority_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/offlinePushInfo.dart';
import 'package:tencent_cloud_chat_sdk/enum/receive_message_opt_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_message_read_member_list.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_message_read_member_list.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_change_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_list_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_list_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_online_url.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_online_url.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_receipt.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_receipt.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_search_param.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_search_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message_search_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_callback.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/error_message_converter.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

class MessageServiceImpl extends MessageService {
  final CoreServicesImpl _coreService = serviceLocator<CoreServicesImpl>();
  final Map<String, List<V2TimMessage>> messageListMap = {};
  final Map<String, List<V2TimMessage>> sendingMessage = {};

  @override
  Future<MessageListResponse> getHistoryMessageListV2({
    HistoryMsgGetTypeEnum getType = HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
    String? userID,
    String? groupID,
    int lastMsgSeq = -1,
    required int count,
    String? lastMsgID,
    List<int>? messageTypeList,
  }) async {
    bool haveMoreData = true;
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getHistoryMessageList(
        count: count,
        getType: getType,
        userID: userID,
        groupID: groupID,
        lastMsgID: lastMsgID,
        lastMsgSeq: lastMsgSeq,
        messageTypeList: messageTypeList);
    final List<V2TimMessage> responseMessageList = res.data ?? [];
    final conversationID = userID ?? groupID;
    final cachedMessageList = messageListMap[conversationID];
    List<V2TimMessage> combinedMessageList = [];
    // 加载更多
    if (lastMsgID != null && cachedMessageList != null) {
      combinedMessageList = [...cachedMessageList, ...responseMessageList];
      // 首次加载
    } else {
      final bool existSendingMessage =
          sendingMessage[conversationID] != null && sendingMessage[conversationID]!.isNotEmpty;
      // 存在未发送完成的消息
      if (existSendingMessage) {
        combinedMessageList = [...sendingMessage[conversationID]!, ...responseMessageList];
      } else {
        sendingMessage.remove(conversationID);
        combinedMessageList = responseMessageList;
      }
    }
    if (res.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    }
    if (responseMessageList.isEmpty ||
        (!PlatformUtils().isWeb && responseMessageList.length < count) ||
        (PlatformUtils().isWeb && responseMessageList.length < min(count, 20))) {
      haveMoreData = false;
    } else {
      haveMoreData = true;
    }
    return MessageListResponse(haveMoreData: haveMoreData, data: combinedMessageList);
  }

  @override
  Future<List<V2TimMessage>> getHistoryMessageList({
    HistoryMsgGetTypeEnum getType = HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
    String? userID,
    String? groupID,
    int lastMsgSeq = -1,
    required int count,
    String? lastMsgID,
    List<int>? messageTypeList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getHistoryMessageList(
        count: count,
        getType: getType,
        userID: userID,
        groupID: groupID,
        lastMsgID: lastMsgID,
        lastMsgSeq: lastMsgSeq,
        messageTypeList: messageTypeList);
    final reponseMessageList = res.data ?? [];
    if (res.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    }
    return reponseMessageList;
  }

  @override
  Future<V2TimMessageListResult?> getHistoryMessageListWithComplete({
    HistoryMsgGetTypeEnum getType = HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
    String? userID,
    String? groupID,
    int lastMsgSeq = 0,
    required int count,
    String? lastMsgID,
    List<int>? messageTypeList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getHistoryMessageListV2(
        count: count,
        getType: getType,
        userID: userID,
        groupID: groupID,
        lastMsgID: lastMsgID,
        lastMsgSeq: lastMsgSeq,
        messageTypeList: messageTypeList);
    final responseMessageList = res.data;
    if (res.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    }
    return responseMessageList;
  }

  @override
  Future addSimpleMsgListener({
    required V2TimSimpleMsgListener listener,
  }) async {
    return TencentImSDKPlugin.v2TIMManager.addSimpleMsgListener(listener: listener);
  }

  @override
  Future<void> removeSimpleMsgListener({V2TimSimpleMsgListener? listener}) {
    return TencentImSDKPlugin.v2TIMManager.removeSimpleMsgListener(listener: listener);
  }

  @override
  Future<void> addAdvancedMsgListener({
    required V2TimAdvancedMsgListener listener,
  }) {
    return TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(listener: listener);
  }

  @override
  Future<V2TimValueCallback<V2TimGroupMessageReadMemberList>> getGroupMessageReadMemberList({
    required String messageID,
    required GetGroupMessageReadMemberListFilter filter,
    int nextSeq = 0,
    int count = 100,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .getGroupMessageReadMemberList(messageID: messageID, filter: filter, nextSeq: nextSeq, count: count);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimValueCallback<List<V2TimMessageReceipt>>> getMessageReadReceipts({
    required List<String> messageIDList,
  }) async {
    final result =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageReadReceipts(messageIDList: messageIDList);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimCallback> sendMessageReadReceipts({
    required List<String> messageIDList,
  }) async {
    return _retryMarkMessageAsRead(action: () {
      return TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessageReadReceipts(messageIDList: messageIDList);
    });
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createTextMessage({required String text}) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextMessage(text: text);
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createCustomMessage({required String data}) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createCustomMessage(data: data);
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createFaceMessage({required int index, required String data}) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createFaceMessage(index: index, data: data);
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> reSendMessage({required String msgID, bool? onlineUserOnly}) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .reSendMessage(msgID: msgID, onlineUserOnly: onlineUserOnly ?? false);
    if (res.code != 0) {
      String recommendText = ErrorMessageConverter.getErrorMessage(res.code);
      _coreService.callOnCallback(TIMCallback(
          type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code, infoRecommendText: recommendText));
    }
    return res;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createTextAtMessage(
      {required String text, required List<String> atUserList}) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextAtMessage(text: text, atUserList: atUserList);
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createImageMessage(
      {String? imageName, String? imagePath, dynamic inputElement}) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createImageMessage(imageName: imageName, imagePath: imagePath ?? "", inputElement: inputElement);
    if (res.code == 0) {
      return res.data;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createSoundMessage({
    required String soundPath,
    required int duration,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createSoundMessage(soundPath: soundPath, duration: duration);
    if (res.code == 0) {
      return res.data;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendMessage({
    required String id, // 自己创建的ID
    required String receiver,
    required String groupID,
    MessagePriorityEnum priority = MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    bool needReadReceipt = false,
    OfflinePushInfo? offlinePushInfo,
    String? cloudCustomData,
    String? localCustomData,
    bool isExcludedFromContentModeration = false,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
          id: id,
          receiver: receiver,
          groupID: groupID,
          priority: priority,
          onlineUserOnly: onlineUserOnly,
          offlinePushInfo: offlinePushInfo,
          needReadReceipt: needReadReceipt,
          localCustomData: localCustomData,
          cloudCustomData: cloudCustomData,
          isExcludedFromContentModeration: isExcludedFromContentModeration,
          isExcludedFromUnreadCount: isExcludedFromUnreadCount,
        );
    if (result.code != 0) {
      String recommendText = ErrorMessageConverter.getErrorMessage(result.code);
      _coreService.callOnCallback(TIMCallback(
          type: TIMCallbackType.API_ERROR,
          errorMsg: result.desc,
          errorCode: result.code,
          infoRecommendText: recommendText));
    }
    return result;
  }

  @override
  Future<V2TimCallback> deleteMessageFromLocalStorage({
    required String msgID,
    Object? webMessageInstance,
  }) async {
    V2TimCallback result;
    if (kIsWeb) {
      result = await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .deleteMessages(msgIDs: [], webMessageInstanceList: [webMessageInstance]);
    } else {
      result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().deleteMessageFromLocalStorage(msgID: msgID);
    }

    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimCallback> revokeMessage({required String msgID, Object? webMessageInstance}) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .revokeMessage(msgID: msgID, webMessageInstatnce: webMessageInstance);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimCallback> clearC2CHistoryMessage({
    required String userID,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearC2CHistoryMessage(userID: userID);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimCallback> clearGroupHistoryMessage({
    required String groupID,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearGroupHistoryMessage(groupID: groupID);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  Future<V2TimCallback> _retryMarkMessageAsRead({
    required Future<V2TimCallback> Function() action,
    int retries = 3,
  }) async {
    V2TimCallback result;
    int attempts = 0;
    do {
      result = await action();
      if (result.code == 0) {
        return result;
      }
      attempts++;
      await Future.delayed(const Duration(milliseconds: 500));
    } while (attempts < retries);

    _coreService
        .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));

    return result;
  }

  @override
  Future<V2TimCallback> markC2CMessageAsRead({
    required String userID,
  }) {
    return _retryMarkMessageAsRead(action: () {
      return TencentImSDKPlugin.v2TIMManager.getConversationManager().cleanConversationUnreadMessageCount(
            conversationID: "${TUIConversationViewModel.conversationC2CPrefix}$userID",
            cleanTimestamp: 0,
            cleanSequence: 0,
          );
    });
  }

  @override
  Future<V2TimCallback> markGroupMessageAsRead({
    required String groupID,
  }) {
    return _retryMarkMessageAsRead(action: () {
      return TencentImSDKPlugin.v2TIMManager.getConversationManager().cleanConversationUnreadMessageCount(
            conversationID: "${TUIConversationViewModel.conversationGroupPrefix}$groupID",
            cleanTimestamp: 0,
            cleanSequence: 0,
          );
    });
  }

  @override
  Future<void> removeAdvancedMsgListener({V2TimAdvancedMsgListener? listener}) async {
    final result =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().removeAdvancedMsgListener(listener: listener);
    return result;
  }

  @override
  Future<List<V2TimMessage>?> downloadMergerMessage({
    required String msgID,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().downloadMergerMessage(msgID: msgID);
    if (res.code == 0) {
      return res.data;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createForwardMessage({
    required String msgID,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createForwardMessage(msgID: msgID);
    if (res.code == 0) {
      return res.data;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createMergerMessage({
    required List<String> msgIDList,
    required String title,
    required List<String> abstractList,
    required String compatibleText,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createMergerMessage(
        msgIDList: msgIDList, title: title, abstractList: abstractList, compatibleText: compatibleText);
    if (res.code == 0) {
      return res.data;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimCallback> deleteMessages({required List<String> msgIDs, List<dynamic>? webMessageInstanceList}) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .deleteMessages(msgIDs: msgIDs, webMessageInstanceList: webMessageInstanceList);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createVideoMessage(
      {String? videoPath, String? type, int? duration, String? snapshotPath, dynamic inputElement}) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createVideoMessage(
        videoFilePath: videoPath ?? "",
        type: type ?? "",
        duration: duration ?? 1,
        snapshotPath: snapshotPath ?? "",
        inputElement: inputElement);
    if (res.code == 0) {
      return res.data;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendReplyMessage({
    required String id, // 自己创建的ID
    required String receiver,
    required String groupID,
    OfflinePushInfo? offlinePushInfo,
    bool needReadReceipt = false,
    required V2TimMessage replyMessage, // 被回复的消息
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendReplyMessage(
        id: id,
        receiver: receiver,
        offlinePushInfo: offlinePushInfo,
        groupID: groupID,
        needReadReceipt: needReadReceipt,
        replyMessage: replyMessage);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createFileMessage(
      {String? filePath, required String fileName, dynamic inputElement}) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createFileMessage(filePath: filePath ?? "", fileName: fileName, inputElement: inputElement);
    if (res.code == 0) {
      return res.data;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimMsgCreateInfoResult?> createLocationMessage(
      {required String desc, required double longitude, required double latitude}) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createLocationMessage(desc: desc, longitude: longitude, latitude: latitude);
    if (res.code == 0) {
      return res.data;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimValueCallback<V2TimMessageSearchResult>> searchLocalMessages(
      {required V2TimMessageSearchParam searchParam}) async {
    final result =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().searchLocalMessages(searchParam: searchParam);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<List<V2TimMessage>?> findMessages({
    required List<String> messageIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().findMessages(messageIDList: messageIDList);
    if (res.code == 0) {
      return res.data;
    }
    _coreService.callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: res.desc, errorCode: res.code));
    return null;
  }

  @override
  Future<V2TimCallback> setLocalCustomInt({required String msgID, required int localCustomInt}) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .setLocalCustomInt(msgID: msgID, localCustomInt: localCustomInt);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimCallback> setC2CReceiveMessageOpt({
    required List<String> userIDList,
    required ReceiveMsgOptEnum opt,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .setC2CReceiveMessageOpt(userIDList: userIDList, opt: opt);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimCallback> setGroupReceiveMessageOpt({
    required String groupID,
    required ReceiveMsgOptEnum opt,
  }) async {
    final result =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().setGroupReceiveMessageOpt(groupID: groupID, opt: opt);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimValueCallback<V2TimMessageChangeInfo>> modifyMessage({required V2TimMessage message}) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().modifyMessage(message: message);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimCallback> setLocalCustomData({required String msgID, required String localCustomData}) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .setLocalCustomData(msgID: msgID, localCustomData: localCustomData);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimValueCallback<V2TimMessageOnlineUrl>> getMessageOnlineUrl({required String msgID}) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageOnlineUrl(msgID: msgID);

    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<V2TimCallback> downloadMessage(
      {required String msgID, required int messageType, required int imageType, required bool isSnapshot}) async {
    final result = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .downloadMessage(msgID: msgID, messageType: messageType, imageType: imageType, isSnapshot: isSnapshot);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result;
  }

  @override
  Future<String> translateText(String text, String target) async {
    final result =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().translateText(texts: [text], targetLanguage: target);
    if (result.code != 0) {
      _coreService
          .callOnCallback(TIMCallback(type: TIMCallbackType.API_ERROR, errorMsg: result.desc, errorCode: result.code));
    }
    return result.data?[text] ?? "";
  }
}
