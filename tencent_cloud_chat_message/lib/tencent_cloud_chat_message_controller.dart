import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_data_tools.dart';

enum EventName {
  scrollToBottom,
  scrollToSpecificMessage,
}

class TencentCloudChatMessageControllerGenerator {
  static TencentCloudChatMessageController getInstance() {
    return TencentCloudChatMessageController._();
  }
}

class TencentCloudChatMessageController
    extends TencentCloudChatComponentBaseController {
  EventName? eventName;
  String? eventValue;
  String? userID;
  String? groupID;

  TencentCloudChatMessageController._();

  // Triggers the specified event with the given value and notifies listeners.
  _triggerEvent({required EventName eventName, String? value, String? user, String? group,}) {
    eventName = eventName;
    eventValue = value;
    userID = user;
    groupID = group;
    notifyListeners();
  }

  /// Scrolls the message list to the bottom for the specified conversation.
  /// The `userID` and `groupID` parameters identify the target conversation.
  void scrollToBottom({String? userID, String? groupID}) {
    _triggerEvent(eventName: EventName.scrollToBottom, value: null, user: userID, group: groupID);
  }

  /// Scrolls the message list to a specific message in the specified conversation.
  /// The `userID` and `groupID` parameters identify the target conversation.
  /// The `msgID` parameter identifies the target message.
  void scrollToSpecificMessage({String? userID, String? groupID, String? msgID}) {
    _triggerEvent(eventName: EventName.scrollToSpecificMessage, value: msgID, user: userID, group: groupID);
  }

  /// Sends a message and adds it to the message list UI.
  /// Before sending, use the Chat SDK create message method to create a message instance,
  /// and pass the created instance through the `createdMessage` parameter.
  /// The `repliedMessage` parameter indicates whether this message is a reply to a previous message.
  /// Other parameters are used to configure the offline push configuration for the recipient,
  /// whether a read receipt is needed, and other features.
  /// The `userID` and `groupID` parameters identify the target conversation.
  Future<V2TimValueCallback<V2TimMessage>?> sendMessage({
    required V2TimMsgCreateInfoResult createdMessage,
    String? groupID,
    String? userID,
    V2TimMessage? repliedMessage,
    V2TimGroupInfo? groupInfo,
    OfflinePushInfo? offlinePushInfo,
    bool? needReadReceipt,
    TencentCloudChatMessageConfig? config,
  }) async {
    return TencentCloudChatMessageDataTools.sendMessage(
      createdMessage: createdMessage,
      groupInfo: groupInfo,
      userID: userID,
      groupID: groupID,
      repliedMessage: repliedMessage,
      offlinePushInfo: offlinePushInfo,
      needReadReceipt: needReadReceipt,
      config: config,
    );
  }
}