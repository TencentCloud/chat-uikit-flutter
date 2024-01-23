import 'package:flutter/cupertino.dart';
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
  State<TencentCloudChatMessageRowContainer> createState() =>
      _TencentCloudChatMessageRowContainerState();
}

class _TencentCloudChatMessageRowContainerState
    extends TencentCloudChatState<TencentCloudChatMessageRowContainer> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;
  bool _isSelected = false;
  bool _inSelectMode = false;

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
  }

  void dataProviderListener() {
    /// _isSelected
    final selectMessages = dataProvider.selectedMessages;
    final newSelected = selectMessages.any((element) =>
        (TencentCloudChatUtils.checkString(widget.message.msgID) != null &&
            element.msgID == widget.message.msgID) ||
        (TencentCloudChatUtils.checkString(widget.message.id) != null &&
            element.id == widget.message.id));
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
      key: Key(widget.message.msgID ?? widget.message.id!),
      message: widget.message,
      messageRowWidth: widget.messageRowWidth,
      inSelectMode: _inSelectMode,
      isSelected: _isSelected,
      isMergeMessage: widget.isMergeMessage,
      onSelectCurrent: (msg) {
        final selectMessages = dataProvider.selectedMessages;
        if (selectMessages.any((element) =>
            (TencentCloudChatUtils.checkString(msg.msgID) != null &&
                element.msgID == msg.msgID) ||
            (TencentCloudChatUtils.checkString(msg.id) != null &&
                element.id == msg.id))) {
          selectMessages.removeWhere((element) =>
              (TencentCloudChatUtils.checkString(msg.msgID) != null &&
                  element.msgID == msg.msgID) ||
              (TencentCloudChatUtils.checkString(msg.id) != null &&
                  element.id == msg.id));
        } else {
          selectMessages.add(msg);
        }
        dataProvider.selectedMessages = selectMessages;
      },
    );
  }
}
