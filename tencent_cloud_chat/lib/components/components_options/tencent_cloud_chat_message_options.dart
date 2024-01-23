class TencentCloudChatMessageOptions {
  final String? userID;
  final String? groupID;

  // Constructor for TencentCloudChatMessageOptions.
  //
  // [userID]: The user ID for a one-to-one conversation.
  // [groupID]: The group ID for a group conversation.
  TencentCloudChatMessageOptions({this.userID, this.groupID});

  // Converts the TencentCloudChatMessageOptions object to a map.
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'groupID': groupID,
    };
  }

  // Creates a TencentCloudChatMessageOptions object from the given map.
  static TencentCloudChatMessageOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatMessageOptions(
      userID: map['userID'] as String?,
      groupID: map['groupID'] as String?,
    );
  }
}
