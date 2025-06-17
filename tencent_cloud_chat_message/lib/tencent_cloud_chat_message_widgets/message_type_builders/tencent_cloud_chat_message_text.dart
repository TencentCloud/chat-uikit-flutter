import 'dart:math';

import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown/src/_functions_io.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/common/text_compiler/tencent_cloud_chat_message_text_compiler.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

class TencentCloudChatMessageText extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageText({
    super.key,
    required super.data,
    required super.methods,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageTextState();
}

class _TencentCloudChatMessageTextState extends TencentCloudChatMessageState<TencentCloudChatMessageText> {
  @override
  Widget tabletAppBuilder(BuildContext context) {
    return defaultBuilder(context);
  }

  Widget _getTextWidget(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    String text = getMarkDownStringData(
      hasStickerPlugin: widget.data.hasStickerPlugin,
      stickerPluginInstance: widget.data.stickerPluginInstance,
      text: widget.data.message.textElem?.text,
    );
    String adjustText = text == '*' ? '\\*' : text;
    return widget.data.enableParseMarkdown
        ? MarkdownBody(
            data: adjustText,
            imageBuilder: (uri, title, alt) {
              double? width;
              double? height;
              final List<String> parts = uri.path.split('#');
              if (parts.isEmpty) {
                return const SizedBox();
              }
              if (parts.length == 2) {
                final List<String> dimensions = parts.last.split('x');
                if (dimensions.length == 2) {
                  width = double.tryParse(dimensions[0]);
                  height = double.tryParse(dimensions[1]);
                }
              }
              return uri.toString().indexOf("resource:") == 0 ? Image(
                image: AssetImage(uri.path.replaceAll("resource:", ""), package: "tencent_cloud_chat_sticker"),
                width: 22,
                height: 22,
              ) : kDefaultImageBuilder(uri, null, width, height);
            },
            selectable: false,
            onTapLink: (
              String link,
              String? href,
              String title,
            ) {
              widget.methods.triggerLinkTappedEvent(link);
            },
            styleSheet: MarkdownStyleSheet.fromTheme(
              ThemeData(
                textTheme: TextTheme(
                  bodyMedium: TextStyle(
                    height: 1.6,
                    fontSize: textStyle.messageBody,
                    color: sentFromSelf ? colorTheme.selfMessageTextColor : colorTheme.othersMessageTextColor,
                  ),
                ),
              ),
            ),
          )
        : ExtendedText(
            key: Key(widget.data.message.msgID ??
                widget.data.message.id ??
                DateTime.now().millisecondsSinceEpoch.toString()),
            _getContentSpan(widget.data.message.textElem?.text ?? "", colorTheme, textStyle),
            onSpecialTextTap: (dynamic parameter) {
              if (parameter.toString().startsWith('\$')) {
                widget.methods.triggerLinkTappedEvent((parameter.toString()).replaceAll('\$', ''));
              }
            },
            specialTextSpanBuilder: TencentCloudChatSpecialTextSpanBuilder(
              onTapUrl: widget.methods.triggerLinkTappedEvent,
              showAtBackground: true,
              stickerPluginInstance: widget.data.stickerPluginInstance,
            ),
            style: TextStyle(
                color: sentFromSelf ? colorTheme.selfMessageTextColor : colorTheme.othersMessageTextColor,
                fontSize: textStyle.messageBody),
          );
  }

  String _getContentSpan(String text, TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    List<InlineSpan> contentList = [];
    String contentData = TencentCloudChatPlatformAdapter().isWeb ? '\u200B' : "";

    Iterable<RegExpMatch> matches = TencentCloudChatUtils.urlReg.allMatches(text);

    int index = 0;
    for (RegExpMatch match in matches) {
      String c = text.substring(match.start, match.end);
      if (match.start == index) {
        index = match.end;
      }
      if (index < match.start) {
        String a = text.substring(index, match.start);
        index = match.end;
        contentData += a;
        contentList.add(
          TextSpan(text: a),
        );
      }

      if (TencentCloudChatUtils.urlReg.hasMatch(c)) {
        contentData += '${HttpText.flag}$c${HttpText.flag}';
        contentList.add(TextSpan(
            text: c,
            style: const TextStyle(color: Colors.blueAccent),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                widget.methods.triggerLinkTappedEvent(text.substring(match.start, match.end));
              }));
      } else {
        contentData += c;
        contentList.add(
          TextSpan(text: c, style: const TextStyle(fontSize: 16.0)),
        );
      }
    }
    if (index < text.length) {
      String a = text.substring(index, text.length);
      contentData += a;
      contentList.add(
        TextSpan(text: a, style: TextStyle(fontSize: textStyle.messageBody)),
      );
    }

    return contentData;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final showIndicators =
        (widget.data.showMessageStatusIndicator && sentFromSelf) || widget.data.showMessageTimeIndicator;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(8)),
        decoration: BoxDecoration(
            color: showHighlightStatus
                ? colorTheme.info
                : (sentFromSelf ? colorTheme.selfMessageBubbleColor : colorTheme.othersMessageBubbleColor),
            border: Border.all(
              color:
                  sentFromSelf ? colorTheme.selfMessageBubbleBorderColor : colorTheme.othersMessageBubbleBorderColor,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSquareSize(!sentFromSelf && widget.data.showMessageSenderName ? 0 : 16)),
              topRight: Radius.circular(getSquareSize(sentFromSelf && widget.data.showMessageSenderName ? 0 : 16)),
              bottomLeft:
                  Radius.circular(getSquareSize(!sentFromSelf && !widget.data.showMessageSenderName ? 0 : 16)),
              bottomRight:
                  Radius.circular(getSquareSize(sentFromSelf && !widget.data.showMessageSenderName ? 0 : 16)),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.data.repliedMessageItem != null) widget.data.repliedMessageItem!,
            if (widget.data.repliedMessageItem != null)
              const SizedBox(
                height: 8,
              ),
            Wrap(
              spacing: 6,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                _getTextWidget(colorTheme, textStyle),
                if (showIndicators)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (sentFromSelf) messageStatusIndicator(),
                      messageTimeIndicator(),
                    ],
                  ),
              ],
            ),

            messageReactionList(),
          ],
        ),
      );
    });
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    final maxBubbleWidth = widget.data.messageRowWidth * 0.8;
    final showIndicators =
        (widget.data.showMessageStatusIndicator && sentFromSelf) || widget.data.showMessageTimeIndicator;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: min(maxBubbleWidth * 0.9, maxBubbleWidth - getSquareSize(sentFromSelf ? 128 : 102))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(8)),
          decoration: BoxDecoration(
              color: showHighlightStatus
                  ? colorTheme.info
                  : (sentFromSelf ? colorTheme.selfMessageBubbleColor : colorTheme.othersMessageBubbleColor),
              border: Border.all(
                color:
                    sentFromSelf ? colorTheme.selfMessageBubbleBorderColor : colorTheme.othersMessageBubbleBorderColor,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(getSquareSize(!sentFromSelf && widget.data.showMessageSenderName ? 0 : 16)),
                topRight: Radius.circular(getSquareSize(sentFromSelf && widget.data.showMessageSenderName ? 0 : 16)),
                bottomLeft:
                    Radius.circular(getSquareSize(!sentFromSelf && !widget.data.showMessageSenderName ? 0 : 16)),
                bottomRight:
                    Radius.circular(getSquareSize(sentFromSelf && !widget.data.showMessageSenderName ? 0 : 16)),
              )),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.data.repliedMessageItem != null) widget.data.repliedMessageItem!,
              if (widget.data.repliedMessageItem != null)
                const SizedBox(
                  height: 8,
                ),
              Wrap(
                spacing: 6,
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  _getTextWidget(colorTheme, textStyle),
                  if (showIndicators)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (sentFromSelf) messageStatusIndicator(),
                          messageTimeIndicator(),
                        ],
                      ),
                    ),
                ],
              ),
              messageReactionList(),
            ],
          ),
        ),
      );
    });
  }
}
