import 'package:flutter/material.dart';

abstract class TencentCloudChatThemeColors {
  /// Primary color for major UI elements
  Color get primaryColor;

  /// Secondary color for UI elements
  Color get secondaryColor;

  /// Background color for the main UI
  Color get backgroundColor;

  /// Text color for primary color backgrounds
  Color get onPrimary;

  /// Text color for secondary color backgrounds
  Color get onSecondary;

  /// Text color for error color backgrounds
  Color get onError;

  /// Background color for surfaces (e.g. cards, dialogs)
  Color get surface;

  /// Text color for surface backgrounds
  Color get onSurface;

  /// Text color for main background color
  Color get onBackground;

  /// Error color for error messages and icons
  Color get error;

  /// Informational color for tooltips and hints
  Color get info;

  /// Text color for primary titles (e.g. conversation names, user names)
  Color get primaryTextColor;

  /// Text color for secondary titles (e.g. last message preview, online status, group member overview)
  Color get secondaryTextColor;

  /// Background color for message bubbles sent by the current user
  Color get selfMessageBubbleColor;

  /// Border color for message bubbles sent by the current user
  Color get selfMessageBubbleBorderColor;

  /// Text color for message bubbles sent by the current user
  Color get selfMessageTextColor;

  /// Background color for message bubbles sent by other users
  Color get othersMessageBubbleColor;

  /// Border color for message bubbles sent by other users
  Color get othersMessageBubbleBorderColor;

  /// Text color for message bubbles sent by other users
  Color get othersMessageTextColor;

  /// Icon color for sent message status (e.g. read, delivered)
  Color get messageStatusIconColor;

  /// The background color for a message row when been chosen
  Color get messageBeenChosenBackgroundColor;

  /// Border color for input fields
  Color get inputFieldBorderColor;

  /// Icon color for input area (e.g. microphone button)
  Color get inputAreaIconColor;

  /// Background color for input area
  Color get inputAreaBackground;

  /// Icon and control color for the app bar
  Color get appBarIconColor;

  /// Background color for the app bar
  Color get appBarBackgroundColor;

  /// Color for the primary action button
  Color get firstButtonColor;

  /// Color for the secondary action button
  Color get secondButtonColor;

  /// Color for tooltips and hints
  Color get tipsColor;

  /// Color for activated switches
  Color get switchActivatedColor;

  /// Color for dividers and separators
  Color get dividerColor;

  /// Color for tips message
  Color get messageTipsBackgroundColor;

  /// Color for conversation title
  Color get conversationItemTitleColor;

  /// Color for conversation last message
  Color get conversationItemLastMessageColor;

  /// conversationItemSwipeActionOneBgColor
  Color get conversationItemSwipeActionOneBgColor;

  /// conversationItemSwipeActionTwoBgColor
  Color get conversationItemSwipeActionTwoBgColor;

  /// conversationItemSwipeActionOneTextColor
  Color get conversationItemSwipeActionOneTextColor;

  /// conversationItemSwipeActionTwoTextColor
  Color get conversationItemSwipeActionTwoTextColor;

  /// conversationItemIsPinedBgColor
  Color get conversationItemIsPinedBgColor;

  /// conversationItemNormalBgColor
  Color get conversationItemNormalBgColor;

  /// conversationItemShowNameTextColor
  Color get conversationItemShowNameTextColor;

  /// conversationItemSendingIconColor
  Color get conversationItemSendingIconColor;

  /// conversationItemSendFailedIconColor
  Color get conversationItemSendFailedIconColor;

  /// conversationItemDraftTextColor
  Color get conversationItemDraftTextColor;

  /// conversationItemLastMessageTextColor
  Color get conversationItemLastMessageTextColor;

  /// conversationItemGroupAtInfoTextColor
  Color get conversationItemGroupAtInfoTextColor;

  /// conversationItemNoReceiveIconColor
  Color get conversationItemNoReceiveIconColor;

  /// conversationItemUnreadCountBgColor
  Color get conversationItemUnreadCountBgColor;

  /// conversationItemUnreadCountTextColor
  Color get conversationItemUnreadCountTextColor;

  /// conversationItemTimeTextColor
  Color get conversationItemTimeTextColor;

  /// conversationItemUnreadIconColor
  Color get conversationItemUnreadIconColor;

  /// conversationItemReadIconColor
  Color get conversationItemReadIconColor;

  /// conversationNoConversationTextColor
  Color get conversationNoConversationTextColor;

  /// conversationItemMoreActionItemNormalTextColor
  Color get conversationItemMoreActionItemNormalTextColor;

  /// _conversationItemMoreActionItemDeleteTextColor
  Color get conversationItemMoreActionItemDeleteTextColor;

  /// _conversationItemMoreActionItemDeleteTextColor
  Color get conversationItemUserStatusBgColor;

  /// Color for contact friend list friend name
  Color get contactItemFriendNameColor;

  /// Color for contact tab item name
  Color get contactItemTabItemNameColor;

  /// Color for contact tab item border
  Color get contactItemTabItemBorderColor;

  /// Color for friend application background
  Color get contactApplicationBackgroundColor;

  /// Color for contact tab item background
  Color get contactTabItemBackgroundColor;

  /// color for contact tab item icon
  Color get contactTabItemIconColor;

  /// color for application unread count text
  Color get contactApplicationUnreadCountTextColor;

  /// color for contact background
  Color get contactBackgroundColor;

  /// color for contact app bar navigation go-back button
  Color get contactBackButtonColor;

  /// color for text for no corresponding list
  Color get contactNoListColor;

  /// color for contact application agree button
  Color get contactAgreeButtonColor;

  /// color for contact application refuse button
  Color get contactRefuseButtonColor;

  /// color for contact appbar icon
  Color get contactAppBarIconColor;

  /// color for contact add contact page background
  Color get contactAddContactBackgroundColor;

  /// color for contact add contact information page background
  Color get contactAddContactInfoBackgroundColor;

  /// color for contact add friend button shadow
  Color get contactAddContactFriendInfoButtonShadowColor;

  /// color for contact add contact friend state information button
  Color get contactAddContactFriendInfoStateButtonBackgroundColor;

  /// color for contact add contact friend state button's text
  Color get contactAddContactFriendInfoStateButtonTextColor;

  /// color for contact add contact friend state button color if active
  Color get contactAddContactFriendInfoStateButtonActiveColor;

  /// color for contact add contact friend state button color if inactive
  Color get contactAddContactFriendInfoStateButtonInactiveColor;

  Color get contactAddContactToastCheckColor;

  Color get contactAddContactToastRefuseColor;

  /// color for contact search friends/groups background
  Color get contactSearchBackgroundColor;

  /// color for contact search page cursor
  Color get contactSearchCursorColor;

  /// color for contact search page search button
  Color get contactSearchButtonColor;

  /// color for setting background
  Color get settingBackgroundColor;

  /// color for settingn title
  Color get settingTitleColor;

  /// color for setting tab background
  Color get settingTabBackgroundColor;

  /// color for setting tab title
  Color get settingTabTitleColor;

  /// color for setting logout button text
  Color get settingLogoutColor;

  /// color for setting self information edit button
  Color get settingInfoEditColor;

  /// color for setting about app tab border
  Color get settingAboutBorderColor;

  /// color for setting more information background
  Color get settingInfoBackgroundColor;

  /// color for login page background
  Color get loginBackgroundColor;

  /// color for login button when disabled
  Color get loginButtonDisableColor;

  /// color for login card background
  Color get loginCardBackground;

  Color get profileChatButtonBackground;

  Color get profileChatButtonBoxShadow;

  Color get groupProfileTabBackground;

  Color get groupProfileTabTextColor;

  Color get groupProfileTextColor;

  Color get groupProfileAddMemberTextColor;

  Color get groupProfileTabBorderColor;

  Color get desktopBackgroundColorLinearGradientOne;

  Color get desktopBackgroundColorLinearGradientTwo;

  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: primaryColor,
      onPrimary: onPrimary,
      secondary: secondaryColor,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      background: backgroundColor,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
    );
  }
}
