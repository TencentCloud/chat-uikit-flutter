import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatGroupMemberInfoOptions {
  final V2TimGroupMemberFullInfo memberFullInfo;

  TencentCloudChatGroupMemberInfoOptions({required this.memberFullInfo});

  Map<String, dynamic> toMap() {
    return {'memberFullInfo': memberFullInfo.toString()};
  }

  static TencentCloudChatGroupMemberInfoOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatGroupMemberInfoOptions(
        memberFullInfo: map['memberFullInfo'] as V2TimGroupMemberFullInfo);
  }
}