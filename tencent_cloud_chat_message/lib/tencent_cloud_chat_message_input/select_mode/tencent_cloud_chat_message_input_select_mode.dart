import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';

class TencentCloudChatMessageInputSelectMode extends StatefulWidget {
  final MessageInputSelectBuilderWidgets? widgets;
  final MessageInputSelectBuilderData data;
  final MessageInputSelectBuilderMethods methods;

  const TencentCloudChatMessageInputSelectMode({
    super.key,
    required this.data,
    required this.methods,
    this.widgets,
  });

  @override
  State<TencentCloudChatMessageInputSelectMode> createState() => _TencentCloudChatMessageInputSelectModeState();
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
                      if (widget.data.enableMessageForwardIndividually)
                        ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorTheme.primaryColor,
                              border: Border.all(color: colorTheme.primaryColor, width: 8),
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
                            widget.methods.onMessagesForward(TencentCloudChatForwardType.individually);
                          },
                        ),
                      if (widget.data.enableMessageForwardCombined)
                        ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorTheme.primaryColor,
                              border: Border.all(color: colorTheme.primaryColor, width: 8),
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
                            widget.methods.onMessagesForward(TencentCloudChatForwardType.combined);
                          },
                        ),
                    ],
                  ),
                ));
      },
    );
  }

  void _showDeletionPopup() {
    bool isSelf = true;
    for (var element in widget.data.messages) {
      if (element.isSelf == false) {
        isSelf = false;
        break;
      }
    }
    TencentCloudChatDialog.showAdaptiveDialog(
      context: context,
      title: Text(tL10n.confirmDeletion),
      content: Text(tL10n.deleteMessageCount(widget.data.messages.length)),
      actions: [
        if (widget.data.enableMessageDeleteForSelf)
          TextButton(
            onPressed: () {
              widget.methods.onDeleteForMe(widget.data.messages);
              Navigator.pop(context);
            },
            child: Text(tL10n.confirm),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(tL10n.cancel),
        ),
      ],
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final showDeletion = widget.data.enableMessageDeleteForSelf;
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        color: colorTheme.inputAreaBackground,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (showDeletion) _buildInputAreaIcon(icon: Icons.delete_outline_rounded, onTap: _showDeletionPopup),
            // _buildInputAreaIcon(icon: Icons.info_outline_rounded, onTap: () {}),
            if (widget.data.enableMessageForwardCombined || widget.data.enableMessageForwardIndividually)
              _buildInputAreaIcon(icon: Icons.arrow_forward_outlined, onTap: _showForwardOptions),
          ],
        ),
      ),
    );
  }

  @override
  Widget tabletAppBuilder(BuildContext context) {
    final showDeletion = widget.data.enableMessageDeleteForSelf;
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        color: colorTheme.inputAreaBackground,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (showDeletion) _buildInputAreaIcon(icon: Icons.delete_outline_rounded, onTap: _showDeletionPopup),
            if (widget.data.enableMessageForwardIndividually)
              _buildInputAreaIcon(
                  icon: Icons.forward_to_inbox_outlined,
                  onTap: () => widget.methods.onMessagesForward(TencentCloudChatForwardType.individually)),
            if (widget.data.enableMessageForwardCombined)
              _buildInputAreaIcon(
                  icon: Icons.forward_outlined,
                  onTap: () => widget.methods.onMessagesForward(TencentCloudChatForwardType.combined)),
          ],
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    final showDeletion = widget.data.enableMessageDeleteForSelf;
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        color: colorTheme.inputAreaBackground,
        padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(60)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (showDeletion)
              Tooltip(
                message: tL10n.delete,
                preferBelow: false,
                child: _buildInputAreaIcon(icon: Icons.delete_outline_rounded, onTap: _showDeletionPopup),
              ),
            if (widget.data.enableMessageForwardIndividually)
              Tooltip(
                message: tL10n.forwardIndividually,
                preferBelow: false,
                child: _buildInputAreaIcon(
                    icon: Icons.forward_to_inbox_outlined,
                    onTap: () => widget.methods.onMessagesForward(TencentCloudChatForwardType.individually)),
              ),
            if (widget.data.enableMessageForwardCombined)
              Tooltip(
                message: tL10n.forwardCombined,
                preferBelow: false,
                child: _buildInputAreaIcon(
                    icon: Icons.forward_outlined,
                    onTap: () => widget.methods.onMessagesForward(TencentCloudChatForwardType.combined)),
              ),
          ],
        ),
      ),
    );
  }
}
