import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_merge_detail.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

class TencentCloudChatMessageMerge extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageMerge({
    super.key,
    required super.data,
    required super.methods,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageMergeState();
}

class _TencentCloudChatMessageMergeState extends TencentCloudChatMessageState<TencentCloudChatMessageMerge> {
  final String _tag = "TencentCloudChatMessageMerge";

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: json.encode(
        {
          "msgID": widget.data.message.msgID,
          "log": log,
        },
      ),
    );
  }

  int onTapDownTime = 0;

  showMergeDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TencentCloudChatMessageMergeDetail(
          message: widget.data.message,
        ),
      ),
    );
  }

  onTapDown(TapDownDetails details) {
    if (!widget.data.inSelectMode) {
      onTapDownTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  onTapUp(TapUpDetails details) {
    if (widget.data.inSelectMode) {
      return;
    }
    int onTapUpTime = DateTime.now().millisecondsSinceEpoch;
    if (onTapUpTime - onTapDownTime > 300 && onTapDownTime > 0) {
      console("tap to long break.");
      return;
    }
    if (widget.data.renderOnMenuPreview) {
      return;
    }
    onTapDownTime = 0;
    showMergeDetail();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final maxBubbleWidth = widget.data.messageRowWidth * 0.8;
    String title = TencentCloudChatUtils.checkString(widget.data.message.mergerElem!.title) ?? tL10n.chatHistory;
    List<String> abstractList = widget.data.message.mergerElem!.abstractList ?? [];
    int displayLen = abstractList.length > 3 ? 3 : abstractList.length;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        child: Container(
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
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: textStyle.fontsize_12,
                  color: colorTheme.othersMessageTextColor,
                ),
              ),
              ...((abstractList)
                  .map(
                    (e) => Text(
                  e,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: textStyle.fontsize_12,
                    color: colorTheme.othersMessageTextColor.withOpacity(0.5),
                  ),
                ),
              ).toList().sublist(0, displayLen)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.withOpacity(0.3),
                height: 1,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      tL10n.chatHistory,
                      style: TextStyle(
                        fontSize: textStyle.fontsize_12,
                        color: colorTheme.othersMessageTextColor.withOpacity(0.5),
                      )
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Spacer(), // 添加空白区域
                  ),
                  if (sentFromSelf) messageStatusIndicator(),
                  messageTimeIndicator(),
                ]
              ),
              messageReactionList(),
            ],
          )
        ),
      );
    });
  }
}
