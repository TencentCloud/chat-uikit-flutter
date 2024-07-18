import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

class TencentCloudChatMessageSticker extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageSticker({
    super.key,
    required super.data,
    required super.methods,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageStickerState();
}

class _TencentCloudChatMessageStickerState extends TencentCloudChatMessageState<TencentCloudChatMessageSticker> {
  Widget getStickerWidget() {
    var faceElem = widget.data.message.faceElem;
    if (faceElem == null) {
      return const Text("Note: No sticker found.");
    }
    final index = faceElem.index;
    final data = faceElem.data;

    if (widget.data.hasStickerPlugin) {
      if (widget.data.stickerPluginInstance != null) {
        var wid = widget.data.stickerPluginInstance!.getWidgetSync(
          methodName: "getStickerWidgetForMessageItem",
          data: Map<String, String>.from(
            {
              "index": index.toString(),
              "data": data,
            },
          ),
        );
        if (wid != null) {
          return wid;
        } else {
          return Text("Note: Failed to compile for sticker data. ${index.toString()} $data");
        }
      } else {
        return const Text("Note: Failed to get sticker example.");
      }
    } else {
      return const Text("Note: No sticker plugin found.");
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
            Row(
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
                          child: getStickerWidget(),
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
            messageReactionList(),
          ],
        ),
      );
    });
  }
}
