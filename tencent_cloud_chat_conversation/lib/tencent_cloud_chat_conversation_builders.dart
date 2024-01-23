import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_item.dart';

/// When ConversationItemAvatarBuilder returns the widget, the widget will be used for rendering. When the return value is null, the UIKit default component will be used for rendering.
typedef ConversationItemAvatarBuilder = Widget? Function(
    V2TimConversation conversation, bool isOnline);

/// When ConversationItemContentBuilder returns the widget, the widget will be used for rendering. When the return value is null, the UIKit default component will be used for rendering.
typedef ConversationItemContentBuilder = Widget? Function(
    V2TimConversation conversation);

/// When ConversationItemInfoBuilder returns the widget, the widget will be used for rendering. When the return value is null, the UIKit default component will be used for rendering.
typedef ConversationItemInfoBuilder = Widget? Function(
    V2TimConversation conversation);

class TencentCloudChatConversationBuilders {
  static ConversationItemAvatarBuilder? _conversationItemAvatarBuilder;
  static ConversationItemContentBuilder? _conversationItemContentBuilder;
  static ConversationItemInfoBuilder? _conversationItemInfoBuilder;

  TencentCloudChatConversationBuilders({
    ConversationItemAvatarBuilder? conversationItemAvatarBuilder,
    ConversationItemContentBuilder? conversationItemContentBuilder,
    ConversationItemInfoBuilder? conversationItemInfoBuilder,
  }) {
    _conversationItemAvatarBuilder = conversationItemAvatarBuilder;
    _conversationItemContentBuilder = conversationItemContentBuilder;
    _conversationItemInfoBuilder = conversationItemInfoBuilder;
  }

  static Widget getConversationItemAvatarBuilder(
      V2TimConversation conversation, bool isOnline) {
    Widget? widget;

    if (_conversationItemAvatarBuilder != null) {
      widget = _conversationItemAvatarBuilder!(conversation, isOnline);
    }

    return widget ??
        TencentCloudChatConversationItemAvatar(
          conversation: conversation,
          isOnline: isOnline,
        );
  }

  static Widget getConversationItemContentBuilder(
      V2TimConversation conversation) {
    Widget? widget;

    if (_conversationItemContentBuilder != null) {
      widget = _conversationItemContentBuilder!(conversation);
    }
    return widget ??
        TencentCloudChatConversationItemContent(
          conversation: conversation,
        );
  }

  static Widget getConversationItemInfoBuilder(V2TimConversation conversation) {
    Widget? widget;

    if (_conversationItemInfoBuilder != null) {
      widget = _conversationItemInfoBuilder!(conversation);
    }
    return widget ??
        TencentCloudChatConversationItemInfo(
          conversation: conversation,
        );
  }
}
