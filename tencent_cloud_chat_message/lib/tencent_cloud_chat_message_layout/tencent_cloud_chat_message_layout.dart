
import 'package:desktop_drop_for_t/desktop_drop_for_t.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/common/for_desktop/file_tools.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/desktop/tencent_cloud_chat_message_input_member_mention_panel.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/special_case/tencent_cloud_chat_message_drop_target.dart';

class TencentCloudChatMessageLayout extends StatefulWidget {
  final String? userID;
  final String? groupID;
  final PreferredSizeWidget header;
  final Widget messageListView;
  final Widget messageInput;

  final Function({
    required String text,
    List<String>? mentionedUsers,
  }) sendTextMessage;
  final Function({required String imagePath}) sendImageMessage;
  final Function({required String videoPath}) sendVideoMessage;
  final Function({required String filePath}) sendFileMessage;
  final Function({required String voicePath, required int duration})
      sendVoiceMessage;
  final String currentConversationShowName;

  /// Desktop member selection
  final double desktopMentionBoxPositionX;
  final double desktopMentionBoxPositionY;
  final int activeMentionIndex;
  final List<V2TimGroupMemberFullInfo?> currentFilteredMembersListForMention;
  final ValueChanged<({V2TimGroupMemberFullInfo memberFullInfo, int index})>
      onSelectMember;
  final AutoScrollController desktopInputMemberSelectionPanelScroll;

  const TencentCloudChatMessageLayout({
    super.key,
    required this.header,
    required this.messageListView,
    required this.messageInput,
    this.userID,
    this.groupID,
    required this.desktopMentionBoxPositionX,
    required this.desktopMentionBoxPositionY,
    required this.activeMentionIndex,
    required this.currentFilteredMembersListForMention,
    required this.onSelectMember,
    required this.desktopInputMemberSelectionPanelScroll,
    required this.sendImageMessage,
    required this.sendVideoMessage,
    required this.sendFileMessage,
    required this.sendTextMessage,
    required this.sendVoiceMessage,
    required this.currentConversationShowName,
  }) : assert((userID == null) != (groupID == null));

  @override
  State<TencentCloudChatMessageLayout> createState() =>
      _TencentCloudChatMessageLayoutState();
}

class _TencentCloudChatMessageLayoutState
    extends TencentCloudChatState<TencentCloudChatMessageLayout> {
  bool _dragging = false;

  @override
  Widget defaultBuilder(BuildContext context) {
    return Scaffold(
      appBar: widget.header,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: widget.messageListView,
          )),
          widget.messageInput,
        ],
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.header,
      body: DropTarget(
          onDragDone: (detail) {
            setState(() {
              _dragging = false;
            });
            final filesPath = detail.files.map((e) => e.path).toList();
            TencentCloudChatDesktopFileTools.sendFileWithConfirmation(
              filesPath: filesPath,
              currentConversationShowName: widget.currentConversationShowName,
              sendFileMessage: widget.sendFileMessage,
              context: context,
            );
          },
          onDragEntered: (detail) {
            setState(() {
              _dragging = true;
            });
          },
          onDragExited: (detail) {
            setState(() {
              _dragging = false;
            });
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: widget.messageListView,
                  )),
                  widget.messageInput,
                ],
              ),
              TencentCloudChatDesktopMemberMentionPanel(
                atMemberPanelScroll:
                    widget.desktopInputMemberSelectionPanelScroll,
                onSelectMember: widget.onSelectMember,
                desktopMentionBoxPositionX: widget.desktopMentionBoxPositionX,
                desktopMentionBoxPositionY: widget.desktopMentionBoxPositionY,
                activeMentionIndex: widget.activeMentionIndex,
                currentFilteredMembersListForMention:
                    widget.currentFilteredMembersListForMention,
              ),
              if (_dragging)
                TencentCloudChatMessageDropTarget(
                  currentConversationShowName:
                      widget.currentConversationShowName,
                ),
            ],
          )),
    );
  }
}
