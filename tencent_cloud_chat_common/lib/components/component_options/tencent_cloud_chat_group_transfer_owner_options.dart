import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatGroupTransferOwnerOptions {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberList;

  TencentCloudChatGroupTransferOwnerOptions({required this.groupInfo, required this.memberList});

  Map<String, dynamic> toMap() {
    return {
      'groupInfo': groupInfo.toString(),
      'memberInfoList': memberList.map((e) => e.toString()).toList(),
    };
  }

  static TencentCloudChatGroupTransferOwnerOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatGroupTransferOwnerOptions(
        groupInfo: map['groupInfo'] as V2TimGroupInfo,
        memberList: map['memberInfoList'] as List<V2TimGroupMemberFullInfo>);
  }
}
