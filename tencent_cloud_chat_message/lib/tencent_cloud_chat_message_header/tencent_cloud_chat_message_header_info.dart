import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatMessageHeaderInfo extends StatefulWidget {
  final bool Function({required String userID}) getUserOnlineStatus;
  final List<V2TimGroupMemberFullInfo> Function() getGroupMembersInfo;
  final String? userID;
  final String? groupID;
  final V2TimConversation? conversation;
  final bool showUserOnlineStatus;
  final String? showName;

  const TencentCloudChatMessageHeaderInfo({
    super.key,
    required this.getUserOnlineStatus,
    required this.getGroupMembersInfo,
    this.showName,
    this.userID,
    this.groupID,
    this.conversation,
    required this.showUserOnlineStatus,
  });

  @override
  State<TencentCloudChatMessageHeaderInfo> createState() =>
      _TencentCloudChatMessageHeaderInfoState();
}

class _TencentCloudChatMessageHeaderInfoState
    extends TencentCloudChatState<TencentCloudChatMessageHeaderInfo> {
  String _getInfoDetailed(V2TimConversation? conversation) {
    String res = "";
    if (conversation == null) {
      return res;
    }
    if (conversation.type == ConversationType.V2TIM_C2C) {
      String userID = conversation.userID ?? "";
      if (userID.isNotEmpty) {
        bool status = widget.getUserOnlineStatus(userID: userID);
        if (status) {
          res = tL10n.online;
        } else {
          res = tL10n.offline;
        }
      }
    } else {
      List<V2TimGroupMemberFullInfo> groupMemberList =
          widget.getGroupMembersInfo();
      var list = groupMemberList
          .map((e) =>
              TencentCloudChatUtils.getDisplayNameByV2TimGroupMemberInfo(e))
          .toList();
      var len = list.length;
      if (len > 2) {
        res = tL10n.groupSubtitle(len, list[0]);
      }
    }
    return res;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final infoDetail = _getInfoDetailed(widget.conversation);
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      widget.showName ?? TencentCloudChatUtils.checkString(
                              widget.conversation?.showName) ??
                          widget.userID ??
                          tL10n.chat,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: textStyle.standardLargeText,
                          fontWeight: FontWeight.bold,
                          color: colorTheme.primaryTextColor),
                    ))
                  ],
                ),
                if (widget.showUserOnlineStatus && TencentCloudChatUtils.checkString(infoDetail) != null)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                              infoDetail,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: textStyle.standardSmallText,
                              color: colorTheme.secondaryTextColor),
                        ))
                      ],
                    ),
                  )
              ],
            ));
  }
}
