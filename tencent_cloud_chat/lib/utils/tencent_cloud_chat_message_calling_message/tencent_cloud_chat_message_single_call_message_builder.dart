import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_message_calling_message/tencent_cloud_chat_message_calling_message.dart';

class CallMessageItem extends StatelessWidget {
  final V2TimCustomElem? customElem;
  final bool isFromSelf;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isShowIcon;

  const CallMessageItem({
    Key? key,
    this.customElem,
    this.isFromSelf = false,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.isShowIcon = true,
  }) : super(key: key);

  /// This function build widget according to call element states.
  /// Returns a Widget
  Widget _callElemBuilder(BuildContext context) {
    final callingMessage = CallingMessage.getCallMessage(customElem);

    if (callingMessage != null) {
      // 如果是结束消息
      final isCallEnd = CallingMessage.isCallEndExist(callingMessage);

      final isVoiceCall = callingMessage.callType == 1;

      String? callTime = "";
      if (isCallEnd) {
        callTime = CallingMessage.getShowTime(callingMessage.callEnd!);
      }

      if (!isShowIcon) {
        return isCallEnd ? Text("通话时间 $callTime") : Text(CallingMessage.getActionType(callingMessage));
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isFromSelf)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Image.asset(
                isVoiceCall ? "assets/calling_message/voice_call.png" : "assets/calling_message/video_call.png",
                height: 16,
                width: 16,
              ),
            ),
          isCallEnd ? Text("通话时间：$callTime") : Text(CallingMessage.getActionType(callingMessage)),
          if (isFromSelf)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Image.asset(
                isVoiceCall ? "assets/calling_message/voice_call.png" : "assets/calling_message/video_call_self.png",
                height: 16,
                width: 16,
              ),
            ),
        ],
      );
    } else {
      return const Text("[自定义]");
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadiusDefault = isFromSelf
        ? const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10))
        : const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10));
    return Container(
      padding: padding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? borderRadiusDefault,
      ),
      constraints: const BoxConstraints(maxWidth: 240),
      child: _callElemBuilder(context),
    );
  }
}
