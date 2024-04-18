class TencentCloudChatUserProfileEventHandlers {
  late final TencentCloudChatUserProfileUIEventHandlers? _uiEventHandlers;
  late final TencentCloudChatUserProfileLifeCycleEventHandlers?
      _lifeCycleEventHandlers;

  TencentCloudChatUserProfileEventHandlers({
    TencentCloudChatUserProfileUIEventHandlers? uiEventHandlers,
    TencentCloudChatUserProfileLifeCycleEventHandlers? lifeCycleEventHandlers,
  }) {
    _uiEventHandlers = uiEventHandlers;
    _lifeCycleEventHandlers = lifeCycleEventHandlers;
  }

  TencentCloudChatUserProfileUIEventHandlers get uiEventHandlers {
    _uiEventHandlers ??= TencentCloudChatUserProfileUIEventHandlers();
    return _uiEventHandlers!;
  }

  TencentCloudChatUserProfileLifeCycleEventHandlers get lifeCycleEventHandlers {
    _lifeCycleEventHandlers ??=
        TencentCloudChatUserProfileLifeCycleEventHandlers();
    return _lifeCycleEventHandlers!;
  }
}

class TencentCloudChatUserProfileUIEventHandlers {
  void setEventHandlers() {}
}

class TencentCloudChatUserProfileLifeCycleEventHandlers {
  void setEventHandlers() {}
}
