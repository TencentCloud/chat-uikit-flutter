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
  TencentCloudChatBasicData get basic =>
      TencentCloudChatBasicData<TencentCloudChatBasicDataKeys>(
          TencentCloudChatBasicDataKeys.none);

  TencentCloudChatConversationData get conversation =>
      TencentCloudChatConversationData(
          TencentCloudChatConversationDataKeys.none);

  TencentCloudChatMessageData get messageData =>
      TencentCloudChatMessageData(TencentCloudChatMessageDataKeys.none);

  TencentCloudChatTheme get theme => TencentCloudChatTheme();

  TencentCloudChatGroupProfileData get groupProfile =>
      TencentCloudChatGroupProfileData(
          TencentCloudChatGroupProfileDataKeys.none);

  TencentCloudChatUIData get ui =>
      TencentCloudChatUIData(TencentCloudChatUIDataKeys.none);

  TencentCloudChatUserProfileData get user =>
      TencentCloudChatUserProfileData(TencentCloudChatUserProfileDataKeys.none);

  TencentCloudChatContactData get contact =>
      TencentCloudChatContactData(TencentCloudChatContactDataKeys.none);
}
