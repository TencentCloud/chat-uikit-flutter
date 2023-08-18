// ignore_for_file: file_names

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/http_text.dart';
import 'package:tim_ui_kit_sticker_plugin/utils/tim_custom_face_data.dart';

import 'emoji_text.dart';

class DefaultSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  DefaultSpecialTextSpanBuilder({
    this.isUseQQPackage = false,
    this.isUseTencentCloudChatPackage = false,
    this.customEmojiStickerList = const [],
    this.showAtBackground = false,
  });

  /// whether show background for @somebody
  final bool showAtBackground;

  final bool isUseQQPackage;

  final bool isUseTencentCloudChatPackage;

  final List<CustomEmojiFaceData> customEmojiStickerList;

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle,
          isUseTencentCloudChatPackage: isUseTencentCloudChatPackage,
          start: index! - (EmojiText.flag.length - 1),
          isUseQQPackage: isUseQQPackage,
          customEmojiStickerList: customEmojiStickerList);
    } else if (isStart(flag, HttpText.flag)) {
      return HttpText(textStyle, onTap,
          start: index! - (HttpText.flag.length - 1));
    }
    return null;
  }
}
