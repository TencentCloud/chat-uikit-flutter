import 'package:tencent_cloud_chat/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

typedef OnTapConversationItem = Future<bool> Function({
  required TencentCloudChatMessageOptions messageOptions,
  required V2TimConversation conversation,
  required bool inDesktopMode,
});

class TencentCloudChatConversationEventHandlers {
  final TencentCloudChatConversationUIEventHandlers _uiEventHandlers;
  final TencentCloudChatConversationLifeCycleEventHandlers _lifeCycleEventHandlers;

  TencentCloudChatConversationEventHandlers({
    TencentCloudChatConversationUIEventHandlers? uiEventHandlers,
    TencentCloudChatConversationLifeCycleEventHandlers? lifeCycleEventHandlers,
  })  : _uiEventHandlers = uiEventHandlers ?? TencentCloudChatConversationUIEventHandlers(),
        _lifeCycleEventHandlers = lifeCycleEventHandlers ?? TencentCloudChatConversationLifeCycleEventHandlers();

  TencentCloudChatConversationUIEventHandlers get uiEventHandlers => _uiEventHandlers;

  TencentCloudChatConversationLifeCycleEventHandlers get lifeCycleEventHandlers => _lifeCycleEventHandlers;
}

class TencentCloudChatConversationUIEventHandlers {
  /// This function is triggered when the user taps on a conversation item.
  /// By default, tapping a conversation item navigates to the corresponding Message component.
  /// You can customize this behavior based on the provided data.
  /// Return value:
  /// - true: If you handle this event and want to prevent automatic navigation to the Message component.
  /// - false: If you want to keep the default behavior and allow UIKit to navigate to the Message component.
  OnTapConversationItem? _onTapConversationItem;

  OnTapConversationItem? get onTapConversationItem => _onTapConversationItem;

  TencentCloudChatConversationUIEventHandlers({
    OnTapConversationItem? onTapConversationItem,
  }) : _onTapConversationItem = onTapConversationItem;

  void setEventHandlers({
    OnTapConversationItem? onTapConversationItem,
  }) {
    _onTapConversationItem = onTapConversationItem ?? _onTapConversationItem;
  }
}

class TencentCloudChatConversationLifeCycleEventHandlers {
  void setEventHandlers() {}
}
