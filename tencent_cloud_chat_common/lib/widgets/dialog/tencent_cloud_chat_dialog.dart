import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';

class TencentCloudChatDialog{
  static void showAdaptiveDialog({
    required BuildContext context,
    Key? key,
    Widget? title,
    String? barrierLabel,
    bool useRootNavigator = true,
    bool barrierDismissible = false,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    Widget? content,
    List<Widget> actions = const <Widget>[],
    ScrollController? scrollController,
    ScrollController? actionScrollController,
    Duration insetAnimationDuration = const Duration(milliseconds: 100),
    Curve insetAnimationCurve = Curves.decelerate,
  }){
    if(TencentCloudChatPlatformAdapter().isIOS || TencentCloudChatPlatformAdapter().isMacOS){
      showCupertinoDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        barrierLabel: barrierLabel,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
        builder: (_) => CupertinoAlertDialog(
          title: title,
          content: content,
          actions: actions,
          scrollController: scrollController,
          actionScrollController: actionScrollController,
          insetAnimationCurve: insetAnimationCurve,
          insetAnimationDuration: insetAnimationDuration,
          key: key,
        ),
      );
    } else{
      showDialog(
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        barrierLabel: barrierLabel,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
        context: context,
        builder: (_) => AlertDialog(
          title: title,
          content: content,
          actions: actions,
          key: key,
        ),
      );
    }
  }
}