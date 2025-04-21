import 'package:flutter/material.dart';
import 'package:extended_text/extended_text.dart';
import 'package:tim_ui_kit_sticker_plugin/constant/emoji.dart';
import 'package:tim_ui_kit_sticker_plugin/utils/tim_custom_face_data.dart';

///emoji/image text
class EmojiText extends SpecialText {
  EmojiText(TextStyle? textStyle,
      {this.start,
      this.isUseQQPackage = false,
      this.isUseTencentCloudChatPackage = false,
      this.isUseTencentCloudChatPackageOldKeys = false,
      this.customEmojiStickerList = const []})
      : super(EmojiText.flag, ']', textStyle);
  static const String flag = '[';
  final int? start;
  final bool isUseQQPackage;
  final bool isUseTencentCloudChatPackage;
  final bool isUseTencentCloudChatPackageOldKeys;
  final List<CustomEmojiFaceData> customEmojiStickerList;

  @override
  InlineSpan finishText() {
    final String key = toString();
    final EmojiUtil emojiUtil = EmojiUtil(
        isUseQQPackage: isUseQQPackage,
        isUseTencentCloudChatPackage: isUseTencentCloudChatPackage,
        isUseTencentCloudChatPackageOldKeys: isUseTencentCloudChatPackageOldKeys,
        customEmojiStickerList: customEmojiStickerList);

    if (emojiUtil.emojiMap.containsKey(key)) {
      double size = 16;

      final TextStyle ts = textStyle!;
      if (ts.fontSize != null) {
        size = ts.fontSize! * 1.44;
      }

      if (isUseQQPackage == true && (emojiUtil.emojiKeyCategoryMap["4349"]?.contains(key) ?? false)) {
        return ImageSpan(AssetImage(emojiUtil.emojiMap[key]!, package: "tim_ui_kit_sticker_plugin"),
            actualText: key,
            imageWidth: size,
            imageHeight: size,
            start: start!,
            // fit: BoxFit.cover,
            margin: const EdgeInsets.all(0));
      } else if (isUseTencentCloudChatPackage == true &&
          (emojiUtil.emojiKeyCategoryMap["tcc1"]?.contains(key) ?? false)) {
        return ImageSpan(AssetImage(emojiUtil.emojiMap[key]!, package: "tim_ui_kit_sticker_plugin"),
            actualText: key,
            imageWidth: size,
            imageHeight: size,
            start: start!,
            // fit: BoxFit.cover,
            margin: const EdgeInsets.all(0));
      } else {
        return ImageSpan(AssetImage(emojiUtil.emojiMap[key]!),
            actualText: key,
            imageWidth: size,
            imageHeight: size,
            start: start!,
            // fit: BoxFit.cover,
            margin: const EdgeInsets.all(0));
      }
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class EmojiUtil {
  // Private constructor initializing the emoji data
  EmojiUtil._internal(
      {required this.isUseQQPackage,
      required this.isUseTencentCloudChatPackage,
      required this.isUseTencentCloudChatPackageOldKeys,
      required this.customEmojiStickerList}) {
    _emojiMap.addAll(loadDefaultEmojis());

    final customEmojis = loadCustomEmojis();
    _emojiMap.addAll(customEmojis.$1);
    _emojiKeyCategoryMap["custom"] = customEmojis.$2;
  }

  final bool isUseQQPackage;
  final bool isUseTencentCloudChatPackage;
  final bool isUseTencentCloudChatPackageOldKeys;
  final List<CustomEmojiFaceData> customEmojiStickerList;

  // Load the default emojis into a Map
  Map<String, String> loadDefaultEmojis() {
    Map<String, String> defaultEmojiMap = {};
    for (final emojiGroup in TUIKitStickerConstData.emojiList) {
      final groupName = emojiGroup.name;
      final keyList = [];
      if (isUseQQPackage && groupName == "4349") {
        for (final emoji in emojiGroup.list) {
          String emojiName = emoji.split('.png')[0];
          defaultEmojiMap['[$emojiName]'] = '$_emojiFilePath/$groupName/$emojiName.png';
          keyList.add('[$emojiName]');

          final zhKey = TUIKitStickerConstData.emoji4349ZhMapList[emojiName];
          defaultEmojiMap['[$zhKey]'] = '$_emojiFilePath/$groupName/$emojiName.png';
          keyList.add('[$zhKey]');
        }
        _emojiKeyCategoryMap[groupName] = keyList;
      }

      if (isUseTencentCloudChatPackage && groupName == "tcc1") {
        for (final emoji in emojiGroup.list) {
          String emojiName = emoji.split('.png')[0];
          String compatibleEmojiName = emojiName;
          if (isUseTencentCloudChatPackageOldKeys) {
            // use old emoji keys in 3.x version
            compatibleEmojiName = getCompatibleEmojiName(emojiName);
          }

          defaultEmojiMap['[$compatibleEmojiName]'] = '$_emojiFilePath/$groupName/$emojiName.png';
          keyList.add('[$compatibleEmojiName]');
        }
        _emojiKeyCategoryMap[groupName] = keyList;
      }
    }
    return defaultEmojiMap;
  }

  // Load the custom emojis into a Map
  (Map<String, String>, List<String>) loadCustomEmojis() {
    Map<String, String> customEmojiMap = {};
    List<String> keyList = [];
    for (final customEmojiGroup in customEmojiStickerList) {
      for (final customEmoji in customEmojiGroup.list) {
        String customEmojiName = customEmoji.split('.png')[0];
        customEmojiMap['[$customEmojiName]'] = '$_emojiFilePath/${customEmojiGroup.name}/$customEmojiName.png';
        keyList.add('[$customEmojiName]');
      }
    }
    return (customEmojiMap, keyList);
  }

  // A Map instance variable to store the emojis and their paths
  final Map<String, String> _emojiMap = <String, String>{};

  // A getter method for _emojiMap
  Map<String, String> get emojiMap => _emojiMap;

  // A Map instance variable to store the emojis and their paths
  final Map<String, List> _emojiKeyCategoryMap = <String, List>{};

  // A getter method for _emojiMap
  Map<String, List> get emojiKeyCategoryMap => _emojiKeyCategoryMap;

  // An instance variable to store the emoji file path
  final String _emojiFilePath = 'assets/custom_face_resource';

  // Singleton pattern to avoid creating multiple instances of EmojiUtil
  static EmojiUtil? _instance;

  // Factory constructor to return the singleton instance of EmojiUtil with custom parameters
  factory EmojiUtil(
      {bool isUseQQPackage = false,
      bool isUseTencentCloudChatPackage = false,
      bool isUseTencentCloudChatPackageOldKeys = false,
      List<CustomEmojiFaceData> customEmojiStickerList = const []}) {
    return _instance ??= EmojiUtil._internal(
        isUseQQPackage: isUseQQPackage,
        customEmojiStickerList: customEmojiStickerList,
        isUseTencentCloudChatPackage: isUseTencentCloudChatPackage,
        isUseTencentCloudChatPackageOldKeys: isUseTencentCloudChatPackageOldKeys);
  }

  static String getCompatibleEmojiName(String emojiName) {
    String compatibleEmojiName = emojiName;
    try {
      compatibleEmojiName = emojiName.split('_')[1];
      // 对特殊字符串 Ok 进行处理
      if (compatibleEmojiName == 'Ok') {
        compatibleEmojiName = 'OK';
      }
    } catch (e) {
      print(e);
    }

    return compatibleEmojiName;
  }
}
