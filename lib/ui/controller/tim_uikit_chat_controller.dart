// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class TIMUIKitChatController {
  late TUIChatSeparateViewModel? model;
  final TUIChatGlobalModel globalChatModel =
      serviceLocator<TUIChatGlobalModel>();

  TIMUIKitChatController({TUIChatSeparateViewModel? viewModel}) {
    if (viewModel != null) {
      model = viewModel;
    }
  }

  Future<bool> loadHistoryMessageList(
      {HistoryMsgGetTypeEnum getType =
          HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_OLDER_MSG,
      String? userID,
      String? groupID,
      int lastMsgSeq = -1,
      required int count,
      String? lastMsgID,
      LoadDirection direction = LoadDirection.previous}) async {
    return await model?.loadChatRecord(
          count: count,
          getType: getType,
          lastMsgID: lastMsgID,
          lastMsgSeq: lastMsgSeq,
        ) ??
        false;
  }

  /// clear the current conversation;
  /// 销毁
  @Deprecated("No need to dispose after tencent_cloud_chat_uikit 0.1.4")
  dispose() {}

  /// clear the history of current conversation;
  /// 清除历史记录
  /// Please provide `convID`, if you use `TIMUIKitChatController` without specifying to a `TIMUIKitChat`.
  clearHistory([String? convID]) {
    if (convID != null) {
      return globalChatModel.setMessageList(convID, []);
    }
    return model?.clearHistory();
  }

  /// refresh the history message list manually;
  /// 手动刷新会话历史消息列表
  /// Please provide `convType` and `convID`, if you use `TIMUIKitChatController` without specifying to a `TIMUIKitChat`.
  Future<bool> refreshCurrentHistoryList(
      [String? convID, ConvType? convType]) async {
    if (convID != null && convType != null) {
      return globalChatModel.refreshCurrentHistoryListForConversation(
          count: 50, convID: convID, convType: convType);
    } else if (model != null) {
      return model!.loadDataFromController();
    }
    return false;
  }

  /// update single message at UI model
  /// 更新单条消息
  /// Please provide `convID`, if you use `TIMUIKitChatController` without specifying to a `TIMUIKitChat`.
  Future<void> updateMessage(
      {
      /// The ID of the target conversation
      String? convID,

      /// The type of the target conversation
      ConvType? convType,

      /// message ID
      required String msgID}) async {
    if (convID != null && convType != null) {
      return globalChatModel.updateMessageFromController(
          msgID: msgID, conversationID: convID, conversationType: convType);
    } else if (model != null) {
      return model!.updateMessageFromController(msgID: msgID);
    }
    return;
  }

  /// Sends a message to the specified conversation, or to the current conversation specified on `TIMUIKitChat`.
  /// 发送消息到指定的对话，或者发送到 `TIMUIKitChat` 中指定的当前对话。
  /// You must provide `convType` and either `userID` or `groupID`, only if you use `TIMUIKitChat` without specifying a `TIMUIKitChatController`, you must provide these parameters.
  /// 您需要提供 `convType` 和 `userID` 或 `groupID`, 只有在如果您使用 `TIMUIKitChat` 而没有指定 `TIMUIKitChatController`，则必须提供这些参数。
  Future<V2TimValueCallback<V2TimMessage>?>? sendMessage({
    required V2TimMessage? messageInfo,

    /// The type of the target conversation: either ConvType.group or ConvType.c2c. Required if using `TIMUIKitChat` without specifying a `TIMUIKitChatController`.
    /// 目标对话的类型：ConvType.group 或 ConvType.c2c。只有在如果您使用 `TIMUIKitChat` 而没有指定 `TIMUIKitChatController`，则必须提供此参数。
    ConvType? convType,

    /// The user ID of the target one-to-one conversation. Required if convType is ConvType.c2c.
    /// 目标一对一对话的用户 ID。如果 convType 是 ConvType.c2c，则必填。
    String? userID,

    /// The target group ID. Required if convType is ConvType.group.
    /// 目标群组的 ID。如果 convType 是 ConvType.group，则必填。
    String? groupID,

    /// A callback function to update the input field when message sending fails.
    /// 当消息发送失败时，用于更新输入框的回调函数。
    ValueChanged<String>? setInputField,

    /// Offline push information.
    /// 离线推送信息。
    OfflinePushInfo? offlinePushInfo,
  }) {
    if (convType != null) {
      /// Sends a message to the specified conversation. 发送消息到指定的对话。
      assert((groupID == null) != (userID == null));
      assert(groupID != null || convType != ConvType.group);
      assert(userID != null || convType != ConvType.c2c);

      return globalChatModel.sendMessageFromController(
          messageInfo: messageInfo,
          convType: convType,
          convID: (convType == ConvType.group ? groupID : userID) ?? "",
          setInputField: setInputField,
          offlinePushInfo: offlinePushInfo);
    } else if (model != null) {
      /// Sends a message to the current conversation specified on `TIMUIKitChat`. 发送到 `TIMUIKitChat` 中指定的当前对话。
      return model!.sendMessageFromController(
          messageInfo: messageInfo, offlinePushInfo: offlinePushInfo);
    }
    return null;
  }

  /// Send forward message;
  /// 逐条转发
  /// This method needs use with TIMUIKitChat directly or model been initialized.
  sendForwardMessage({
    required List<V2TimConversation> conversationList,
  }) async {
    model?.sendForwardMessage(conversationList: conversationList);
  }

  /// Send merger message;
  /// 合并转发
  /// This method needs use with TIMUIKitChat directly or model been initialized.
  Future<V2TimValueCallback<V2TimMessage>?> sendMergerMessage({
    required List<V2TimConversation> conversationList,
    required String title,
    required List<String> abstractList,
    required BuildContext context,
  }) async {
    return model?.sendMergerMessage(
        conversationList: conversationList,
        title: title,
        abstractList: abstractList,
        context: context);
  }

  /// Set local custom data; returns the bool shows if succeed
  /// 为本地消息配置额外String字段
  /// Please provide `convID`, if you use `TIMUIKitChatController` without specifying to a `TIMUIKitChat`.
  Future<bool> setLocalCustomData(String msgID, String localCustomData,
      [String? convID]) async {
    final String? conversationID = convID ?? model?.conversationID;
    if (conversationID == null) {
      return false;
    }
    return globalChatModel.setLocalCustomData(
        msgID, localCustomData, conversationID);
  }

  /// Set local custom int; returns the bool shows if succeed
  /// 为本地消息配置额外int字段
  /// Please provide `convID`, if you use `TIMUIKitChatController` without specifying to a `TIMUIKitChat`.
  Future<bool> setLocalCustomInt(String msgID, int localCustomInt,
      [String? convID]) async {
    final String? conversationID = convID ?? model?.conversationID;
    if (conversationID == null) {
      return false;
    }
    return globalChatModel.setLocalCustomInt(
        msgID, localCustomInt, conversationID);
  }

  /// Get current conversation, returns UserID or GroupID if in the chat page, returns "" if not.
  /// 获取当前会话ID，如果在Chat页面，返回UserID or GroupID， 反之返回""
  String getCurrentConversation() {
    return globalChatModel.currentSelectedConv;
  }
}
