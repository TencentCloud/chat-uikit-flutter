import 'package:flutter/material.dart';

class TencentCloudChatMessageGeneralOptionItem {
  final IconData icon;
  final String label;

  /// Not every events include offset data, mainly support on desktop.
  final Function({Offset? offset}) onTap;

  TencentCloudChatMessageGeneralOptionItem(
      {required this.icon, required this.label, required this.onTap});
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
