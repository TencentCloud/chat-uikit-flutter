import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

class TencentCloudChatMessageOptions {
  final String? userID;
  final String? groupID;
  final String? topicID;
  final V2TimMessage? targetMessage;

  // Constructor for TencentCloudChatMessageOptions.
  //
  // [userID]: The user ID for a one-to-one conversation.
  // [groupID]: The group ID for a group conversation.
  // [topicID]: The topicID for a topic, within a community group conversation.
  TencentCloudChatMessageOptions( {this.userID, this.topicID, this.groupID, this.targetMessage, });

  // Converts the TencentCloudChatMessageOptions object to a map.
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'groupID': groupID,
      'topicID': topicID,
      'targetMessage': targetMessage,
    };
  }

  // Creates a TencentCloudChatMessageOptions object from the given map.
  static TencentCloudChatMessageOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatMessageOptions(
      userID: map['userID'] as String?,
      groupID: map['groupID'] as String?,
      topicID: map['topicID'] as String?,
      targetMessage: map['targetMessage'] as V2TimMessage?,
    );
  }
}
