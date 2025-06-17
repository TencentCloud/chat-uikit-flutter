import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_message_calling_message.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

class TencentCloudChatMessageCustomC2CCall extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageCustomC2CCall({
    super.key,
    required super.data,
    required super.methods,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageCustomC2CCallState();
}

class _TencentCloudChatMessageCustomC2CCallState extends TencentCloudChatMessageState<TencentCloudChatMessageCustomC2CCall> {
  @override
  Widget tabletAppBuilder(BuildContext context) {
    return defaultBuilder(context);
  }

  Widget _getContentWidget(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    final callingMessage = CallingMessage.getCallMessage(widget.data.message);
    if (callingMessage == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        if (callingMessage!.streamMediaType == CallStreamMediaType.audio) {
          widget.methods.startVoiceCall?.call();
        } else {
          widget.methods.startVideoCall?.call();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (callingMessage!.direction == CallMessageDirection.incoming)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ImageIcon(
                AssetImage(
                  callingMessage!.streamMediaType == CallStreamMediaType.audio
                    ? "lib/assets/voice_call.png"
                    : "lib/assets/video_call.png",
                  package: 'tencent_cloud_chat_message',
                ),
                size: 16,
              ),
            ),

          Text(callingMessage!.getContent()),

          if (callingMessage!.direction == CallMessageDirection.outcoming)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ImageIcon(
                AssetImage(
                  callingMessage!.streamMediaType == CallStreamMediaType.audio
                      ? "lib/assets/voice_call.png"
                      : "lib/assets/video_call_self.png",
                  package: 'tencent_cloud_chat_message',
                ),
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final showTimeIndicators = widget.data.showMessageTimeIndicator;
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
                _getContentWidget(colorTheme, textStyle),
                if (showTimeIndicators) messageTimeIndicator(),
              ],
            ),

            messageReactionList(),
          ],
        ),
      );
    });
  }
}
