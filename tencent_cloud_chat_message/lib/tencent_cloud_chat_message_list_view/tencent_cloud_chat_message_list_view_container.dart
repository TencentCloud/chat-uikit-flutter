import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';

class TencentCloudChatMessageListViewContainer extends StatefulWidget {
  final String? userID;
  final String? groupID;

  const TencentCloudChatMessageListViewContainer({super.key, this.userID, this.groupID}) : assert((userID == null) != (groupID == null));

  @override
  State<TencentCloudChatMessageListViewContainer> createState() => _TencentCloudChatMessageListViewContainerState();
}

class _TencentCloudChatMessageListViewContainerState extends TencentCloudChatState<TencentCloudChatMessageListViewContainer> {
  List<V2TimMessage> messageList = [];
  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData>();
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? _messageDataSubscription;
  late TencentCloudChatMessageSeparateDataProvider dataProvider;

  /// Message List Status
  V2TimConversation? _conversation;
  bool _haveMorePreviousData = true;
  bool _haveMoreLatestData = false;
  List<V2TimMessage>? _messagesMentionedMe;

  bool _init = false;
  Key _messageListKey = UniqueKey();

  // This method handles changes in message data.
  void _messageDataHandler(TencentCloudChatMessageData messageData) {
    final TencentCloudChatMessageDataKeys messageDataKeys = messageData.currentUpdatedFields;
    final updateUserID = TencentCloudChatUtils.checkString(messageData.currentOperateUserID);
    final updateGroupID = TencentCloudChatUtils.checkString(messageData.currentOperateGroupID);
    final isCurrentConversation = ((updateUserID == widget.userID) && updateUserID != null) || ((updateGroupID == widget.groupID) && updateGroupID != null);

    switch (messageDataKeys) {
      case TencentCloudChatMessageDataKeys.messageHighlighted:
        break;
      case TencentCloudChatMessageDataKeys.messageNeedUpdate:
        break;
      case TencentCloudChatMessageDataKeys.none:
        break;
      case TencentCloudChatMessageDataKeys.messageReadReceipts:
        break;
      case TencentCloudChatMessageDataKeys.messageList:
        if (isCurrentConversation) {
          var previousList = messageList;
          var nextList = dataProvider.getMessageListForRender(
            messageListKey: TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
          );
          if (!TencentCloudChatUtils.deepEqual(previousList, nextList)) {
            safeSetState(() {
              messageList = nextList;
              _haveMoreLatestData = dataProvider.haveMoreLatestData;
              _haveMorePreviousData = dataProvider.haveMorePreviousData;
            });
          } else {
            if (_haveMoreLatestData != dataProvider.haveMoreLatestData) {
              safeSetState(() {
                _haveMoreLatestData = dataProvider.haveMoreLatestData;
              });
            }
            if (_haveMorePreviousData != dataProvider.haveMorePreviousData) {
              safeSetState(() {
                _haveMorePreviousData = dataProvider.haveMorePreviousData;
              });
            }
          }
        }
      case TencentCloudChatMessageDataKeys.downloadMessage:
        break;
      case TencentCloudChatMessageDataKeys.sendMessageProgress:
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 10), () {
        safeSetState(() {
          messageList = dataProvider.getMessageListForRender(
            messageListKey: TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
          );
          _haveMoreLatestData = dataProvider.haveMoreLatestData;
          _haveMorePreviousData = dataProvider.haveMorePreviousData;
        });
        TencentCloudChat.instance.dataInstance.messageData.loadMessageList(
          groupID: widget.groupID,
          userID: widget.userID,
          direction: TencentCloudChatMessageLoadDirection.previous,
        );
      });
    });
  }

  @override
  void didUpdateWidget(covariant TencentCloudChatMessageListViewContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.userID != oldWidget.userID && !(TencentCloudChatUtils.checkString(widget.userID) == null && TencentCloudChatUtils.checkString(oldWidget.userID) == null)) ||
        (widget.groupID != oldWidget.groupID && !(TencentCloudChatUtils.checkString(widget.groupID) == null && TencentCloudChatUtils.checkString(oldWidget.groupID) == null))) {
      // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 10), () {
        safeSetState(() {
          messageList = dataProvider.getMessageListForRender(
            messageListKey: TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
          );
          _haveMoreLatestData = dataProvider.haveMoreLatestData;
          _haveMorePreviousData = dataProvider.haveMorePreviousData;
        });
        TencentCloudChat.instance.dataInstance.messageData.loadMessageList(
          groupID: widget.groupID,
          userID: widget.userID,
          direction: TencentCloudChatMessageLoadDirection.previous,
        );
      });
      // });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      return;
    }
    _init = true;
    dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
    dataProvider.addListener(dataProviderListener);
  }

  @override
  void dispose() {
    _messageDataSubscription?.cancel();
    dataProvider.removeListener(dataProviderListener);
    super.dispose();
  }

  void dataProviderListener() {
    // Conversation
    if (dataProvider.conversation != _conversation) {
      safeSetState(() {
        _conversation = dataProvider.conversation;
      });
      if (dataProvider.conversation != null) {
        setState(() {
          _messageListKey = UniqueKey();
        });
      }
    }

    // Mentioned Messages
    if (dataProvider.messagesMentionedMe != _messagesMentionedMe) {
      safeSetState(() {
        _messagesMentionedMe = dataProvider.messagesMentionedMe;
      });
    }
  }

  Future<void> _loadMoreMessage({
    required TencentCloudChatMessageLoadDirection direction,
  }) {
    final actualMessageList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(
      key: dataProvider.groupID ?? dataProvider.userID ?? "",
    );
    final lastMsgID = direction == TencentCloudChatMessageLoadDirection.previous ? actualMessageList.last.msgID : actualMessageList.first.msgID;
    return dataProvider.loadMessageList(
      groupID: widget.groupID,
      userID: widget.userID,
      direction: direction,
      lastMsgID: lastMsgID,
    );
  }

  Future<void> _loadToLatestMessage() {
    return dataProvider.loadMessageList(
      groupID: widget.groupID,
      userID: widget.userID,
      direction: TencentCloudChatMessageLoadDirection.previous,
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageListViewBuilder(
              key: _messageListKey,
              loadToLatestMessage: _loadToLatestMessage,
              controller: dataProvider.messageController,
              messageList: messageList,
              messagesMentionedMe: _messagesMentionedMe ?? [],
              highlightMessage: (message) => TencentCloudChat.instance.dataInstance.messageData.messageHighlighted = message,
              loadToSpecificMessage: dataProvider.loadToSpecificMessage,
              loadMoreMessages: _loadMoreMessage,
              haveMorePreviousData: _haveMorePreviousData,
              groupID: widget.groupID,
              userID: widget.userID,
              unreadCount: _conversation?.unreadCount,
              c2cReadTimestamp: _conversation?.c2cReadTimestamp,
              groupReadSequence: _conversation?.groupReadSequence,
              haveMoreLatestData: _haveMoreLatestData,
              getMessageList: dataProvider.getMessageListForRender,
              onSelectMessages: (List<V2TimMessage> value) {
                final selectMessages = dataProvider.selectedMessages;
                for (var msg in value) {
                  if (selectMessages.any((element) => (TencentCloudChatUtils.checkString(msg.msgID) != null && element.msgID == msg.msgID) || (TencentCloudChatUtils.checkString(msg.id) != null && element.id == msg.id))) {
                    selectMessages.removeWhere((element) => (TencentCloudChatUtils.checkString(msg.msgID) != null && element.msgID == msg.msgID) || (TencentCloudChatUtils.checkString(msg.id) != null && element.id == msg.id));
                  } else {
                    selectMessages.add(msg);
                  }
                }
                dataProvider.selectedMessages = selectMessages;
              },
            ) ??
        Container();
  }
}
