import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatConversationDesktopSearchAndAdd extends StatefulWidget {
  const TencentCloudChatConversationDesktopSearchAndAdd({super.key});

  @override
  State<TencentCloudChatConversationDesktopSearchAndAdd> createState() =>
      _TencentCloudChatConversationDesktopSearchAndAddState();
}

class _TencentCloudChatConversationDesktopSearchAndAddState
    extends TencentCloudChatState<
        TencentCloudChatConversationDesktopSearchAndAdd> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => ConstrainedBox(
              constraints: BoxConstraints(maxHeight: getHeight(64)),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: getHeight(18), horizontal: getWidth(16)),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: colorTheme.dividerColor)),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () async {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorTheme.dividerColor.withOpacity(0.36),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              color: colorTheme.secondaryTextColor
                                  .withOpacity(0.8),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(tL10n.search,
                                style: TextStyle(
                                  color: colorTheme.secondaryTextColor
                                      .withOpacity(0.8),
                                  fontSize: 12,
                                )),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(
                      width: getWidth(16),
                    ),
                    Container(
                      height: getSquareSize(24),
                      width: getSquareSize(24),
                      color: colorTheme.dividerColor.withOpacity(0.36),
                      child: Icon(
                        Icons.add,
                        color: colorTheme.secondaryTextColor.withOpacity(0.6),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
