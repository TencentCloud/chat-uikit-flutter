import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageReplyView extends StatefulWidget {
  final String? messageSender;
  final String? messageAbstract;
  final String messageID;

  const TencentCloudChatMessageReplyView({
    super.key,
    required this.messageSender,
    required this.messageAbstract,
    required this.messageID,
  });

  @override
  State<TencentCloudChatMessageReplyView> createState() =>
      _TencentCloudChatMessageReplyViewState();
}

class _TencentCloudChatMessageReplyViewState
    extends TencentCloudChatState<TencentCloudChatMessageReplyView> {
  @override
  Widget defaultBuilder(BuildContext context) {
    final showMessageDetail =
        TencentCloudChatUtils.checkString(widget.messageSender) != null &&
            TencentCloudChatUtils.checkString(widget.messageAbstract) != null;
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: colorTheme.messageTipsBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                Icons.reply,
                color: colorTheme.secondaryTextColor,
                size: textStyle.standardLargeText,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showMessageDetail)
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4),
                      child: Text(
                        widget.messageSender!,
                        style: TextStyle(
                          color: colorTheme.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: textStyle.standardSmallText,
                        ),
                      )),
                if (showMessageDetail)
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4),
                      child: Text(
                        widget.messageAbstract!,
                        maxLines: 5,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: colorTheme.secondaryTextColor,
                          fontSize: textStyle.standardSmallText,
                        ),
                      )),
                if (!showMessageDetail)
                  Text(
                    "Reply to a message",
                    style: TextStyle(
                      color: colorTheme.secondaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: textStyle.standardSmallText,
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
