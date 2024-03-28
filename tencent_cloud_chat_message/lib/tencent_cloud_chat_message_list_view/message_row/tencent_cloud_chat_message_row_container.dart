import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';

class TencentCloudChatMessageRowContainer extends StatefulWidget {
  final V2TimMessage message;
  final bool isMergeMessage;
  final double messageRowWidth;

  const TencentCloudChatMessageRowContainer({
    super.key,
    required this.message,
    required this.isMergeMessage,
    required this.messageRowWidth,
  });

  @override
  State<TencentCloudChatMessageRowContainer> createState() => _TencentCloudChatMessageRowContainerState();
}

class _TencentCloudChatMessageRowContainerState extends TencentCloudChatState<TencentCloudChatMessageRowContainer> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;

  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.eventBusInstance.on<TencentCloudChatMessageData>();
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? _messageDataSubscription;

  bool _isSelected = false;
  bool _inSelectMode = false;

  late V2TimMessage _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
    _messageDataSubscription = _messageDataStream?.listen(_messageDataHandler);
  }

  @override
  void didUpdateWidget(covariant TencentCloudChatMessageRowContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message != _message && widget.message != oldWidget.message) {
      safeSetState(() {
        _message = widget.message;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
    dataProvider.addListener(dataProviderListener);
    dataProviderListener();
  }

  @override
  void dispose() {
    super.dispose();
    dataProvider.removeListener(dataProviderListener);
    _messageDataSubscription?.cancel();
  }

  // This method handles changes in message data.
  void _messageDataHandler(TencentCloudChatMessageData messageData) {
    final msgID = _message.msgID ?? "";
    final TencentCloudChatMessageDataKeys messageDataKeys = messageData.currentUpdatedFields;

    switch (messageDataKeys) {
      case TencentCloudChatMessageDataKeys.messageNeedUpdate:
        if (TencentCloudChat().dataInstance.messageData.messageNeedUpdate != null && msgID == TencentCloudChat().dataInstance.messageData.messageNeedUpdate?.msgID && TencentCloudChatUtils.checkString(msgID) != null) {
          safeSetState(() {
            _message = TencentCloudChat().dataInstance.messageData.messageNeedUpdate!;
          });
        }
      default:
        break;
    }
  }

  void dataProviderListener() {
    /// _isSelected
    final selectMessages = dataProvider.selectedMessages;
    final newSelected =
        selectMessages.any((element) => (TencentCloudChatUtils.checkString(_message.msgID) != null && element.msgID == _message.msgID) || (TencentCloudChatUtils.checkString(_message.id) != null && element.id == _message.id));
    if (newSelected != _isSelected) {
      setState(() {
        _isSelected = newSelected;
      });
    }

    /// _inSelectMode
    final inSelectMode = dataProvider.inSelectMode;
    if (_inSelectMode != inSelectMode) {
      setState(() {
        _inSelectMode = inSelectMode;
      });
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    // Use LayoutBuilder to get the width of the parent widget (i.e., the width of the message row).
    return TencentCloudChatMessageBuilders.getMessageRowBuilder(
      key: Key(_message.msgID ?? _message.id!),
      message: _message,
      userID: dataProvider.userID,
      groupID: dataProvider.groupID,
      messageRowWidth: widget.messageRowWidth,
      inSelectMode: _inSelectMode,
      loadToSpecificMessage: dataProvider.loadToSpecificMessage,
      isSelected: _isSelected,
      isMergeMessage: widget.isMergeMessage,
      onSelectCurrent: (msg) {
        final selectMessages = dataProvider.selectedMessages;
        if (selectMessages.any((element) => (TencentCloudChatUtils.checkString(msg.msgID) != null && element.msgID == msg.msgID) || (TencentCloudChatUtils.checkString(msg.id) != null && element.id == msg.id))) {
          selectMessages.removeWhere((element) => (TencentCloudChatUtils.checkString(msg.msgID) != null && element.msgID == msg.msgID) || (TencentCloudChatUtils.checkString(msg.id) != null && element.id == msg.id));
        } else {
          selectMessages.add(msg);
        }
        dataProvider.selectedMessages = selectMessages;
      },
    );
  }
}
