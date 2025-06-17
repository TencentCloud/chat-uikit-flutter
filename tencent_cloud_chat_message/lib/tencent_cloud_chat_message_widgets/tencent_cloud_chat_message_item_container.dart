import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_message_calling_message.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';

// MessageContainer is a StatefulWidget that is used for listening to
// TencentCloudChatMessageData and combining it with a pure message widget.
class TencentCloudChatMessageItemContainer extends StatefulWidget {
  final V2TimMessage message;

  /// The width of the message row, which represents the available width
  /// for displaying the message on the screen. This is useful for
  /// automatically wrapping text messages in a message bubble.
  final double messageRowWidth;

  final Widget Function(BuildContext context, bool shouldBeHighlighted, VoidCallback clearHighlightFunc,
      V2TimMessageReceipt? messageReceipt, String? messageText, SendingMessageData? sendingMessageData) messageBuilder;

  final bool inMergerMessagePreviewMode;

  const TencentCloudChatMessageItemContainer({
    Key? key,
    required this.message,
    required this.messageBuilder,
    required this.messageRowWidth,
    required this.inMergerMessagePreviewMode,
  }) : super(key: key);

  @override
  TencentCloudChatMessageItemContainerState createState() => TencentCloudChatMessageItemContainerState();
}

class TencentCloudChatMessageItemContainerState extends State<TencentCloudChatMessageItemContainer> {
  bool _shouldBeHighlighted = false;
  V2TimMessageReceipt? _messageReceipt;
  SendingMessageData? _sendingMessageData;
  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream =
      TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData>("TencentCloudChatMessageData");
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? _messageDataSubscription;

  // This method handles changes in message data.
  void _messageDataHandler(TencentCloudChatMessageData messageData) {
    final msgID = TencentCloudChatUtils.checkString(widget.message.msgID) ??
        TencentCloudChatUtils.checkString(widget.message.id) ??
        "";
    if (TencentCloudChatUtils.checkString(msgID) == null) {
      return;
    }
    final bool isGroup = TencentCloudChatUtils.checkString(widget.message.groupID) != null;
    final TencentCloudChatMessageDataKeys messageDataKeys = messageData.currentUpdatedFields;

    switch (messageDataKeys) {
      case TencentCloudChatMessageDataKeys.messageHighlighted:
        if ((messageData.messageHighlighted?.msgID == msgID) && (msgID.isNotEmpty)) {
          setState(() {
            _shouldBeHighlighted = true;
          });
        } else {
          setState(() {
            _shouldBeHighlighted = false;
          });
        }
      case TencentCloudChatMessageDataKeys.none:
        break;
      case TencentCloudChatMessageDataKeys.messageReadReceipts:
        final receipt = messageData.getMessageReadReceipt(
          msgID: msgID,
          userID: widget.message.userID ?? "",
          timestamp: widget.message.timestamp ?? 0,
        );
        if (isGroup &&
            (_messageReceipt == null ||
                _messageReceipt?.readCount != receipt.readCount ||
                _messageReceipt?.unreadCount != receipt.unreadCount)) {
          setState(() {
            _messageReceipt = receipt;
          });
        }
      case TencentCloudChatMessageDataKeys.messageList:
        break;
      case TencentCloudChatMessageDataKeys.downloadMessage:
        break;
      case TencentCloudChatMessageDataKeys.sendMessageProgress:
        if (messageData.messageProgressData.containsKey(msgID)) {
          if (messageData.messageProgressData[msgID] != null &&
              _sendingMessageData != messageData.messageProgressData[msgID]) {
            setState(() {
              _sendingMessageData = messageData.messageProgressData[msgID];
              if (_sendingMessageData!.isSendComplete) {
                TencentCloudChat.instance.dataInstance.messageData.messageProgressData.remove(msgID);
              }
            });
          }
        }
        break;
      case TencentCloudChatMessageDataKeys.currentPlayAudioInfo:
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _messageDataSubscription = _messageDataStream?.listen(_messageDataHandler);
    _messageReceipt = TencentCloudChat.instance.dataInstance.messageData.getMessageReadReceipt(
      msgID: widget.message.msgID ?? "",
      userID: widget.message.userID ?? "",
      timestamp: widget.message.timestamp ?? 0,
    );
  }

  @override
  void dispose() {
    _messageDataSubscription?.cancel();
    super.dispose();
  }

  // This method clears the message highlight.
  void _clearHighlight() {
    _shouldBeHighlighted = false;
    TencentCloudChat.instance.dataInstance.messageData.messageHighlighted = null;
  }

  @override
  Widget build(BuildContext context) {
    String? messageText;
    if (widget.message.status == MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED) {
      if (widget.message.revokerInfo != null &&
          TencentCloudChatUtils.checkString(widget.message.revokerInfo?.userID) != null) {
        messageText = tL10n.memberRecalledMessage(TencentCloudChatUtils.checkString(widget.message.revokerInfo?.nickName) ??
            widget.message.revokerInfo!.userID!);
      } else {
        messageText = tL10n.messageRecalled;
      }
    } else {
      switch (widget.message.elemType) {
        case 101:
          final TencentCloudChatMessageSeparateDataProvider dataProvider =
              TencentCloudChatMessageDataProviderInherited.of(context);
          final timeDividerConfig = dataProvider.config.timeDividerConfig;
          final customTimeStampParser = timeDividerConfig(
            userID: dataProvider.userID,
            groupID: dataProvider.groupID,
            topicID: dataProvider.topicID,
          ).timestampParser;
          final String? customTimeStamp =
              customTimeStampParser != null ? customTimeStampParser(widget.message.timestamp ?? 0) : null;
          messageText =
              customTimeStamp ?? TencentCloudChatIntl.localizedDateString(widget.message.timestamp ?? 0, context);
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
          messageText = widget.message.textElem?.text;
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS:
          messageText = TencentCloudChatUtils.buildGroupTipsText(widget.message.groupTipsElem);
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
          if (widget.message.customElem != null) {
            if (TencentCloudChatUtils.isCreateGroupCustomMessage(widget.message)) {
              messageText = TencentCloudChatUtils.getCreateGroupCustomText(widget.message);
            } else {
              final callingMessage = CallingMessage.getCallMessage(widget.message);
              if (callingMessage != null && callingMessage.isCallingSignal) {
                messageText = TencentCloudChatUtils.buildCallingText(widget.message);
              }
            }
          }
          break;
        default:
          break;
      }
    }

    return widget.messageBuilder(
      context,
      _shouldBeHighlighted,
      _clearHighlight,
      _messageReceipt,
      messageText,
      _sendingMessageData,
    );
  }
}
