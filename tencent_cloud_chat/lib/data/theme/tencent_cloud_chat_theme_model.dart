// ignore_for_file: unnecessary_getters_setters

import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat/data/theme/color/dark.dart';
import 'package:tencent_cloud_chat/data/theme/color/light.dart';
import 'package:tencent_cloud_chat/data/theme/text_style/text_style.dart';

/// A class that contains the core theme model for TencentCloudChat .
class TencentCloudChatThemeModel {
  TencentCloudChatThemeColors _lightTheme;
  TencentCloudChatThemeColors _darkTheme;
  TencentCloudChatTextStyle _textStyle;

  /// Creates a new TencentCloudChatThemeModel with the given light and dark theme colors, and text styles.
  TencentCloudChatThemeModel({
    TencentCloudChatThemeColors? lightTheme,
    TencentCloudChatThemeColors? darkTheme,
    TencentCloudChatTextStyle? textStyle,
  })  : _textStyle = textStyle ?? TencentCloudChatTextStyle(),
        _darkTheme = darkTheme ?? DarkTencentCloudChatColors(),
        _lightTheme = lightTheme ?? LightTencentCloudChatColors();

  /// Getter for the light theme colors.
  TencentCloudChatThemeColors get lightTheme => _lightTheme;

  /// Setter for the light theme colors.
  set lightTheme(TencentCloudChatThemeColors value) {
    _lightTheme = value;
  }

  /// Getter for the dark theme colors.
  TencentCloudChatThemeColors get darkTheme => _darkTheme;

  /// Setter for the dark theme colors.
  set darkTheme(TencentCloudChatThemeColors value) {
    _darkTheme = value;
  }

  /// Getter for the text styles.
  TencentCloudChatTextStyle get textStyle => _textStyle;

  /// Setter for the text styles.
  set textStyle(TencentCloudChatTextStyle value) {
    _textStyle = value;
  }
}
