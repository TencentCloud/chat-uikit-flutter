// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

enum DeviceType { Desktop, Mobile }

class FormFactor {
  static double desktop = 900;
  static double handset = 300;
}

class TUIKitScreenUtils {
  static DeviceType? deviceType;

  /// Although specifying the `BuildContext` is optional, providing it can prevent layout issues when this widget renders immediately after the app launch.
  /// If this widget needs to be used at the moment the app launches, it's recommended to provide the `BuildContext` here.
  static DeviceType getFormFactor([BuildContext? context]) {
    if (deviceType != null) return deviceType!;

    if (PlatformUtils().isWeb) {
      final win = WidgetsBinding.instance.platformDispatcher.views.first;
      final size = win.physicalSize;
      final screenWidth = size.width / win.devicePixelRatio;
      final screenHeight = size.height / win.devicePixelRatio;

      final diagonalInInches =
          sqrt(pow(screenWidth, 2) + pow(screenHeight, 2)) / 96.0;

      deviceType =  diagonalInInches < 11.0 ? DeviceType.Mobile : DeviceType.Desktop;
      return deviceType ?? DeviceType.Mobile;
    }else{
      if(context != null){
        double deviceWidth = MediaQuery.of(context).size.width;
        double deviceHeight = MediaQuery.of(context).size.height;

        if (deviceWidth > FormFactor.desktop || deviceWidth > deviceHeight * 1.1) {
          deviceType = DeviceType.Desktop;
        } else if (deviceWidth > FormFactor.handset) {
          deviceType = DeviceType.Mobile;
        }
        return deviceType ?? DeviceType.Mobile;
      }else{
        return DeviceType.Mobile;
      }
    }
  }

  static Widget getDeviceWidget({
    /// Although specifying the `BuildContext` is optional, providing it can prevent layout issues when this widget renders immediately after the app launch.
    /// If this widget needs to be used at the moment the app launches, it's recommended to provide the `BuildContext` here.
    BuildContext? context,
    required Widget defaultWidget,
    Widget? desktopWidget,
    Widget? mobileWidget,
  }) {
    deviceType ??= getFormFactor(context);
    if (deviceType == DeviceType.Desktop) return desktopWidget ?? defaultWidget;
    return mobileWidget ?? defaultWidget;
  }
}
