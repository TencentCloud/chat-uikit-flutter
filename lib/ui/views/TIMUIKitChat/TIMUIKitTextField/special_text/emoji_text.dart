
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/constant_data.dart';
import 'package:tencent_extended_text/extended_text.dart';

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

    if (EmojiUitl(
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
                EmojiUitl(
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
            AssetImage(EmojiUitl(
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

class EmojiUitl {
  EmojiUitl(
      {this.isUseDefaultEmoji = false, this.customEmojiStickerList = const []});
  EmojiUitl._(this.isUseDefaultEmoji, this.customEmojiStickerList) {
    RegExp exp = RegExp(r"([\u4e00-\u9fa5]+|[a-zA-Z]+)");
    if (isUseDefaultEmoji == true) {
      for (int i = 0; i < ConstData.emojiList.length; i++) {
        for (int j = 0; j < ConstData.emojiList[i].list.length; j++) {
          var emojiPngNameMatch =
              exp.firstMatch(ConstData.emojiList[i].list[j]);
          String? emojiName = emojiPngNameMatch![0];
          _emojiMap['[$emojiName]'] =
              '$_emojiFilePath/${ConstData.emojiList[i].name}/[$emojiName]@2x.png';
        }
      }
    } else {
      for (int i = 0; i < customEmojiStickerList.length; i++) {
        for (int j = 0; j < customEmojiStickerList[i].list.length; j++) {
          var emojiPngNameMatch =
              exp.firstMatch(customEmojiStickerList[i].list[j]);
          String? emojiName = emojiPngNameMatch![0];
          _emojiMap['[$emojiName]'] =
              '$_emojiFilePath/${customEmojiStickerList[i].name}/[$emojiName]@2x.png';
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
  static EmojiUitl? _instance;
  EmojiUitl get instance =>
      _instance ??= EmojiUitl._(isUseDefaultEmoji, customEmojiStickerList);
}
