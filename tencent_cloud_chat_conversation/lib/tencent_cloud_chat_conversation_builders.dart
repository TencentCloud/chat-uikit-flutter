import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_app_bar.dart';
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

typedef ConversationHeaderBuilder = Widget? Function();

class TencentCloudChatConversationBuilders
    extends TencentCloudChatComponentBuilder {
  ConversationItemAvatarBuilder? _conversationItemAvatarBuilder;
  ConversationItemContentBuilder? _conversationItemContentBuilder;
  ConversationItemInfoBuilder? _conversationItemInfoBuilder;
  ConversationHeaderBuilder? _conversationHeaderBuilder;

  TencentCloudChatConversationBuilders({
    ConversationItemAvatarBuilder? conversationItemAvatarBuilder,
    ConversationItemContentBuilder? conversationItemContentBuilder,
    ConversationItemInfoBuilder? conversationItemInfoBuilder,
    ConversationHeaderBuilder? conversationHeaderBuilder,
  }) {
    _conversationItemAvatarBuilder = conversationItemAvatarBuilder;
    _conversationItemContentBuilder = conversationItemContentBuilder;
    _conversationItemInfoBuilder = conversationItemInfoBuilder;
    _conversationHeaderBuilder = conversationHeaderBuilder;
  }

  void setBuilders({
    ConversationItemAvatarBuilder? conversationItemAvatarBuilder,
    ConversationItemContentBuilder? conversationItemContentBuilder,
    ConversationItemInfoBuilder? conversationItemInfoBuilder,
    ConversationHeaderBuilder? conversationHeaderBuilder,
  }) {
    _conversationItemAvatarBuilder = conversationItemAvatarBuilder;
    _conversationItemContentBuilder = conversationItemContentBuilder;
    _conversationItemInfoBuilder = conversationItemInfoBuilder;
    _conversationHeaderBuilder = conversationHeaderBuilder;
    TencentCloudChat.instance.dataInstance.conversation.notifyListener(TencentCloudChatConversationDataKeys.conversationBuilder);
  }

  @override
  (Widget, bool) getConversationHeaderBuilder() {
    Widget? widget;

    if (_conversationHeaderBuilder != null) {
      widget = _conversationHeaderBuilder!();
    }

    return (
      widget ?? const TencentCloudChatConversationAppBar(),
      widget != null
    );
  }

  @override
  Widget getConversationItemAvatarBuilder(
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

  @override
  Widget getConversationItemContentBuilder(V2TimConversation conversation) {
    Widget? widget;

    if (_conversationItemContentBuilder != null) {
      widget = _conversationItemContentBuilder!(conversation);
    }
    return widget ??
        TencentCloudChatConversationItemContent(
          conversation: conversation,
        );
  }

  @override
  Widget getConversationItemInfoBuilder(V2TimConversation conversation) {
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
