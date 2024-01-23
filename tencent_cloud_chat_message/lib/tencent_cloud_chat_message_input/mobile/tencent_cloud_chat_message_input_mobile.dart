import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/message_reply/tencent_cloud_chat_message_input_reply_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_attachment_options.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_camera.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_input_recording.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/select_mode/tencent_cloud_chat_message_input_select_mode_container.dart';

class TencentCloudChatMessageInputMobile extends StatefulWidget {
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
  final TencentCloudChatMessageController messageController;
  final Future<List<V2TimGroupMemberFullInfo>> Function({
    int? maxSelectionAmount,
    String? title,
    String? onSelectLabel,
  }) onChooseGroupMembers;
  final List<TencentCloudChatMessageGeneralOptionItem> attachmentOptions;
  final String? statusText;
  final FocusNode focusNode;
  final TextEditingController textEditingController;

  const TencentCloudChatMessageInputMobile({
    super.key,
    this.userID,
    this.groupID,
    required this.sendTextMessage,
    required this.sendImageMessage,
    required this.sendVideoMessage,
    required this.sendFileMessage,
    required this.sendVoiceMessage,
    required this.inSelectMode,
    required this.selectedMessages,
    this.repliedMessage,
    required this.messageController,
    required this.onChooseGroupMembers,
    required this.attachmentOptions,
    this.statusText,
    required this.focusNode,
    required this.textEditingController,
  });

  @override
  State<TencentCloudChatMessageInputMobile> createState() =>
      _TencentCloudChatMessageInputMobileState();
}

class _TencentCloudChatMessageInputMobileState
    extends TencentCloudChatState<TencentCloudChatMessageInputMobile>
    with TickerProviderStateMixin {
  final GlobalKey<TooltipState> micTooltipKey = GlobalKey<TooltipState>();
  final TencentCloudChatMessageAttachmentOptions _messageAttachmentOptions =
      TencentCloudChatMessageAttachmentOptions();
  final GlobalKey<TencentCloudChatMessageInputRecordingState>
      _recordingWidgetKey = GlobalKey();
  final List<({String userID, String label})> _mentionedUsers = [];

  late AnimationController _animationController;

  bool _showStickerPanel = false;
  bool _showKeyboard = false;
  bool _isRecording = false;
  bool _showSendButton = false;
  Timer? _recordingStarter;
  double? _bottomPadding;
  String _inputText = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _messageAttachmentOptions.init(vsync: this, context: context);
    widget.textEditingController.addListener(_onTextChanged);
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        setState(() {
          _showKeyboard = true;
          _showStickerPanel = false;
        });
      } else {
        setState(() {
          _showKeyboard = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.textEditingController.dispose();
    _messageAttachmentOptions.dispose();
    super.dispose();
  }

  Widget _buildInputAreaIcon({
    required IconData icon,
    required GestureTapCallback onTap,
  }) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  margin: EdgeInsets.only(bottom: getSquareSize(1.5)),
                  padding: EdgeInsets.all(getSquareSize(8)),
                  child: Icon(
                    icon,
                    size: textStyle.inputAreaIcon,
                    color: colorTheme.inputAreaIconColor,
                  ),
                ),
              ),
            ));
  }

  void _onStartRecording(PointerDownEvent event) {
    _recordingStarter?.cancel();
    _recordingStarter = Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _isRecording = true;
      });
      _recordingWidgetKey.currentState?.startRecording();
    });
  }

  void _onTextChanged() async {
    final newText = widget.textEditingController.text;

    /// Send Button Animation
    if (newText.isNotEmpty != _showSendButton) {
      setState(() {
        _showSendButton = !_showSendButton;
      });
      if (_showSendButton) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }

    /// Dealing with mentioning member in group
    if (TencentCloudChatUtils.checkString(widget.groupID) != null) {
      final compareResult =
          TencentCloudChatUtils.compareString(_inputText, newText);
      if (compareResult.isAddText && compareResult.character == "@") {
        /// Add "@" mentioned member tag
        final List<V2TimGroupMemberFullInfo> memberList =
            await widget.onChooseGroupMembers();

        final mentionTextList = memberList.map((targetMember) {
          final String targetMemberLabel =
              TencentCloudChatUtils.checkString(targetMember.nameCard) ??
                  TencentCloudChatUtils.checkString(targetMember.nickName) ??
                  targetMember.userID;

          _mentionedUsers
              .add((label: targetMemberLabel, userID: targetMember.userID));
          return "@$targetMemberLabel ";
        }).toList();
        final mentionText = mentionTextList.join();

        /// Insert mentionText after the "@" character
        final updatedText = newText.replaceRange(
            compareResult.index, compareResult.index + 1, mentionText);
        widget.textEditingController.text = updatedText;
        widget.textEditingController.selection = TextSelection.collapsed(
            offset: compareResult.index + mentionText.length);
      } else if (!compareResult.isAddText) {
        final atIndex =
            _inputText.lastIndexOf('@', max(0, compareResult.index - 1));
        final removedLabelList = [];
        if (atIndex != -1) {
          removedLabelList
              .add(_inputText.substring(atIndex + 1, compareResult.index));

          int spaceIndex = compareResult.index;
          int count = 0;

          while (spaceIndex != -1 && count < 5) {
            spaceIndex = _inputText.indexOf(' ', spaceIndex + 1);
            if (spaceIndex != -1) {
              removedLabelList
                  .add(_inputText.substring(atIndex + 1, spaceIndex));
              count++;
            } else {
              removedLabelList.add(_inputText.substring(atIndex + 1));
            }
          }

          final mentionedUserExist = _mentionedUsers
              .any((user) => removedLabelList.contains(user.label));

          if (mentionedUserExist) {
            final mentionedUser = _mentionedUsers
                .firstWhere((user) => removedLabelList.contains(user.label));
            final updatedText = newText.replaceRange(
                atIndex, atIndex + 1 + mentionedUser.label.length, '');
            widget.textEditingController.text = updatedText;
            widget.textEditingController.selection =
                TextSelection.collapsed(offset: atIndex);
            _mentionedUsers
                .removeWhere((user) => user.label == mentionedUser.label);
          }
        }
      }
    }

    /// End
    _inputText = widget.textEditingController.text;
  }

  void _onStopRecording(PointerUpEvent event) {
    if (_recordingStarter != null && _recordingStarter!.isActive) {
      _recordingWidgetKey.currentState?.stopRecording(cancel: true);
      _recordingStarter?.cancel();
      _recordingStarter = null;
      micTooltipKey.currentState?.ensureTooltipVisible();
      Future.delayed(const Duration(seconds: 2), () {
        // micTooltipKey.currentState?.dispose();
        Tooltip.dismissAllToolTips();
      });
    } else {
      RenderBox trashIconBox =
          trashIconKey.currentContext?.findRenderObject() as RenderBox;
      final boxHitTestResult = BoxHitTestResult();
      bool isOverTrashIcon = trashIconBox.hitTest(boxHitTestResult,
          position: trashIconBox.globalToLocal(event.position));
      setState(() {
        _isRecording = false;
      });
      _recordingWidgetKey.currentState?.stopRecording(cancel: isOverTrashIcon);
    }
  }

  Widget _buildInputWidget(BoxConstraints constraints) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              color: colorTheme.inputAreaBackground,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildInputAreaIcon(
                    icon: Icons.add_circle_outline_rounded,
                    onTap: () {
                      widget.focusNode.unfocus();
                      _messageAttachmentOptions.toggleAttachmentOptionsOverlay(
                          constraints: constraints,
                          context: context,
                          attachmentOptions: widget.attachmentOptions);
                    },
                  ),
                  _buildInputAreaIcon(
                    icon: Icons.camera_alt_outlined,
                    onTap: () =>
                        TencentCloudChatMessageCamera.showCameraOptions(
                      context: context,
                      onSendImage: widget.sendImageMessage,
                      onSendVideo: widget.sendVideoMessage,
                    ),
                  ),
                  SizedBox(
                    width: getSquareSize(8),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: getWidth(10), horizontal: getHeight(16)),
                    decoration: BoxDecoration(
                      color: colorTheme.backgroundColor,
                      border:
                          Border.all(color: colorTheme.inputFieldBorderColor),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Input field for the message.
                        Expanded(
                          child: TextField(
                            onTap: () {
                              widget.messageController.scrollToBottom();
                              widget.focusNode.requestFocus();
                              setState(() {
                                _showStickerPanel = false;
                                _showKeyboard = true;
                              });
                            },
                            focusNode: widget.focusNode,
                            controller: widget.textEditingController,
                            minLines: 1,
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: getFontSize(14),
                            ),
                            decoration: InputDecoration(
                              hintText: tL10n.sendAMessage,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     if (!_showStickerPanel) {
                        //       widget.focusNode.unfocus();
                        //     }
                        //     setState(() {
                        //       _showStickerPanel = !_showStickerPanel;
                        //     });
                        //   },
                        //   child: Icon(
                        //     Icons.emoji_emotions,
                        //     size: textStyle.inputAreaIcon,
                        //     color: colorTheme.inputAreaIconColor,
                        //   ),
                        // ),
                      ],
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: getSquareSize(_showSendButton ? 6 : 4),
                      left: getSquareSize(_showSendButton ? 6 : 8),
                      right: getSquareSize(_showSendButton ? 8 : 2),
                    ),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: _animationController.value * pi,
                          child: _showSendButton
                              ? InkWell(
                                  onTap: () {
                                    widget.sendTextMessage(
                                      text: widget.textEditingController.text,
                                      mentionedUsers: _mentionedUsers
                                          .map(
                                            (e) => e.userID,
                                          )
                                          .toList(),
                                    );
                                    _inputText = "";
                                    _mentionedUsers.clear();
                                    widget.textEditingController.clear();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: colorTheme.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    padding: EdgeInsets.all(getSquareSize(4)),
                                    child: Icon(
                                      Icons.arrow_downward,
                                      size: textStyle.inputAreaIcon,
                                      color: colorTheme.backgroundColor,
                                    ),
                                  ),
                                )
                              : Tooltip(
                                  key: micTooltipKey,
                                  preferBelow: false,
                                  verticalOffset: getSquareSize(36),
                                  triggerMode: TooltipTriggerMode.manual,
                                  showDuration: const Duration(seconds: 1),
                                  message: tL10n.holdToRecordReleaseToSend,
                                  child: Listener(
                                    onPointerDown: _onStartRecording,
                                    onPointerUp: _onStopRecording,
                                    child: Container(
                                      padding: EdgeInsets.all(getSquareSize(6)),
                                      child: Icon(
                                        Icons.mic,
                                        size: textStyle.inputAreaIcon,
                                        color: colorTheme.inputAreaIconColor,
                                      ),
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  double _getBottomContainerHeight() {
    if (_showStickerPanel) {
      return getHeight(280);
    }
    if (_showKeyboard) {
      final currentKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      double originHeight =
          TencentCloudChat.dataInstance.basic.keyboardHeight ?? getHeight(280);
      if (currentKeyboardHeight != 0) {
        if (currentKeyboardHeight >= originHeight) {
          originHeight = currentKeyboardHeight;
        }
        TencentCloudChatUtils.debounce("setCurrentKeyboardHeight", () {
          TencentCloudChat.dataInstance.basic.keyboardHeight =
              currentKeyboardHeight;
        });
      }
      final height = originHeight != 0 ? originHeight : currentKeyboardHeight;
      final actualHeight =
          height + (_bottomPadding! > 8 ? getSquareSize(16) : getSquareSize(0));

      return actualHeight;
    }
    return _bottomPadding ?? 0.0;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    _bottomPadding ??= MediaQuery.of(context).padding.bottom;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) {
          return Container(
            color: colorTheme.inputAreaBackground,
            padding: EdgeInsets.only(
              bottom:
                  _bottomPadding! > 8 ? getSquareSize(0) : getSquareSize(16),
              left: getSquareSize(16),
              right: getSquareSize(16),
              top: widget.repliedMessage != null
                  ? getSquareSize(8)
                  : getSquareSize(16),
            ),
            child: Column(
              children: [
                if (widget.repliedMessage != null)
                  TencentCloudChatMessageInputReplyContainer(
                    repliedMessage: widget.repliedMessage,
                  ),
                IndexedStack(
                  index: _isRecording ? 1 : 0,
                  children: [
                    AnimatedSwitcher(
                      switchInCurve: Curves.ease,
                      switchOutCurve: Curves.ease,
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: const Offset(0, 0),
                          ).animate(animation),
                          child: child,
                        );
                      },
                      child: widget.inSelectMode
                          ? const TencentCloudChatMessageInputSelectModeContainer()
                          : _buildInputWidget(constraints),
                    ),
                    TencentCloudChatMessageInputRecording(
                      onRecordFinish: (recordInfo) => widget.sendVoiceMessage(
                          voicePath: recordInfo.path,
                          duration: recordInfo.duration),
                      isRecording: _isRecording,
                      key: _recordingWidgetKey,
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  height: _getBottomContainerHeight(),
                  child: _showStickerPanel
                      ? Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.construction),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                "表情面板 - 开发中",
                                style: TextStyle(
                                    fontSize: textStyle.standardLargeText),
                              )
                            ],
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
