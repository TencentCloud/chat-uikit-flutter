// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatGroupProfileOptions {
  final String groupID;
  final V2TimGroupInfo? groupInfo;
  final List<V2TimGroupMemberFullInfo> Function() getGroupMembersInfo;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;

  TencentCloudChatGroupProfileOptions({
    required this.groupID,
    this.groupInfo,
    required this.getGroupMembersInfo,
    this.startVoiceCall,
    this.startVideoCall,
  });

  Map<String, dynamic> toMap() {
    return {'groupID': groupID};
  }

  static TencentCloudChatGroupProfileOptions fromMap(Map<String, dynamic> map) {
    return TencentCloudChatGroupProfileOptions(
        groupID: map['groupID'] as String,
        getGroupMembersInfo: map['getGroupMembersInfo']
            as List<V2TimGroupMemberFullInfo> Function(),
        startVideoCall: map['startVideoCall'] as VoidCallback,
        startVoiceCall: map['startVoiceCall'] as VoidCallback);
  }
}
