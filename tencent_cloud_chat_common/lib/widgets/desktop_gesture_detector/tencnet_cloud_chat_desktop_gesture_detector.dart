import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';

class TencentCloudChatDesktopGestureDetector extends StatefulWidget {
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onSecondaryTapDown;
  final Widget? child;

  const TencentCloudChatDesktopGestureDetector(
      {super.key, this.onTap, this.onSecondaryTapDown, this.child});

  @override
  State<TencentCloudChatDesktopGestureDetector> createState() =>
      _TencentCloudChatDesktopGestureDetectorState();
}

class _TencentCloudChatDesktopGestureDetectorState
    extends TencentCloudChatState<TencentCloudChatDesktopGestureDetector> {
  Timer? _longPressTimer;

  @override
  void dispose() {
    _removeTimer();
    super.dispose();
  }

  void _removeTimer() {
    if (_longPressTimer != null) {
      _longPressTimer?.cancel();
      _longPressTimer = null;
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: widget.onSecondaryTapDown,
      child: widget.child,
    );
  }

  @override
  Widget tabletAppBuilder(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        _removeTimer();
        _longPressTimer = Timer(const Duration(milliseconds: 200), () {
          widget.onSecondaryTapDown?.call(TapDownDetails(
            globalPosition: details.globalPosition,
            localPosition: details.localPosition,
          ));
          _removeTimer();
        });
      },
      onLongPressEnd: (_) {
        _removeTimer();
      },
      child: widget.child,
    );
  }
}
