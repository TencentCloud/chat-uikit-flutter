typedef OnTapContactItem = Future<bool> Function({
  String? userID,
  String? groupID,
});

class TencentCloudChatContactEventHandlers {
  final TencentCloudChatContactUIEventHandlers _uiEventHandlers;
  final TencentCloudChatContactLifeCycleEventHandlers _lifeCycleEventHandlers;

  TencentCloudChatContactEventHandlers({
    TencentCloudChatContactUIEventHandlers? uiEventHandlers,
    TencentCloudChatContactLifeCycleEventHandlers? lifeCycleEventHandlers,
  })  : _uiEventHandlers = uiEventHandlers ?? TencentCloudChatContactUIEventHandlers(),
        _lifeCycleEventHandlers = lifeCycleEventHandlers ?? TencentCloudChatContactLifeCycleEventHandlers();

  TencentCloudChatContactUIEventHandlers get uiEventHandlers => _uiEventHandlers;

  TencentCloudChatContactLifeCycleEventHandlers get lifeCycleEventHandlers => _lifeCycleEventHandlers;
}

class TencentCloudChatContactUIEventHandlers {
  /// This function is triggered when the user taps on a contact item.
  /// By default, tapping a contact item navigates to the corresponding Message component on Mobile devices, while do nothing on Tablet or Desktop devices.
  /// You can customize this behavior based on the provided data.
  /// Return value:
  /// - true: If you handle this event and want to prevent automatic navigation to the Message component.
  /// - false: If you want to keep the default behavior and allow UIKit to navigate to the Message component.
  OnTapContactItem? _onTapContactItem;

  OnTapContactItem? get onNavigateToChat => _onTapContactItem;

  TencentCloudChatContactUIEventHandlers({
    OnTapContactItem? onTapContactItem,
  }) : _onTapContactItem = onTapContactItem;

  void setEventHandlers({
    OnTapContactItem? onTapContactItem,
  }) {
    _onTapContactItem = onTapContactItem ?? _onTapContactItem;
  }
}

class TencentCloudChatContactLifeCycleEventHandlers {
  TencentCloudChatContactLifeCycleEventHandlers();

  void setEventHandlers() {}
}
