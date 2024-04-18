class TencentCloudChatGroupProfileEventHandlers {
  late final TencentCloudChatGroupProfileUIEventHandlers? _uiEventHandlers;
  late final TencentCloudChatGroupProfileLifeCycleEventHandlers?
      _lifeCycleEventHandlers;

  TencentCloudChatGroupProfileEventHandlers({
    TencentCloudChatGroupProfileUIEventHandlers? uiEventHandlers,
    TencentCloudChatGroupProfileLifeCycleEventHandlers? lifeCycleEventHandlers,
  }) {
    _uiEventHandlers = uiEventHandlers;
    _lifeCycleEventHandlers = lifeCycleEventHandlers;
  }

  TencentCloudChatGroupProfileUIEventHandlers get uiEventHandlers {
    _uiEventHandlers ??= TencentCloudChatGroupProfileUIEventHandlers();
    return _uiEventHandlers!;
  }

  TencentCloudChatGroupProfileLifeCycleEventHandlers
      get lifeCycleEventHandlers {
    _lifeCycleEventHandlers ??=
        TencentCloudChatGroupProfileLifeCycleEventHandlers();
    return _lifeCycleEventHandlers!;
  }
}

class TencentCloudChatGroupProfileUIEventHandlers {
  void setEventHandlers() {}
}

class TencentCloudChatGroupProfileLifeCycleEventHandlers {
  void setEventHandlers() {}
}
