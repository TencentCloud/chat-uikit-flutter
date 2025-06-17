import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageReplyView extends StatefulWidget {
  final MessageReplyViewBuilderData data;
  final MessageReplyViewBuilderMethods methods;

  const TencentCloudChatMessageReplyView({
    super.key, required this.data, required this.methods,
  });

  @override
  State<TencentCloudChatMessageReplyView> createState() =>
      _TencentCloudChatMessageReplyViewState();
}

class _TencentCloudChatMessageReplyViewState
    extends TencentCloudChatState<TencentCloudChatMessageReplyView> {
  @override
  Widget tabletAppBuilder(BuildContext context) {
    return defaultBuilder(context);
  }
  
  Widget replyView(){
    final showMessageDetail =
        TencentCloudChatUtils.checkString(widget.data.messageSender) != null &&
            TencentCloudChatUtils.checkString(widget.data.messageAbstract) != null;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) => Container(
      margin: const EdgeInsets.only(top: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: IntrinsicHeight(
          child: Container(
            color: colorTheme.messageTipsBackgroundColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  color: colorTheme.secondaryTextColor.withOpacity(0.2),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showMessageDetail)
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.4),
                            child: Text(
                              widget.data.messageSender!,
                              style: TextStyle(
                                color: colorTheme.secondaryTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: textStyle.standardSmallText,
                              ),
                            )),
                      const SizedBox(height: 4,),
                      if (showMessageDetail)
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.4),
                            child: Text(
                              widget.data.messageAbstract!,
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
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final supportNavigation =
        widget.data.messageSeq != null || widget.data.messageTimestamp != null;
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => GestureDetector(
        onTap: supportNavigation ? widget.methods.onTriggerNavigation : null,
        child: replyView(),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    final supportNavigation =
        widget.data.messageSeq != null || widget.data.messageTimestamp != null;
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) =>  InkWell(
        onTap: supportNavigation ? widget.methods.onTriggerNavigation : null,
        child: replyView(),
      ),
    );
  }
}
