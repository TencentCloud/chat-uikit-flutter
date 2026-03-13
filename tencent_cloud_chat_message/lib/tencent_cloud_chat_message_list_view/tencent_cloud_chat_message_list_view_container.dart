import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/log/tencent_cloud_chat_log.dart';
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

  /// After loading to this target message we skip further loadToSpecificMessage for the same msgID so the highlight only runs once and stops after a few blinks.
  String? _loadedTargetMsgID;

  // This method handles changes in message data.
  void _messageDataHandler(TencentCloudChatMessageData messageData) {
    if (!mounted) return;
    final TencentCloudChatMessageDataKeys messageDataKeys = messageData.currentUpdatedFields;
    final updateUserID = TencentCloudChatUtils.checkString(messageData.currentOperateUserID);
    final updateGroupID = TencentCloudChatUtils.checkString(messageData.currentOperateGroupID);
    // For C2C messages, check if updateUserID matches widget.userID
    // For group messages, check if updateGroupID matches widget.groupID or widget.topicID
    // Also handle case where updateUserID/updateGroupID is null but widget.userID/widget.groupID is set (for current conversation)
    final isCurrentConversation = (updateUserID != null && (updateUserID == widget.userID)) || 
                                  (updateGroupID != null && (updateGroupID == (TencentCloudChatUtils.checkString(widget.topicID) ?? widget.groupID))) ||
                                  (updateUserID == null && updateGroupID == null && widget.userID != null && widget.groupID == null); // If no userID/groupID specified, assume it's for current conversation if widget.userID is set

    switch (messageDataKeys) {
      case TencentCloudChatMessageDataKeys.messageHighlighted:
        break;
      case TencentCloudChatMessageDataKeys.messageNeedUpdate:
        // Only update if this is the current conversation
        if (isCurrentConversation) {
          final messageNeedUpdate = messageData.messageNeedUpdate!;
          int index = _messageList.indexWhere((element) => TencentCloudChatUtils.checkString(element.msgID) != null && element.msgID == messageNeedUpdate.msgID);
          if (index == -1 && TencentCloudChatUtils.checkString(messageNeedUpdate.id) != null && messageNeedUpdate.id != messageNeedUpdate.msgID) {
            index = _messageList.indexWhere((element) => element.id == messageNeedUpdate.id);
          }

          if (index > -1) {
            // Store previous list length to detect new messages
            final previousListLength = _messageList.length;
            // Update the message in the list
            safeSetState(() {
              _messageList[index] = messageNeedUpdate;
            });
            // Immediately refresh the entire list from dataProvider to ensure Flutter widget tree is rebuilt
            // This is important for newly added messages where the widget hasn't been created yet
            // OPTIMIZED: getMessageListForRender() already returns properly sorted list (newest-first),
            // so we don't need to sort again here
            var nextList = dataProvider.getMessageListForRender(
              messageListKey: TencentCloudChatUtils.checkString(widget.topicID) ?? TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
            );
            // Ensure the updated message is in the refreshed list
            int refreshedIndex = nextList.indexWhere((element) => 
              (TencentCloudChatUtils.checkString(element.msgID) != null && element.msgID == messageNeedUpdate.msgID) ||
              (TencentCloudChatUtils.checkString(element.id) != null && element.id == messageNeedUpdate.id));
            if (refreshedIndex > -1) {
              nextList[refreshedIndex] = messageNeedUpdate;
            }
            safeSetState(() {
              // Create a new list instance to ensure Flutter detects the change
              // This is important for FlutterListView to detect new items
              _messageList = List<V2TimMessage>.from(nextList);
            });
          } else {
            // Message not found in _messageList - it may have been just added
            // Use addPostFrameCallback to ensure messageList event is processed first
            // This prevents widget tree rebuild conflicts and UI flickering
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              // OPTIMIZED: getMessageListForRender() already returns properly sorted list (newest-first),
              // so we don't need to sort again here
              var nextList = dataProvider.getMessageListForRender(
                messageListKey: TencentCloudChatUtils.checkString(widget.topicID) ?? TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
              );
              // Try to find the message again in the refreshed list
              int refreshedIndex = nextList.indexWhere((element) => 
                (TencentCloudChatUtils.checkString(element.msgID) != null && element.msgID == messageNeedUpdate.msgID) ||
                (TencentCloudChatUtils.checkString(element.id) != null && element.id == messageNeedUpdate.id));
              if (refreshedIndex > -1) {
                // Update the message in the refreshed list
                nextList[refreshedIndex] = messageNeedUpdate;
              }
              safeSetState(() {
                // Create a new list instance to ensure Flutter detects the change
                // This is important for FlutterListView to detect new items
                _messageList = List<V2TimMessage>.from(nextList);
              });
            });
          }
        }
        break;
      case TencentCloudChatMessageDataKeys.none:
        break;
      case TencentCloudChatMessageDataKeys.messageReadReceipts:
        break;
      case TencentCloudChatMessageDataKeys.messageList:
        if (isCurrentConversation) {
          var previousList = _messageList;
          // OPTIMIZED: getMessageListForRender() already returns properly sorted list (newest-first),
          // so we don't need to sort again here
          var nextList = dataProvider.getMessageListForRender(
            messageListKey: TencentCloudChatUtils.checkString(widget.topicID) ?? TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
          );
          // Check if lists are different by comparing length first (faster)
          // Then use deepEqual for content comparison
          // CRITICAL: Always update if length is different, as deepEqual.unordered() might incorrectly
          // think lists are equal when they have different messages but same content
          bool listsAreDifferent = previousList.length != nextList.length;
          if (!listsAreDifferent) {
            // If lengths are same, check content using deepEqual
            listsAreDifferent = !TencentCloudChatUtils.deepEqual(previousList, nextList);
          }
          if (listsAreDifferent) {
            // Only scroll to bottom when the newest message changed (new message or send),
            // not when we only appended older messages (load previous).
            final bool shouldScrollToBottom;
            if (previousList.isEmpty) {
              shouldScrollToBottom = true; // Initial load
            } else if (nextList.isEmpty) {
              shouldScrollToBottom = false;
            } else if (nextList.length > previousList.length) {
              // List grew: scroll only if we did NOT just append older messages (load previous).
              // Compare only real messages (skip time dividers with elemType 101),
              // since time dividers can change position/ID when pagination adds messages.
              bool onlyAppendedOlder = true;
              final previousRealMsgs = previousList.where((m) => m.elemType != 101).toList();
              final nextRealMsgs = nextList.where((m) => m.elemType != 101).toList();
              if (nextRealMsgs.length < previousRealMsgs.length) {
                onlyAppendedOlder = false;
              } else {
                // Check where previousRealMsgs[0] appears in nextRealMsgs.
                // Three scenarios:
                // A) foundIndex == 0: prev[0] is still the newest → simple tail append → onlyAppendedOlder
                // B) foundIndex > 0: new messages were prepended at head → NOT onlyAppendedOlder
                // C) foundIndex == -1: prev[0] was trimmed from head (maxMessageCount exceeded)
                //    → check if prev's oldest msg still exists in next (pagination + head trimming)
                if (previousRealMsgs.isNotEmpty) {
                  final firstPrevMsgID = TencentCloudChatUtils.checkString(previousRealMsgs[0].msgID);
                  if (firstPrevMsgID != null) {
                    final foundIndex = nextRealMsgs.indexWhere((m) =>
                        TencentCloudChatUtils.checkString(m.msgID) == firstPrevMsgID);
                    if (foundIndex > 0) {
                      // Case B: New messages were added at the head (e.g. received new msg)
                      onlyAppendedOlder = false;
                    } else if (foundIndex == -1) {
                      // Case C: Previous newest message was trimmed from head.
                      // Check if this is pagination + head trimming: the previous list's
                      // oldest message should still exist in the next list.
                      final lastPrevMsgID = TencentCloudChatUtils.checkString(
                          previousRealMsgs[previousRealMsgs.length - 1].msgID);
                      if (lastPrevMsgID != null &&
                          nextRealMsgs.any((m) =>
                              TencentCloudChatUtils.checkString(m.msgID) == lastPrevMsgID)) {
                        // Oldest previous message still exists → pagination + head trimming
                        onlyAppendedOlder = true;
                      } else {
                        onlyAppendedOlder = false;
                      }
                    } else {
                      // Case A: foundIndex == 0. Verify remaining messages match.
                      for (int i = 0; i < previousRealMsgs.length && i < nextRealMsgs.length; i++) {
                        if (TencentCloudChatUtils.checkString(nextRealMsgs[i].msgID) !=
                            TencentCloudChatUtils.checkString(previousRealMsgs[i].msgID)) {
                          onlyAppendedOlder = false;
                          break;
                        }
                      }
                    }
                  }
                }
              }
              shouldScrollToBottom = !onlyAppendedOlder;
            } else {
              // Same length or shorter: check if this is head trimming from pagination.
              // When maxMessageCount is reached while loading older messages, newest messages
              // are removed and older ones added, resulting in same or shorter length.
              // In that case, the oldest previous message should still exist in next list.
              final previousRealMsgs = previousList.where((m) => m.elemType != 101).toList();
              final nextRealMsgs = nextList.where((m) => m.elemType != 101).toList();
              if (previousRealMsgs.isNotEmpty && nextRealMsgs.isNotEmpty) {
                final lastPrevMsgID = TencentCloudChatUtils.checkString(
                    previousRealMsgs[previousRealMsgs.length - 1].msgID);
                final lastNextMsgID = TencentCloudChatUtils.checkString(
                    nextRealMsgs[nextRealMsgs.length - 1].msgID);
                if (lastPrevMsgID != null && lastNextMsgID != null && lastPrevMsgID != lastNextMsgID) {
                  // Oldest message changed → older messages were added (pagination + trimming)
                  // Check if previous oldest msg still exists in next list
                  final prevOldestInNext = nextRealMsgs.any((m) =>
                      TencentCloudChatUtils.checkString(m.msgID) == lastPrevMsgID);
                  if (prevOldestInNext) {
                    shouldScrollToBottom = false; // Pagination with head trimming
                  } else {
                    shouldScrollToBottom = true; // Content truly changed
                  }
                } else {
                  shouldScrollToBottom = true; // Content changed (e.g. new message replaced old)
                }
              } else {
                shouldScrollToBottom = true;
              }
            }
            safeSetState(() {
              // Create a new list instance to ensure Flutter detects the change
              // This is important for FlutterListView to detect new items
              _messageList = List<V2TimMessage>.from(nextList);
              _haveMoreLatestData = dataProvider.haveMoreLatestData;
              _haveMorePreviousData = dataProvider.haveMorePreviousData;
            });
            if (shouldScrollToBottom) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                try {
                  dataProvider.messageController.scrollToBottom(
                    userID: dataProvider.userID,
                    groupID: dataProvider.groupID,
                    topicID: dataProvider.topicID,
                  );
                } catch (e, stackTrace) {
                  // Silently handle scroll errors
                }
              });
            }
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
      // OPTIMIZED: getMessageListForRender() already returns properly sorted list (newest-first),
      // so we don't need to sort again here
      var nextList = dataProvider.getMessageListForRender(
        messageListKey: TencentCloudChatUtils.checkString(widget.topicID) ?? TencentCloudChatUtils.checkString(widget.groupID) ?? widget.userID,
      );
      _messageList = nextList;
      _haveMoreLatestData = dataProvider.haveMoreLatestData;
      _haveMorePreviousData = dataProvider.haveMorePreviousData;
    });
    if (widget.targetMessage != null) {
      final msgID = TencentCloudChatUtils.checkString(widget.targetMessage!.msgID);
      if (msgID != null && msgID != _loadedTargetMsgID) {
        _loadedTargetMsgID = msgID;
        Future.delayed(const Duration(microseconds: 10), () {
          dataProvider.loadToSpecificMessage(
            message: widget.targetMessage,
          );
        });
      }
    } else {
      _loadedTargetMsgID = null;
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
      _loadedTargetMsgID = null;
      _loadInitMessageList();
    }

    if (widget.targetMessage != null && widget.targetMessage != oldWidget.targetMessage) {
      final msgID = TencentCloudChatUtils.checkString(widget.targetMessage!.msgID);
      if (msgID != null && msgID != _loadedTargetMsgID) {
        _loadedTargetMsgID = msgID;
        Future.delayed(const Duration(microseconds: 10), () {
          dataProvider.loadToSpecificMessage(
            message: widget.targetMessage,
          );
        });
      }
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
