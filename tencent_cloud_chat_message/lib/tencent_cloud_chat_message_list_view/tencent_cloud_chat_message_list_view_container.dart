import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';

class TencentCloudChatMessageListViewContainer extends StatefulWidget {
  final String? userID;
  final String? groupID;
  final String? topicID;
  final V2TimMessage? targetMessage;
  const TencentCloudChatMessageListViewContainer({super.key, this.userID, this.groupID, this.topicID, this.targetMessage}) : assert((userID == null) != (groupID == null));

  @override
  State<TencentCloudChatMessageListViewContainer> createState() => _TencentCloudChatMessageListViewContainerState();
}

class _TencentCloudChatMessageListViewContainerState extends TencentCloudChatState<TencentCloudChatMessageListViewContainer> {
  List<V2TimMessage> _messageList = [];
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
    final isCurrentConversation = (updateUserID != null && (updateUserID == widget.userID)) || (updateGroupID != null && (updateGroupID == (TencentCloudChatUtils.checkString(widget.topicID) ?? widget.groupID)));
    TencentCloudChat.instance.logInstance.console(
        componentName: 'TencentCloudChatMessageListViewContainer',
        logs:
        "_messageDataHandler -- isCurrentConversation: ${isCurrentConversation}  --updateUserID: ${updateUserID} -- updateGroupID: ${updateGroupID} -- widget.topicID: ${TencentCloudChatUtils.checkString(widget.topicID)} -- widget.groupID: ${widget.groupID} -- widget.userID: ${widget.userID} -- messageDataKeys: ${messageDataKeys}");

    switch (messageDataKeys) {
      case TencentCloudChatMessageDataKeys.messageHighlighted:
        break;
      case TencentCloudChatMessageDataKeys.messageNeedUpdate:
        final messageNeedUpdate = messageData.messageNeedUpdate!;
        int index = _messageList.indexWhere((element) => TencentCloudChatUtils.checkString(element.msgID) != null && element.msgID == messageNeedUpdate.msgID);
        if (index == -1 && TencentCloudChatUtils.checkString(messageNeedUpdate.id) != null && messageNeedUpdate.id != messageNeedUpdate.msgID) {
          index = _messageList.indexWhere((element) => element.id == messageNeedUpdate.id);
        }

        if (index > -1) {
          safeSetState(() {
            _messageList[index] = messageNeedUpdate;
          });
        }
        break;
      case TencentCloudChatMessageDataKeys.none:
        break;
      case TencentCloudChatMessageDataKeys.messageReadReceipts:
        break;
      case TencentCloudChatMessageDataKeys.messageList:
        if (isCurrentConversation) {
          var previousList = _messageList;
          var nextList = dataProvider.getMessageListForRender(
            messageListKey: TencentCloudChatUtils.checkString(widget.topicID) ?? TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
          );
          if (!TencentCloudChatUtils.deepEqual(previousList, nextList)) {
            safeSetState(() {
              _messageList = nextList;
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
      _loadInitMessageList();
    });
  }

  void _loadInitMessageList(){
    _messageList.clear();
    safeSetState(() {
      _messageList = dataProvider.getMessageListForRender(
        messageListKey: TencentCloudChatUtils.checkString(widget.topicID) ?? TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
      );
      _haveMoreLatestData = dataProvider.haveMoreLatestData;
      _haveMorePreviousData = dataProvider.haveMorePreviousData;
    });
    if(widget.targetMessage != null ){
      Future.delayed(const Duration(microseconds: 10), (){
        dataProvider.loadToSpecificMessage(
          message: widget.targetMessage,
        );
      });
    }else{
      Future.delayed(const Duration(milliseconds: 10), () {
        dataProvider.loadMessageList(
          groupID: widget.groupID,
          userID: widget.userID,
          topicID: widget.topicID,
          direction: TencentCloudChatMessageLoadDirection.previous,
        );
      });
    }
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
      _messageDataSubscription?.cancel();
      _messageDataSubscription = _messageDataStream?.listen(_messageDataHandler);
    }
    if ((widget.userID != oldWidget.userID && !(TencentCloudChatUtils.checkString(widget.userID) == null && TencentCloudChatUtils.checkString(oldWidget.userID) == null)) ||
        (widget.groupID != oldWidget.groupID && !(TencentCloudChatUtils.checkString(widget.groupID) == null && TencentCloudChatUtils.checkString(oldWidget.groupID) == null)) ||
          (widget.topicID != oldWidget.topicID && !(TencentCloudChatUtils.checkString(widget.topicID) == null && TencentCloudChatUtils.checkString(oldWidget.topicID) == null))) {
      _loadInitMessageList();
    }

    if(widget.targetMessage != null && widget.targetMessage != oldWidget.targetMessage){
      Future.delayed(const Duration(microseconds: 10), (){
        dataProvider.loadToSpecificMessage(
          message: widget.targetMessage,
        );
      });
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
    final lastMsgSeq = direction == TencentCloudChatMessageLoadDirection.previous ? actualMessageList.last.seq : actualMessageList.first.seq;
    return dataProvider.loadMessageList(
      groupID: widget.groupID,
      userID: widget.userID,
      topicID: widget.topicID,
      direction: direction,
      lastMsgID: lastMsgID,
      lastMsgSeq: (TencentCloudChatPlatformAdapter().isWeb && TencentCloudChatUtils.checkString(widget.groupID) != null && direction == TencentCloudChatMessageLoadDirection.latest) ? int.parse(lastMsgSeq ?? "-1") : null,
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
                closeSticker: closeSticker,
              ),
              data: MessageListViewBuilderData(
                messageList: _messageList,
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
