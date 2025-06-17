import 'dart:async';
import 'dart:math';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_permission_handlers.dart';
import 'package:tencent_cloud_chat_message/common/text_compiler/tencent_cloud_chat_message_text_compiler.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/message_reply/tencent_cloud_chat_message_input_reply_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_attachment_options.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_camera.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_input_recording.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/select_mode/tencent_cloud_chat_message_input_select_mode_container.dart';

class TencentCloudChatMessageInputMobile extends StatefulWidget {
  final MessageInputBuilderData inputData;
  final MessageInputBuilderMethods inputMethods;

  const TencentCloudChatMessageInputMobile({
    super.key,
    required this.inputData,
    required this.inputMethods,
  });

  @override
  State<TencentCloudChatMessageInputMobile> createState() => _TencentCloudChatMessageInputMobileState();
}

class _TencentCloudChatMessageInputMobileState extends TencentCloudChatState<TencentCloudChatMessageInputMobile>
    with TickerProviderStateMixin{
  final GlobalKey<TooltipState> micTooltipKey = GlobalKey<TooltipState>();
  final TencentCloudChatMessageAttachmentOptions _messageAttachmentOptions = TencentCloudChatMessageAttachmentOptions();
  final GlobalKey<TencentCloudChatMessageInputRecordingState> _recordingWidgetKey = GlobalKey();
  final List<({String userID, String label})> _mentionedUsers = [];

  late AnimationController? _animationController;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textEditingFocusNode = FocusNode();

  bool isStarted = false;

  Widget stickerWidget = Container();

  bool _showStickerPanel = false;
  bool _showKeyboard = false;
  bool _isRecording = false;
  bool _showSendButton = false;
  Timer? _recordingStarter;
  double? _bottomPadding;
  String _inputText = "";
  String listenerUUID = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (listenerUUID.isNotEmpty) {
      removeUIKitListener();
    }

    listenerUUID = addUIKitListener();
    _textEditingController.text = widget.inputData.specifiedMessageText ?? "";
    _inputText = widget.inputData.specifiedMessageText ?? "";
    // must add input event after _textEditingController.text
    _addTextInputEvent();
  }

  void uikitListener(Map<String, dynamic> data) {
    if (data.containsKey("eventType")) {
      if (data["eventType"] == "stickClick") {
        if (data["type"] == 0) {
          var space = "";
          if (_textEditingController.text == "") {
            space = " ";
          }
          _textEditingController.text = "$space${_textEditingController.text}${data["name"]}";
        } else if (data["type"] == 1) {}
      }
    }
  }

  String addUIKitListener() {
    return TencentCloudChat.instance.chatSDKInstance.messageSDK.addUIKitListener(listener: uikitListener);
  }

  void removeUIKitListener() {
    if (listenerUUID.isNotEmpty) {
      return TencentCloudChat.instance.chatSDKInstance.messageSDK.removeUIKitListener(listenerID: listenerUUID);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageAttachmentOptions.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _removeTextInputEvent();
    removeUIKitListener();
  }

  @override
  void didUpdateWidget(covariant TencentCloudChatMessageInputMobile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.inputData.specifiedMessageText != oldWidget.inputData.specifiedMessageText) {
      _textEditingController.text = widget.inputData.specifiedMessageText ?? "";
      _mentionedUsers.clear();
      _mentionedUsers.addAll((widget.inputData.membersNeedToMention ?? []).map(((e) {
        final targetMemberLabel = _getShowName(e);
        return (label: targetMemberLabel, userID: e.userID);
      })));
      _textEditingFocusNode.requestFocus();
    } else if (!TencentCloudChatUtils.deepEqual(
            widget.inputData.membersNeedToMention, oldWidget.inputData.membersNeedToMention) &&
        widget.inputData.membersNeedToMention != null) {
      _addMentionedUsers(groupMembersInfo: widget.inputData.membersNeedToMention);
    }

    if (widget.inputData.enableReplyWithMention &&
        oldWidget.inputData.repliedMessage != widget.inputData.repliedMessage &&
        widget.inputData.repliedMessage != null &&
        TencentCloudChatUtils.checkString(widget.inputData.repliedMessage!.sender) != null) {
      if (!(widget.inputData.repliedMessage?.isSelf ?? true) &&
          TencentCloudChatUtils.checkString(widget.inputData.groupID) != null) {
        _addMentionedUsers(message: widget.inputData.repliedMessage!);
      } else {
        _textEditingFocusNode.requestFocus();
      }
    }
  }

  void _addTextInputEvent() {
    try {
      _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
      _messageAttachmentOptions.init(vsync: this, context: context);
      _textEditingController.addListener(_onTextChanged);
      _textEditingFocusNode.addListener(() {
        if (_textEditingFocusNode.hasFocus) {
          safeSetState(() {
            _showKeyboard = true;
            _showStickerPanel = false;
          });
        } else {
          safeSetState(() {
            _showKeyboard = false;
          });
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _removeTextInputEvent() {
    try {
      _animationController?.dispose();
      _messageAttachmentOptions.dispose();
      _animationController = null;
      _textEditingController.removeListener(_onTextChanged);
      _textEditingController.clear();
      _textEditingController.dispose();
      _textEditingFocusNode.dispose();
      TencentCloudChat.instance.chatSDKInstance.messageSDK.removeUIKitListener(listenerID: listenerUUID);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _buildInputAreaIcon({
    required IconData icon,
    required GestureTapDownCallback onTapDown,
  }) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTapDown: onTapDown,
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

  void _onStartRecording(PointerDownEvent event) async {
    isStarted = true;
    if (TencentCloudChatPlatformAdapter().isMobile &&
        await TencentCloudChatPermissionHandler.checkPermission("microphone", context) &&
        isStarted) {
      _recordingStarter?.cancel();
      _recordingStarter = Timer(const Duration(milliseconds: 100), () {
        safeSetState(() {
          _isRecording = true;
        });
        _recordingWidgetKey.currentState?.startRecording();
      });
    }
  }

  void _onStopRecording(PointerUpEvent event) {
    isStarted = false;
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
      RenderBox trashIconBox = trashIconKey.currentContext?.findRenderObject() as RenderBox;
      final boxHitTestResult = BoxHitTestResult();
      bool isOverTrashIcon =
          trashIconBox.hitTest(boxHitTestResult, position: trashIconBox.globalToLocal(event.position));
      safeSetState(() {
        _isRecording = false;
      });
      _recordingWidgetKey.currentState?.stopRecording(cancel: isOverTrashIcon);
    }
  }

  String _getShowName(V2TimGroupMemberFullInfo? item) {
    return TencentCloudChatUtils.checkStringWithoutSpace(item?.nameCard) ??
        TencentCloudChatUtils.checkStringWithoutSpace(item?.nickName) ??
        TencentCloudChatUtils.checkStringWithoutSpace(item?.userID) ??
        "";
  }

  void _addMentionedUsers({V2TimMessage? message, List<V2TimGroupMemberFullInfo>? groupMembersInfo}) {
    final currentText = _textEditingController.text;
    final isValid = (groupMembersInfo ?? []).isNotEmpty || TencentCloudChatUtils.checkString(message?.sender) != null;
    if (isValid) {
      String addText = "";
      groupMembersInfo?.forEach((element) {
        final targetMemberLabel = _getShowName(element);
        _mentionedUsers.add((label: targetMemberLabel, userID: element.userID));
        addText += "@$targetMemberLabel ";
      });
      if (message?.sender != null) {
        final String targetMemberLabel = TencentCloudChatUtils.checkString(message?.nameCard) ??
            TencentCloudChatUtils.checkString(message?.nickName) ??
            message!.sender!;
        _mentionedUsers.add((label: targetMemberLabel, userID: message!.sender!));
        addText += "@$targetMemberLabel ";
      }

      /// Insert mentionText after the "@" character
      ///
      final cursorPosition = max(0, _textEditingController.selection.start);
      final updatedText = currentText.substring(0, cursorPosition) + addText + currentText.substring(cursorPosition);
      _textEditingController.text = updatedText;
      _inputText = updatedText;
      _textEditingController.selection = TextSelection.collapsed(offset: cursorPosition + addText.length);
      _textEditingFocusNode.requestFocus();
    }
  }

  void _onTextChanged() async {
    final newText = _textEditingController.text;

    /// Send Button Animation
    if (newText.isNotEmpty != _showSendButton) {
      safeSetState(() {
        _showSendButton = !_showSendButton;
      });
      if (_showSendButton) {
        _animationController?.forward();
      } else {
        _animationController?.reverse();
      }
    }

    if (_inputText == newText) {
      if (_inputText.isEmpty) {
        /// Update draft
        _updateDraft(_inputText);
      }
      return;
    }

    /// Dealing with mentioning member in group
    if (TencentCloudChatUtils.checkString(widget.inputData.groupID) != null) {
      final compareResult = TencentCloudChatUtils.compareString(_inputText, newText);
      if (compareResult.isAddText && compareResult.character == "@") {
        /// Add "@" mentioned member tag
        final List<V2TimGroupMemberFullInfo> memberList = await widget.inputMethods.onChooseGroupMembers();

        final mentionTextList = memberList.map((targetMember) {
          final String targetMemberLabel = TencentCloudChatUtils.checkString(targetMember.nameCard) ??
              TencentCloudChatUtils.checkString(targetMember.nickName) ??
              targetMember.userID;

          _mentionedUsers.add((label: targetMemberLabel, userID: targetMember.userID));
          return "@$targetMemberLabel ";
        }).toList();
        final mentionText = mentionTextList.join();

        if (memberList.isNotEmpty) {
          /// Insert mentionText after the "@" character
          final updatedText = newText.replaceRange(compareResult.index, compareResult.index + 1, mentionText);
          _textEditingController.text = updatedText;
          _textEditingController.selection = TextSelection.collapsed(offset: compareResult.index + mentionText.length);
        }
      } else if (!compareResult.isAddText) {
        final atIndex = _inputText.lastIndexOf('@', max(0, compareResult.index - 1));
        final removedLabelList = [];
        if (atIndex != -1 && compareResult.character != '@' && compareResult.index > (atIndex + 1)) {
          removedLabelList.add(_inputText.substring(atIndex + 1, compareResult.index));

          int spaceIndex = compareResult.index;
          int count = 0;

          while (spaceIndex != -1 && count < 5) {
            spaceIndex = _inputText.indexOf(' ', spaceIndex + 1);
            if (spaceIndex != -1) {
              removedLabelList.add(_inputText.substring(atIndex + 1, spaceIndex));
              count++;
            } else {
              removedLabelList.add(_inputText.substring(atIndex + 1));
            }
          }

          final mentionedUserExist = _mentionedUsers.any((user) => removedLabelList.contains(user.label));

          if (mentionedUserExist) {
            final mentionedUser = _mentionedUsers.firstWhere((user) => removedLabelList.contains(user.label));
            final updatedText = newText.replaceRange(atIndex, atIndex + 1 + mentionedUser.label.length, '');
            _textEditingController.text = updatedText;
            _textEditingController.selection = TextSelection.collapsed(offset: atIndex);
            _mentionedUsers.removeWhere((user) => user.label == mentionedUser.label);
          }
        }
      }
    }

    /// End
    _inputText = _textEditingController.text;

    /// Update draft
    _updateDraft(_inputText);
  }

  void _updateDraft(String draftText) {
    if ((widget.inputData.userID == null || widget.inputData.userID!.isEmpty) &&
        (widget.inputData.groupID == null || widget.inputData.groupID!.isEmpty)) {
      return;
    }

    String conversationID = "";
    if (widget.inputData.userID != null && widget.inputData.userID!.isNotEmpty) {
      conversationID = "c2c_${widget.inputData.userID}";
    } else if (widget.inputData.groupID != null && widget.inputData.groupID!.isNotEmpty) {
      conversationID = "group_${widget.inputData.groupID}";
    }

    (widget.inputMethods.controller as TencentCloudChatMessageController).setDraft(conversationID, _inputText);
  }

  Widget _buildInputTextField() {
    return ExtendedTextField(
      onTap: () {
        (widget.inputMethods.controller as TencentCloudChatMessageController).scrollToBottom();
        _textEditingFocusNode.requestFocus();
        safeSetState(() {
          _showStickerPanel = false;
          _showKeyboard = true;
        });
      },
      focusNode: _textEditingFocusNode,
      controller: _textEditingController,
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
      specialTextSpanBuilder: TencentCloudChatSpecialTextSpanBuilder(
        onTapUrl: (_) {},
        stickerPluginInstance: widget.inputData.stickerPluginInstance,
      ),
    );
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
                    onTapDown: (details) {
                      _textEditingFocusNode.unfocus();
                      if (_showStickerPanel) {
                        safeSetState(() {
                          _showStickerPanel = false;
                        });
                      }

                      _messageAttachmentOptions.toggleAttachmentOptionsOverlay(
                        constraints: constraints,
                        context: context,
                        tapDownDetails: details,
                        attachmentOptions: widget.inputData.attachmentOptions,
                        messageAttachmentOptionsBuilder: widget.inputMethods.messageAttachmentOptionsBuilder
                            as Widget? Function(
                                {required MessageAttachmentOptionsBuilderData data,
                                Key? key,
                                required MessageAttachmentOptionsBuilderMethods methods})?,
                      );
                    },
                  ),
                  _buildInputAreaIcon(
                    icon: Icons.camera_alt_outlined,
                    onTapDown: (_) {
                      if (_showStickerPanel) {
                        safeSetState(() {
                          _showStickerPanel = false;
                        });
                      }

                      TencentCloudChatMessageCamera.showCameraOptions(
                        context: context,
                        onSendImage: widget.inputMethods.sendImageMessage,
                        onSendVideo: widget.inputMethods.sendVideoMessage,
                      );
                    } 
                  ),
                  SizedBox(
                    width: getSquareSize(8),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(vertical: getWidth(10), horizontal: getHeight(16)),
                    decoration: BoxDecoration(
                      color: colorTheme.backgroundColor,
                      border: Border.all(color: colorTheme.inputFieldBorderColor),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Input field for the message.
                        Expanded(
                          child: _buildInputTextField(),
                        ),
                        if (widget.inputData.hasStickerPlugin)
                          GestureDetector(
                            onTap: () {
                              if (!_showStickerPanel) {
                                _textEditingFocusNode.unfocus();
                              } else {
                                _textEditingFocusNode.requestFocus();
                              }
                              safeSetState(() {
                                _showStickerPanel = !_showStickerPanel;
                              });
                            },
                            child: Icon(
                              _showStickerPanel ? Icons.keyboard_alt_outlined : Icons.emoji_emotions,
                              size: textStyle.inputAreaIcon,
                              color: colorTheme.inputAreaIconColor,
                            ),
                          ),
                      ],
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: getSquareSize(_showSendButton ? 6 : 4),
                      left: getSquareSize(_showSendButton ? 6 : 8),
                      right: getSquareSize(_showSendButton ? 8 : 2),
                    ),
                    child: _animationController != null
                        ? AnimatedBuilder(
                            animation: _animationController!,
                            builder: (BuildContext context, Widget? child) {
                              return Transform.rotate(
                                angle: _animationController!.value * pi,
                                child: _showSendButton
                                    ? InkWell(
                                        onTap: () {
                                          widget.inputMethods.sendTextMessage(
                                            text: _textEditingController.text,
                                            mentionedUsers: _mentionedUsers
                                                .map(
                                                  (e) => e.userID,
                                                )
                                                .toList(),
                                          );
                                          _inputText = "";
                                          _mentionedUsers.clear();
                                          _textEditingController.clear();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: colorTheme.primaryColor, borderRadius: BorderRadius.circular(25)),
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
                          )
                        : Container(),
                  ),
                ],
              ),
            ));
  }

  double _getBottomContainerHeight() {
    if (_showStickerPanel) {
      return getHeight(280);
    }
    // if (_showKeyboard) {
    //   final currentKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    //   double originHeight = TencentCloudChat.instance.dataInstance.basic.keyboardHeight ?? getHeight(280);
    //   if (currentKeyboardHeight > -1) {
    //     if (currentKeyboardHeight >= originHeight) {
    //       originHeight = currentKeyboardHeight;
    //     }
    //     TencentCloudChatUtils.debounce("setCurrentKeyboardHeight", () {
    //       TencentCloudChat.instance.dataInstance.basic.keyboardHeight = currentKeyboardHeight;
    //     }, duration: const Duration(seconds: 1));
    //   }
    //   final height = originHeight != 0 ? originHeight : currentKeyboardHeight;
    //   final actualHeight = height + (_bottomPadding! > 8 ? getSquareSize(16) : getSquareSize(0));
    //
    //   return actualHeight;
    // }
    return _bottomPadding ?? 0.0;
  }

  Future<bool> getStickerPanelWidget() async {
    if (widget.inputData.hasStickerPlugin) {
      if (widget.inputData.stickerPluginInstance != null) {
        var wid = await widget.inputData.stickerPluginInstance!.getWidget(methodName: "stickerPanel");
        if (wid != null) {
          stickerWidget = wid;
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    _bottomPadding ??= MediaQuery.of(context).padding.bottom;
    var panelHeight = _getBottomContainerHeight();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) {
          return Container(
            color: colorTheme.inputAreaBackground,
            padding: EdgeInsets.only(
              bottom: _showStickerPanel ? 0 : (_bottomPadding! > 8 ? getSquareSize(0) : getSquareSize(16)),
              left: getSquareSize(16),
              right: getSquareSize(16),
              top: widget.inputData.repliedMessage != null ? getSquareSize(8) : getSquareSize(16),
            ),
            child: Column(
              children: [
                if (widget.inputData.repliedMessage != null)
                  TencentCloudChatMessageInputReplyContainer(
                    repliedMessage: widget.inputData.repliedMessage,
                  ),
                IndexedStack(
                  index: _isRecording ? 1 : 0,
                  children: [
                    AnimatedSwitcher(
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
                      child: widget.inputData.inSelectMode
                          ? const TencentCloudChatMessageInputSelectModeContainer()
                          : _buildInputWidget(constraints),
                    ),
                    TencentCloudChatMessageInputRecording(
                      onRecordFinish: (recordInfo) => widget.inputMethods
                          .sendVoiceMessage(voicePath: recordInfo.path, duration: recordInfo.duration),
                      isRecording: _isRecording,
                      key: _recordingWidgetKey,
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  height: panelHeight,
                  constraints: _showStickerPanel ? BoxConstraints(minHeight: panelHeight) : null,
                  child: _showStickerPanel
                      ? Center(
                          child: FutureBuilder<bool>(
                            future: getStickerPanelWidget(),
                            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                              return stickerWidget;
                            },
                          ),
                        )
                      : Container(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
