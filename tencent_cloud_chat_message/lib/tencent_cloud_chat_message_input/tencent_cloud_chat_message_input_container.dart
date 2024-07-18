// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/tuicore/tencent_cloud_chat_core.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_permission_handlers.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_common/widgets/group_member_selector/tencent_cloud_chat_group_member_selector.dart';
import 'package:tencent_cloud_chat_common/widgets/modal/bottom_modal.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:universal_html/html.dart' as html;

class TencentCloudChatMessageInputContainer extends StatefulWidget {
  final String? userID;
  final String? groupID;
  final String? topicID;

  const TencentCloudChatMessageInputContainer({super.key, this.userID, this.groupID, this.topicID});

  @override
  State<TencentCloudChatMessageInputContainer> createState() => _TencentCloudChatMessageInputContainerState();
}

class _TencentCloudChatMessageInputContainerState extends TencentCloudChatState<TencentCloudChatMessageInputContainer> {
  late TencentCloudChatMessageSeparateDataProvider _dataProvider;
  late TencentCloudChatMessageController? _messageController;

  bool _inSelectMode = false;
  V2TimMessage? _repliedMessage;
  List<TencentCloudChatMessageGeneralOptionItem> _attachmentOrInputControlBarOptions = [];
  final TencentCloudChatMessageInputStatus _chatMessageInputStatus = TencentCloudChatMessageInputStatus.canSendMessage;

  double _desktopMentionBoxPositionX = 0.0;
  double _desktopMentionBoxPositionY = 0.0;
  int _activeMentionIndex = 0;
  List<V2TimGroupMemberFullInfo>? _membersNeedToMention;
  String? _specifiedMessageText;
  List<V2TimGroupMemberFullInfo?> _currentFilteredMembersListForMention = [];
  bool _init = false;
  List<V2TimGroupMemberFullInfo?> _groupMemberList = [];
  TencentCloudChatWidgetBuilder? _searchWidget;

  @override
  void initState() {
    super.initState();
    _searchWidget = TencentCloudChat.instance.dataInstance.basic.componentsMap[TencentCloudChatComponentsEnum.search];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      return;
    }
    _init = true;
    _dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
    _dataProvider.addListener(_dataProviderListener);
    _messageController = _dataProvider.messageController;
    _messageController?.addListener(_controllerEventListener);
    _dataProviderListener();
    _buildAttachmentOptionsList();
  }

  _openStickerPanel({Offset? offset}) {
    if (offset != null) {
      _dataProvider.setStickerPosition(offset);
    } else {
      TencentCloudChat.instance.logInstance
          .console(componentName: "TencentCloudChatMessageInputContainer", logs: "Icon click but the offset is null");
    }
  }

  @override
  void didUpdateWidget(TencentCloudChatMessageInputContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.userID != oldWidget.userID && widget.userID != null) ||
        (widget.topicID != oldWidget.topicID && widget.topicID != null) ||
        (widget.groupID != oldWidget.groupID && widget.groupID != null)) {
      _groupMemberList.clear();
      _membersNeedToMention?.clear();
      _specifiedMessageText = null;
      _activeMentionIndex = 0;
      _currentFilteredMembersListForMention.clear();
    }
  }

  void _buildAttachmentOptionsList() {
    final config = _dataProvider.config;
    final attachmentConfig = config.attachmentConfig(
      userID: _dataProvider.userID,
      topicID: _dataProvider.topicID,
      groupID: _dataProvider.groupID,
    );
    if (!TencentCloudChatPlatformAdapter().isMobile) {
      final defaultOptions = [
        if (attachmentConfig.enableSendFile)
          TencentCloudChatMessageGeneralOptionItem(
              iconAsset: (path: "lib/assets/send_file.svg", package: "tencent_cloud_chat_message"),
              label: tL10n.file,
              onTap: _sendFileFromExplorer),
        if (attachmentConfig.enableSendImage)
          TencentCloudChatMessageGeneralOptionItem(
              iconAsset: (path: "lib/assets/send_image.svg", package: "tencent_cloud_chat_message"),
              label: tL10n.image,
              onTap: _sendImage),
        if (attachmentConfig.enableSendVideo)
          TencentCloudChatMessageGeneralOptionItem(
              iconAsset: (path: "lib/assets/send_video.svg", package: "tencent_cloud_chat_message"),
              label: tL10n.video,
              onTap: ({Offset? offset}) => _sendMediaFromExplorer(
                    offset: offset,
                    fileType: FileType.video,
                  )),
        if (attachmentConfig.enableSearch && _searchWidget != null)
          TencentCloudChatMessageGeneralOptionItem(
            iconAsset: (path: "lib/assets/message_search.svg", package: "tencent_cloud_chat_message"),
            label: tL10n.search,
            onTap: ({Offset? offset}) => _showMessageSearch(),
          ),
      ];
      final additionalAttachmentOptionsForDesktop = config.additionalInputControlBarOptionsForDesktop(
        userID: _dataProvider.userID,
        groupID: _dataProvider.groupID,
        topicID: _dataProvider.topicID,
      );
      if (hasStickerPlugin && stickerPluginInstance != null) {
        defaultOptions.insert(
            0,
            TencentCloudChatMessageGeneralOptionItem(
                iconAsset: (path: "lib/assets/send_face.svg", package: "tencent_cloud_chat_message"),
                label: tL10n.sticker,
                onTap: _openStickerPanel));
      }
      _attachmentOrInputControlBarOptions = [...defaultOptions, ...additionalAttachmentOptionsForDesktop];
    } else {
      final defaultOptions = [
        if (attachmentConfig.enableSendFile)
          TencentCloudChatMessageGeneralOptionItem(
              iconAsset: (path: "lib/assets/send_file.svg", package: "tencent_cloud_chat_message"),
              label: tL10n.file,
              onTap: _sendFileFromExplorer),
        if (attachmentConfig.enableSendMediaFromMobileGallery)
          TencentCloudChatMessageGeneralOptionItem(
              iconAsset: (path: "lib/assets/send_image.svg", package: "tencent_cloud_chat_message"),
              label: tL10n.album,
              onTap: _sendMediaFromGallery),
        if (TencentCloudChat.instance.dataInstance.basic.useCallKit)
          TencentCloudChatMessageGeneralOptionItem(icon: Icons.call, label: tL10n.call, onTap: _startCall),
      ];
      final additionalAttachmentOptionsForMobile = config.additionalAttachmentOptionsForMobile(
        userID: _dataProvider.userID,
        topicID: _dataProvider.topicID,
        groupID: _dataProvider.groupID,
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
                groupMemberList:
                    _dataProvider.groupMemberList.where((element) => element != null).map((e) => e!).toList(),
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
                groupMemberList:
                    _dataProvider.groupMemberList.where((element) => element != null).map((e) => e!).toList(),
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

  void _showMessageSearch() {
    if (_searchWidget != null) {
      final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
      if (isDesktopScreen) {
        TencentCloudChatDesktopPopup.showPopupWindow(
          title: tL10n.search,
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.6,
          operationKey: TencentCloudChatPopupOperationKey.searchInChat,
          context: context,
          child: (closeFunc) => _searchWidget!(
            options: {
              "keyWord": "",
              "userID": widget.userID,
              "groupID": TencentCloudChatUtils.checkString(widget.topicID) ?? widget.groupID,
              "closeFunc": closeFunc,
            },
          ),
        );
      } else {}
    }
  }

  void _sendMediaFromExplorer({Offset? offset, required FileType fileType}) async {
    if (TencentCloudChatPlatformAdapter().isWeb) {
      try {
        final ImagePicker picker = ImagePicker();
        XFile? pickedFile;
        if (fileType == FileType.video) {
          pickedFile = await picker.pickVideo(source: ImageSource.gallery);
        } else {
          pickedFile = await picker.pickImage(source: ImageSource.gallery);
        }
        await pickedFile!.readAsBytes();
        final fileName = pickedFile.name;
        final tempFile = File(pickedFile.path);

        final String type =
            TencentCloudChatUtils.getFileType(fileName.split(".")[fileName.split(".").length - 1]).split("/")[0];

        html.Node? inputElem;
        inputElem = html.document.getElementById("__image_picker_web-file-input")?.querySelector("input");
        if (type == "image") {
          _sendImageMessage(
            inputElement: inputElem,
            imageName: fileName,
          );
        } else if (type == "video") {
          _sendVideoMessage(
            inputElement: inputElem,
            videoPath: tempFile.path,
          );
        }
      } catch (e) {
        debugPrint("_sendFileErr: ${e.toString()}");
      }
    } else {
      if ((TencentCloudChatPlatformAdapter().isMobile &&
              await TencentCloudChatPermissionHandler.checkPermission("photos", context)) ||
          !TencentCloudChatPlatformAdapter().isMobile) {
        final FilePickerResult? fileResult = await FilePicker.platform
            .pickFiles(allowMultiple: !TencentCloudChatPlatformAdapter().isWeb, type: fileType);

        for (final file in (fileResult?.files ?? [])) {
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
  }

  void _sendMediaFromGallery({Offset? offset}) async {
    if (TencentCloudChatPlatformAdapter().isWeb) {
      try {
        final ImagePicker picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        await pickedFile!.readAsBytes();
        final fileName = pickedFile.name;
        final tempFile = File(pickedFile.path);

        final String type =
            TencentCloudChatUtils.getFileType(fileName.split(".")[fileName.split(".").length - 1]).split("/")[0];

        html.Node? inputElem;
        inputElem = html.document.getElementById("__image_picker_web-file-input")?.querySelector("input");
        if (type == "image") {
          _sendImageMessage(
            inputElement: inputElem,
            imageName: fileName,
          );
        } else if (type == "video") {
          _sendVideoMessage(
            inputElement: inputElem,
            videoPath: tempFile.path,
          );
        }
      } catch (e) {
        debugPrint("_sendFileErr: ${e.toString()}");
      }
    } else {
      if ((TencentCloudChatPlatformAdapter().isMobile &&
              await TencentCloudChatPermissionHandler.checkPermission("photos", context)) ||
          !TencentCloudChatPlatformAdapter().isMobile) {
        final ImagePicker picker = ImagePicker();
        final pickedFile = await picker.pickMultipleMedia();

        for (final file in pickedFile) {
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
  }

  void _sendImage({Offset? offset}) async {
    if (TencentCloudChatPlatformAdapter().isWeb) {
      _sendMediaFromExplorer(offset: offset, fileType: FileType.image);
    } else if ((TencentCloudChatPlatformAdapter().isMobile &&
            await TencentCloudChatPermissionHandler.checkPermission("photos", context)) ||
        !TencentCloudChatPlatformAdapter().isMobile) {
      final FilePickerResult? fileResult = await FilePicker.platform
          .pickFiles(allowMultiple: !TencentCloudChatPlatformAdapter().isWeb, type: FileType.image);

      for (final file in (fileResult?.files ?? [])) {
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

  void _sendFileFromExplorer({Offset? offset}) async {
    if ((TencentCloudChatPlatformAdapter().isMobile &&
            await TencentCloudChatPermissionHandler.checkPermission("storage", context)) ||
        !TencentCloudChatPlatformAdapter().isMobile) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: !TencentCloudChatPlatformAdapter().isWeb);

      if (result != null && result.files.isNotEmpty) {
        if (TencentCloudChatPlatformAdapter().isWeb) {
          html.Node? inputElem;
          inputElem = html.document.getElementById("__file_picker_web-file-input")?.querySelector("input");
          final fileName = result.files.single.name;
          final fileSize = result.files.single.size;
          if (fileSize > 100 * 1024 * 1024) {
            TencentCloudChat.instance.callbacks
                .onSDKFailed("sendMessage", 1020, "The selected file exceeds 100M and the sending is interrupted.");
            return;
          }
          _sendFileMessage(inputElement: inputElem, fileName: fileName);
        } else {
          List<File> files = result.paths.map((path) => File(path!)).toList();
          for (var element in files) {
            _sendFileMessage(filePath: element.path);
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dataProvider.removeListener(_dataProviderListener);
    _messageController?.removeListener(_controllerEventListener);
  }

  closeSticker() {
    _dataProvider.closeSticker();
  }

  void _controllerEventListener() {
    final current = (_messageController?.userID == widget.userID &&
            TencentCloudChatUtils.checkString(widget.userID) != null) ||
        (_messageController?.topicID == widget.topicID && TencentCloudChatUtils.checkString(widget.topicID) != null) ||
        (_messageController?.groupID == widget.groupID && TencentCloudChatUtils.checkString(widget.groupID) != null);
    if (current) {
      final event = _messageController?.eventName;
      switch (event) {
        case EventName.setMessageTextWithMentions:
          if (_messageController?.eventValue != null) {
            safeSetState(() {
              _specifiedMessageText = _messageController?.eventValue;
              _membersNeedToMention = _messageController?.groupMembersFullInfo;
            });
          }
          break;
        case EventName.mentionGroupMembers:
          if (_messageController?.groupMembersFullInfo != null &&
              !TencentCloudChatUtils.deepEqual(_messageController!.groupMembersFullInfo, _membersNeedToMention)) {
            safeSetState(() {
              _membersNeedToMention = _messageController?.groupMembersFullInfo;
            });
          }
          break;
        default:
          break;
      }
    }
  }

  void _dataProviderListener() {
    bool needSetState = false;

    if (_groupMemberList.length != _dataProvider.groupMemberList.length) {
      _groupMemberList = _dataProvider.groupMemberList;
      needSetState = true;
    }

    /// _inSelectMode
    if (_inSelectMode != _dataProvider.inSelectMode) {
      _inSelectMode = _dataProvider.inSelectMode;
      needSetState = true;
    }

    /// _repliedMessage
    if (_repliedMessage != _dataProvider.repliedMessage) {
      _repliedMessage = _dataProvider.repliedMessage;
      needSetState = true;
    }

    if (_dataProvider.desktopMentionBoxPositionX != _desktopMentionBoxPositionX) {
      _desktopMentionBoxPositionX = _dataProvider.desktopMentionBoxPositionX;
      needSetState = true;
    }

    if (_dataProvider.desktopMentionBoxPositionY != _desktopMentionBoxPositionY) {
      _desktopMentionBoxPositionY = _dataProvider.desktopMentionBoxPositionY;
      needSetState = true;
    }

    if (_dataProvider.activeMentionIndex != _activeMentionIndex) {
      _activeMentionIndex = _dataProvider.activeMentionIndex;
      needSetState = true;
    }

    if (_dataProvider.membersNeedToMention != _membersNeedToMention) {
      _membersNeedToMention = _dataProvider.membersNeedToMention;
      needSetState = true;
    }

    if (!TencentCloudChatUtils.deepEqual(
        _dataProvider.currentFilteredMembersListForMention, _currentFilteredMembersListForMention)) {
      _currentFilteredMembersListForMention = _dataProvider.currentFilteredMembersListForMention;
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
    _dataProvider.sendTextMessage(text, mentionedUsers ?? []);
  }

  void _sendImageMessage({String? imagePath, String? imageName, dynamic inputElement}) {
    _dataProvider.sendImageMessage(
      imagePath: imagePath,
      imageName: imageName,
      inputElement: inputElement,
    );
  }

  void _sendVideoMessage({String? videoPath, dynamic inputElement}) {
    _dataProvider.sendVideoMessage(
      videoPath: videoPath,
      inputElement: inputElement,
    );
  }

  void _sendFileMessage({String? filePath, String? fileName, dynamic inputElement}) {
    _dataProvider.sendFileMessage(
      filePath: filePath,
      fileName: fileName,
      inputElement: inputElement,
    );
  }

  void _sendVoiceMessage({required String voicePath, required int duration}) {
    _dataProvider.sendVoiceMessage(voicePath, duration);
  }

  Future<List<V2TimGroupMemberFullInfo>> _onChooseGroupMembers(
      {int? maxSelectionAmount, String? onSelectLabel, String? title}) async {
    final List<V2TimGroupMemberFullInfo> memberList = await showGroupMemberSelector(
      groupMemberList: _dataProvider.groupMemberList.where((element) => element != null).map((e) => e!).toList(),
      context: context,
      maxSelectionAmount: maxSelectionAmount,
      onSelectLabel: onSelectLabel,
      title: title,
    );
    return memberList;
  }

  String currentUserid = TencentCloudChat.instance.dataInstance.basic.currentUser?.userID ?? "";
  bool hasStickerPlugin = TencentCloudChat.instance.dataInstance.basic.hasPlugins("sticker");
  TencentCloudChatPlugin? stickerPluginInstance =
      TencentCloudChat.instance.dataInstance.basic.getPlugin("sticker")?.pluginInstance;

  @override
  Widget defaultBuilder(BuildContext context) {
    bool isGroupAdmin = false;
    try {
      if (TencentCloudChatUtils.checkString(widget.groupID) != null) {
        final selfInfo = _dataProvider.groupMemberList.firstWhere((element) =>
            element?.userID == currentUserid && TencentCloudChatUtils.checkString(element?.userID) != null);
        if (selfInfo != null) {
          final selfRole = selfInfo.role;
          isGroupAdmin = (selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN ||
              selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER);
        }
      }
    } catch (e) {
      isGroupAdmin = false;
    }

    String showName = _dataProvider.conversation?.showName ?? "";
    if (showName.isEmpty) {
      if (TencentCloudChatUtils.checkString(_dataProvider.groupID) != null) {
        final String groupShowName =
            TencentCloudChatUtils.checkString(_dataProvider.groupInfo?.groupName) ?? _dataProvider.groupID ?? "";
        if (groupShowName.isNotEmpty) {
          showName = groupShowName;
        }
      } else if (TencentCloudChatUtils.checkString(_dataProvider.userID) != null) {
        showName = _dataProvider.userID!;
      }
    }

    return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageInputBuilder(
              data: MessageInputBuilderData(
                status: _chatMessageInputStatus,
                userID: widget.userID,
                topicID: widget.topicID,
                isGroupAdmin: isGroupAdmin,
                enableReplyWithMention: _dataProvider.config.enableReplyWithMention(
                  userID: _dataProvider.userID,
                  groupID: _dataProvider.groupID,
                  topicID: widget.topicID,
                ),
                groupID: widget.groupID,
                attachmentOptions: _attachmentOrInputControlBarOptions,
                inSelectMode: _inSelectMode,
                selectedMessages: TencentCloudChatMessageDataProviderInherited.of(context).selectedMessages,
                repliedMessage: _repliedMessage,
                desktopMentionBoxPositionX: _desktopMentionBoxPositionX,
                desktopMentionBoxPositionY: _desktopMentionBoxPositionY,
                groupMemberList: _groupMemberList
                    .where((element) => element != null)
                    .map((e) => e!)
                    .where((element) => element.userID != currentUserid)
                    .toList(),
                activeMentionIndex: _activeMentionIndex,
                specifiedMessageText: _specifiedMessageText,
                currentFilteredMembersListForMention: _currentFilteredMembersListForMention,
                membersNeedToMention: _membersNeedToMention,
                currentConversationShowName: TencentCloudChatUtils.checkString(showName) ?? tL10n.chat,
                hasStickerPlugin: hasStickerPlugin,
                stickerPluginInstance: stickerPluginInstance,
              ),
              methods: MessageInputBuilderMethods(
                controller: _dataProvider.messageController,
                sendTextMessage: _sendTextMessage,
                sendVideoMessage: _sendVideoMessage,
                sendImageMessage: _sendImageMessage,
                sendVoiceMessage: _sendVoiceMessage,
                sendFileMessage: _sendFileMessage,
                messageAttachmentOptionsBuilder: _dataProvider.messageBuilders!.getAttachmentOptionsBuilder,
                clearRepliedMessage: () => _dataProvider.repliedMessage = null,
                onChooseGroupMembers: _onChooseGroupMembers,
                desktopInputMemberSelectionPanelScroll: _dataProvider.desktopInputMemberSelectionPanelScroll,
                setDesktopMentionBoxPositionX: (value) => _dataProvider.desktopMentionBoxPositionX = value,
                setDesktopMentionBoxPositionY: (value) => _dataProvider.desktopMentionBoxPositionY = value,
                setActiveMentionIndex: (value) => _dataProvider.activeMentionIndex = value,
                setCurrentFilteredMembersListForMention: (value) =>
                    _dataProvider.currentFilteredMembersListForMention = value,
                closeSticker: () {
                  _dataProvider.closeSticker();
                },
              ),
            ) ??
        Container();
  }
}
