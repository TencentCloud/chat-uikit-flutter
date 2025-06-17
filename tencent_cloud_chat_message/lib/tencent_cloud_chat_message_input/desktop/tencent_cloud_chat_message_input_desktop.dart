import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:tencent_cloud_chat_common/utils/sdk_const.dart';
import 'package:universal_html/html.dart' as html;

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/common/for_desktop/file_tools.dart';
import 'package:tencent_cloud_chat_message/common/for_desktop/image_tools.dart';
import 'package:tencent_cloud_chat_message/common/text_compiler/tencent_cloud_chat_message_text_compiler.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/message_reply/tencent_cloud_chat_message_input_reply_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/select_mode/tencent_cloud_chat_message_input_select_mode_container.dart';

class TencentCloudChatMessageInputDesktop extends StatefulWidget {
  final MessageInputBuilderData inputData;
  final MessageInputBuilderMethods inputMethods;
  final String? statusText;

  const TencentCloudChatMessageInputDesktop({
    super.key,
    required this.inputData,
    required this.inputMethods,
    this.statusText,
  });

  @override
  State<TencentCloudChatMessageInputDesktop> createState() => _TencentCloudChatMessageInputDesktopState();
}

class _TencentCloudChatMessageInputDesktopState extends TencentCloudChatState<TencentCloudChatMessageInputDesktop> {
  final List<({String userID, String label})> _mentionedUsers = [];
  late ScrollController _scrollController;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textEditingFocusNode = FocusNode();
  String _inputText = "";
  bool _isComposingText = false;
  bool _isEditingAtSearchWords = false;
  int _atTagIndex = -1;
  double _inputWidth = 900;
  int _maxLines = 6;
  String listenerUUID = "";

  @override
  void initState() {
    super.initState();
    _cancelEditingMemberMentionStatus();
    _textEditingFocusNode.onKey = _handleKeyEvent;
    _textEditingFocusNode.requestFocus();
    _scrollController = ScrollController();
    _textEditingController.addListener(() {
      _isComposingText = _textEditingController.value.composing.start != -1;
    });
    if (listenerUUID.isNotEmpty) {
      removeUIKitListener();
    }
    addUIKitListener();
    _initPasteOnWeb();
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
          _textEditingFocusNode.requestFocus();
        }
        widget.inputMethods.closeSticker();
      }
    }
  }

  String addUIKitListener() {
    var id = TencentCloudChat.instance.chatSDKInstance.messageSDK.addUIKitListener(listener: uikitListener);
    listenerUUID = id;
    return id;
  }

  void removeUIKitListener() {
    if (listenerUUID.isNotEmpty) {
      return TencentCloudChat.instance.chatSDKInstance.messageSDK.removeUIKitListener(listenerID: listenerUUID);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _textEditingFocusNode.dispose();
    removeUIKitListener();
  }

  @override
  void didUpdateWidget(TencentCloudChatMessageInputDesktop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.inputData.specifiedMessageText != oldWidget.inputData.specifiedMessageText) {
      _textEditingController.text = widget.inputData.specifiedMessageText ?? "";
      _mentionedUsers.clear();
      _mentionedUsers.addAll((widget.inputData.membersNeedToMention ?? []).map(((e) {
        final targetMemberLabel = _getShowName(e);
        return (label: targetMemberLabel, userID: e.userID);
      })));
      _textEditingFocusNode.requestFocus();
    } else if (!TencentCloudChatUtils.deepEqual(widget.inputData.membersNeedToMention, oldWidget.inputData.membersNeedToMention) && widget.inputData.membersNeedToMention != null) {
      _addMentionedUsers(groupMembersInfo: widget.inputData.membersNeedToMention);
    }

    if (widget.inputData.enableReplyWithMention &&
        oldWidget.inputData.repliedMessage != widget.inputData.repliedMessage &&
        widget.inputData.repliedMessage != null &&
        TencentCloudChatUtils.checkString(widget.inputData.repliedMessage!.sender) != null) {
      if (!(widget.inputData.repliedMessage?.isSelf ?? true) && TencentCloudChatUtils.checkString(widget.inputData.groupID) != null) {
        _addMentionedUsers(message: widget.inputData.repliedMessage!);
      } else {
        _textEditingFocusNode.requestFocus();
      }
    }
  }

  _initPasteOnWeb() {
    try {
      if (TencentCloudChatPlatformAdapter().isWeb) {
        html.window.addEventListener('paste', (event) {
          _handlePasteOnWeb(event as html.ClipboardEvent);
        });
      }
    } catch (e) {
      // ignore: avoid_print
      debugPrint(e.toString());
    }
  }

  Future<void> _handlePasteOnWeb(html.ClipboardEvent event) async {
    try {
      if (event.clipboardData!.files!.isNotEmpty) {
        html.File imageFile = event.clipboardData!.files![0];
        _sendFileUseJs(imageFile);
      }
    } catch (e) {
      // ignore: avoid_print
      debugPrint("Paste image failed: ${e.toString()}");
    }
  }

  _sendFileUseJs(html.File file) {
    final mimeType = file.type.split('/');
    final type = mimeType[0];
    final blobUrl = html.Url.createObjectUrl(file);
    if (type == 'image') {
      TencentCloudChatDesktopImageTools.sendImageOnDesktop(
        context: context,
        imagePath: blobUrl,
        imageSize: const Size(500, 500),
        imageName: file.name,
        currentConversationShowName: widget.inputData.currentConversationShowName,
        sendImageMessage: widget.inputMethods.sendImageMessage,
      );
    }
  }

  Offset _getAtPosition(String text, int atPlace) {
    final textBeforeAt = text.substring(0, atPlace + 1);
    final textPainter = TextPainter(
      text: TextSpan(text: textBeforeAt, style: const TextStyle(fontSize: 14)),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: _inputWidth);
    final TextPosition lastLineOffset = textPainter.getPositionForOffset(Offset(textPainter.width, textPainter.height));
    final Offset caretPosition = textPainter.getOffsetForCaret(lastLineOffset, Rect.zero);
    final dx = min(_inputWidth - 180, caretPosition.dx + 16);
    final dy = max(24, 21 * _maxLines - caretPosition.dy).toDouble();

    return Offset(dx, dy);
  }

  void _onTextChanged(String newText) async {
    widget.inputMethods.closeSticker();
    final newText = _textEditingController.text;

    /// Dealing with mentioning member in group
    if (TencentCloudChatUtils.checkString(widget.inputData.groupID) != null) {
      final ({String character, int index, bool isAddText}) compareResult = TencentCloudChatUtils.compareString(
        _inputText,
        newText,
      );

      /// Add word
      if (compareResult.isAddText) {
        if (compareResult.character == "@") {
          final atPosition = _getAtPosition(newText, compareResult.index);
          widget.inputMethods.setDesktopMentionBoxPositionX(atPosition.dx);
          widget.inputMethods.setDesktopMentionBoxPositionY(atPosition.dy);
          _isEditingAtSearchWords = true;
          _atTagIndex = compareResult.index;
        }
      } else if (!compareResult.isAddText) {
        /// Delete word
        final atIndex = _inputText.lastIndexOf('@', max(0, compareResult.index - 1));
        final removedLabelList = [];
        if (atIndex != -1 && compareResult.character != '@') {
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

      /// Deal with editing mention member keyword
      if (_isEditingAtSearchWords && _atTagIndex > -1 && (compareResult.isAddText ? compareResult.index >= _atTagIndex : compareResult.index > _atTagIndex)) {
        String keyword = newText.substring(_atTagIndex + 1, compareResult.index + (compareResult.isAddText ? 1 : 0));

        List<V2TimGroupMemberFullInfo> showAtMemberList = widget.inputData.groupMemberList
            .where((element) {
              final showName = (_getShowName(element)).toLowerCase();
              return showName.contains(keyword.toLowerCase()) && TencentCloudChatUtils.checkString(showName) != null;
            })
            .whereType<V2TimGroupMemberFullInfo>()
            .toList();
        if (showAtMemberList.isEmpty && widget.inputData.groupMemberList.isEmpty) {
          TencentCloudChat.instance.callbacks.onUserNotificationEvent(
            TencentCloudChatComponentsEnum.message,
            TencentCloudChatCodeInfo.retrievingGroupMembers,
          );
        }
        showAtMemberList.sort((V2TimGroupMemberFullInfo userA, V2TimGroupMemberFullInfo userB) {
          final isUserAIsGroupAdmin = userA.role == 300;
          final isUserAIsGroupOwner = userA.role == 400;

          final isUserBIsGroupAdmin = userB.role == 300;
          final isUserBIsGroupOwner = userB.role == 400;

          final String userAName = _getShowName(userA);
          final String userBName = _getShowName(userB);

          if (isUserAIsGroupOwner != isUserBIsGroupOwner) {
            return isUserAIsGroupOwner ? -1 : 1;
          }

          if (isUserAIsGroupAdmin != isUserBIsGroupAdmin) {
            return isUserAIsGroupAdmin ? -1 : 1;
          }

          return userAName.compareTo(userBName);
        });

        if (widget.inputData.isGroupAdmin && showAtMemberList.isNotEmpty && keyword.isEmpty) {
          showAtMemberList = [
            V2TimGroupMemberFullInfo(userID: SDKConst.sdkAtAllUserID, nickName: tL10n.all),
            ...showAtMemberList,
          ];
        }

        widget.inputMethods.setCurrentFilteredMembersListForMention(showAtMemberList);
        widget.inputMethods.setActiveMentionIndex(0);
      } else {
        _cancelEditingMemberMentionStatus();
      }
    }

    /// End
    _inputText = _textEditingController.text;
  }

  final GlobalKey desktopInputKey = GlobalKey();

  List<Widget> _generateBarIcons(TencentCloudChatThemeColors theme) {
    return widget.inputData.attachmentOptions.map((e) {
      final GlobalKey toolbarKey = GlobalKey();
      return Container(
        key: toolbarKey,
        margin: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTapUp: (TapUpDetails detail) {
            RenderBox? renderBox = desktopInputKey.currentContext?.findRenderObject() as RenderBox;
            RenderBox? toolBarRenderBox = toolbarKey.currentContext?.findRenderObject() as RenderBox;
            var offset = detail.localPosition;

            e.onTap(
              offset: Offset(offset.dx, renderBox.size.height + toolBarRenderBox.size.height + 20), // 20 为margin
            );
          },
          child: Tooltip(
            preferBelow: false,
            message: e.label,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
              padding: const EdgeInsets.all(4),
              child: () {
                if (e.iconAsset != null) {
                  final type = e.iconAsset!.path.split(".")[e.iconAsset!.path.split(".").length - 1];
                  if (type == "svg") {
                    return SvgPicture.asset(
                      e.iconAsset!.path,
                      package: e.iconAsset!.package,
                      width: 16,
                      height: 16,
                      colorFilter: ui.ColorFilter.mode(
                        theme.secondaryTextColor,
                        ui.BlendMode.srcIn,
                      ),
                    );
                  }
                  return Image.asset(
                    e.iconAsset!.path,
                    package: e.iconAsset!.package,
                    width: 16,
                    height: 16,
                  );
                }
                if (e.icon != null) {
                  return Icon(
                    e.icon,
                    color: theme.inputAreaIconColor.withOpacity(0.6),
                    size: 20,
                  );
                }
              }(),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _generateControlBar(TencentCloudChatThemeColors theme) {
    return _generateBarIcons(theme);
  }

  String _getShowName(V2TimGroupMemberFullInfo? item) {
    return TencentCloudChatUtils.checkStringWithoutSpace(item?.nameCard) ?? TencentCloudChatUtils.checkStringWithoutSpace(item?.nickName) ?? TencentCloudChatUtils.checkStringWithoutSpace(item?.userID) ?? "";
  }

  void _cancelEditingMemberMentionStatus() {
    _isEditingAtSearchWords = false;
    _atTagIndex = -1;
    widget.inputMethods.setCurrentFilteredMembersListForMention([]);
    widget.inputMethods.setActiveMentionIndex(-1);
  }

  void _addMentionedUsers({V2TimMessage? message, List<V2TimGroupMemberFullInfo>? groupMembersInfo}) {
    final currentText = _textEditingController.text;
    final isValid = (groupMembersInfo ?? []).isNotEmpty || TencentCloudChatUtils.checkString(message?.sender) != null;
    if (isValid) {
      if (_isEditingAtSearchWords && groupMembersInfo?.length == 1) {
        final showName = _getShowName(groupMembersInfo!.first);
        _replaceAtTag(showName);
        _mentionedUsers.add((label: showName, userID: groupMembersInfo.first.userID));
        _cancelEditingMemberMentionStatus();
        _textEditingFocusNode.requestFocus();
      } else {
        String addText = "";
        groupMembersInfo?.forEach((element) {
          final targetMemberLabel = _getShowName(element);
          _mentionedUsers.add((label: targetMemberLabel, userID: element.userID));
          addText += "@$targetMemberLabel ";
        });
        if (message?.sender != null) {
          final String targetMemberLabel = TencentCloudChatUtils.checkString(message?.nameCard) ?? TencentCloudChatUtils.checkString(message?.nickName) ?? message!.sender!;
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
  }

  void _replaceAtTag(String selectedMember) {
    int cursorPosition = _textEditingController.selection.baseOffset;
    int atIndex = _textEditingController.text.lastIndexOf('@', cursorPosition - 1);
    if (atIndex >= 0) {
      String beforeAt = _textEditingController.text.substring(0, atIndex);
      String afterAt = _textEditingController.text.substring(cursorPosition);
      _textEditingController.text = '$beforeAt@$selectedMember $afterAt';
      _textEditingController.selection = TextSelection.collapsed(offset: atIndex + selectedMember.length + 2);
      _inputText = '$beforeAt@$selectedMember $afterAt';
    }
  }

  void _handleMentionUser(V2TimGroupMemberFullInfo memberFullInfo) {
    final String showName = _getShowName(memberFullInfo);
    _mentionedUsers.add((label: showName, userID: memberFullInfo.userID));
    _replaceAtTag(showName);
    _cancelEditingMemberMentionStatus();
    _textEditingFocusNode.requestFocus();
  }

  _handlePasteResource() async {
    final imageBytes = await Pasteboard.image;
    if (imageBytes != null && imageBytes.isNotEmpty) {
      String directory;
      if (TencentCloudChatPlatformAdapter().isWindows) {
        final String documentsDirectoryPath = "${Platform.environment['USERPROFILE']}";
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String pkgName = packageInfo.packageName;
        directory = Pertypath().join(documentsDirectoryPath, "Documents", ".TencentCloudChat", pkgName, "screenshots");
      } else {
        final dic = await getApplicationSupportDirectory();
        directory = dic.path;
      }
      var uuid = DateTime.now().microsecondsSinceEpoch;
      final fileName = 'paste_image_$uuid.png';
      final scDirectory = Directory(directory);
      final filePath = '${scDirectory.path}${TencentCloudChatPlatformAdapter().isWindows ? "\\" : "/"}$fileName';
      final file = File(filePath);
      if (!await scDirectory.exists()) {
        await scDirectory.create(recursive: true);
      }
      await file.writeAsBytes(imageBytes.toList());

      TencentCloudChatDesktopImageTools.sendImageOnDesktop(
        context: context,
        imagePath: file.path,
        currentConversationShowName: widget.inputData.currentConversationShowName,
        sendImageMessage: widget.inputMethods.sendImageMessage,
      );
    } else {
      final List<String> fileList = await Pasteboard.files();

      if (fileList.isNotEmpty) {
        TencentCloudChatDesktopFileTools.sendFileWithConfirmation(
          filesPath: fileList,
          currentConversationShowName: widget.inputData.currentConversationShowName,
          sendFileMessage: widget.inputMethods.sendFileMessage,
          context: context,
        );
      }
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    final isPressEnter = (event.physicalKey == PhysicalKeyboardKey.enter) || (event.physicalKey == PhysicalKeyboardKey.numpadEnter);

    final activeIndex = widget.inputData.activeMentionIndex;
    final showMemberList = widget.inputData.currentFilteredMembersListForMention;

    if (TencentCloudChatPlatformAdapter().isDesktop && ((event.isKeyPressed(LogicalKeyboardKey.controlLeft) && event.logicalKey == LogicalKeyboardKey.keyV) || (event.isMetaPressed && event.logicalKey == LogicalKeyboardKey.keyV))) {
      _handlePasteResource();
      return KeyEventResult.ignored;
    } else if (event.runtimeType == RawKeyDownEvent) {
      if (event.physicalKey == PhysicalKeyboardKey.backspace) {
        if (_textEditingController.text.isEmpty && _inputText.isEmpty) {
          widget.inputMethods.clearRepliedMessage();
          return KeyEventResult.handled;
        }
      } else if ((event.isShiftPressed || event.isAltPressed || event.isControlPressed || event.isMetaPressed) && isPressEnter) {
        final offset = _textEditingController.selection.baseOffset;
        _textEditingController.text = '${_inputText.substring(0, offset)}\n${_inputText.substring(offset)}';
        _textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: offset + 1));
        _inputText = _textEditingController.text;

        return KeyEventResult.handled;
      } else if (isPressEnter) {
        if (!_isComposingText) {
          if (!_isEditingAtSearchWords || showMemberList.isEmpty) {
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
            _cancelEditingMemberMentionStatus();
          } else {
            final V2TimGroupMemberFullInfo? memberInfo = showMemberList[activeIndex];
            if (memberInfo != null) {
              _handleMentionUser(memberInfo);
            }
          }
          return KeyEventResult.handled;
        }
      }

      if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) && _isEditingAtSearchWords && showMemberList.isNotEmpty) {
        final newIndex = max(activeIndex - 1, 0);
        widget.inputMethods.setActiveMentionIndex(newIndex);
        widget.inputMethods.desktopInputMemberSelectionPanelScroll.scrollToIndex(newIndex, preferPosition: AutoScrollPosition.middle);
        return KeyEventResult.handled;
      }

      if (event.isKeyPressed(LogicalKeyboardKey.arrowDown) && _isEditingAtSearchWords && showMemberList.isNotEmpty) {
        final newIndex = min(activeIndex + 1, showMemberList.length - 1);
        widget.inputMethods.setActiveMentionIndex(newIndex);
        widget.inputMethods.desktopInputMemberSelectionPanelScroll.scrollToIndex(newIndex, preferPosition: AutoScrollPosition.middle);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final TencentCloudChatMessageConfig config = TencentCloudChatMessageDataProviderInherited.of(context).config;
    final maxLines = config.desktopMessageInputLines(
      userID: TencentCloudChatMessageDataProviderInherited.of(context).userID,
      groupID: TencentCloudChatMessageDataProviderInherited.of(context).groupID,
      topicID: TencentCloudChatMessageDataProviderInherited.of(context).topicID,
    );
    _maxLines = maxLines;

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      _inputWidth = constraints.maxWidth;
      return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
          color: colorTheme.backgroundColor,
          child: AnimatedSwitcher(
            switchInCurve: Curves.ease,
            switchOutCurve: Curves.ease,
            duration: const Duration(milliseconds: 300),
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
                : Column(
                    children: [
                      if (widget.inputData.repliedMessage != null)
                        TencentCloudChatMessageInputReplyContainer(
                          repliedMessage: widget.inputData.repliedMessage,
                        ),
                      SizedBox(height: 1, child: Container(color: colorTheme.dividerColor)),
                      if (TencentCloudChatUtils.checkString(widget.statusText) == null)
                        Container(
                          color: colorTheme.backgroundColor,
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _generateControlBar(colorTheme),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                        constraints: const BoxConstraints(minHeight: 50),
                        child: Row(
                          children: [
                            if (TencentCloudChatUtils.checkString(widget.statusText) != null)
                              Expanded(
                                  child: Container(
                                height: 35,
                                color: colorTheme.backgroundColor,
                                alignment: Alignment.center,
                                child: Text(
                                  widget.statusText!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: colorTheme.secondaryTextColor,
                                  ),
                                ),
                              )),
                            if (TencentCloudChatUtils.checkString(widget.statusText) == null)
                              Expanded(
                                child: ExtendedTextField(
                                  key: desktopInputKey,
                                  scrollController: _scrollController,
                                  autofocus: true,
                                  onChanged: _onTextChanged,
                                  maxLines: maxLines,
                                  minLines: maxLines,
                                  focusNode: _textEditingFocusNode,
                                  keyboardType: TextInputType.multiline,
                                  onEditingComplete: () {
                                    //   // widget.onSubmitted();
                                  },
                                  textAlignVertical: TextAlignVertical.top,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    hoverColor: Colors.transparent,
                                    border: InputBorder.none,
                                    hintStyle: const TextStyle(
                                      color: Color(0xffAEA4A3),
                                    ),
                                    fillColor: colorTheme.backgroundColor,
                                    filled: true,
                                    isDense: true,
                                  ),
                                  controller: _textEditingController,
                                  specialTextSpanBuilder: TencentCloudChatSpecialTextSpanBuilder(
                                    onTapUrl: (_) {},
                                    stickerPluginInstance: widget.inputData.stickerPluginInstance,
                                  ),
                                  onTap: () {
                                    widget.inputMethods.closeSticker();
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
