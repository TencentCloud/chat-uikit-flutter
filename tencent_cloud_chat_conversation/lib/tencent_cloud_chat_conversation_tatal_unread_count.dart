import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';

/// Returns a widget for conversation total unread message count
typedef TencentCloudChatConversationTotalUnreadCountWrapperBuilder = Widget Function(BuildContext context, int totalUnreadCount);

class TencentCloudChatConversationTotalUnreadCount extends StatefulWidget {
  final TencentCloudChatConversationTotalUnreadCountWrapperBuilder builder;
  const TencentCloudChatConversationTotalUnreadCount({
    super.key,
    required this.builder,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatConversationTotalUnreadCountState();
}

class TencentCloudChatConversationTotalUnreadCountState extends TencentCloudChatState<TencentCloudChatConversationTotalUnreadCount> {
  final Stream<TencentCloudChatConversationData<dynamic>>? _conversationDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatConversationData<dynamic>>("TencentCloudChatConversationData");

  /// get conversation total unread count from TencentCloudChatData
  int totalUnreadCount = TencentCloudChat.instance.dataInstance.conversation.totalUnreadCount;

  late StreamSubscription<TencentCloudChatConversationData<dynamic>>? _conversationDataSubscription;
  final String _tag = "TencentCloudChatConversationTotalUnreadCount";
  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: json.encode(
        {
          "log": log,
        },
      ),
    );
  }

  /// if current conversation total unread count updated, update totalUnreadCount
  conversationDataHandler(TencentCloudChatConversationData data) {
    if (data.currentUpdatedFields == TencentCloudChatConversationDataKeys.totalUnreadCount) {
      console("conversation total unread count change, current is ${data.totalUnreadCount}");
      safeSetState(() {
        totalUnreadCount = data.totalUnreadCount;
      });
    }
  }

  _addConversationDataListener() {
    _conversationDataSubscription = _conversationDataStream?.listen(conversationDataHandler);
  }

  @override
  void dispose() {
    super.dispose();
    _conversationDataSubscription?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _addConversationDataListener();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return widget.builder(
      context,
      totalUnreadCount,
    );
  }
}
