import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageTipsCommon extends StatefulWidget {
  final String text;
  final V2TimMessage? message;

  const TencentCloudChatMessageTipsCommon(
      {super.key, required this.text, this.message});
  @override
  State<TencentCloudChatMessageTipsCommon> createState() =>
      _TencentCloudChatMessageTipsCommonState();
}

class _TencentCloudChatMessageTipsCommonState
    extends TencentCloudChatState<TencentCloudChatMessageTipsCommon> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        margin: EdgeInsets.symmetric(vertical: getSquareSize(4)),
        padding: EdgeInsets.symmetric(
            vertical: getSquareSize(4), horizontal: getSquareSize(8)),
        decoration: BoxDecoration(
          color: colorTheme.messageTipsBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(getSquareSize(16))),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: textStyle.standardSmallText,
            color: colorTheme.secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
