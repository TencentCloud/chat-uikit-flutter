import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';

import '../forward/tencent_cloud_chat_message_forward_container.dart';

class TencentCloudChatMessageInputSelectMode extends StatefulWidget {
  final List<V2TimMessage> messages;
  final ValueChanged<List<V2TimMessage>> onDeleteForMe;
  final ValueChanged<List<V2TimMessage>> onDeleteForEveryone;
  final bool useDeleteForEveryone;

  const TencentCloudChatMessageInputSelectMode({
    super.key,
    required this.messages,
    required this.onDeleteForMe,
    required this.onDeleteForEveryone,
    required this.useDeleteForEveryone,
  });

  @override
  State<TencentCloudChatMessageInputSelectMode> createState() =>
      _TencentCloudChatMessageInputSelectModeState();
}

class _TencentCloudChatMessageInputSelectModeState
    extends TencentCloudChatState<TencentCloudChatMessageInputSelectMode> {
  Widget _buildInputAreaIcon({
    required IconData icon,
    required GestureTapCallback onTap,
  }) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: IconButton(
                onPressed: onTap,
                color: colorTheme.primaryColor,
                icon: Icon(
                  icon,
                  size: textStyle.fontsize_24,
                  color: colorTheme.primaryColor,
                ),
              ),
            ));
  }

  void _showForwardOptions() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => Container(
                  padding: const EdgeInsets.all(16),
                  color: colorTheme.inputAreaBackground,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorTheme.primaryColor,
                            border: Border.all(
                                color: colorTheme.primaryColor, width: 8),
                          ),
                          child: Icon(
                            Icons.forward_to_inbox_outlined,
                            color: colorTheme.backgroundColor,
                            size: textStyle.standardLargeText,
                          ),
                        ),
                        title: Text(tL10n.forwardIndividually),
                        onTap: () {
                          Navigator.pop(context);
                          _showForwardPopup(
                              type: TencentCloudChatForwardType.individually);
                        },
                      ),
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorTheme.primaryColor,
                            border: Border.all(
                                color: colorTheme.primaryColor, width: 8),
                          ),
                          child: Icon(
                            Icons.forward_outlined,
                            color: colorTheme.backgroundColor,
                            size: textStyle.standardLargeText,
                          ),
                        ),
                        title: Text(tL10n.forwardCombined),
                        onTap: () {
                          Navigator.pop(context);
                          _showForwardPopup(
                              type: TencentCloudChatForwardType.combined);
                        },
                      ),
                    ],
                  ),
                ));
      },
    );
  }

  void _showForwardPopup({required TencentCloudChatForwardType type}) {
    final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType ==
        DeviceScreenType.desktop;
    if (isDesktopScreen) {
      TencentCloudChatDesktopPopup.showPopupWindow(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.6,
        operationKey: TencentCloudChatPopupOperationKey.forward,
        context: context,
        child: (closeFunc) => TencentCloudChatMessageForwardContainer(
          onCloseModal: closeFunc,
          type: type,
          context: context,
          messages: widget.messages,
        ),
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext _) {
          return TencentCloudChatMessageForwardContainer(
            type: type,
            context: context,
            messages: widget.messages,
          );
        },
      );
    }
  }

  void _showDeletionPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isSelf = true;
        for (var element in widget.messages) {
          if (element.isSelf == false) {
            isSelf = false;
            break;
          }
        }
        final showDeleteForEveryone = isSelf && widget.useDeleteForEveryone;
        return AlertDialog(
          title: Text(tL10n.confirmDeletion),
          content: Text(tL10n.deleteMessageCount(widget.messages.length)),
          actions: [
            if (showDeleteForEveryone)
              TextButton(
                onPressed: () {
                  widget.onDeleteForEveryone(widget.messages);
                  Navigator.pop(context);
                },
                child: Text(tL10n.deleteForEveryone),
              ),
            TextButton(
              onPressed: () {
                widget.onDeleteForMe(widget.messages);
                Navigator.pop(context);
              },
              child: Text(tL10n.deleteForMe),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(tL10n.cancel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        color: colorTheme.inputAreaBackground,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildInputAreaIcon(
                icon: Icons.delete_outline_rounded, onTap: _showDeletionPopup),
            // _buildInputAreaIcon(icon: Icons.info_outline_rounded, onTap: () {}),
            _buildInputAreaIcon(
                icon: Icons.arrow_forward_outlined, onTap: _showForwardOptions),
          ],
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        color: colorTheme.inputAreaBackground,
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(16), vertical: getHeight(60)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Tooltip(
              message: tL10n.delete,
              preferBelow: false,
              child: _buildInputAreaIcon(
                  icon: Icons.delete_outline_rounded,
                  onTap: _showDeletionPopup),
            ),
            Tooltip(
              message: tL10n.forwardIndividually,
              preferBelow: false,
              child: _buildInputAreaIcon(
                  icon: Icons.forward_to_inbox_outlined,
                  onTap: () => _showForwardPopup(
                      type: TencentCloudChatForwardType.individually)),
            ),
            Tooltip(
              message: tL10n.forwardCombined,
              preferBelow: false,
              child: _buildInputAreaIcon(
                  icon: Icons.forward_outlined,
                  onTap: () => _showForwardPopup(
                      type: TencentCloudChatForwardType.combined)),
            ),
          ],
        ),
      ),
    );
  }
}
