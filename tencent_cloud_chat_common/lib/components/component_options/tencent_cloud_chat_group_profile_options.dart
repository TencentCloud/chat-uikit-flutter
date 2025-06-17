// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatGroupProfileOptions {
  final String groupID;
  final V2TimGroupInfo? groupInfo;

  TencentCloudChatGroupProfileOptions({
    required this.groupID,
    this.groupInfo,
  });

  Map<String, dynamic> toMap() {
    return {'groupID': groupID};
  }

  static TencentCloudChatGroupProfileOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatGroupProfileOptions(
        groupID: map['groupID'] as String,);
  }
}
