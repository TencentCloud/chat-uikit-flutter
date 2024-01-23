import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/components_options/tencent_cloud_chat_group_profile_options.dart';
import 'package:tencent_cloud_chat/components/components_options/tencent_cloud_chat_user_profile_options.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header_select_mode.dart';

class TencentCloudChatMessageHeader extends StatefulWidget {
  final V2TimConversation? conversation;
  final Future<V2TimConversation> Function({bool shouldUpdateState})
      loadConversation;
  final String? userID;
  final String? groupID;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  final bool inSelectMode;
  final int selectAmount;
  final VoidCallback onCancelSelect;
  final VoidCallback onClearSelect;
  final bool showUserOnlineStatus;
  final TencentCloudChatMessageController controller;

  // final VoidCallback onTapAvatar;
  final bool Function({required String userID}) getUserOnlineStatus;
  final List<V2TimGroupMemberFullInfo> Function() getGroupMembersInfo;

  const TencentCloudChatMessageHeader({
    super.key,
    required this.conversation,
    required this.loadConversation,
    this.userID,
    this.groupID,
    this.startVoiceCall,
    this.startVideoCall,
    required this.inSelectMode,
    required this.controller,
    required this.selectAmount,
    required this.onCancelSelect,
    required this.showUserOnlineStatus,
    required this.getUserOnlineStatus,
    required this.getGroupMembersInfo,
    required this.onClearSelect,
    // required this.onTapAvatar,
  });

  @override
  State<TencentCloudChatMessageHeader> createState() =>
      _TencentCloudChatMessageHeaderState();
}

class _TencentCloudChatMessageHeaderState
    extends TencentCloudChatState<TencentCloudChatMessageHeader> {
  final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType ==
      DeviceScreenType.desktop;

  Widget buildSelectModeHeader() {
    return TencentCloudChatMessageHeaderSelectMode(
      key: ValueKey<bool>(widget.inSelectMode),
      onClearSelect: widget.onClearSelect,
      selectAmount: widget.selectAmount,
      onCancelSelect: widget.onCancelSelect,
    );
  }

  String getOnlineStatus(V2TimConversation? conversation) {
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

  List<String> getConversationFaceURL(V2TimConversation? conversation) {
    var defaultUrl =
        "https://comm.qq.com/im/static-files/im-demo/im_virtual_customer.png";
    if (conversation == null) {
      return [defaultUrl];
    }
    if (conversation.type == ConversationType.V2TIM_C2C) {
      return [
        TencentCloudChatUtils.checkString(conversation.faceUrl) == null
            ? defaultUrl
            : conversation.faceUrl!
      ];
    } else {
      if (TencentCloudChatUtils.checkString(conversation.faceUrl) != null) {
        return [conversation.faceUrl!];
      }
      List<V2TimGroupMemberFullInfo> groupMemberList =
          widget.getGroupMembersInfo();
      var list = groupMemberList
          .takeWhile((value) =>
              TencentCloudChatUtils.checkString(value.faceUrl) != null)
          .toList();
      if (list.isNotEmpty) {
        if (list.length > 9) {
          list = list.sublist(0, 9);
        }
        return list.map((e) => e.faceUrl!).toList();
      }
      return [defaultUrl];
    }
  }

  Widget buildNormalHeader(
      colorTheme, textStyle, V2TimConversation? conversation) {
    List<Widget> innerHeader = [];
    Widget showName = Row(
      children: [
        Expanded(
            child: Text(
          TencentCloudChatUtils.checkString(conversation?.showName) ??
              widget.userID ??
              tL10n.chat,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: textStyle.standardLargeText,
              fontWeight: FontWeight.bold,
              color: colorTheme.primaryTextColor),
        ))
      ],
    );
    Widget onlineStatus = Expanded(
      child: Row(
        children: [
          Expanded(
              child: Text(
            getOnlineStatus(conversation),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: textStyle.standardSmallText,
                color: colorTheme.secondaryTextColor),
          ))
        ],
      ),
    );
    if (widget.showUserOnlineStatus) {
      innerHeader = [showName, onlineStatus];
    } else {
      innerHeader = [showName];
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 8 : 0),
      child: Row(
        key: ValueKey<bool>(widget.inSelectMode),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                if (!isDesktop)
                  IconButton(
                      color: colorTheme.primaryColor,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded)),
                GestureDetector(
                  onTap:
                      TencentCloudChatUtils.checkString(conversation?.userID) !=
                              null
                          ? () => navigateToUserProfile(
                              context: context,
                              options: TencentCloudChatUserProfileOptions(
                                  userID: conversation!.userID!,
                                  startVideoCall: widget.startVideoCall,
                                  startVoiceCall: widget.startVoiceCall))
                          : TencentCloudChatUtils
                                      .checkString(conversation?.groupID) !=
                                  null
                              ? () => navigateToGroupProfile(
                                  context: context,
                                  options: TencentCloudChatGroupProfileOptions(
                                      groupID: conversation!.groupID!,
                                      getGroupMembersInfo:
                                          widget.getGroupMembersInfo,
                                      startVideoCall: widget.startVideoCall,
                                      startVoiceCall: widget.startVoiceCall))
                              : null,
                  child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                    scene: TencentCloudChatAvatarScene.messageHeader,
                    imageList: getConversationFaceURL(conversation),
                    width: getSquareSize(34),
                    height: getSquareSize(34),
                    borderRadius: getSquareSize(17),
                  ),
                ),
                SizedBox(
                  width: getWidth(isDesktop ? 12 : 8),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: innerHeader,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (widget.startVoiceCall != null)
                IconButton(
                  onPressed: widget.startVoiceCall,
                  icon: Icon(
                    Icons.call,
                    color: colorTheme.primaryColor,
                    size: textStyle.inputAreaIcon,
                  ),
                ),
              if (widget.startVideoCall != null)
                IconButton(
                  onPressed: widget.startVideoCall,
                  icon: Icon(
                    Icons.videocam,
                    color: colorTheme.primaryColor,
                    size: textStyle.inputAreaIcon,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => FutureBuilder(
        initialData: widget.conversation,
        future: widget.loadConversation(shouldUpdateState: false),
        builder:
            (BuildContext context, AsyncSnapshot<V2TimConversation> snapshot) {
          final conversation = widget.conversation ?? snapshot.data;
          return Container(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + getSquareSize(8),
              left: getSquareSize(10),
              right: getSquareSize(10),
              bottom: widget.inSelectMode ? 0.0 : getSquareSize(10),
            ),
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: colorTheme.dividerColor)),
              color: colorTheme.backgroundColor,
            ),
            child: AnimatedSwitcher(
              switchInCurve: Curves.ease,
              switchOutCurve: Curves.ease,
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: child,
                );
              },
              child: widget.inSelectMode
                  ? buildSelectModeHeader()
                  : buildNormalHeader(colorTheme, textStyle, conversation),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => FutureBuilder(
        initialData: widget.conversation,
        future: widget.loadConversation(shouldUpdateState: false),
        builder:
            (BuildContext context, AsyncSnapshot<V2TimConversation> snapshot) {
          final conversation = widget.conversation ?? snapshot.data;
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: getSquareSize(10),
              vertical: getSquareSize(12),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorTheme.dividerColor),
              ),
              color: colorTheme.backgroundColor,
            ),
            child: AnimatedSwitcher(
              switchInCurve: Curves.ease,
              switchOutCurve: Curves.ease,
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: child,
                );
              },
              child: widget.inSelectMode
                  ? buildSelectModeHeader()
                  : buildNormalHeader(colorTheme, textStyle, conversation),
            ),
          );
        },
      ),
    );
  }
}
