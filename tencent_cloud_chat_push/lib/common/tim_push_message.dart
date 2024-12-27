
import 'package:tencent_cloud_chat_push/common/utils.dart';

class TimPushMessage {
  late String? title;
  late String? desc;
  late String? ext;
  late String? messageID;
  TimPushMessage({
    this.title,
    this.desc,
    this.ext,
    this.messageID,
  });

  TimPushMessage.fromJson(Map json) {
    json = TencentCloudChatPushUtils.formatJson(json);
    title = json['title'];
    desc = json['desc'];
    ext = json['ext'];
    messageID = json["messageID"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['desc'] = desc;
    data['ext'] = ext;
    data["messageID"] = messageID ?? "";
    return data;
  }
  String toLogString() {
    var res = "|title:$title|desc:$desc|ext:$ext|messageID:$messageID";
    return res;
  }
}