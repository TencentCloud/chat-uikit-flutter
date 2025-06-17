import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';

class TencentCloudChatGestureColors {
  Color? focusColor;
  Color? hoverColor;
  Color? highlightColor;
  Color? splashColor;
  TencentCloudChatGestureColors({
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.splashColor,
  });
}

typedef OnTap = void Function();

class TencentCloudChatGesture extends StatefulWidget {
  final Widget child;
  final TencentCloudChatGestureColors? gestureColors;
  final OnTap? onTap;
  final Function(TapDownDetails)? onSecondaryTapDown;
  const TencentCloudChatGesture({
    super.key,
    required this.child,
    this.gestureColors,
    this.onTap,
    this.onSecondaryTapDown,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatGestureState();
}

class TencentCloudChatGestureState extends State<TencentCloudChatGesture> {
  TencentCloudChatGestureColors getDefaultColors() {
    Color focusColor =
        widget.gestureColors?.focusColor ?? const Color.fromARGB(8, 0, 0, 0);
    Color hoverColor =
        widget.gestureColors?.focusColor ?? const Color.fromARGB(8, 0, 0, 0);
    Color highlightColor =
        widget.gestureColors?.focusColor ?? const Color.fromARGB(8, 0, 0, 0);
    Color splashColor =
        widget.gestureColors?.focusColor ?? const Color.fromARGB(8, 0, 0, 0);
    return TencentCloudChatGestureColors(
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    TencentCloudChatGestureColors colors = getDefaultColors();

    return InkWell(
      onTap: widget.onTap,
      onSecondaryTapDown: widget.onSecondaryTapDown,
      focusColor: colors.focusColor,
      hoverColor: colors.hoverColor,
      highlightColor: colors.highlightColor,
      splashColor: !TencentCloudChatPlatformAdapter().isWeb && TencentCloudChatPlatformAdapter().isAndroid
          ? colors.splashColor
          : Colors.transparent, // this field on used on android
      child: widget.child,
    );
  }
}
