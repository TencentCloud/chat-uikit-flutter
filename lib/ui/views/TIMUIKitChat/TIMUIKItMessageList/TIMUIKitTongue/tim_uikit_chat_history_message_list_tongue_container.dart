import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/common_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/TIMUIKitTongue/tim_uikit_chat_history_message_list_tongue.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tuple/tuple.dart';

class TIMUIKitHistoryMessageListTongueContainer extends StatefulWidget {
  final Widget Function(void Function(), MessageListTongueType, int)? tongueItemBuilder;
  final List<V2TimGroupAtInfo?>? groupAtInfoList;
  final Function(String targetSeq) scrollToIndexBySeq;
  final AutoScrollController scrollController;
  final TUIChatSeparateViewModel model;
  final V2TimConversation conversation;

  const TIMUIKitHistoryMessageListTongueContainer({
    Key? key,
    this.tongueItemBuilder,
    this.groupAtInfoList,
    required this.conversation,
    required this.scrollToIndexBySeq,
    required this.scrollController,
    required this.model,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitHistoryMessageListTongueContainerState();
}

class _TIMUIKitHistoryMessageListTongueContainerState extends TIMUIKitState<TIMUIKitHistoryMessageListTongueContainer> {
  bool isFinishJumpToAt = false;
  List<V2TimGroupAtInfo?>? groupAtInfoList = [];
  final TUIChatGlobalModel globalModel = serviceLocator<TUIChatGlobalModel>();
  bool isClickShowPrevious = false;

  @override
  void initState() {
    super.initState();
    initScrollListener();
    groupAtInfoList = widget.groupAtInfoList?.reversed.toList();
  }

  void changePositionState(HistoryMessagePosition newPosition) {
    if (globalModel.getMessageListPosition(widget.model.conversationID) != newPosition) {
      globalModel.setMessageListPosition(widget.model.conversationID, newPosition);
    }
  }

  scrollHandler() {
    final screenHeight = MediaQuery.of(context).size.height;
    final offset = widget.scrollController.offset;
    final conversationUnreadCount = widget.model.getConversationUnreadCount();
    if (offset <= 0.0 && conversationUnreadCount != 0) {
      widget.model.showLatestUnread();
    }
    if (widget.scrollController.offset <= widget.scrollController.position.minScrollExtent && !widget.scrollController.position.outOfRange && !widget.model.haveMoreLatestData) {
      changePositionState(HistoryMessagePosition.bottom);
    } else if (widget.scrollController.offset <= screenHeight * 1.6 && widget.scrollController.offset > 0 && !widget.scrollController.position.outOfRange && !widget.model.haveMoreLatestData) {
      changePositionState(HistoryMessagePosition.inTwoScreen);
    } else if (widget.scrollController.offset > screenHeight * 1.6 && !widget.scrollController.position.outOfRange && !widget.model.haveMoreLatestData) {
      changePositionState(HistoryMessagePosition.awayTwoScreen);
    }
  }

  void initScrollListener() {
    widget.scrollController.addListener(scrollHandler);
  }

  MessageListTongueType _getTongueValueType(List<V2TimGroupAtInfo?>? groupAtInfoList) {
    if (globalModel.getMessageListPosition(widget.model.conversationID) == HistoryMessagePosition.notShowLatest) {
      return MessageListTongueType.none;
    }
    if (groupAtInfoList != null && groupAtInfoList.isNotEmpty && !isFinishJumpToAt) {
      if (groupAtInfoList[0]!.atType == 1) {
        return MessageListTongueType.atMe;
      } else {
        return MessageListTongueType.atAll;
      }
    }

    if ((widget.conversation.unreadCount ?? 0) > 20 && !isClickShowPrevious) {
      return MessageListTongueType.showPrevious;
    }

    if (globalModel.unreadCountForConversation > 0) {
      return MessageListTongueType.showUnread;
    }

    if (globalModel.getMessageListPosition(widget.model.conversationID) == HistoryMessagePosition.awayTwoScreen) {
      return MessageListTongueType.toLatest;
    }

    return MessageListTongueType.none;
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(scrollHandler);
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return Selector<TUIChatGlobalModel, Tuple2<HistoryMessagePosition, int>>(
      builder: (context, value, child) {
        return Positioned(
          bottom: _getTongueValueType(groupAtInfoList) != MessageListTongueType.showPrevious ? 16 : null,
          top: _getTongueValueType(groupAtInfoList) == MessageListTongueType.showPrevious ? 16 : null,
          right: 16,
          child: TIMUIKitHistoryMessageListTongue(
            previousCount: widget.conversation.unreadCount ?? 0,
            tongueItemBuilder: widget.tongueItemBuilder,
            unreadCount: globalModel.unreadCountForConversation,
            onClick: () async {
              if (groupAtInfoList != null && groupAtInfoList!.isNotEmpty) {
                if (groupAtInfoList?.length == 1) {
                  widget.scrollToIndexBySeq(groupAtInfoList![0]!.seq);
                  widget.model.markMessageAsRead();
                  setState(() {
                    groupAtInfoList = [];
                    isFinishJumpToAt = true;
                  });
                } else {
                  widget.scrollToIndexBySeq(groupAtInfoList!.removeAt(0)!.seq);
                }
              } else if ((widget.conversation.unreadCount ?? 0) > 20 && !isClickShowPrevious) {
                try {
                  isClickShowPrevious = true;
                  final String? lastSeqString = widget.conversation.lastMessage?.seq;
                  final int? lastSeq = TencentUtils.checkString(lastSeqString) != null ? int.parse(lastSeqString!) : null;
                  final int? previousCount = widget.conversation.unreadCount;
                  if (lastSeq != null && previousCount != null) {
                    final targetSeq = lastSeq - previousCount;
                    await widget.model.loadListForSpecificMessage(seq: targetSeq);
                    // Future.delayed(const Duration(milliseconds: 100), () {
                    //   widget.scrollToIndexBySeq((targetSeq).toString());
                    // });
                  }
                } catch (e) {
                  // TODO: 这里后续加个弹窗提示客户，找消息失败了
                }
                // widget.model.loadListForSpecificMessage(seq: count);
              } else if (value.item1 == HistoryMessagePosition.awayTwoScreen || globalModel.unreadCountForConversation > 0) {
                widget.model.showLatestUnread();
                widget.scrollController.animateTo(
                  widget.scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                );
                return;
              }
            },
            atNum: groupAtInfoList?.length.toString() ?? "",
            valueType: _getTongueValueType(groupAtInfoList),
          ),
        );
      },
      selector: (c, model) {
        final mesageListPosition = model.getMessageListPosition(widget.model.conversationID);
        final unreadCountForConversation = model.unreadCountForConversation;
        return Tuple2(mesageListPosition, unreadCountForConversation);
      },
    );
  }
}
