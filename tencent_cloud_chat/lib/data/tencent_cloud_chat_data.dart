import 'package:tencent_cloud_chat/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/data/search/tencent_cloud_chat_search_data.dart';
import 'package:tencent_cloud_chat/data/theme/tencent_cloud_chat_theme.dart';
import 'package:tencent_cloud_chat/data/user_profile/tencent_cloud_chat_user_profile_data.dart';

class TencentCloudChatDataManager {
  static TencentCloudChatData? instance;

  static TencentCloudChatData getInstance() {
    instance ??= TencentCloudChatData._();
    return instance!;
  }

  static void resetInstance() {
    instance = null;
  }
}

/// A class that manages the core data for TencentCloudChat .
///
/// This class provides access to various data classes for the Chat UIKit,
/// such as basic data, conversation data, message data, theme data,
/// group profile data, and user profile data.
class TencentCloudChatData {
  TencentCloudChatData._();

  final TencentCloudChatTheme theme = TencentCloudChatTheme();
  final TencentCloudChatBasicData basic =
      TencentCloudChatBasicData<TencentCloudChatBasicDataKeys>(TencentCloudChatBasicDataKeys.none);
  final TencentCloudChatConversationData conversation =
      TencentCloudChatConversationData(TencentCloudChatConversationDataKeys.none);
  final TencentCloudChatMessageData messageData = TencentCloudChatMessageData(TencentCloudChatMessageDataKeys.none);
  final TencentCloudChatGroupProfileData groupProfile =
      TencentCloudChatGroupProfileData(TencentCloudChatGroupProfileDataKeys.none);
  final TencentCloudChatUserProfileData userProfile =
      TencentCloudChatUserProfileData(TencentCloudChatUserProfileDataKeys.none);
  final TencentCloudChatContactData contact = TencentCloudChatContactData(TencentCloudChatContactDataKeys.none);
  final TencentCloudChatSearchData search = TencentCloudChatSearchData(TencentCloudChatSearchDataKeys.none);
}
