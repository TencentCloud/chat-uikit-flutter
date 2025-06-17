import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';

class TencentCloudChatMessageHeader extends StatefulWidget {
  final MessageHeaderBuilderWidgets widgets;
  final MessageHeaderBuilderData data;
  final MessageHeaderBuilderMethods methods;

  const TencentCloudChatMessageHeader({
    super.key,
    required this.widgets,
    required this.data,
    required this.methods,
  });

  @override
  State<TencentCloudChatMessageHeader> createState() =>
      _TencentCloudChatMessageHeaderState();
}

class _TencentCloudChatMessageHeaderState
    extends TencentCloudChatState<TencentCloudChatMessageHeader> {
  final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType ==
      DeviceScreenType.desktop;

  Widget buildNormalHeader(
      colorTheme, textStyle, V2TimConversation? conversation) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 8 : 0),
      child: Row(
        key: ValueKey<bool>(widget.data.inSelectMode),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                if (!isDesktop)
                  IconButton(
                      color: colorTheme.primaryColor,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded)),
                widget.widgets.messageHeaderProfileImage,
                SizedBox(
                  width: getWidth(isDesktop ? 12 : 8),
                ),
                Expanded(
                  child: widget.widgets.messageHeaderInfo,
                ),
              ],
            ),
          ),
          widget.widgets.messageHeaderActions,
        ],
      ),
    );
  }

  @override
  Widget tabletAppBuilder(BuildContext context) {
    return defaultBuilder(context);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + getSquareSize(8),
          left: getSquareSize(10),
          right: getSquareSize(10),
          bottom: widget.data.inSelectMode ? 0.0 : getSquareSize(10),
        ),
        decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(color: colorTheme.dividerColor)),
          color: colorTheme.backgroundColor,
        ),
        child: AnimatedSwitcher(
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.ease,
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: const Offset(0, 0),
              ).animate(animation),
              child: child,
            );
          },
          child: widget.data.inSelectMode
              ? widget.widgets.messageHeaderMessagesSelectMode
              : buildNormalHeader(colorTheme, textStyle, widget.data.conversation),
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: getSquareSize(10),
          vertical: getSquareSize(12),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colorTheme.dividerColor),
          ),
          color: colorTheme.backgroundColor,
        ),
        child: AnimatedSwitcher(
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.ease,
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: const Offset(0, 0),
              ).animate(animation),
              child: child,
            );
          },
          child: widget.data.inSelectMode
              ? widget.widgets.messageHeaderMessagesSelectMode
              : buildNormalHeader(colorTheme, textStyle, widget.data.conversation),
        ),
      ),
    );
  }
}
