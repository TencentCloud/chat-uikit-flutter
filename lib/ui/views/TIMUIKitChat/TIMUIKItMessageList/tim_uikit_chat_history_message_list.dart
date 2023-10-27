import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/logger.dart';
// ignore: unused_import
import 'package:tencent_cloud_chat_uikit/ui/utils/optimize_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list_config.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/keepalive_wrapper.dart';

import 'TIMUIKitTongue/tim_uikit_chat_history_message_list_tongue.dart';
import 'TIMUIKitTongue/tim_uikit_chat_history_message_list_tongue_container.dart';

enum LoadingPlace {
  none,
  top,
  bottom,
}

enum ScrollType { toIndex, toIndexBegin }

class TIMUIKitHistoryMessageListController extends ChangeNotifier {
  AutoScrollController? scrollController = AutoScrollController();
  late ScrollType scrollType;
  late V2TimMessage targetMessage;

  TIMUIKitHistoryMessageListController({
    AutoScrollController? scrollController,
  }) {
    if (scrollController != null) {
      this.scrollController = scrollController;
    }
  }

  scrollToIndex(V2TimMessage message) {
    scrollType = ScrollType.toIndex;
    targetMessage = message;
    notifyListeners();
  }

  scrollToIndexBegin(V2TimMessage message) {
    scrollType = ScrollType.toIndexBegin;
    targetMessage = message;
    notifyListeners();
  }
}

class TIMUIKitHistoryMessageList extends StatefulWidget {
  /// message list
  final List<V2TimMessage?> messageList;

  /// tongue item builder
  final TongueItemBuilder? tongueItemBuilder;

  /// group at info, it can get from conversation info
  final List<V2TimGroupAtInfo?>? groupAtInfoList;

  /// use for build message item
  final Widget Function(BuildContext, V2TimMessage?)? itemBuilder;

  /// can controll message list scroll
  final TIMUIKitHistoryMessageListController? controller;

  /// use for message jump, if passed will jump to target message.
  final V2TimMessage? initFindingMsg;

  /// use for load more message
  final Future<void> Function(String?, LoadDirection direction, [int?]) onLoadMore;

  /// configuration for list view
  final TIMUIKitHistoryMessageListConfig? mainHistoryListConfig;

  final TUIChatSeparateViewModel model;

  final bool isAllowScroll;

  final V2TimConversation conversation;

  const TIMUIKitHistoryMessageList(
      {Key? key,
      required this.model,
      required this.messageList,
      this.itemBuilder,
      this.controller,
      required this.onLoadMore,
      this.tongueItemBuilder,
      this.groupAtInfoList,
      this.initFindingMsg,
      this.isAllowScroll = true,
      this.mainHistoryListConfig,
      required this.conversation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitHistoryMessageListState();
}

class _TIMUIKitHistoryMessageListState extends TIMUIKitState<TIMUIKitHistoryMessageList> {
  V2TimMessage? findingMsg;
  String findingSeq = "";
  late TIMUIKitHistoryMessageListController _controller;
  late AutoScrollController _autoScrollController;
  LoadingPlace loadingPlace = LoadingPlace.none;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TIMUIKitHistoryMessageListController();
    _autoScrollController = _controller.scrollController ?? AutoScrollController();
    _controller.addListener(_controllerListener);
    initFinding();
  }

  initFinding() async {
    if (widget.initFindingMsg != null) {
      await widget.onLoadMore(null, LoadDirection.previous);
      setState(() {
        findingMsg = widget.initFindingMsg!;
      });
    }
  }

  _controllerListener() {
    final scrollType = _controller.scrollType;
    final targetMessage = _controller.targetMessage;
    switch (scrollType) {
      case ScrollType.toIndex:
        _onScrollToIndex(targetMessage);
        break;
      case ScrollType.toIndexBegin:
        _onScrollToIndexBegin(targetMessage);
        break;
      default:
    }
  }

  Widget _getMessageItemBuilder(V2TimMessage? messageItem) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, messageItem);
    }
    return Container();
  }

  _getMessageId(int index) {
    if (widget.messageList[index]!.elemType == 11) {
      return _getMessageId(index - 1);
    }
    return widget.messageList[index]!.msgID;
  }

  void showCantFindMsg() {
    findingMsg = null;
    findingSeq = "";
    loadingPlace = LoadingPlace.none;
    onTIMCallback(TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("无法定位到原消息"), infoCode: 6660401));
  }

  _onScrollToIndex(V2TimMessage targetMsg) {
    // This method called by @ messages or messages been searched, aims to jump to target message
    loadingPlace = LoadingPlace.top;
    const int singleLoadAmount = kIsWeb ? 15 : 40;
    final lastTimestamp = widget.messageList[widget.messageList.length - 1]?.timestamp;
    final msgList = widget.messageList;
    final targetTimeStamp = targetMsg.timestamp!;

    if (targetTimeStamp >= lastTimestamp!) {
      // 当前列表里应该有这个消息，试试能不能直接定位到那去
      bool isFound = false;
      int targetIndex = 1;
      for (int i = msgList.length - 1; i >= 0; i--) {
        final currentMsg = msgList[i];
        if (currentMsg?.timestamp == targetTimeStamp && currentMsg?.elemType != 11 && currentMsg!.msgID == targetMsg.msgID) {
          // find the target index by timestamp and msgID
          isFound = true;
          targetIndex = -i;
          break;
        }
      }

      if (isFound && targetIndex != 1) {
        findingMsg = null;
        _autoScrollController.scrollToIndex(
          targetIndex,
          preferPosition: AutoScrollPosition.middle,
        );

        // execute twice for accurate position, as the position located firstly can be wrong
        _autoScrollController.scrollToIndex(targetIndex, preferPosition: AutoScrollPosition.middle);
        _autoScrollController.scrollToIndex(targetIndex, preferPosition: AutoScrollPosition.middle);

        widget.model.jumpMsgID = targetMsg.msgID!;
        loadingPlace = LoadingPlace.none;
      } else {
        showCantFindMsg();
      }
    } else {
      if (widget.model.haveMoreData) {
        // if the target message not in current message list, load more
        findingMsg = targetMsg;
        final lastMsgId = _getMessageId(widget.messageList.length - 1);
        widget.onLoadMore(lastMsgId, LoadDirection.previous, singleLoadAmount);
      } else {
        showCantFindMsg();
      }
    }
  }

  _onScrollToIndexBySeq(String targetSeq) {
    // This method called by tongue request jumping to target @ message
    loadingPlace = LoadingPlace.top;
    const int singleLoadAmount = 40;
    final msgList = widget.messageList;
    String lastSeq = "";
    for (int i = msgList.length - 1; i >= 0; i--) {
      final currentMsg = msgList[i];
      if (currentMsg!.seq != null && currentMsg.seq != "") {
        lastSeq = currentMsg.seq!;
        break;
      }
    }

    if (int.parse(lastSeq) <= int.parse(targetSeq)) {
      bool isFound = false;
      int targetIndex = 1;
      String? targetMsgID = "";
      for (int i = msgList.length - 1; i >= 0; i--) {
        final currentMsg = msgList[i];
        if (currentMsg?.seq == targetSeq) {
          isFound = true;
          targetMsgID = currentMsg?.msgID;
          targetIndex = -i;
          break;
        }
      }

      if (isFound && targetIndex != 1) {
        findingSeq = "";
        _autoScrollController.scrollToIndex(
          targetIndex,
          preferPosition: AutoScrollPosition.middle,
        );
        _autoScrollController.scrollToIndex(targetIndex, preferPosition: AutoScrollPosition.middle);
        if (targetMsgID != null && targetMsgID != "") {
          widget.model.jumpMsgID = targetMsgID;
        }
        loadingPlace = LoadingPlace.none;
      } else {
        showCantFindMsg();
      }
    } else {
      if (widget.model.haveMoreData) {
        findingSeq = targetSeq;
        widget.onLoadMore(_getMessageId(widget.messageList.length - 1), LoadDirection.previous, singleLoadAmount);
      } else {
        showCantFindMsg();
      }
    }
  }

  _onScrollToIndexBegin(V2TimMessage targetMsg) {
    final lastTimestamp = widget.messageList[widget.messageList.length - 1]?.timestamp;
    final msgList = widget.messageList;
    final int targetTimeStamp = targetMsg.timestamp!;

    if (targetTimeStamp >= lastTimestamp!) {
      bool isFound = false;
      int targetIndex = 1;
      for (int i = msgList.length - 1; i >= 0; i--) {
        final currentMsg = msgList[i];
        if (currentMsg?.timestamp == targetTimeStamp && currentMsg?.elemType != 11 && currentMsg!.msgID == targetMsg.msgID) {
          isFound = true;
          targetIndex = -i;
          break;
        }
      }
      if (isFound && targetIndex != 1) {
        _autoScrollController.scrollToIndex(
          targetIndex,
          preferPosition: AutoScrollPosition.end,
        );
      }
    }
  }

  List<V2TimMessage?> _getReceivedMessageList(int receivedMessageListCount) {
    if (receivedMessageListCount == 0) {
      return [];
    }
    final haveTimeStampMessage = widget.messageList[receivedMessageListCount]?.elemType == 11;
    final endPoint = haveTimeStampMessage ? receivedMessageListCount + 1 : receivedMessageListCount;
    return widget.messageList.sublist(0, endPoint).reversed.toList();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    // center key should generate everytime when build method called.
    final GlobalKey centerKey = GlobalKey();

    final theme = value.theme;
    if (widget.messageList.isEmpty) {
      return Container();
    }

    final messageList = widget.messageList;
    final globalModel = context.read<TUIChatGlobalModel>();
    final receivedNewMessageList = globalModel.receivedMessageListCount;
    final shouldShowUnreadMessage = receivedNewMessageList > 0;
    final unreadMessageList = _getReceivedMessageList(receivedNewMessageList);
    final readMessageList = messageList.sublist(unreadMessageList.length, messageList.length).toList();

    final throttleFunction = OptimizeUtils.multiThrottle((index, LoadDirection direction) async {
      final msgID = TIMUIKitChatUtils.getMessageIDWithinIndex(readMessageList, index);
      await widget.onLoadMore(msgID, direction);
    }, 20);

    final throttleFunctionWithMsgID = OptimizeUtils.multiThrottle((msgID, LoadDirection direction) async {
      await widget.onLoadMore(msgID, direction);
    }, 200);

    if (findingMsg != null) {
      _onScrollToIndex(findingMsg!);
    } else if (findingSeq != "") {
      _onScrollToIndexBySeq(findingSeq);
    }

    String getMessageIdentifier(V2TimMessage? message, int index) {
      return "${message?.msgID} - ${message?.timestamp} - ${message?.seq} -${message?.id}";
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scrollbar(
            controller: _autoScrollController,
            child: CustomScrollView(
              center: shouldShowUnreadMessage ? centerKey : null,
              key: widget.mainHistoryListConfig?.key,
              primary: widget.mainHistoryListConfig?.primary,
              physics: (widget.isAllowScroll == false) ? const NeverScrollableScrollPhysics() : widget.mainHistoryListConfig?.physics,
              // padding: widget.mainHistoryListConfig?.padding ?? EdgeInsets.zero,
              // itemExtent: widget.mainHistoryListConfig?.itemExtent,
              // prototypeItem: widget.mainHistoryListConfig?.prototypeItem,
              cacheExtent: widget.mainHistoryListConfig?.cacheExtent ?? 1500,
              semanticChildCount: widget.mainHistoryListConfig?.semanticChildCount,
              dragStartBehavior: widget.mainHistoryListConfig?.dragStartBehavior ?? DragStartBehavior.start,
              keyboardDismissBehavior: widget.mainHistoryListConfig?.keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
              restorationId: widget.mainHistoryListConfig?.restorationId,
              clipBehavior: widget.mainHistoryListConfig?.clipBehavior ?? Clip.hardEdge,
              reverse: true,
              shrinkWrap: !shouldShowUnreadMessage,
              controller: _autoScrollController,
              slivers: [
                SliverPadding(
                  padding: widget.mainHistoryListConfig?.padding ?? EdgeInsets.zero,
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final messageItem = unreadMessageList[index];
                            if (index == unreadMessageList.length - 1 && widget.model.haveMoreLatestData == true) {
                              throttleFunctionWithMsgID(messageItem?.msgID ?? "", LoadDirection.latest);
                            }
                            outputLogger.i("Rendering a unread message: ${getMessageIdentifier(messageItem, 0)}, message Type: ${messageItem?.elemType}");
                            return AutoScrollTag(
                              controller: _autoScrollController,
                              index: -index,
                              key: ValueKey(getMessageIdentifier(messageItem, index)),
                              highlightColor: Colors.black.withOpacity(0.1),
                              child: KeepAliveWrapper(keepAlive: messageItem?.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND, child: Container(child: _getMessageItemBuilder(messageItem))),
                            );
                          },
                          childCount: unreadMessageList.length,
                          findChildIndexCallback: (Key key) {
                            final ValueKey<String> valueKey = key as ValueKey<String>;
                            final String data = valueKey.value;
                            final int index = unreadMessageList.indexWhere((element) => getMessageIdentifier(element, 0) == data);
                            return index != -1 ? index : null;
                          })),
                ),
                SliverPadding(
                  padding: EdgeInsets.zero,
                  key: centerKey,
                ),
                SliverPadding(
                  padding: widget.mainHistoryListConfig?.padding ?? EdgeInsets.zero,
                  sliver: Selector<TUIChatSeparateViewModel, bool>(
                    selector: (context, model) {
                      return model.haveMoreData;
                    },
                    shouldRebuild: (previous, next) {
                      return previous != next;
                    },
                    builder: (context, haveMoreData, child) {
                      return SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final messageItem = readMessageList[index];
                                if (index == readMessageList.length - 1) {
                                  if (haveMoreData) {
                                    final lastMessage = globalModel.messageListMap[TencentUtils.checkString(widget.conversation.groupID) ?? widget.conversation.userID ?? widget.conversation.conversationID]?.last;
                                    if(lastMessage != null){
                                      throttleFunctionWithMsgID(lastMessage.msgID ?? "", LoadDirection.previous);
                                    }else{
                                      throttleFunction(index, messageList);
                                    }
                                    return Column(
                                      children: [
                                        LoadingAnimationWidget.staggeredDotsWave(
                                          color: theme.weakTextColor ?? Colors.grey,
                                          size: 28,
                                        ),
                                        AutoScrollTag(
                                          controller: _autoScrollController,
                                          index: -index,
                                          key: ValueKey(getMessageIdentifier(messageItem, index)),
                                          highlightColor: Colors.black.withOpacity(0.1),
                                          child: KeepAliveWrapper(keepAlive: messageItem?.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND, child: Container(child: _getMessageItemBuilder(messageItem))),
                                        ),
                                      ],
                                    );
                                  }
                                }
                                if (index == 0 && widget.model.haveMoreLatestData == true && globalModel.receivedMessageListCount < 10) {
                                  throttleFunction(index, LoadDirection.latest);
                                }
                                outputLogger.i("Rendering a read message: ${getMessageIdentifier(messageItem, 0)}, message Type: ${messageItem?.elemType}");
                                return AutoScrollTag(
                                  controller: _autoScrollController,
                                  index: -index,
                                  key: ValueKey(getMessageIdentifier(messageItem, index)),
                                  highlightColor: Colors.black.withOpacity(0.1),
                                  child: KeepAliveWrapper(keepAlive: messageItem?.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND, child: Container(child: _getMessageItemBuilder(messageItem))),
                                );
                              },
                              childCount: readMessageList.length,
                              findChildIndexCallback: (Key key) {
                                final ValueKey<String> valueKey = key as ValueKey<String>;
                                final String data = valueKey.value;
                                final int index = readMessageList.indexWhere((element) => getMessageIdentifier(element, 0) == data);
                                return index > -1 ? index : null;
                              }));
                    },
                  ),
                ),
              ],
            )),
        TIMUIKitHistoryMessageListTongueContainer(
          conversation: widget.conversation,
          model: widget.model,
          scrollController: _autoScrollController,
          scrollToIndexBySeq: _onScrollToIndexBySeq,
          groupAtInfoList: widget.groupAtInfoList,
          tongueItemBuilder: widget.tongueItemBuilder,
        ),
        if (loadingPlace == LoadingPlace.top)
          Positioned(
            top: 8,
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: theme.weakTextColor ?? Colors.grey,
              size: 28,
            ),
          ),
      ],
    );
  }
}

class TIMUIKitHistoryMessageListSelector extends TIMUIKitStatelessWidget {
  final Widget Function(BuildContext, List<V2TimMessage?>, Widget?) builder;
  final String conversationID;

  TIMUIKitHistoryMessageListSelector({Key? key, required this.builder, required this.conversationID}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return Selector<TUIChatGlobalModel, List<V2TimMessage?>>(
        builder: builder,
        shouldRebuild: (previous, next) {
          final isEquals = const DeepCollectionEquality.unordered().equals(previous, next);
          return !isEquals;
        },
        selector: (context, model) {
          final messageList = model.getMessageList(conversationID) ?? [];
          return messageList;
        });
  }
}
