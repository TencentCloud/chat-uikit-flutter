// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/time_ago.dart';

import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation_draft_text.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation_last_msg.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/unread_message.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

typedef LastMessageBuilder = Widget? Function(
    V2TimMessage? lastMsg, List<V2TimGroupAtInfo?> groupAtInfoList);

class TIMUIKitConversationItem extends TIMUIKitStatelessWidget {
  final String faceUrl;
  final String nickName;
  final V2TimMessage? lastMsg;
  final int unreadCount;
  final bool isPined;
  final List<V2TimGroupAtInfo?> groupAtInfoList;
  final String? draftText;
  final int? draftTimestamp;
  final bool isDisturb;
  final LastMessageBuilder? lastMessageBuilder;
  final V2TimUserStatus? onlineStatus;
  final int? convType;
  final bool isCurrent;

  /// Control if shows the identifier that the conversation has a draft text, inputted in previous.
  /// Also, you'd better specifying the `draftText` field for `TIMUIKitChat`, from the `draftText` in `V2TimConversation`,
  /// to meet the identifier shows here.
  final bool isShowDraft;

  TIMUIKitConversationItem({
    Key? key,
    required this.isShowDraft,
    required this.faceUrl,
    required this.nickName,
    required this.lastMsg,
    this.onlineStatus,
    required this.isPined,
    this.isCurrent = false,
    required this.unreadCount,
    required this.groupAtInfoList,
    required this.isDisturb,
    this.draftText,
    this.draftTimestamp,
    this.lastMessageBuilder,
    this.convType,
  }) : super(key: key);

  Widget _getShowMsgWidget(BuildContext context) {
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    if (isShowDraft && draftText != null && draftText != "") {
      return TIMUIKitDraftText(
        context: context,
        draftText: draftText ?? "",
        fontSize: isDesktopScreen ? 12 : 14,
      );
    } else if (lastMsg != null) {
      if (lastMessageBuilder != null &&
          lastMessageBuilder!(lastMsg, groupAtInfoList) != null) {
        return lastMessageBuilder!(lastMsg, groupAtInfoList)!;
      }
      return TIMUIKitLastMsg(
        fontSize: isDesktopScreen ? 12 : 14,
        groupAtInfoList: groupAtInfoList,
        lastMsg: lastMsg,
        context: context,
      );
    }

    return Container(
      height: 0,
    );
  }

  bool isHaveSecondLine() {
    return (isShowDraft && draftText != null && draftText != "") ||
        (lastMsg != null);
  }

  Widget _getTimeStringForChatWidget(BuildContext context, TUITheme theme) {
    try {
      if (draftTimestamp != null && draftTimestamp != 0) {
        return Text(TimeAgo().getTimeStringForChat(draftTimestamp as int) ?? "",
            style: TextStyle(
              fontSize: 12,
              color: theme.conversationItemTitmeTextColor,
            ));
      } else if (lastMsg != null) {
        return Text(TimeAgo().getTimeStringForChat(lastMsg!.timestamp as int) ?? "",
            style: TextStyle(
              fontSize: 11,
              color: theme.conversationItemTitmeTextColor,
            ));
      }
    } catch (err) {}

    return Container();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.conversationItemBorderColor ??
                CommonColor.weakDividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0, bottom: 2, right: 0),
            child: SizedBox(
              width: isDesktopScreen ? 40 : 44,
              height: isDesktopScreen ? 40 : 44,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Avatar(
                      onlineStatus: onlineStatus,
                      faceUrl: faceUrl,
                      showName: nickName,
                      type: convType),
                  if (unreadCount != 0)
                    Positioned(
                      top: isDisturb ? -2.5 : -4.5,
                      right: isDisturb ? -2.5 : -4.5,
                      child: UnconstrainedBox(
                        child: UnreadMessage(
                            width: isDisturb ? 10 : 18,
                            height: isDisturb ? 10 : 18,
                            unreadCount: isDisturb ? 0 : unreadCount),
                      ),
                    )
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            height: 60,
            margin: EdgeInsets.only(left: isDesktopScreen ? 10 : 12),
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      nickName,
                      softWrap: true,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        height: 1,
                        color: theme.conversationItemTitleTextColor,
                        fontSize: isDesktopScreen ? 14 : 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                    _getTimeStringForChatWidget(context, theme),
                  ],
                ),
                if (isHaveSecondLine())
                  const SizedBox(
                    height: 6,
                  ),
                Row(
                  children: [
                    Expanded(child: _getShowMsgWidget(context)),
                    if (isDisturb)
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Icon(
                          Icons.notifications_off,
                          color: theme.conversationItemNoNotificationIconColor,
                          size: isDesktopScreen ? 14 : 16.0,
                        ),
                      )
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
