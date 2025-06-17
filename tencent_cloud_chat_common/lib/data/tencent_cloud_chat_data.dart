import 'package:tencent_cloud_chat_common/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat_common/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/data/search/tencent_cloud_chat_search_data.dart';
import 'package:tencent_cloud_chat_common/data/theme/tencent_cloud_chat_theme.dart';

/// A class that manages the core data for TencentCloudChat .
///
/// This class provides access to various data classes for the Chat UIKit,
/// such as basic data, conversation data, message data, theme data,
/// group profile data, and user profile data.
class TencentCloudChatData {
  static TencentCloudChatData? _instance;
  static TencentCloudChatData getInstance() {
    _instance ??= TencentCloudChatData._internal();

    return _instance!;
  }

  TencentCloudChatData._internal();

  final TencentCloudChatTheme theme = TencentCloudChatTheme();
  final TencentCloudChatBasicData basic =
      TencentCloudChatBasicData<TencentCloudChatBasicDataKeys>(TencentCloudChatBasicDataKeys.none);
  final TencentCloudChatConversationData conversation =
      TencentCloudChatConversationData(TencentCloudChatConversationDataKeys.none);
  final TencentCloudChatMessageData messageData = TencentCloudChatMessageData(TencentCloudChatMessageDataKeys.none);
  final TencentCloudChatGroupProfileData groupProfile =
      TencentCloudChatGroupProfileData(TencentCloudChatGroupProfileDataKeys.none);
  final TencentCloudChatContactData contact = TencentCloudChatContactData(TencentCloudChatContactDataKeys.none);
  final TencentCloudChatSearchData search = TencentCloudChatSearchData(TencentCloudChatSearchDataKeys.none);
}
