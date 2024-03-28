import 'package:tencent_cloud_chat/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/data/theme/tencent_cloud_chat_theme.dart';
import 'package:tencent_cloud_chat/data/ui/tencent_cloud_chat_ui_data.dart';
import 'package:tencent_cloud_chat/data/user_profile/tencent_cloud_chat_user_profile_data.dart';

/// A class that manages the core data for TencentCloudChat.
///
/// This class provides access to various data classes for the Chat UIKit,
/// such as basic data, conversation data, message data, theme data,
/// group profile data, UI data, and user profile data.
class TencentCloudChatData {
  static TencentCloudChatTheme theme = TencentCloudChatTheme();
  static TencentCloudChatUIData ui = TencentCloudChatUIData(TencentCloudChatUIDataKeys.none);

  late TencentCloudChatBasicData basic;
  late TencentCloudChatConversationData conversation;
  late TencentCloudChatMessageData messageData;
  late TencentCloudChatGroupProfileData groupProfile;
  late TencentCloudChatUserProfileData user;
  late TencentCloudChatContactData contact;

  TencentCloudChatData() {
    basic = TencentCloudChatBasicData<TencentCloudChatBasicDataKeys>(TencentCloudChatBasicDataKeys.none);
    conversation = TencentCloudChatConversationData(TencentCloudChatConversationDataKeys.none);
    messageData = TencentCloudChatMessageData(TencentCloudChatMessageDataKeys.none);
    groupProfile = TencentCloudChatGroupProfileData(TencentCloudChatGroupProfileDataKeys.none);
    user = TencentCloudChatUserProfileData(TencentCloudChatUserProfileDataKeys.none);
    contact = TencentCloudChatContactData(TencentCloudChatContactDataKeys.none);
  }
}
