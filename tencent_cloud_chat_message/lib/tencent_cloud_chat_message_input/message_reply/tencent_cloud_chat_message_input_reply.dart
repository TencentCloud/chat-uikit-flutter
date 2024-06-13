import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageInputReply extends StatefulWidget {
  final MessageInputReplyBuilderWidgets? widgets;
  final MessageInputReplyBuilderData data;
  final MessageInputReplyBuilderMethods methods;

  const TencentCloudChatMessageInputReply({
    super.key,
    this.widgets,
    required this.data,
    required this.methods,
  });

  @override
  State<TencentCloudChatMessageInputReply> createState() => _TencentCloudChatMessageInputReplyState();
}

class _TencentCloudChatMessageInputReplyState extends TencentCloudChatState<TencentCloudChatMessageInputReply> {
  @override
  Widget defaultBuilder(BuildContext context) {
    final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              color: isDesktopScreen ? colorTheme.inputAreaBackground : null,
              padding: EdgeInsets.only(
                left: isDesktopScreen ? 8 : 0,
                right: isDesktopScreen ? 8 : 0,
                bottom: getSquareSize(8),
                top: isDesktopScreen ? 8 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: widget.methods.onClickReply,
                    icon: Icon(
                      Icons.reply_outlined,
                      color: colorTheme.primaryColor,
                      size: textStyle.fontsize_24,
                    ),
                  ),
                  SizedBox(
                    width: getWidth(12),
                  ),
                  Container(
                    color: colorTheme.primaryColor,
                    width: 1,
                    height: getHeight(36),
                  ),
                  SizedBox(
                    width: getWidth(12),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          tL10n.replyTo(widget.data.repliedMessage?.sender ?? ""),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: colorTheme.primaryColor,
                            fontSize: textStyle.fontsize_14,
                          ),
                        ),
                        Text(
                          TencentCloudChatUtils.getMessageSummary(message: widget.data.repliedMessage),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: colorTheme.secondaryTextColor,
                            fontSize: textStyle.fontsize_12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.methods.onCancel,
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: colorTheme.secondaryTextColor,
                      size: textStyle.fontsize_24,
                    ),
                  ),
                ],
              ),
            ));
  }
}
