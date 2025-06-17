import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageDropTarget extends StatefulWidget {
  final String currentConversationShowName;

  const TencentCloudChatMessageDropTarget(
      {Key? key, required this.currentConversationShowName})
      : super(key: key);

  @override
  State<TencentCloudChatMessageDropTarget> createState() =>
      _TencentCloudChatMessageDropTargetState();
}

class _TencentCloudChatMessageDropTargetState
    extends TencentCloudChatState<TencentCloudChatMessageDropTarget> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Opacity(
              opacity: 0.85,
              child: Container(
                color: colorTheme.backgroundColor,
                padding: const EdgeInsets.all(40),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(20),
                  color: colorTheme.primaryColor,
                  dashPattern: const [6, 3],
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_copy_outlined,
                              size: 60,
                              color: colorTheme.primaryColor,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              tL10n.sendToSomeChat(
                                  widget.currentConversationShowName),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colorTheme.primaryTextColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
