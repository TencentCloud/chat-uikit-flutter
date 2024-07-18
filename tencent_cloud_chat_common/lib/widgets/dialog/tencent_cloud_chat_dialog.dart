import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';

class TencentCloudChatDialog{
  static void showCustomDialog({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
    String title = "",
    bool? barrierDismissible,
    bool? showCloseBtn,
    bool? autoScroll,
    double? containerMaxHeight,
    double? containerMaxWidth,
    EdgeInsets? containerPadding,
    double? contentMaxHeight,
    double? contentMaxWidth,
    Color? backgroundColor,
  }) {
     showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: (c) {
          return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10)),
                constraints:  BoxConstraints(
                        maxHeight: containerMaxHeight ?? 604,
                        maxWidth: containerMaxWidth ?? 490),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            if ((showCloseBtn ?? true)) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(10),
                            child: (showCloseBtn ?? true)
                                ? const Icon(
                                    Icons.close_outlined,
                                    size: 14,
                                    color: Color(0xff888888),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    if (title.isNotEmpty)
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xff333333)),
                        ),
                      ),
                    Container(
                      padding: containerPadding ?? const EdgeInsets.all(20),
                      constraints: BoxConstraints(
                          maxHeight: contentMaxHeight ?? 520,
                          maxWidth: contentMaxWidth ?? 502),
                      child: builder(c),
                    )
                  ],
                ),
              ));
        });
  }

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