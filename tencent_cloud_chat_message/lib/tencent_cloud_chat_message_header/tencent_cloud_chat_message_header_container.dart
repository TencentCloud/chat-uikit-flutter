// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/eventbus/tencent_cloud_chat_eventbus.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/tuicore/tencent_cloud_chat_core.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/group_member_selector/tencent_cloud_chat_group_member_selector.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header_actions.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header_info.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header_profile_image.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header_select_mode.dart';

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class TencentCloudChatMessageHeaderContainer extends StatefulWidget implements PreferredSizeWidget {
  final String? userID;
  final String? groupID;
  final String? topicID;

  TencentCloudChatMessageHeaderContainer({
    super.key,
    this.userID,
    this.groupID,
    this.toolbarHeight,
    this.bottom,
    this.topicID,
  }) : preferredSize = _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height);

  @override
  State<TencentCloudChatMessageHeaderContainer> createState() => _TencentCloudChatMessageHeaderContainerState();

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
  V2TimConversation? _conversation;
  bool _inSelectMode = false;
  int _selectAmount = 0;

  List<V2TimGroupMemberFullInfo?> _groupMemberInfo = [];

  @override
  void initState() {
    super.initState();
  }

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
    final selectAmount = dataProvider.getSelectedMessages().length;
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

    if (_conversation?.conversationID == dataProvider.conversation?.conversationID &&
        (_conversation?.faceUrl != dataProvider.conversation?.faceUrl ||
            _conversation?.showName != dataProvider.conversation?.showName)) {
      setState(() {});
    }
  }

  List<V2TimGroupMemberFullInfo> _getGroupMembersInfo() {
    final List<V2TimGroupMemberFullInfo?> list = _groupMemberInfo;
    final List<V2TimGroupMemberFullInfo> res = [];
    for (var i = 0; i < list.length; i++) {
      if (list[i] != null) {
        res.add(list[i]!);
      }
    }
    return res;
  }

  _startVideoCall() async {
    final useCallKit = TencentCloudChat.instance.dataInstance.basic.useCallKit;
    if (useCallKit) {
      if (TencentCloudChatUtils.checkString(widget.groupID) != null) {
        final List<V2TimGroupMemberFullInfo> memberInfoList = await showGroupMemberSelector(
          groupMemberList: dataProvider.groupMemberList.where((element) => element != null).map((e) => e!).toList(),
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
  }

  _startVoiceCall() async {
    final useCallKit = TencentCloudChat.instance.dataInstance.basic.useCallKit;
    if (useCallKit) {
      if (TencentCloudChatUtils.checkString(widget.groupID) != null) {
        final List<V2TimGroupMemberFullInfo> memberInfoList = await showGroupMemberSelector(
          groupMemberList: dataProvider.groupMemberList.where((element) => element != null).map((e) => e!).toList(),
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
  }

  Future<V2TimConversation> _loadConversation() async {
    final conversation = dataProvider.conversation ?? await dataProvider.loadConversation();
    _conversation = conversation;
    return conversation;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final useCallKit = TencentCloudChat.instance.dataInstance.basic.useCallKit;

    return FutureBuilder(
        future: _loadConversation(),
        initialData: dataProvider.conversation,
        builder: (BuildContext context, AsyncSnapshot<V2TimConversation> snapshot) {
          final conversation = snapshot.data ?? dataProvider.conversation;
          return dataProvider.messageBuilders?.getMessageHeader(
                data: MessageHeaderBuilderData(
                  selectAmount: _selectAmount,
                  inSelectMode: _inSelectMode,
                  userID: widget.userID,
                  topicID: widget.topicID,
                  groupID: widget.groupID,
                  conversation: conversation,
                  showUserOnlineStatus:
                      TencentCloudChat.instance.dataInstance.basic.userConfig.useUserOnlineStatus ?? true,
                ),
                methods: MessageHeaderBuilderMethods(
                  getUserOnlineStatus: ({required String userID}) {
                    return TencentCloudChat.instance.dataInstance.contact.getOnlineStatusByUserId(userID: userID);
                  },
                  getGroupMembersInfo: _getGroupMembersInfo,
                  controller: dataProvider.messageController,
                  onCancelSelect: () => dataProvider.inSelectMode = false,
                  onClearSelect: () => dataProvider.selectedMessages = [],
                  startVideoCall: _startVideoCall,
                  startVoiceCall: _startVoiceCall,
                ),
                widgets: MessageHeaderBuilderWidgets(
                  messageHeaderProfileImage: TencentCloudChatMessageHeaderProfileImage(
                    getGroupMembersInfo: _getGroupMembersInfo,
                    conversation: conversation,
                    startVideoCall: _startVideoCall,
                    startVoiceCall: _startVoiceCall,
                  ),
                  messageHeaderInfo: TencentCloudChatMessageHeaderInfo(
                    conversation: conversation,
                    userID: widget.userID,
                    groupID: widget.groupID,
                    showName: TencentCloudChatUtils.checkString(conversation?.showName) ?? widget.userID ?? tL10n.chat,
                    showUserOnlineStatus:
                        TencentCloudChat.instance.dataInstance.basic.userConfig.useUserOnlineStatus ?? true,
                    getUserOnlineStatus: ({required String userID}) {
                      return TencentCloudChat.instance.dataInstance.contact.getOnlineStatusByUserId(userID: userID);
                    },
                    getGroupMembersInfo: _getGroupMembersInfo,
                  ),
                  messageHeaderActions: TencentCloudChatMessageHeaderActions(
                    startVoiceCall: _startVoiceCall,
                    startVideoCall: _startVideoCall,
                    useCallKit: useCallKit,
                  ),
                  messageHeaderMessagesSelectMode: TencentCloudChatMessageHeaderSelectMode(
                    key: ValueKey<bool>(_inSelectMode),
                    selectAmount: _selectAmount,
                    onCancelSelect: () => dataProvider.inSelectMode = false,
                    onClearSelect: () => dataProvider.selectedMessages = [],
                  ),
                ),
              ) ??
              Container();
        });
  }
}
