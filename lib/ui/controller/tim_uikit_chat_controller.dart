// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class TIMUIKitChatController {
  late TUIChatSeparateViewModel? model;
  late TIMUIKitInputTextFieldController? textFieldController;
  late AutoScrollController? scrollController;
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

  /// Clear the current conversation;
  @Deprecated("No need to dispose after tencent_cloud_chat_uikit 0.1.4")
  dispose() {}

  /// Clear the history of current conversation;
  /// Please provide `convID`, if you use `TIMUIKitChatController` without specifying to a `TIMUIKitChat`.
  clearHistory([String? convID]) {
    if (convID != null) {
      return globalChatModel.setMessageList(convID, []);
    }
    return model?.clearHistory();
  }

  /// refresh the history message list manually;
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

  /// Update single message at UI model
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
  /// You must provide `convType` and either `userID` or `groupID`, only if you use `TIMUIKitChat` without specifying a `TIMUIKitChatController`, you must provide these parameters.
  Future<V2TimValueCallback<V2TimMessage>?>? sendMessage({
    required V2TimMessage? messageInfo,

    /// The type of the target conversation: either ConvType.group or ConvType.c2c. Required if using `TIMUIKitChat` without specifying a `TIMUIKitChatController`.
    ConvType? convType,

    /// The user ID of the target one-to-one conversation. Required if convType is ConvType.c2c.
    String? userID,

    /// The target group ID. Required if convType is ConvType.group.
    String? groupID,

    /// A callback function to update the input field when message sending fails.
    ValueChanged<String>? setInputField,

    /// Offline push information.
    OfflinePushInfo? offlinePushInfo,

    /// Whether automatically scrolling to the bottom of the message list after sending a message.
    /// This field solely works when `TIMUIKitChatController` is specified for use within a `TIMUIKitChat`.
    bool isNavigateToMessageListBottom = true,

    /// Message priorities. This field is valid only for group chat messages.
    /// You are advised to set higher priorities for important messages (such as red packet and gift messages)
    /// and set lower priorities for frequent but unimportant messages (such as like messages).
    MessagePriorityEnum priority = MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,

    /// Whether the message can be received only by online users.
    /// If this field is set to true, the message cannot be pulled in recipient historical message pulling.
    /// This field is often used to implement weak notification features such as "The other party is typing" or unimportant notifications in the group. This field is not supported by audio-video groups (AVChatRoom).
    bool? onlineUserOnly,

    /// Whether the message is excluded from the conversation unread message count.
    bool? isExcludedFromUnreadCount,

    /// Whether a read receipt is required.
    bool? needReadReceipt,

    /// Cloud custom data (saved in the cloud, will be sent to the peer end,
    /// and can still be pulled after the app is uninstalled and reinstalled)
    String? cloudCustomData,

    /// Local custom message data (saved locally, will not be sent to the peer end,
    /// and will become invalid after the app is uninstalled and reinstalled).
    String? localCustomData,
  }) {
    if (convType != null) {
      /// Sends a message to the specified conversation.
      assert((groupID == null) != (userID == null));
      assert(groupID != null || convType != ConvType.group);
      assert(userID != null || convType != ConvType.c2c);
      if (isNavigateToMessageListBottom && scrollController != null) {
        scrollController!.animateTo(
          scrollController!.position.minScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
      return globalChatModel.sendMessageFromController(
          priority: priority,
          onlineUserOnly: onlineUserOnly,
          isExcludedFromUnreadCount: isExcludedFromUnreadCount,
          needReadReceipt: needReadReceipt,
          cloudCustomData: cloudCustomData,
          localCustomData: localCustomData,
          messageInfo: messageInfo,
          convType: convType,
          convID: (convType == ConvType.group ? groupID : userID) ?? "",
          setInputField: setInputField,
          offlinePushInfo: offlinePushInfo);
    } else if (model != null) {
      /// Sends a message to the current conversation specified on `TIMUIKitChat`. 发送到 `TIMUIKitChat` 中指定的当前对话。
      if (isNavigateToMessageListBottom && scrollController != null) {
        scrollController?.animateTo(
          scrollController!.position.minScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
      return model!.sendMessageFromController(
          priority: priority,
          onlineUserOnly: onlineUserOnly,
          isExcludedFromUnreadCount: isExcludedFromUnreadCount,
          needReadReceipt: needReadReceipt,
          cloudCustomData: cloudCustomData,
          localCustomData: localCustomData,
          messageInfo: messageInfo,
          offlinePushInfo: offlinePushInfo);
    }
    return null;
  }

  /// Sends a message, replying to another message, to the specified conversation, or to the current conversation specified on `TIMUIKitChat`.
  /// You must provide `convType` and either `userID` or `groupID`, only if you use `TIMUIKitChat` without specifying a `TIMUIKitChatController`, you must provide these parameters.
  Future<V2TimValueCallback<V2TimMessage>?>? sendReplyMessage({
    required String messageText,
    required V2TimMessage messageBeenReplied,

    /// The type of the target conversation: either ConvType.group or ConvType.c2c. Required if using `TIMUIKitChat` without specifying a `TIMUIKitChatController`.
    ConvType? convType,

    /// The user ID of the target one-to-one conversation. Required if convType is ConvType.c2c.
    String? userID,

    /// The target group ID. Required if convType is ConvType.group.
    String? groupID,

    /// A callback function to update the input field when message sending fails.
    ValueChanged<String>? setInputField,

    /// Offline push information.
    OfflinePushInfo? offlinePushInfo,

    /// Whether automatically scrolling to the bottom of the message list after sending a message.
    /// This field solely works when `TIMUIKitChatController` is specified for use within a `TIMUIKitChat`.
    bool isNavigateToMessageListBottom = true,

    /// Message priorities. This field is valid only for group chat messages.
    /// You are advised to set higher priorities for important messages (such as red packet and gift messages)
    /// and set lower priorities for frequent but unimportant messages (such as like messages).
    MessagePriorityEnum priority = MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,

    /// Whether the message can be received only by online users.
    /// If this field is set to true, the message cannot be pulled in recipient historical message pulling.
    /// This field is often used to implement weak notification features such as "The other party is typing" or unimportant notifications in the group. This field is not supported by audio-video groups (AVChatRoom).
    bool? onlineUserOnly,

    /// Whether the message is excluded from the conversation unread message count.
    bool? isExcludedFromUnreadCount,

    /// Whether a read receipt is required.
    bool? needReadReceipt,

    /// Local custom message data (saved locally, will not be sent to the peer end,
    /// and will become invalid after the app is uninstalled and reinstalled).
    String? localCustomData,
  }) {
    if (convType != null) {
      /// Sends a message to the specified conversation.
      assert((groupID == null) != (userID == null));
      assert(groupID != null || convType != ConvType.group);
      assert(userID != null || convType != ConvType.c2c);
      if (isNavigateToMessageListBottom && scrollController != null) {
        scrollController!.animateTo(
          scrollController!.position.minScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
      return globalChatModel.sendReplyMessageFromController(
          text: messageText,
          messageBeenReplied: messageBeenReplied,
          priority: priority,
          onlineUserOnly: onlineUserOnly,
          isExcludedFromUnreadCount: isExcludedFromUnreadCount,
          needReadReceipt: needReadReceipt,
          localCustomData: localCustomData,
          convType: convType,
          convID: (convType == ConvType.group ? groupID : userID) ?? "",
          setInputField: setInputField,
          offlinePushInfo: offlinePushInfo);
    } else if (model != null) {
      /// Sends a message to the current conversation specified on `TIMUIKitChat`. 发送到 `TIMUIKitChat` 中指定的当前对话。
      if (isNavigateToMessageListBottom && scrollController != null) {
        scrollController?.animateTo(
          scrollController!.position.minScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
      return globalChatModel.sendReplyMessageFromController(
          text: messageText,
          messageBeenReplied: messageBeenReplied,
          priority: priority,
          onlineUserOnly: onlineUserOnly,
          isExcludedFromUnreadCount: isExcludedFromUnreadCount,
          needReadReceipt: needReadReceipt,
          localCustomData: localCustomData,
          convType: model!.conversationType ?? ConvType.group,
          convID: model!.conversationID,
          setInputField: setInputField,
          offlinePushInfo: offlinePushInfo);
    }
    return null;
  }

  /// Send forward message;
  /// This function solely works when `TIMUIKitChatController` is specified for use within a `TIMUIKitChat`.
  sendForwardMessage({
    required List<V2TimConversation> conversationList,
  }) async {
    model?.sendForwardMessage(conversationList: conversationList);
  }

  /// Send merger message;
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

  /// Set local custom data; returns the bool shows if succeed.
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

  /// Set local custom int; returns the bool shows if succeed.
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
  String getCurrentConversation() {
    return globalChatModel.currentSelectedConv;
  }

  /// Hide all bottom panels, including the sticker panel and the additional functions panel, on mobile devices.
  /// This function solely works when `TIMUIKitChatController` is specified for use within a `TIMUIKitChat`.
  void hideAllBottomPanelOnMobile() {
    textFieldController?.hideAllPanel();
  }

  /// Mention or @ other members in a group manually.
  /// This function solely works when `TIMUIKitChatController` is specified for use within a `TIMUIKitChat`.
  void mentionOtherMemberInGroup(
      {required String showNameInMessage, required String userID}) {
    textFieldController?.longPressToAt(showNameInMessage, userID);
  }

  /// Set the content within the message input text field.
  /// This function solely works when `TIMUIKitChatController` is specified for use within a `TIMUIKitChat`.
  void setInputTextField(String text) {
    textFieldController?.setTextField(text);
  }

  /// Returns the list of group members of current group chat based on the provided keyword.
  ///
  /// This method filters the group members based on the given keyword. If the keyword is not provided,
  /// it returns the entire list of group members. The filtering is performed by checking if the keyword
  /// is contained within the userID, nickName, or friendRemark properties of each group member.
  ///
  /// [keyword] (optional) - The keyword to filter the group members. If not provided, the entire list of group members is returned.
  /// This function solely works when `TIMUIKitChatController` is specified for use within a `TIMUIKitChat`.
  List<V2TimGroupMemberFullInfo> getGroupMemberList({String? keyword}) {
    final List<V2TimGroupMemberFullInfo> memberList =
        (model?.groupMemberList ?? [])
            .whereType<V2TimGroupMemberFullInfo>()
            .toList();

    return TencentUtils.checkString(keyword) == null
        ? memberList
        : memberList.where((e) {
            final userID = e.userID;
            final nickName = e.nickName ?? "";
            final friendRemark = e.friendRemark ?? "";
            return userID.contains(keyword!) ||
                nickName.contains(keyword) ||
                friendRemark.contains(keyword);
          }).toList();
  }
}
