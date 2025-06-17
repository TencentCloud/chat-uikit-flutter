import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/forward/tencent_cloud_chat_message_forward_container.dart';

class TencentCloudChatMessageItemWithMenuContainer extends StatefulWidget {
  final Widget Function({required bool renderOnMenuPreview, Key? key}) getMessageItemWidget;
  final bool useMessageReaction;
  final V2TimMessage message;
  final bool isMergeMessage;
  final bool isTextTranslatePluginEnabled;
  final bool isSoundToTextPluginEnabled;

  const TencentCloudChatMessageItemWithMenuContainer({
    super.key,
    required this.getMessageItemWidget,
    required this.useMessageReaction,
    required this.message,
    required this.isMergeMessage,
    required this.isTextTranslatePluginEnabled,
    required this.isSoundToTextPluginEnabled
  });

  @override
  State<TencentCloudChatMessageItemWithMenuContainer> createState() =>
      _TencentCloudChatMessageItemWithMenuContainerState();
}

class _TencentCloudChatMessageItemWithMenuContainerState
    extends TencentCloudChatState<TencentCloudChatMessageItemWithMenuContainer> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;
  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream =
  TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData>("TencentCloudChatMessageData");
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? _messageDataSubscription;

  List<TencentCloudChatMessageGeneralOptionItem> _menuOptions = [];
  V2TimMessageReceipt? _messageReceipt;

  late V2TimMessage _message;
  bool _hasTranslate = false;
  bool _hasConvertToText = false;

  // This method handles changes in message data.
  void _messageDataHandler(TencentCloudChatMessageData messageData) {
    final msgID = _message.msgID ?? "";
    final bool isGroup = TencentCloudChatUtils.checkString(_message.groupID) != null;
    final TencentCloudChatMessageDataKeys messageDataKeys = messageData.currentUpdatedFields;

    switch (messageDataKeys) {
      case TencentCloudChatMessageDataKeys.messageHighlighted:
        break;
      case TencentCloudChatMessageDataKeys.none:
        break;
      case TencentCloudChatMessageDataKeys.messageReadReceipts:
        final receipt = messageData.getMessageReadReceipt(
          msgID: msgID,
          userID: _message.userID ?? "",
          timestamp: _message.timestamp ?? 0,
        );
        if (isGroup &&
            (_messageReceipt == null ||
                _messageReceipt?.readCount != receipt.readCount ||
                _messageReceipt?.unreadCount != receipt.unreadCount)) {
          _messageReceipt = receipt;
          _generateMenuOptions(messageReceipt: receipt);
        }
      case TencentCloudChatMessageDataKeys.messageList:
        break;
      case TencentCloudChatMessageDataKeys.downloadMessage:
        break;
      case TencentCloudChatMessageDataKeys.sendMessageProgress:
        if (messageData.messageProgressData.containsKey(msgID)) {
          var data = messageData.messageProgressData[msgID];
          if (data != null) {
            _message = data.message;
            _generateMenuOptions();
          }
        } else if (TencentCloudChatUtils.checkString(_message.id) != null && _message.id != msgID &&
            messageData.messageProgressData.containsKey(_message.id)) {
          var data = messageData.messageProgressData[_message.id];
          if (data != null) {
            _message = data.message;
            _generateMenuOptions();
          }
        }
        break;
      case TencentCloudChatMessageDataKeys.currentPlayAudioInfo:
        break;
      case TencentCloudChatMessageDataKeys.messageNeedUpdate:
        final messageNeedUpdate = TencentCloudChat.instance.dataInstance.messageData.messageNeedUpdate;
        if (messageNeedUpdate != null && (
            (TencentCloudChatUtils.checkString(msgID) != null && msgID == messageNeedUpdate.msgID) ||
                (TencentCloudChatUtils.checkString(_message.id) != null && _message.id == messageNeedUpdate.id)
        )) {
          safeSetState(() {
            _message = messageNeedUpdate;
          });
          _generateMenuOptions();
        }
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _message = widget.message;
    _messageDataSubscription = _messageDataStream?.listen(_messageDataHandler);
    _messageReceipt = TencentCloudChat.instance.dataInstance.messageData.getMessageReadReceipt(
      msgID: _message.msgID ?? "",
      userID: _message.userID ?? "",
      timestamp: _message.timestamp ?? 0,
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
    dataProvider.addListener(dataProviderListener);
    _generateMenuOptions();
  }

  @override
  void dispose() {
    _messageDataSubscription?.cancel();
    dataProvider.removeListener(dataProviderListener);
    super.dispose();
  }

  void dataProviderListener() {
    bool latestTranslateState = dataProvider.translatedMessages.any((element) => element.msgID == _message.msgID);
    bool latestConvertToTextState = dataProvider.soundToTextMessages.any((element) => element.msgID == _message.msgID);
    if (latestTranslateState != _hasTranslate || latestConvertToTextState != _hasConvertToText) {
      safeSetState(() {
        _hasTranslate = latestTranslateState;
        _hasConvertToText = latestConvertToTextState;
        _generateMenuOptions();
      });
    }
  }

  bool _showRecallButton() {
    final TencentCloudChatMessageConfig config = dataProvider.config;
    final defaultMessageMenuConfig = config.defaultMessageMenuConfig(
      userID: dataProvider.userID,
      groupID: dataProvider.groupID,
      topicID: dataProvider.topicID,
    );
    if (!defaultMessageMenuConfig.enableMessageRecall) {
      return false;
    }
    final recallTimeLimit = config.recallTimeLimit(
      userID: dataProvider.userID,
      groupID: dataProvider.groupID,
      topicID: dataProvider.topicID,
    );

    final timeDiff = (DateTime
        .now()
        .millisecondsSinceEpoch / 1000).ceil() - (_message.timestamp ?? 0);
    final enableRecall = (timeDiff < recallTimeLimit) &&
        (_message.isSelf ?? true) &&
        _message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC;

    return enableRecall;
  }

  List<TencentCloudChatMessageGeneralOptionItem> _generateMenuOptions(
      {V2TimMessageReceipt? messageReceipt, String? selectedText}) {
    final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;

    final TencentCloudChatMessageConfig config = dataProvider.config;

    final List<TencentCloudChatMessageGeneralOptionItem> additionalOptions = config.additionalMessageMenuOptions(
      userID: dataProvider.userID,
      groupID: dataProvider.groupID,
      topicID: dataProvider.topicID,
      message: _message,
    );

    final defaultMessageMenuConfig = config.defaultMessageMenuConfig(
      userID: dataProvider.userID,
      groupID: dataProvider.groupID,
    );

    // === Message Delete ===
    final enableMessageDeleteForSelf = defaultMessageMenuConfig.enableMessageDeleteForSelf;

    // === Group Message Read Receipt ===
    final useReadReceipt = defaultMessageMenuConfig.enableGroupMessageReceipt &&
        TencentCloudChatUtils.checkString(dataProvider.groupID) != null &&
        dataProvider.config
            .enabledGroupTypesForMessageReadReceipt(
          userID: dataProvider.userID,
          groupID: dataProvider.groupID,
          topicID: dataProvider.topicID,
        )
            .contains(dataProvider.groupInfo?.groupType);
    final showReadReceipt = useReadReceipt && (_message.isSelf ?? true) && (_message.needReadReceipt ?? false);
    final receipt = showReadReceipt
        ? (messageReceipt ?? _messageReceipt) ??
        TencentCloudChat.instance.dataInstance.messageData.getMessageReadReceipt(
          msgID: _message.msgID ?? "",
          userID: _message.userID ?? "",
          timestamp: _message.timestamp ?? 0,
        )
        : null;
    final int? readCount = showReadReceipt ? receipt?.readCount : null;
    final int? unreadCount = showReadReceipt ? receipt?.unreadCount : null;
    final bool isAllRead = (readCount ?? 0) > 0 && unreadCount == 0;

    final defaultMenuOptions = [
      if (defaultMessageMenuConfig.enableMessageCopy)
        TencentCloudChatMessageGeneralOptionItem(
            iconAsset: (path: "lib/assets/copy_message.svg", package: "tencent_cloud_chat_message"),
            label: tL10n.copy,
            id: "_uikit_copy_message",
            onTap: ({Offset? offset}) {
              final text = _message.textElem?.text ?? "";
              Clipboard.setData(
                ClipboardData(text: selectedText ?? text),
              );
            }),
      if (defaultMessageMenuConfig.enableMessageQuote && _message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC)
        TencentCloudChatMessageGeneralOptionItem(
            iconAsset: (path: "lib/assets/quote_message.svg", package: "tencent_cloud_chat_message"),
            id: "_uikit_quote_message",
            label: config.enableQuoteWithMention(
              userID: dataProvider.userID,
              topicID: dataProvider.topicID,
              groupID: dataProvider.groupID,
            )
                ? tL10n.quote
                : tL10n.reply,
            onTap: ({Offset? offset}) {
              dataProvider.quotedMessage = _message;
            }),
      if (defaultMessageMenuConfig.enableMessageSelect)
        TencentCloudChatMessageGeneralOptionItem(
          iconAsset: (path: "lib/assets/multi_message.svg", package: "tencent_cloud_chat_message"),
          label: tL10n.multiSelect,
          id: "_uikit_multi_message",
          onTap: ({Offset? offset}) {
            Future.delayed(
              const Duration(milliseconds: 150),
                  () {
                dataProvider.inSelectMode = true;
                dataProvider.selectedMessages = [_message];
              },
            );
          },
        ),
      if (defaultMessageMenuConfig.enableMessageForward && _message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC)
        TencentCloudChatMessageGeneralOptionItem(
            iconAsset: (path: "lib/assets/forward_message.svg", package: "tencent_cloud_chat_message"),
            label: tL10n.forward,
            id: "_uikit_forward_message",
            onTap: ({Offset? offset}) {
              if (isDesktopScreen) {
                TencentCloudChatDesktopPopup.showPopupWindow(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.6,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.6,
                  operationKey: TencentCloudChatPopupOperationKey.forward,
                  context: context,
                  child: (closeFunc) =>
                      TencentCloudChatMessageForwardContainer(
                        type: TencentCloudChatForwardType.individually,
                        onCloseModal: closeFunc,
                        context: context,
                        messages: [_message],
                        messageForwardBuilder: TencentCloudChatMessageDataProviderInherited
                            .of(context)
                            .messageBuilders
                            ?.getMessageForwardBuilder,
                      ),
                );
              } else {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext _) {
                    return TencentCloudChatMessageForwardContainer(
                      type: TencentCloudChatForwardType.individually,
                      messageForwardBuilder: TencentCloudChatMessageDataProviderInherited
                          .of(context)
                          .messageBuilders
                          ?.getMessageForwardBuilder,
                      context: context,
                      messages: [_message],
                    );
                  },
                );
              }
            }),
      if (enableMessageDeleteForSelf)
        TencentCloudChatMessageGeneralOptionItem(
            iconAsset: (path: "lib/assets/delete_message.svg", package: "tencent_cloud_chat_message"),
            label: tL10n.delete,
            id: "_uikit_delete_message",
            onTap: ({Offset? offset}) {
              if (isDesktopScreen) {
                TencentCloudChatDesktopPopup.showSecondaryConfirmDialog(
                  operationKey: TencentCloudChatPopupOperationKey.confirmDeleteMessages,
                  context: context,
                  title: tL10n.confirmDeletion,
                  text: tL10n.askDeleteThisMessage,
                  width: enableMessageDeleteForSelf ? 600 : 400,
                  height: 200,
                  actions: [
                    (
                    onTap: () {},
                    label: tL10n.cancel,
                    type: TencentCloudChatDesktopPopupActionButtonType.secondary,
                    ),
                    if (enableMessageDeleteForSelf)
                      (
                      onTap: () {
                        dataProvider.deleteMessagesForMe(messages: [_message]);
                      },
                      label: tL10n.confirm,
                      type: TencentCloudChatDesktopPopupActionButtonType.primary,
                      ),
                  ],
                );
              } else {
                TencentCloudChatDialog.showAdaptiveDialog(
                  context: context,
                  title: Text(tL10n.confirmDeletion),
                  content: Text(tL10n.askDeleteThisMessage),
                  actions: [
                    if (enableMessageDeleteForSelf)
                      TextButton(
                        onPressed: () {
                          dataProvider.deleteMessagesForMe(messages: [_message]);
                          Navigator.pop(context);
                        },
                        child: Text(tL10n.confirm),
                      ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(tL10n.cancel),
                    ),
                  ],
                );
              }
            }),
      if (_showRecallButton())
        TencentCloudChatMessageGeneralOptionItem(
            iconAsset: (path: "lib/assets/revoke_message.svg", package: "tencent_cloud_chat_message"),
            label: tL10n.recall,
            id: "_uikit_revoke_message",
            onTap: ({Offset? offset}) {
              if (isDesktopScreen) {
                TencentCloudChatDesktopPopup.showSecondaryConfirmDialog(
                    operationKey: TencentCloudChatPopupOperationKey.confirmDeleteMessages,
                    context: context,
                    title: tL10n.messageRecall,
                    text: tL10n.messageRecallConfirmation,
                    width: 400,
                    height: 200,
                    onCancel: () {},
                    onConfirm: () {
                      dataProvider.recallMessage(message: _message);
                    });
              } else {
                TencentCloudChatDialog.showAdaptiveDialog(
                  context: context,
                  title: Text(tL10n.messageRecall),
                  content: Text(tL10n.messageRecallConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () {
                        dataProvider.recallMessage(message: _message);
                        Navigator.pop(context);
                      },
                      child: Text(tL10n.recall),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(tL10n.cancel),
                    ),
                  ],
                );
              }
            }),
      if (showReadReceipt && _message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC)
        TencentCloudChatMessageGeneralOptionItem(
            icon: Icons.visibility,
            id: "_uikit_read_receipt",
            label: isAllRead ? tL10n.allMembersRead : tL10n.memberReadCount(readCount ?? 0),
            onTap: ({Offset? offset}) {}),
      if (widget.isTextTranslatePluginEnabled && _message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC &&
          !_hasTranslate)
        TencentCloudChatMessageGeneralOptionItem(
          icon: Icons.translate_outlined,
          label: tL10n.translate,
          id: "_uikit_translate",
          onTap: ({offset}) {
            dataProvider.translatedMessages = [_message];
          },
        ),
      if (widget.isSoundToTextPluginEnabled && _message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC &&
          !_hasConvertToText)
        TencentCloudChatMessageGeneralOptionItem(
          icon: Icons.translate_outlined,
          label: tL10n.convertToText,
          id: "_uikit_convert_to_text",
          onTap: ({offset}) {
            dataProvider.soundToTextMessages = [_message];
          },
        )
    ];

    final mergedList = [...defaultMenuOptions, ...additionalOptions];

    if (_message.elemType != MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
      mergedList.removeWhere((element) => (element.id == "_uikit_copy_message" || element.id == "_uikit_translate"));
    }

    if (_message.elemType != MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
      mergedList.removeWhere((element) => (element.id == "_uikit_convert_to_text"));
    }

    if (!(_message.isSelf ?? false)) {
      mergedList.removeWhere((element) => element.id == "_uikit_revoke_message");
    }

    if (TencentCloudChatUtils.checkString(selectedText) == null) {
      _menuOptions = mergedList;
    }
    return mergedList;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatMessageDataProviderInherited
        .of(context)
        .messageBuilders
        ?.getMessageItemMenuBuilder(
      data: MessageItemMenuBuilderData(
        message: _message,
        isMergeMessage: widget.isMergeMessage,
        inSelectMode: dataProvider.inSelectMode,
        useMessageReaction: widget.useMessageReaction,
        messageReactionPluginInstance: dataProvider.messageReactionPluginInstance,
      ),
      methods: MessageItemMenuBuilderMethods(
        onSelectMessage: () => dataProvider.triggerSelectedMessage(message: _message),
        getMessageItemWidget: widget.getMessageItemWidget,
        getMenuOptions: ({String? selectedText}) {
          if (TencentCloudChatUtils.checkString(selectedText) == null) {
            if (_menuOptions.any((element) => element.id == "_uikit_revoke_message")) {
              if (_showRecallButton() == false) {
                _menuOptions.removeWhere((element) => element.id == "_uikit_revoke_message");
              }
            }

            return _menuOptions;
          } else {
            return _generateMenuOptions(selectedText: selectedText);
          }
        },
      ),
    ) ??
        Container();
  }
}
