import 'dart:async';
import 'dart:math';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_setting_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/optimize_utils.dart';
import 'package:tencent_extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_emoji_panel.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_send_sound_message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_keyboard_visibility/tencent_keyboard_visibility.dart';
import 'special_text/DefaultSpecialTextSpanBuilder.dart';

enum MuteStatus { none, me, all }

class TIMUIKitInputTextField extends StatefulWidget {
  /// conversation id
  final String conversationID;

  /// conversation type
  final ConvType conversationType;

  /// init text, use for draft text re-view
  final String? initText;

  /// messageList widget scroll controller
  final AutoScrollController? scrollController;

  /// hint text for textField widget
  final String? hintText;

  /// config for more pannel
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

  final String? groupType;

  /// sticker panel customization
  final Widget Function(
          {void Function() sendTextMessage,
          void Function(int index, String data) sendFaceMessage,
          void Function() deleteText,
          void Function(int unicode) addText,
          void Function(String singleEmojiName) addCustomEmojiText,
          List<CustomEmojiFaceData> defaultCustomEmojiStickerList})?
      customStickerPanel;

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
      required this.model, this.groupType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends TIMUIKitState<TIMUIKitInputTextField> {
  final TUIChatGlobalModel globalModel = serviceLocator<TUIChatGlobalModel>();
  final TUISettingModel settingModel = serviceLocator<TUISettingModel>();
  bool showMore = false;
  bool showMoreButton = true;
  bool showSendSoundText = false;
  bool showEmojiPanel = false;
  bool showKeyboard = false;
  late FocusNode focusNode;
  String zeroWidthSpace = '\ufeff';
  String lastText = "";
  String languageType = "";
  double? bottomPadding;
  Function? setKeyboardHeight;
  int? currentCursor;

  Map<String, V2TimGroupMemberFullInfo> memberInfoMap = {};

  late TextEditingController textEditingController;
  final TUIConversationViewModel conversationModel =
      serviceLocator<TUIConversationViewModel>();
  final TUISelfInfoViewModel selfModel = serviceLocator<TUISelfInfoViewModel>();
  MuteStatus muteStatus = MuteStatus.none;

  int latestSendEditStatusTime = DateTime.now().millisecondsSinceEpoch;

  Widget _getBottomContainer() {
    if (showEmojiPanel) {
      return widget.customStickerPanel != null
          ? widget.customStickerPanel!(
              sendTextMessage: () {
                onEmojiSubmitted();
              },
              sendFaceMessage: onCustomEmojiFaceSubmitted,
              deleteText: () {
                backSpaceText();
              },
              addText: (int unicode) {
                final newText = String.fromCharCode(unicode);
                addStickerToText(newText);
                // handleSetDraftText();
              },
              addCustomEmojiText: ((String singleEmojiName) {
                String? emojiName = singleEmojiName.split('.png')[0];
                if (widget.isUseDefaultEmoji &&
                    languageType == 'zh' &&
                    ConstData.emojiMapList[emojiName] != null &&
                    ConstData.emojiMapList[emojiName] != '') {
                  emojiName = ConstData.emojiMapList[emojiName];
                }
                final newText = '[$emojiName]';
                addStickerToText(newText);
                setSendButton();
              }),
              defaultCustomEmojiStickerList:
                  widget.isUseDefaultEmoji ? ConstData.emojiList : [])
          : EmojiPanel(onTapEmoji: (unicode) {
              final newText = String.fromCharCode(unicode);
              addStickerToText(newText);
              setSendButton();
              // handleSetDraftText();
            }, onSubmitted: () {
              onEmojiSubmitted();
            }, delete: () {
              backSpaceText();
            });
    }

    if (showMore) {
      return MorePanel(
          morePanelConfig: widget.morePanelConfig,
          conversationID: widget.conversationID,
          conversationType: widget.conversationType);
    }

    return const SizedBox(height: 0);
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
  }

  double _getBottomHeight() {
    if (showKeyboard) {
      final currentKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      double originHeight = settingModel.keyboardHeight;
      if (currentKeyboardHeight != 0) {
        if (currentKeyboardHeight >= originHeight) {
          originHeight = currentKeyboardHeight;
        }
        if (setKeyboardHeight != null) {
          setKeyboardHeight!(currentKeyboardHeight);
        }
      }
      final height = originHeight != 0 ? originHeight : currentKeyboardHeight;
      return height;
    } else if (showMore || showEmojiPanel) {
      return 248.0 + (bottomPadding ?? 0.0);
    } else if (textEditingController.text.length >= 46 &&
        showKeyboard == false) {
      return 25 + (bottomPadding ?? 0.0);
    } else {
      return bottomPadding ?? 0;
    }
  }

  _openMore() {
    if (!showMore) {
      focusNode.unfocus();
      currentCursor = null;
    }
    setState(() {
      showKeyboard = false;
      showEmojiPanel = false;
      showSendSoundText = false;
      showMore = !showMore;
    });
  }

  _openEmojiPanel() {
    _onCursorChange();
    showKeyboard = showEmojiPanel;
    if (showEmojiPanel) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
    }

    setState(() {
      showMore = false;
      showSendSoundText = false;
      showEmojiPanel = !showEmojiPanel;
    });
  }

  String _filterU200b(String text) {
    return text.replaceAll(RegExp(r'\ufeff'), "");
  }

  getShowName(message) {
    return message.friendRemark == null || message.friendRemark == ''
        ? message.nickName == null || message.nickName == ''
            ? message.sender
            : message.nickName
        : message.friendRemark;
  }

  handleSetDraftText() async {
    String convID = widget.conversationID;
    String conversationID = widget.conversationType == ConvType.c2c
        ? "c2c_$convID"
        : "group_$convID";
    String text = textEditingController.text;
    String? draftText = _filterU200b(text);

    if (draftText.isEmpty) {
      draftText = "";
    }
    await conversationModel.setConversationDraft(
        conversationID: conversationID, draftText: draftText);
  }

  _buildRepliedMessage(V2TimMessage? repliedMessage) {
    final haveRepliedMessage = repliedMessage != null;
    if (haveRepliedMessage) {
      final text =
          "${MessageUtils.getDisplayName(widget.model.repliedMessage!)}:${widget.model.abstractMessageBuilder != null ? widget.model.abstractMessageBuilder!(widget.model.repliedMessage!) : MessageUtils.getAbstractMessageAsync(widget.model.repliedMessage!, widget.model.groupMemberList ?? [])}";
      return Container(
        color: widget.backgroundColor ?? hexToColor("f5f5f6"),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: hexToColor("8f959e"), fontSize: 14),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            InkWell(
              onTap: () {
                widget.model.repliedMessage = null;
              },
              child: Icon(Icons.clear, color: hexToColor("8f959e"), size: 18),
            )
          ],
        ),
      );
    }
    return Container();
  }

  void setSendButton() {
    final value = textEditingController.text;
    if (isWebDevice() || isAndroidDevice()) {
      if (value.isEmpty && showMoreButton != true) {
        setState(() {
          showMoreButton = true;
        });
      } else if (value.isNotEmpty && showMoreButton == true) {
        setState(() {
          showMoreButton = false;
        });
      }
    }
  }

  backSpaceText() {
    String originalText = textEditingController.text;
    dynamic text;

    if (originalText == zeroWidthSpace) {
      _handleSoftKeyBoardDelete();
      // _addDeleteTag();
    } else {
      text = originalText.characters.skipLast(1);
      textEditingController.text = "$text";
      // handleSetDraftText();
    }
    setSendButton();
  }

// 和onSubmitted一样，只是保持焦点的不同
  onEmojiSubmitted() {
    final text = textEditingController.text.trim();
    final convType = widget.conversationType;
    if (text.isNotEmpty && text != zeroWidthSpace) {
      if (widget.model.repliedMessage != null) {
        MessageUtils.handleMessageError(
            widget.model.sendReplyMessage(
                text: text, convID: widget.conversationID, convType: convType),
            context);
      } else {
        MessageUtils.handleMessageError(
            widget.model.sendTextMessage(
                text: text, convID: widget.conversationID, convType: convType),
            context);
      }
      textEditingController.clear();
      goDownBottom();
    }
    setSendButton();
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
    memberInfoMap.forEach((String key, V2TimGroupMemberFullInfo info) {
      userList.add(info.userID);
    });

    return userList;
  }

  onSubmitted() async {
    final text = textEditingController.text.trim();
    final convType = widget.conversationType;
    if (text.isNotEmpty && text != zeroWidthSpace) {
      if (widget.model.repliedMessage != null) {
        MessageUtils.handleMessageError(
            widget.model.sendReplyMessage(
                text: text, convID: widget.conversationID, convType: convType),
            context);
      } else if (memberInfoMap.isNotEmpty) {
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
      if (showKeyboard) {
        focusNode.requestFocus();
      }
      lastText = "";
      memberInfoMap = {};
      setState(() {
        if (textEditingController.text.isEmpty) {
          showMoreButton = true;
        }
      });
      goDownBottom();
      _handleSendEditStatus("", false);
    }
  }

  void goDownBottom() {
    if(globalModel.getMessageListPosition(widget.conversationID) == HistoryMessagePosition.notShowLatest){
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
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    });
  }

  _hideAllPanel() {
    focusNode.unfocus();
    currentCursor == null;
    if (showKeyboard != false || showMore != false || showEmojiPanel != false) {
      setState(() {
        showKeyboard = false;
        showMore = false;
        showEmojiPanel = false;
      });
    }
  }

  void onModelChanged() {
    if (widget.model.repliedMessage != null) {
      showKeyboard = true;
      focusNode.requestFocus();
      _addDeleteTag();
    } else {}
    if (widget.model.editRevokedMsg != "") {
      showKeyboard = true;
      focusNode.requestFocus();
      textEditingController.clear();
      textEditingController.text = widget.model.editRevokedMsg;
      textEditingController.selection = TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: widget.model.editRevokedMsg.length));
      widget.model.editRevokedMsg = "";
    }
  }

  _addDeleteTag() {
    final originalText = textEditingController.text;
    textEditingController.text = zeroWidthSpace + originalText;
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
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

  _getShowName(V2TimGroupMemberFullInfo? item) {
    final nameCard = item?.nameCard ?? "";
    final nickName = item?.nickName ?? "";
    final userID = item?.userID ?? "";
    return nameCard.isNotEmpty
        ? nameCard
        : nickName.isNotEmpty
            ? nickName
            : userID;
  }

  _longPressToAt(String? userID, String? nickName) {
    final memberInfo = V2TimGroupMemberFullInfo(
      userID: userID ?? "",
      nickName: nickName,
    );
    final showName = _getShowName(memberInfo);
    memberInfoMap["@$showName"] = memberInfo;
    String text = "$lastText@$showName ";
    //please do not delete space
    textEditingController.text = text;
    textEditingController.selection =
        TextSelection.fromPosition(TextPosition(offset: text.length));
    lastText = text;
  }

  _handleAtText(String text, TUIChatSeparateViewModel model) async {
    String? groupID = widget.conversationType == ConvType.group
        ? widget.conversationID
        : null;

    if (groupID == null) {
      lastText = text;
      return;
    }

    RegExp atTextReg = RegExp(r'@([^@\s]*)');

    int textLength = text.length;
    // 删除的话
    if (lastText.length > textLength && text != "@") {
      Map<String, V2TimGroupMemberFullInfo> map = {};
      Iterable<Match> matches = atTextReg.allMatches(text);
      List<String?> parseAtList = [];
      for (final item in matches) {
        final str = item.group(0);
        parseAtList.add(str);
      }
      for (String? key in parseAtList) {
        if (key != null && memberInfoMap[key] != null) {
          map[key] = memberInfoMap[key]!;
        }
      }
      memberInfoMap = map;
    }
    // 有@的情况并且是文本新增的时候
    if (textLength > 0 &&
        text[textLength - 1] == "@" &&
        (lastText.length < textLength || text == "@")) {
      V2TimGroupMemberFullInfo? memberInfo = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AtText(
              groupMemberList: model.groupMemberList,
              groupInfo: model.groupInfo,
              groupID: groupID,
              groupType: widget.groupType),
        ),
      );
      final showName = _getShowName(memberInfo);
      if (memberInfo != null) {
        memberInfoMap["@$showName"] = memberInfo;
        //please don not delete space
        textEditingController.text = "$text$showName ";
      }
    }
    lastText = text;
  }

  _debounce(
    Function(String text) fun, [
    Duration delay = const Duration(milliseconds: 30),
  ]) {
    Timer? timer;
    return (String text) {
      if (timer != null) {
        timer?.cancel();
      }

      timer = Timer(delay, () {
        fun(text);
      });
    };
  }

  @override
  void initState() {
    super.initState();
    if (PlatformUtils().isWeb) {
      focusNode = FocusNode(
        onKey: (node, event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
      );
    } else {
      focusNode = FocusNode();
    }
    textEditingController =
        widget.controller?.textEditingController ?? TextEditingController();
    if (widget.controller != null) {
      widget.controller?.addListener(() {
        final actionType = widget.controller?.actionType;
        if (actionType == ActionType.hideAllPanel) {
          _hideAllPanel();
        }
        if (actionType == ActionType.longPressToAt) {
          _longPressToAt(
              widget.controller?.atUserID, widget.controller?.atUserName);
        }
      });
    }
    widget.model.addListener(onModelChanged);
    if (widget.initText != null) {
      textEditingController.text = widget.initText!;
    }
    final AppLocale appLocale = I18nUtils.findDeviceLocale();
    languageType =
        (appLocale == AppLocale.zhHans || appLocale == AppLocale.zhHant)
            ? 'zh'
            : 'en';
  }

  @override
  void dispose() {
    handleSetDraftText();
    widget.model.removeListener(onModelChanged);
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

    setKeyboardHeight ??= OptimizeUtils.debounce((height) {
      settingModel.keyboardHeight = height;
    }, const Duration(seconds: 1));

    _getMuteType(model);

    final debounceFunc = _debounce((value) {
      if (isWebDevice() || isAndroidDevice()) {
        if (value.isEmpty && showMoreButton != true) {
          setState(() {
            showMoreButton = true;
          });
        } else if (value.isNotEmpty && showMoreButton == true) {
          setState(() {
            showMoreButton = false;
          });
        }
      }
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
      _handleAtText(value, model);
      _handleSendEditStatus(value, true);
      final isEmpty = value.isEmpty;
      if (isEmpty) {
        _handleSoftKeyBoardDelete();
      }
    }, const Duration(milliseconds: 80));

    final MediaQueryData data = MediaQuery.of(context);
    EdgeInsets padding = data.padding;
    if (bottomPadding == null || padding.bottom > bottomPadding!) {
      bottomPadding = padding.bottom;
    }

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
          return Column(
            children: [
              _buildRepliedMessage(value),
              Container(
                color: widget.backgroundColor ?? hexToColor("f5f5f6"),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      constraints: const BoxConstraints(minHeight: 50),
                      child: Row(
                        children: [
                          if (forbiddenText != null)
                            Expanded(
                                child: Container(
                              height: 35,
                              color: theme.weakBackgroundColor,
                              alignment: Alignment.center,
                              child: Text(
                                TIM_t(forbiddenText),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: theme.weakTextColor,
                                ),
                              ),
                            )),
                          if (!PlatformUtils().isWeb &&
                              widget.showSendAudio &&
                              forbiddenText == null)
                            InkWell(
                              onTap: () async {
                                showKeyboard = showSendSoundText;
                                if (showSendSoundText) {
                                  focusNode.requestFocus();
                                }
                                if (await Permissions.checkPermission(
                                  context,
                                  Permission.microphone.value,
                                  theme,
                                )) {
                                  setState(() {
                                    showEmojiPanel = false;
                                    showMore = false;
                                    showSendSoundText = !showSendSoundText;
                                  });
                                }
                              },
                              child: SvgPicture.asset(
                                showSendSoundText
                                    ? 'images/keyboard.svg'
                                    : 'images/voice.svg',
                                package: 'tencent_cloud_chat_uikit',
                                color: const Color.fromRGBO(68, 68, 68, 1),
                                height: 28,
                                width: 28,
                              ),
                            ),
                          if (forbiddenText == null)
                            const SizedBox(
                              width: 10,
                            ),
                          if (forbiddenText == null)
                            Expanded(
                              child: showSendSoundText
                                  ? SendSoundMessage(
                                      onDownBottom: goDownBottom,
                                      conversationID: widget.conversationID,
                                      conversationType: widget.conversationType)
                                  : KeyboardVisibility(
                                      child: ExtendedTextField(
                                          maxLines: 4,
                                          minLines: 1,
                                          focusNode: focusNode,
                                          onChanged: debounceFunc,
                                          onTap: () {
                                            showKeyboard = true;
                                            goDownBottom();
                                            setState(() {
                                              showEmojiPanel = false;
                                              showMore = false;
                                            });
                                          },
                                          keyboardType: TextInputType.multiline,
                                          textInputAction:
                                              PlatformUtils().isAndroid
                                                  ? TextInputAction.newline
                                                  : TextInputAction.send,
                                          onEditingComplete: onSubmitted,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: const TextStyle(
                                                // fontSize: 10,
                                                color: Color(0xffAEA4A3),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              hintText: widget.hintText ?? ''),
                                          controller: textEditingController,
                                          specialTextSpanBuilder: PlatformUtils()
                                                  .isWeb
                                              ? null
                                              : DefaultSpecialTextSpanBuilder(
                                                  isUseDefaultEmoji:
                                                      widget.isUseDefaultEmoji,
                                                  customEmojiStickerList: widget
                                                      .customEmojiStickerList,
                                                  showAtBackground: true,
                                                )),
                                      onChanged: (bool visibility) {
                                        if (showKeyboard != visibility) {
                                          setState(() {
                                            showKeyboard = visibility;
                                          });
                                        }
                                      }),
                            ),
                          if (forbiddenText == null)
                            const SizedBox(
                              width: 10,
                            ),
                          if (widget.showSendEmoji && forbiddenText == null)
                            InkWell(
                              onTap: () {
                                _openEmojiPanel();
                                goDownBottom();
                              },
                              child: PlatformUtils().isWeb
                                  ? Icon(
                                      showEmojiPanel
                                          ? Icons.keyboard_alt_outlined
                                          : Icons.mood_outlined,
                                      color: hexToColor("5c6168"),
                                      size: 32)
                                  : SvgPicture.asset(
                                      showEmojiPanel
                                          ? 'images/keyboard.svg'
                                          : 'images/face.svg',
                                      package: 'tencent_cloud_chat_uikit',
                                      color:
                                          const Color.fromRGBO(68, 68, 68, 1),
                                      height: 28,
                                      width: 28,
                                    ),
                            ),
                          if (forbiddenText == null)
                            const SizedBox(
                              width: 10,
                            ),
                          if (widget.showMorePanel &&
                              forbiddenText == null &&
                              showMoreButton)
                            InkWell(
                              onTap: () {
                                // model.sendCustomMessage(data: "a", convID: model.currentSelectedConv, convType: model.currentSelectedConvType == 1 ? ConvType.c2c : ConvType.group);
                                _openMore();
                                goDownBottom();
                              },
                              child: PlatformUtils().isWeb
                                  ? Icon(Icons.add_circle_outline_outlined,
                                      color: hexToColor("5c6168"), size: 32)
                                  : SvgPicture.asset(
                                      'images/add.svg',
                                      package: 'tencent_cloud_chat_uikit',
                                      color:
                                          const Color.fromRGBO(68, 68, 68, 1),
                                      height: 28,
                                      width: 28,
                                    ),
                            ),
                          if ((isAndroidDevice() || isWebDevice()) &&
                              !showMoreButton)
                            SizedBox(
                              height: 32.0,
                              child: ElevatedButton(
                                onPressed: onSubmitted,
                                child: Text(TIM_t("发送")),
                              ),
                            ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(
                          milliseconds:
                              (showKeyboard && PlatformUtils().isAndroid)
                                  ? 200
                                  : 340),
                      curve: Curves.fastOutSlowIn,
                      height: max(_getBottomHeight(), 0.0),
                      child: _getBottomContainer(),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
        selector: (c, model) => model.repliedMessage);
  }
}
