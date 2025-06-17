import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';

// This widget represents a single chat message in Tencent Cloud Chat.
abstract class TencentCloudChatMessageItemBase extends StatefulWidget {
  final MessageItemBuilderData data;
  final MessageItemBuilderMethods methods;

  const TencentCloudChatMessageItemBase({
    Key? key,
    required this.data,
    required this.methods,
  }) : super(key: key);
}

// This is the state class for TencentCloudChatMessageWidget.
// It manages the message highlighting animation and listens for changes in message data.
abstract class TencentCloudChatMessageState<T extends TencentCloudChatMessageItemBase> extends TencentCloudChatState<T> {
  final String _tag = "TencentCloudChatMessageState";
  // A flag indicating whether the message was sent by the current user.
  bool sentFromSelf = false;

  // A flag indicating whether the message is currently highlighted.
  bool showHighlightStatus = false;

  // A flag indicating whether the highlighting animation is currently running.
  bool isAnimating = false;

  // A flag indicating whether the message was in a group.
  bool isGroupMessage = false;

  // A flag indicting whether the message was read by others.
  bool showReadByOthersStatus = false;

  final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
  // log for this components
  void consoleLog(String logs) {
    TencentCloudChat.instance.logInstance.console(componentName: _tag, logs: logs);
  }

  // This method starts the message highlighting animation.
  void _startMessageHighlightAnimation() {
    // Return early if the animation is already running or the message shouldn't be highlighted.
    if ((isAnimating || !widget.data.shouldBeHighlighted)) {
      widget.methods.clearHighlightFunc();
      return;
    }

    // Start the highlighting animation.
    isAnimating = true;
    int highlightCount = 6;
    setState(() {
      showHighlightStatus = true;
    });

    // Create a timer to periodically update the highlighting state.
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          showHighlightStatus = highlightCount.isOdd;
        });
      }

      // Stop the timer and animation when the highlight count reaches zero or the widget is no longer mounted.
      if (highlightCount == 0 || !mounted) {
        isAnimating = false;
        timer.cancel();
      }

      highlightCount--;
    });

    // Reset the message highlighted value after a short delay.
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.methods.clearHighlightFunc();
    });
  }

  Widget _renderSendingStatus(TencentCloudChatThemeColors colorTheme) {
      return Container(
        margin: const EdgeInsets.only(right: 6),
        width: 12.0,
        height: 12.0,
        child: CircularProgressIndicator(
          strokeWidth: 1.0,
          color: colorTheme.secondaryTextColor,
        ),
      );
  }

  void _showResendDialog() {
    TencentCloudChatDialog.showAdaptiveDialog(
      context: context,
      title: Text(tL10n.resendTips),
      actions: <Widget>[
        TextButton(
          child: Text(tL10n.cancel),
          onPressed: () =>
              Navigator.of(context).pop(), // 关闭对话框
        ),
        TextButton(
          child: Text(tL10n.confirm),
          onPressed: () {
            //关闭对话框并返回true
            Navigator.of(context).pop(true);
            widget.methods.onResendMessage?.call();
          },
        ),
      ],
    );
  }

  Widget messageStatusIndicator() {
    return GestureDetector(
      onTap: () {
        if (widget.data.message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL) {
          _showResendDialog();
        }
      },
      child: widget.data.showMessageStatusIndicator
        ? TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) {
              IconData? iconData;
              Color? iconColor = colorTheme.messageStatusIconColor;
              double iconSize = textStyle.standardText;

              if (widget.data.message.status == MessageStatus.V2TIM_MSG_STATUS_SENDING) {
                return _renderSendingStatus(colorTheme);
              }

              switch (widget.data.message.status) {
                case MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL:
                  iconData = Icons.error;
                  iconColor = colorTheme.error;
                  break;
                case MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC:
                  iconData = showReadByOthersStatus ? Icons.done_all : Icons.done;
                  break;
                case MessageStatus.V2TIM_MSG_STATUS_HAS_DELETED:
                case MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED:
                default:
                  iconData = Icons.done;
                  iconColor = colorTheme.secondaryTextColor;
              }

              return Container(
                margin: const EdgeInsets.only(right: 4),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: iconSize,
                ),
              );
            },
          )
        : Container(),
    );
  }

  Widget messageTimeIndicator({
    Color? textColor,
    double? fontSize,
    List<Shadow>? shadow,
  }) {
    return widget.data.showMessageTimeIndicator
        ? TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => Text(
              TencentCloudChatIntl.formatTimestampToTime(widget.data.message.timestamp ?? 0),
              style: TextStyle(
                color: textColor ?? colorTheme.secondaryTextColor.withOpacity(0.6),
                fontSize: fontSize ?? textStyle.standardSmallText,
                fontWeight: FontWeight.w400,
                shadows: shadow,
              ),
            ),
          )
        : Container();
  }

  Widget messageReactionList() {
    return TencentCloudChatUtils.checkString(widget.data.message.msgID) != null
        ? TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) {
              final Map<String, String> data = {};
              data["primaryColor"] = colorTheme.primaryColor.value.toString();
              data["borderColor"] = colorTheme.dividerColor.value.toString();
              data["textColor"] = colorTheme.secondaryTextColor.value.toString();
              data["msgID"] = widget.data.message.msgID!;
              data["platformMode"] = isDesktopScreen ? "desktop" : "mobile";
              return widget.data.messageReactionPluginInstance?.getWidgetSync(
                    methodName: "messageReactionList",
                    data: data,
                  ) ??
                  const SizedBox(
                    width: 0,
                    height: 0,
                  );
            },
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }

  Widget messageReactionSelector() {
    return TencentCloudChatUtils.checkString(widget.data.message.msgID) != null
        ? TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) {
              final Map<String, String> data = {};
              data["msgID"] = widget.data.message.msgID!;
              data["platformMode"] = isDesktopScreen ? "desktop" : "mobile";
              return widget.data.messageReactionPluginInstance!.getWidgetSync(
                    methodName: "messageReactionSelector",
                    data: data,
                  ) ??
                  const SizedBox(
                    width: 0,
                    height: 0,
                  );
            },
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }

  // Initialize the state.
  @override
  void initState() {
    super.initState();
    sentFromSelf = widget.data.message.isSelf ?? false;
    isGroupMessage = TencentCloudChatUtils.checkString(widget.data.message.groupID) != null;
    showReadByOthersStatus = isGroupMessage ? (widget.data.messageReceipt != null && (widget.data.messageReceipt!.readCount ?? 0) > 0) : (widget.data.message.isPeerRead ?? false);

    // Start the message highlighting animation if the message should be highlighted.
    if (widget.data.shouldBeHighlighted) {
      consoleLog("shouldBeHighlighted true in initstate");
      _startMessageHighlightAnimation();
    }
  }

  // This method is called when the widget configuration changes.
  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the shouldBeHighlighted property has changed to true, start the highlighting animation.
    if (!oldWidget.data.shouldBeHighlighted && widget.data.shouldBeHighlighted) {
      consoleLog("shouldBeHighlighted true");
      _startMessageHighlightAnimation();
    }

    sentFromSelf = widget.data.message.isSelf ?? false;
    isGroupMessage = TencentCloudChatUtils.checkString(widget.data.message.groupID) != null;
    showReadByOthersStatus = isGroupMessage ? (widget.data.messageReceipt != null && (widget.data.messageReceipt!.readCount ?? 0) > 0) : (widget.data.message.isPeerRead ?? false);
  }

}
