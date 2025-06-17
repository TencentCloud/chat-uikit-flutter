import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.data.repliedMessage?.nickName ?? widget.data.repliedMessage?.sender ?? '',
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
