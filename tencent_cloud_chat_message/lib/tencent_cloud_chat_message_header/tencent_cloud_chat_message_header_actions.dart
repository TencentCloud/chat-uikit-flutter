import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageHeaderActions extends StatelessWidget {
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  final bool useCallKit;
  final bool callActionsEnabled;

  const TencentCloudChatMessageHeaderActions(
      {super.key,
      this.startVoiceCall,
      this.startVideoCall,
      required this.useCallKit,
      this.callActionsEnabled = true});

  @override
  Widget build(BuildContext context) {
    final voiceCallHandler = callActionsEnabled ? startVoiceCall : null;
    final videoCallHandler = callActionsEnabled ? startVideoCall : null;

    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Row(
              children: [
                if (startVoiceCall != null && useCallKit)
                  IconButton(
                    onPressed: voiceCallHandler,
                    icon: Icon(
                      Icons.call,
                      color: callActionsEnabled
                          ? colorTheme.primaryColor
                          : colorTheme.primaryTextColor.withValues(alpha: 0.35),
                      size: textStyle.inputAreaIcon,
                    ),
                  ),
                if (startVideoCall != null && useCallKit)
                  IconButton(
                    onPressed: videoCallHandler,
                    icon: Icon(
                      Icons.videocam,
                      color: callActionsEnabled
                          ? colorTheme.primaryColor
                          : colorTheme.primaryTextColor.withValues(alpha: 0.35),
                      size: textStyle.inputAreaIcon,
                    ),
                  ),
              ],
            ));
  }
}
