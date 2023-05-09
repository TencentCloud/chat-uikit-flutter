// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';

enum DeviceType { Desktop, Mobile }

class FormFactor {
  static double desktop = 900;
  static double handset = 300;
}

class TUIKitScreenUtils {
  static DeviceType? deviceType;

  static DeviceType getFormFactor([BuildContext? context]) {
    if (deviceType != null) return deviceType!;

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

  static Widget getDeviceWidget({
    required Widget defaultWidget,
    Widget? desktopWidget,
    Widget? mobileWidget,
  }) {
    if (deviceType == DeviceType.Desktop) return desktopWidget ?? defaultWidget;
    return mobileWidget ?? defaultWidget;
  }
}
