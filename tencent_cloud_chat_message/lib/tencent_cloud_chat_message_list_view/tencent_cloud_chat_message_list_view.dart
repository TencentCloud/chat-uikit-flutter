import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_list/message_list.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_list/message_list_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_row/tencent_cloud_chat_message_row_container.dart';

class TencentCloudChatMessageListView extends StatefulWidget {
  final MessageListViewBuilderData data;
  final MessageListViewBuilderMethods methods;

  const TencentCloudChatMessageListView({
    super.key,
    required this.data,
    required this.methods,
  });

  @override
  State<TencentCloudChatMessageListView> createState() => _TencentCloudChatMessageListViewState();
}

class _TencentCloudChatMessageListViewState extends TencentCloudChatState<TencentCloudChatMessageListView> {
  final MessageListController _messageListController = MessageListController();
  late TencentCloudChatMessageController? controller;
  List<V2TimMessage> _messagesMentionedMe = [];
  double? _maxWidth;

  @override
  void initState() {
    super.initState();
    controller = widget.methods.controller as TencentCloudChatMessageController?;
    controller?.addListener(_controllerEventListener);
    _messagesMentionedMe = widget.data.messagesMentionedMe;
  }

  @override
  void didUpdateWidget(TencentCloudChatMessageListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.messagesMentionedMe != oldWidget.data.messagesMentionedMe) {
      setState(() {
        _messagesMentionedMe = widget.data.messagesMentionedMe;
      });
    }
  }

  @override
  void dispose() {
    controller?.removeListener(_controllerEventListener);
    super.dispose();
  }

  int _findMsgIndex(String? msgID) {
    if (TencentCloudChatUtils.checkString(msgID) == null) {
      return -1;
    }
    final messageList = widget.methods.getMessageList().asMap();
    final target = messageList.entries.lastWhere((entry) {
      return (entry.value.msgID == msgID!);
    }, orElse: () {
      return MapEntry(-1, V2TimMessage(elemType: 0));
    });
    return target.key;
  }

  void _controllerEventListener() {
    final current =
        (controller?.userID == widget.data.userID && TencentCloudChatUtils.checkString(widget.data.userID) != null) ||
            (controller?.topicID == widget.data.topicID &&
                TencentCloudChatUtils.checkString(widget.data.topicID) != null) ||
            (controller?.groupID == widget.data.groupID &&
                TencentCloudChatUtils.checkString(widget.data.groupID) != null);
    if (current) {
      final event = controller?.eventName;
      switch (event) {
        case EventName.scrollToBottom:
          _messageListController.scrollToBottom();
          break;
        case EventName.scrollToSpecificMessage:
          final int index = _findMsgIndex(controller?.eventValue);
          if (index > -1) {
            _messageListController.animateToIndex(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              offset: 100,
              offsetBasedOnBottom: true,
            );
          }
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) => Container(
      color: colorTheme.backgroundColor,
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            if (_maxWidth != constraints.maxWidth) {
              Future.delayed(const Duration(milliseconds: 10), () {
                setState(() {
                  _maxWidth = constraints.maxWidth;
                });
              });
            }
            return Row(
              children: [
                Expanded(
                    child: Container(
                      height: 0,
                    ))
              ],
            );
          }),
          if (_maxWidth != null)
            Expanded(
              child: MessageList(
                haveMorePreviousData: widget.data.haveMorePreviousData,
                haveMoreLatestData: widget.data.haveMoreLatestData,
                offsetToTriggerLoadPrevious: 200,
                offsetToTriggerLoadLatest: 100,
                unreadMsgCount: (widget.data.unreadCount ?? 0) > 0 ? widget.data.unreadCount : null,
                onLoadToLatest: widget.methods.loadToLatestMessage,
                onLoadPreviousMsgs: () =>
                    widget.methods.loadMoreMessages(direction: TencentCloudChatMessageLoadDirection.previous),
                onLoadLatestMsgs: () =>
                    widget.methods.loadMoreMessages(direction: TencentCloudChatMessageLoadDirection.latest),
                msgCount: widget.data.messageList.length,
                messagesMentionedMe: _messagesMentionedMe,
                controller: _messageListController,
                determineIsLatestReadMessage: (index) {
                  final message = widget.data.messageList[index];
                  final messageKey = TencentCloudChatUtils.checkString(widget.data.groupID) != null
                      ? int.tryParse(message.seq ?? "")
                      : message.timestamp;
                  if (TencentCloudChatUtils.checkString(widget.data.groupID) != null) {
                    return (messageKey == widget.data.groupReadSequence && widget.data.groupReadSequence != null, true);
                  } else {
                    final previousMessageKey =
                        widget.data.messageList[min(widget.data.messageList.length - 1, index + 1)].timestamp ?? 0;
                    return (
                    (widget.data.c2cReadTimestamp != null) &&
                        ((widget.data.c2cReadTimestamp ?? 0) < (messageKey ?? 0)) &&
                        ((widget.data.c2cReadTimestamp ?? 0) > previousMessageKey) &&
                        (previousMessageKey < (messageKey ?? 0)),
                    false
                    );
                  }
                },
                closeSticker: widget.methods.closeSticker,
                latestReadMsgKey: TencentCloudChatUtils.checkString(widget.data.groupID) != null
                    ? widget.data.groupReadSequence
                    : widget.data.c2cReadTimestamp,
                itemBuilder: (BuildContext context, int index) {
                  V2TimMessage message = widget.data.messageList[index];
                  return TencentCloudChatMessageRowContainer(
                    key: ValueKey(message.msgID),
                    messageRowWidth: _maxWidth!,
                    message: message,
                    inMergerMessagePreviewMode: false,
                  );
                },
                onMsgKey: (int index) =>
                widget.data.messageList[index].msgID ??
                    widget.data.messageList[index].id ??
                    widget.data.messageList[index].timestamp.toString(),
                onLoadToLatestReadMessage: () async {
                  try {
                    await widget.methods.loadToSpecificMessage(
                      highLightTargetMessage: false,
                      timeStamp: TencentCloudChatUtils.checkString(widget.data.userID) != null
                          ? widget.data.c2cReadTimestamp
                          : null,
                      seq: TencentCloudChatUtils.checkString(widget.data.groupID) != null
                          ? widget.data.groupReadSequence
                          : null,
                    );
                    return;
                  } catch (e) {
                    return;
                  }
                },
                onLoadToLatestMessageMentionedMe: () async {
                  final V2TimMessage latestMessage = _messagesMentionedMe.first;
                  await widget.methods.loadToSpecificMessage(
                    highLightTargetMessage: true,
                    message: latestMessage,
                  );
                  _messagesMentionedMe.removeAt(0);
                  return;
                },
              ),
            ),
        ],
      ),
    ));
  }
}
