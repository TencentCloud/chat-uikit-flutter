class TencentCloudChatMessageEventHandlers {
  late final TencentCloudChatMessageUIEventHandlers? _uiEventHandlers;
  late final TencentCloudChatMessageLifeCycleEventHandlers?
      _lifeCycleEventHandlers;

  TencentCloudChatMessageEventHandlers({
    TencentCloudChatMessageUIEventHandlers? uiEventHandlers,
    TencentCloudChatMessageLifeCycleEventHandlers? lifeCycleEventHandlers,
  }) {
    _uiEventHandlers = uiEventHandlers;
    _lifeCycleEventHandlers = lifeCycleEventHandlers;
  }

  TencentCloudChatMessageUIEventHandlers get uiEventHandlers {
    _uiEventHandlers ??= TencentCloudChatMessageUIEventHandlers();
    return _uiEventHandlers!;
  }

  TencentCloudChatMessageLifeCycleEventHandlers get lifeCycleEventHandlers {
    _lifeCycleEventHandlers ??= TencentCloudChatMessageLifeCycleEventHandlers();
    return _lifeCycleEventHandlers!;
  }
}

class TencentCloudChatMessageUIEventHandlers {
  void setEventHandlers() {}
}

class TencentCloudChatMessageLifeCycleEventHandlers {
  void setEventHandlers() {}
}
