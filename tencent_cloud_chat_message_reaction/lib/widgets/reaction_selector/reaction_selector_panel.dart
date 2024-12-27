import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_message_reaction/tencent_cloud_chat_message_reaction.dart';
import 'package:tencent_cloud_chat_message_reaction/widgets/reaction_selector/reaction_selector_item_desktop.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction_change_info.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudMessageReactionSelectorPanel extends StatelessWidget {
  final String msgID;
  final int backgroundColor;
  final int borderColor;
  final String platformMode;

  const TencentCloudMessageReactionSelectorPanel({
    super.key,
    required this.msgID,
    required this.backgroundColor,
    required this.platformMode,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final messageReactionStickerList = TencentCloudChatMessageReaction.instance.reactionData.messageReactionStickerList;
    final messageReactionLabelToAsset =
        TencentCloudChatMessageReaction.instance.reactionData.messageReactionLabelToAsset;
    final ScrollController scrollController = ScrollController();

    void updateMessageReaction(String reactionID) {
      final reactionMap = TencentCloudChatMessageReaction.instance.reactionData.messageReactionMap;
      final targetMessageReactionList = reactionMap[msgID] ?? [];
      final targetReactionIndex = targetMessageReactionList.indexWhere((e) => e.reactionID == reactionID);
      bool hasReactedBySelf = false;
      V2TimMessageReaction? targetReaction;

      if (targetReactionIndex > -1) {
        targetReaction = targetMessageReactionList[targetReactionIndex];
        hasReactedBySelf = targetReaction.reactedByMyself;
        if (hasReactedBySelf) {
          targetReaction.reactedByMyself = false;
          targetReaction.totalUserCount = targetReaction.totalUserCount - 1;
        } else {
          targetReaction.reactedByMyself = true;
          targetReaction.totalUserCount = targetReaction.totalUserCount + 1;
        }
      } else {
        targetReaction = V2TimMessageReaction(
          reactionID: reactionID,
          reactedByMyself: true,
          totalUserCount: 1,
          partialUserList: [],
        );
      }

      if (hasReactedBySelf) {
        TencentImSDKPlugin.v2TIMManager.getMessageManager().removeMessageReaction(
          msgID: msgID,
          reactionID: reactionID,
        );
      } else {
        TencentImSDKPlugin.v2TIMManager.getMessageManager().addMessageReaction(
          msgID: msgID,
          reactionID: reactionID,
        );
      }

      TencentCloudChatMessageReaction.instance.reactionData.onReceivedMessageReactionChanged([
        V2TIMMessageReactionChangeInfo(
          messageID: msgID,
          reactionList: [targetReaction],
        ),
      ], true);
    }

    if (platformMode == "desktop") {
      return Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            scrollController.position.moveTo(
              scrollController.offset + pointerSignal.scrollDelta.dy,
            );
          }
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 254,
            height: 48,
            decoration: BoxDecoration(
              color: Color(backgroundColor).withOpacity(0.9),
              border: Border.all(
                color: Color(borderColor),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: messageReactionStickerList.length,
                  itemBuilder: (context, index) {
                    return TencentCloudChatReactionSelectorItemDesktop(
                      index: index,
                      onTap: (){
                        updateMessageReaction(messageReactionStickerList[index]);
                        TencentImSDKPlugin.v2TIMManager.emitUIKitListener(
                          data: Map<String, dynamic>.from(
                            {
                              "eventType": "onClickReactionSelector",
                            },
                          ),
                        );
                      },
                    );
                  }
              ),
            ),
          ),
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: SizedBox(
          height: 50,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: min(800, MediaQuery
                  .of(context)
                  .size
                  .width * 0.76),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(48)),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(backgroundColor).withOpacity(0.7),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: messageReactionStickerList.length,
                  itemBuilder: (context, index) {
                    final asset = messageReactionLabelToAsset[messageReactionStickerList[index]];
                    return (asset ?? "").isNotEmpty
                        ? Container(
                      margin: EdgeInsets.only(
                          right: index == messageReactionStickerList.length - 1 ? 12 : 4,
                          left: index == 0 ? 12 : 0),
                      child: InkWell(
                        onTap: () {
                          updateMessageReaction(messageReactionStickerList[index]);
                          TencentImSDKPlugin.v2TIMManager.emitUIKitListener(
                            data: Map<String, dynamic>.from(
                              {
                                "eventType": "onClickReactionSelector",
                              },
                            ),
                          );
                        },
                        child: Image.asset(
                          asset!,
                          package: "tencent_cloud_chat_sticker",
                          width: 40.0,
                          height: 40.0,
                        ),
                      ),
                    )
                        : const SizedBox(
                      width: 0,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
