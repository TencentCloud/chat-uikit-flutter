import 'package:flutter/material.dart';

class TUITheme {
  const TUITheme({
    this.primaryColor = const Color(0xFF00449E),
    this.secondaryColor = const Color(0xFF147AFF),
    this.infoColor = const Color(0xFFFF9C19),
    this.weakBackgroundColor = const Color(0xFFEDEDED),
    this.wideBackgroundColor = Colors.white,
    this.weakDividerColor = const Color(0xFFE5E6E9),
    this.weakTextColor = const Color(0xFF999999),
    this.darkTextColor = const Color(0xFF444444),
    this.lightPrimaryColor = const Color(0xFF3371CD),
    this.textColor,
    this.cautionColor = const Color(0xFFFF584C),
    this.ownerColor = Colors.orange,
    this.adminColor = Colors.blue,
    this.white = Colors.white,
    this.black = Colors.black,
    this.inputFillColor = const Color(0xFFEDEDED),
    this.textgrey = const Color(0xFFAEA4A3),

    /// 消息列表多选面板背景颜色
    this.selectPanelBgColor = const Color(0xFFF9F9FA),

    /// 消息列表多选面板文字及icon颜色
    this.selectPanelTextIconColor = const Color(0xFF37393F),

    /// Appbar 背景颜色
    this.appbarBgColor = const Color(0xFFF2F3F5),

    /// Appbar 文字颜色
    this.appbarTextColor = const Color(0xFF010000),

    /// 会话列表背景颜色
    this.conversationItemBgColor = Colors.white, // 1

    /// 会话列表边框颜色
    this.conversationItemBorderColor = const Color(0xFFE5E6E9), // 1

    /// 会话列表选中背景颜色
    this.conversationItemActiveBgColor = const Color(0xFFEDEDED), // 1

    /// 会话列表置顶背景颜色
    this.conversationItemPinedBgColor = const Color(0xFFEDEDED), // 1

    /// 会话列表Title字体颜色
    this.conversationItemTitleTextColor = Colors.black, // 1

    /// 会话列表LastMessage字体颜色
    this.conversationItemLastMessageTextColor = const Color(0xFF999999), // 1

    /// 会话列表Time字体颜色
    this.conversationItemTitmeTextColor = const Color(0xFF999999), // 1

    /// 会话列表用户在线状态背景色
    this.conversationItemOnlineStatusBgColor = Colors.green, // 1

    /// 会话列表用户离线状态背景色
    this.conversationItemOfflineStatusBgColor = Colors.grey, // 1

    /// 会话列表未读数背景颜色
    this.conversationItemUnreadCountBgColor = const Color(0xFFFF584C), // 1

    /// 会话列表未读数字体颜色
    this.conversationItemUnreadCountTextColor = Colors.white, // 1

    /// 会话列表草稿字体颜色
    this.conversationItemDraftTextColor = const Color(0xFFFF584C), // 1

    /// 会话列表收到消息不提醒Icon颜色
    this.conversationItemNoNotificationIconColor = const Color(0xFF999999), // 1

    /// 会话列表侧滑按钮字体颜色
    this.conversationItemSliderTextColor = Colors.white, // 1

    /// 会话列表侧滑按钮Clear背景颜色
    this.conversationItemSliderClearBgColor = const Color(0xFF00449E), // 1

    /// 会话列表侧滑按钮Pin背景颜色
    this.conversationItemSliderPinBgColor = const Color(0xFFFF9C19), // 1

    /// 会话列表侧滑按钮Delete背景颜色
    this.conversationItemSliderDeleteBgColor = Colors.red, // 1

    /// 会话列表宽屏模式选中时背景颜色
    this.conversationItemChooseBgColor = const Color(0xFFE7F0FF), // 1

    /// 聊天页背景颜色
    this.chatBgColor, // 1

    /// 桌面端消息输入框背景颜色
    this.desktopChatMessageInputBgColor, // 1

    /// 聊天页背景颜色
    this.chatTimeDividerTextColor = const Color(0xFF999999), // 1

    /// 聊天页导航栏背景颜色
    this.chatHeaderBgColor = const Color(0xFFF2F3F5),

    /// 聊天页导航栏Title字体颜色
    this.chatHeaderTitleTextColor = const Color(0xFF010000),

    /// 聊天页导航栏Back字体颜色
    this.chatHeaderBackTextColor = const Color(0xFF010000),

    /// 聊天页导航栏Action字体颜色
    this.chatHeaderActionTextColor = const Color(0xFF010000),

    /// 聊天页历史消息列表字体颜色
    this.chatMessageItemTextColor = Colors.black, // 1

    /// 聊天页历史消息列表来自自己时背景颜色
    this.chatMessageItemFromSelfBgColor = const Color(0xFFD1E3FF),

    /// 聊天页历史消息列表来自非自己时背景颜色
    this.chatMessageItemFromOthersBgColor = const Color(0xFFEDEDED), // 1

    /// 聊天页历史消息列表已读状态字体颜色
    this.chatMessageItemUnreadStatusTextColor = const Color(0xFF999999), // 1

    /// 聊天页历史消息列表小舌头背景颜色
    this.chatMessageTongueBgColor = const Color(0xFFAEA4A3),

    /// 聊天页历史消息列表小舌头字体颜色
    this.chatMessageTongueTextColor = const Color(0xFFAEA4A3),
  });

  // 应用主色
  // Primary Color For The App
  final Color? primaryColor;

  // 应用次色
  // Secondary Color For The App
  final Color? secondaryColor;

  // 提示颜色，用于次级操作或提示
  // Info Color, Used For Secondary Action Or Info
  final Color? infoColor;

  // 浅背景颜色，比主背景颜色浅，用于填充缝隙或阴影
  // Weak Background Color, Lighter Than Main Background, Used For Marginal Space Or Shadowy Space
  final Color? weakBackgroundColor;

  // 宽屏幕：浅白背景颜色，比浅背景颜色浅
  // Weak Background Color, Lighter Than Main Background, Used For Marginal Space Or Shadowy Space
  final Color? wideBackgroundColor;

  // 浅分割线颜色，用于分割线或边框
  // Weak Divider Color, Used For Divider Or Border
  final Color? weakDividerColor;

  // 浅字色
  // Weak Text Color
  final Color? weakTextColor;

  // 深字色
  // Dark Text Color
  final Color? darkTextColor;

  // 浅主色，用于AppBar或Panels
  // Light Primary Color, Used For AppBar Or Several Panels
  final Color? lightPrimaryColor;

  // 字色
  // TextColor
  final Color? textColor;

  // 警示色，用于危险操作
  // Caution Color, Used For Warning Actions
  final Color? cautionColor;

  // 群主标识色
  // Group Owner Identification Color
  final Color? ownerColor;

  // 群管理员标识色
  // Group Admin Identification Color
  final Color? adminColor;

  // 白色
  // white
  final Color? white;

  // 黑色
  // black
  final Color? black;

  // 输入框填充色
  // input fill color
  final Color? inputFillColor;

  // 灰色文本
  // grey text color
  final Color? textgrey;

  /// 新版本颜色从这里开始
  ///
  /// Appbar 背景颜色
  final Color? appbarBgColor;

  /// Appbar 文字颜色
  final Color? appbarTextColor;

  /// 消息列表多选面板背景颜色
  final Color? selectPanelBgColor;

  /// 消息列表多选面板文字及icon颜色
  final Color? selectPanelTextIconColor;

  /// 会话列表背景颜色
  final Color? conversationItemBgColor;

  /// 会话列表边框颜色
  final Color? conversationItemBorderColor;

  /// 会话列表选中背景颜色
  final Color? conversationItemActiveBgColor;

  /// 会话列表置顶背景颜色
  final Color? conversationItemPinedBgColor;

  /// 会话列表Title字体颜色
  final Color? conversationItemTitleTextColor;

  /// 会话列表LastMessage字体颜色
  final Color? conversationItemLastMessageTextColor;

  /// 会话列表Time字体颜色
  final Color? conversationItemTitmeTextColor;

  /// 会话列表用户在线状态背景色
  final Color? conversationItemOnlineStatusBgColor;

  /// 会话列表用户离线状态背景色
  final Color? conversationItemOfflineStatusBgColor;

  /// 会话列表未读数背景颜色
  final Color? conversationItemUnreadCountBgColor;

  /// 会话列表未读数字体颜色
  final Color? conversationItemUnreadCountTextColor;

  /// 会话列表草稿字体颜色
  final Color? conversationItemDraftTextColor;

  /// 会话列表收到消息不提醒Icon颜色
  final Color? conversationItemNoNotificationIconColor;

  /// 会话列表侧滑按钮字体颜色
  final Color? conversationItemSliderTextColor;

  /// 会话列表侧滑按钮Clear背景颜色
  final Color? conversationItemSliderClearBgColor;

  /// 会话列表侧滑按钮Pin背景颜色
  final Color? conversationItemSliderPinBgColor;

  /// 会话列表侧滑按钮Delete背景颜色
  final Color? conversationItemSliderDeleteBgColor;

  /// 会话列表宽屏模式选中时背景颜色
  final Color? conversationItemChooseBgColor;

  /// 聊天页背景颜色
  final Color? chatBgColor;

  /// 桌面端消息输入框背景颜色
  final Color? desktopChatMessageInputBgColor;

  /// 聊天页背景颜色
  final Color? chatTimeDividerTextColor;

  /// 聊天页导航栏背景颜色
  final Color? chatHeaderBgColor;

  /// 聊天页导航栏Title字体颜色
  final Color? chatHeaderTitleTextColor;

  /// 聊天页导航栏Back字体颜色
  final Color? chatHeaderBackTextColor;

  /// 聊天页导航栏Action字体颜色
  final Color? chatHeaderActionTextColor;

  /// 聊天页历史消息列表字体颜色
  final Color? chatMessageItemTextColor;

  /// 聊天页历史消息列表来自自己时背景颜色
  final Color? chatMessageItemFromSelfBgColor;

  /// 聊天页历史消息列表来自非自己时背景颜色
  final Color? chatMessageItemFromOthersBgColor;

  /// 聊天页历史消息列表已读状态字体颜色
  final Color? chatMessageItemUnreadStatusTextColor;

  /// 聊天页历史消息列表小舌头背景颜色
  final Color? chatMessageTongueBgColor;

  /// 聊天页历史消息列表小舌头字体颜色
  final Color? chatMessageTongueTextColor;

  static const TUITheme light = TUITheme();
  static const TUITheme dark = TUITheme();

  MaterialColor get primaryMaterialColor => createMaterialColor(primaryColor!);

  MaterialColor get lightPrimaryMaterialColor =>
      createMaterialColor(lightPrimaryColor!);

  TUITheme.fromJson(Map<String, dynamic> json)
      : primaryColor = json['primaryColor'] as Color?,
        secondaryColor = json['secondaryColor'] as Color?,
        infoColor = json['infoColor'] as Color?,
        weakBackgroundColor = json['weakBackgroundColor'] as Color?,
        wideBackgroundColor = json['wideBackgroundColor'] as Color?,
        weakDividerColor = json['weakDividerColor'] as Color?,
        weakTextColor = json['weakTextColor'] as Color?,
        darkTextColor = json['darkTextColor'] as Color?,
        lightPrimaryColor = json['lightPrimaryColor'] as Color?,
        textColor = json['textColor'] as Color?,
        cautionColor = json['cautionColor'] as Color?,
        ownerColor = json['ownerColor'] as Color?,
        white = json['white'] as Color?,
        black = json['black'] as Color?,
        inputFillColor = json["inputFillColor"] as Color?,
        textgrey = json['textgrey'] as Color?,
        adminColor = json['adminColor'] as Color?,
        selectPanelBgColor = json['selectPanelBgColor'] as Color?,
        selectPanelTextIconColor = json['selectPanelTextIconColor'] as Color?,
        appbarBgColor = json['appbarBgColor'] as Color?,
        appbarTextColor = json['appbarTextColor'] as Color?,

        /// 会话列表背景颜色
        conversationItemBgColor = json['conversationItemBgColor'] as Color?,

        /// 会话列表边框颜色
        conversationItemBorderColor =
            json['conversationItemBorderColor'] as Color?,

        /// 会话列表选中背景颜色
        conversationItemActiveBgColor =
            json['conversationItemActiveBgColor'] as Color?,

        /// 会话列表置顶背景颜色
        conversationItemPinedBgColor =
            json['conversationItemPinedBgColor'] as Color?,

        /// 会话列表Title字体颜色
        conversationItemTitleTextColor =
            json['conversationItemTitleTextColor'] as Color?,

        /// 会话列表LastMessage字体颜色
        conversationItemLastMessageTextColor =
            json['conversationItemLastMessageTextColor'] as Color?,

        /// 会话列表Time字体颜色
        conversationItemTitmeTextColor =
            json['conversationItemTitmeTextColor'] as Color?,

        /// 会话列表用户在线状态背景色
        conversationItemOnlineStatusBgColor =
            json['conversationItemOnlineStatusBgColor'] as Color?,

        /// 会话列表用户离线状态背景色
        conversationItemOfflineStatusBgColor =
            json['conversationItemOfflineStatusBgColor'] as Color?,

        /// 会话列表未读数背景颜色
        conversationItemUnreadCountBgColor =
            json['conversationItemUnreadCountBgColor'] as Color?,

        /// 会话列表未读数字体颜色
        conversationItemUnreadCountTextColor =
            json['conversationItemUnreadCountTextColor'] as Color?,
        conversationItemChooseBgColor =
            json['conversationItemChooseBgColor'] as Color?,

        /// 会话列表草稿字体颜色
        conversationItemDraftTextColor =
            json['conversationItemDraftTextColor'] as Color?,

        /// 会话列表收到消息不提醒Icon颜色
        conversationItemNoNotificationIconColor =
            json['conversationItemNoNotificationIconColor'] as Color?,

        /// 会话列表侧滑按钮字体颜色
        conversationItemSliderTextColor =
            json['conversationItemSliderTextColor'] as Color?,

        /// 会话列表侧滑按钮Clear背景颜色
        conversationItemSliderClearBgColor =
            json['conversationItemSliderClearBgColor'] as Color?,

        /// 会话列表侧滑按钮Pin背景颜色
        conversationItemSliderPinBgColor =
            json['conversationItemSliderPinBgColor'] as Color?,

        /// 会话列表侧滑按钮Delete背景颜色
        conversationItemSliderDeleteBgColor =
            json['conversationItemSliderDeleteBgColor'] as Color?,

        /// 聊天页背景颜色
        chatBgColor = json['chatBgColor'] as Color?,

        /// 桌面端消息输入框背景颜色
        desktopChatMessageInputBgColor =
            json['desktopChatMessageInputBgColor'] as Color?,

        /// 聊天页背景颜色
        chatTimeDividerTextColor = json['chatTimeDividerTextColor'] as Color?,

        /// 聊天页导航栏背景颜色
        chatHeaderBgColor = json['chatHeaderBgColor'] as Color?,

        /// 聊天页导航栏Title字体颜色
        chatHeaderTitleTextColor = json['chatHeaderTitleTextColor'] as Color?,

        /// 聊天页导航栏Back字体颜色
        chatHeaderBackTextColor = json['chatHeaderBackTextColor'] as Color?,

        /// 聊天页导航栏Action字体颜色
        chatHeaderActionTextColor = json['chatHeaderActionTextColor'] as Color?,

        /// 聊天页历史消息列表字体颜色
        chatMessageItemTextColor = json['chatMessageItemTextColor'] as Color?,

        /// 聊天页历史消息列表来自自己时背景颜色
        chatMessageItemFromSelfBgColor =
            json['chatMessageItemFromSelfBgColor'] as Color?,

        /// 聊天页历史消息列表来自非自己时背景颜色
        chatMessageItemFromOthersBgColor =
            json['chatMessageItemFromOthersBgColor'] as Color?,

        /// 聊天页历史消息列表已读状态字体颜色
        chatMessageItemUnreadStatusTextColor =
            json['chatMessageItemUnreadStatusTextColor'] as Color?,

        /// 聊天页历史消息列表小舌头背景颜色
        chatMessageTongueBgColor = json['chatMessageTongueBgColor'] as Color?,

        /// 聊天页历史消息列表小舌头字体颜色
        chatMessageTongueTextColor =
            json['chatMessageTongueTextColor'] as Color?;

  toJson() => <String, dynamic>{
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'infoColor': infoColor,
        'weakBackgroundColor': weakBackgroundColor,
        'wideBackgroundColor': wideBackgroundColor,
        'weakDividerColor': weakDividerColor,
        'weakTextColor': weakTextColor,
        'darkTextColor': darkTextColor,
        'lightPrimaryColor': lightPrimaryColor,
        'textColor': textColor,
        'cautionColor': cautionColor,
        'ownerColor': ownerColor,
        'adminColor': adminColor,
        'white': white,
        'black': black,
        'inputFillColor': inputFillColor,
        'textgrey': textgrey,

        "selectPanelBgColor": selectPanelBgColor,

        "selectPanelTextIconColor": selectPanelTextIconColor,

        "appbarBgColor": appbarBgColor,

        "appbarTextColor": appbarTextColor,

        /// 会话列表背景颜色
        "conversationItemBgColor": conversationItemBgColor,

        /// 会话列表边框颜色
        "conversationItemBorderColor": conversationItemBorderColor,

        /// 会话列表选中背景颜色
        "conversationItemActiveBgColor": conversationItemActiveBgColor,

        /// 会话列表置顶背景颜色
        "conversationItemPinedBgColor": conversationItemPinedBgColor,

        /// 会话列表Title字体颜色
        "conversationItemTitleTextColor": conversationItemTitleTextColor,

        /// 会话列表LastMessage字体颜色
        "conversationItemLastMessageTextColor":
            conversationItemLastMessageTextColor,

        /// 会话列表Time字体颜色
        "conversationItemTitmeTextColor": conversationItemTitmeTextColor,

        /// 会话列表用户在线状态背景色
        "conversationItemOnlineStatusBgColor":
            conversationItemOnlineStatusBgColor,

        /// 会话列表用户离线状态背景色
        "conversationItemOfflineStatusBgColor":
            conversationItemOfflineStatusBgColor,

        /// 会话列表未读数背景颜色
        "conversationItemUnreadCountBgColor":
            conversationItemUnreadCountBgColor,

        /// 会话列表未读数字体颜色
        "conversationItemUnreadCountTextColor":
            conversationItemUnreadCountTextColor,

        /// 会话列表草稿字体颜色
        "conversationItemDraftTextColor": conversationItemDraftTextColor,

        /// 会话列表收到消息不提醒Icon颜色
        "conversationItemNoNotificationIconColor":
            conversationItemNoNotificationIconColor,

        /// 会话列表侧滑按钮字体颜色
        "conversationItemSliderTextColor": conversationItemSliderTextColor,

        /// 会话列表侧滑按钮Clear背景颜色
        "conversationItemSliderClearBgColor":
            conversationItemSliderClearBgColor,

        /// 会话列表侧滑按钮Pin背景颜色
        "conversationItemSliderPinBgColor": conversationItemSliderPinBgColor,

        /// 会话列表侧滑按钮Delete背景颜色
        "conversationItemSliderDeleteBgColor":
            conversationItemSliderDeleteBgColor,

        /// 会话列表侧滑按钮Delete背景颜色
        "conversationItemChooseBgColor": conversationItemChooseBgColor,

        /// 聊天页背景颜色
        "chatBgColor": chatBgColor,

        /// 桌面端消息输入框背景颜色
        "desktopChatMessageInputBgColor": desktopChatMessageInputBgColor,

        /// 聊天页背景颜色
        "chatTimeDividerTextColor": chatTimeDividerTextColor,

        /// 聊天页导航栏背景颜色
        "chatHeaderBgColor": chatHeaderBgColor,

        /// 聊天页导航栏Title字体颜色
        "chatHeaderTitleTextColor": chatHeaderTitleTextColor,

        /// 聊天页导航栏Back字体颜色
        "chatHeaderBackTextColor": chatHeaderBackTextColor,

        /// 聊天页导航栏Action字体颜色
        "chatHeaderActionTextColor": chatHeaderActionTextColor,

        /// 聊天页历史消息列表字体颜色
        "chatMessageItemTextColor": chatMessageItemTextColor,

        /// 聊天页历史消息列表来自自己时背景颜色
        "chatMessageItemFromSelfBgColor": chatMessageItemFromSelfBgColor,

        /// 聊天页历史消息列表来自非自己时背景颜色
        "chatMessageItemFromOthersBgColor": chatMessageItemFromOthersBgColor,

        /// 聊天页历史消息列表已读状态字体颜色
        "chatMessageItemUnreadStatusTextColor":
            chatMessageItemUnreadStatusTextColor,

        /// 聊天页历史消息列表小舌头背景颜色
        "chatMessageTongueBgColor": chatMessageTongueBgColor,

        /// 聊天页历史消息列表小舌头字体颜色
        "chatMessageTongueTextColor": chatMessageTongueTextColor,
      };

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
