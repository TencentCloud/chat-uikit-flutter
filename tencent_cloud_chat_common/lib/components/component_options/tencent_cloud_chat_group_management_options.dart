import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatGroupManagementOptions {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberInfoList;

  TencentCloudChatGroupManagementOptions({required this.groupInfo, required this.memberInfoList});

  Map<String, dynamic> toMap() {
    return {'groupInfo': groupInfo.toString(), 'memberInfoList': memberInfoList.map((e) => e.toString()).toList()};
  }

  static TencentCloudChatGroupManagementOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatGroupManagementOptions(
        groupInfo: map['groupInfo'] as V2TimGroupInfo,
        memberInfoList: map['memberInfoList'] as List<V2TimGroupMemberFullInfo>);
  }
}
