import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/TIMUIKitMessageReaction/message_reaction_emoji.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_emoji_panel.dart'
    as emoji;
import 'package:tencent_cloud_chat_uikit/ui/widgets/emoji.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/extended_wrap/extended_wrap.dart';

enum SelectEmojiPanelPosition { up, down }

class TIMUIKitMessageReactionEmojiSelectPanel extends StatefulWidget {
  final ValueChanged<int> onSelect;
  final bool isShowMoreSticker;
  final ValueChanged<bool> onClickShowMore;

  const TIMUIKitMessageReactionEmojiSelectPanel(
      {Key? key,
      required this.onSelect,
      required this.isShowMoreSticker,
      required this.onClickShowMore})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TIMUIKitMessageReactionEmojiSelectPanelState();
}

class TIMUIKitMessageReactionEmojiSelectPanelState
    extends TIMUIKitState<TIMUIKitMessageReactionEmojiSelectPanel> {
  bool isShowMore = false;

  _buildSimplePanel(TUITheme theme) {
    final List<Map<String, Object>> emojiData = messageReactionEmojiData;
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor() == DeviceType.Desktop;
    return Material(
      color: Colors.white,
      child: ExtendedWrap(
        maxLines: widget.isShowMoreSticker ? 5 : 1,
        spacing: 18,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 24,
        children: [
          if(!isDesktopScreen)
            GestureDetector(
            onTap: () {
              widget.onClickShowMore(!widget.isShowMoreSticker);
            },
            child: SizedBox(
              height: 34,
              child: Icon(
                  widget.isShowMoreSticker
                      ? Icons.cancel_outlined
                      : Icons.add_circle_outline_outlined,
                  color: hexToColor("444444"),
                  size: 26),
            ),
          ),
          ...emojiData.map(
            (e) {
              var item = Emoji.fromJson(e);
              return SizedBox(
                // width: 50,
                child: InkWell(
                  splashColor: Colors.white,
                  onTap: () {
                    widget.onSelect(item.unicode);
                  },
                  child: emoji.EmojiItem(
                    name: item.name,
                    unicode: item.unicode,
                  ),
                ),
              );
            },
          ).toList()
        ],
      ),
    );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return Container(
      child: _buildSimplePanel(theme),
    );
  }
}
