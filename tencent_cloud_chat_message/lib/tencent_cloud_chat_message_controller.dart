import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_data_tools.dart';

enum EventName {
  scrollToBottom,
  scrollToSpecificMessage,
  mentionGroupMembers,
  setMessageTextWithMentions,
}

class TencentCloudChatMessageControllerGenerator {
  static TencentCloudChatMessageController getInstance() {
    return TencentCloudChatMessageController._();
  }
}

/// Controller for the TencentCloudChatMessage component, enabling a range of custom message operations.
/// The currently supported methods are listed below. For specific usage, please refer to the comments on each controller method.
/// - updateMessages: Updates the message widgets.
/// - mentionGroupMembers: Allows for mentioning users within a group.
/// - setMessageTextWithMentions: Sets the text message in the input area, with the ability to mention users.
/// - scrollToBottom: Enables automatic scrolling to the bottom of the message list.
/// - scrollToSpecificMessage: Enables scrolling to a specific message in the list.
/// - sendMessage: Allows for sending a message and automatically adds it to the message list UI.
class TencentCloudChatMessageController extends TencentCloudChatComponentBaseController {
  /// Updates the message widgets,
  /// causing them to re-render in the widget tree.
  void updateMessages({
    required List<V2TimMessage> messages,
  }) {
    for (final e in messages) {
      TencentCloudChat.instance.dataInstance.messageData.messageNeedUpdate = e;
    }
  }

  /// Mentions users within a group.
  /// Accepts a list of `V2TimGroupMemberFullInfo` objects representing the group members to mention.
  void mentionGroupMembers({
    required List<V2TimGroupMemberFullInfo> groupMembers,
    String? user,
    String? group,
    String? topicID,
  }) {
    groupMembersFullInfo = groupMembers;
    _triggerEvent(
      event: EventName.mentionGroupMembers,
      value: null,
      user: user,
      group: group,
      topic: topicID,
    );
  }

  /// Sets the text message in the message input area, replacing the current editing content,
  /// with an optional list of `V2TimGroupMemberFullInfo` objects representing the group members to be mentioned.
  /// If no group members are provided, the method will simply set the message text.
  void setMessageTextWithMentions({
    List<V2TimGroupMemberFullInfo>? groupMembersToMention,
    String? messageText,
    String? user,
    String? group,
    String? topicID,
  }) {
    groupMembersFullInfo = groupMembersToMention;
    _triggerEvent(
      event: EventName.setMessageTextWithMentions,
      value: messageText,
      user: user,
      group: group,
      topic: topicID,
    );
  }

  /// Scrolls the message list to the bottom for the specified conversation.
  /// The `userID` and `groupID` parameters identify the target conversation.
  void scrollToBottom({
    String? userID,
    String? groupID,
    String? topicID,
  }) {
    _triggerEvent(
      event: EventName.scrollToBottom,
      value: null,
      user: userID,
      topic: topicID,
      group: groupID,
    );
  }

  /// Scrolls the message list to a specific message in the specified conversation.
  /// The `userID` and `groupID` parameters identify the target conversation.
  /// The `msgID` parameter identifies the target message.
  void scrollToSpecificMessage({String? userID, String? groupID, String? topicID, String? msgID}) {
    _triggerEvent(
      event: EventName.scrollToSpecificMessage,
      value: msgID,
      user: userID,
      group: groupID,
      topic: topicID,
    );
  }

  /// Sends a message and adds it to the message list UI.
  /// Before sending, use the Chat SDK create message method to create a message instance,
  /// and pass the created instance through the `createdMessage` parameter.
  /// The `repliedMessage` parameter indicates whether this message is a reply to a previous message.
  /// Other parameters are used to configure the offline push configuration for the recipient,
  /// whether a read receipt is needed, and other features.
  /// The `userID`, `groupID` and `topicID` parameters identify the target conversation.
  Future<V2TimValueCallback<V2TimMessage>?> sendMessage({
    required V2TimMsgCreateInfoResult createdMessage,
    String? groupID,
    String? userID,
    String? topicID,
    V2TimMessage? repliedMessage,
    V2TimGroupInfo? groupInfo,
    OfflinePushInfo? offlinePushInfo,
    bool? needReadReceipt,
    @Deprecated("This config is for internal use only in the UIKit and should not be specified manually.")
    TencentCloudChatMessageConfig? config,
    @Deprecated("This hook is for internal use only in the UIKit and should not be specified manually.")
    BeforeMessageSending? beforeMessageSendingHook,
    bool? isResend = false,
  }) async {
    return TencentCloudChatMessageDataTools.sendMessage(
      createdMessage: createdMessage,
      groupInfo: groupInfo,
      userID: userID,
      topicID: topicID,
      groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID,
      repliedMessage: repliedMessage,
      offlinePushInfo: offlinePushInfo,
      needReadReceipt: needReadReceipt,
      config: config,
      beforeMessageSendingHook: beforeMessageSendingHook,
      isResend: isResend,
    );
  }

  void setDraft(String conversationID, String draft) {
    TencentCloudChat.instance.chatSDKInstance.manager
        .getConversationManager()
        .setConversationDraft(conversationID: conversationID, draftText: draft);
  }

  EventName? eventName;
  String? eventValue;
  List<V2TimGroupMemberFullInfo>? groupMembersFullInfo;
  String? userID;
  String? groupID;
  String? topicID;

  TencentCloudChatMessageController._();

  // Triggers the specified event with the given value and notifies listeners.
  _triggerEvent({
    required EventName event,
    String? value,
    String? user,
    String? group,
    String? topic,
  }) {
    eventName = event;
    eventValue = value;
    userID = user;
    groupID = group;
    topicID = topic;
    notifyListeners();
  }
}
