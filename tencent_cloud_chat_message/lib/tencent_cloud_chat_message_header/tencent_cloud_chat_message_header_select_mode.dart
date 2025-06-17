import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageHeaderSelectMode extends StatefulWidget {
  final int selectAmount;
  final VoidCallback onCancelSelect;
  final VoidCallback onClearSelect;

  const TencentCloudChatMessageHeaderSelectMode({
    super.key,
    required this.selectAmount,
    required this.onCancelSelect,
    required this.onClearSelect,
  });

  @override
  State<TencentCloudChatMessageHeaderSelectMode> createState() =>
      _TencentCloudChatMessageHeaderSelectModeState();
}

class _TencentCloudChatMessageHeaderSelectModeState
    extends TencentCloudChatState<TencentCloudChatMessageHeaderSelectMode> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onClearSelect,
                    child: Text(
                      tL10n.clear,
                      style: TextStyle(fontSize: textStyle.fontsize_14),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                tL10n.numSelect(widget.selectAmount),
                style: TextStyle(
                  fontSize: textStyle.fontsize_16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancelSelect,
                    child: Text(
                      tL10n.cancel,
                      style: TextStyle(fontSize: textStyle.fontsize_14),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
