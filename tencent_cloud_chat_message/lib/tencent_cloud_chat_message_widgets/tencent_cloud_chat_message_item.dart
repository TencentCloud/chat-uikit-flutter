import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

// This widget represents a single chat message in Tencent Cloud Chat.
abstract class TencentCloudChatMessageItemBase extends StatefulWidget {
  /// The message itself.
  final V2TimMessage message;

  final String? userID;

  final String? groupID;

  /// A flag indicating whether the message should be highlighted.
  final bool shouldBeHighlighted;

  /// A callback function to clear the highlight.
  final VoidCallback clearHighlightFunc;

  /// The group message read receipt for this message.
  final V2TimMessageReceipt? messageReceipt;

  final SendingMessageData? sendingMessageData;

  /// The width of the message row, which represents the available width
  /// for displaying the message on the screen. This is useful for
  /// automatically wrapping text messages in a message bubble.
  final double messageRowWidth;

  final bool renderOnMenuPreview;

  final bool inSelectMode;
  final VoidCallback onSelectMessage;

  const TencentCloudChatMessageItemBase({
    Key? key,
    required this.message,
    required this.shouldBeHighlighted,
    required this.clearHighlightFunc,
    this.messageReceipt,
    required this.messageRowWidth,
    this.sendingMessageData,
    required this.renderOnMenuPreview,
    required this.inSelectMode,
    required this.onSelectMessage,
    this.userID,
    this.groupID,
  }) : super(key: key);
}

// This is the state class for TencentCloudChatMessageWidget.
// It manages the message highlighting animation and listens for changes in message data.
abstract class TencentCloudChatMessageState<
        T extends TencentCloudChatMessageItemBase>
    extends TencentCloudChatState<T> {
  // The unique ID of the message.
  String msgID = "";

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

  // This method starts the message highlighting animation.
  void _startMessageHighlightAnimation() {
    // Return early if the animation is already running or the message shouldn't be highlighted.
    if ((isAnimating || !widget.shouldBeHighlighted)) {
      widget.clearHighlightFunc();
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
      widget.clearHighlightFunc();
    });
  }

  Widget messageStatusIndicator() {
    final showMessageStatusIndicator = TencentCloudChat
        .dataInstance.basic.messageConfig
        .showMessageStatusIndicator(
      userID: widget.userID,
      groupID: widget.groupID,
    );

    return showMessageStatusIndicator
        ? TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) {
              IconData? iconData;
              Color? iconColor = colorTheme.messageStatusIconColor;
              double iconSize = textStyle.standardSmallText;

              switch (widget.message.status) {
                case MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL:
                  iconData = Icons.error;
                  iconColor = colorTheme.error;
                  break;
                case MessageStatus.V2TIM_MSG_STATUS_SENDING:
                  iconData = Icons.done;
                  iconColor = colorTheme.secondaryTextColor;
                case MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC:
                  iconData =
                      showReadByOthersStatus ? Icons.done_all : Icons.done;
                  break;
                case MessageStatus.V2TIM_MSG_STATUS_HAS_DELETED:
                case MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED:
                default:
                  return Container();
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
        : Container();
  }

  Widget messageTimeIndicator({
    Color? textColor,
    double? fontSize,
    List<Shadow>? shadow,
  }) {
    final showMessageTimeIndicator = TencentCloudChat
        .dataInstance.basic.messageConfig
        .showMessageTimeIndicator(
      userID: widget.userID,
      groupID: widget.groupID,
    );
    return showMessageTimeIndicator
        ? TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => Text(
              TencentCloudChatIntl.formatTimestampToTime(
                  widget.message.timestamp ?? 0),
              style: TextStyle(
                color: textColor ?? colorTheme.secondaryTextColor,
                fontSize: fontSize ?? textStyle.standardSmallText,
                shadows: shadow,
              ),
            ),
          )
        : Container();
  }

  // Initialize the state.
  @override
  void initState() {
    super.initState();
    msgID = widget.message.msgID ?? "";
    sentFromSelf = widget.message.isSelf ?? false;
    isGroupMessage =
        TencentCloudChatUtils.checkString(widget.message.groupID) != null;
    showReadByOthersStatus = isGroupMessage
        ? (widget.messageReceipt != null &&
            (widget.messageReceipt!.readCount ?? 0) > 0)
        : (widget.message.isPeerRead ?? false);

    // Start the message highlighting animation if the message should be highlighted.
    if (widget.shouldBeHighlighted) {
      _startMessageHighlightAnimation();
    }
  }

  // This method is called when the widget configuration changes.
  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the shouldBeHighlighted property has changed to true, start the highlighting animation.
    if (!oldWidget.shouldBeHighlighted && widget.shouldBeHighlighted) {
      _startMessageHighlightAnimation();
    }

    sentFromSelf = widget.message.isSelf ?? false;
    isGroupMessage =
        TencentCloudChatUtils.checkString(widget.message.groupID) != null;
    showReadByOthersStatus = isGroupMessage
        ? (widget.messageReceipt != null &&
            (widget.messageReceipt!.readCount ?? 0) > 0)
        : (widget.message.isPeerRead ?? false);
  }
}
