// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_profile_userinfo_card/tim_uikit_profile_userinfo_card_narrow.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_profile_userinfo_card/tim_uikit_profile_userinfo_card_wide.dart';

class TIMUIKitProfileUserInfoCard extends StatelessWidget {
  /// User info
  final V2TimUserFullInfo? userInfo;
  final bool isJumpToPersonalProfile;
  final VoidCallback? onClickAvatar;

  /// If shows the arrow icon on the right
  final bool showArrowRightIcon;

  const TIMUIKitProfileUserInfoCard(
      {Key? key,
      this.userInfo,
      @Deprecated("This info card can no longer navigate to default personal profile page automatically, please deal with it manually.")
          this.isJumpToPersonalProfile = false,
      this.showArrowRightIcon = false,
      this.onClickAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TUIKitScreenUtils.getDeviceWidget(
      context: context,
      defaultWidget: TIMUIKitProfileUserInfoCardNarrow(
        userInfo: userInfo,
        isJumpToPersonalProfile: isJumpToPersonalProfile,
        showArrowRightIcon: showArrowRightIcon,
        onClickAvatar: onClickAvatar,
      ),
      desktopWidget: TIMUIKitProfileUserInfoCardWide(
        userInfo: userInfo,
        onClickAvatar: onClickAvatar,
        isJumpToPersonalProfile: isJumpToPersonalProfile,
        showArrowRightIcon: showArrowRightIcon,
      ),
      mobileWidget: TIMUIKitProfileUserInfoCardNarrow(
        userInfo: userInfo,
        onClickAvatar: onClickAvatar,
        isJumpToPersonalProfile: isJumpToPersonalProfile,
        showArrowRightIcon: showArrowRightIcon,
      ),
    );
  }
}
