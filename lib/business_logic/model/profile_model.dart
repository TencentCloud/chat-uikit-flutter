import 'package:zhaopin/im/tencent_cloud_chat_uikit.dart';

class UserProfile {
  late V2TimFriendInfo? friendInfo;
  late V2TimConversation? conversation;

  UserProfile({required this.friendInfo, required this.conversation});
}
