library tencent_cloud_chat_sound_to_text;

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sound_to_text/sound_to_text.dart';

class TencentCloudChatSoundToTextMethodName {
  static const String setTranslateLanguage = "setTranslateLanguage";
  static const String setTranslateBoxStyle = "setTranslateBoxStyle";
}

class TencentCloudChatSoundToText extends TencentCloudChatPlugin {
  static final TencentCloudChatSoundToText _instance =
      TencentCloudChatSoundToText._internal();

  static Function()? _onTranslateSuccess;
  static Function()? _onTranslateFailed;
  static BoxDecoration? _decoration;
  static TextStyle? _textStyle;
  static EdgeInsetsGeometry? _padding;
  static String _sourceLanguage = "";

  TencentCloudChatSoundToText._internal();
  factory TencentCloudChatSoundToText({
    Function()? onTranslateFailed,
    Function()? onTranslateSuccess,
  }) {
    _onTranslateSuccess = onTranslateSuccess;
    _onTranslateFailed = onTranslateFailed;
    return _instance;
  }

  @override
  Future<Map<String, dynamic>> callMethod(
      {required String methodName, String? data}) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> callMethodSync(
      {required String methodName, String? data, Map? methodValue}) {
    if (methodName ==
        TencentCloudChatSoundToTextMethodName.setTranslateBoxStyle) {
      final {
        "boxDecoration": boxDecoration,
        "boxPadding": boxPadding,
        "translateTextStyle": translateTextStyle,
      } = methodValue ?? {};
      _decoration = boxDecoration;
      _padding = boxPadding;
      _textStyle = translateTextStyle;
    }
    if (methodName ==
        TencentCloudChatSoundToTextMethodName.setTranslateLanguage) {
      _sourceLanguage = data ?? "";
    }
    return {};
  }

  @override
  TencentCloudChatPlugin getInstance() {
    return _instance;
  }

  @override
  Future<Widget?> getWidget(
      {required String methodName,
      Map<String, String>? data,
      Map<String, TencentCloudChatPluginTapFn>? fns}) {
    throw UnimplementedError();
  }

  @override
  Widget? getWidgetSync(
      {required String methodName,
      Map<String, String>? data,
      Map<String, TencentCloudChatPluginTapFn>? fns,
      Function()? onTranslateFailed,
      Function()? onTranslateSuccess,
      bool? hasFailed = false,}) {
    final {
      "msgID": msgID,
      "language": language,
    } = data ?? {};

    return TencentCloudChatTranslate(
        key: hasFailed! ? UniqueKey() : null,
        onTranslateFailed: onTranslateFailed ?? _onTranslateFailed,
        onTranslateSuccess: onTranslateSuccess ?? _onTranslateSuccess,
        language: language ?? _sourceLanguage,
        msgID: msgID,
        decoration: _decoration,
        padding: _padding,
        textStyle: _textStyle);
  }

  @override
  Future<Map<String, dynamic>> init(String? data) {
    return Future.value({});
  }

  @override
  Future<Map<String, dynamic>> unInit(String? data) {
    return Future.value({});
  }
}
