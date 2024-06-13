import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

/// A utility class for checking page routes behavior and add action for audio player for TencentCloudChat .
class TencentCloudChatObserver extends RouteObserver<PageRoute<dynamic>> {
  static final TencentCloudChatObserver _instance = TencentCloudChatObserver();
  static bool isClose = false;

  static TencentCloudChatObserver getInstance() {
    return _instance;
  }

  /// function handles audio in message when route changed
  void _handleRouteChanged(PageRoute<dynamic> route) {
    TencentCloudChat.instance.dataInstance.messageData.stopPlayAudio();
  }

  /// function for checking and handling routes `Push` behavior and stop playing audio.
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute<dynamic>) {
      _handleRouteChanged(route);
    }
  }

  /// function for checking and handling routes `Pop` behavior and stop playing audio.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute is PageRoute<dynamic>) {
      _handleRouteChanged(previousRoute);
    }
  }

  /// function for checking and handling routes `Replace route` behavior and stop playing audio.
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute<dynamic>) {
      _handleRouteChanged(newRoute);
    }
  }
}
