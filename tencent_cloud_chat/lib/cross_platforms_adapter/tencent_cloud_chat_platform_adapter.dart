import 'dart:io';

import 'package:flutter/foundation.dart';

/// A utility class for detecting the current platform.
///
/// This class provides a singleton instance to detect the current platform
/// on which the application is running, such as Android, iOS, Windows, macOS,
/// Linux, or web.
class TencentCloudChatPlatformAdapter {
  /// Private constructor to implement the singleton pattern.
  TencentCloudChatPlatformAdapter._internal();

  static final TencentCloudChatPlatformAdapter _instance =
      TencentCloudChatPlatformAdapter._internal();

  static bool _hasInstantiation = false;

  static late bool _isAndroid;
  static late bool _isIos;
  static late bool _isMobile;
  static late bool _isWeb;
  static late bool _isWindows;
  static late bool _isMacOS;
  static late bool _isLinux;
  static late bool _isDesktop;

  /// Factory constructor that returns the singleton instance of TencentCloudChatUIKitPlatformAdapter.
  factory TencentCloudChatPlatformAdapter() {
    if (!_hasInstantiation) {
      _isAndroid = !kIsWeb && Platform.isAndroid;
      _isIos = !kIsWeb && Platform.isIOS;
      _isMobile = _isAndroid || _isIos;
      _isWindows = !kIsWeb && Platform.isWindows;
      _isMacOS = !kIsWeb && Platform.isMacOS;
      _isLinux = !kIsWeb && Platform.isLinux;
      _isDesktop = _isMacOS || _isWindows || _isLinux;
      _isWeb = kIsWeb;
      _hasInstantiation = true;
    }

    return _instance;
  }

  /// Getter for checking if the current platform is Android.
  bool get isAndroid => _isAndroid;

  /// Getter for checking if the current platform is web.
  bool get isWeb => _isWeb;

  /// Getter for checking if the current platform is iOS.
  bool get isIOS => _isIos;

  /// Getter for checking if the current platform is Windows.
  bool get isWindows => _isWindows;

  /// Getter for checking if the current platform is macOS.
  bool get isMacOS => _isMacOS;

  /// Getter for checking if the current platform is mobile (Android or iOS).
  bool get isMobile => _isMobile;

  /// Getter for checking if the current platform is desktop (macOS, Windows, or Linux).
  bool get isDesktop => _isDesktop;

  /// Getter for checking if the current platform is Linux.
  bool get isLinux => _isLinux;
}
