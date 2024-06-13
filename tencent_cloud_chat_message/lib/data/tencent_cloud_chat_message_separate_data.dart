// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_data_tools.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

class TencentCloudChatMessageSeparateDataProvider extends ChangeNotifier {
  final AutoScrollController desktopInputMemberSelectionPanelScroll = AutoScrollController(
    axis: Axis.vertical,
  );
  final TencentCloudChatMessageData _messageGlobalData = TencentCloudChat.instance.dataInstance.messageData;
  TencentCloudChatMessageController? _messageController;

  TencentCloudChatMessageConfig _config = TencentCloudChat.instance.dataInstance.messageData.messageConfig;

  TencentCloudChatMessageEventHandlers? messageEventHandlers;

  TencentCloudChatMessageBuilders? messageBuilders;

  // TencentCloudChatMessageStickerData? _stickerData;

  String? _userID;
  String? _groupID;
  String? _topicID;
  V2TimGroupInfo? _groupInfo;
  V2TimTopicInfo? _topicInfo;
  List<V2TimGroupMemberFullInfo?> _groupMemberList = [];
  V2TimConversation? _conversation;
  List<V2TimMessage> _messagesMentionedMe = [];

  List<V2TimMessage> _selectedMessages = [];
  bool _inSelectMode = false;
  V2TimMessage? _repliedMessage;

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

  TencentCloudChatPlugin? get stickerPluginInstance => TencentCloudChat.instance.dataInstance.basic.getPlugin("sticker")?.pluginInstance;

  set config(TencentCloudChatMessageConfig value) {
    _config = value;
  }

  List<V2TimMessage> get selectedMessages => _selectedMessages;

  bool get inSelectMode => _inSelectMode;

  V2TimMessage? get repliedMessage => _repliedMessage;

  V2TimGroupInfo? get groupInfo => _groupInfo;

  V2TimTopicInfo? get topicInfo => _topicInfo;

  List<V2TimGroupMemberFullInfo?> get groupMemberList => _groupMemberList;

  TencentCloudChatMessageController get messageController {
    _messageController ??= TencentCloudChat.instance.dataInstance.messageData.messageController as TencentCloudChatMessageController? ?? TencentCloudChatMessageControllerGenerator.getInstance();
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

  set repliedMessage(V2TimMessage? value) {
    _repliedMessage = value;
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

  Future<V2TimConversation> loadConversation({bool shouldUpdateState = false}) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.conversationSDK.getConversation(userID: _userID, groupID: _groupID);
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
    return TencentCloudChat.instance.chatSDKInstance.messageSDK.addUIKitListener(listener: uikitListener);
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
          needCache: false,
        );
        final messageList = messageListRes.messageList;
        messagesMentionedMe = messageList;
      } else {
        messagesMentionedMe = [];
      }
    }
    return _messagesMentionedMe;
  }

  setGroupMemberList(List<V2TimGroupMemberFullInfo?> list, bool needCache) {
    if (!TencentCloudChatUtils.deepEqual(list, _groupMemberList)) {
      _groupMemberList = list;
      notifyListeners();
      if (needCache && TencentCloudChatUtils.checkString(_groupID) != null) {
        list.removeWhere((e) => e == null);
        TencentCloudChat.instance.cache.cacheGroupMemberList(
          _groupID!,
          list,
        );
      }
    }
  }

  triggerSelectedMessage({required V2TimMessage message}) {
    final targetIndex = _selectedMessages.indexWhere((element) => element.msgID == message.msgID || (element.id == message.id && TencentCloudChatUtils.checkString(element.id) != null));
    if (targetIndex > -1) {
      removeSelectedMessage(message: message);
    } else {
      addSelectedMessage(message: message);
    }
  }

  addSelectedMessage({required V2TimMessage message}) {
    _selectedMessages.add(message);
    notifyListeners();
  }

  removeSelectedMessage({required V2TimMessage message}) {
    _selectedMessages.removeWhere((element) => element.msgID == message.msgID || (element.id == message.id && TencentCloudChatUtils.checkString(element.id) != null));
    notifyListeners();
  }

  Future<bool> loadToSpecificMessage({
    bool highLightTargetMessage = true,
    V2TimMessage? message,
    int? timeStamp,
    int? seq,
  }) async {
    assert(message != null || timeStamp != null || seq != null);
    if(TencentCloudChatPlatformAdapter().isWeb){
      return false;
    }
    try {
      final ({bool haveMoreLatestData, bool haveMorePreviousData, V2TimMessage? targetMessage}) res = await _messageGlobalData.loadToSpecificMessage(
        userID: userID,
        groupID: groupID,
        msgID: TencentCloudChatUtils.checkString(message?.msgID),
        timeStamp: timeStamp ?? message?.timestamp,
        seq: seq ?? (TencentCloudChatUtils.checkString(message?.seq) != null ? int.tryParse(message!.seq!) : null),
      );

      if (res.targetMessage == null) {
        return false;
      }

      final messageListStatus = _messageGlobalData.getMessageListStatus(userID: userID, groupID: groupID);
      messageListStatus.haveMoreLatestData = res.haveMoreLatestData;
      messageListStatus.haveMorePreviousData = res.haveMorePreviousData;

      Future.delayed(const Duration(milliseconds: 100), () {
        _messageController?.scrollToSpecificMessage(
          msgID: TencentCloudChatUtils.checkString(res.targetMessage?.msgID) ?? message?.msgID,
          userID: _userID,
          groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID,
        );
      });

      Future.delayed(const Duration(milliseconds: 150), () {
        _messageController?.scrollToSpecificMessage(
          msgID: TencentCloudChatUtils.checkString(res.targetMessage?.msgID) ?? message?.msgID,
          userID: _userID,
          groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID,
        );
      });

      if (highLightTargetMessage && (TencentCloudChatUtils.checkString(res.targetMessage?.msgID) != null || TencentCloudChatUtils.checkString(message?.msgID) != null)) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Future.delayed(const Duration(milliseconds: 300), () {
            TencentCloudChat.instance.dataInstance.messageData.messageHighlighted = TencentCloudChatUtils.checkString(res.targetMessage?.msgID) != null ? res.targetMessage : message;
          });
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadMessageList({
    String? userID,
    String? groupID,
    String? topicID,
    required TencentCloudChatMessageLoadDirection direction,
    int count = 20,
    String? lastMsgID,
  }) async {
    final messageListStatus = _messageGlobalData.getMessageListStatus(userID: userID, groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID);

    if (lastMsgID != null && (direction == TencentCloudChatMessageLoadDirection.previous && !messageListStatus.haveMorePreviousData) || (direction == TencentCloudChatMessageLoadDirection.latest && !messageListStatus.haveMoreLatestData)) {
      return;
    }
    final isFinished = await _messageGlobalData.loadMessageList(
      direction: direction,
      userID: userID,
      groupID: groupID,
      topicID: topicID,
      count: count,
      lastMsgID: lastMsgID,
    );
    if (direction == TencentCloudChatMessageLoadDirection.latest) {
      messageListStatus.haveMoreLatestData = !isFinished;
    } else {
      messageListStatus.haveMorePreviousData = !isFinished;
    }
    return;
  }

  get haveMorePreviousData => _messageGlobalData.getMessageListStatus(userID: _userID, groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID).haveMorePreviousData;

  get haveMoreLatestData => _messageGlobalData.getMessageListStatus(userID: _userID, groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID).haveMoreLatestData;

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
    if (!(_userID == null) != (_groupID == null)) {
      unInit();
      return;
    }

    final conversation = await loadConversation(shouldUpdateState: true);
    if (_groupID != null) {
      _loadMentionedMessages(conversation: conversation);
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
      messageBuilders = TencentCloudChat.instance.dataInstance.messageData.messageBuilder as TencentCloudChatMessageBuilders;
    }

    if (controller != null) {
      messageController = controller;
    } else {
      messageController = TencentCloudChat.instance.dataInstance.messageData.messageController as TencentCloudChatMessageController? ?? TencentCloudChatMessageControllerGenerator.getInstance();
    }

    if (TencentCloudChatUtils.checkString(_groupID) != null) {
      final list = TencentCloudChat.instance.cache.getGroupMemberListFromCache(_groupID!);
      if (list.isNotEmpty) {
        setGroupMemberList(list, false);
      }
      _loadGroupInfo();
      _loadTopicInfo();

      Future.delayed(const Duration(seconds: 0), () {
        _loadGroupMemberList();
      });
    }
    TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().cleanConversationUnreadMessageCount(
          conversationID: TencentCloudChatUtils.checkString(_groupID) != null ? "group_$_groupID" : "c2c_$_userID",
          cleanTimestamp: 0,
          cleanSequence: 0,
        );
    listenerID = addUIKitListener();
    addMessageVideoInit();
  }

  addMessageVideoInit() {
    VideoPlayerMediaKit.ensureInitialized(
      android: true, // default: false    -    dependency: media_kit_libs_android_video
      iOS: true, // default: false    -    dependency: media_kit_libs_ios_video
      macOS: true, // default: false    -    dependency: media_kit_libs_macos_video
      windows: true, // default: false    -    dependency: media_kit_libs_windows_video
    );
  }

  void unInit() {
    _userID = null;
    _groupID = null;
    _topicID = null;
    _groupInfo = null;
    _groupMemberList.clear();
    _messagesMentionedMe.clear();
    _conversation = null;
    _inSelectMode = false;
    _selectedMessages.clear();
    _repliedMessage = null;
    removeUIKitListener();
    notifyListeners();
  }

  getVideoAndImageElem() {
    int convType = TencentCloudChatUtils.checkString(_groupID) == null ? ConversationType.V2TIM_C2C : ConversationType.V2TIM_GROUP;
    String convKey = TencentCloudChatUtils.checkString(_groupID) == null ? (_userID ?? "") : (TencentCloudChatUtils.checkString(_topicID) ?? _groupID!);
    TencentCloudChat.instance.chatSDKInstance.messageSDK.getLocalMessageByElemType(lastMsgId: "", convType: convType, convKey: convKey).then((value) {});
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

  void _loadTopicInfo() async {
    if (TencentCloudChatUtils.checkString(_topicID) != null) {
      final topicInfoList = await TencentCloudChat.instance.chatSDKInstance.groupSDK.getTopicInfo(topicIDList: [_topicID!], groupID: _groupID!);
      _topicInfo = topicInfoList?.first.topicInfo;
    }
  }

  void _loadGroupInfo() async {
    final groupInfoList = await TencentCloudChat.instance.chatSDKInstance.groupSDK.getGroupsInfo(groupIDList: [_groupID ?? ""]);
    _groupInfo = groupInfoList?.first.groupInfo;
  }

  Future<List<V2TimGroupMemberFullInfo?>> _loadGroupMemberList({String nextSeq = "0"}) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.groupSDK.getGroupMemberList(
      groupID: _groupID ?? "",
      filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
      nextSeq: nextSeq,
    );
    List<V2TimGroupMemberFullInfo?> list = [];
    if (res?.code == 0) {
      final result = res?.data;
      final List<V2TimGroupMemberFullInfo?> tempMemberList = result?.memberInfoList ?? [];
      list.addAll(tempMemberList);
      if (TencentCloudChatUtils.checkString(result?.nextSeq) != null && result!.nextSeq != "0") {
        list.addAll(await _loadGroupMemberList(nextSeq: result.nextSeq!));
      }
    }

    if (nextSeq == "0") {
      setGroupMemberList(list, true);
    }
    return list;
  }

  List<V2TimMessage> getMessageListForRender({String? messageListKey}) {
    final messageListPointer = _messageGlobalData.getMessageList(key: TencentCloudChatUtils.checkString(messageListKey) ?? TencentCloudChatUtils.checkString(_topicID) ?? TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");

    if (_config.enableAutoReportReadStatusForComingMessages(
      userID: _userID,
      groupID: _groupID,
      topicID: _topicID,
    )) {
      _sendMessageReadReceipt(messageListPointer);
    }

    List<V2TimMessage> messageList = [...messageListPointer.reversed];

    final timeDividerConfig = _config.timeDividerConfig(userID: _userID, groupID: _groupID, topicID: _topicID);
    final List<V2TimMessage> listWithTimestamp = [];
    final interval = timeDividerConfig.timeInterval;

    // Remove messages been deleted
    messageList.removeWhere((element) {
      final cloudCustomDataString = element.cloudCustomData ?? "{}";
      try {
        final cloudCustomData = jsonDecode(cloudCustomDataString);
        if (cloudCustomData["deleteForEveryone"] == true) {
          return true;
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

    if (interval != null) {
      for (var item in messageList) {
        if (listWithTimestamp.isEmpty || (listWithTimestamp[listWithTimestamp.length - 1].timestamp != null && item.timestamp != null && (item.timestamp! - listWithTimestamp[listWithTimestamp.length - 1].timestamp! > interval))) {
          listWithTimestamp.add(V2TimMessage(
            userID: '',
            isSelf: false,
            elemType: 101,
            msgID: 'time-divider-${item.timestamp}',
            timestamp: item.timestamp,
          ));
        }
        listWithTimestamp.add(V2TimMessage.fromJson(item.toJson()));
      }
    } else {
      DateTime? lastDate;

      for (var item in messageList) {
        DateTime currentItemDate = DateTime.fromMillisecondsSinceEpoch(item.timestamp! * 1000);

        if (lastDate == null || currentItemDate.day != lastDate.day) {
          listWithTimestamp.add(V2TimMessage(
            userID: '',
            isSelf: false,
            elemType: 101,
            msgID: 'time-divider-${item.timestamp}',
            timestamp: item.timestamp,
          ));
        }

        listWithTimestamp.add(V2TimMessage.fromJson(item.toJson()));
        lastDate = currentItemDate;
      }
    }

    return listWithTimestamp.reversed.toList();
  }

  _sendMessageReadReceipt(List<V2TimMessage> messageList) async {
    if (messageList.isEmpty) {
      return;
    }
    final groupType = _groupInfo?.groupType;
    final enabledGroupType = _config.enabledGroupTypesForMessageReadReceipt(userID: _userID, groupID: _groupID, topicID: _topicID);
    final useReadReceipt = TencentCloudChatUtils.checkString(_groupID) != null && _groupInfo != null && enabledGroupType.contains(groupType);
    final filteredMessageList = messageList
        .where((element) => // (element.isRead ?? false) == false &&
            (element.isSelf ?? true) == false)
        .toList();
    for (var element in filteredMessageList) {
      element.isRead = true;
    }

    if (TencentCloudChatUtils.checkString(_groupID) != null && useReadReceipt) {
      final List<V2TimMessage> needReceiptMessageList = filteredMessageList.where((element) => element.needReadReceipt == true && TencentCloudChatUtils.checkString(element.msgID) != null).toList();

      if (needReceiptMessageList.isNotEmpty) {
        TencentCloudChat.instance.chatSDKInstance.manager.getMessageManager().sendMessageReadReceipts(
              messageIDList: needReceiptMessageList.map((e) => e.msgID ?? "").toList(),
            );
      }
    }
    if (filteredMessageList.isNotEmpty) {
      TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().cleanConversationUnreadMessageCount(
            conversationID: TencentCloudChatUtils.checkString(_groupID) != null ? "group_${TencentCloudChatUtils.checkString(_topicID) ?? _groupID}" : "c2c_$_userID",
            cleanTimestamp: 0,
            cleanSequence: 0,
          );
    }
  }

  _sendMessage({V2TimMsgCreateInfoResult? messageInfoResult}) async {
    if (messageInfoResult != null) {
      messageController.scrollToBottom(
        userID: _userID,
        groupID: _groupID,
        topicID: _topicID,
      );

      final res = await _messageController?.sendMessage(
        createdMessage: messageInfoResult,
        userID: _userID,
        groupID: _groupID,
        topicID: _topicID,
        repliedMessage: _repliedMessage,
        groupInfo: _groupInfo,
        config: _config,
        beforeMessageSendingHook: messageEventHandlers?.lifeCycleEventHandlers.beforeMessageSending,
      );

      if (res != null && res.code == 0) {
        if (repliedMessage != null) {
          repliedMessage = null;
          notifyListeners();
        }
      } else {
        TencentCloudChat.instance.callbacks.onSDKFailed(
          "sendMessage",
          res?.code ?? -1,
          res?.desc ?? "",
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
    final messageInfo = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createFaceMessage(index: index, name: name);
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
  }) async {
    if (!TencentCloudChatPlatformAdapter().isWeb && (videoPath?.isEmpty ?? true)) {
      return null;
    }
    String? snapshotPath;
    final String fileExtension = Pertypath().extension(videoPath ?? "").toLowerCase();
    if(!TencentCloudChatPlatformAdapter().isWeb){
      final plugin = FcNativeVideoThumbnail();
      snapshotPath = "${(await getTemporaryDirectory()).path}${Pertypath().basename(videoPath ?? "")}.jpeg";
      await plugin.getVideoThumbnail(
        srcFile: videoPath ?? "",
        keepAspectRatio: true,
        destFile: snapshotPath,
        format: 'jpeg',
        width: 128,
        quality: 100,
        height: 128,
      );
    }
    final messageInfo = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createVideoMessage(
      videoFilePath: videoPath ?? "",
      snapshotPath: snapshotPath,
      inputElement: inputElement,
      type: fileExtension,
      duration: 150,
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
    final messageInfo =
        await TencentCloudChat.instance.chatSDKInstance.messageSDK.createFileMessage(filePath: filePath, fileName: TencentCloudChatUtils.checkString(fileName) ?? Pertypath().basename(filePath ?? ""), inputElement: inputElement);
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

  // Forward Individually
  sendForwardIndividuallyMessage(List<String> msgIDs, List<({String? userID, String? groupID})> chats) async {
    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(key: TencentCloudChatUtils.checkString(_topicID) ?? TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");

    if (chats.isEmpty || msgIDs.isEmpty) {
      return null;
    }
    for (final msg in msgIDs) {
      if (TencentCloudChatUtils.checkString(msg) == null) {
        continue;
      }
      final forwardMessageInfo = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createForwardIndividuallyMessage(msgID: msg);
      final messageInfo = forwardMessageInfo?.messageInfo;
      if (messageInfo != null) {
        for (final chat in chats) {
          final messageInfoWithAdditionalInfo = TencentCloudChatMessageDataTools.setAdditionalInfoForMessage(
            messageInfo: messageInfo,
            id: messageInfo.id ?? forwardMessageInfo?.id,
            groupID: TencentCloudChatUtils.checkString(_topicID) ?? _groupID,
            offlinePushInfo: _config.messageOfflinePushInfo(userID: _userID, groupID: _groupID, topicID: _topicID, message: messageInfo),
            groupInfo: _groupInfo,
          );
          final isCurrentConversation = (chat.userID == _userID && TencentCloudChatUtils.checkString(_userID) != null) || (chat.groupID == _groupID && TencentCloudChatUtils.checkString(_groupID) != null);
          if (isCurrentConversation) {
            currentHistoryMsgList.insert(0, messageInfoWithAdditionalInfo);
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
    TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
      messageList: currentHistoryMsgList,
      userID: _userID,
      groupID: _groupID,
      topicID: _topicID,
    );
  }

// Forward Combined
  sendForwardCombinedMessage(List<V2TimMessage> messages, List<({String? userID, String? groupID})> chats) async {
    final msgIDs = messages.map((e) => e.msgID ?? "").toList();
    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(key: TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");
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
          offlinePushInfo: _config.messageOfflinePushInfo(userID: _userID, groupID: _groupID, topicID: _topicID, message: messageInfo),
          groupInfo: _groupInfo,
        );
        final isCurrentConversation = (chat.userID == _userID && TencentCloudChatUtils.checkString(_userID) != null) || (chat.groupID == _groupID && TencentCloudChatUtils.checkString(_groupID) != null);
        if (isCurrentConversation) {
          currentHistoryMsgList.insert(0, messageInfoWithAdditionalInfo);
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
    TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
      messageList: currentHistoryMsgList,
      userID: _userID,
      groupID: _groupID,
      topicID: _topicID,
    );
  }

  Future deleteMessagesForEveryone({
    required List<V2TimMessage> messages,
  }) async {
    final deleteRes = await TencentCloudChat.instance.chatSDKInstance.messageSDK.deleteMessagesForEveryone(messages: messages);
    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(key: TencentCloudChatUtils.checkString(_topicID) ?? TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");

    for (final targetMessage in deleteRes) {
      currentHistoryMsgList.removeWhere((msg) =>
          ((msg.msgID == targetMessage.msgID && TencentCloudChatUtils.checkString(msg.msgID) != null) || (msg.id == targetMessage.id && TencentCloudChatUtils.checkString(msg.id) != null)) &&
          TencentCloudChatUtils.checkString(msg.msgID) != null);
    }
    TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
      messageList: currentHistoryMsgList,
      userID: _userID,
      groupID: _groupID,
      topicID: _topicID,
    );
  }

  Future deleteMessagesForMe({
    required List<V2TimMessage> messages,
  }) async {
    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(key: TencentCloudChatUtils.checkString(_topicID) ?? TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");
    final deleteRes = await TencentCloudChat.instance.chatSDKInstance.messageSDK.deleteMessagesForMe(
      msgIDs: messages
          .map(
            (e) => e.msgID ?? "",
          )
          .toList(),
      webMessageInstanceList: messages.map((e) => e.messageFromWeb).toList(),
    );
    if (deleteRes?.code == 0) {
      for (final element in messages) {
        currentHistoryMsgList.removeWhere((msg) =>
            ((msg.msgID == element.msgID && TencentCloudChatUtils.checkString(msg.msgID) != null) || (msg.id == element.id && TencentCloudChatUtils.checkString(msg.id) != null)) && TencentCloudChatUtils.checkString(msg.msgID) != null);
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
    List<V2TimMessage> currentHistoryMsgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(key: TencentCloudChatUtils.checkString(_topicID) ?? TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");
    final res = await TencentCloudChat.instance.chatSDKInstance.manager.getMessageManager().revokeMessage(msgID: message.msgID ?? "", webMessageInstatnce: message.messageFromWeb);
    if (res.code == 0) {
      final target = currentHistoryMsgList.firstWhere((element) => element.msgID == message.msgID || element.id == message.id);
      target.status = MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED;
    }
    TencentCloudChat.instance.dataInstance.messageData.updateMessageList(messageList: currentHistoryMsgList, userID: _userID, groupID: _groupID, topicID: _topicID, disableNotify: true);
  }
}
