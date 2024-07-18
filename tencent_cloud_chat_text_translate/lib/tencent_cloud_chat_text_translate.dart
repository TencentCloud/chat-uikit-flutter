library tencent_cloud_chat_text_translate;

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_text_translate/translate.dart';

class TencentCloudChatTranslateMethodName {
  static const String setTranslateLanguage = "setTranslateLanguage";
  static const String setTranslateBoxStyle = "setTranslateBoxStyle";
  static const String checkTranslateEnable = "checkTranslateEnable";
}

class TencentCloudChatTextTranslate extends TencentCloudChatPlugin {
  static String? _sourceLanguage;
  static String? _targetLanguate;
  static BoxDecoration? _decoration;
  static TextStyle? _textStyle;
  static EdgeInsetsGeometry? _padding;
  static bool Function(
          String? groupID, String? userID, String? topicID, String? text)?
      _enableTranslate;
  static Function()? _onTranslateSuccess;
  static Function()? _onTranslateFailed;

  TencentCloudChatTextTranslate._internal();
  factory TencentCloudChatTextTranslate({
    String? sourceLanguage,
    String? targetLanguate,
    BoxDecoration? boxDecoration,
    TextStyle? translateTextStyle,
    EdgeInsetsGeometry? boxPadding,
    Function()? onTranslateFailed,
    Function()? onTranslateSuccess,
    bool Function(
            String? groupID, String? userID, String? topicID, String? text)?
        enableTranslate,
  }) {
    _sourceLanguage = sourceLanguage;
    _targetLanguate = targetLanguate;
    _decoration = boxDecoration;
    _textStyle = translateTextStyle;
    _padding = boxPadding;
    _enableTranslate = enableTranslate;
    _onTranslateSuccess = onTranslateSuccess;
    _onTranslateFailed = onTranslateFailed;
    return _instance;
  }

  static final TencentCloudChatTextTranslate _instance =
      TencentCloudChatTextTranslate._internal();
  @override
  Future<Map<String, dynamic>> callMethod(
      {required String methodName, String? data}) {
    // TODO: implement callMethod
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> callMethodSync(
      {required String methodName, String? data, Map? methodValue}) {
    if (methodName ==
        TencentCloudChatTranslateMethodName.setTranslateLanguage) {
      final {
        "sourceLanguage": sourceLanguage,
        "targetLanguage": targetLanguage,
      } = methodValue ?? {};
      _sourceLanguage = sourceLanguage;
      _targetLanguate = targetLanguage;
    }

    if (methodName ==
        TencentCloudChatTranslateMethodName.setTranslateBoxStyle) {
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
        TencentCloudChatTranslateMethodName.checkTranslateEnable) {
      final {
        "groupID": groupID,
        "topicID": topicID,
        "userID": userID,
        "message": textMessage,
      } = methodValue ?? {};
      if (_enableTranslate != null) {
        return {
          "enable": _enableTranslate!(groupID, userID, topicID, textMessage),
        };
      }
    }

    return {
      "sourceLanguage": _sourceLanguage,
      "targetLanguage": _targetLanguate,
      "enable": true,
    };
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
      Map<String, TencentCloudChatPluginTapFn>? fns}) {
    final {
      "text": text,
      "targetLanguage": targetLanguage,
    } = data ?? {};
    return TencentCloudChatTranslate(
        onTranslateFailed: _onTranslateFailed,
        onTranslateSuccess: _onTranslateSuccess,
        sourceText: text,
        targetLanguage: _targetLanguate ?? targetLanguage,
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
    // TODO: implement unInit
    throw UnimplementedError();
  }
}
