import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

typedef OnTapMessageRelated = Future<bool> Function({
  String? userID,
  String? groupID,
  String? topicID,
  required TapDownDetails tapDownDetails,
  required V2TimMessage message,
});

typedef OnRenderMessageList = List<V2TimMessage>? Function({
  required List<V2TimMessage> messageList,
  String? userID,
  String? groupID,
  String? topicID,
});

typedef BeforeMessageSending = V2TimMessage? Function({
  required V2TimMessage createdMessage,
  V2TimMessage? repliedMessage,
  String? userID,
  String? groupID,
  String? topicID,
});

class TencentCloudChatMessageEventHandlers {
  final TencentCloudChatMessageUIEventHandlers _uiEventHandlers;
  final TencentCloudChatMessageLifeCycleEventHandlers _lifeCycleEventHandlers;

  TencentCloudChatMessageEventHandlers({
    TencentCloudChatMessageUIEventHandlers? uiEventHandlers,
    TencentCloudChatMessageLifeCycleEventHandlers? lifeCycleEventHandlers,
  })  : _uiEventHandlers = uiEventHandlers ?? TencentCloudChatMessageUIEventHandlers(),
        _lifeCycleEventHandlers = lifeCycleEventHandlers ?? TencentCloudChatMessageLifeCycleEventHandlers();

  TencentCloudChatMessageUIEventHandlers get uiEventHandlers => _uiEventHandlers;

  TencentCloudChatMessageLifeCycleEventHandlers get lifeCycleEventHandlers => _lifeCycleEventHandlers;
}

class TencentCloudChatMessageUIEventHandlers {
  bool Function({required String link})? _onTapLink;

  OnTapMessageRelated? _onTapAvatar;

  OnTapMessageRelated? _onLongPressTapAvatar;

  // OnTapMessageRelated? _onPrimaryTapMessage;
  //
  // OnTapMessageRelated? _onSecondaryTapMessage;

  TencentCloudChatMessageUIEventHandlers({
    bool Function({required String link})? onTapLink,
    OnTapMessageRelated? onTapAvatar,
    OnTapMessageRelated? onLongPressTapAvatar,
    // OnTapMessageRelated? onPrimaryTapMessage,
    // OnTapMessageRelated? onSecondaryTapMessage,
  })  : _onTapLink = onTapLink,
        _onTapAvatar = onTapAvatar,
        _onLongPressTapAvatar = onLongPressTapAvatar;

  // _onPrimaryTapMessage = onPrimaryTapMessage,
  // _onSecondaryTapMessage = onSecondaryTapMessage;

  void setEventHandlers({
    bool Function({required String link})? onTapLink,
    OnTapMessageRelated? onPrimaryTapAvatar,
    OnTapMessageRelated? onSecondaryTapAvatar,
    // OnTapMessageRelated? onPrimaryTapMessage,
    // OnTapMessageRelated? onSecondaryTapMessage,
  }) {
    _onTapLink = onTapLink ?? _onTapLink;
    _onTapAvatar = onPrimaryTapAvatar ?? _onTapAvatar;
    _onLongPressTapAvatar = onSecondaryTapAvatar ?? _onLongPressTapAvatar;
    // _onPrimaryTapMessage = onPrimaryTapMessage;
    // _onSecondaryTapMessage = onSecondaryTapMessage;
  }

  bool Function({required String link})? get onTapLink => _onTapLink;

  OnTapMessageRelated? get onTapAvatar => _onTapAvatar;

  OnTapMessageRelated? get onLongPressAvatar => _onLongPressTapAvatar;

// OnTapMessageRelated? get onPrimaryTapMessage => _onPrimaryTapMessage;
//
// OnTapMessageRelated? get onSecondaryTapMessage => _onSecondaryTapMessage;
}

class TencentCloudChatMessageLifeCycleEventHandlers {
  /// A hook that is triggered before the message list is rendered,
  /// allowing you to manually modify the list of messages to be displayed.
  /// Return a custom message list, and the UIKit will insert time dividers and render it on the UI.
  /// Return `null` to use the default message list without any modifications.
  OnRenderMessageList? _beforeRenderMessageList;

  OnRenderMessageList? get beforeRenderMessageList => _beforeRenderMessageList;

  /// A callback hook that is triggered after a message has been created and just before it's sent.
  /// Using the provided `V2TimMessage createdMessage`,
  /// you can access and modify the content of the message that is about to be sent,
  /// allowing for customizing the message content.
  /// Most properties have default values provided that can been modified.
  ///
  /// To prevent a message from being sent, return `null`.
  /// To continue sending the message, return a `V2TimMessage` instance.
  /// If no changes are needed for the message about to be sent,
  /// simply return the provided `V2TimMessage createdMessage` instance.
  BeforeMessageSending? _beforeMessageSending;

  BeforeMessageSending? get beforeMessageSending => _beforeMessageSending;

  TencentCloudChatMessageLifeCycleEventHandlers({
    OnRenderMessageList? beforeRenderMessageList,
    BeforeMessageSending? beforeMessageSending,
  })  : _beforeRenderMessageList = beforeRenderMessageList,
        _beforeMessageSending = beforeMessageSending;

  void setEventHandlers({
    OnRenderMessageList? beforeRenderMessageList,
    BeforeMessageSending? beforeMessageSending,
  }) {
    _beforeRenderMessageList = beforeRenderMessageList ?? _beforeRenderMessageList;
    _beforeMessageSending = beforeMessageSending ?? _beforeMessageSending;
  }
}
