import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat/data/theme/tencent_cloud_chat_theme.dart';
import 'package:tencent_cloud_chat/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatThemeWidget extends StatefulWidget {
  final Widget Function(BuildContext, TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) build;

  const TencentCloudChatThemeWidget({super.key, required this.build});

  @override
  State<TencentCloudChatThemeWidget> createState() => _TencentCloudChatThemeWidgetState();
}

class _TencentCloudChatThemeWidgetState extends State<TencentCloudChatThemeWidget> {
  // Theme instance for the Chat UIKit

  // Color theme based on the current brightness mode
  TencentCloudChatThemeColors _colorTheme = TencentCloudChatData.theme.colorTheme;

  // Text styles for the Chat UIKit
  TencentCloudChatTextStyle _textStyle = TencentCloudChatData.theme.textStyle;

  // Listener for theme data changes
  final Stream<TencentCloudChatTheme>? _themeDataStream = TencentCloudChat.eventBusInstance.on<TencentCloudChatTheme>();

  late StreamSubscription<TencentCloudChatTheme>? _themeDataSubscription;

  // Callback for handling theme data changes
  void themeDataChangeHandler(TencentCloudChatTheme themeData) {
    final color = themeData.colorTheme;
    final text = themeData.textStyle;

    setState(() {
      _colorTheme = color;
      _textStyle = text;
    });
  }

  // Adds a handler for theme data changes
  void addThemeDataChangeHandler() {
    _themeDataSubscription = _themeDataStream?.listen(
      themeDataChangeHandler,
    );
  }

  @override
  void initState() {
    super.initState();
    addThemeDataChangeHandler();
  }

  @override
  void dispose() {
    _themeDataSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, _colorTheme, _textStyle);
  }
}
