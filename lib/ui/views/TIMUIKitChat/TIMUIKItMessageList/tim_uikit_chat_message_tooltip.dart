// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/common_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/TIMUIKitMessageReaction/tim_uikit_message_reaction_select_emoji.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list_item.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/forward_message_screen.dart';
import 'package:tencent_open_file/tencent_open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class TIMUIKitMessageTooltip extends StatefulWidget {
  /// tool tips panel configuration, long press message will show tool tips panel
  final ToolTipsConfig? toolTipsConfig;

  /// current message
  final V2TimMessage message;

  /// allow notifi user when send reply message
  final bool allowAtUserWhenReply;

  /// the callback for long press event, except myself avatar
  final Function(String? userId, String? nickName)?
      onLongPressForOthersHeadPortrait;

  final bool isUseMessageReaction;

  /// direction
  final SelectEmojiPanelPosition selectEmojiPanelPosition;

  /// on add sticker reaction to a message
  final ValueChanged<int> onSelectSticker;

  /// on close tooltip area
  final VoidCallback onCloseTooltip;

  final TUIChatSeparateViewModel model;

  final bool isShowMoreSticker;

  const TIMUIKitMessageTooltip(
      {Key? key,
      this.toolTipsConfig,
      this.isUseMessageReaction = true,
      required this.model,
      required this.message,
      required this.allowAtUserWhenReply,
      this.onLongPressForOthersHeadPortrait,
      required this.selectEmojiPanelPosition,
      required this.onCloseTooltip,
      required this.onSelectSticker,
      this.isShowMoreSticker = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TIMUIKitMessageTooltipState();
}

class TIMUIKitMessageTooltipState
    extends TIMUIKitState<TIMUIKitMessageTooltip> {
  final TUIChatGlobalModel globalModal = serviceLocator<TUIChatGlobalModel>();
  bool isShowMoreSticker = false;
  bool isShowOpenFile = false;
  String filePath = "";

  @override
  void initState() {
    super.initState();
    hasFile();
    isShowMoreSticker = widget.isShowMoreSticker;
  }

  hasFile() {
    if (PlatformUtils().isMobile || widget.message.fileElem == null) {
      isShowOpenFile = false;
      return;
    }
    if (PlatformUtils().isWeb) {
      isShowOpenFile = true;
      return;
    }
    if (PlatformUtils().isDesktop) {
      if (globalModal.getMessageProgress(widget.message.msgID) == 100) {
        String savePath =
            TencentUtils.checkString(widget.message.fileElem!.localUrl) ??
                globalModal.getFileMessageLocation(widget.message.msgID);
        File f = File(savePath);
        if (f.existsSync() && widget.message.msgID != null) {
          filePath = savePath;
          isShowOpenFile = true;
          return;
        }
        isShowOpenFile = false;
        return;
      }
      String savePath = widget.message.fileElem!.localUrl ?? '';
      File f = File(savePath);
      if (f.existsSync() && widget.message.msgID != null) {
        filePath = savePath;
        globalModal.setMessageProgress(widget.message.msgID!, 100);
        isShowOpenFile = true;
        return;
      }
    }
    isShowOpenFile = false;
  }

  bool isRevocable(int timestamp, int upperTimeLimit) =>
      (DateTime.now().millisecondsSinceEpoch / 1000).ceil() - timestamp <
      upperTimeLimit;

  Widget ItemInkWell({
    Widget? child,
    GestureTapCallback? onTap,
  }) {
    return SizedBox(
      width: 44,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.only(bottom: 6, top: 6),
          child: child,
        ),
      ),
    );
  }

  bool isVoteMessage(V2TimMessage message) {
    bool isvote = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData["businessID"] == "group_poll") {
            isvote = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isvote;
  }

  _buildLongPressTipItem(
      TUITheme theme, TUIChatSeparateViewModel model, V2TimMessage message) {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final isCanRevoke = isRevocable(
        widget.message.timestamp!, model.chatConfig.upperRecallTime);
    final shouldShowRevokeAction = isCanRevoke &&
        (widget.message.isSelf ?? true) &&
        widget.message.status != MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL;
    final shouldShowReplyAction = !(widget.message.customElem?.data != null &&
        MessageUtils.isCallingData(widget.message.customElem!.data!));
    final shouldShowForwardAction = !(widget.message.customElem?.data != null &&
        MessageUtils.isCallingData(widget.message.customElem!.data!));
    final tooltipsConfig = widget.toolTipsConfig;
    final List<MessageToolTipItem> defaultTipsList = [
      if (isShowOpenFile)
        MessageToolTipItem(
            label: TIM_t("打开"),
            id: "open",
            iconImageAsset: "images/open_in_new.png",
            onClick: () => _onTap("open", model)),
      if (isShowOpenFile && PlatformUtils().isDesktop)
        MessageToolTipItem(
            label: PlatformUtils().isMacOS ? TIM_t("在访达中打开") : TIM_t("查看文件夹"),
            id: "finder",
            iconImageAsset: "images/folder_open.png",
            onClick: () => _onTap("finder", model)),
      MessageToolTipItem(
          label: TIM_t("复制"),
          id: "copyMessage",
          iconImageAsset: "images/copy_message.png",
          onClick: () => _onTap("copyMessage", model)),
      if (shouldShowForwardAction && !isVoteMessage(widget.message))
        MessageToolTipItem(
            label: TIM_t("转发"),
            id: "forwardMessage",
            iconImageAsset: "images/forward_message.png",
            onClick: () => _onTap("forwardMessage", model)),
      MessageToolTipItem(
          label: TIM_t("多选"),
          id: "multiSelect",
          iconImageAsset: "images/multi_message.png",
          onClick: () => _onTap("multiSelect", model)),
      if (shouldShowReplyAction)
        MessageToolTipItem(
            label: TIM_t(model.chatConfig.isAtWhenReply ? "回复" : "引用"),
            id: "replyMessage",
            iconImageAsset: "images/reply_message.png",
            onClick: () => _onTap("replyMessage", model)),
      MessageToolTipItem(
          label: TIM_t("删除"),
          id: "delete",
          iconImageAsset: "images/delete_message.png",
          onClick: () => _onTap("delete", model)),
      MessageToolTipItem(
          label: TIM_t("翻译"),
          id: "translate",
          iconImageAsset: "images/translate.png",
          onClick: () => _onTap("translate", model)),
      if (shouldShowRevokeAction)
        MessageToolTipItem(
            label: TIM_t("撤回"),
            id: "revoke",
            iconImageAsset: "images/revoke_message.png",
            onClick: () => _onTap("revoke", model)),
    ];
    List<MessageToolTipItem> defaultFormattedTipsList = defaultTipsList;
    if (tooltipsConfig != null) {
      defaultFormattedTipsList = defaultTipsList.where((element) {
        final type = element.id;
        if (type == "copyMessage") {
          return tooltipsConfig.showCopyMessage &&
              widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT;
        }
        if (type == "forwardMessage") {
          return tooltipsConfig.showForwardMessage && !isDesktopScreen;
        }
        if (type == "replyMessage") {
          return tooltipsConfig.showReplyMessage && !isDesktopScreen;
        }
        if (type == "delete") {
          return (!PlatformUtils().isWeb) && tooltipsConfig.showDeleteMessage;
        }
        if (type == "multiSelect") {
          return tooltipsConfig.showMultipleChoiceMessage;
        }

        if (type == "revoke") {
          return tooltipsConfig.showRecallMessage;
        }
        if (type == "translate") {
          return tooltipsConfig.showTranslation &&
              widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT;
        }
        return true;
      }).toList();
    }

    final List<MessageToolTipItem>? customList =
        widget.toolTipsConfig?.additionalMessageToolTips != null
            ? (widget.toolTipsConfig?.additionalMessageToolTips!(
                message, widget.onCloseTooltip))
            : [];

    List<MessageToolTipItem> formattedTipsList = [
      ...defaultFormattedTipsList,
      ...?customList,
    ];

    List<dynamic> widgetList = [];
    if (isDesktopScreen) {
      widgetList = formattedTipsList
          .map(
            (item) => Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  item.onClick();
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        item.iconImageAsset,
                        package: 'tencent_cloud_chat_uikit',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        height: 4,
                        width: 8,
                      ),
                      Text(
                        item.label,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: theme.darkTextColor,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList();
    } else {
      widgetList = formattedTipsList
          .map(
            (item) => Material(
              color: Colors.white,
              child: ItemInkWell(
                onTap: () {
                  item.onClick();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      item.iconImageAsset,
                      package: 'tencent_cloud_chat_uikit',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(
                      height: 4,
                      width: 60,
                    ),
                    Text(
                      item.label,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: theme.darkTextColor,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
          .toList();
    }
    if (widgetList.isEmpty && widget.isUseMessageReaction == false) {
      widget.onCloseTooltip();
    }

    return widgetList;
  }

  _onTap(String operation, TUIChatSeparateViewModel model) async {
    final messageItem = widget.message;
    final msgID = messageItem.msgID as String;
    switch (operation) {
      case "open":
        if (PlatformUtils().isDesktop) {
          final String savePath =
              TencentUtils.checkString(widget.message.fileElem!.localUrl) ??
                  globalModal.getFileMessageLocation(widget.message.msgID);
          launchUrl(Uri.file(savePath));
        } else {
          if (PlatformUtils().isWindows) {
            OpenFile.open(widget.message.fileElem?.path ?? "");
          } else {
            launchUrl(
              Uri.parse(widget.message.fileElem?.path ?? ""),
              mode: LaunchMode.externalApplication,
            );
          }
        }
        break;
      case "finder":
        final String savePath =
            TencentUtils.checkString(widget.message.fileElem!.localUrl) ??
                globalModal.getFileMessageLocation(widget.message.msgID);
        final String fileDir = path.dirname(savePath);
        if (PlatformUtils().isWindows) {
          OpenFile.open(fileDir);
        } else {
          launchUrl(Uri.file(fileDir));
        }
        break;
      case "delete":
        model.deleteMsg(msgID, webMessageInstance: messageItem.messageFromWeb);
        break;
      case "revoke":
        model.revokeMsg(msgID, messageItem.messageFromWeb);
        break;
      case 'translate':
        model.translateText(widget.message);
        break;
      case "multiSelect":
        model.updateMultiSelectStatus(true);
        model.addToMultiSelectedMessageList(widget.message);
        break;
      case "forwardMessage":
        model.addToMultiSelectedMessageList(widget.message);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForwardMessageScreen(
                      conversationType: ConvType.c2c,
                      model: model,
                    )));
        break;
      case "copyMessage":
        if (widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
          try {
            await Clipboard.setData(
                ClipboardData(text: widget.message.textElem?.text ?? ""));
            onTIMCallback(TIMCallback(
                type: TIMCallbackType.INFO,
                infoRecommendText: TIM_t("已复制"),
                infoCode: 6660408));
            // ignore: empty_catches
          } catch (e) {}
        }
        break;
      case "replyMessage":
        model.repliedMessage = widget.message;
        if (widget.allowAtUserWhenReply &&
            widget.onLongPressForOthersHeadPortrait != null &&
            !(widget.message.isSelf ?? true)) {
          widget.onLongPressForOthersHeadPortrait!(
              widget.message.sender, widget.message.nickName);
        }
        break;
      default:
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("暂未实现"),
            infoCode: 6660409));
    }
    widget.onCloseTooltip();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.model),
      ],
      builder: (BuildContext context, Widget? w) {
        final TUIChatSeparateViewModel model =
            Provider.of<TUIChatSeparateViewModel>(context);
        final bool haveExtraTipsConfig = widget.toolTipsConfig != null &&
            widget.toolTipsConfig?.additionalItemBuilder != null;
        Widget? extraTipsActionItem = haveExtraTipsConfig
            ? widget.toolTipsConfig!.additionalItemBuilder!(
                widget.message, widget.onCloseTooltip, null, context)
            : null;
        final message = widget.message;
        return Container(
            decoration: isDesktopScreen
                ? BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xCCbebebe),
                        offset: Offset(2, 2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      width: 1,
                      color: hexToColor("dee0e3"),
                    ),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  )
                : null,
            color: isDesktopScreen ? null : Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: 8, vertical: isDesktopScreen ? 8 : 4),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: min(MediaQuery.of(context).size.width * 0.75, 350),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if ((!isDesktopScreen || widget.isShowMoreSticker) &&
                      widget.isUseMessageReaction &&
                      widget.selectEmojiPanelPosition ==
                          SelectEmojiPanelPosition.up)
                    TIMUIKitMessageReactionEmojiSelectPanel(
                      isShowMoreSticker: isShowMoreSticker,
                      onSelect: (int value) => widget.onSelectSticker(value),
                      onClickShowMore: (bool value) {
                        setState(() {
                          isShowMoreSticker = value;
                        });
                      },
                    ),
                  if (!isDesktopScreen &&
                      widget.isUseMessageReaction &&
                      widget.selectEmojiPanelPosition ==
                          SelectEmojiPanelPosition.up &&
                      isShowMoreSticker == false)
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: const Divider(
                            thickness: 1,
                            indent: 0,
                            // endIndent: 10,
                            color: Colors.black12)),
                  if (isShowMoreSticker == false)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isDesktopScreen && widget.isUseMessageReaction)
                          Expanded(
                              child: Wrap(
                            direction: Axis.horizontal,
                            alignment:
                                TUIKitScreenUtils.getFormFactor(context) ==
                                        DeviceType.Mobile
                                    ? WrapAlignment.spaceBetween
                                    : WrapAlignment.start,
                            spacing: 4,
                            runSpacing: 8,
                            children: [
                              ..._buildLongPressTipItem(theme, model, message),
                              if (extraTipsActionItem != null)
                                extraTipsActionItem
                            ],
                          )),
                        if (!isDesktopScreen && !widget.isUseMessageReaction)
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: min(
                                  MediaQuery.of(context).size.width * 0.75,
                                  350),
                            ),
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment:
                                  TUIKitScreenUtils.getFormFactor(context) ==
                                          DeviceType.Mobile
                                      ? WrapAlignment.spaceBetween
                                      : WrapAlignment.start,
                              spacing: 4,
                              runSpacing: 8,
                              children: [
                                ..._buildLongPressTipItem(
                                    theme, model, message),
                                if (extraTipsActionItem != null)
                                  extraTipsActionItem
                              ],
                            ),
                          ),
                        if (isDesktopScreen)
                          Table(columnWidths: const <int, TableColumnWidth>{
                            0: IntrinsicColumnWidth(),
                          }, children: <TableRow>[
                            ..._buildLongPressTipItem(theme, model, message)
                                .map((e) => TableRow(children: <Widget>[e]))
                          ])
                      ],
                    ),
                  if (!isDesktopScreen &&
                      widget.isUseMessageReaction &&
                      widget.selectEmojiPanelPosition ==
                          SelectEmojiPanelPosition.down &&
                      isShowMoreSticker == false)
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: const Divider(
                            thickness: 1,
                            indent: 0,
                            // endIndent: 10,
                            color: Colors.black12)),
                  if ((!isDesktopScreen || widget.isShowMoreSticker) &&
                      widget.isUseMessageReaction &&
                      widget.selectEmojiPanelPosition ==
                          SelectEmojiPanelPosition.down)
                    TIMUIKitMessageReactionEmojiSelectPanel(
                      isShowMoreSticker: isShowMoreSticker,
                      onSelect: (int value) => widget.onSelectSticker(value),
                      onClickShowMore: (bool value) {
                        setState(() {
                          isShowMoreSticker = value;
                        });
                      },
                    ),
                ],
              ),
            ));
      },
    );
  }
}
