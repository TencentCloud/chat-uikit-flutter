class TencentCloudChatSearchEventHandlers {
  final TencentCloudChatSearchUIEventHandlers _uiEventHandlers;
  final TencentCloudChatSearchLifeCycleEventHandlers _lifeCycleEventHandlers;

  TencentCloudChatSearchEventHandlers({
    TencentCloudChatSearchUIEventHandlers? uiEventHandlers,
    TencentCloudChatSearchLifeCycleEventHandlers? lifeCycleEventHandlers,
  }) : _uiEventHandlers = uiEventHandlers ?? TencentCloudChatSearchUIEventHandlers(),
        _lifeCycleEventHandlers = lifeCycleEventHandlers ?? TencentCloudChatSearchLifeCycleEventHandlers();

  TencentCloudChatSearchUIEventHandlers get uiEventHandlers => _uiEventHandlers;

  TencentCloudChatSearchLifeCycleEventHandlers get lifeCycleEventHandlers => _lifeCycleEventHandlers;
}

class TencentCloudChatSearchUIEventHandlers {
  void setEventHandlers() {}
}

class TencentCloudChatSearchLifeCycleEventHandlers {
  void setEventHandlers() {}
}
