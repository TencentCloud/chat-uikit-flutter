library tencent_cloud_chat_uikit;

import 'package:tencent_im_base/tencent_im_base.dart';

import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'data_services/core/core_services_implements.dart';
export 'data_services/core/core_services_implements.dart';
export 'package:tencent_im_base/theme/tui_theme.dart';
export 'package:tencent_im_base/theme/color.dart';

// Sticker
export 'package:tim_ui_kit_sticker_plugin/tim_ui_kit_sticker_plugin.dart';

// Widgets
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_chat.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/tim_uikit_profile.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_operation_item.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitContact/tim_uikit_contact.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroup/tim_uikit_group.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitBlackList/tim_uikit_black_list.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitNewContact/tim_uikit_new_contact.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitNewContact/tim_uikit_unread_count.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/tim_uikit_group_profile.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list_item.dart';
export 'package:tencent_cloud_chat_uikit/ui/widgets/unread_message.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitAddFriend/tim_uikit_add_friend.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitAddGroup/tim_uikit_add_group.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_more_panel.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/tim_uikit_search.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/tim_uikit_search_msg_detail.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field_controller.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitAppBar/tim_uikit_appbar.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroup/tim_uikit_group_application_list.dart';
export 'package:tencent_im_base/tencent_im_base.dart';
export 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/models/link_preview_content.dart';
export 'package:tencent_cloud_chat_uikit/ui/widgets/column_menu.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_profile_userinfo_card/tim_uikit_profile_userinfo_card.dart';
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_ui_kit_conversation_total_unread.dart';

// Enum
export 'package:tencent_cloud_chat_uikit/ui/theme/tim_uikit_message_theme.dart';

// Controller
export 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_profile_controller.dart';

// Config
export 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_chat_config.dart';
export 'package:permission_handler/permission_handler.dart';

// Utils
export 'package:tencent_cloud_chat_uikit/ui/utils/common_utils.dart';
export 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';

class TIMUIKitCore {
  static CoreServicesImpl getInstance() {
    setupServiceLocator();
    return serviceLocator<CoreServicesImpl>();
  }

  static V2TIMManager getSDKInstance() {
    return TencentImSDKPlugin.v2TIMManager;
  }
}
