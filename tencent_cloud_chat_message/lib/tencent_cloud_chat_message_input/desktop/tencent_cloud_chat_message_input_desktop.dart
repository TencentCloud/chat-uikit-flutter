import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/common/for_desktop/file_tools.dart';
import 'package:tencent_cloud_chat_message/common/for_desktop/image_tools.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/message_reply/tencent_cloud_chat_message_input_reply_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/select_mode/tencent_cloud_chat_message_input_select_mode_container.dart';

class TencentCloudChatMessageInputDesktop extends StatefulWidget {
  final String? userID;
  final String? groupID;
  final Function({
    required String text,
    List<String>? mentionedUsers,
  }) sendTextMessage;
  final Function({required String imagePath}) sendImageMessage;
  final Function({required String videoPath}) sendVideoMessage;
  final Function({required String filePath}) sendFileMessage;
  final Function({required String voicePath, required int duration}) sendVoiceMessage;
  final bool inSelectMode;
  final List<V2TimMessage> selectedMessages;
  final V2TimMessage? repliedMessage;
  final TencentCloudChatMessageController messageController;
  final Future<List<V2TimGroupMemberFullInfo>> Function({
    int? maxSelectionAmount,
    String? title,
    String? onSelectLabel,
  }) onChooseGroupMembers;
  final List<TencentCloudChatMessageGeneralOptionItem> controlBarItems;
  final String? statusText;
  final VoidCallback clearRepliedMessage;
  final bool isGroupAdmin;
  final double desktopMentionBoxPositionX;
  final double desktopMentionBoxPositionY;
  final int activeMentionIndex;
  final List<V2TimGroupMemberFullInfo?> currentFilteredMembersListForMention;
  final ValueChanged<double> setDesktopMentionBoxPositionX;
  final ValueChanged<double> setDesktopMentionBoxPositionY;
  final ValueChanged<int> setActiveMentionIndex;
  final ValueChanged<List<V2TimGroupMemberFullInfo?>> setCurrentFilteredMembersListForMention;
  final AutoScrollController desktopInputMemberSelectionPanelScroll;
  final List<V2TimGroupMemberFullInfo> groupMemberList;
  final V2TimGroupMemberFullInfo? memberNeedToMention;
  final String currentConversationShowName;

  const TencentCloudChatMessageInputDesktop({
    super.key,
    required this.controlBarItems,
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
    this.statusText,
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
  });

  @override
  State<TencentCloudChatMessageInputDesktop> createState() => _TencentCloudChatMessageInputDesktopState();
}

class _TencentCloudChatMessageInputDesktopState extends TencentCloudChatState<TencentCloudChatMessageInputDesktop> {
  final List<({String userID, String label})> _mentionedUsers = [];
  late ScrollController _scrollController;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textEditingFocusNode = FocusNode();

  V2TimGroupMemberFullInfo? _memberNeedToMention;
  String _inputText = "";
  bool _isComposingText = false;
  bool _isEditingAtSearchWords = false;
  int _atTagIndex = -1;
  double _inputWidth = 900;
  int _maxLines = 6;

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
    _memberNeedToMention = widget.memberNeedToMention;
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _textEditingFocusNode.dispose();
  }

  @override
  void didUpdateWidget(TencentCloudChatMessageInputDesktop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.memberNeedToMention != _memberNeedToMention && widget.memberNeedToMention != null) {
      _handleMentionUser(widget.memberNeedToMention!);
    }
    _memberNeedToMention = widget.memberNeedToMention;
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
    final newText = _textEditingController.text;

    /// Dealing with mentioning member in group
    if (TencentCloudChatUtils.checkString(widget.groupID) != null) {
      final ({String character, int index, bool isAddText}) compareResult = TencentCloudChatUtils.compareString(
        _inputText,
        newText,
      );

      /// Add word
      if (compareResult.isAddText) {
        if (compareResult.character == "@") {
          final atPosition = _getAtPosition(newText, compareResult.index);
          widget.setDesktopMentionBoxPositionX(atPosition.dx);
          widget.setDesktopMentionBoxPositionY(atPosition.dy);
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

        List<V2TimGroupMemberFullInfo> showAtMemberList = widget.groupMemberList
            .where((element) {
              final showName = (_getShowName(element)).toLowerCase();
              return showName.contains(keyword.toLowerCase()) && TencentCloudChatUtils.checkString(showName) != null;
            })
            .whereType<V2TimGroupMemberFullInfo>()
            .toList();

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

        if (widget.isGroupAdmin && showAtMemberList.isNotEmpty && keyword.isEmpty) {
          showAtMemberList = [
            V2TimGroupMemberFullInfo(userID: "__kImSDK_MesssageAtALL__", nickName: tL10n.all),
            ...showAtMemberList,
          ];
        }

        widget.setCurrentFilteredMembersListForMention(showAtMemberList);
        widget.setActiveMentionIndex(0);
      } else {
        _cancelEditingMemberMentionStatus();
      }
    }

    /// End
    _inputText = _textEditingController.text;
  }

  List<Widget> _generateBarIcons(TencentCloudChatThemeColors theme) {
    return widget.controlBarItems.map((e) {
      final GlobalKey key = GlobalKey();
      return Container(
        margin: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: () {
            final alignBox = key.currentContext?.findRenderObject() as RenderBox?;
            var offset = alignBox?.localToGlobal(Offset.zero);
            final double? dx = (offset?.dx != null) ? offset!.dx : null;
            final double? dy = (offset?.dy != null && alignBox?.size.height != null) ? offset!.dy - (20) : null;
            e.onTap(offset: (dx != null && dy != null) ? Offset(dx, dy) : null);
          },
          child: Tooltip(
            preferBelow: false,
            message: e.label,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
              padding: const EdgeInsets.all(4),
              child: () {
                return Icon(
                  e.icon,
                  key: key,
                  color: theme.inputAreaIconColor.withOpacity(0.6),
                  size: 20,
                );
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
    widget.setCurrentFilteredMembersListForMention([]);
    widget.setActiveMentionIndex(-1);
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
        currentConversationShowName: widget.currentConversationShowName,
        sendImageMessage: widget.sendImageMessage,
      );
    } else {
      final List<String> fileList = await Pasteboard.files();

      if (fileList.isNotEmpty) {
        TencentCloudChatDesktopFileTools.sendFileWithConfirmation(
          filesPath: fileList,
          currentConversationShowName: widget.currentConversationShowName,
          sendFileMessage: widget.sendFileMessage,
          context: context,
        );
      }
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    final isPressEnter = (event.physicalKey == PhysicalKeyboardKey.enter) || (event.physicalKey == PhysicalKeyboardKey.numpadEnter);

    final activeIndex = widget.activeMentionIndex;
    final showMemberList = widget.currentFilteredMembersListForMention;

    if (TencentCloudChatPlatformAdapter().isDesktop && ((event.isKeyPressed(LogicalKeyboardKey.controlLeft) && event.logicalKey == LogicalKeyboardKey.keyV) || (event.isMetaPressed && event.logicalKey == LogicalKeyboardKey.keyV))) {
      _handlePasteResource();
      return KeyEventResult.ignored;
    } else if (event.runtimeType == RawKeyDownEvent) {
      if (event.physicalKey == PhysicalKeyboardKey.backspace) {
        if (_textEditingController.text.isEmpty && _inputText.isEmpty) {
          widget.clearRepliedMessage();
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
            widget.sendTextMessage(
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
        widget.setActiveMentionIndex(newIndex);
        widget.desktopInputMemberSelectionPanelScroll.scrollToIndex(newIndex, preferPosition: AutoScrollPosition.middle);
        return KeyEventResult.handled;
      }

      if (event.isKeyPressed(LogicalKeyboardKey.arrowDown) && _isEditingAtSearchWords && showMemberList.isNotEmpty) {
        final newIndex = min(activeIndex + 1, showMemberList.length - 1);
        widget.setActiveMentionIndex(newIndex);
        widget.desktopInputMemberSelectionPanelScroll.scrollToIndex(newIndex, preferPosition: AutoScrollPosition.middle);
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
            child: widget.inSelectMode
                ? const TencentCloudChatMessageInputSelectModeContainer()
                : Column(
                    children: [
                      if (widget.repliedMessage != null)
                        TencentCloudChatMessageInputReplyContainer(
                          repliedMessage: widget.repliedMessage,
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
                                child: TextField(
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
