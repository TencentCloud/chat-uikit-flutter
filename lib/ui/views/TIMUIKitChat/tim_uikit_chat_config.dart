import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'TIMUIKitTextField/tim_uikit_text_field_layout/wide.dart';

enum GroupReceptAllowType { work, public, meeting }

enum GroupReceiptAllowType { work, public, meeting }

enum UrlPreviewType { none, onlyHyperlink, previewCardAndHyperlink }

class TimeDividerConfig {
  /// Defines the interval of adding a time divider among the two messages.
  /// [Unit]: second.
  /// [Default]: 300.
  final int? timeInterval;

  /// Defines the parser of a specific timestamp,
  /// transform it into a semantic time description.
  final String Function(int timeStamp)? timestampParser;

  TimeDividerConfig({this.timeInterval, this.timestampParser});
}

/// StickerPanelConfig is a configuration class for the sticker panel component.
/// It allows customization of specific features such as display options for the
/// message area, sticker packages, unicode emoji lists, and custom sticker packages.
class StickerPanelConfig {
  /// Determines whether to use the QQ Sticker Package.
  /// Default value: true
  final bool useQQStickerPackage;

  /// Determines whether to use the Tencent Cloud Chat Sticker Package.
  /// Default value: true
  final bool useTencentCloudChatStickerPackage;

  /// A list of unicode emoji, represented as integers.
  /// Default value: a list of common Unicode Emojis.
  /// To exclude Unicode Emoji from the display, pass an empty list.
  final List<int> unicodeEmojiList;

  /// A list of CustomStickerPackage instances, where each instance represents a sticker package.
  /// Default value: an empty list.
  final List<CustomStickerPackage> customStickerPackages;

  StickerPanelConfig({
    this.useQQStickerPackage = true,
    this.useTencentCloudChatStickerPackage = true,
    this.unicodeEmojiList = TUIKitStickerConstData.defaultUnicodeEmojiList,
    this.customStickerPackages = const [],
  });
}

class TIMUIKitChatConfig {
  /// A StickerPanelConfig instance to configure the sticker panel's behavior and appearance.
  /// This includes options such as display settings, usage of specific sticker packages,
  /// unicode emoji lists, and custom sticker packages.
  final StickerPanelConfig? stickerPanelConfig;

  /// Customize the time divider among the two messages.
  final TimeDividerConfig? timeDividerConfig;

  /// Control if allowed to show reading status.
  /// [Default]: true.
  final bool isShowReadingStatus;

  /// Control if allowed to show reading status for group.
  /// [Default]: true.
  final bool isShowGroupReadingStatus;

  /// Control if allowed to report reading status for group.
  /// [Default]: true.
  final bool isReportGroupReadingStatus;

  /// Control if allowed to show the message operation menu after long pressing message.
  /// [Default]: true.
  final bool isAllowLongPressMessage;

  /// Control if allowed to callback after clicking the avatar.
  /// [Default]: true.
  final bool isAllowClickAvatar;

  /// Control if allowed to show emoji face message panel.
  /// [Default]: true.
  final bool isAllowEmojiPanel;

  /// Control if allowed to show more plus panel.
  /// [Default]: true.
  final bool isAllowShowMorePanel;

  /// Control if allowed to send voice sound message.
  /// [Default]: true.
  final bool isAllowSoundMessage;

  /// Control if allowed to at when reply automatically.
  /// [Default]: true.
  final bool isAtWhenReply;

  /// Control if allowed to at when reply automatically.
  /// [Default]: true.
  final bool Function(V2TimMessage message)? isAtWhenReplyDynamic;

  /// The main switch of the group read receipt.
  final bool isShowGroupMessageReadReceipt;

  /// [Deprecated: ] Please use [groupReadReceiptPermissionList] instead.
  final List<GroupReceptAllowType>? groupReadReceiptPermisionList;

  /// Control which group can send message read receipt.
  final List<GroupReceiptAllowType>? groupReadReceiptPermissionList;

  /// Control if show self name in group chat.
  /// [Default]: false.
  final bool isShowSelfNameInGroup;

  /// Control if others name in group chat.
  /// [Default]: true.
  final bool isShowOthersNameInGroup;

  /// Configuration for offline push.
  /// If this field is specified, `notificationTitle`, `notificationOPPOChannelID`, `notificationIOSSound`, `notificationAndroidSound`, `notificationBody` and `notificationExt` will not work.
  final OfflinePushInfo? Function(
      V2TimMessage message, String convID, ConvType convType)? offlinePushInfo;

  /// The title shows in push notification
  final String notificationTitle;

  /// The channel ID for OPPO in push notification.
  final String notificationOPPOChannelID;

  /// The notification sound in iOS devices.
  /// When `iOSSound` = `kIOSOfflinePushNoSound`, the sound will not play when message received. When `iOSSound` = `kIOSOfflinePushDefaultSound`, the system sound is played when message received. If you want to customize `iOSSound`, you need to link the voice file into the Xcode project, and then set the voice file name (with a suffix) to iOSSound.
  final String notificationIOSSound;

  /// The notification sound in Android devices.
  final String notificationAndroidSound;

  ///Used to set the line height of text messages
  final double textHeight;

  /// The body content shows in push notification.
  /// Returning `null` means using default body in this case.
  final String? Function(
      V2TimMessage message, String convID, ConvType convType)? notificationBody;

  /// External information (String) for notification message, recommend used for jumping to target conversation with JSON format,
  /// Returning `null` means using default ext in this case.
  final String? Function(
      V2TimMessage message, String convID, ConvType convType)? notificationExt;

  /// The type of URL preview level, none preview, only hyperlink in text, or shows a preview card for website.
  /// [Default]: UrlPreviewType.previewCardAndHyperlink.
  final UrlPreviewType urlPreviewType;

  /// Whether to display the sending status of c2c messages
  /// [Default]: true.
  final bool showC2cMessageEditStatus;

  /// Control if take emoji stickers as message reaction.
  /// [Default]: true.
  final bool isUseMessageReaction;

  /// Determine how long a message is allowed to be recalled after it is sent.
  /// You must modify the configuration on control dashboard synchronized at: https://console.cloud.tencent.com/im/login-message.
  /// [Unit]: second.
  /// [Default]: 120.
  final int upperRecallTime;

  /// The prefix of face sticker URI.
  final String Function(String data)? faceURIPrefix;

  /// The suffix of face sticker URI.
  final String Function(String data)? faceURISuffix;

  /// Controls whether text and replied messages can be displayed with Markdown formatting.
  /// Also, when enabled, `isEnableTextSelection` will not works.
  /// [Default]: false.
  final bool isSupportMarkdownForTextMessage;

  /// The callback after user clicking the URL link in text messages.
  /// The default action is opening the link with the default browser of system.
  final void Function(String url)? onTapLink;

  /// Whether to use the default emoji
  final bool isUseDefaultEmoji;

  /// Whether shows avatar on history message list.
  /// [Default]: true.
  final bool isShowAvatar;

  /// This list contains additional operation items that are displayed on the hover bar
  /// of a message on desktop (macOS, Windows, and desktop version of Web). These items
  /// are in addition to the default ones and do not affect them.
  final List<MessageHoverControlItem>? additionalDesktopMessageHoverBarItem;

  /// This list contains additional items that are displayed
  /// on the message sending area  control bar on desktop (macOS, Windows, and desktop version of Web).
  /// Use `desktopControlBarConfig` to configure whether or not to show the default control items.
  final List<DesktopControlBarItem>? additionalDesktopControlBarItems;

  /// This configuration is used for the control bar
  /// on desktop (macOS, Windows, and desktop version of Web).
  /// Use `desktopControlBarConfig` to add additional items to the desktop message sending area control bar, in addition to the default ones.
  final DesktopControlBarConfig? desktopControlBarConfig;

  /// Controls whether users are allowed to mention another user in the group by long-pressing on their avatar.
  /// [Default]: true.
  final bool isAllowLongPressAvatarToAt;

  /// Controls whether auto report message read status when new messages come.
  /// [Default]: true.
  final bool isAutoReportRead;

  /// Controls whether enable text selection.
  /// [Default]: true on Desktop while false on Mobile.
  final bool? isEnableTextSelection;

  /// Controls whether enable the control bar shows when hovering a message on Desktop.
  /// [Default]: true.
  final bool isUseMessageHoverBarOnDesktop;

  /// Define the lines in the text message input field on Desktop.
  final int desktopMessageInputFieldLines;

  /// Specifies whether to use the draft feature on the Web, as the Chat SDK does not support this functionality.
  /// If enabled, draft data will be stored in TUIKit's memory.
  /// Note that the draft text will be lost upon refreshing the website.
  /// [Default]: true.
  final bool isUseDraftOnWeb;

  /// Determines whether a group administrator is allowed to recall any
  /// message from any group member. If this capability is enabled,
  /// recalled messages will not be interoperable with Native clients
  /// and will only take effect on other Flutter clients.
  ///
  /// [Default]: false
  final bool isGroupAdminRecallEnabled;

  /// Defines the height of the sticker panel on desktop platforms.
  /// If the height of the sticker list exceeds this container height,
  /// the sticker list will automatically become scrollable.
  ///
  /// [Default]: 400
  final double desktopStickerPanelHeight;

  const TIMUIKitChatConfig(
      {this.onTapLink,
      this.timeDividerConfig,
      this.desktopStickerPanelHeight = 400,
      this.stickerPanelConfig,
      this.isGroupAdminRecallEnabled = false,
      this.isAutoReportRead = true,
      this.faceURIPrefix,
      this.faceURISuffix,
      this.textHeight = 1.3,
      this.desktopMessageInputFieldLines = 6,
      this.isAtWhenReply = true,
      this.notificationAndroidSound = "",
      this.isUseMessageHoverBarOnDesktop = true,
      this.isSupportMarkdownForTextMessage = false,
      this.notificationExt,
      this.isUseMessageReaction = true,
      this.isShowAvatar = true,
      this.isShowSelfNameInGroup = false,
        this.isAtWhenReplyDynamic,
      this.offlinePushInfo,
      @Deprecated("Please use [isShowGroupReadingStatus] instead")
      this.isShowGroupMessageReadReceipt = true,
      this.upperRecallTime = 120,
      this.isShowOthersNameInGroup = true,
      this.urlPreviewType = UrlPreviewType.onlyHyperlink,
      this.notificationBody,
      this.notificationOPPOChannelID = "",
      this.notificationTitle = "",
      this.notificationIOSSound = "",
      this.isAllowSoundMessage = true,
      @Deprecated("Please use [groupReadReceiptPermissionList] instead")
      this.groupReadReceiptPermisionList,
      this.groupReadReceiptPermissionList,
      this.isAllowEmojiPanel = true,
      this.isAllowShowMorePanel = true,
      this.isShowReadingStatus = true,
      this.desktopControlBarConfig,
      this.isAllowLongPressMessage = true,
      this.isUseDraftOnWeb = true,
      this.isAllowClickAvatar = true,
      this.isEnableTextSelection,
      this.additionalDesktopMessageHoverBarItem,
      this.isShowGroupReadingStatus = true,
      this.isReportGroupReadingStatus = true,
      this.showC2cMessageEditStatus = true,
      this.additionalDesktopControlBarItems,
      this.isAllowLongPressAvatarToAt = true,
      this.isUseDefaultEmoji = false});
}
