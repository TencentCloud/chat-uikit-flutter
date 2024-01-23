import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';

class TencentCloudChatMessageLayoutContainer extends StatefulWidget {
  final String? userID;
  final String? groupID;
  final PreferredSizeWidget header;
  final Widget messageListView;
  final Widget messageInput;

  const TencentCloudChatMessageLayoutContainer(
      {super.key,
      this.userID,
      this.groupID,
      required this.header,
      required this.messageListView,
      required this.messageInput});

  @override
  State<TencentCloudChatMessageLayoutContainer> createState() =>
      _TencentCloudChatMessageLayoutContainerState();
}

class _TencentCloudChatMessageLayoutContainerState
    extends TencentCloudChatState<TencentCloudChatMessageLayoutContainer> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;

  double _desktopMentionBoxPositionX = 0.0;
  double _desktopMentionBoxPositionY = 0.0;
  int _activeMentionIndex = 0;
  List<V2TimGroupMemberFullInfo?> _currentFilteredMembersListForMention = [];
  bool _init = false;

  void _dataProviderHandler() {
    if (dataProvider.desktopMentionBoxPositionX !=
        _desktopMentionBoxPositionX) {
      setState(() {
        _desktopMentionBoxPositionX = dataProvider.desktopMentionBoxPositionX;
      });
    }

    if (dataProvider.desktopMentionBoxPositionY !=
        _desktopMentionBoxPositionY) {
      setState(() {
        _desktopMentionBoxPositionY = dataProvider.desktopMentionBoxPositionY;
      });
    }

    if (dataProvider.activeMentionIndex != _activeMentionIndex) {
      setState(() {
        _activeMentionIndex = dataProvider.activeMentionIndex;
      });
    }

    if (!TencentCloudChatUtils.deepEqual(
        dataProvider.currentFilteredMembersListForMention,
        _currentFilteredMembersListForMention)) {
      setState(() {
        _currentFilteredMembersListForMention =
            dataProvider.currentFilteredMembersListForMention;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      return;
    }
    _init = true;
    dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
    dataProvider.addListener(_dataProviderHandler);
  }

  void _sendTextMessage({
    required String text,
    List<String>? mentionedUsers,
  }) {
    dataProvider.sendTextMessage(text, mentionedUsers ?? []);
  }

  void _sendImageMessage({required String imagePath}) {
    dataProvider.sendImageMessage(imagePath);
  }

  void _sendVideoMessage({required String videoPath}) {
    dataProvider.sendVideoMessage(videoPath);
  }

  void _sendFileMessage({required String filePath}) {
    dataProvider.sendFileMessage(filePath);
  }

  void _sendVoiceMessage({required String voicePath, required int duration}) {
    dataProvider.sendVoiceMessage(voicePath, duration);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    String showName = dataProvider.conversation?.showName ?? "";
    if (showName.isEmpty) {
      if (TencentCloudChatUtils.checkString(dataProvider.groupID) != null) {
        final String groupShowName = TencentCloudChatUtils.checkString(
                dataProvider.groupInfo?.groupName) ??
            dataProvider.groupID ??
            "";
        if (groupShowName.isNotEmpty) {
          showName = groupShowName;
        }
      } else if (TencentCloudChatUtils.checkString(dataProvider.userID) !=
          null) {
        showName = dataProvider.userID!;
      }
    }

    return TencentCloudChatMessageBuilders.getMessageLayoutBuilder(
      userID: widget.userID,
      groupID: widget.groupID,
      header: widget.header,
      messageListView: widget.messageListView,
      messageInput: widget.messageInput,
      currentConversationShowName:
          TencentCloudChatUtils.checkString(showName) ?? tL10n.chat,
      desktopMentionBoxPositionY: _desktopMentionBoxPositionY,
      desktopMentionBoxPositionX: _desktopMentionBoxPositionX,
      activeMentionIndex: _activeMentionIndex,
      currentFilteredMembersListForMention:
          _currentFilteredMembersListForMention,
      desktopInputMemberSelectionPanelScroll:
          dataProvider.desktopInputMemberSelectionPanelScroll,
      sendFileMessage: _sendFileMessage,
      sendVoiceMessage: _sendVoiceMessage,
      sendVideoMessage: _sendVideoMessage,
      sendImageMessage: _sendImageMessage,
      sendTextMessage: _sendTextMessage,
      onSelectMember:
          (({V2TimGroupMemberFullInfo memberFullInfo, int index}) memberData) {
        // dataProvider.activeMentionIndex = memberData.index;
        dataProvider.memberNeedToMention = memberData.memberFullInfo;
        dataProvider.currentFilteredMembersListForMention = [];
      },
    );
  }
}
