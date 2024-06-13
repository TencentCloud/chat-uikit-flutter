import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat/data/theme/tencent_cloud_chat_theme_model.dart';
import 'package:tencent_cloud_chat/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

/// A class that manages the theme data for TencentCloudChat .
///
/// This class provides a singleton instance to manage the theme data
/// for the entire application. It includes the color theme and text styles
/// for both light and dark modes.
///
/// Example usage:
///
/// ```
/// // Initialize the theme data with the current BuildContext
/// TencentCloudChatTheme.init(context);
///
/// // Access the theme data in your widgets
/// Color primaryColor = TencentCloudChatTheme().colorTheme.primaryColor;
/// TextStyle textStyle = TencentCloudChatTheme().textStyle.standardText;
/// ```
class TencentCloudChatTheme {
  static TencentCloudChatTheme? _instance;
  late Brightness? _brightness;
  late TencentCloudChatThemeModel _themeModel;

  /// Private constructor to implement the singleton pattern.
  TencentCloudChatTheme._internal({
    TencentCloudChatThemeModel? themeModel,
    Brightness? brightness,
  }) {
    _brightness = brightness ?? WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _themeModel = themeModel ?? TencentCloudChatThemeModel();
  }

  /// Factory constructor that returns the singleton instance of TencentCloudChatTheme.
  factory TencentCloudChatTheme({
    TencentCloudChatThemeModel? themeMode,
    Brightness? brightness,
  }) {
    _instance ??= TencentCloudChatTheme._internal(themeModel: themeMode, brightness: brightness);
    return _instance!;
  }

  /// Initializes the theme data with the given BuildContext.
  static init({
    Brightness? brightness,
    TencentCloudChatThemeModel? themeModel,
  }) {
    if (brightness != null) {
      TencentCloudChatTheme().brightness = brightness;
    }
    if (themeModel != null) {
      TencentCloudChatTheme().themeModel = themeModel;
    }
  }

  /// Getter for the theme model.
  TencentCloudChatThemeModel get themeModel => _themeModel;

  /// Setter for the theme model.
  set themeModel(TencentCloudChatThemeModel value) {
    _themeModel = value;
    TencentCloudChat.instance.eventBusInstance.fire(this, "TencentCloudChatTheme");
  }

  /// Getter for the color theme based on the current brightness.
  TencentCloudChatThemeColors get colorTheme =>
      _brightness == Brightness.light ? _themeModel.lightTheme : _themeModel.darkTheme;

  /// Getter for the text style.
  TencentCloudChatTextStyle get textStyle => _themeModel.textStyle;

  /// Getter for the brightness.
  Brightness? get brightness => _brightness;

  /// Setter for the brightness.
  set brightness(Brightness? value) {
    _brightness = value;
    TencentCloudChat.instance.eventBusInstance.fire(this, "TencentCloudChatTheme");
  }

  set brightnessWithoutFire(Brightness? value) {
    _brightness = value;
  }

  /// Toggles the brightness mode between light and dark.
  void toggleBrightnessMode({Brightness? brightness}) {
    _brightness = brightness ?? (_brightness == Brightness.light ? Brightness.dark : Brightness.light);
    TencentCloudChat.instance.eventBusInstance.fire(this, "TencentCloudChatTheme");
  }

  /// Sets the theme colors for the specified brightness.
  void setThemeColors({
    required Brightness brightness,
    required TencentCloudChatThemeColors themeColors,
  }) {
    if (brightness == Brightness.light) {
      _themeModel.lightTheme = themeColors;
    } else {
      _themeModel.darkTheme = themeColors;
    }
    TencentCloudChat.instance.eventBusInstance.fire(this, "TencentCloudChatTheme");
  }

  /// Sets the global text style
  void setTextStyle({required TencentCloudChatTextStyle textStyle}) {
    _themeModel.textStyle = textStyle;
    TencentCloudChat.instance.eventBusInstance.fire(this, "TencentCloudChatTheme");
  }

  /// Returns a ThemeData instance based on the current brightness and configuration.
  ThemeData getThemeData({
    required BuildContext context,
    Brightness? brightness,
    bool needTextTheme = true,
    bool needColorScheme = true,
  }) {
    Brightness? br = brightness ?? _brightness;
    if (br == null) {
      try {
        br = Theme.of(context).brightness;
      } catch (e) {
        br = Brightness.light;
      }
    }

    TencentCloudChatThemeColors colorTheme = (br == Brightness.light ? _themeModel.lightTheme : _themeModel.darkTheme);

    return ThemeData(
      useMaterial3: true,
      textTheme: needTextTheme
          ? TextTheme(
              bodyLarge:
                  TextStyle(color: colorTheme.primaryTextColor, fontSize: _themeModel.textStyle.standardLargeText),
              bodyMedium: TextStyle(color: colorTheme.primaryTextColor, fontSize: _themeModel.textStyle.standardText),
              bodySmall:
                  TextStyle(color: colorTheme.primaryTextColor, fontSize: _themeModel.textStyle.standardSmallText),
            )
          : null,
      colorScheme: needColorScheme ? colorTheme.toColorScheme(br) : null,
    );
  }
}
