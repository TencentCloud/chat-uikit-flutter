// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';


import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/eventbus/tencent_cloud_chat_eventbus.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/error_message_converter.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_data_tools.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';

class TencentCloudChatMessageSeparateDataProvider extends ChangeNotifier {
  bool _disposed = false;

  final AutoScrollController desktopInputMemberSelectionPanelScroll = AutoScrollController(
    axis: Axis.vertical,
  );
  final TencentCloudChatMessageData _messageGlobalData = TencentCloudChat.instance.dataInstance.messageData;
  TencentCloudChatMessageController? _messageController;

  TencentCloudChatMessageConfig _config = TencentCloudChat.instance.dataInstance.messageData.messageConfig;

  TencentCloudChatMessageEventHandlers? messageEventHandlers;

  TencentCloudChatMessageBuilders? messageBuilders;

  final int forwardMsgNumLimit = 30;

  // TencentCloudChatMessageStickerData? _stickerData;

  String? _userID;
  String? _groupID;
  String? _topicID;
  V2TimTopicInfo? _topicInfo;
  V2TimConversation? _conversation;
  List<V2TimMessage> _messagesMentionedMe = [];

  List<V2TimMessage> _selectedMessages = [];
  bool _inSelectMode = false;
  V2TimMessage? _quotedMessage;

  final List<V2TimMessage> _translatedMessages = [];
  final List<V2TimMessage> _soundToTextMessages = [];
  final Set<String> _soundToTextFailedMsgIDs = {};

  /// Desktop mentioning members
  double _desktopMentionBoxPositionX = 0.0;
  double _desktopMentionBoxPositionY = 0.0;
  double _desktopStickerBoxPositionY = 0.0;
  double _desktopStickerBoxPositionX = 0.0;
  bool _desktopStickerPanelOpened = false;

  int _activeMentionIndex = -1;
  List<V2TimGroupMemberFullInfo?> _currentFilteredMembersListForMention = [];
  List<V2TimGroupMemberFullInfo>? _memberNeedToMention;

  String? get userID => _userID;

  String? get groupID => _groupID;

  String? get topicID => _topicID;

  TencentCloudChatMessageConfig get config => _config;

  bool get hasStickerPlugin => TencentCloudChat.instance.dataInstance.basic.hasPlugins("sticker");

  String listenerID = "";

  TencentCloudChatPlugin? get stickerPluginInstance =>
      TencentCloudChat.instance.dataInstance.basic.getPlugin("sticker")?.pluginInstance;

  TencentCloudChatPlugin? get messageReactionPluginInstance =>
      TencentCloudChat.instance.dataInstance.basic.getPlugin("messageReaction")?.pluginInstance;

  TencentCloudChatPlugin? get soundToTextPluginInstance =>
      TencentCloudChat.instance.dataInstance.basic.getPlugin("soundToText")?.pluginInstance;

  TencentCloudChatPlugin? get textTranslatePluginInstance =>
      TencentCloudChat.instance.dataInstance.basic.getPlugin("textTranslate")?.pluginInstance;

  set config(TencentCloudChatMessageConfig value) {
    _config = value;
  }

  List<V2TimMessage> get translatedMessages => _translatedMessages;

  List<V2TimMessage> get soundToTextMessages => _soundToTextMessages;

  Set<String> get soundToTextFailedMsgIDs => _soundToTextFailedMsgIDs;

  bool get inSelectMode => _inSelectMode;

  V2TimMessage? get quotedMessage => _quotedMessage;

  V2TimGroupInfo get groupInfo {
    return TencentCloudChat.instance.dataInstance.contact.getGroupInfo(_groupID ?? '');
  }

  List<V2TimGroupMemberFullInfo?> get groupMemberList =>
      TencentCloudChat.instance.dataInstance.groupProfile.getGroupMemberList(_groupID);

  TencentCloudChatMessageController get messageController {
    _messageController ??=
        TencentCloudChat.instance.dataInstance.messageData.messageController as TencentCloudChatMessageController? ??
            TencentCloudChatMessageControllerGenerator.getInstance();
    return _messageController!;
  }

  V2TimConversation? get conversation => _conversation;

  List<V2TimMessage> get messagesMentionedMe => _messagesMentionedMe;

  bool get desktopStickerPanelOpened => _desktopStickerPanelOpened;

  double get desktopMentionBoxPositionX => _desktopMentionBoxPositionX;

  double get desktopMentionBoxPositionY => _desktopMentionBoxPositionY;

  double get desktopStickerBoxPositionX => _desktopStickerBoxPositionX;

  double get desktopStickerBoxPositionY => _desktopStickerBoxPositionY;

  int get activeMentionIndex => _activeMentionIndex;

  List<V2TimGroupMemberFullInfo?> get currentFilteredMembersListForMention => _currentFilteredMembersListForMention;

  List<V2TimGroupMemberFullInfo>? get membersNeedToMention => _memberNeedToMention;

  final Stream<TencentCloudChatConversationData<dynamic>>? _conversationDataStream = TencentCloudChat
      .instance.eventBusInstance
      .on<TencentCloudChatConversationData<dynamic>>(TencentCloudChatEventBus.eventNameConversation);
  StreamSubscription<TencentCloudChatConversationData<dynamic>>? _conversationDataSubscription;

  closeSticker() {
    _desktopStickerBoxPositionX = 0.0;
    _desktopStickerBoxPositionY = 0.0;
    _desktopStickerPanelOpened = false;
    notifyListeners();
  }

  setStickerPosition(Offset offset) {
    if (_desktopStickerBoxPositionX == 0.0 && _desktopStickerBoxPositionY == 0.0) {
      _desktopStickerBoxPositionX = offset.dx;
      _desktopStickerBoxPositionY = offset.dy;
      _desktopStickerPanelOpened = true;
    } else {
      _desktopStickerBoxPositionX = 0.0;
      _desktopStickerBoxPositionY = 0.0;
      _desktopStickerPanelOpened = false;
    }
    notifyListeners();
  }

  set membersNeedToMention(List<V2TimGroupMemberFullInfo>? value) {
    if (value != null) {
      _memberNeedToMention = value;
    } else {
      _memberNeedToMention?.clear();
    }
    notifyListeners();
  }

  set activeMentionIndex(int value) {
    _activeMentionIndex = value;
    notifyListeners();
  }

  set desktopMentionBoxPositionY(double value) {
    _desktopMentionBoxPositionY = value;
    notifyListeners();
  }

  set currentFilteredMembersListForMention(List<V2TimGroupMemberFullInfo?> value) {
    _currentFilteredMembersListForMention = value;
    notifyListeners();
  }

  set desktopMentionBoxPositionX(double value) {
    _desktopMentionBoxPositionX = value;
    notifyListeners();
  }

  set messagesMentionedMe(List<V2TimMessage> value) {
    _messagesMentionedMe = value;
    notifyListeners();
  }

  set conversation(V2TimConversation? value) {
    _conversation = value;
    notifyListeners();
  }

  set messageController(TencentCloudChatMessageController value) {
    _messageController = value;
  }

  set quotedMessage(V2TimMessage? value) {
    _quotedMessage = value;
    notifyListeners();
  }

  set inSelectMode(bool value) {
    if (!inSelectMode && value) {
      _selectedMessages.clear();
    }
    _inSelectMode = value;
    notifyListeners();
  }

  set selectedMessages(List<V2TimMessage> value) {
    _selectedMessages = value;
    notifyListeners();
  }

  List<V2TimMessage> getSelectedMessages() {
    // sort
    if (_selectedMessages != null && _selectedMessages.isNotEmpty) {
      if (_selectedMessages != null && _selectedMessages.length >= 2) {
        _selectedMessages.sort((a, b) {
          if (a.timestamp != b.timestamp) {
            return a.timestamp!.compareTo(b.timestamp!);
          } else {
            return a.seq!.compareTo(b.seq!);
          }
        });
      }
    }

    return _selectedMessages;
  }

  triggerSelectedMessage({required V2TimMessage message}) {
    if (_selectedMessages.any((element) =>
        (TencentCloudChatUtils.checkString(message.msgID) != null && element.msgID == message.msgID) ||
        (TencentCloudChatUtils.checkString(message.id) != null && element.id == message.id))) {
      _selectedMessages.removeWhere((element) =>
          (TencentCloudChatUtils.checkString(message.msgID) != null && element.msgID == message.msgID) ||
          (TencentCloudChatUtils.checkString(message.id) != null && element.id == message.id));
    } else {
      _selectedMessages.add(message);
    }

    notifyListeners();
  }

  set translatedMessages(List<V2TimMessage> value) {
    final translateMessage = value.first;
    final isNotExist = _translatedMessages.indexWhere((element) => element.msgID == translateMessage.msgID) == -1;
    if (isNotExist) {
      _translatedMessages.add(translateMessage);
      notifyListeners();
    }
  }

  set soundToTextMessages(List<V2TimMessage> value) {
    final soundToTextMessage = value.first;
    final isNotExist = _soundToTextMessages.indexWhere((element) => element.msgID == soundToTextMessage.msgID) == -1;
    if (isNotExist) {
      _soundToTextMessages.add(soundToTextMessage);
      notifyListeners();
    }
  }

  void handleSoundToTextSuccessfulMessage(String msgID) {
    _soundToTextFailedMsgIDs.remove(msgID);
  }

  void handleSoundToTextFailedMessage(String msgID) {
    _soundToTextMessages.removeWhere((msg) => msg.msgID != null && msg.msgID == msgID);
    _soundToTextFailedMsgIDs.add(msgID);
    notifyListeners();
  }

  Future<V2TimConversation> loadConversation({bool shouldUpdateState = false}) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.conversationSDK
        .getConversation(userID: _userID, groupID: _groupID);
    if (shouldUpdateState) {
      conversation = res;
    } else {
      _conversation = res;
    }
    return res;
  }

  void uikitListener(Map<String, dynamic> data) {
    if (data.containsKey("eventType")) {
      if (data["eventType"] == "stickClick") {
        if (data["type"] == 0) {
          // messageController.textEditingController.text = "${messageController.textEditingController.text}${data["name"]}";
        } else if (data["type"] == 1) {
          sendFaceMessage(data["stickerIndex"], data["name"]);
        }
      }
    }
  }

  String addUIKitListener() {
    var id = TencentCloudChat.instance.chatSDKInstance.messageSDK.addUIKitListener(listener: uikitListener);
    listenerID = id;
    return id;
  }

  void removeUIKitListener() {
    TencentCloudChat.instance.chatSDKInstance.messageSDK.removeUIKitListener(listenerID: listenerID);
  }

  Future<List<V2TimMessage>> _loadMentionedMessages({
    required V2TimConversation conversation,
  }) async {
    if (TencentCloudChatUtils.checkString(_groupID) != null) {
      final seqList = conversation.groupAtInfoList?.map((e) => int.tryParse(e?.seq ?? "-1") ?? -1).toList() ?? [];
      if (seqList.isNotEmpty) {
        final messageListRes = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getHistoryMessageList(
          count: seqList.length,
          groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID,
          messageSeqList: seqList,
        );
        final messageList = messageListRes.messageList;
        messagesMentionedMe = messageList;
      } else {
        messagesMentionedMe = [];
      }
    }
    return _messagesMentionedMe;
  }

  bool checkMessagesForward(TencentCloudChatForwardType forwardType, List<V2TimMessage> messages) {
    for (V2TimMessage message in messages) {
      if (message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL) {
        TencentCloudChat.instance.callbacks.onUserNotificationEvent(
            TencentCloudChatComponentsEnum.message,
            TencentCloudChatUserNotificationEvent(
              eventCode: -1,
              text: tL10n.forwardFailedTip,
            ));
        return false;
      }

      if (TencentCloudChatUtils.isVoteMessage(message)) {
        TencentCloudChat.instance.callbacks.onUserNotificationEvent(
            TencentCloudChatComponentsEnum.message,
            TencentCloudChatUserNotificationEvent(
              eventCode: -1,
              text: tL10n.forwardVoteFailedTip,
            ));
        return false;
      }
    }

    if (forwardType == TencentCloudChatForwardType.individually && messages.length > forwardMsgNumLimit) {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent(
          TencentCloudChatComponentsEnum.message,
          TencentCloudChatUserNotificationEvent(
            eventCode: -1,
            text: tL10n.forwardOneByOneLimitNumberTip,
          ));
      return false;
    }

    return true;
  }

  Future<bool> loadToSpecificMessage({
    bool highLightTargetMessage = true,
    V2TimMessage? message,
    int? timeStamp,
    int? seq,
  }) async {
    assert(message != null || timeStamp != null || seq != null);
    try {
      final ({bool haveMoreLatestData, bool haveMorePreviousData, V2TimMessage? targetMessage}) res =
          await _messageGlobalData.loadToSpecificMessage(
        userID: userID,
        groupID: groupID,
        topicID: topicID,
        msgID: TencentCloudChatUtils.checkString(message?.msgID),
        timeStamp: timeStamp ?? message?.timestamp,
        seq: seq ?? (TencentCloudChatUtils.checkString(message?.seq) != null ? int.tryParse(message!.seq!) : null),
      );

      if (res.targetMessage == null || res.targetMessage!.status == MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED) {
        return false;
      }

      final messageListStatus = _messageGlobalData.getMessageListStatus(userID: userID, groupID: groupID);
      messageListStatus.haveMoreLatestData = res.haveMoreLatestData;
      messageListStatus.haveMorePreviousData = res.haveMorePreviousData;

      // M11: single post-frame scroll instead of two racing Future.delayed
      // hops. Capture the conversation identifier at issue time and bail if
      // the user has navigated to a different conversation (or this provider
      // has been disposed) before the frame settles.
      final scrollTargetUserID = _userID;
      final scrollTargetGroupID = _groupID;
      final scrollTargetTopicID = _topicID;
      final scrollMsgID = TencentCloudChatUtils.checkString(res.targetMessage?.msgID) ?? message?.msgID;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_disposed) return;
        if (_userID != scrollTargetUserID ||
            _groupID != scrollTargetGroupID ||
            _topicID != scrollTargetTopicID) {
          return;
        }
        _messageController?.scrollToSpecificMessage(
          msgID: scrollMsgID,
          userID: _userID,
          topicID: _topicID,
          groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID,
        );
      });

      if (highLightTargetMessage &&
          (TencentCloudChatUtils.checkString(res.targetMessage?.msgID) != null ||
              TencentCloudChatUtils.checkString(message?.msgID) != null)) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Future.delayed(const Duration(milliseconds: 300), () {
            TencentCloudChat.instance.dataInstance.messageData.messageHighlighted =
                TencentCloudChatUtils.checkString(res.targetMessage?.msgID) != null ? res.targetMessage : message;
          });
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _isLoadingPrevious = false;
  bool _isLoadingLatest = false;

  // M10: high-watermark for read-receipt reporting — avoid firing
  // cleanConversationUnreadMessageCount / sendMessageReadReceipts on every
  // render when the newest visible message hasn't advanced.
  String? _lastReportedReadMsgID;
  int _lastReportedReadTimestamp = 0;

  Future<void> loadMessageList({
    String? userID,
    String? groupID,
    String? topicID,
    required TencentCloudChatMessageLoadDirection direction,
    int count = 20,
    String? lastMsgID,
    int? lastMsgSeq,
  }) async {
    final messageListStatus = _messageGlobalData.getMessageListStatus(
        userID: userID, groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID);

    // H6: parenthesize the early-exit guard so lastMsgID gates BOTH directions
    // (the previous form parsed as `(lastMsgID != null && prev) || latest`,
    // letting the latest-path clause fire regardless of lastMsgID).
    if (lastMsgID != null &&
        ((direction == TencentCloudChatMessageLoadDirection.previous && !messageListStatus.haveMorePreviousData) ||
            (direction == TencentCloudChatMessageLoadDirection.latest && !messageListStatus.haveMoreLatestData))) {
      return;
    }

    // H5: per-direction in-flight guard — drop overlapping callers
    // for the same direction so we don't fan out duplicate fetches.
    final isPrevDir = direction == TencentCloudChatMessageLoadDirection.previous;
    if (isPrevDir && _isLoadingPrevious) return;
    if (!isPrevDir && _isLoadingLatest) return;
    if (isPrevDir) {
      _isLoadingPrevious = true;
    } else {
      _isLoadingLatest = true;
    }
    try {
      final isFinished = await _messageGlobalData.loadMessageList(
        direction: direction,
        userID: userID,
        groupID: groupID,
        topicID: topicID,
        count: count,
        lastMsgID: lastMsgID,
        lastMsgSeq: lastMsgSeq,
      );
      if (direction == TencentCloudChatMessageLoadDirection.latest) {
        messageListStatus.haveMoreLatestData = !isFinished;
      } else {
        messageListStatus.haveMorePreviousData = !isFinished;
      }
    } finally {
      if (isPrevDir) {
        _isLoadingPrevious = false;
      } else {
        _isLoadingLatest = false;
      }
    }
    return;
  }

  get haveMorePreviousData => _messageGlobalData
      .getMessageListStatus(userID: _userID, groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID)
      .haveMorePreviousData;

  get haveMoreLatestData => _messageGlobalData
      .getMessageListStatus(userID: _userID, groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID)
      .haveMoreLatestData;

  void init(
      {String? userID,
      String? groupID,
      String? topicID,
      TencentCloudChatMessageConfig? config,
      TencentCloudChatMessageBuilders? builders,
      TencentCloudChatMessageController? controller,
      TencentCloudChatMessageEventHandlers? eventHandlers}) async {
    _userID = TencentCloudChatUtils.checkString(userID);
    _groupID = TencentCloudChatUtils.checkString(groupID);
    _topicID = TencentCloudChatUtils.checkString(topicID);
    if ((_userID == null) && (_groupID == null)) {
      unInit();
      return;
    }

    // Synchronously pre-populate conversation from global conversation list to avoid
    // header flash (default avatar/ID shown briefly before async load completes).
    // The global list already contains correct faceUrl and showName from the conversation list page.
    final convID = TencentCloudChatUtils.checkString(_groupID) != null ? "group_$_groupID" : "c2c_$_userID";
    final globalConvList = TencentCloudChat.instance.dataInstance.conversation.conversationList;
    final cachedConv = globalConvList.cast<V2TimConversation?>().firstWhere(
      (c) => c?.conversationID == convID,
      orElse: () => null,
    );
    if (cachedConv != null) {
      _conversation = cachedConv;
      notifyListeners();
    }

    final conversation = await loadConversation(shouldUpdateState: true);
    if (_groupID != null) {
      _loadMentionedMessages(conversation: conversation);
    }

    // If conversation has no faceUrl (e.g. avatar saved after list was built), schedule a delayed
    // refresh so session list/header pick up the latest from Prefs when avatar is available.
    final hasEmptyFaceUrl = conversation.faceUrl == null || conversation.faceUrl!.isEmpty;
    if (hasEmptyFaceUrl && TencentCloudChatUtils.checkString(_userID) != null) {
      Future.delayed(const Duration(milliseconds: 800), () async {
        if (_userID == null) return;
        final refreshed = await loadConversation(shouldUpdateState: true);
        if (refreshed.faceUrl != null && refreshed.faceUrl!.isNotEmpty) {
          this.conversation = refreshed;
        }
      });
    }

    if (config != null) {
      _config = config;
    } else {
      _config = TencentCloudChat.instance.dataInstance.messageData.messageConfig;
    }

    if (eventHandlers != null) {
      messageEventHandlers = eventHandlers;
    } else {
      messageEventHandlers = TencentCloudChat.instance.dataInstance.messageData.messageEventHandlers;
    }

    if (builders != null) {
      messageBuilders = builders;
    } else {
      messageBuilders =
          TencentCloudChat.instance.dataInstance.messageData.messageBuilder as TencentCloudChatMessageBuilders;
    }

    if (controller != null) {
      messageController = controller;
    } else {
      messageController =
          TencentCloudChat.instance.dataInstance.messageData.messageController as TencentCloudChatMessageController? ??
              TencentCloudChatMessageControllerGenerator.getInstance();
    }

    if (TencentCloudChatUtils.checkString(_groupID) != null) {
      Future.delayed(const Duration(seconds: 0), () {
        _loadGroupMemberList();
        notifyListeners();
      });
    }

    TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().cleanConversationUnreadMessageCount(
          conversationID: TencentCloudChatUtils.checkString(_groupID) != null ? "group_$_groupID" : "c2c_$_userID",
          cleanTimestamp: 0,
          cleanSequence: 0,
        );
    if (listenerID.isNotEmpty) {
      removeUIKitListener();
    }
    addUIKitListener();

    _conversationDataSubscription = _conversationDataStream?.listen(_conversationDataHandler);
  }

  _conversationDataHandler(TencentCloudChatConversationData conversationData) {
    if (conversationData.currentUpdatedFields == TencentCloudChatConversationDataKeys.conversationList) {
      final conversationList = conversationData.conversationList;
      if (conversationList != null && _conversation != null) {
        int index = conversationList.indexWhere((element) => element.conversationID == _conversation!.conversationID);
        if (index >= 0) {
          conversation = conversationList[index];
        }
      }
    }
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    removeUIKitListener();
    _cleanGroupData();
    _conversationDataSubscription?.cancel();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  void unInit() {
    _userID = null;
    _groupID = null;
    _topicID = null;
    _cleanGroupData();
    _messagesMentionedMe.clear();
    _translatedMessages.clear();
    _soundToTextMessages.clear();
    _soundToTextFailedMsgIDs.clear();
    _conversation = null;
    _inSelectMode = false;
    _selectedMessages.clear();
    _quotedMessage = null;
    removeUIKitListener();
    notifyListeners();
  }

  void _cleanGroupData() {
    if (TencentCloudChatUtils.checkString(_groupID) != null) {
      TencentCloudChat.instance.dataInstance.groupProfile.removeGroupMemberList(_groupID);
    }
  }

  getVideoAndImageElem() {
    int convType =
        TencentCloudChatUtils.checkString(_groupID) == null ? ConversationType.V2TIM_C2C : ConversationType.V2TIM_GROUP;
    String convKey = TencentCloudChatUtils.checkString(_groupID) == null
        ? (_userID ?? "")
        : (TencentCloudChatUtils.checkString(_topicID) ?? _groupID!);
    TencentCloudChat.instance.chatSDKInstance.messageSDK
        .getLocalMessageByElemType(lastMsgId: "", convType: convType, convKey: convKey)
        .then((value) {});
  }

  void triggerLinkTappedEvent(String link) {
    final bool customEvent = messageEventHandlers?.uiEventHandlers.onTapLink?.call(
          link: link,
        ) ??
        false;
    if (!customEvent) {
      TencentCloudChatUtils.launchLink(link: link);
    }
  }

  Future<List<V2TimGroupMemberFullInfo?>> _loadGroupMemberList() async {
    final bool mentionGroupAdminAndOwnerOnly = config.mentionGroupAdminAndOwnerOnly(
      groupID: _groupID,
      userID: _userID,
      topicID: _topicID,
    );
    final res = await TencentCloudChat.instance.dataInstance.groupProfile.loadGroupMemberList(
      loadGroupAdminAndOwnerOnly: mentionGroupAdminAndOwnerOnly,
      groupID: _groupID,
    );
    return res;
  }

  List<V2TimMessage> getMessageListForRender({String? messageListKey}) {
    final messageListPointer = _messageGlobalData.getMessageList(
        key: TencentCloudChatUtils.checkString(messageListKey) ??
            TencentCloudChatUtils.checkString(_topicID) ??
            TencentCloudChatUtils.checkString(_groupID) ??
            _userID ??
            "");

    if (_config.enableAutoReportReadStatusForComingMessages(
      userID: _userID,
      groupID: _groupID,
      topicID: _topicID,
    )) {
      _sendMessageReadReceipt(messageListPointer);
    }

    // OPTIMIZED: messageListPointer is already in newest-first order (internal storage format),
    // so we don't need to reverse it. We'll work directly with newest-first order.
    List<V2TimMessage> messageList = [...messageListPointer];

    final timeDividerConfig = _config.timeDividerConfig(userID: _userID, groupID: _groupID, topicID: _topicID);
    final List<V2TimMessage> listWithTimestamp = [];
    final interval = timeDividerConfig.timeInterval;

    // Remove messages been deleted
    messageList.removeWhere((element) {
      final cloudCustomDataString = TencentCloudChatUtils.checkString(element.cloudCustomData) ?? "{}";
      try {
        final cloudCustomData = jsonDecode(cloudCustomDataString);
        if (cloudCustomData["deleteForEveryone"] == true) {
          return true;
        }
        if (element.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
          if (element.customElem != null) {
            if (element.customElem!.data != null) {
              String? data = element.customElem!.data!;
              try {
                Map<String, dynamic> jsonData = json.decode(data);
                var isCustomerServicePlugin = jsonData["customerServicePlugin"] ?? "";
                if (isCustomerServicePlugin == 0) {
                  List<String> srcWhiteList = [
                    '9',
                    '21',
                    '22',
                    '15',
                    '28',
                    '29',
                    '30',
                    '31',
                  ];
                  return !srcWhiteList.contains(jsonData["src"]);
                }
              } catch (err) {
                return false;
              }
            }
          }
        }
        return false;
      } catch (e) {
        return false;
      }
    });

    messageList = messageEventHandlers?.lifeCycleEventHandlers.beforeRenderMessageList?.call(
          messageList: messageList,
          userID: _userID,
          groupID: _groupID,
          topicID: _topicID,
        ) ??
        messageList;

    // OPTIMIZED: Sort messages by timestamp to ensure correct order before creating date separators
    // Since we're working with newest-first order, we sort descending (newest first)
    // This ensures messages are properly ordered and date separators are inserted correctly
    messageList.sort((a, b) {
      final timestampA = a.timestamp ?? 0;
      final timestampB = b.timestamp ?? 0;
      // If timestamps are equal, use msgID as tiebreaker to ensure stable sort
      if (timestampA == timestampB) {
        final msgIDA = a.msgID ?? a.id ?? '';
        final msgIDB = b.msgID ?? b.id ?? '';
        return msgIDB.compareTo(msgIDA); // Descending for newest-first
      }
      return timestampB.compareTo(timestampA); // Descending: newest first
    });

    // Process messages in newest-first order and insert date separators.
    // With FlutterListView reverse:true, index 0 is at the BOTTOM of the screen.
    // So in the list: lower index = newer = visually at bottom, higher index = older = visually at top.
    //
    // Desired UI (top to bottom):
    //   [divider: Yesterday]    ← top (highest index)
    //   [msg_yesterday]
    //   [divider: Today]
    //   [msg_today]             ← bottom (index 0, newest)
    //
    // Corresponding list (newest-first): [msg_today, divider_today, msg_yesterday, divider_yesterday]
    //
    // Algorithm: For each message, add the message first, then check if a separator
    // is needed AFTER it (between this message and the next older one, or after the oldest message).
    // The separator uses the CURRENT message's timestamp so it labels the messages below it.
    DateTime? lastMessageDate;

    if (interval != null) {
      // Use time interval for separators
      for (int i = 0; i < messageList.length; i++) {
        final item = messageList[i];
        listWithTimestamp.add(item);

        // Check if we need a separator AFTER this message (visually above it)
        bool needsSeparator = false;
        if (i == messageList.length - 1) {
          // Last (oldest) message always needs a separator above it
          needsSeparator = true;
        } else {
          final nextItem = messageList[i + 1];
          if (item.timestamp != null && nextItem.timestamp != null &&
              (item.timestamp! - nextItem.timestamp!).abs() > interval) {
            needsSeparator = true;
          }
        }

        if (needsSeparator) {
          listWithTimestamp.add(V2TimMessage(
            userID: '',
            isSelf: false,
            elemType: 101,
            msgID: 'time-divider-${item.timestamp}-${item.msgID ?? i}',
            timestamp: item.timestamp,
          ));
        }
      }
    } else {
      // Use date-based separators
      for (int i = 0; i < messageList.length; i++) {
        final item = messageList[i];
        DateTime currentItemDate = DateTime.fromMillisecondsSinceEpoch((item.timestamp ?? 0) * 1000);

        listWithTimestamp.add(item);

        // Check if we need a separator AFTER this message (visually above it)
        bool needsSeparator = false;
        if (i == messageList.length - 1) {
          // Last (oldest) message always needs a separator above it
          needsSeparator = true;
        } else {
          final nextItem = messageList[i + 1];
          DateTime nextItemDate = DateTime.fromMillisecondsSinceEpoch((nextItem.timestamp ?? 0) * 1000);
          if (currentItemDate.year != nextItemDate.year ||
              currentItemDate.month != nextItemDate.month ||
              currentItemDate.day != nextItemDate.day) {
            needsSeparator = true;
          }
        }

        if (needsSeparator) {
          listWithTimestamp.add(V2TimMessage(
            userID: '',
            isSelf: false,
            elemType: 101,
            msgID: 'time-divider-${item.timestamp}-${item.msgID ?? i}',
            timestamp: item.timestamp,
          ));
        }

        lastMessageDate = currentItemDate;
      }
    }
    
    // listWithTimestamp is in newest-first order with separators correctly positioned:
    // [msg_today, divider_today, msg_yesterday, divider_yesterday]
    // With reverse:true ListView, this renders as:
    //   divider_yesterday (top)
    //   msg_yesterday
    //   divider_today
    //   msg_today (bottom, newest)
    return listWithTimestamp;
  }

  _sendMessageReadReceipt(List<V2TimMessage> messageList) async {
    if (messageList.isEmpty) {
      return;
    }
    final groupType = groupInfo?.groupType;
    final enabledGroupType =
        _config.enabledGroupTypesForMessageReadReceipt(userID: _userID, groupID: _groupID, topicID: _topicID);
    final useReadReceipt = TencentCloudChatUtils.checkString(_groupID) != null &&
        groupInfo != null &&
        enabledGroupType.contains(groupType);
    final filteredMessageList = messageList
        .where((element) => // (element.isRead ?? false) == false &&
            (element.isSelf ?? true) == false)
        .toList();
    for (var element in filteredMessageList) {
      element.isRead = true;
    }

    // M10: bail out if the newest message hasn't advanced past the previously
    // reported watermark. messageList is in newest-first order (see
    // getMessageListForRender), so messageList[0] is the newest. For groups we
    // gate by timestamp; for C2C we gate by msgID identity.
    final isGroup = TencentCloudChatUtils.checkString(_groupID) != null;
    final newest = messageList.first;
    final newestTimestamp = newest.timestamp ?? 0;
    final newestMsgID = TencentCloudChatUtils.checkString(newest.msgID);
    if (isGroup) {
      if (newestTimestamp <= _lastReportedReadTimestamp) {
        return;
      }
    } else {
      if (newestMsgID != null && newestMsgID == _lastReportedReadMsgID) {
        return;
      }
    }

    if (TencentCloudChatUtils.checkString(_groupID) != null && useReadReceipt) {
      final List<V2TimMessage> needReceiptMessageList = filteredMessageList
          .where(
              (element) => element.needReadReceipt == true && TencentCloudChatUtils.checkString(element.msgID) != null)
          .toList();

      if (needReceiptMessageList.isNotEmpty) {
        TencentCloudChat.instance.chatSDKInstance.manager.getMessageManager().sendMessageReadReceipts(
              messageIDList: needReceiptMessageList.map((e) => e.msgID ?? "").toList(),
            );
      }
    }
    if (filteredMessageList.isNotEmpty) {
      TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().cleanConversationUnreadMessageCount(
            conversationID: TencentCloudChatUtils.checkString(_groupID) != null
                ? "group_${TencentCloudChatUtils.checkString(_topicID) ?? _groupID}"
                : "c2c_$_userID",
            cleanTimestamp: 0,
            cleanSequence: 0,
          );
    }

    // Advance watermark only after we've gone through the report path so a
    // failure mid-flight doesn't get permanently suppressed by the watermark.
    if (isGroup) {
      if (newestTimestamp > _lastReportedReadTimestamp) {
        _lastReportedReadTimestamp = newestTimestamp;
      }
    } else if (newestMsgID != null) {
      _lastReportedReadMsgID = newestMsgID;
    }
  }

  _sendMessage({V2TimMsgCreateInfoResult? messageInfoResult, bool? isResend}) async {
    if (messageInfoResult != null) {
      final tempRepliedMessage = _quotedMessage;

      if (_quotedMessage != null) {
        _quotedMessage = null;
        notifyListeners();
      }

      final res = await _messageController?.sendMessage(
        createdMessage: messageInfoResult,
        userID: _userID,
        groupID: _groupID,
        topicID: _topicID,
        repliedMessage: tempRepliedMessage,
        groupInfo: groupInfo,
        isResend: isResend,
      );

      messageController.scrollToBottom(
        userID: _userID,
        groupID: _groupID,
        topicID: _topicID,
      );

      if (res == null || res.code != 0) {
        TencentCloudChat.instance.callbacks.onSDKFailed(
          "sendMessage",
          res?.code ?? -1,
          ErrorMessageConverter.getErrorMessage(res?.code ?? -1, res!.desc),
        );
      }
    }
  }

  // Text Message
  sendTextMessage(String text, List<String> mentionedUsers) async {
    if (text.isEmpty) {
      return null;
    }
    final textMessageInfo = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createTextMessage(
      text: text,
      mentionedUsers: mentionedUsers,
    );
    return _sendMessage(messageInfoResult: textMessageInfo);
  }

  sendFaceMessage(int index, String name) async {
    final messageInfo =
        await TencentCloudChat.instance.chatSDKInstance.messageSDK.createFaceMessage(index: index, name: name);
    return _sendMessage(messageInfoResult: messageInfo);
  }

  // Image Message
  sendImageMessage({
    String? imagePath,
    String? imageName,
    dynamic inputElement,
  }) async {
    if (!TencentCloudChatPlatformAdapter().isWeb && (imagePath?.isEmpty ?? true)) {
      return null;
    }
    final messageInfo = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createImageMessage(
      imagePath: imagePath,
      imageName: TencentCloudChatUtils.checkString(imageName) ?? Pertypath().basename(imagePath ?? ""),
      inputElement: inputElement,
    );

    return _sendMessage(messageInfoResult: messageInfo);
  }

  // Video Message
  sendVideoMessage({
    String? videoPath,
    dynamic inputElement,
    int? videoDuration,
  }) async {
    if (!TencentCloudChatPlatformAdapter().isWeb && (videoPath?.isEmpty ?? true)) {
      return null;
    }
    String? snapshotPath;
    final String fileExtension = Pertypath().extension(videoPath ?? "").toLowerCase();
    if (!TencentCloudChatPlatformAdapter().isWeb) {
      final plugin = FcNativeVideoThumbnail();
      snapshotPath = "${(await getTemporaryDirectory()).path}${Pertypath().basename(videoPath ?? "")}.jpeg";
      await plugin.getVideoThumbnail(
        srcFile: videoPath ?? "",
        keepAspectRatio: true,
        destFile: snapshotPath,
        format: 'jpeg',
        width: 1280,
        quality: 100,
        height: 1280,
      );
    }
    final messageInfo = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createVideoMessage(
      videoFilePath: videoPath ?? "",
      snapshotPath: snapshotPath,
      inputElement: inputElement,
      type: fileExtension,
      // toxee(P1): upstream hard-coded `duration: 150` for every video,
      // which lies to the receiver and our own metadata mappers. Real
      // duration should come from the caller (gallery picker / recorder);
      // if unavailable, surface 0 and let downstream backfill from the
      // file metadata instead of a fabricated value.
      duration: videoDuration ?? 0,
    );

    return _sendMessage(messageInfoResult: messageInfo);
  }

  // File Message
  sendFileMessage({
    String? filePath,
    String? fileName,
    dynamic inputElement,
  }) async {
    if (!TencentCloudChatPlatformAdapter().isWeb && (filePath?.isEmpty ?? true)) {
      return null;
    }
    final messageInfo = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createFileMessage(
        filePath: filePath,
        fileName: TencentCloudChatUtils.checkString(fileName) ?? Pertypath().basename(filePath ?? ""),
        inputElement: inputElement);
    return _sendMessage(messageInfoResult: messageInfo);
  }

  // Voice Message
  sendVoiceMessage(String voicePath, int duration) async {
    if (voicePath.isEmpty) {
      return null;
    }

    final messageInfo = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createVoiceMessage(
      voicePath: voicePath,
      duration: duration,
    );
    return _sendMessage(messageInfoResult: messageInfo);
  }

  resendMessage(V2TimMessage message) async {
    V2TimMsgCreateInfoResult createInfoResult = V2TimMsgCreateInfoResult(messageInfo: message);
    return _sendMessage(
      messageInfoResult: createInfoResult,
      isResend: true,
    );
  }

  // Forward Individually
  sendForwardIndividuallyMessage(List<String> msgIDs, List<({String? userID, String? groupID})> chats) async {
    if (chats.isEmpty || msgIDs.isEmpty) {
      return null;
    }
    for (final msg in msgIDs) {
      if (TencentCloudChatUtils.checkString(msg) == null) {
        continue;
      }
      final forwardMessageInfo =
          await TencentCloudChat.instance.chatSDKInstance.messageSDK.createForwardIndividuallyMessage(msgID: msg);
      final messageInfo = forwardMessageInfo?.messageInfo;
      if (messageInfo != null) {
        for (final chat in chats) {
          final messageInfoWithAdditionalInfo = TencentCloudChatMessageDataTools.setAdditionalInfoForMessage(
            messageInfo: messageInfo,
            id: messageInfo.id ?? forwardMessageInfo?.id,
            groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID,
            offlinePushInfo: _config.messageOfflinePushInfo(
                userID: _userID, groupID: _groupID, topicID: _topicID, message: messageInfo),
            groupInfo: groupInfo,
          );

          messageInfoWithAdditionalInfo.status = MessageStatus.V2TIM_MSG_STATUS_SENDING;

          final isCurrentConversation =
              (chat.userID == _userID && TencentCloudChatUtils.checkString(_userID) != null) ||
                  (chat.groupID == _groupID && TencentCloudChatUtils.checkString(_groupID) != null);
          if (isCurrentConversation) {
            List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData
                .getMessageList(
                    key: TencentCloudChatUtils.checkString(_topicID) ??
                        TencentCloudChatUtils.checkString(_groupID) ??
                        _userID ??
                        "");
            currentHistoryMsgList.insert(0, messageInfoWithAdditionalInfo);

            TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
              messageList: currentHistoryMsgList,
              userID: _userID,
              groupID: _groupID,
              topicID: _topicID,
            );
          }

          await Future.delayed(const Duration(milliseconds: 100), () {
            TencentCloudChatMessageDataTools.sendMessageFinalPhase(
              userID: chat.userID,
              groupID: chat.groupID,
              id: messageInfo.id as String,
              isCurrentConversation: isCurrentConversation,
              offlinePushInfo: messageInfoWithAdditionalInfo.offlinePushInfo,
            );
          });
        }
      }
    }
  }

  // Forward Combined
  sendForwardCombinedMessage(List<V2TimMessage> messages, List<({String? userID, String? groupID})> chats) async {
    final msgIDs = messages.map((e) => e.msgID ?? "").toList();
    if (chats.isEmpty || msgIDs.isEmpty) {
      return null;
    }
    final forwardMessageInfo = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createForwardCombinedMessage(
      msgIDList: msgIDs,
      title: tL10n.chatRecord,
      abstractList: TencentCloudChatMessageDataTools.getAbstractList(messages),
      compatibleText: tL10n.chatRecord,
    );
    final messageInfo = forwardMessageInfo?.messageInfo;
    if (messageInfo != null) {
      for (final chat in chats) {
        final messageInfoWithAdditionalInfo = TencentCloudChatMessageDataTools.setAdditionalInfoForMessage(
          messageInfo: messageInfo,
          id: messageInfo.id ?? forwardMessageInfo?.id,
          groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID,
          offlinePushInfo: _config.messageOfflinePushInfo(
              userID: _userID, groupID: _groupID, topicID: _topicID, message: messageInfo),
          groupInfo: groupInfo,
        );

        messageInfoWithAdditionalInfo.status = MessageStatus.V2TIM_MSG_STATUS_SENDING;

        final isCurrentConversation = (chat.userID == _userID && TencentCloudChatUtils.checkString(_userID) != null) ||
            (chat.groupID == _groupID && TencentCloudChatUtils.checkString(_groupID) != null);
        if (isCurrentConversation) {
          List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData
              .getMessageList(key: TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");
          currentHistoryMsgList.insert(0, messageInfoWithAdditionalInfo);

          TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
            messageList: currentHistoryMsgList,
            userID: _userID,
            groupID: _groupID,
            topicID: _topicID,
          );
        }

        TencentCloudChatMessageDataTools.sendMessageFinalPhase(
          userID: chat.userID,
          groupID: chat.groupID,
          id: messageInfo.id as String,
          isCurrentConversation: isCurrentConversation,
          offlinePushInfo: messageInfoWithAdditionalInfo.offlinePushInfo,
        );
      }
    }
  }

  Future deleteMessagesForMe({
    required List<V2TimMessage> messages,
  }) async {
    final deleteRes = await TencentCloudChat.instance.chatSDKInstance.messageSDK.deleteMessagesForMe(
      msgIDs: messages
          .map(
            (e) => e.msgID ?? "",
          )
          .toList(),
      webMessageInstanceList: messages.map((e) => e.messageFromWeb).toList(),
    );

    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(
        key: TencentCloudChatUtils.checkString(_topicID) ??
            TencentCloudChatUtils.checkString(_groupID) ??
            _userID ??
            "");

    if (deleteRes?.code == 0) {
      for (final element in messages) {
        currentHistoryMsgList.removeWhere((msg) =>
            ((msg.msgID == element.msgID && TencentCloudChatUtils.checkString(msg.msgID) != null) ||
                (msg.id == element.id && TencentCloudChatUtils.checkString(msg.id) != null)) &&
            TencentCloudChatUtils.checkString(msg.msgID) != null);
      }
    }
    TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
      messageList: currentHistoryMsgList,
      userID: _userID,
      groupID: _groupID,
      topicID: _topicID,
    );
  }

  Future recallMessage({
    required V2TimMessage message,
  }) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getMessageManager()
        .revokeMessage(msgID: message.msgID ?? "", webMessageInstatnce: message.messageFromWeb);

    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(
        key: TencentCloudChatUtils.checkString(_topicID) ??
            TencentCloudChatUtils.checkString(_groupID) ??
            _userID ??
            "");

    if (res.code == 0) {
      final target =
          currentHistoryMsgList.firstWhere((element) => element.msgID == message.msgID || element.id == message.id);
      target.status = MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED;
      target.revokerInfo = TencentCloudChat.instance.dataInstance.basic.currentUser;
    }

    TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
        messageList: currentHistoryMsgList, userID: _userID, groupID: _groupID, topicID: _topicID, disableNotify: true);
  }

  Future setLocalCustomData(String msgID, String localCustomData) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getMessageManager()
        .setLocalCustomData(msgID: msgID, localCustomData: localCustomData);

    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(
        key: TencentCloudChatUtils.checkString(_topicID) ??
            TencentCloudChatUtils.checkString(_groupID) ??
            _userID ??
            "");

    if (res.code == 0) {
      final target = currentHistoryMsgList.firstWhere((element) => element.msgID == msgID);
      target.localCustomData = localCustomData;
    }

    TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
        messageList: currentHistoryMsgList, userID: _userID, groupID: _groupID, topicID: _topicID, disableNotify: true);
  }
}
