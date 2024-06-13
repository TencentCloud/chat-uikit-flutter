import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageHeaderActions extends StatefulWidget {
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  final bool useCallKit;

  const TencentCloudChatMessageHeaderActions(
      {super.key,
      this.startVoiceCall,
      this.startVideoCall,
      required this.useCallKit});

  @override
  State<TencentCloudChatMessageHeaderActions> createState() =>
      _TencentCloudChatMessageHeaderActionsState();
}

class _TencentCloudChatMessageHeaderActionsState
    extends TencentCloudChatState<TencentCloudChatMessageHeaderActions> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Row(
              children: [
                if (widget.startVoiceCall != null && widget.useCallKit)
                  IconButton(
                    onPressed: widget.startVoiceCall,
                    icon: Icon(
                      Icons.call,
                      color: colorTheme.primaryColor,
                      size: textStyle.inputAreaIcon,
                    ),
                  ),
                if (widget.startVideoCall != null && widget.useCallKit)
                  IconButton(
                    onPressed: widget.startVideoCall,
                    icon: Icon(
                      Icons.videocam,
                      color: colorTheme.primaryColor,
                      size: textStyle.inputAreaIcon,
                    ),
                  ),
              ],
            ));
  }
}
