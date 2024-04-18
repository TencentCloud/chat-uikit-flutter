// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/tuicore/tencent_cloud_chat_core.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_permission_handlers.dart';
import 'package:tencent_cloud_chat_common/widgets/group_member_selector/tencent_cloud_chat_group_member_selector.dart';
import 'package:tencent_cloud_chat_common/widgets/modal/bottom_modal.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';

class TencentCloudChatMessageInputContainer extends StatefulWidget {
  final String? userID;
  final String? groupID;

  const TencentCloudChatMessageInputContainer({super.key, this.userID, this.groupID});

  @override
  State<TencentCloudChatMessageInputContainer> createState() => _TencentCloudChatMessageInputContainerState();
}

class _TencentCloudChatMessageInputContainerState extends TencentCloudChatState<TencentCloudChatMessageInputContainer> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;
  bool _inSelectMode = false;
  V2TimMessage? _repliedMessage;
  List<TencentCloudChatMessageGeneralOptionItem> _attachmentOrInputControlBarOptions = [];
  final TencentCloudChatMessageInputStatus _chatMessageInputStatus = TencentCloudChatMessageInputStatus.canSendMessage;

  double _desktopMentionBoxPositionX = 0.0;
  double _desktopMentionBoxPositionY = 0.0;
  int _activeMentionIndex = 0;
  V2TimGroupMemberFullInfo? _memberNeedToMention;
  List<V2TimGroupMemberFullInfo?> _currentFilteredMembersListForMention = [];
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      return;
    }
    _init = true;
    dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
    dataProvider.addListener(_dataProviderListener);
    _dataProviderListener();
    _buildAttachmentOptionsList();
  }

  void _buildAttachmentOptionsList() {
    final config = dataProvider.config;
    if (!TencentCloudChatPlatformAdapter().isMobile) {
      final defaultOptions = [
        TencentCloudChatMessageGeneralOptionItem(icon: Icons.insert_drive_file_outlined, label: tL10n.file, onTap: _sendFileFromExplorer),
        TencentCloudChatMessageGeneralOptionItem(icon: Icons.image_outlined, label: tL10n.image, onTap: _sendImage),
        TencentCloudChatMessageGeneralOptionItem(icon: Icons.perm_media_outlined, label: tL10n.media, onTap: _sendMediaFromGallery),
      ];
      final additionalAttachmentOptionsForDesktop = config.additionalInputControlBarOptionsForDesktop(
        userID: dataProvider.userID,
        groupID: dataProvider.groupID,
      );
      _attachmentOrInputControlBarOptions = [...defaultOptions, ...additionalAttachmentOptionsForDesktop];
    } else {
      final defaultOptions = [
        TencentCloudChatMessageGeneralOptionItem(icon: Icons.insert_drive_file, label: tL10n.file, onTap: _sendFileFromExplorer),
        TencentCloudChatMessageGeneralOptionItem(icon: Icons.photo_library, label: tL10n.album, onTap: _sendMediaFromGallery),
        if (TencentCloudChat.instance.dataInstance.basic.useCallKit) TencentCloudChatMessageGeneralOptionItem(icon: Icons.call, label: tL10n.call, onTap: _startCall),
      ];
      final additionalAttachmentOptionsForMobile = config.additionalAttachmentOptionsForMobile(
        userID: dataProvider.userID,
        groupID: dataProvider.groupID,
      );
      _attachmentOrInputControlBarOptions = [...defaultOptions, ...additionalAttachmentOptionsForMobile];
    }
  }

  void _startCall({Offset? offset}) {
    showTencentCloudChatBottomModal(
      context: context,
      actions: [
        TencentCloudChatModalAction(
          label: tL10n.voiceCall,
          icon: Icons.call,
          onTap: () async {
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
          },
        ),
        TencentCloudChatModalAction(
          label: tL10n.videoCall,
          icon: Icons.videocam,
          onTap: () async {
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
          },
        ),
      ],
    );
  }

  void _sendMediaFromGallery({Offset? offset}) async {
    if (TencentCloudChatPlatformAdapter().isMobile && await TencentCloudChatPermissionHandler.checkPermission("photos", context)) {
      final ImagePicker picker = ImagePicker();
      final List<XFile> files = await picker.pickMultipleMedia();

      for (final file in files) {
        final String fileExtension = file.path.split('.').last.toLowerCase();
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'webp'].contains(fileExtension)) {
          _sendImageMessage(imagePath: file.path);
        } else if (['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'mpeg', 'webm', '3gp'].contains(fileExtension)) {
          _sendVideoMessage(videoPath: file.path);
        } else {
          // Unsupported file type
          debugPrint('Unsupported file type: $fileExtension');
        }
      }
    }
  }

  void _sendImage({Offset? offset}) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> files = await picker.pickMultiImage();

    for (final file in files) {
      final String fileExtension = file.path.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'webp'].contains(fileExtension)) {
        _sendImageMessage(imagePath: file.path);
      } else if (['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'mpeg', 'webm', '3gp'].contains(fileExtension)) {
        _sendVideoMessage(videoPath: file.path);
      } else {
        // Unsupported file type
        debugPrint('Unsupported file type: $fileExtension');
      }
    }
  }

  void _sendVideo({Offset? offset}) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> files = await picker.pickMultipleMedia();

    for (final file in files) {
      final String fileExtension = file.path.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'webp'].contains(fileExtension)) {
        _sendImageMessage(imagePath: file.path);
      } else if (['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'mpeg', 'webm', '3gp'].contains(fileExtension)) {
        _sendVideoMessage(videoPath: file.path);
      } else {
        // Unsupported file type
        debugPrint('Unsupported file type: $fileExtension');
      }
    }
  }

  void _sendFileFromExplorer({Offset? offset}) async {
    if (TencentCloudChatPlatformAdapter().isMobile && await TencentCloudChatPermissionHandler.checkPermission("storage", context)) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        for (var element in files) {
          _sendFileMessage(filePath: element.path);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    dataProvider.removeListener(_dataProviderListener);
  }

  void _dataProviderListener() {
    bool needSetState = false;

    /// _inSelectMode
    if (_inSelectMode != dataProvider.inSelectMode) {
      _inSelectMode = dataProvider.inSelectMode;
      needSetState = true;
    }

    /// _repliedMessage
    if (_repliedMessage != dataProvider.repliedMessage) {
      _repliedMessage = dataProvider.repliedMessage;
      needSetState = true;
    }

    if (dataProvider.desktopMentionBoxPositionX != _desktopMentionBoxPositionX) {
      _desktopMentionBoxPositionX = dataProvider.desktopMentionBoxPositionX;
      needSetState = true;
    }

    if (dataProvider.desktopMentionBoxPositionY != _desktopMentionBoxPositionY) {
      _desktopMentionBoxPositionY = dataProvider.desktopMentionBoxPositionY;
      needSetState = true;
    }

    if (dataProvider.activeMentionIndex != _activeMentionIndex) {
      _activeMentionIndex = dataProvider.activeMentionIndex;
      needSetState = true;
    }

    if (dataProvider.memberNeedToMention != _memberNeedToMention) {
      _memberNeedToMention = dataProvider.memberNeedToMention;
      needSetState = true;
    }

    if (!TencentCloudChatUtils.deepEqual(dataProvider.currentFilteredMembersListForMention, _currentFilteredMembersListForMention)) {
      _currentFilteredMembersListForMention = dataProvider.currentFilteredMembersListForMention;
      needSetState = true;
    }

    if (needSetState) {
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() {});
      });
    }
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

  Future<List<V2TimGroupMemberFullInfo>> _onChooseGroupMembers({int? maxSelectionAmount, String? onSelectLabel, String? title}) async {
    final List<V2TimGroupMemberFullInfo> memberList = await showGroupMemberSelector(
      groupMemberList: dataProvider.groupMemberList.where((element) => element != null).map((e) => e!).toList(),
      context: context,
      maxSelectionAmount: maxSelectionAmount,
      onSelectLabel: onSelectLabel,
      title: title,
    );
    return memberList;
  }

  String currentUserid = TencentCloudChat.instance.dataInstance.basic.currentUser?.userID ?? "";

  @override
  Widget defaultBuilder(BuildContext context) {
    bool isGroupAdmin = false;
    try {
      if (TencentCloudChatUtils.checkString(widget.groupID) != null) {
        final selfInfo = dataProvider.groupMemberList.firstWhere((element) => element?.userID == currentUserid && TencentCloudChatUtils.checkString(element?.userID) != null);
        if (selfInfo != null) {
          final selfRole = selfInfo.role;
          isGroupAdmin = (selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN || selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER);
        }
      }
    } catch (e) {
      isGroupAdmin = false;
    }

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

    return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageInputBuilder(
      controller: dataProvider.messageController,
      sendTextMessage: _sendTextMessage,
      sendVideoMessage: _sendVideoMessage,
      sendImageMessage: _sendImageMessage,
      sendVoiceMessage: _sendVoiceMessage,
      status: _chatMessageInputStatus,
      sendFileMessage: _sendFileMessage,
      userID: widget.userID,
      messageAttachmentOptionsBuilder: dataProvider.messageBuilders?.getAttachmentOptionsBuilder,
      isGroupAdmin: isGroupAdmin,
      groupID: widget.groupID,
      attachmentOrInputControlBarOptions: _attachmentOrInputControlBarOptions,
      inSelectMode: _inSelectMode,
      selectedMessages: TencentCloudChatMessageDataProviderInherited.of(context).selectedMessages,
      repliedMessage: _repliedMessage,
      clearRepliedMessage: () => dataProvider.repliedMessage = null,
      onChooseGroupMembers: _onChooseGroupMembers,
      desktopInputMemberSelectionPanelScroll: dataProvider.desktopInputMemberSelectionPanelScroll,
      desktopMentionBoxPositionX: _desktopMentionBoxPositionX,
      desktopMentionBoxPositionY: _desktopMentionBoxPositionY,
      groupMemberList: dataProvider.groupMemberList.where((element) => element != null).map((e) => e!).where((element) => element.userID != currentUserid).toList(),
      activeMentionIndex: _activeMentionIndex,
      currentFilteredMembersListForMention: _currentFilteredMembersListForMention,
      setDesktopMentionBoxPositionX: (value) => dataProvider.desktopMentionBoxPositionX = value,
      setDesktopMentionBoxPositionY: (value) => dataProvider.desktopMentionBoxPositionY = value,
      setActiveMentionIndex: (value) => dataProvider.activeMentionIndex = value,
      setCurrentFilteredMembersListForMention: (value) => dataProvider.currentFilteredMembersListForMention = value,
      memberNeedToMention: _memberNeedToMention,
      currentConversationShowName: TencentCloudChatUtils.checkString(showName) ?? tL10n.chat,
    ) ?? Container();
  }
}
