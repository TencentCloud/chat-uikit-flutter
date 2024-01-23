import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

class TencentCloudChatMessageText extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageText({
    super.key,
    required super.message,
    required super.shouldBeHighlighted,
    required super.clearHighlightFunc,
    super.messageReceipt,
    required super.messageRowWidth,
    super.sendingMessageData,
    required super.renderOnMenuPreview,
    required super.inSelectMode,
    required super.onSelectMessage,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageTextState();
}

class _TencentCloudChatMessageTextState
    extends TencentCloudChatMessageState<TencentCloudChatMessageText> {
  @override
  Widget defaultBuilder(BuildContext context) {
    final maxBubbleWidth = widget.messageRowWidth * 0.8;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(10), vertical: getHeight(8)),
        decoration: BoxDecoration(
            color: showHighlightStatus
                ? colorTheme.info
                : (sentFromSelf
                    ? colorTheme.selfMessageBubbleColor
                    : colorTheme.othersMessageBubbleColor),
            border: Border.all(
              color: sentFromSelf
                  ? colorTheme.selfMessageBubbleBorderColor
                  : colorTheme.othersMessageBubbleBorderColor,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSquareSize(16)),
              topRight: Radius.circular(getSquareSize(16)),
              bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
              bottomRight:
                  Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
            )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: min(
                      maxBubbleWidth * 0.9,
                      maxBubbleWidth -
                          getSquareSize(sentFromSelf ? 128 : 102))),
              child: Text(
                widget.message.textElem?.text ?? "",
                style: TextStyle(
                    color: sentFromSelf
                        ? colorTheme.selfMessageTextColor
                        : colorTheme.othersMessageTextColor,
                    fontSize: textStyle.messageBody),
              ),
            ),
            SizedBox(
              width: getWidth(4),
            ),
            if (sentFromSelf) messageStatus(),
            messageTimeIndicator(),
          ],
        ),
      );
    });
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    final maxBubbleWidth = widget.messageRowWidth * 0.8;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(10), vertical: getHeight(8)),
        decoration: BoxDecoration(
            color: showHighlightStatus
                ? colorTheme.info
                : (sentFromSelf
                    ? colorTheme.selfMessageBubbleColor
                    : colorTheme.othersMessageBubbleColor),
            border: Border.all(
              color: sentFromSelf
                  ? colorTheme.selfMessageBubbleBorderColor
                  : colorTheme.othersMessageBubbleBorderColor,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSquareSize(16)),
              topRight: Radius.circular(getSquareSize(16)),
              bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
              bottomRight:
                  Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
            )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: min(
                      maxBubbleWidth * 0.9,
                      maxBubbleWidth -
                          getSquareSize(sentFromSelf ? 128 : 102))),
              child: SelectableText(
                widget.message.textElem?.text ?? "",
                style: TextStyle(
                    color: sentFromSelf
                        ? colorTheme.selfMessageTextColor
                        : colorTheme.othersMessageTextColor,
                    fontSize: textStyle.messageBody),
              ),
            ),
            SizedBox(
              width: getWidth(4),
            ),
            if (sentFromSelf) messageStatus(),
            messageTimeIndicator(),
          ],
        ),
      );
    });
  }
}
