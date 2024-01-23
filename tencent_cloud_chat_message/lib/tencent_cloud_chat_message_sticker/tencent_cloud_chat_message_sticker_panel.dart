import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageStickerPanel extends StatefulWidget {
  const TencentCloudChatMessageStickerPanel({super.key});

  @override
  State<TencentCloudChatMessageStickerPanel> createState() =>
      _TencentCloudChatMessageStickerPanelState();
}

class _TencentCloudChatMessageStickerPanelState
    extends TencentCloudChatState<TencentCloudChatMessageStickerPanel> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              decoration: BoxDecoration(
                color: colorTheme.backgroundColor,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(getSquareSize(16))),
              ),
              child: const Column(
                children: [],
              ),
            ));
  }
}
