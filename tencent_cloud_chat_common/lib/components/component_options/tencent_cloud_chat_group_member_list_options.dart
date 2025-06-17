import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatGroupMemberListOptions {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberInfoList;

  TencentCloudChatGroupMemberListOptions({required this.groupInfo, required this.memberInfoList});

  Map<String, dynamic> toMap() {
    return {'groupInfo': groupInfo.toString(), 'memberInfoList': memberInfoList.map((e) => e.toString()).toList()};
  }

  static TencentCloudChatGroupMemberListOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatGroupMemberListOptions(
        groupInfo: map['groupInfo'] as V2TimGroupInfo,
        memberInfoList: map['memberInfoList'] as List<V2TimGroupMemberFullInfo>);
  }
}