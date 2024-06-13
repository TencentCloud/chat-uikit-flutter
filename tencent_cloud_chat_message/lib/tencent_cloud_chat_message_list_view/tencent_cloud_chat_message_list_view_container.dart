import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';

class TencentCloudChatMessageListViewContainer extends StatefulWidget {
  final String? userID;
  final String? groupID;
  final String? topicID;
  const TencentCloudChatMessageListViewContainer({super.key, this.userID, this.groupID, this.topicID}) : assert((userID == null) != (groupID == null));

  @override
  State<TencentCloudChatMessageListViewContainer> createState() => _TencentCloudChatMessageListViewContainerState();
}

class _TencentCloudChatMessageListViewContainerState extends TencentCloudChatState<TencentCloudChatMessageListViewContainer> {
  List<V2TimMessage> messageList = [];
  Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData>("TencentCloudChatMessageData");
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
    final isCurrentConversation = ((updateUserID == widget.userID) && updateUserID != null) || ((updateGroupID == (TencentCloudChatUtils.checkString(widget.topicID) ?? widget.groupID)) && updateGroupID != null);
    TencentCloudChat.instance.logInstance.console(
        componentName: 'TencentCloudChatMessageListViewContainer',
        logs:
        "_messageDataHandler -- isCurrentConversation: ${isCurrentConversation}  --updateUserID: ${updateUserID} -- updateGroupID: ${updateGroupID} -- widget.topicID: ${TencentCloudChatUtils.checkString(widget.topicID)} -- widget.groupID: ${widget.groupID} -- widget.userID: ${widget.userID} -- messageDataKeys: ${messageDataKeys}");

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
            messageListKey: TencentCloudChatUtils.checkString(widget.topicID) ?? TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
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
    TencentCloudChat.instance.logInstance.console(
        componentName: 'TencentCloudChatMessageListViewContainer',
        logs:
        "add _messageDataHandler start ${_messageDataStream != null}");

    _messageDataSubscription = _messageDataStream?.listen(_messageDataHandler);

    TencentCloudChat.instance.logInstance.console(
        componentName: 'TencentCloudChatMessageListViewContainer',
        logs:
        "add _messageDataHandler end");

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 10), () {
        safeSetState(() {
          messageList = dataProvider.getMessageListForRender(
            messageListKey: TencentCloudChatUtils.checkString(widget.topicID) ?? TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
          );
          _haveMoreLatestData = dataProvider.haveMoreLatestData;
          _haveMorePreviousData = dataProvider.haveMorePreviousData;
        });
        TencentCloudChat.instance.dataInstance.messageData.loadMessageList(
          groupID: widget.groupID,
          userID: widget.userID,
          topicID: widget.topicID,
          direction: TencentCloudChatMessageLoadDirection.previous,
        );
      });
    });
  }

  closeSticker() {
    dataProvider.closeSticker();
  }

  @override
  void didUpdateWidget(covariant TencentCloudChatMessageListViewContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    TencentCloudChat.instance.logInstance.console(
        componentName: 'TencentCloudChatMessageListViewContainer',
        logs:
        "didUpdateWidget add _messageDataHandler start ${_messageDataStream != null}");
    if(_messageDataStream == null){
      _messageDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData>("TencentCloudChatMessageData");
      _messageDataSubscription = _messageDataStream?.listen(_messageDataHandler);
    }
    if ((widget.userID != oldWidget.userID && !(TencentCloudChatUtils.checkString(widget.userID) == null && TencentCloudChatUtils.checkString(oldWidget.userID) == null)) ||
        (widget.groupID != oldWidget.groupID && !(TencentCloudChatUtils.checkString(widget.groupID) == null && TencentCloudChatUtils.checkString(oldWidget.groupID) == null)) ||
          (widget.topicID != oldWidget.topicID && !(TencentCloudChatUtils.checkString(widget.topicID) == null && TencentCloudChatUtils.checkString(oldWidget.topicID) == null))) {
      // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 10), () {
        safeSetState(() {
          messageList = dataProvider.getMessageListForRender(
            messageListKey:  TencentCloudChatUtils.checkString(widget.topicID) ??  TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
          );
          _haveMoreLatestData = dataProvider.haveMoreLatestData;
          _haveMorePreviousData = dataProvider.haveMorePreviousData;
        });
        TencentCloudChat.instance.dataInstance.messageData.loadMessageList(
          groupID: widget.groupID,
          topicID: widget.topicID,
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
    dataProvider.addListener(_dataProviderListener);
    _conversation=dataProvider.conversation;
  }

  @override
  void dispose() {
    _messageDataSubscription?.cancel();
    dataProvider.removeListener(_dataProviderListener);
    super.dispose();
  }

  void _dataProviderListener() {
    final newConversation = dataProvider.conversation;
    // Conversation
    if (newConversation?.conversationID != _conversation?.conversationID) {
      safeSetState(() {
        _conversation = dataProvider.conversation;
      });
      if (newConversation != null) {
        safeSetState(() {
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
      key: dataProvider.topicID ?? dataProvider.groupID ?? dataProvider.userID ?? "",
    );
    final lastMsgID = direction == TencentCloudChatMessageLoadDirection.previous ? actualMessageList.last.msgID : actualMessageList.first.msgID;
    return dataProvider.loadMessageList(
      groupID: widget.groupID,
      userID: widget.userID,
      topicID: widget.topicID,
      direction: direction,
      lastMsgID: lastMsgID,
    );
  }

  Future<void> _loadToLatestMessage() {
    return dataProvider.loadMessageList(
      groupID: widget.groupID,
      userID: widget.userID,
      topicID: widget.topicID,
      direction: TencentCloudChatMessageLoadDirection.previous,
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageListViewBuilder(
              key: _messageListKey,
              methods: MessageListViewBuilderMethods(
                loadToLatestMessage: _loadToLatestMessage,
                controller: dataProvider.messageController,
                highlightMessage: (message) => TencentCloudChat.instance.dataInstance.messageData.messageHighlighted = message,
                loadToSpecificMessage: dataProvider.loadToSpecificMessage,
                loadMoreMessages: _loadMoreMessage,
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
                closeSticker: closeSticker,
              ),
              data: MessageListViewBuilderData(
                messageList: messageList,
                messagesMentionedMe: _messagesMentionedMe ?? [],
                haveMorePreviousData: _haveMorePreviousData,
                groupID: widget.groupID,
                userID: widget.userID,
                topicID: widget.topicID,
                unreadCount: _conversation?.unreadCount,
                c2cReadTimestamp: _conversation?.c2cReadTimestamp,
                groupReadSequence: _conversation?.groupReadSequence,
                haveMoreLatestData: _haveMoreLatestData,
              ),
            ) ??
        Container();
  }
}
