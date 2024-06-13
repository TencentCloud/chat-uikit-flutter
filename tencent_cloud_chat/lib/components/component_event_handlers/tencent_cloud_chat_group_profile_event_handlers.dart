class TencentCloudChatGroupProfileEventHandlers {
  final TencentCloudChatGroupProfileUIEventHandlers _uiEventHandlers;
  final TencentCloudChatGroupProfileLifeCycleEventHandlers _lifeCycleEventHandlers;

  TencentCloudChatGroupProfileEventHandlers({
    TencentCloudChatGroupProfileUIEventHandlers? uiEventHandlers,
    TencentCloudChatGroupProfileLifeCycleEventHandlers? lifeCycleEventHandlers,
  })  : _uiEventHandlers = uiEventHandlers ?? TencentCloudChatGroupProfileUIEventHandlers(),
        _lifeCycleEventHandlers = lifeCycleEventHandlers ?? TencentCloudChatGroupProfileLifeCycleEventHandlers();

  TencentCloudChatGroupProfileUIEventHandlers get uiEventHandlers => _uiEventHandlers;

  TencentCloudChatGroupProfileLifeCycleEventHandlers get lifeCycleEventHandlers => _lifeCycleEventHandlers;
}

class TencentCloudChatGroupProfileUIEventHandlers {
  void setEventHandlers() {}
}

class TencentCloudChatGroupProfileLifeCycleEventHandlers {
  void setEventHandlers() {}
}
