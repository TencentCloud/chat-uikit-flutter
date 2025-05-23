import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_ui_group_search_msg.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_uikit_group_add_opt.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_uikit_group_detail_card.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_uikit_group_manage.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_uikit_group_member_title.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_uikit_group_message_disturb.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_uikit_group_name_card.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_uikit_group_notification.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_uikit_group_pin_conversation.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_uikit_group_type.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme.dart';

class TIMUIKitGroupProfileWidget {
  static Widget detailCard(
      {required V2TimGroupInfo groupInfo,
      bool isHavePermission = false,

      /// You can deal with updating group name manually, or UIKIt do it automatically.
      Function(String updateGroupName)? updateGroupName}) {
    return GroupProfileDetailCard(
      groupInfo: groupInfo,
      isHavePermission: isHavePermission,
      updateGroupName: updateGroupName,
    );
  }

  static Widget memberTile() {
    return GroupMemberTitle();
  }

  static Widget groupNotification({
    bool isHavePermission = false,
  }) {
    return GroupProfileNotification(
      isHavePermission: isHavePermission,
    );
  }

  static Widget groupManage() {
    return const GroupProfileGroupManage();
  }

  static Widget searchMessage(Function(V2TimConversation?) onJumpToSearch) {
    return GroupProfileGroupSearch(onJumpToSearch: onJumpToSearch);
  }

  static Widget operationDivider(TUITheme theme) {
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor() == DeviceType.Desktop;
    return Container(
      color: theme.weakDividerColor,
      height: isDesktopScreen ? 1 : 10,
    );
  }

  static Widget groupType() {
    return GroupProfileType();
  }

  static Widget groupAddOpt() {
    return GroupProfileAddOpt();
  }

  static Widget nameCard() {
    return const GroupProfileNameCard();
  }

  static Widget messageDisturb() {
    return GroupMessageDisturb();
  }

  static Widget pinedConversation() {
    return GroupPinConversation();
  }
}
