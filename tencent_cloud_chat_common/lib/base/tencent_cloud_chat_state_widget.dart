import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/data/theme/tencent_cloud_chat_theme.dart';
import 'package:tencent_cloud_chat_common/eventbus/tencent_cloud_chat_eventbus.dart';
import 'package:tencent_cloud_chat_common/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

/// An abstract base class for the state of StatefulWidget in TencentCloudChat.instance.
///
/// This class extends the Flutter [State] class and provides a foundation for
/// managing theme data and screen types for the Chat UIKit widgets. It includes
/// methods for handling data changes and selecting appropriate widget
/// builders based on the current platform and screen type.
///
/// All widgets in the Chat UIKit should extend this class to ensure a consistent
/// appearance and behavior.
abstract class TencentCloudChatState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  // EventBus instance for the Chat UIKit
  TencentCloudChatEventBus eventbus = TencentCloudChat.instance.eventBusInstance;

  // Listener for theme data changes
  Stream<TencentCloudChatTheme>? themeDataListener = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatTheme>("TencentCloudChatTheme");

  // Ticker for FPS monitoring
  Ticker? _fpsTicker;

  // Frame counter for FPS calculation
  int _frameCount = 0;

  // Stopwatch for measuring elapsed time between FPS calculations
  Stopwatch? _stopwatch;

  // Flag to determine if FPS monitoring is needed
  final bool _needFPSMonitor;

  // Constructor for TencentCloudChatState
  // [needFPSMonitor]: Optional parameter to enable or disable FPS monitoring, defaults to false
  TencentCloudChatState({bool needFPSMonitor = false}) : _needFPSMonitor = needFPSMonitor;

  void safeSetState(VoidCallback fn) {
    try {
      if (mounted) {
        setState(fn);
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_needFPSMonitor && (kDebugMode || kProfileMode)) {
      startFPSMonitor();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TencentCloudChat.instance.chatController.initGlobalAdapterInBuildPhase(context);
  }

  @override
  void dispose() {
    super.dispose();
    _fpsTicker?.dispose();
    _stopwatch?.stop();
    WidgetsBinding.instance.removeObserver(this);
  }

  void startFPSMonitor() {
    // Initialize the stopwatch for FPS calculation and start it
    _stopwatch = Stopwatch();
    _stopwatch?.start();

    // Initialize the FPS ticker with a callback that increments the frame counter
    // and calculates the FPS every second
    _fpsTicker = Ticker((Duration elapsed) {
      // Increment the frame counter
      _frameCount++;

      // If one second has passed, calculate and print the FPS
      if (_stopwatch!.elapsedMilliseconds >= 1000) {
        int fps = (_frameCount / (_stopwatch!.elapsedMilliseconds / 1000)).ceil();
        if (fps < 40) {
          TencentCloudChat.instance.logInstance.console(
            logs: 'FPS: $fps',
            componentName: runtimeType.toString(),
            logLevel: TencentCloudChatLogLevel.error,
          );
        }

        // Reset the frame counter and stopwatch for the next FPS calculation
        _frameCount = 0;
        _stopwatch!.reset();
        _stopwatch!.start();
      }
    });

    // Start the FPS ticker
    _fpsTicker!.start();
  }

  // Get Adapter width
  double getWidth(double width) {
    return TencentCloudChatScreenAdapter.getWidth(width);
  }

  // Get Adapter height
  double getHeight(double height) {
    return TencentCloudChatScreenAdapter.getHeight(height);
  }

  // Get Adapter square size
  double getSquareSize(double height) {
    return TencentCloudChatScreenAdapter.getSquareSize(height);
  }

  // Get Adapter FontSize
  double getFontSize(double fontSize) {
    return TencentCloudChatScreenAdapter.getFontSize(fontSize);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
    final isMobileScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.mobile;

    // Select the appropriate builder based on the current platform and screen type
    if (TencentCloudChatPlatformAdapter().isWeb && isDesktopScreen) {
      final testBuild = desktopWebBuilder(context);
      if(testBuild != null){
        return testBuild;
      }
    }

    if (TencentCloudChatPlatformAdapter().isWeb && isMobileScreen) {
      final testBuild = mobileWebBuilder(context);
      if(testBuild != null){
        return testBuild;
      }
    }

    if (TencentCloudChatPlatformAdapter().isMobile && isDesktopScreen) {
      final testBuild = tabletAppBuilder(context);
      if(testBuild != null){
        return testBuild;
      }
    }

    if (TencentCloudChatPlatformAdapter().isMobile) {
      final testBuild = mobileAppBuilder(context);
      if(testBuild != null){
        return testBuild;
      }
    }

    if (TencentCloudChatPlatformAdapter().isDesktop) {
      final testBuild = desktopAppBuilder(context);
      if(testBuild != null){
        return testBuild;
      }
    }

    if (TencentCloudChatPlatformAdapter().isWeb) {
      final testBuild = webBuilder(context);
      if(testBuild != null){
        return testBuild;
      }
    }

    if (isMobileScreen) {
      final testBuild = mobileBuilder(context);
      if(testBuild != null){
        return testBuild;
      }
    }

    if (isDesktopScreen) {
      final testBuild = desktopBuilder(context);
      if(testBuild != null){
        return testBuild;
      }
    }
    return defaultBuilder(context);
  }

  /// Default builder for the widget, which is necessary and must been override.
  Widget defaultBuilder(BuildContext context);

  // Optional builders for different platforms and screen types

  /// Builder for desktop web platform.
  ///
  /// Use this builder to customize the widget appearance and behavior specifically for desktop web.
  Widget? desktopWebBuilder(BuildContext context) => null;

  /// Builder for mobile web platform.
  ///
  /// Use this builder to customize the widget appearance and behavior specifically for mobile web.
  Widget? mobileWebBuilder(BuildContext context) => null;

  /// Builder for mobile app platform (Android and iOS).
  ///
  /// Use this builder to customize the widget appearance and behavior specifically for mobile apps.
  Widget? mobileAppBuilder(BuildContext context) => null;

  /// Builder for desktop app platform (Windows, macOS, and Linux).
  ///
  /// Use this builder to customize the widget appearance and behavior specifically for desktop apps.
  Widget? desktopAppBuilder(BuildContext context) => null;

  /// Builder for tablets app platform (iPad, Android Tablets, etc.).
  ///
  /// Use this builder to customize the widget appearance and behavior specifically for tablets apps.
  Widget? tabletAppBuilder(BuildContext context) => null;

  /// Builder for web platform (both desktop and mobile web).
  ///
  /// Use this builder to customize the widget appearance and behavior for web platform in general.
  Widget? webBuilder(BuildContext context) => null;

  /// Builder for mobile platform (both mobile app and mobile web).
  ///
  /// Use this builder to customize the widget appearance and behavior for mobile platform in general.
  Widget? mobileBuilder(BuildContext context) => null;

  /// Builder for desktop platform (both desktop app and desktop web).
  ///
  /// Use this builder to customize the widget appearance and behavior for desktop platform in general.
  Widget? desktopBuilder(BuildContext context) => null;
}
