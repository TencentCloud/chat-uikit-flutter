import 'package:flutter/material.dart';
import 'package:extended_text/extended_text.dart';
import 'package:tim_ui_kit_sticker_plugin/constant/emoji.dart';

///emoji/image text
class EmojiText extends SpecialText {
  EmojiText(TextStyle? textStyle,
      {this.start,
      this.isUseDefaultEmoji = false,
      this.customEmojiStickerList = const []})
      : super(EmojiText.flag, ']', textStyle);
  static const String flag = '[';
  final int? start;
  final bool isUseDefaultEmoji;
  final List customEmojiStickerList;
  @override
  InlineSpan finishText() {
    final String key = toString();

    if (EmojiUtil(
            isUseDefaultEmoji: isUseDefaultEmoji,
            customEmojiStickerList: customEmojiStickerList)
        .instance
        .emojiMap
        .containsKey(key)) {
      double size = 16;

      final TextStyle ts = textStyle!;
      if (ts.fontSize != null) {
        size = ts.fontSize! * 1.15;
      }

      if (isUseDefaultEmoji == true) {
        return ImageSpan(
            AssetImage(
                EmojiUtil(
                        isUseDefaultEmoji: isUseDefaultEmoji,
                        customEmojiStickerList: customEmojiStickerList)
                    .instance
                    .emojiMap[key]!,
                package: "tencent_im_base"),
            actualText: key,
            imageWidth: size,
            imageHeight: size,
            start: start!,
            // fit: BoxFit.cover,
            margin: const EdgeInsets.all(0));
      } else {
        return ImageSpan(
            AssetImage(EmojiUtil(
                    isUseDefaultEmoji: isUseDefaultEmoji,
                    customEmojiStickerList: customEmojiStickerList)
                .instance
                .emojiMap[key]!),
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
  EmojiUtil(
      {this.isUseDefaultEmoji = false, this.customEmojiStickerList = const []});
  EmojiUtil._(this.isUseDefaultEmoji, this.customEmojiStickerList) {
    if (isUseDefaultEmoji == true) {
      for (int i = 0; i < ConstData.emojiList.length; i++) {
        for (int j = 0; j < ConstData.emojiList[i].list.length; j++) {
          String? emojiName = ConstData.emojiList[i].list[j].split('.png')[0];
          _emojiMap['[$emojiName]'] =
              '$_emojiFilePath/${ConstData.emojiList[i].name}/$emojiName.png';
          _emojiMap['[${ConstData.emojiMapList[emojiName]}]'] =
              '$_emojiFilePath/${ConstData.emojiList[i].name}/$emojiName.png';
        }
      }
    } else {
      for (int i = 0; i < customEmojiStickerList.length; i++) {
        for (int j = 0; j < customEmojiStickerList[i].list.length; j++) {
          String? emojiName =
              customEmojiStickerList[i].list[j].split('.png')[0];
          _emojiMap['[$emojiName]'] =
              '$_emojiFilePath/${customEmojiStickerList[i].name}/$emojiName.png';
        }
      }
    }
  }
  final List customEmojiStickerList;
  final bool isUseDefaultEmoji;
  final Map<String, String> _emojiMap = <String, String>{};

  Map<String, String> get emojiMap => _emojiMap;

  final String _emojiFilePath = 'assets/custom_face_resource';
  // EmojiUitl? _instance;
  static EmojiUtil? _instance;
  EmojiUtil get instance =>
      _instance ??= EmojiUtil._(isUseDefaultEmoji, customEmojiStickerList);
}
