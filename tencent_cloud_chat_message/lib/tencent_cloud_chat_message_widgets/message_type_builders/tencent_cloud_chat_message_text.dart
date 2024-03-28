import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

class TencentCloudChatMessageText extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageText({
    super.key,
    super.userID,
    super.groupID,
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

class _TencentCloudChatMessageTextState extends TencentCloudChatMessageState<TencentCloudChatMessageText> {
  @override
  Widget tabletAppBuilder(BuildContext context) {
    return defaultBuilder(context);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final maxBubbleWidth = widget.messageRowWidth * 0.8;
    final showIndicators = TencentCloudChat().dataInstance.basic.messageConfig.showMessageTimeIndicator(
              userID: widget.userID,
              groupID: widget.groupID,
            ) ||
        TencentCloudChat().dataInstance.basic.messageConfig.showMessageTimeIndicator(
              userID: widget.userID,
              groupID: widget.groupID,
            );
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(8)),
        decoration: BoxDecoration(
            color: showHighlightStatus ? colorTheme.info : (sentFromSelf ? colorTheme.selfMessageBubbleColor : colorTheme.othersMessageBubbleColor),
            border: Border.all(
              color: sentFromSelf ? colorTheme.selfMessageBubbleBorderColor : colorTheme.othersMessageBubbleBorderColor,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSquareSize(16)),
              topRight: Radius.circular(getSquareSize(16)),
              bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
              bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
            )),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: showIndicators ? 18 : 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 70, maxWidth: min(maxBubbleWidth * 0.9, maxBubbleWidth - getSquareSize(sentFromSelf ? 128 : 102))),
                    child: Text(
                      widget.message.textElem?.text ?? "",
                      style: TextStyle(color: sentFromSelf ? colorTheme.selfMessageTextColor : colorTheme.othersMessageTextColor, fontSize: textStyle.messageBody),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (sentFromSelf) messageStatusIndicator(),
                  messageTimeIndicator(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    final maxBubbleWidth = widget.messageRowWidth * 0.8;
    final showIndicators = TencentCloudChat().dataInstance.basic.messageConfig.showMessageTimeIndicator(
              userID: widget.userID,
              groupID: widget.groupID,
            ) ||
        TencentCloudChat().dataInstance.basic.messageConfig.showMessageTimeIndicator(
              userID: widget.userID,
              groupID: widget.groupID,
            );
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(8)),
        decoration: BoxDecoration(
            color: showHighlightStatus ? colorTheme.info : (sentFromSelf ? colorTheme.selfMessageBubbleColor : colorTheme.othersMessageBubbleColor),
            border: Border.all(
              color: sentFromSelf ? colorTheme.selfMessageBubbleBorderColor : colorTheme.othersMessageBubbleBorderColor,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSquareSize(16)),
              topRight: Radius.circular(getSquareSize(16)),
              bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
              bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
            )),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: showIndicators ? 18 : 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 70, maxWidth: min(maxBubbleWidth * 0.9, maxBubbleWidth - getSquareSize(sentFromSelf ? 128 : 102))),
                    child: Text(
                      widget.message.textElem?.text ?? "",
                      style: TextStyle(color: sentFromSelf ? colorTheme.selfMessageTextColor : colorTheme.othersMessageTextColor, fontSize: textStyle.messageBody),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (sentFromSelf) messageStatusIndicator(),
                  messageTimeIndicator(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
