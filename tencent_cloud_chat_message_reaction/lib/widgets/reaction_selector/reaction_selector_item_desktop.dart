
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_message_reaction/tencent_cloud_chat_message_reaction.dart';

class TencentCloudChatReactionSelectorItemDesktop extends StatefulWidget {
  final int index;
  final VoidCallback onTap;

  const TencentCloudChatReactionSelectorItemDesktop({super.key, required this.index, required this.onTap});

  @override
  State<TencentCloudChatReactionSelectorItemDesktop> createState() =>
      _TencentCloudChatReactionSelectorItemDesktopState();
}

class _TencentCloudChatReactionSelectorItemDesktopState extends State<TencentCloudChatReactionSelectorItemDesktop> {
  final messageReactionStickerList = TencentCloudChatMessageReaction.instance.reactionData.messageReactionStickerList;
  final messageReactionLabelToAsset = TencentCloudChatMessageReaction.instance.reactionData.messageReactionLabelToAsset;
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final asset = messageReactionLabelToAsset[messageReactionStickerList[widget.index]];
    return (asset ?? "").isNotEmpty
        ? Container(
      margin: EdgeInsets.only(
          right: widget.index == messageReactionStickerList.length - 1 ? 8 : 2,
          left: widget.index == 0 ? 8 : 2),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _hovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hovering = false;
          });
        },
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: _hovering ? 1.4 : 1.0),
          duration: const Duration(milliseconds: 200),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: InkWell(
                onTap: widget.onTap,
                onSecondaryTap: (){

                },
                child: Image.asset(
                  asset!,
                  package: "tencent_cloud_chat_sticker",
                  width: 30.0,
                  height: 30.0,
                ),
              ),
            );
          },
        ),
      ),
    )
        : const SizedBox(
      width: 0,
    );
  }
}