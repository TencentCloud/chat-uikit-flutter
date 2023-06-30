import 'dart:async';
import 'dart:math';
import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_setting_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field_layout/narrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_at_text.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field_layout/wide.dart';

enum MuteStatus { none, me, all }

typedef CustomStickerPanel = Widget Function({
  void Function() sendTextMessage,
  void Function(int index, String data) sendFaceMessage,
  void Function() deleteText,
  void Function(int unicode) addText,
  void Function(String singleEmojiName) addCustomEmojiText,
  List<CustomEmojiFaceData> defaultCustomEmojiStickerList,

  /// If non-null, requires the child to have exactly this width.
  double? width,

  /// If non-null, requires the child to have exactly this height.
  double? height,
});

class TIMUIKitInputTextField extends StatefulWidget {
  /// conversation id
  final String conversationID;

  /// conversation type
  final ConvType conversationType;

  /// init text, use for draft text re-view
  final String? initText;

  /// messageList widget scroll controller
  final AutoScrollController? scrollController;

  /// messageList widget scroll controller
  final AutoScrollController? atMemberPanelScroll;

  /// hint text for textField widget
  final String? hintText;

  /// config for more panel
  final MorePanelConfig? morePanelConfig;

  /// show send audio icon
  final bool showSendAudio;

  /// show send emoji icon
  final bool showSendEmoji;

  /// show more panel
  final bool showMorePanel;

  /// background color
  final Color? backgroundColor;

  /// control input field behavior
  final TIMUIKitInputTextFieldController? controller;

  /// on text changed
  final void Function(String)? onChanged;

  final TUIChatSeparateViewModel model;

  /// Whether to use the default emoji
  final bool isUseDefaultEmoji;

  final List customEmojiStickerList;

  /// sticker panel customization
  final CustomStickerPanel? customStickerPanel;

  /// Conversation need search
  final V2TimConversation currentConversation;

  final String? groupType;

  final String? groupID;

  const TIMUIKitInputTextField(
      {Key? key,
      required this.conversationID,
      required this.conversationType,
      this.initText,
      this.hintText,
      this.scrollController,
      this.morePanelConfig,
      this.customStickerPanel,
      this.showSendAudio = true,
      this.showSendEmoji = true,
      this.showMorePanel = true,
      this.backgroundColor,
      this.controller,
      this.onChanged,
      this.isUseDefaultEmoji = false,
      this.customEmojiStickerList = const [],
      required this.model,
      required this.currentConversation,
      this.groupType,
      this.atMemberPanelScroll,
      this.groupID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends TIMUIKitState<TIMUIKitInputTextField> {
  final TUIChatGlobalModel globalModel = serviceLocator<TUIChatGlobalModel>();
  final TUISettingModel settingModel = serviceLocator<TUISettingModel>();
  final RegExp atTextReg = RegExp(r'@([^@\s]*)');
  late FocusNode focusNode;
  String zeroWidthSpace = '\ufeff';
  String lastText = "";
  String languageType = "";
  int? currentCursor;
  bool isAddingAtSearchWords = false;
  double inputWidth = 900;
  Map<String, V2TimGroupMemberFullInfo> mentionedMembersMap = {};
  late TextEditingController textEditingController;
  final TUIConversationViewModel conversationModel =
      serviceLocator<TUIConversationViewModel>();
  final TUISelfInfoViewModel selfModel = serviceLocator<TUISelfInfoViewModel>();
  MuteStatus muteStatus = MuteStatus.none;
  bool _isComposingText = false;
  int latestSendEditStatusTime = DateTime.now().millisecondsSinceEpoch;

  setCurrentCursor(int? value) {
    currentCursor = value;
  }

  void addStickerToText(String sticker) {
    final oldText = textEditingController.text;
    if (currentCursor != null && currentCursor! > -1) {
      final firstString = oldText.substring(0, currentCursor);
      final secondString = oldText.substring(currentCursor!);
      currentCursor = currentCursor! + sticker.length;
      textEditingController.text = "$firstString$sticker$secondString";
    } else {
      textEditingController.text = "$oldText$sticker";
    }

    if (TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop) {
      textEditingController.selection = TextSelection.fromPosition(TextPosition(
          offset: currentCursor ?? textEditingController.text.length));
      focusNode.requestFocus();
    }
  }

  String _filterU200b(String text) {
    return text.replaceAll(RegExp(r'\ufeff'), "");
  }

  Future handleSetDraftText([String? id, ConvType? convType]) async {
    String text = textEditingController.text;
    String convID = id ?? widget.conversationID;
    final isTopic = convID.contains("@TOPIC#");
    String conversationID = isTopic
        ? convID
        : ((convType ?? widget.conversationType) == ConvType.c2c
            ? "c2c_$convID"
            : "group_$convID");
    String draftText = _filterU200b(text);
    return await conversationModel.setConversationDraft(
        groupID: widget.groupID,
        isTopic: isTopic,
        isAllowWeb: widget.model.chatConfig.isUseDraftOnWeb,
        conversationID: conversationID,
        draftText: draftText);
  }

  backSpaceText() {
    String originalText = textEditingController.text;
    dynamic text;

    if (originalText == zeroWidthSpace) {
      _handleSoftKeyBoardDelete();
    } else {
      text = originalText.characters.skipLast(1);
      textEditingController.text = text;
    }
  }

// 和onSubmitted一样，只是保持焦点的不同
  onEmojiSubmitted() {
    lastText = "";
    final text = textEditingController.text.trim();
    final convType = widget.conversationType;
    conversationModel.clearWebDraft(conversationID: widget.conversationID);
    if (text.isNotEmpty && text != zeroWidthSpace) {
      if (widget.model.repliedMessage != null) {
        MessageUtils.handleMessageError(
            widget.model.sendReplyMessage(
              text: text,
              convID: widget.conversationID,
              convType: convType,
              atUserIDList: getUserIdFromMemberInfoMap(),
            ),
            context);
      } else {
        MessageUtils.handleMessageError(
            widget.model.sendTextMessage(
              text: text,
              convID: widget.conversationID,
              convType: convType,
            ),
            context);
      }
      textEditingController.clear();
      goDownBottom();
    }
    currentCursor = null;
  }

// index为emoji的index,data为baseurl+name
  onCustomEmojiFaceSubmitted(int index, String data) {
    final convType = widget.conversationType;
    if (widget.model.repliedMessage != null) {
      MessageUtils.handleMessageError(
          widget.model.sendFaceMessage(
              index: index,
              data: data,
              convID: widget.conversationID,
              convType: convType),
          context);
    } else {
      MessageUtils.handleMessageError(
          widget.model.sendFaceMessage(
              index: index,
              data: data,
              convID: widget.conversationID,
              convType: convType),
          context);
    }
  }

  List<String> getUserIdFromMemberInfoMap() {
    List<String> userList = [];
    mentionedMembersMap.forEach((String key, V2TimGroupMemberFullInfo info) {
      userList.add(info.userID);
    });

    return userList;
  }

  onSubmitted() async {
    conversationModel.clearWebDraft(conversationID: widget.conversationID);
    lastText = "";
    final text = textEditingController.text.trim();
    final convType = widget.conversationType;
    if (text.isNotEmpty && text != zeroWidthSpace) {
      if (widget.model.repliedMessage != null) {
        MessageUtils.handleMessageError(
            widget.model.sendReplyMessage(
                text: text,
                convID: widget.conversationID,
                convType: convType,
                atUserIDList: getUserIdFromMemberInfoMap()),
            context);
      } else if (mentionedMembersMap.isNotEmpty) {
        widget.model.sendTextAtMessage(
            text: text,
            convType: widget.conversationType,
            convID: widget.conversationID,
            atUserList: getUserIdFromMemberInfoMap());
      } else {
        MessageUtils.handleMessageError(
            widget.model.sendTextMessage(
                text: text, convID: widget.conversationID, convType: convType),
            context);
      }
      textEditingController.clear();
      currentCursor = null;
      lastText = "";
      mentionedMembersMap = {};

      goDownBottom();
      _handleSendEditStatus("", false);
    }
  }

  void goDownBottom() {
    if (globalModel.getMessageListPosition(widget.conversationID) ==
        HistoryMessagePosition.notShowLatest) {
      return;
    }
    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        if (widget.scrollController != null) {
          widget.scrollController!.animateTo(
            widget.scrollController!.position.minScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
          );
        }
        // ignore: empty_catches
      } catch (e) {}
    });
  }

  _onCursorChange() {
    final selection = textEditingController.selection;
    currentCursor = selection.baseOffset;
  }

  _handleSoftKeyBoardDelete() {
    if (widget.model.repliedMessage != null) {
      widget.model.repliedMessage = null;
    }
  }

  String _getShowName(V2TimGroupMemberFullInfo? item) {
    return TencentUtils.checkStringWithoutSpace(item?.nameCard) ??
        TencentUtils.checkStringWithoutSpace(item?.nickName) ??
        TencentUtils.checkStringWithoutSpace(item?.userID) ??
        "";
  }

  mentionMemberInMessage(String? userID, String? nickName) {
    if (TencentUtils.checkString(userID) == null) {
      focusNode.requestFocus();
    } else {
      final memberInfo = widget.model.groupMemberList
              ?.firstWhere((element) => element?.userID == userID) ??
          V2TimGroupMemberFullInfo(
            userID: userID ?? "",
            nickName: nickName,
          );
      final showName = _getShowName(memberInfo);
      mentionedMembersMap["@$showName"] = memberInfo;
      String text = "${textEditingController.text}@$showName ";
      //please do not delete space
      focusNode.requestFocus();
      textEditingController.text = text;
      textEditingController.selection =
          TextSelection.fromPosition(TextPosition(offset: text.length));
      lastText = text;
      _isComposingText = false;
      narrowTextFieldKey.currentState?.showKeyboard = true;
    }
  }

  bool shouldRemoveAtTag(String atTag, String deletedChar) {
    final atMemberArray = [];
    mentionedMembersMap.forEach((key, value) {
      atMemberArray.add(key);
    });
    for (String member in atMemberArray) {
      if (atTag == member && member.contains(deletedChar)) {
        return true;
      }
    }
    return false;
  }

  Offset getAtPosition(String text, int atPlace) {
    final textBeforeAt = text.substring(0, atPlace + 1);
    final textPainter = TextPainter(
      text: TextSpan(text: textBeforeAt, style: const TextStyle(fontSize: 14)),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: inputWidth);
    final TextPosition lastLineOffset = textPainter
        .getPositionForOffset(Offset(textPainter.width, textPainter.height));
    final Offset caretPosition =
        textPainter.getOffsetForCaret(lastLineOffset, Rect.zero);
    final dx = min(inputWidth - 180, caretPosition.dx + 16);
    final dy = max(
            24,
            18 * widget.model.chatConfig.desktopMessageInputFieldLines -
                caretPosition.dy)
        .toDouble();

    return Offset(dx, dy);
  }

  calculateRemoveRemainAt(String text) {
    Map<String, V2TimGroupMemberFullInfo> map = {};
    Iterable<Match> matches = atTextReg.allMatches(text);
    List<String?> parseAtList = [];
    for (final item in matches) {
      final str = item.group(0);
      parseAtList.add(str);
    }
    for (String? key in parseAtList) {
      if (key != null && mentionedMembersMap[key] != null) {
        map[key] = mentionedMembersMap[key]!;
      }
    }
    mentionedMembersMap = map;
  }

  updateMentionedMap() {
    Map<String, V2TimGroupMemberFullInfo> map = {};
    Iterable<Match> matches = atTextReg.allMatches(textEditingController.text);
    List<String?> parseAtList = [];
    for (final item in matches) {
      final str = item.group(0);
      parseAtList.add(str);
    }
    for (String? key in parseAtList) {
      if (key != null && mentionedMembersMap[key] != null) {
        map[key] = mentionedMembersMap[key]!;
      }
    }
    mentionedMembersMap = map;
  }

  _handleAtText(String text, TUIChatSeparateViewModel model) async {
    final text = textEditingController.text;
    String? groupID = widget.conversationType == ConvType.group
        ? widget.conversationID
        : null;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    if (groupID == null) {
      lastText = text;
      return;
    }

    int textLength = text.length;
    // 删除的话
    if (lastText.length > textLength) {
      final List<Diff> differencesList = diff(lastText, text);
      final diffIndex = differencesList.first.text.length - 1;
      int atIndex = lastText.lastIndexOf('@', diffIndex);
      int spaceIndex = lastText.indexOf(' ', diffIndex);
      if (diffIndex < 0 || atIndex < 0 || spaceIndex <= atIndex) {
        lastText = text;
      } else {
        String atTag = lastText.substring(atIndex, spaceIndex);
        String deletedChar = lastText[diffIndex];
        if (shouldRemoveAtTag(atTag, deletedChar)) {
          final newText = lastText.substring(0, atIndex) +
              lastText.substring(spaceIndex + 1);
          textEditingController.text = newText;
          textEditingController.selection =
              TextSelection.collapsed(offset: atIndex);
          lastText = newText;
          updateMentionedMap();
          return;
        }
      }
      updateMentionedMap();
    }

    final int selfRole = widget.model.selfMemberInfo?.role ?? 0;
    final bool canAtAll =
        (selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN ||
            selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER);

    if (isDesktopScreen) {
      final atPlace = text.lastIndexOf("@");
      final keyword = text.substring(atPlace + 1);
      if (atPlace >= 0) {
        if (text[textLength - 1] == "@") {
          final atPosition = getAtPosition(text, atPlace);
          model.atPositionX = atPosition.dx;
          model.atPositionY = atPosition.dy;
          isAddingAtSearchWords = true;
        }
        List<V2TimGroupMemberFullInfo> showAtMemberList = (model
                    .groupMemberList ??
                [])
            .where((element) {
              final showName = (TencentUtils.checkStringWithoutSpace(
                          element?.friendRemark) ??
                      TencentUtils.checkStringWithoutSpace(element?.nameCard) ??
                      TencentUtils.checkStringWithoutSpace(element?.nickName) ??
                      TencentUtils.checkStringWithoutSpace(element?.userID) ??
                      "")
                  .toLowerCase();
              return element != null &&
                  showName.contains(keyword.toLowerCase()) &&
                  TencentUtils.checkString(showName) != null &&
                  element.userID != widget.model.selfMemberInfo?.userID;
            })
            .whereType<V2TimGroupMemberFullInfo>()
            .toList();

        showAtMemberList.sort(
            (V2TimGroupMemberFullInfo userA, V2TimGroupMemberFullInfo userB) {
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

        if (canAtAll && showAtMemberList.isNotEmpty && keyword.isEmpty) {
          showAtMemberList = [
            V2TimGroupMemberFullInfo(
                userID: "__kImSDK_MesssageAtALL__", nickName: TIM_t("所有人")),
            ...showAtMemberList
          ];
        }

        model.activeAtIndex = 0;
        model.showAtMemberList = showAtMemberList;

        isAddingAtSearchWords = showAtMemberList.isNotEmpty;
      } else {
        model.activeAtIndex = -1;
        model.showAtMemberList = [];
        isAddingAtSearchWords = false;
      }
    } else if (textLength > 0 &&
        text[textLength - 1] == "@" &&
        lastText.length < textLength) {
      V2TimGroupMemberFullInfo? memberInfo = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AtText(
              groupMemberList: model.groupMemberList,
              groupInfo: model.groupInfo,
              groupID: groupID,
              canAtAll: canAtAll,
              groupType: widget.groupType),
        ),
      );
      final showName = _getShowName(memberInfo);
      if (memberInfo != null) {
        mentionedMembersMap["@$showName"] = memberInfo;
        textEditingController.text = "$text$showName ";
        lastText = "$text$showName ";
      }
    }
    lastText = textEditingController.text;
  }

  void replaceAtTag(String selectedMember) {
    int cursorPosition = textEditingController.selection.baseOffset;
    int atIndex =
        textEditingController.text.lastIndexOf('@', cursorPosition - 1);
    if (atIndex >= 0) {
      String beforeAt = textEditingController.text.substring(0, atIndex);
      String afterAt = textEditingController.text.substring(cursorPosition);
      textEditingController.text =
          beforeAt + '@' + selectedMember + ' ' + afterAt;
      textEditingController.selection =
          TextSelection.collapsed(offset: atIndex + selectedMember.length + 2);
      lastText = beforeAt + '@' + selectedMember + ' ' + afterAt;
    }
  }

  void handleAtMember(
      {V2TimGroupMemberFullInfo? memberInfo,
      bool? isAddToCursorPosition = false}) {
    if (memberInfo != null) {
      final String showName = _getShowName(memberInfo);
      mentionedMembersMap["@$showName"] = memberInfo;
      replaceAtTag(showName);
      widget.model.showAtMemberList = [];
      widget.model.activeAtIndex = -1;
      focusNode.requestFocus();
    }
  }

  KeyEventResult handleDesktopKeyEvent(FocusNode node, RawKeyEvent event) {
    final activeIndex = widget.model.activeAtIndex;
    final showMemberList = widget.model.showAtMemberList;
    if (event.runtimeType == RawKeyDownEvent) {
      if (event.physicalKey == PhysicalKeyboardKey.backspace) {
        if (textEditingController.text.isEmpty && lastText.isEmpty) {
          widget.model.repliedMessage = null;
          return KeyEventResult.handled;
        }
      } else if ((event.isShiftPressed ||
              event.isAltPressed ||
              event.isControlPressed ||
              event.isMetaPressed) &&
          event.physicalKey == PhysicalKeyboardKey.enter) {
        final offset = textEditingController.selection.baseOffset;
        textEditingController.text =
            '${lastText.substring(0, offset)}\n${lastText.substring(offset)}';
        textEditingController.selection =
            TextSelection.fromPosition(TextPosition(offset: offset + 1));
        lastText = textEditingController.text;

        return KeyEventResult.handled;
      } else if (event.physicalKey == PhysicalKeyboardKey.enter) {
        if (!_isComposingText) {
          if (!isAddingAtSearchWords || widget.model.showAtMemberList.isEmpty) {
            onSubmitted();
          } else {
            isAddingAtSearchWords = false;
            final V2TimGroupMemberFullInfo? memberInfo =
                showMemberList[activeIndex];
            if (memberInfo != null) {
              handleAtMember(
                  memberInfo: memberInfo, isAddToCursorPosition: true);
            }
          }
          return KeyEventResult.handled;
        }
      }

      if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) &&
          isAddingAtSearchWords &&
          showMemberList.isNotEmpty) {
        final newIndex = max(activeIndex - 1, 0);
        widget.model.activeAtIndex = newIndex;
        widget.atMemberPanelScroll?.scrollToIndex(newIndex,
            preferPosition: AutoScrollPosition.middle);
        return KeyEventResult.handled;
      }

      if (event.isKeyPressed(LogicalKeyboardKey.arrowDown) &&
          isAddingAtSearchWords &&
          showMemberList.isNotEmpty) {
        final newIndex = min(activeIndex + 1, showMemberList.length - 1);
        widget.model.activeAtIndex = newIndex;
        widget.atMemberPanelScroll?.scrollToIndex(newIndex,
            preferPosition: AutoScrollPosition.middle);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    if (PlatformUtils().isWeb || PlatformUtils().isDesktop) {
      focusNode = FocusNode(
        onKey: (node, event) => handleDesktopKeyEvent(node, event),
      );
    } else {
      focusNode = FocusNode();
    }
    textEditingController =
        widget.controller?.textEditingController ?? TextEditingController();
    if (widget.initText != null) {
      textEditingController.text = widget.initText!;
    }
    if (widget.controller != null) {
      widget.controller?.addListener(controllerHandler);
    }
    final AppLocale appLocale = I18nUtils.findDeviceLocale(null);
    languageType =
        (appLocale == AppLocale.zhHans || appLocale == AppLocale.zhHant)
            ? 'zh'
            : 'en';
    textEditingController.addListener(() {
      _isComposingText = textEditingController.value.composing.start != -1;
    });
  }

  controllerHandler() {
    final actionType = widget.controller?.actionType;
    if (actionType == ActionType.longPressToAt) {
      mentionMemberInMessage(
          widget.controller?.atUserID, widget.controller?.atUserName);
    } else if (actionType == ActionType.setTextField) {
      final newText = widget.controller?.inputText ?? "";
      textEditingController.text = newText;
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
      lastText = textEditingController.text;
      focusNode.requestFocus();
      return;
    } else if (actionType == ActionType.requestFocus) {
      focusNode.requestFocus();
      return;
    } else if (actionType == ActionType.handleAtMember) {
      handleAtMember(memberInfo: widget.controller?.groupMemberFullInfo);
      return;
    }
  }

  @override
  void didUpdateWidget(TIMUIKitInputTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.conversationID != oldWidget.conversationID) {
      mentionedMembersMap.clear();
      handleSetDraftText(oldWidget.conversationID, oldWidget.conversationType);
      if (oldWidget.initText != widget.initText) {
        textEditingController.text = widget.initText ?? "";
      } else {
        textEditingController.clear();
      }
    }
    if (widget.initText != oldWidget.initText &&
        TencentUtils.checkString(widget.initText) != null) {
      textEditingController.text = widget.initText!;
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    handleSetDraftText();
    if (widget.controller != null) {
      widget.controller?.removeListener(controllerHandler);
    }
    focusNode.dispose();
    super.dispose();
  }

  Future<bool> getMemberMuteStatus(String userID) async {
    // Get the mute state of the members recursively
    if (widget.model.groupMemberList?.any((item) => (item?.userID == userID)) ??
        false) {
      final int muteUntil = widget.model.groupMemberList
              ?.firstWhere((item) => (item?.userID == userID))
              ?.muteUntil ??
          0;
      return muteUntil * 1000 > DateTime.now().millisecondsSinceEpoch;
    } else {
      return false;
    }
  }

  _getMuteType(TUIChatSeparateViewModel model) async {
    if (!mounted) {
      return;
    }
    if (widget.conversationType == ConvType.group) {
      if ((model.groupInfo?.isAllMuted ?? false) &&
          muteStatus != MuteStatus.all) {
        Future.delayed(const Duration(seconds: 0), () {
          setState(() {
            muteStatus = MuteStatus.all;
          });
        });
      } else if (selfModel.loginInfo?.userID != null &&
          await getMemberMuteStatus(selfModel.loginInfo!.userID!) &&
          muteStatus != MuteStatus.me) {
        Future.delayed(const Duration(seconds: 0), () {
          setState(() {
            muteStatus = MuteStatus.me;
          });
        });
      } else if (!(model.groupInfo?.isAllMuted ?? false) &&
          !(selfModel.loginInfo?.userID != null &&
              await getMemberMuteStatus(selfModel.loginInfo!.userID!)) &&
          muteStatus != MuteStatus.none) {
        Future.delayed(const Duration(seconds: 0), () {
          setState(() {
            muteStatus = MuteStatus.none;
          });
        });
      }
    } else {
      Future.delayed(const Duration(seconds: 0), () {
        setState(() {
          muteStatus = MuteStatus.none;
        });
      });
    }
  }

  _handleSendEditStatus(String value, bool status) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (value.isNotEmpty && widget.conversationType == ConvType.c2c) {
      if (status) {
        if (now - latestSendEditStatusTime < 5 * 1000) {
          return;
        }
      }
      // send status
      globalModel.sendEditStatusMessage(status, widget.conversationID);
      latestSendEditStatusTime = now;
    } else {
      globalModel.sendEditStatusMessage(false, widget.conversationID);
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    final TUIChatSeparateViewModel model =
        Provider.of<TUIChatSeparateViewModel>(context);

    _getMuteType(model);

    return Selector<TUIChatSeparateViewModel, V2TimMessage?>(
        builder: ((context, value, child) {
          String? getForbiddenText() {
            if (!(model.isGroupExist)) {
              return "群组不存在";
            } else if (model.isNotAMember) {
              return "您不是群成员";
            } else if (muteStatus == MuteStatus.all) {
              return "全员禁言中";
            } else if (muteStatus == MuteStatus.me) {
              return "您被禁言";
            }
            return null;
          }

          final forbiddenText = getForbiddenText();
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            inputWidth = constraints.maxWidth;
            return TUIKitScreenUtils.getDeviceWidget(
                context: context,
                defaultWidget: TIMUIKitTextFieldLayoutNarrow(
                    onEmojiSubmitted: onEmojiSubmitted,
                    onCustomEmojiFaceSubmitted: onCustomEmojiFaceSubmitted,
                    backSpaceText: backSpaceText,
                    addStickerToText: addStickerToText,
                    customStickerPanel: widget.customStickerPanel,
                    forbiddenText: forbiddenText,
                    onChanged: widget.onChanged,
                    backgroundColor: widget.backgroundColor,
                    morePanelConfig: widget.morePanelConfig,
                    repliedMessage: value,
                    currentCursor: currentCursor,
                    hintText: widget.hintText,
                    isUseDefaultEmoji: widget.isUseDefaultEmoji,
                    languageType: languageType,
                    textEditingController: textEditingController,
                    conversationID: widget.conversationID,
                    conversationType: widget.conversationType,
                    focusNode: focusNode,
                    controller: widget.controller,
                    setCurrentCursor: setCurrentCursor,
                    onCursorChange: _onCursorChange,
                    model: model,
                    handleSendEditStatus: _handleSendEditStatus,
                    handleAtText: (text) {
                      _handleAtText(text, model);
                    },
                    handleSoftKeyBoardDelete: _handleSoftKeyBoardDelete,
                    onSubmitted: onSubmitted,
                    goDownBottom: goDownBottom,
                    showSendAudio: widget.showSendAudio,
                    showSendEmoji: widget.showSendEmoji,
                    showMorePanel: widget.showMorePanel,
                    customEmojiStickerList: widget.customEmojiStickerList),
                desktopWidget: TIMUIKitTextFieldLayoutWide(
                    theme: theme,
                    currentConversation: widget.currentConversation,
                    onEmojiSubmitted: onEmojiSubmitted,
                    onCustomEmojiFaceSubmitted: onCustomEmojiFaceSubmitted,
                    backSpaceText: backSpaceText,
                    addStickerToText: addStickerToText,
                    customStickerPanel: widget.customStickerPanel,
                    forbiddenText: forbiddenText,
                    onChanged: widget.onChanged,
                    backgroundColor: widget.backgroundColor,
                    morePanelConfig: widget.morePanelConfig,
                    repliedMessage: value,
                    currentCursor: currentCursor,
                    hintText: widget.hintText,
                    isUseDefaultEmoji: widget.isUseDefaultEmoji,
                    languageType: languageType,
                    textEditingController: textEditingController,
                    conversationID: widget.conversationID,
                    conversationType: widget.conversationType,
                    focusNode: focusNode,
                    controller: widget.controller,
                    setCurrentCursor: setCurrentCursor,
                    onCursorChange: _onCursorChange,
                    model: model,
                    handleSendEditStatus: _handleSendEditStatus,
                    handleAtText: (text) {
                      _handleAtText(text, model);
                    },
                    onSubmitted: onSubmitted,
                    goDownBottom: goDownBottom,
                    showSendAudio: widget.showSendAudio,
                    showSendEmoji: widget.showSendEmoji,
                    showMorePanel: widget.showMorePanel,
                    customEmojiStickerList: widget.customEmojiStickerList));
          });
        }),
        selector: (c, model) => model.repliedMessage);
  }
}
