import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_list/message_list.dart';

class MessageListController {
  MessageListState? stateObj;

  notifyNewMessageComing(String firstKey, int newMsgCount) {
    stateObj?.notifyNewMessageComing(firstKey, newMsgCount);
  }

  jumpToIndex(int index) {
    stateObj?.listViewController.sliverController.jumpToIndex(index);
  }

  Future<void> animateToIndex(
    int index, {
    required Duration duration,
    required Curve curve,
    double offset = 0,
    bool offsetBasedOnBottom = false,
  }) async {
    stateObj?.listViewController.sliverController.animateToIndex(index,
        duration: duration,
        curve: curve,
        offset: offset,
        offsetBasedOnBottom: offsetBasedOnBottom);
  }

  mount(MessageListState state) {
    stateObj = state;
  }

  scrollToBottom() {
    stateObj?.scrollToLatestMessage();
  }
}
