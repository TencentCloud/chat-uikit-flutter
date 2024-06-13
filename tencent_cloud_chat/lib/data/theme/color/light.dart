import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';

class LightTencentCloudChatColors extends TencentCloudChatThemeColors {
  LightTencentCloudChatColors({
    Color? primaryColor,
    Color? secondaryColor,
    Color? primaryTextColor,
    Color? backgroundColor,
    Color? onPrimary,
    Color? onSecondary,
    Color? onError,
    Color? surface,
    Color? onSurface,
    Color? onBackground,
    Color? error,
    Color? appBarBackgroundColor,
    Color? appBarIconColor,
    Color? dividerColor,
    Color? firstButtonColor,
    Color? info,
    Color? inputAreaIconColor,
    Color? inputAreaBackground,
    Color? inputFieldBorderColor,
    Color? messageStatusIconColor,
    Color? othersMessageBubbleBorderColor,
    Color? othersMessageBubbleColor,
    Color? othersMessageTextColor,
    Color? secondButtonColor,
    Color? secondaryTextColor,
    Color? selfMessageBubbleBorderColor,
    Color? selfMessageBubbleColor,
    Color? selfMessageTextColor,
    Color? switchActivatedColor,
    Color? tipsColor,
    Color? messageTipsBackgroundColor,
    Color? messageBeenChosenBackgroundColor,
    // The color value used by the conversation component
    Color? conversationItemLastMessageColor, // 待废弃
    Color? conversationItemTitleColor, // 待废弃
    Color? conversationItemSwipeActionOneBgColor,
    Color? conversationItemSwipeActionTwoBgColor,
    Color? conversationItemSwipeActionOneTextColor,
    Color? conversationItemSwipeActionTwoTextColor,
    Color? conversationItemIsPinedBgColor,
    Color? conversationItemNormalBgColor,
    Color? conversationItemShowNameTextColor,
    Color? conversationItemSendingIconColor,
    Color? conversationItemSendFailedIconColor,
    Color? conversationItemDraftTextColor,
    Color? conversationItemLastMessageTextColor,
    Color? conversationItemGroupAtInfoTextColor,
    Color? conversationItemNoReceiveIconColor,
    Color? conversationItemUnreadCountBgColor,
    Color? conversationItemUnreadCountTextColor,
    Color? conversationItemTimeTextColor,
    Color? conversationItemUnreadIconColor,
    Color? conversationItemReadIconColor,
    Color? conversationNoConversationTextColor,
    Color? conversationItemMoreActionItemNormalTextColor,
    Color? conversationItemMoreActionItemDeleteTextColor,
    Color? conversationItemUserStatusBgColor,
    // The color value used by the contact component
    Color? contactItemFriendNameColor,
    Color? contactItemTabItemNameColor,
    Color? contactApplicationBackgroundColor,
    Color? contactItemTabItemBorderColor,
    Color? contactTabItemBackgroundColor,
    Color? contactTabItemIconColor,
    Color? contactApplicationUnreadCountTextColor,
    Color? contactBackgroundColor,
    Color? contactBackButtonColor,
    Color? contactNoListColor,
    Color? contactAgreeButtonColor,
    Color? contactRefuseButtonColor,
    Color? contactAppBarIconColor,
    Color? contactAddContactBackgroundColor,
    Color? contactAddContactInfoBackgroundColor,
    Color? contactAddContactFriendInfoButtonShadowColor,
    Color? contactAddContactFriendInfoStateButtonBackgroundColor,
    Color? contactAddContactFriendInfoStateButtonTextColor,
    Color? contactAddContactFriendInfoStateButtonActiveColor,
    Color? contactAddContactFriendInfoStateButtonInactiveColor,
    Color? contactAddContactToastCheckColor,
    Color? contactAddContactToastRefuseColor,
    Color? contactSearchBackgroundColor,
    Color? contactSearchCursorColor,
    Color? contactSearchButtonColor,
    //setting
    Color? settingBackgroundColor,
    Color? settingTabBackgroundColor,
    Color? settingTitleColor,
    Color? settingTabTitleColor,
    Color? settingLogoutColor,
    Color? settingInfoEditColor,
    Color? settingAboutBorderColor,
    Color? settingInfoBackgroundColor,
    //login
    Color? loginBackgroundColor,
    Color? loginButtonDisableColor,
    Color? loginCardBackground,
    Color? profileChatButtonBackground,
    Color? profileChatButtonBoxShadow,
    Color? groupProfileTabBackground,
    Color? groupProfileTabTextColor,
    Color? groupProfileTextColor,
    Color? groupProfileAddMemberTextColor,
    Color? groupProfileTabBorderColor,
    Color? desktopBackgroundColorLinearGradientOne,
    Color? desktopBackgroundColorLinearGradientTwo,
    // end
  })  : _primaryColor = primaryColor ?? const Color(0xFF147AFF),
        _secondaryColor = secondaryColor ?? const Color(0xFF108EE9),
        _primaryTextColor = primaryTextColor ?? const Color(0xFF222222),
        _backgroundColor = backgroundColor ?? const Color(0xFFFFFFFF),
        _onPrimary = onPrimary ?? Colors.white,
        _onSecondary = onSecondary ?? Colors.white,
        _onError = onError ?? Colors.black,
        _surface = surface ?? const Color(0xFFF1F0F0),
        _onSurface = onSurface ?? const Color(0xFF222222),
        _onBackground = onBackground ?? const Color(0xFF222222),
        _error = error ?? const Color(0xFFD32F2F),
        _appBarBackgroundColor = appBarBackgroundColor ?? const Color(0xFFFFFFFF),
        _appBarIconColor = appBarIconColor ?? Colors.black,
        _dividerColor = dividerColor ?? const Color(0xFFE0E0E0),
        _firstButtonColor = firstButtonColor ?? const Color(0xFF0365F9),
        _info = info ?? const Color(0xFFFF3742),
        _inputAreaBackground = inputAreaBackground ?? const Color(0xFFF9F9F9),
        _inputAreaIconColor = inputAreaIconColor ?? const Color(0xFF000000),
        _inputFieldBorderColor = inputFieldBorderColor ?? const Color(0xFFD3DAF3),
        _messageStatusIconColor = messageStatusIconColor ?? const Color(0xFF0365F9),
        _othersMessageBubbleBorderColor = othersMessageBubbleBorderColor ?? const Color(0xFFECEBEB),
        _othersMessageBubbleColor = othersMessageBubbleColor ?? const Color(0xFFFFFFFF),
        _othersMessageTextColor = othersMessageTextColor ?? const Color(0xFF222222),
        _secondButtonColor = secondButtonColor ?? const Color(0xFF4CAF50),
        _secondaryTextColor = secondaryTextColor ?? const Color(0xFF666666),
        _selfMessageBubbleBorderColor = selfMessageBubbleBorderColor ?? const Color(0xFFECEBEB),
        _selfMessageBubbleColor = selfMessageBubbleColor ?? const Color(0xFFECEBEB),
        _selfMessageTextColor = selfMessageTextColor ?? const Color(0xFF222222),
        _switchActivatedColor = switchActivatedColor ?? const Color(0xFF0365F9),
        _tipsColor = tipsColor ?? const Color(0xFFFF3742),
        _messageTipsBackgroundColor = messageTipsBackgroundColor ?? const Color(0xFFECEBEB),
        _messageBeenChosenBackgroundColor = messageBeenChosenBackgroundColor ?? const Color(0xFFF3F3F3),

        // The color value used by the conversation component
        _conversationItemLastMessageColor =
            conversationItemLastMessageColor ?? secondaryTextColor ?? const Color(0xFF7A7A7A),
        _conversationItemTitleColor = conversationItemTitleColor ?? const Color(0xFF000000),
        _conversationItemSwipeActionOneBgColor =
            conversationItemSwipeActionOneBgColor ?? firstButtonColor ?? const Color(0xFF0365F9),
        _conversationItemSwipeActionTwoBgColor =
            conversationItemSwipeActionTwoBgColor ?? secondButtonColor ?? const Color(0xFF000000),
        _conversationItemSwipeActionOneTextColor =
            conversationItemSwipeActionOneTextColor ?? backgroundColor ?? const Color(0xFFFFFFFF),
        _conversationItemSwipeActionTwoTextColor =
            conversationItemSwipeActionTwoTextColor ?? backgroundColor ?? const Color(0xFFFFFFFF),
        _conversationItemIsPinedBgColor = conversationItemIsPinedBgColor ?? dividerColor ?? const Color(0xFFE0E0E0),
        _conversationItemNormalBgColor = conversationItemNormalBgColor ?? backgroundColor ?? const Color(0xFFFFFFFF),
        _conversationItemShowNameTextColor =
            conversationItemShowNameTextColor ?? backgroundColor ?? const Color(0xFF121212),
        _conversationItemSendingIconColor = conversationItemSendingIconColor ?? primaryColor ?? const Color(0xFF147AFF),
        _conversationItemSendFailedIconColor =
            conversationItemSendFailedIconColor ?? tipsColor ?? const Color(0xFFFF3742),
        _conversationItemDraftTextColor = conversationItemDraftTextColor ?? tipsColor ?? const Color(0xFFFF3742),
        _conversationItemLastMessageTextColor =
            conversationItemLastMessageTextColor ?? secondaryTextColor ?? const Color(0xFF7A7A7A),
        _conversationItemGroupAtInfoTextColor =
            conversationItemGroupAtInfoTextColor ?? tipsColor ?? const Color(0xFFFF3742),
        _conversationItemNoReceiveIconColor =
            conversationItemNoReceiveIconColor ?? secondaryTextColor ?? const Color(0xFF7A7A7A),
        _conversationItemUnreadCountBgColor =
            conversationItemUnreadCountBgColor ?? tipsColor ?? const Color(0xFFFF3742),
        _conversationItemUnreadCountTextColor =
            conversationItemUnreadCountTextColor ?? backgroundColor ?? const Color(0xFFF1F0F0),
        _conversationItemTimeTextColor = conversationItemTimeTextColor ?? secondaryTextColor ?? const Color(0xFF7A7A7A),
        _conversationItemUnreadIconColor =
            conversationItemUnreadIconColor ?? secondaryTextColor ?? const Color(0xFF666666),
        _conversationItemReadIconColor = conversationItemReadIconColor ?? secondButtonColor ?? const Color(0xFF4CAF50),
        _conversationNoConversationTextColor =
            conversationNoConversationTextColor ?? secondaryTextColor ?? const Color(0xFF7A7A7A),
        _conversationItemMoreActionItemNormalTextColor =
            conversationItemMoreActionItemNormalTextColor ?? primaryColor ?? const Color(0xFF147AFF),
        _conversationItemMoreActionItemDeleteTextColor =
            conversationItemMoreActionItemDeleteTextColor ?? tipsColor ?? const Color(0xFFFF3742),
        _conversationItemUserStatusBgColor = conversationItemUserStatusBgColor ?? const Color(0XFF20E070),
        // end
        // contact color start
        _contactItemFriendNameColor = contactItemFriendNameColor ?? const Color(0xFF000000),
        _contactItemTabItemNameColor = contactItemTabItemNameColor ?? const Color(0x99000000),
        _contactApplicationBackgroundColor = contactApplicationBackgroundColor ?? const Color(0xFFF1F1F1),
        _contactItemTabItemBorderColor = contactItemTabItemBorderColor ?? const Color(0x0D000000),
        _contactTabItemBackgroundColor = contactTabItemBackgroundColor ?? const Color(0xFFF9F9F9),
        _contactTabItemIconColor = contactTabItemIconColor ?? const Color(0xFFD9D9D9),
        _contactApplicationUnreadCountTextColor = contactApplicationUnreadCountTextColor ?? const Color(0xFFFFFFFF),
        _contactBackgroundColor = contactBackgroundColor ?? const Color(0xFFFFFFFF),
        _contactBackButtonColor = contactBackButtonColor ?? const Color(0xFF0365F9),
        _contactNoListColor = contactNoListColor ?? const Color(0xFF666666),
        _contactAgreeButtonColor = contactAgreeButtonColor ?? const Color(0xFF1890FF),
        _contactRefuseButtonColor = contactRefuseButtonColor ?? const Color(0xFFCE3125),
        _contactAppBarIconColor = contactAppBarIconColor ?? const Color(0xFF0365F9),
        _contactAddContactBackgroundColor = contactAddContactBackgroundColor ?? const Color(0xE6F2F2F2),
        _contactAddContactInfoBackgroundColor = contactAddContactInfoBackgroundColor ?? const Color(0xE6E5E5EA),
        _contactAddContactFriendInfoButtonShadowColor =
            contactAddContactFriendInfoButtonShadowColor ?? const Color(0x40FFFFFF),
        _contactAddContactFriendInfoStateButtonBackgroundColor =
            contactAddContactFriendInfoStateButtonBackgroundColor ?? const Color(0xF2F9F9F9),
        _contactAddContactFriendInfoStateButtonTextColor =
            contactAddContactFriendInfoStateButtonTextColor ?? const Color(0x99000000),
        _contactAddContactFriendInfoStateButtonActiveColor =
            contactAddContactFriendInfoStateButtonActiveColor ?? const Color(0xFF34C759),
        _contactAddContactFriendInfoStateButtonInactiveColor =
            contactAddContactFriendInfoStateButtonInactiveColor ?? const Color(0xFFDDDDE0),
        _contactAddContactToastCheckColor = contactAddContactToastCheckColor ?? const Color(0xFF49935A),
        _contactAddContactToastRefuseColor = contactAddContactToastRefuseColor ?? const Color(0xFFCE3125),
        _contactSearchBackgroundColor = contactSearchBackgroundColor ?? const Color(0xFFEDEDED),
        _contactSearchCursorColor = contactSearchCursorColor ?? const Color(0xFF07C160),
        _contactSearchButtonColor = contactSearchButtonColor ?? const Color(0xFF576B95),
        // setting colors
        _settingBackgroundColor = settingBackgroundColor ?? const Color(0xFFFFFFFF),
        _settingTabBackgroundColor = settingTabBackgroundColor ?? const Color(0xF2F9F9F9),
        _settingTitleColor = settingTitleColor ?? const Color(0xFF000000),
        _settingTabTitleColor = settingTabTitleColor ?? const Color(0x99000000),
        _settingLogoutColor = settingLogoutColor ?? const Color(0xFFCE3125),
        _settingInfoEditColor = settingInfoEditColor ?? const Color(0xFF0365F9),
        _settingAboutBorderColor = settingAboutBorderColor ?? const Color(0x1A000000),
        _settingInfoBackgroundColor = settingInfoBackgroundColor ?? const Color(0xFFF1F1F1),
        //login
        _loginBackgroundColor = loginBackgroundColor ?? const Color(0xFF0078D7),
        _loginButtonDisableColor = loginButtonDisableColor ?? Colors.grey,
        _loginCardBackground = loginCardBackground ?? const Color(0xE6FFFFFF),
        _profileChatButtonBackground = profileChatButtonBackground ?? const Color(0xFFFFFFFF),
        _profileChatButtonBoxShadow = profileChatButtonBoxShadow ?? const Color(0x40000000),
        _groupProfileTabBackground = groupProfileTabBackground ?? const Color(0xFFF9F9F9),
        _groupProfileTabTextColor = groupProfileTabTextColor ?? const Color(0x99000000),
        _groupProfileTextColor = groupProfileTextColor ?? const Color(0xFF000000),
        _groupProfileAddMemberTextColor = groupProfileAddMemberTextColor ?? const Color(0xFF0365F9),
        _groupProfileTabBorderColor = groupProfileTabBorderColor ?? const Color(0xFFE0E0E0),
        _desktopBackgroundColorLinearGradientOne = desktopBackgroundColorLinearGradientOne ?? const Color(0xFFEAEBEE),
        _desktopBackgroundColorLinearGradientTwo = desktopBackgroundColorLinearGradientTwo ?? const Color(0xFFF6F6F6)
  // end
  ;

  final Color _primaryColor;
  final Color _secondaryColor;
  final Color _primaryTextColor;
  final Color _backgroundColor;
  final Color _onPrimary;
  final Color _onSecondary;
  final Color _onError;
  final Color _surface;
  final Color _onSurface;
  final Color _onBackground;
  final Color _error;
  final Color _appBarBackgroundColor;
  final Color _appBarIconColor;
  final Color _dividerColor;
  final Color _firstButtonColor;
  final Color _info;
  final Color _inputAreaBackground;
  final Color _inputAreaIconColor;
  final Color _inputFieldBorderColor;
  final Color _messageStatusIconColor;
  final Color _othersMessageBubbleBorderColor;
  final Color _othersMessageBubbleColor;
  final Color _othersMessageTextColor;
  final Color _secondButtonColor;
  final Color _secondaryTextColor;
  final Color _selfMessageBubbleBorderColor;
  final Color _selfMessageBubbleColor;
  final Color _selfMessageTextColor;
  final Color _switchActivatedColor;
  final Color _tipsColor;

  final Color _messageTipsBackgroundColor;

  final Color _messageBeenChosenBackgroundColor;

  // The color value used by the conversation component
  final Color _conversationItemLastMessageColor; // 待废弃
  final Color _conversationItemTitleColor; // 待废弃
  final Color _conversationItemSwipeActionOneBgColor;
  final Color _conversationItemSwipeActionTwoBgColor;
  final Color _conversationItemSwipeActionOneTextColor;
  final Color _conversationItemSwipeActionTwoTextColor;
  final Color _conversationItemIsPinedBgColor;
  final Color _conversationItemNormalBgColor;
  final Color _conversationItemShowNameTextColor;
  final Color _conversationItemSendingIconColor;
  final Color _conversationItemSendFailedIconColor;
  final Color _conversationItemDraftTextColor;
  final Color _conversationItemLastMessageTextColor;
  final Color _conversationItemGroupAtInfoTextColor;
  final Color _conversationItemNoReceiveIconColor;
  final Color _conversationItemUnreadCountBgColor;
  final Color _conversationItemUnreadCountTextColor;
  final Color _conversationItemTimeTextColor;
  final Color _conversationItemUnreadIconColor;
  final Color _conversationItemReadIconColor;
  final Color _conversationItemMoreActionItemNormalTextColor;
  final Color _conversationItemMoreActionItemDeleteTextColor;
  final Color _conversationNoConversationTextColor;
  final Color _conversationItemUserStatusBgColor;

  // The color value used by the contact component
  final Color _contactItemFriendNameColor;
  final Color _contactItemTabItemNameColor;
  final Color _contactApplicationBackgroundColor;
  final Color _contactItemTabItemBorderColor;
  final Color _contactTabItemBackgroundColor;
  final Color _contactTabItemIconColor;
  final Color _contactApplicationUnreadCountTextColor;
  final Color _contactBackgroundColor;
  final Color _contactBackButtonColor;
  final Color _contactNoListColor;
  final Color _contactAgreeButtonColor;
  final Color _contactRefuseButtonColor;
  final Color _contactAppBarIconColor;
  final Color _contactAddContactBackgroundColor;
  final Color _contactAddContactInfoBackgroundColor;
  final Color _contactAddContactFriendInfoButtonShadowColor;
  final Color _contactAddContactFriendInfoStateButtonBackgroundColor;
  final Color _contactAddContactFriendInfoStateButtonTextColor;
  final Color _contactAddContactFriendInfoStateButtonActiveColor;
  final Color _contactAddContactFriendInfoStateButtonInactiveColor;
  final Color _contactAddContactToastCheckColor;
  final Color _contactAddContactToastRefuseColor;
  final Color _contactSearchBackgroundColor;
  final Color _contactSearchCursorColor;
  final Color _contactSearchButtonColor;

  final Color _settingBackgroundColor;
  final Color _settingTabBackgroundColor;
  final Color _settingTitleColor;
  final Color _settingTabTitleColor;
  final Color _settingLogoutColor;
  final Color _settingInfoEditColor;
  final Color _settingAboutBorderColor;
  final Color _settingInfoBackgroundColor;
  final Color _loginBackgroundColor;
  final Color _loginButtonDisableColor;
  final Color _loginCardBackground;
  final Color _profileChatButtonBackground;
  final Color _profileChatButtonBoxShadow;
  final Color _groupProfileTabBackground;
  final Color _groupProfileTabTextColor;
  final Color _groupProfileTextColor;
  final Color _groupProfileAddMemberTextColor;
  final Color _groupProfileTabBorderColor;

  final Color _desktopBackgroundColorLinearGradientOne;
  final Color _desktopBackgroundColorLinearGradientTwo;

  // end

  @override
  Color get primaryColor => _primaryColor;

  @override
  Color get secondaryColor => _secondaryColor;

  @override
  Color get primaryTextColor => _primaryTextColor;

  @override
  Color get backgroundColor => _backgroundColor;

  @override
  Color get onPrimary => _onPrimary;

  @override
  Color get onSecondary => _onSecondary;

  @override
  Color get onError => _onError;

  @override
  Color get surface => _surface;

  @override
  Color get onSurface => _onSurface;

  @override
  Color get onBackground => _onBackground;

  @override
  Color get error => _error;

  @override
  Color get appBarBackgroundColor => _appBarBackgroundColor;

  @override
  Color get appBarIconColor => _appBarIconColor;

  @override
  Color get dividerColor => _dividerColor;

  @override
  Color get firstButtonColor => _firstButtonColor;

  @override
  Color get info => _info;

  @override
  Color get inputAreaBackground => _inputAreaBackground;

  @override
  Color get inputAreaIconColor => _inputAreaIconColor;

  @override
  Color get inputFieldBorderColor => _inputFieldBorderColor;

  @override
  Color get messageStatusIconColor => _messageStatusIconColor;

  @override
  Color get othersMessageBubbleBorderColor => _othersMessageBubbleBorderColor;

  @override
  Color get othersMessageBubbleColor => _othersMessageBubbleColor;

  @override
  Color get othersMessageTextColor => _othersMessageTextColor;

  @override
  Color get secondButtonColor => _secondButtonColor;

  @override
  Color get secondaryTextColor => _secondaryTextColor;

  @override
  Color get selfMessageBubbleBorderColor => _selfMessageBubbleBorderColor;

  @override
  Color get selfMessageBubbleColor => _selfMessageBubbleColor;

  @override
  Color get selfMessageTextColor => _selfMessageTextColor;

  @override
  Color get switchActivatedColor => _switchActivatedColor;

  @override
  Color get tipsColor => _tipsColor;

  @override
  Color get conversationItemLastMessageColor => _conversationItemLastMessageColor;

  @override
  Color get messageTipsBackgroundColor => _messageTipsBackgroundColor;

  // The color value used by the convergestion component
  @override
  Color get conversationItemTitleColor => _conversationItemTitleColor; // 待废弃

  @override
  Color get conversationItemSwipeActionOneBgColor => _conversationItemSwipeActionOneBgColor;

  @override
  Color get conversationItemSwipeActionTwoBgColor => _conversationItemSwipeActionTwoBgColor;

  @override
  Color get conversationItemSwipeActionOneTextColor => _conversationItemSwipeActionOneTextColor;

  @override
  Color get conversationItemSwipeActionTwoTextColor => _conversationItemSwipeActionTwoTextColor;

  @override
  Color get conversationItemIsPinedBgColor => _conversationItemIsPinedBgColor;

  @override
  Color get conversationItemNormalBgColor => _conversationItemNormalBgColor;

  @override
  Color get conversationItemShowNameTextColor => _conversationItemShowNameTextColor;

  @override
  Color get conversationItemSendingIconColor => _conversationItemSendingIconColor;

  @override
  Color get conversationItemSendFailedIconColor => _conversationItemSendFailedIconColor;

  @override
  Color get conversationItemDraftTextColor => _conversationItemDraftTextColor;

  @override
  Color get conversationItemLastMessageTextColor => _conversationItemLastMessageTextColor;

  @override
  Color get conversationItemGroupAtInfoTextColor => _conversationItemGroupAtInfoTextColor;

  @override
  Color get conversationItemNoReceiveIconColor => _conversationItemNoReceiveIconColor;

  @override
  Color get conversationItemUnreadCountBgColor => _conversationItemUnreadCountBgColor;

  @override
  Color get conversationItemUnreadCountTextColor => _conversationItemUnreadCountTextColor;

  @override
  Color get conversationItemTimeTextColor => _conversationItemTimeTextColor;

  @override
  Color get conversationItemUnreadIconColor => _conversationItemUnreadIconColor;

  @override
  Color get conversationItemReadIconColor => _conversationItemReadIconColor;

  @override
  Color get conversationNoConversationTextColor => _conversationNoConversationTextColor;

  @override
  Color get conversationItemMoreActionItemNormalTextColor => _conversationItemMoreActionItemNormalTextColor;

  @override
  Color get conversationItemMoreActionItemDeleteTextColor => _conversationItemMoreActionItemDeleteTextColor;

  @override
  Color get conversationItemUserStatusBgColor => _conversationItemUserStatusBgColor;

  @override
  Color get messageBeenChosenBackgroundColor => _messageBeenChosenBackgroundColor;

  @override
  Color get contactItemTabItemNameColor => _contactItemTabItemNameColor;

  @override
  Color get contactItemFriendNameColor => _contactItemFriendNameColor;

  @override
  Color get contactApplicationBackgroundColor => _contactApplicationBackgroundColor;

  @override
  Color get contactItemTabItemBorderColor => _contactItemTabItemBorderColor;

  @override
  Color get contactTabItemBackgroundColor => _contactTabItemBackgroundColor;

  @override
  Color get contactTabItemIconColor => _contactTabItemIconColor;

  @override
  Color get contactApplicationUnreadCountTextColor => _contactApplicationUnreadCountTextColor;

  @override
  Color get contactBackgroundColor => _contactBackgroundColor;

  @override
  Color get contactBackButtonColor => _contactBackButtonColor;

  @override
  Color get contactNoListColor => _contactNoListColor;

  @override
  Color get contactAgreeButtonColor => _contactAgreeButtonColor;

  @override
  Color get contactRefuseButtonColor => _contactRefuseButtonColor;

  @override
  Color get contactAppBarIconColor => _contactAppBarIconColor;

  @override
  Color get contactAddContactBackgroundColor => _contactAddContactBackgroundColor;

  @override
  Color get contactAddContactInfoBackgroundColor => _contactAddContactInfoBackgroundColor;

  @override
  Color get contactAddContactFriendInfoButtonShadowColor => _contactAddContactFriendInfoButtonShadowColor;

  @override
  Color get contactAddContactFriendInfoStateButtonBackgroundColor =>
      _contactAddContactFriendInfoStateButtonBackgroundColor;

  @override
  Color get contactAddContactFriendInfoStateButtonTextColor => _contactAddContactFriendInfoStateButtonTextColor;

  @override
  Color get contactAddContactFriendInfoStateButtonActiveColor => _contactAddContactFriendInfoStateButtonActiveColor;

  @override
  Color get contactAddContactFriendInfoStateButtonInactiveColor => _contactAddContactFriendInfoStateButtonInactiveColor;

  @override
  // TODO: implement contactAddContactToastCheckColor
  Color get contactAddContactToastCheckColor => _contactAddContactToastCheckColor;

  @override
  // TODO: implement contactAddContactToastRefuseColor
  Color get contactAddContactToastRefuseColor => _contactAddContactToastRefuseColor;

  @override
  // TODO: implement settingBackgroundColor
  Color get settingBackgroundColor => _settingBackgroundColor;

  @override
  // TODO: implement settingTabBackgroundColor
  Color get settingTabBackgroundColor => _settingTabBackgroundColor;

  @override
  // TODO: implement settingTitleColor
  Color get settingTitleColor => _settingTitleColor;

  @override
  // TODO: implement settingTabTitleColor
  Color get settingTabTitleColor => _settingTabTitleColor;

  @override
  // TODO: implement settingLogoutColor
  Color get settingLogoutColor => _settingLogoutColor;

  @override
  // TODO: implement settingInfoEditColor
  Color get settingInfoEditColor => _settingInfoEditColor;

  @override
  // TODO: implement settingAboutBorderColor
  Color get settingAboutBorderColor => _settingAboutBorderColor;

  @override
  // TODO: implement contactSearchBackgroundColor
  Color get contactSearchBackgroundColor => _contactSearchBackgroundColor;

  @override
  // TODO: implement contactSearchCursorColor
  Color get contactSearchCursorColor => _contactSearchCursorColor;

  @override
  // TODO: implement contactSearchButtonColor
  Color get contactSearchButtonColor => _contactSearchButtonColor;

  @override
  // TODO: implement settingInfoBackgroundColor
  Color get settingInfoBackgroundColor => _settingInfoBackgroundColor;

  @override
  // TODO: implement loginBackgroundColor
  Color get loginBackgroundColor => _loginBackgroundColor;

  @override
  // TODO: implement loginButtonDisableColor
  Color get loginButtonDisableColor => _loginButtonDisableColor;

  @override
  // TODO: implement loginCardBackground
  Color get loginCardBackground => _loginCardBackground;

  @override
  // TODO: implement profileChatButtonBackground
  Color get profileChatButtonBackground => _profileChatButtonBackground;

  @override
  // TODO: implement profileChatButtonBoxShadow
  Color get profileChatButtonBoxShadow => _profileChatButtonBoxShadow;

  @override
  // TODO: implement groupProfileTabBackground
  Color get groupProfileTabBackground => _groupProfileTabBackground;

  @override
  // TODO: implement groupProfileTabTextColor
  Color get groupProfileTabTextColor => _groupProfileTabTextColor;

  @override
  // TODO: implement groupProfileTextColor
  Color get groupProfileTextColor => _groupProfileTextColor;

  @override
  // TODO: implement groupProfileAddMemberTextColor
  Color get groupProfileAddMemberTextColor => _groupProfileAddMemberTextColor;

  @override
  // TODO: implement groupProfileTabBorderColor
  Color get groupProfileTabBorderColor => _groupProfileTabBorderColor;

  @override
  Color get desktopBackgroundColorLinearGradientOne => _desktopBackgroundColorLinearGradientOne;

  @override
  Color get desktopBackgroundColorLinearGradientTwo => _desktopBackgroundColorLinearGradientTwo;

// end
}
