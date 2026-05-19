import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
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
  // toxee(P1): show a small media-type indicator (or local thumbnail for
  // images) next to the quoted-summary text so users can recognise that
  // they're replying to a picture / video / voice / file at a glance,
  // instead of only seeing localized "[Image]"/"[Video]" labels.
  Widget? _buildReplyLeadingIndicator(double size) {
    final repliedMessage = widget.data.repliedMessage;
    if (repliedMessage == null) return null;

    final elemType = repliedMessage.elemType;

    // Inline image thumbnail when we can resolve a local path.
    if (elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
      final localPath = repliedMessage.imageElem?.path;
      if (localPath != null && localPath.isNotEmpty) {
        final file = File(localPath);
        if (file.existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.file(
              file,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.image_outlined, size: size),
            ),
          );
        }
      }
      return Icon(Icons.image_outlined, size: size);
    }

    if (elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      return Icon(Icons.videocam_outlined, size: size);
    }
    if (elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
      return Icon(Icons.mic_none_outlined, size: size);
    }
    if (elemType == MessageElemType.V2TIM_ELEM_TYPE_FILE) {
      return Icon(Icons.attach_file_outlined, size: size);
    }
    if (elemType == MessageElemType.V2TIM_ELEM_TYPE_FACE) {
      return Icon(Icons.emoji_emotions_outlined, size: size);
    }
    return null;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) {
          final indicator = _buildReplyLeadingIndicator(18);
          return Container(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (indicator != null) ...[
                            IconTheme(
                              data: IconThemeData(
                                color: colorTheme.secondaryTextColor,
                                size: 18,
                              ),
                              child: indicator,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Flexible(
                            child: Text(
                              TencentCloudChatUtils.getMessageSummary(
                                  message: widget.data.repliedMessage),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: colorTheme.secondaryTextColor,
                                fontSize: textStyle.fontsize_12,
                              ),
                            ),
                          ),
                        ],
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
          );
        });
  }
}
