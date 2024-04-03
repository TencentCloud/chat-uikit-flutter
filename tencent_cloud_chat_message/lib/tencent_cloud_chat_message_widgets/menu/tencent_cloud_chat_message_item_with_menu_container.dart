import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/forward/tencent_cloud_chat_message_forward_container.dart';

class TencentCloudChatMessageItemWithMenuContainer extends StatefulWidget {
  final Widget Function({required bool renderOnMenuPreview}) messageItem;
  final bool useMessageReaction;
  final V2TimMessage message;
  final bool isMergeMessage;

  const TencentCloudChatMessageItemWithMenuContainer({
    super.key,
    required this.messageItem,
    required this.useMessageReaction,
    required this.message,
    required this.isMergeMessage,
  });

  @override
  State<TencentCloudChatMessageItemWithMenuContainer> createState() => _TencentCloudChatMessageItemWithMenuContainerState();
}

class _TencentCloudChatMessageItemWithMenuContainerState extends TencentCloudChatState<TencentCloudChatMessageItemWithMenuContainer> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;
  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.eventBusInstance.on<TencentCloudChatMessageData>();
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? _messageDataSubscription;

  List<TencentCloudChatMessageGeneralOptionItem> _menuOptions = [];
  V2TimMessageReceipt? _messageReceipt;

  late V2TimMessage _message;

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
        if (isGroup && (_messageReceipt == null || _messageReceipt?.readCount != receipt.readCount || _messageReceipt?.unreadCount != receipt.unreadCount)) {
          setState(() {
            _messageReceipt = receipt;
          });
          _generateMenuOptions(messageReceipt: receipt);
        }
      case TencentCloudChatMessageDataKeys.messageList:
        break;
      case TencentCloudChatMessageDataKeys.downloadMessage:
        break;
      case TencentCloudChatMessageDataKeys.sendMessageProgress:
        if (messageData.messageProgressData.containsKey(msgID)) {
          if (messageData.messageProgressData[msgID] != null) {
            setState(() {
              var data = messageData.messageProgressData[msgID];
              if (data != null) {
                _message = data.message;
              }
            });
            _generateMenuOptions();
          }
        }
        break;
      case TencentCloudChatMessageDataKeys.currentPlayAudioInfo:
        break;
      case TencentCloudChatMessageDataKeys.messageNeedUpdate:
        if (TencentCloudChat().dataInstance.messageData.messageNeedUpdate != null && msgID == TencentCloudChat().dataInstance.messageData.messageNeedUpdate?.msgID && TencentCloudChatUtils.checkString(msgID) != null) {
          safeSetState(() {
            _message = TencentCloudChat().dataInstance.messageData.messageNeedUpdate!;
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
    _messageReceipt = TencentCloudChat().dataInstance.messageData.getMessageReadReceipt(
          msgID: _message.msgID ?? "",
          userID: _message.userID ?? "",
          timestamp: _message.timestamp ?? 0,
        );
  }

  @override
  void dispose() {
    _messageDataSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
    _generateMenuOptions();
  }

  bool _showRecallButton() {
    final TencentCloudChatMessageConfig config = dataProvider.config;
    final defaultMessageMenuConfig = config.defaultMessageMenuConfig(userID: dataProvider.userID, groupID: dataProvider.groupID);
    if (!defaultMessageMenuConfig.enableMessageRecall) {
      return false;
    }
    final recallTimeLimit = config.recallTimeLimit(userID: dataProvider.userID, groupID: dataProvider.groupID);

    final timeDiff = (DateTime.now().millisecondsSinceEpoch / 1000).ceil() - (_message.timestamp ?? 0);
    final enableRecall = (timeDiff < recallTimeLimit) && (_message.isSelf ?? true) && _message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC;

    return enableRecall;
  }

  void _generateMenuOptions({V2TimMessageReceipt? messageReceipt}) {
    final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;

    final TencentCloudChatMessageConfig config = dataProvider.config;

    final List<TencentCloudChatMessageGeneralOptionItem> additionalOptions = config.additionalMessageMenuOptions(
      userID: dataProvider.userID,
      groupID: dataProvider.groupID,
    );

    final defaultMessageMenuConfig = config.defaultMessageMenuConfig(
      userID: dataProvider.userID,
      groupID: dataProvider.groupID,
    );

    // === Message Delete ===
    final enableMessageDeleteForEveryone = defaultMessageMenuConfig.enableMessageDeleteForEveryone && config.enableMessageDeleteForEveryone(userID: dataProvider.userID, groupID: dataProvider.groupID);
    final enableMessageDeleteForSelf = defaultMessageMenuConfig.enableMessageDeleteForSelf;
    final showDeleteForEveryone = (_message.isSelf ?? false) && enableMessageDeleteForEveryone;
    final showMessageDelete = showDeleteForEveryone || enableMessageDeleteForSelf;

    // === Group Message Read Receipt ===
    final useReadReceipt = defaultMessageMenuConfig.enableGroupMessageReceipt &&
        TencentCloudChatUtils.checkString(dataProvider.groupID) != null &&
        dataProvider.config
            .enabledGroupTypesForMessageReadReceipt(
              userID: dataProvider.userID,
              groupID: dataProvider.groupID,
            )
            .contains(dataProvider.groupInfo?.groupType);
    final showReadReceipt = useReadReceipt && (_message.isSelf ?? true) && (_message.needReadReceipt ?? false);
    final receipt = showReadReceipt
        ? messageReceipt ??
            TencentCloudChat().dataInstance.messageData.getMessageReadReceipt(
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
            icon: Icons.copy,
            label: tL10n.copy,
            onTap: ({Offset? offset}) {
              final text = _message.textElem?.text ?? "";
              Clipboard.setData(
                ClipboardData(text: text),
              );
            }),
      if (defaultMessageMenuConfig.enableMessageReply)
        TencentCloudChatMessageGeneralOptionItem(
            icon: Icons.reply_outlined,
            label: tL10n.reply,
            onTap: ({Offset? offset}) {
              dataProvider.repliedMessage = _message;
            }),
      if (defaultMessageMenuConfig.enableMessageSelect)
        TencentCloudChatMessageGeneralOptionItem(
          icon: Icons.check_circle_outline,
          label: tL10n.select,
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
      if (defaultMessageMenuConfig.enableMessageForward)
        TencentCloudChatMessageGeneralOptionItem(
            icon: Icons.forward,
            label: tL10n.forward,
            onTap: ({Offset? offset}) {
              if (isDesktopScreen) {
                TencentCloudChatDesktopPopup.showPopupWindow(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.6,
                  operationKey: TencentCloudChatPopupOperationKey.forward,
                  context: context,
                  child: (closeFunc) => TencentCloudChatMessageForwardContainer(
                    type: TencentCloudChatForwardType.individually,
                    onCloseModal: closeFunc,
                    context: context,
                    messages: [_message],
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
                      context: context,
                      messages: [_message],
                    );
                  },
                );
              }
            }),
      if (showMessageDelete)
        TencentCloudChatMessageGeneralOptionItem(
            icon: Icons.delete_outline_outlined,
            label: tL10n.delete,
            onTap: ({Offset? offset}) {
              if (isDesktopScreen) {
                TencentCloudChatDesktopPopup.showSecondaryConfirmDialog(
                  operationKey: TencentCloudChatPopupOperationKey.confirmDeleteMessages,
                  context: context,
                  title: tL10n.confirmDeletion,
                  text: tL10n.askDeleteThisMessage,
                  width: (showDeleteForEveryone && enableMessageDeleteForSelf) ? 600 : 400,
                  height: 200,
                  actions: [
                    (
                      onTap: () {},
                      label: tL10n.cancel,
                      type: TencentCloudChatDesktopPopupActionButtonType.secondary,
                    ),
                    if (showDeleteForEveryone)
                      (
                        onTap: () {
                          dataProvider.deleteMessagesForEveryone(messages: [_message]);
                        },
                        label: tL10n.deleteForEveryone,
                        type: TencentCloudChatDesktopPopupActionButtonType.primary,
                      ),
                    if (enableMessageDeleteForSelf)
                      (
                        onTap: () {
                          dataProvider.deleteMessagesForMe(messages: [_message]);
                        },
                        label: tL10n.deleteForMe,
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
                    if (showDeleteForEveryone)
                      TextButton(
                        onPressed: () {
                          dataProvider.deleteMessagesForEveryone(messages: [_message]);
                          Navigator.pop(context);
                        },
                        child: Text(tL10n.deleteForEveryone),
                      ),
                    if (enableMessageDeleteForSelf)
                      TextButton(
                        onPressed: () {
                          dataProvider.deleteMessagesForMe(messages: [_message]);
                          Navigator.pop(context);
                        },
                        child: Text(tL10n.deleteForMe),
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
            icon: Icons.undo_outlined,
            label: tL10n.recall,
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
      if (showReadReceipt) TencentCloudChatMessageGeneralOptionItem(icon: Icons.visibility, label: isAllRead ? tL10n.allMembersRead : tL10n.memberReadCount(readCount ?? 0), onTap: ({Offset? offset}) {}),
    ];

    final mergedList = [...defaultMenuOptions, ...additionalOptions];

    if (_message.elemType != MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
      mergedList.removeWhere((element) => element.label == tL10n.copy);
    }

    if (!(_message.isSelf ?? false)) {
      mergedList.removeWhere((element) => element.label == tL10n.recall);
    }

    setState(() {
      _menuOptions = mergedList;
    });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatMessageBuilders.getMessageLongPressBuilder(
      messageItem: widget.messageItem,
      useMessageReaction: widget.useMessageReaction,
      message: _message,
      menuOptions: _menuOptions,
      isMergeMessage: widget.isMergeMessage,
      inSelectMode: dataProvider.inSelectMode,
      onSelectMessage: () => dataProvider.triggerSelectedMessage(message: _message),
    );
  }
}
