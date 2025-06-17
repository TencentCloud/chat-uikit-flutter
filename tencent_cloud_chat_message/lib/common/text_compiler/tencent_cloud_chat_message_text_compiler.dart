import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';

class TencentCloudChatSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  final TencentCloudChatPlugin? stickerPluginInstance;
  final ValueChanged<String> onTapUrl;

  TencentCloudChatSpecialTextSpanBuilder({
    this.showAtBackground = false,
    required this.onTapUrl,
    this.stickerPluginInstance,
  });

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, int? index}) {
    if (flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, HttpText.flag)) {
      return HttpText(textStyle, onTap, onTapUrl: onTapUrl, start: index! - (HttpText.flag.length - 1));
    } else if (isStart(flag, EmojiText.flag)) {
      return EmojiText(
        textStyle,
        start: index! - (EmojiText.flag.length - 1),
        stickerPluginInstance: stickerPluginInstance,
      );
    }
    return null;
  }
}

class EmojiText extends SpecialText {
  EmojiText(
    TextStyle? textStyle, {
    this.start,
    this.stickerPluginInstance,
  }) : super(EmojiText.flag, ']', textStyle);
  static const String flag = '[TUIEmoji_';
  final int? start;
  final TencentCloudChatPlugin? stickerPluginInstance;

  @override
  InlineSpan finishText() {
    final String key = toString();
    if (stickerPluginInstance != null) {
      var data = stickerPluginInstance!.callMethodSync(methodName: "getAssetImagePathByName", data: key);
      if (data.containsKey("emojiAssets")) {
        String assets = data["emojiAssets"];
        return ImageSpan(
          AssetImage(assets, package: "tencent_cloud_chat_sticker"),
          actualText: key,
          imageWidth: 22,
          imageHeight: 22,
          start: start!,
          // fit: BoxFit.cover,
          margin: const EdgeInsets.all(0),
        );
      }
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class HttpText extends SpecialText {
  HttpText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, {required this.onTapUrl, this.start})
      : super(flag, flag, textStyle, onTap: onTap);
  final ValueChanged<String> onTapUrl;

  static const String flag = '!@TURL#*&\$';
  final int? start;

  @override
  InlineSpan finishText() {
    final String text = getContent();
    final isValidUrl = TencentCloudChatUtils.urlReg.hasMatch(text);
    return isValidUrl
        ? SpecialTextSpan(
            text: text,
            actualText: toString(),
            start: start!,

            ///caret can move into special text
            deleteAll: true,
            style: const TextStyle(color: Colors.blueAccent),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                onTapUrl(text);
              },
          )
        : TextSpan(text: toString(), style: textStyle);
  }
}

String getMarkDownStringData({
  required bool hasStickerPlugin,
  String? text,
  TencentCloudChatPlugin? stickerPluginInstance,
}) {
  final formattedText = _addSpaceAfterLeftBracket(_addSpaceBeforeHttp(_replaceSingleNewlineWithTwo(text ?? "")));
  if (hasStickerPlugin) {
    if (stickerPluginInstance != null) {
      var data =
          stickerPluginInstance.callMethodSync(methodName: "replaceTextToMarkDownData", data: formattedText);
      if (data.containsKey('text')) {
        return data["text"];
      }
    }
  }
  return formattedText;
}


String _addSpaceAfterLeftBracket(String inputText) {
  return inputText.splitMapJoin(
    RegExp(r'<\w+[^<>]*>'),
    onMatch: (match) {
      return match.group(0)!.replaceFirst('<', '< ');
    },
    onNonMatch: (text) => text,
  );
}

String _replaceSingleNewlineWithTwo(String inputText) {
  return inputText.split('\n').join('\n\n');
}

String _addSpaceBeforeHttp(String inputText) {
  return inputText.splitMapJoin(
    RegExp(r'http'),
    onMatch: (match) {
      return ' http';
    },
    onNonMatch: (text) => text,
  );
}