import 'package:flutter/material.dart';

class TencentCloudChatMessageGeneralOptionItem {
  final IconData? icon;
  final String label;
  final String? id;
  final ({String path, String? package})? iconAsset;

  /// Not every events include offset data, mainly support on desktop.
  final Function({Offset? offset}) onTap;

  TencentCloudChatMessageGeneralOptionItem({this.iconAsset, this.icon, required this.label, required this.onTap, this.id});
}

class TencentCloudChatTimeDividerConfig {
  /// Defines the interval of adding a time divider among the two messages.
  /// If not yet specified, time divider will act as date divider,
  /// shows before the first message each single day, like Telegram.
  /// [Unit]: second.
  final int? timeInterval;

  /// Defines the parser of a specific timestamp,
  /// transform it into a semantic time description.
  final String Function(int timeStamp)? timestampParser;

  TencentCloudChatTimeDividerConfig({this.timeInterval, this.timestampParser});
}

/// Configuration options for default message menu settings in Tencent Cloud Chat Message.
///
/// The default value for all configurations is `true`.
class TencentCloudChatMessageDefaultMessageMenuConfig {
  /// Determines whether to enable the option to copy text messages within the message menu.
  final bool enableMessageCopy;

  /// Determines whether to enable the message reply option in the message menu.
  final bool enableMessageReply;

  /// Determines whether to enable the message select option in the message menu.
  final bool enableMessageSelect;

  /// Determines whether to enable the message forward option in the message menu.
  final bool enableMessageForward;

  /// Determines whether to enable the option to recall messages that were sent within the specific `recallTimeLimit`
  /// (from `TencentCloudChatMessageConfig`) within the message menu.
  final bool enableMessageRecall;

  /// Determines whether to enable the message delete for self option in the message menu.
  final bool enableMessageDeleteForSelf;

  /// Determines whether to enable the message delete for everyone option in the message menu.
  ///
  /// This feature works with Premium Edition only.
  final bool enableMessageDeleteForEveryone;

  /// Determines whether to enable group message receipt option.
  final bool enableGroupMessageReceipt;

  TencentCloudChatMessageDefaultMessageMenuConfig({
    this.enableMessageCopy = true,
    this.enableMessageReply = true,
    this.enableMessageSelect = true,
    this.enableMessageForward = true,
    this.enableMessageRecall = true,
    this.enableMessageDeleteForSelf = true,
    this.enableMessageDeleteForEveryone = true,
    this.enableGroupMessageReceipt = true,
  });
}

class TencentCloudChatMessageAttachmentConfig {
  /// Works on Mobile.
  final bool enableSendMediaFromMobileGallery;

  /// Works on Desktop & Web.
  final bool enableSendImage;

  /// Works on Desktop & Web.
  final bool enableSendVideo;

  /// Works on all platforms.
  final bool enableSendFile;

  /// Works on Desktop & Web.
  final bool enableSearch;

  TencentCloudChatMessageAttachmentConfig({
    this.enableSendMediaFromMobileGallery = true,
    this.enableSendImage = true,
    this.enableSendVideo = true,
    this.enableSendFile = true,
    this.enableSearch = true,
  });
}

/// Configuration options for default operations on message selection mode in Tencent Cloud Chat Message.
///
/// The default value for all configurations is `true`.
class TencentCloudChatMessageDefaultMessageSelectionOptionsConfig {
  /// Determines whether to enable the message forward individually option in the message menu.
  final bool enableMessageForwardIndividually;

  /// Determines whether to enable the message forward combined option in the message menu.
  final bool enableMessageForwardCombined;

  /// Determines whether to enable the message delete for self option in the message menu.
  final bool enableMessageDeleteForSelf;

  /// Determines whether to enable the message delete for everyone option in the message menu.
  ///
  /// This feature works with Premium Edition only.
  final bool enableMessageDeleteForEveryone;

  TencentCloudChatMessageDefaultMessageSelectionOptionsConfig({
    this.enableMessageForwardIndividually = true,
    this.enableMessageForwardCombined = true,
    this.enableMessageDeleteForSelf = true,
    this.enableMessageDeleteForEveryone = true,
  });
}

/// Represents a sticker set in the Tencent Cloud Chat.
///
/// A sticker set contains multiple stickers that can be used in chat
/// conversations for expressive communication. Stickers can be either
/// small emoji-like icons embedded within text, or larger standalone images.
class TencentCloudChatStickerSet {
  /// The name of the sticker set.
  final String setName;

  /// The package identifier for the sticker set (optional).
  final String? package;

  /// The base path for the sticker set resources (optional).
  final String? baseAssetPath;

  /// The title icon of the sticker set, represented by a key and a path.
  final ({String key, String assetPath}) titleIcon;

  /// A flag indicating whether the stickers are small emoji-like icons
  /// embedded within text (true), or larger standalone images (false).
  final bool isEmoji;

  /// A list of stickers in the set, each represented by a key and a assetPath.
  final List<({String key, String assetPath})> stickerList;

  /// Creates a new sticker set with the specified properties.
  ///
  /// The [setName], [titleIcon], [isEmoji], and [stickerList] parameters
  /// are required, while the [package] and [baseAssetPath] parameters are optional.
  TencentCloudChatStickerSet({
    required this.setName,
    this.package,
    this.baseAssetPath,
    required this.titleIcon,
    required this.isEmoji,
    required this.stickerList,
  });
}

enum TencentCloudChatMessageInputStatus {
  canSendMessage,
  cantSendMessage,
  noSuchGroup,
  notGroupMember,
  userNotFound,
  userBlockedYou,
  muted,
  groupMuted,
}
