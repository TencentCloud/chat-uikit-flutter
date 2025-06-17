import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatGroupAddMemberOptions {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberList;
  final List<V2TimFriendInfo> contactList;

  TencentCloudChatGroupAddMemberOptions({required this.groupInfo, required this.memberList, required this.contactList});

  Map<String, dynamic> toMap() {
    return {
      'groupInfo': groupInfo.toString(),
      'memberInfoList': memberList.map((e) => e.toString()).toList(),
      'contactList': contactList.map((e) => e.toString()).toList()
    };
  }

  static TencentCloudChatGroupAddMemberOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatGroupAddMemberOptions(
        groupInfo: map['groupInfo'] as V2TimGroupInfo,
        memberList: map['memberInfoList'] as List<V2TimGroupMemberFullInfo>,
        contactList: map['contactList'] as List<V2TimFriendInfo>);
  }
}
