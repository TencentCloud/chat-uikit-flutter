import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';

class TencentCloudChatMessageLayoutContainer extends StatefulWidget {
  final String? userID;
  final String? groupID;
  final String? topicID;
  final PreferredSizeWidget header;
  final Widget messageListView;
  final Widget messageInput;

  const TencentCloudChatMessageLayoutContainer({super.key, this.userID, this.groupID, required this.header, required this.messageListView, required this.messageInput, this.topicID});

  @override
  State<TencentCloudChatMessageLayoutContainer> createState() => _TencentCloudChatMessageLayoutContainerState();
}

class _TencentCloudChatMessageLayoutContainerState extends TencentCloudChatState<TencentCloudChatMessageLayoutContainer> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;

  double _desktopMentionBoxPositionX = 0.0;
  double _desktopMentionBoxPositionY = 0.0;
  double _desktopStickerBoxPositionX = 0.0;
  double _desktopStickerBoxPositionY = 0.0;
  int _activeMentionIndex = 0;
  List<V2TimGroupMemberFullInfo?> _currentFilteredMembersListForMention = [];
  bool _init = false;

  void _dataProviderHandler() {
    if (dataProvider.desktopMentionBoxPositionX != _desktopMentionBoxPositionX) {
      safeSetState(() {
        _desktopMentionBoxPositionX = dataProvider.desktopMentionBoxPositionX;
      });
    }

    if (dataProvider.desktopMentionBoxPositionY != _desktopMentionBoxPositionY) {
      safeSetState(() {
        _desktopMentionBoxPositionY = dataProvider.desktopMentionBoxPositionY;
      });
    }

    if (dataProvider.activeMentionIndex != _activeMentionIndex) {
      safeSetState(() {
        _activeMentionIndex = dataProvider.activeMentionIndex;
      });
    }

    if (!TencentCloudChatUtils.deepEqual(dataProvider.currentFilteredMembersListForMention, _currentFilteredMembersListForMention)) {
      safeSetState(() {
        _currentFilteredMembersListForMention = dataProvider.currentFilteredMembersListForMention;
      });
    }
    if (dataProvider.desktopStickerBoxPositionX != _desktopStickerBoxPositionX || dataProvider.desktopStickerBoxPositionY != _desktopStickerBoxPositionY) {
      safeSetState(() {
        _desktopStickerBoxPositionX = dataProvider.desktopStickerBoxPositionX;
        _desktopStickerBoxPositionY = dataProvider.desktopStickerBoxPositionY;
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

  void _sendImageMessage({String? imagePath, String? imageName, dynamic inputElement}) {
    dataProvider.sendImageMessage(
      imagePath: imagePath,
      imageName: imageName,
      inputElement: inputElement,
    );
  }

  void _sendVideoMessage({String? videoPath, dynamic inputElement}) {
    dataProvider.sendVideoMessage(
      videoPath: videoPath,
      inputElement: inputElement,
    );
  }

  void _sendFileMessage({String? filePath, String? fileName, dynamic inputElement}) {
    dataProvider.sendFileMessage(
      filePath: filePath,
      fileName: fileName,
      inputElement: inputElement,
    );
  }

  void _sendVoiceMessage({required String voicePath, required int duration}) {
    dataProvider.sendVoiceMessage(voicePath, duration);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    String showName = dataProvider.conversation?.showName ?? "";
    if (showName.isEmpty) {
      if (TencentCloudChatUtils.checkString(dataProvider.groupID) != null) {
        final String groupShowName = TencentCloudChatUtils.checkString(dataProvider.groupInfo?.groupName) ?? dataProvider.groupID ?? "";
        if (groupShowName.isNotEmpty) {
          showName = groupShowName;
        }
      } else if (TencentCloudChatUtils.checkString(dataProvider.userID) != null) {
        showName = dataProvider.userID!;
      }
    }
    bool hasStickerPlugin = TencentCloudChat.instance.dataInstance.basic.hasPlugins("sticker");
    TencentCloudChatPlugin? stickerPluginInstance = TencentCloudChat.instance.dataInstance.basic.getPlugin("sticker")?.pluginInstance;
    
    return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageLayoutBuilder(
              data: MessageLayoutBuilderData(
                userID: widget.userID,
                groupID: widget.groupID,
                topicID: widget.topicID,
                currentConversationShowName: TencentCloudChatUtils.checkString(showName) ?? tL10n.chat,
                desktopMentionBoxPositionY: _desktopMentionBoxPositionY,
                desktopMentionBoxPositionX: _desktopMentionBoxPositionX,
                activeMentionIndex: _activeMentionIndex,
                currentFilteredMembersListForMention: _currentFilteredMembersListForMention,
                desktopStickerBoxPositionX: _desktopStickerBoxPositionX,
                desktopStickerBoxPositionY: _desktopStickerBoxPositionY,
                hasStickerPlugin: hasStickerPlugin,
                stickerPluginInstance: stickerPluginInstance,
              ),
              methods: MessageLayoutBuilderMethods(
                desktopInputMemberSelectionPanelScroll: dataProvider.desktopInputMemberSelectionPanelScroll,
                sendFileMessage: _sendFileMessage,
                sendVoiceMessage: _sendVoiceMessage,
                sendVideoMessage: _sendVideoMessage,
                sendImageMessage: _sendImageMessage,
                sendTextMessage: _sendTextMessage,
                onSelectMember: (({V2TimGroupMemberFullInfo memberFullInfo, int index}) memberData) {
                  // dataProvider.activeMentionIndex = memberData.index;
                  dataProvider.membersNeedToMention = [memberData.memberFullInfo];
                  dataProvider.currentFilteredMembersListForMention = [];
                },
                closeSticker: () {
                  dataProvider.closeSticker();
                },
              ),
              widgets: MessageLayoutBuilderWidgets(
                header: widget.header,
                messageListView: widget.messageListView,
                messageInput: widget.messageInput,
              ),
            ) ??
        Container();
  }
}
