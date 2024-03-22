import 'package:tencent_cloud_chat/components/components_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatConversationEventHandlers {
  static TencentCloudChatConversationUIEventHandlers? _uiEventHandlers;
  static TencentCloudChatConversationLifeCycleEventHandlers?
      _lifeCycleEventHandlers;

  TencentCloudChatConversationEventHandlers({
    TencentCloudChatConversationUIEventHandlers? uiEventHandlers,
    TencentCloudChatConversationLifeCycleEventHandlers? lifeCycleEventHandlers,
  }) {
    _uiEventHandlers = uiEventHandlers;
    _lifeCycleEventHandlers = lifeCycleEventHandlers;
  }

  static TencentCloudChatConversationUIEventHandlers? get uiEventHandlers =>
      _uiEventHandlers;

  static TencentCloudChatConversationLifeCycleEventHandlers?
      get lifeCycleEventHandlers => _lifeCycleEventHandlers;
}

class TencentCloudChatConversationUIEventHandlers {

  /// This function is triggered when the user taps on a conversation item.
  /// By default, tapping a conversation item navigates to the corresponding Message component.
  /// You can customize this behavior based on the provided data.
  /// Return value:
  /// - true: If you handle this event and want to prevent automatic navigation to the Message component.
  /// - false: If you want to keep the default behavior and allow UIKit to navigate to the Message component.
  final Future<bool> Function({
    required TencentCloudChatMessageOptions messageOptions,
    required V2TimConversation conversation,
  required bool inDesktopMode,
  })? onTapConversationItem;

  TencentCloudChatConversationUIEventHandlers({
    this.onTapConversationItem,
  });
}

class TencentCloudChatConversationLifeCycleEventHandlers {}
