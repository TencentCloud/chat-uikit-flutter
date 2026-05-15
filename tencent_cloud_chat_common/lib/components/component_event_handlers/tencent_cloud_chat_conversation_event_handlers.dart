import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

typedef OnTapConversationItem = Future<bool> Function({
  required TencentCloudChatMessageOptions messageOptions,
  required V2TimConversation conversation,
  required bool inDesktopMode,
});

/// Fired when the user secondary-taps (right-clicks) a conversation item.
/// Return true to indicate the event was handled and to prevent UIKit's
/// default desktop context menu from appearing.
typedef OnSecondaryTapConversationItem = Future<bool> Function({
  required V2TimConversation conversation,
  required Offset position,
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

  /// This function is triggered when the user secondary-taps (right-clicks) a conversation item.
  /// Provides the conversation and the global cursor position so the parent app can anchor a
  /// custom context menu (e.g. via `showMenu`).
  /// Return value:
  /// - true: handled — UIKit will skip its default desktop column menu.
  /// - false: keep default UIKit behavior.
  OnSecondaryTapConversationItem? _onSecondaryTapConversationItem;

  OnSecondaryTapConversationItem? get onSecondaryTapConversationItem => _onSecondaryTapConversationItem;

  TencentCloudChatConversationUIEventHandlers({
    OnTapConversationItem? onTapConversationItem,
    OnSecondaryTapConversationItem? onSecondaryTapConversationItem,
  })  : _onTapConversationItem = onTapConversationItem,
        _onSecondaryTapConversationItem = onSecondaryTapConversationItem;

  void setEventHandlers({
    OnTapConversationItem? onTapConversationItem,
    OnSecondaryTapConversationItem? onSecondaryTapConversationItem,
  }) {
    _onTapConversationItem = onTapConversationItem ?? _onTapConversationItem;
    _onSecondaryTapConversationItem = onSecondaryTapConversationItem ?? _onSecondaryTapConversationItem;
  }
}

class TencentCloudChatConversationLifeCycleEventHandlers {
  void setEventHandlers() {}
}
