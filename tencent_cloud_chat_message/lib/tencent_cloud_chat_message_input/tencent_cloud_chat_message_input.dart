import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/desktop/tencent_cloud_chat_message_input_desktop.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_input_mobile.dart';

class TencentCloudChatMessageInput extends StatefulWidget {
  final String? userID;
  final String? groupID;
  final Function({
    required String text,
    List<String>? mentionedUsers,
  }) sendTextMessage;
  final Function({required String imagePath}) sendImageMessage;
  final Function({required String videoPath}) sendVideoMessage;
  final Function({required String filePath}) sendFileMessage;
  final Function({required String voicePath, required int duration})
      sendVoiceMessage;
  final bool inSelectMode;
  final List<V2TimMessage> selectedMessages;
  final V2TimMessage? repliedMessage;
  final VoidCallback clearRepliedMessage;
  final List<TencentCloudChatMessageGeneralOptionItem> attachmentOptions;
  final TencentCloudChatMessageController controller;
  final Future<List<V2TimGroupMemberFullInfo>> Function({
    int? maxSelectionAmount,
    String? title,
    String? onSelectLabel,
  }) onChooseGroupMembers;
  final TencentCloudChatMessageInputStatus status;
  final bool isGroupAdmin;
  final String currentConversationShowName;

  /// Desktop mentioning members
  final AutoScrollController desktopInputMemberSelectionPanelScroll;
  final double desktopMentionBoxPositionX;
  final double desktopMentionBoxPositionY;
  final int activeMentionIndex;
  final List<V2TimGroupMemberFullInfo?> currentFilteredMembersListForMention;
  final ValueChanged<double> setDesktopMentionBoxPositionX;
  final ValueChanged<double> setDesktopMentionBoxPositionY;
  final ValueChanged<int> setActiveMentionIndex;
  final ValueChanged<List<V2TimGroupMemberFullInfo?>>
      setCurrentFilteredMembersListForMention;
  final List<V2TimGroupMemberFullInfo> groupMemberList;
  final V2TimGroupMemberFullInfo? memberNeedToMention;

  const TencentCloudChatMessageInput({
    super.key,
    required this.sendTextMessage,
    this.userID,
    this.groupID,
    required this.inSelectMode,
    required this.selectedMessages,
    this.repliedMessage,
    required this.attachmentOptions,
    required this.sendImageMessage,
    required this.controller,
    required this.sendVideoMessage,
    required this.sendFileMessage,
    required this.sendVoiceMessage,
    required this.onChooseGroupMembers,
    required this.status,
    required this.clearRepliedMessage,
    required this.desktopMentionBoxPositionX,
    required this.desktopMentionBoxPositionY,
    required this.activeMentionIndex,
    required this.currentFilteredMembersListForMention,
    required this.setDesktopMentionBoxPositionX,
    required this.setDesktopMentionBoxPositionY,
    required this.setActiveMentionIndex,
    required this.setCurrentFilteredMembersListForMention,
    required this.desktopInputMemberSelectionPanelScroll,
    required this.groupMemberList,
    required this.isGroupAdmin,
    required this.memberNeedToMention,
    required this.currentConversationShowName,
  }) : assert((userID == null) != (groupID == null));

  @override
  State<TencentCloudChatMessageInput> createState() =>
      _TencentCloudChatMessageInputState();
}

class _TencentCloudChatMessageInputState
    extends TencentCloudChatState<TencentCloudChatMessageInput> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textEditingFocusNode = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  String? _getMessageInputStatusText() {
    String? result;
    switch (widget.status) {
      case TencentCloudChatMessageInputStatus.canSendMessage:
        break;
      case TencentCloudChatMessageInputStatus.cantSendMessage:
        result = tL10n.cantSendMessage;
        break;
      case TencentCloudChatMessageInputStatus.noSuchGroup:
        result = tL10n.noSuchGroup;
        break;
      case TencentCloudChatMessageInputStatus.notGroupMember:
        result = tL10n.notGroupMember;
        break;
      case TencentCloudChatMessageInputStatus.userNotFound:
        result = tL10n.userNotFound;
        break;
      case TencentCloudChatMessageInputStatus.userBlockedYou:
        result = tL10n.userBlockedYou;
        break;
      case TencentCloudChatMessageInputStatus.muted:
        result = tL10n.muted;
        break;
      case TencentCloudChatMessageInputStatus.groupMuted:
        result = tL10n.groupMuted;
        break;
    }
    return result;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final String? statusText = _getMessageInputStatusText();
    return TencentCloudChatMessageInputMobile(
      key: Key(TencentCloudChatUtils.checkString(widget.groupID) ??
          widget.userID ??
          ""),
      userID: widget.userID,
      groupID: widget.groupID,
      sendFileMessage: widget.sendFileMessage,
      sendImageMessage: widget.sendImageMessage,
      sendTextMessage: widget.sendTextMessage,
      sendVideoMessage: widget.sendVideoMessage,
      sendVoiceMessage: widget.sendVoiceMessage,
      inSelectMode: widget.inSelectMode,
      statusText: statusText,
      selectedMessages: widget.selectedMessages,
      repliedMessage: widget.repliedMessage,
      textEditingController: _textEditingController,
      messageController: widget.controller,
      focusNode: _textEditingFocusNode,
      onChooseGroupMembers: widget.onChooseGroupMembers,
      attachmentOptions: widget.attachmentOptions,
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    final String? statusText = _getMessageInputStatusText();
    return TencentCloudChatMessageInputDesktop(
      key: Key(TencentCloudChatUtils.checkString(widget.groupID) ??
          widget.userID ??
          ""),
      userID: widget.userID,
      groupID: widget.groupID,
      currentConversationShowName: widget.currentConversationShowName,
      sendFileMessage: widget.sendFileMessage,
      sendImageMessage: widget.sendImageMessage,
      sendTextMessage: widget.sendTextMessage,
      sendVideoMessage: widget.sendVideoMessage,
      sendVoiceMessage: widget.sendVoiceMessage,
      inSelectMode: widget.inSelectMode,
      clearRepliedMessage: widget.clearRepliedMessage,
      statusText: statusText,
      selectedMessages: widget.selectedMessages,
      repliedMessage: widget.repliedMessage,
      textEditingController: _textEditingController,
      messageController: widget.controller,
      focusNode: _textEditingFocusNode,
      isGroupAdmin: widget.isGroupAdmin,
      onChooseGroupMembers: widget.onChooseGroupMembers,
      controlBarItems: widget.attachmentOptions,
      desktopMentionBoxPositionX: widget.desktopMentionBoxPositionX,
      desktopMentionBoxPositionY: widget.desktopMentionBoxPositionY,
      activeMentionIndex: widget.activeMentionIndex,
      currentFilteredMembersListForMention:
          widget.currentFilteredMembersListForMention,
      setDesktopMentionBoxPositionX: widget.setDesktopMentionBoxPositionX,
      memberNeedToMention: widget.memberNeedToMention,
      setDesktopMentionBoxPositionY: widget.setDesktopMentionBoxPositionY,
      setActiveMentionIndex: widget.setActiveMentionIndex,
      desktopInputMemberSelectionPanelScroll:
          widget.desktopInputMemberSelectionPanelScroll,
      setCurrentFilteredMembersListForMention:
          widget.setCurrentFilteredMembersListForMention,
      groupMemberList: widget.groupMemberList,
    );
  }
}
