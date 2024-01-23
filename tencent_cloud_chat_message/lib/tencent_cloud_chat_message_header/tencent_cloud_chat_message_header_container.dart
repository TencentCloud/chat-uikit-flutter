// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/tuicore/tencent_cloud_chat_core.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/group_member_selector/tencent_cloud_chat_group_member_selector.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
            (toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class TencentCloudChatMessageHeaderContainer extends StatefulWidget
    implements PreferredSizeWidget {
  final String? userID;
  final String? groupID;

  TencentCloudChatMessageHeaderContainer({
    super.key,
    this.userID,
    this.groupID,
    this.toolbarHeight,
    this.bottom,
  }) : preferredSize =
            _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height);

  @override
  State<TencentCloudChatMessageHeaderContainer> createState() =>
      _TencentCloudChatMessageHeaderContainerState();

  @override
  final Size preferredSize;

  /// {@template flutter.material.appbar.toolbarHeight}
  /// Defines the height of the toolbar component of an [AppBar].
  ///
  /// By default, the value of [toolbarHeight] is [kToolbarHeight].
  /// {@endtemplate}
  final double? toolbarHeight;

  /// {@template flutter.material.appbar.bottom}
  /// This widget appears across the bottom of the app bar.
  ///
  /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can
  /// be used at the bottom of an app bar.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
  final PreferredSizeWidget? bottom;
}

class _TencentCloudChatMessageHeaderContainerState
    extends TencentCloudChatState<TencentCloudChatMessageHeaderContainer> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;
  bool _inSelectMode = false;
  int _selectAmount = 0;

  List<V2TimGroupMemberFullInfo?> _groupMemberInfo = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
    dataProvider.addListener(dataProviderListener);
    dataProviderListener();
  }

  @override
  void dispose() {
    super.dispose();
    dataProvider.removeListener(dataProviderListener);
  }

  void dataProviderListener() {
    /// _inSelectMode
    if (_inSelectMode != dataProvider.inSelectMode) {
      setState(() {
        _inSelectMode = dataProvider.inSelectMode;
      });
    }

    /// _selectAmount
    final selectAmount = dataProvider.selectedMessages.length;
    if (selectAmount != _selectAmount) {
      setState(() {
        _selectAmount = selectAmount;
      });
    }

    final groupMemberList = dataProvider.groupMemberList;
    if (!TencentCloudChatUtils.deepEqual(_groupMemberInfo, groupMemberList)) {
      setState(() {
        _groupMemberInfo = groupMemberList;
      });
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final useCallKit = TencentCloudChat.dataInstance.basic.useCallKit;

    return TencentCloudChatMessageBuilders.getMessageHeader(
      controller: dataProvider.messageController,
      onCancelSelect: () => dataProvider.inSelectMode = false,
      onClearSelect: () => dataProvider.selectedMessages = [],
      selectAmount: _selectAmount,
      inSelectMode: _inSelectMode,
      loadConversation: dataProvider.loadConversation,
      userID: widget.userID,
      groupID: widget.groupID,
      conversation: dataProvider.conversation,
      startVideoCall: useCallKit
          ? () async {
              if (TencentCloudChatUtils.checkString(widget.groupID) != null) {
                final List<V2TimGroupMemberFullInfo> memberInfoList =
                    await showGroupMemberSelector(
                  groupMemberList: dataProvider.groupMemberList
                      .where((element) => element != null)
                      .map((e) => e!)
                      .toList(),
                  context: context,
                  onSelectLabel: tL10n.startCall,
                );

                TencentCloudChatTUICore.videoCall(
                  userids: memberInfoList.map((e) => e.userID).toList(),
                  groupid: widget.groupID,
                );
              } else {
                if (widget.userID != null) {
                  TencentCloudChatTUICore.videoCall(
                    userids: [widget.userID ?? ""],
                    groupid: widget.groupID,
                  );
                }
              }
            }
          : null,
      startVoiceCall: useCallKit
          ? () async {
              if (TencentCloudChatUtils.checkString(widget.groupID) != null) {
                final List<V2TimGroupMemberFullInfo> memberInfoList =
                    await showGroupMemberSelector(
                  groupMemberList: dataProvider.groupMemberList
                      .where((element) => element != null)
                      .map((e) => e!)
                      .toList(),
                  context: context,
                  onSelectLabel: tL10n.startCall,
                );
                TencentCloudChatTUICore.audioCall(
                  userids: memberInfoList.map((e) => e.userID).toList(),
                  groupid: widget.groupID,
                );
              } else {
                if (widget.userID != null) {
                  TencentCloudChatTUICore.audioCall(
                    userids: [widget.userID ?? ""],
                    groupid: widget.groupID,
                  );
                }
              }
            }
          : null,
      showUserOnlineStatus:
          TencentCloudChat.dataInstance.basic.userConfig.useUserOnlineStatus ??
              true,
      getUserOnlineStatus: ({required String userID}) {
        return TencentCloudChat.dataInstance.contact
            .getOnlineStatusByUserId(userID: userID);
      },
      getGroupMembersInfo: () {
        var list = _groupMemberInfo;
        List<V2TimGroupMemberFullInfo> res = [];
        for (var i = 0; i < list.length; i++) {
          if (list[i] != null) {
            res.add(list[i]!);
          }
        }
        return res;
      },
    );
  }
}
