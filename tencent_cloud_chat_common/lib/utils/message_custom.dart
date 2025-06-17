import 'package:tencent_cloud_chat_sdk/utils/utils.dart';

class MessageCustom {
  static String businessIDGroupCreate = "group_create";
  static int groupCreateVersion = 4; // Android/iOS/Web interoperable version for video call

  late int version;
  late String businessID;
  late String opUser;
  late String content;
  late int cmd;

  MessageCustom({
    required this.version,
    required this.businessID,
    required this.opUser,
    required this.content,
    required this.cmd,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'businessID': businessID,
      'opUser': opUser,
      'content': content,
      'cmd': cmd,
    };
  }

  MessageCustom.fromJson(Map json) {
    json = Utils.formatJson(json);
    version = json['version'];
    businessID = json['businessID'];
    opUser = json['opUser'];
    content = json['content'];
    cmd = json['cmd'];
  }

}