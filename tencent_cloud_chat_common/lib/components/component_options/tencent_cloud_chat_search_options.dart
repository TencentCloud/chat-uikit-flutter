import 'package:tencent_cloud_chat_sdk/enum/callbacks.dart';

class TencentCloudChatSearchOptions {
  final String? userID;
  final String? groupID;
  final String? keyWord;
  final VoidCallback? closeFunc;

  // Constructor for TencentCloudChatSearchOptions.
  //
  // [userID]: The user ID for a one-to-one conversation.
  // [groupID]: The group ID for a group conversation.
  // [topicID]: The topicID for a topic, within a community group conversation.
  TencentCloudChatSearchOptions({
    this.keyWord,
    this.userID,
    this.groupID,
    this.closeFunc,
  });

  // Converts the TencentCloudChatSearchOptions object to a map.
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'groupID': groupID,
      'keyWord': keyWord,
      'closeFunc': closeFunc,
    };
  }

  // Creates a TencentCloudChatSearchOptions object from the given map.
  static TencentCloudChatSearchOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatSearchOptions(
      userID: map['userID'] as String?,
      groupID: map['groupID'] as String?,
      keyWord: map['keyWord'] as String?,
      closeFunc: map['closeFunc'] as VoidCallback?,
    );
  }
}
