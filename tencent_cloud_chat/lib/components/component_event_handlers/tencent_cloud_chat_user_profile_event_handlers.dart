class TencentCloudChatUserProfileEventHandlers {
  final TencentCloudChatUserProfileUIEventHandlers _uiEventHandlers;
  final TencentCloudChatUserProfileLifeCycleEventHandlers _lifeCycleEventHandlers;

  TencentCloudChatUserProfileEventHandlers({
    TencentCloudChatUserProfileUIEventHandlers? uiEventHandlers,
    TencentCloudChatUserProfileLifeCycleEventHandlers? lifeCycleEventHandlers,
  }) : _uiEventHandlers = uiEventHandlers ?? TencentCloudChatUserProfileUIEventHandlers(),
  _lifeCycleEventHandlers = lifeCycleEventHandlers ?? TencentCloudChatUserProfileLifeCycleEventHandlers();

  TencentCloudChatUserProfileUIEventHandlers get uiEventHandlers => _uiEventHandlers;

  TencentCloudChatUserProfileLifeCycleEventHandlers get lifeCycleEventHandlers => _lifeCycleEventHandlers;
}

class TencentCloudChatUserProfileUIEventHandlers {
  void setEventHandlers() {}
}

class TencentCloudChatUserProfileLifeCycleEventHandlers {
  void setEventHandlers() {}
}
