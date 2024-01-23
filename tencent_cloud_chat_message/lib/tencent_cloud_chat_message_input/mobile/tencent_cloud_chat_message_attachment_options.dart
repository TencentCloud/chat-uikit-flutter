import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';

class TencentCloudChatMessageAttachmentOptions {
  OverlayEntry? _overlayEntry;
  late AnimationController _attachmentOptionsAnimationController;
  late Animation<double> _attachmentOptionsAnimation;

  void init({required TickerProvider vsync, required BuildContext context}) {
    _attachmentOptionsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: vsync,
    );
    _attachmentOptionsAnimation = CurvedAnimation(
      parent: _attachmentOptionsAnimationController,
      curve: Curves.easeInOut,
    );
  }

  void dispose() {
    _attachmentOptionsAnimationController.dispose();
  }

  Widget _buildAttachmentOptions(
      {required BoxConstraints constraints,
      required List<TencentCloudChatMessageGeneralOptionItem>
          attachmentOptions}) {
    return SlideTransition(
      position: _attachmentOptionsAnimation.drive(Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      )),
      child: SizeTransition(
        sizeFactor: _attachmentOptionsAnimation,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth - 32),
          child: TencentCloudChatMessageBuilders.getAttachmentOptionsBuilder(
            attachmentOptions: attachmentOptions,
            onActionFinish: _removeEntry,
          ),
        ),
      ),
    );
  }

  void toggleAttachmentOptionsOverlay(
      {required BoxConstraints constraints,
      required BuildContext context,
      required List<TencentCloudChatMessageGeneralOptionItem>
          attachmentOptions}) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => toggleAttachmentOptionsOverlay(
              constraints: constraints,
              context: context,
              attachmentOptions: attachmentOptions),
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  bottom: 80,
                  left: 16,
                  child: GestureDetector(
                    onTap: () {},
                    child: _buildAttachmentOptions(
                        constraints: constraints,
                        attachmentOptions: attachmentOptions),
                  ),
                ),
              ],
            ),
          ),
        );
      });

      Overlay.of(context).insert(_overlayEntry!);
      _attachmentOptionsAnimationController.forward();
    } else {
      _removeEntry();
    }
  }

  void _removeEntry() {
    _attachmentOptionsAnimationController.reverse().then((value) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}

class TencentCloudChatMessageAttachmentOptionsWidget extends StatefulWidget {
  final List<TencentCloudChatMessageGeneralOptionItem> attachmentOptions;
  final VoidCallback onActionFinish;

  const TencentCloudChatMessageAttachmentOptionsWidget({
    super.key,
    required this.attachmentOptions,
    required this.onActionFinish,
  });

  @override
  State<TencentCloudChatMessageAttachmentOptionsWidget> createState() =>
      _TencentCloudChatMessageAttachmentOptionsWidgetState();
}

class _TencentCloudChatMessageAttachmentOptionsWidgetState
    extends TencentCloudChatState<
        TencentCloudChatMessageAttachmentOptionsWidget> {
  Widget _buildAttachmentOptionsItem(
      TencentCloudChatMessageGeneralOptionItem item) {
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return InkWell(
        onTap: () {
          widget.onActionFinish();
          item.onTap();
        },
        child: SizedBox(
          width: 62,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorTheme.primaryColor,
                  border: Border.all(color: colorTheme.primaryColor, width: 12),
                ),
                child: Icon(
                  item.icon,
                  color: colorTheme.backgroundColor,
                  size: textStyle.standardLargeText,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                item.label,
                style: TextStyle(
                    color: colorTheme.secondaryTextColor,
                    fontSize: textStyle.standardSmallText),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              decoration: BoxDecoration(
                color: colorTheme.inputAreaBackground,
                border: Border.all(color: colorTheme.dividerColor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Material(
                  color: colorTheme.inputAreaBackground,
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: widget.attachmentOptions
                        .map((e) => _buildAttachmentOptionsItem(e))
                        .toList(),
                  ),
                ),
              ),
            ));
  }
}
