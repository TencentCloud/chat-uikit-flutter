import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_common_defines.dart';

class TencentCloudChatMessageStickerData {
  // A Map instance variable to store the emojis and their paths
  final Map<String, ({String assetPath, String? package})> _emojiMap =
      <String, ({String assetPath, String? package})>{};

  // A getter method for _emojiMap
  Map<String, ({String assetPath, String? package})> get emojiMap => _emojiMap;

  // A Map instance variable to store the key to emoji groups
  final Map<String, List> _emojiKeyCategoryMap = <String, List>{};

  // A getter method for _emojiMap
  Map<String, List> get emojiKeyCategoryMap => _emojiKeyCategoryMap;

  void _loadEmojis(List<TencentCloudChatStickerSet> emojiSetList) {
    for (final emojiSet in emojiSetList) {
      if (!emojiSet.isEmoji) {
        continue;
      }
      final keyList = [];
      for (final emoji in emojiSet.stickerList) {
        _emojiMap[emoji.key] =
            (assetPath: emoji.assetPath, package: emojiSet.package);
        keyList.add(emoji.key);
      }
      _emojiKeyCategoryMap[emojiSet.setName] = keyList;
    }
  }

  TencentCloudChatMessageStickerData(
      List<TencentCloudChatStickerSet> emojiSetList) {
    _loadEmojis(emojiSetList.where((element) => element.isEmoji).toList());
  }
}
