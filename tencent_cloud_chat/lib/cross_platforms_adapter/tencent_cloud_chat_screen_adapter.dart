import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// TencentCloudChatUIKitScreenAdapter is a utility class that helps to adapt the UI
/// for different screen sizes and device types (such as mobile and desktop).
/// It is based on the flutter_screenutil package and provides additional
/// functionality for handling different device types.
///
/// To use this class, follow these steps:
///
/// 1. Call the `TencentCloudChatUIKitScreenAdapter.init(context)` method in your
///    app's root widget. This will initialize the ScreenAdapter with the
///    appropriate design size based on the current device type.
///
/// 2. Use the `setWidth`, `setHeight`, and `setFontSize` methods provided by
///    the `TencentCloudChatUIKitScreenAdapter` class to set dimensions for your
///    widgets. These methods will automatically adapt the dimensions based on
///    the current device type and screen size.
///
/// Example usage:
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'tencent_cloud_chat_screen_adapter.dart';
///
/// void main() {
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Builder(
///         builder: (BuildContext context) {
///           // Initialize the TencentCloudChatUIKitScreenAdapter
///           TencentCloudChatUIKitScreenAdapter.init(context);
///
///           // Use the TencentCloudChatUIKitScreenAdapter to set dimensions
///           return Scaffold(
///             appBar: AppBar(
///               title: Text(
///                 'Flutter Screen Adapter',
///                 style: TextStyle(fontSize: TencentCloudChatUIKitScreenAdapter.setFontSize(18)),
///               ),
///             ),
///             body: Center(
///               child: Container(
///                 width: TencentCloudChatUIKitScreenAdapter.setWidth(200),
///                 height: TencentCloudChatUIKitScreenAdapter.setHeight(200),
///                 color: Colors.blue,
///               ),
///             ),
///           );
///         },
///       ),
///     );
///   }
/// }
class TencentCloudChatScreenAdapter {
  static DeviceScreenType? deviceScreenType;
  static bool hasInitialized = false;

  /// Initializes the ScreenAdapter with the appropriate design size
  /// based on the current device type.
  ///
  /// This method should be called in your app's root widget or the initializing process of this UIKit.
  static void init(BuildContext context) {
    if (hasInitialized) {
      return;
    }
    try {
      // Get the current device type
      deviceScreenType = _getDeviceType(context);

      // Get the screen width
      double screenWidth = MediaQuery.of(context).size.width;

      // Set the designSize based on the device type and screen width
      Size designSize;
      if (deviceScreenType == DeviceScreenType.desktop) {
        designSize = screenWidth > 960 ? const Size(1024, 768) : const Size(960, 640);
      } else {
        designSize = const Size(390, 844);
      }

      ScreenUtil.init(
        context,
        designSize: designSize,
      );
      hasInitialized = true;
    } catch (e) {
      hasInitialized = false;
    }
  }

  /// Returns the adapted width based on the current device type and screen size.
  static double getWidth(double width) {
    return width;
    // if (deviceScreenType == DeviceScreenType.desktop) {
    //   return width;
    // }
    // if (hasInitialized == false) {
    //   return width;
    // }
    // return ScreenUtil().setWidth(width);
  }

  /// Returns the adapted height based on the current device type and screen size.
  static double getHeight(double height) {
    return height;
    // if (deviceScreenType == DeviceScreenType.desktop) {
    //   return height;
    // }
    // if (hasInitialized == false) {
    //   return height;
    // }
    // return ScreenUtil().setHeight(height);
  }

  /// Returns the adapted font size based on the current device type and screen size.
  static double getFontSize(double fontSize) {
    return fontSize;
    // if (deviceScreenType == DeviceScreenType.desktop) {
    //   return fontSize;
    // }
    // if (hasInitialized == false) {
    //   return fontSize;
    // }
    // return ScreenUtil().setSp(fontSize);
  }

  /// Returns the size of a square based on the device type (desktop or mobile).
  ///
  /// This method ensures that the square maintains its aspect ratio and does not
  /// get stretched into a rectangle. It calculates the size of the square based
  /// on the device type. For desktop devices, it uses the height to determine
  /// the size, while for mobile devices, it uses the width.
  ///
  /// The [size] parameter represents the desired size of the square.
  static double getSquareSize(double size) {
    return size;
    // if (deviceScreenType == DeviceScreenType.desktop) {
    //   return size;
    // }
    // if (hasInitialized == false) {
    //   return size;
    // }
    // // Use the height for desktop devices and width for mobile devices
    // return deviceScreenType == DeviceScreenType.desktop
    //     ? getHeight(size)
    //     : getWidth(size);
  }

  /// Returns the adapted screen radius based on the current device type and screen size.
  static double Function(num r) get getRadius => ScreenUtil().radius;

  /// Returns the current screen width.
  static double get screenWidth => ScreenUtil().screenWidth;

  /// Returns the current screen height.
  static double get screenHeight => ScreenUtil().screenHeight;

  /// Returns the current status bar height.
  static double get statusBarHeight => ScreenUtil().statusBarHeight;

  /// Returns the current bottom bar height.
  static double get bottomBarHeight => ScreenUtil().bottomBarHeight;

  /// Helper method to get the current device type
  static DeviceScreenType _getDeviceType(BuildContext context) {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final win = WidgetsBinding.instance.platformDispatcher.views.first;
      final size = win.physicalSize;
      final screenWidth = size.width / win.devicePixelRatio;
      final screenHeight = size.height / win.devicePixelRatio;

      final diagonalInInches = sqrt(pow(screenWidth, 2) + pow(screenHeight, 2)) / 96.0;

      return diagonalInInches < 11 ? DeviceScreenType.mobile : DeviceScreenType.desktop;
    } else {
      double deviceWidth = MediaQuery.of(context).size.width;
      double deviceHeight = MediaQuery.of(context).size.height;

      if (deviceWidth > 900 || deviceWidth > deviceHeight * 1.1) {
        return DeviceScreenType.desktop;
      } else if (deviceWidth > 300) {
        return DeviceScreenType.mobile;
      }
      return DeviceScreenType.mobile;
    }
  }
}

enum DeviceScreenType { desktop, mobile }
