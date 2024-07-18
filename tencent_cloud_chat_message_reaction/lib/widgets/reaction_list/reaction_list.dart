import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_message_reaction/data/message_reaction_data.dart';
import 'package:tencent_cloud_chat_message_reaction/widgets/reaction_list/reaction_list_item.dart';
import 'package:tencent_cloud_chat_message_reaction/widgets/reaction_list/reation_list_detail_item.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction.dart';

import '../../tencent_cloud_chat_message_reaction.dart';

class TencentCloudChatMessageReactionList extends StatefulWidget {
  final String msgID;
  final int primaryColor;
  final int borderColor;
  final int textColor;
  final String platformMode;

  const TencentCloudChatMessageReactionList({
    super.key,
    required this.primaryColor,
    required this.borderColor,
    required this.textColor,
    required this.msgID, required this.platformMode,
  });

  @override
  State<TencentCloudChatMessageReactionList> createState() => _TencentCloudChatMessageReactionListState();
}

class _TencentCloudChatMessageReactionListState extends State<TencentCloudChatMessageReactionList> {
  late TencentCloudChatMessageReactionData reactionData;

  List<V2TimMessageReaction>? _messageReactions;

  void _reactionDataHandler() {
    if (reactionData.updatedMessageReactions.contains(widget.msgID)) {
      final newReactionList = reactionData.messageReactionMap[widget.msgID];
      setState(() {
        _messageReactions = newReactionList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    reactionData = TencentCloudChatMessageReaction.instance.reactionData;
    reactionData.addListener(_reactionDataHandler);
    _messageReactions = reactionData.messageReactionMap[widget.msgID];
  }

  @override
  void dispose() {
    super.dispose();
    reactionData.removeListener(_reactionDataHandler);
  }

  @override
  Widget build(BuildContext context) {
    return (_messageReactions ?? []).isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ..._messageReactions!.map((reaction) {
                  return TencentCloudChatMessageReactionItem(
                    messageReaction: reaction,
                    msgID: widget.msgID,
                    primaryColor: widget.primaryColor,
                    textColor: widget.textColor,
                    borderColor: widget.borderColor,
                  );
                }),
                TencentCloudChatMessageReactionListDetailItem(
                  msgID: widget.msgID,
                  primaryColor: widget.primaryColor,
                  borderColor: widget.borderColor,
                  textColor: widget.textColor,
                  platformMode: widget.platformMode,
                ),
              ],
            ),
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }
}
