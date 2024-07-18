import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_message_reaction/tencent_cloud_chat_message_reaction.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction_change_info.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudChatMessageReactionItem extends StatefulWidget {
  final String msgID;
  final V2TimMessageReaction messageReaction;
  final int primaryColor;
  final int borderColor;
  final int textColor;

  const TencentCloudChatMessageReactionItem({
    super.key,
    required this.messageReaction,
    required this.primaryColor,
    required this.borderColor,
    required this.textColor,
    required this.msgID,
  });

  @override
  State<TencentCloudChatMessageReactionItem> createState() => _TencentCloudChatMessageReactionItemState();
}

class _TencentCloudChatMessageReactionItemState extends State<TencentCloudChatMessageReactionItem> {
  bool _updating = false;

  @override
  void didUpdateWidget(covariant TencentCloudChatMessageReactionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messageReaction != widget.messageReaction) {
      setState(() {
        _updating = false;
      });
    }
  }

  void _onClickReaction() {
    if (widget.messageReaction.reactedByMyself) {
      TencentImSDKPlugin.v2TIMManager.getMessageManager().removeMessageReaction(
            msgID: widget.msgID,
            reactionID: widget.messageReaction.reactionID,
          );
    } else {
      TencentImSDKPlugin.v2TIMManager.getMessageManager().addMessageReaction(
            msgID: widget.msgID,
            reactionID: widget.messageReaction.reactionID,
          );
    }

    final reactionMap = TencentCloudChatMessageReaction.instance.reactionData.messageReactionMap;
    final targetMessage = reactionMap[widget.msgID] ?? [];
    final targetReactionIndex = targetMessage.indexWhere((e) => e.reactionID == widget.messageReaction.reactionID);
    V2TimMessageReaction? targetReaction;

    if (targetReactionIndex > -1) {
      targetReaction = targetMessage[targetReactionIndex];
      if (!targetReaction.reactedByMyself) {
        targetReaction.reactedByMyself = true;
        targetReaction.totalUserCount = targetReaction.totalUserCount + 1;
      } else {
        targetReaction.reactedByMyself = false;
        targetReaction.totalUserCount = targetReaction.totalUserCount - 1;
      }
    }
    if (targetReaction != null) {
      TencentCloudChatMessageReaction.instance.reactionData.onReceivedMessageReactionChanged([
        V2TIMMessageReactionChangeInfo(
          messageID: widget.msgID,
          reactionList: [targetReaction],
        ),
      ], true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReactionUpdatingList =
        TencentCloudChatMessageReaction.instance.reactionData.messageReactionUpdatingList;
    final exists = messageReactionUpdatingList.any((e) {
      return e.$1 == widget.msgID && e.$2 == widget.messageReaction.reactionID;
    });
    final forbidClick = _updating || exists;
    return Opacity(
      opacity: _updating ? 1.0 : 1.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.messageReaction.reactedByMyself
                      ? Color(widget.primaryColor).withOpacity(0.6)
                      : Color(widget.borderColor)),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Material(
                color: widget.messageReaction.reactedByMyself ? Color(widget.primaryColor).withOpacity(0.06) : null,
                child: InkWell(
                  onTap: forbidClick
                      ? null
                      : () {
                          // setState(() {
                          //   _updating = true;
                          // });
                          _onClickReaction();
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          TencentCloudChatMessageReaction.instance.reactionData
                                  .messageReactionLabelToAsset[widget.messageReaction.reactionID] ??
                              "",
                          package: "tencent_cloud_chat_sticker",
                          height: 26,
                          width: 26,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          widget.messageReaction.totalUserCount.toString(),
                          style: TextStyle(color: Color(widget.textColor), fontSize: 12),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // if (false)
          //   Positioned(
          //     child: SizedBox(
          //       width: 16,
          //       height: 16,
          //       child: CircularProgressIndicator(
          //         strokeWidth: 2.0,
          //         valueColor: AlwaysStoppedAnimation<Color>(Color(widget.primaryColor)),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
