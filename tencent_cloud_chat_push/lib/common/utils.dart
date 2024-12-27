import 'dart:convert';

class ParseExtInfoResult {
  final String? userID;
  final String? groupID;

  ParseExtInfoResult({this.userID, this.groupID});
}

class TencentCloudChatPushUtils {
  /// Parses the given [ext] string to extract the userID and groupID.
  ///
  /// The [ext] string should be a JSON string with either of the following structures:
  ///
  /// 1. For a private chat: {"conversationID": "c2c_aaa"}, where "aaa" is the userID to be returned.
  ///    For a group chat: {"conversationID": "group_aaa"}, where "aaa" is the groupID to be returned.
  ///
  /// 2. {"entity": {
  ///        "action": 1,
  ///        "chatType": 1,
  ///        "content": "example content",
  ///        "faceUrl": "example face url",
  ///        "nickname": "example nickname",
  ///        "sendTime": 0,
  ///        "sender": "example sender",
  ///        "version": 1
  ///      }}
  ///    When chatType is 1, it's a private chat, and the userID is the value of the sender field.
  ///    When chatType is 2, it's a group chat, and the groupID is the value of the sender field.
  ///
  /// If the JSON parsing fails or the relevant information is not found,
  /// both userID and groupID will be returned as null.
  ///
  /// The function first attempts to parse the conversationID format JSON.
  /// If the parsing fails, it then attempts to parse the new JSON format.
  ///
  /// Returns a record containing the userID and groupID.
  static ParseExtInfoResult parseExtInfo(String ext) {
    String? userID;
    String? groupID;
    // ext = "{\"ext\":{\"entity\":{\"version\":1,\"action\":1,\"chatType\":1,\"sender\":\"@im_agent#online_shopping_mall\",\"nickname\":\"线上商城 Demo\"}}}";
    try {
      Map<String, dynamic> extJson = json.decode(ext);
      String? conversationID = extJson["conversationID"] as String?;

      if (conversationID != null) {
        RegExp c2cRegExp = RegExp(r'^c2c_(.*)');
        RegExp groupRegExp = RegExp(r'^group_(.*)');

        Match? c2cMatch = c2cRegExp.firstMatch(conversationID);
        Match? groupMatch = groupRegExp.firstMatch(conversationID);

        if (c2cMatch != null) {
          userID = c2cMatch.group(1);
        } else if (groupMatch != null) {
          groupID = groupMatch.group(1);
        }
      } else {
        Map<String, dynamic>? entity = extJson["entity"] as Map<String, dynamic>?;
        if (entity != null) {
          int? chatType = entity["chatType"] as int?;
          String? sender = entity["sender"] as String?;

          if (chatType != null && sender != null) {
            if (chatType == 1) {
              userID = sender;
            } else if (chatType == 2) {
              groupID = sender;
            }
          }
        }
      }
      // ignore: empty_catches
    } catch (e) {}

    return ParseExtInfoResult(
      userID: userID,
      groupID: groupID,
    );
  }

  static Map<String, dynamic> formatJson(Map? jsonSrc) {
    if (jsonSrc != null) {
      return Map<String, dynamic>.from(jsonSrc);
    }
    return Map<String, dynamic>.from({});
  }
}
