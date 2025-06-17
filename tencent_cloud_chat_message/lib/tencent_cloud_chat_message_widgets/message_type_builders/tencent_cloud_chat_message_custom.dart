import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

class TencentCloudChatMessageCustom extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageCustom({
    super.key,
    required super.data,
    required super.methods,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageCustomState();
}

class _TencentCloudChatMessageCustomState
    extends TencentCloudChatMessageState<TencentCloudChatMessageCustom> {
  bool isVoteMessage = false;
  bool isRobotMessage = false;
  bool isCustomerServiceMessage = false;
  Widget? voteWidget;
  Widget? robotWidget;
  Widget? customerServiceWidget;

  renderVoteMessage(TencentCloudChatThemeColors colorTheme,
      TencentCloudChatTextStyle textStyle) {
    if (voteWidget == null) {
      return Container();
    }
    return voteWidget;
  }

  renderRobotMessage(TencentCloudChatThemeColors colorTheme,
      TencentCloudChatTextStyle textStyle) {
    if (robotWidget == null) {
      return Container();
    }
    return robotWidget;
  }

  renderCustomerServiceMessage(TencentCloudChatThemeColors colorTheme,
      TencentCloudChatTextStyle textStyle) {
    if (customerServiceWidget == null) {
      return Container();
    }
    return customerServiceWidget;
  }

  getWidgetFromPlugin() async {
    if (isVoteMessage) {
      if (TencentCloudChat.instance.dataInstance.basic.hasPlugins('poll')) {
        var plugin =
            TencentCloudChat.instance.dataInstance.basic.getPlugin('poll');
        if (plugin != null) {
          var voteMsg = await plugin.pluginInstance.getWidget(
            methodName: "voteMessageItem",
            data: Map.from(
              {
                "message": json.encode(widget.data.message.toJson()),
              },
            ),
            fns: Map<String, TencentCloudChatPluginTapFn>.from(
              {
                "onTap": plugin.tapFn ??
                    (Map<String, String> data) {
                      return true;
                    }
              },
            ),
          );
          if (voteMsg != null) {
            setState(() {
              voteWidget = voteMsg;
            });
          }
        }
      }
    }
    if (isRobotMessage) {
      if (TencentCloudChat.instance.dataInstance.basic.hasPlugins('robot')) {
        var plugin =
            TencentCloudChat.instance.dataInstance.basic.getPlugin('robot');
        if (plugin != null) {
          var robotMsg = await plugin.pluginInstance.getWidget(
            methodName: "robotMessageItem",
            data: Map.from(
              {
                "message": json.encode(widget.data.message.toJson()),
              },
            ),
            fns: Map<String, TencentCloudChatPluginTapFn>.from(
              {
                "onTap": plugin.tapFn ??
                    (Map<String, String> data) {
                      return true;
                    }
              },
            ),
          );
          if (robotMsg != null) {
            setState(() {
              robotWidget = robotMsg;
            });
          }
        }
      }
    }
    if (isCustomerServiceMessage) {
      if (TencentCloudChat.instance.dataInstance.basic
          .hasPlugins('customerService')) {
        var plugin = TencentCloudChat.instance.dataInstance.basic
            .getPlugin('customerService');
        if (plugin != null) {
          var customerServiceMsg = plugin.pluginInstance.getWidgetSync(
            methodName: "customerServiceMessageItem",
            data: Map.from(
              {
                "message": json.encode(widget.data.message.toJson()),
              },
            ),
            fns: Map<String, TencentCloudChatPluginTapFn>.from(
              {
                "onTap": plugin.tapFn ??
                    (Map<String, String> data) {
                      return true;
                    }
              },
            ),
          );

          if (customerServiceMsg != null) {
            setState(() {
              customerServiceWidget = customerServiceMsg;
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isVoteMessage = TencentCloudChatUtils.isVoteMessage(widget.data.message);
    isRobotMessage = TencentCloudChatUtils.isRobotMessage(widget.data.message);
    isCustomerServiceMessage =
        TencentCloudChatUtils.isCustomerServiceMessage(widget.data.message);
    getWidgetFromPlugin();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getWidgetFromPlugin();
  }

  Widget getFinalRenderWidget(TencentCloudChatThemeColors colorTheme,
      TencentCloudChatTextStyle textStyle) {
    if (isVoteMessage) {
      return renderVoteMessage(colorTheme, textStyle);
    }
    if (isRobotMessage) {
      return renderRobotMessage(colorTheme, textStyle);
    }
    if (isCustomerServiceMessage) {
      return renderCustomerServiceMessage(colorTheme, textStyle);
    }

    final (String lineOne, String? lineTwo) =
        TencentCloudChatUtils.handleCustomMessage(widget.data.message);
    if (lineTwo == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lineOne,
            style: TextStyle(
                color: sentFromSelf
                    ? colorTheme.selfMessageTextColor
                    : colorTheme.othersMessageTextColor,
                fontSize: textStyle.messageBody),
          )
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lineOne,
                style: TextStyle(
                    color: sentFromSelf
                        ? colorTheme.selfMessageTextColor
                        : colorTheme.othersMessageTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: textStyle.messageBody),
              ),
              Text(
                lineTwo,
                style: TextStyle(
                    color: (sentFromSelf
                            ? colorTheme.selfMessageTextColor
                            : colorTheme.othersMessageTextColor)
                        .withOpacity(0.9),
                    fontSize: textStyle.messageBody - 1),
              )
            ],
          )
        ],
      );
    }
  }

  Widget messageInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!sentFromSelf)
          SizedBox(
            width: getWidth(0),
          ),
        if (sentFromSelf) messageStatusIndicator(),
        messageTimeIndicator(),
        if (sentFromSelf)
          SizedBox(
            width: getWidth(8),
          ),
      ],
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final maxBubbleWidth = widget.data.messageRowWidth * 0.8;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
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
            bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxBubbleWidth - 22,
                minWidth: 100,
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: getFinalRenderWidget(colorTheme, textStyle),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: messageInfo(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
