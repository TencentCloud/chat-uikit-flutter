// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/widgets.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_conversation_sdk.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_group_sdk.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_message_sdk.dart';
import 'package:tencent_cloud_chat/chat_sdk/tencent_cloud_chat_sdk.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_data_tools.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_sticker/default_sticker_set.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_sticker/tencent_cloud_chat_message_sticker_data.dart';
// import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudChatMessageSeparateDataProvider extends ChangeNotifier {
  final AutoScrollController desktopInputMemberSelectionPanelScroll =
      AutoScrollController(
    axis: Axis.vertical,
  );
  final TencentCloudChatMessageData _messageGlobalData =
      TencentCloudChat.dataInstance.messageData;
  TencentCloudChatMessageController? _messageController;

  TencentCloudChatMessageConfig _config =
      TencentCloudChat.dataInstance.basic.messageConfig;
  TencentCloudChatMessageStickerData? _stickerData;

  String? _userID;
  String? _groupID;
  V2TimGroupInfo? _groupInfo;
  List<V2TimGroupMemberFullInfo?> _groupMemberList = [];
  V2TimConversation? _conversation;
  List<V2TimMessage> _messagesMentionedMe = [];

  List<V2TimMessage> _selectedMessages = [];
  bool _inSelectMode = false;
  V2TimMessage? _repliedMessage;

  /// Desktop mentioning members
  double _desktopMentionBoxPositionX = 0.0;
  double _desktopMentionBoxPositionY = 0.0;
  int _activeMentionIndex = -1;
  List<V2TimGroupMemberFullInfo?> _currentFilteredMembersListForMention = [];
  V2TimGroupMemberFullInfo? _memberNeedToMention;

  String? get userID => _userID;

  String? get groupID => _groupID;

  TencentCloudChatMessageConfig get config => _config;

  List<V2TimMessage> get selectedMessages => _selectedMessages;

  bool get inSelectMode => _inSelectMode;

  V2TimMessage? get repliedMessage => _repliedMessage;

  V2TimGroupInfo? get groupInfo => _groupInfo;

  List<V2TimGroupMemberFullInfo?> get groupMemberList => _groupMemberList;

  TencentCloudChatMessageController get messageController {
    _messageController ??= TencentCloudChatMessageController();
    return _messageController!;
  }

  V2TimConversation? get conversation => _conversation;

  List<V2TimMessage> get messagesMentionedMe => _messagesMentionedMe;

  double get desktopMentionBoxPositionX => _desktopMentionBoxPositionX;

  double get desktopMentionBoxPositionY => _desktopMentionBoxPositionY;

  int get activeMentionIndex => _activeMentionIndex;

  List<V2TimGroupMemberFullInfo?> get currentFilteredMembersListForMention =>
      _currentFilteredMembersListForMention;

  V2TimGroupMemberFullInfo? get memberNeedToMention => _memberNeedToMention;

  set memberNeedToMention(V2TimGroupMemberFullInfo? value) {
    _memberNeedToMention = value;
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

  set currentFilteredMembersListForMention(
      List<V2TimGroupMemberFullInfo?> value) {
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

  Future<V2TimConversation> loadConversation(
      {bool shouldUpdateState = false}) async {
    final res = await TencentCloudChatConversationSDK.getConversation(
        userID: _userID, groupID: _groupID);
    if (shouldUpdateState) {
      conversation = res;
    } else {
      _conversation = res;
    }
    return res;
  }

  Future<List<V2TimMessage>> _loadMentionedMessages({
    required V2TimConversation conversation,
  }) async {
    if (TencentCloudChatUtils.checkString(_groupID) != null) {
      final seqList = conversation.groupAtInfoList
              ?.map((e) => int.tryParse(e?.seq ?? "-1") ?? -1)
              .toList() ??
          [];
      if (seqList.isNotEmpty) {
        final messageListRes =
            await TencentCloudChatMessageSDK().getHistoryMessageList(
          count: seqList.length,
          groupID: _groupID,
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

  setGroupMemberList(List<V2TimGroupMemberFullInfo?> list) {
    _groupMemberList = list;
    notifyListeners();
  }

  triggerSelectedMessage({required V2TimMessage message}) {
    final targetIndex = _selectedMessages.indexWhere((element) =>
        element.msgID == message.msgID ||
        (element.id == message.id &&
            TencentCloudChatUtils.checkString(element.id) != null));
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
    _selectedMessages.removeWhere((element) =>
        element.msgID == message.msgID ||
        (element.id == message.id &&
            TencentCloudChatUtils.checkString(element.id) != null));
    notifyListeners();
  }

  Future<void> loadToSpecificMessage({
    V2TimMessage? message,
    int? timeStamp,
    int? seq,
  }) async {
    assert(message != null || timeStamp != null || seq != null);

    final ({bool haveMoreLatestData, bool haveMorePreviousData}) res =
        await _messageGlobalData.loadToSpecificMessage(
      userID: userID,
      groupID: groupID,
      msgID: message?.msgID,
      timeStamp: timeStamp,
      seq: seq,
    );

    final messageListStatus = _messageGlobalData.getMessageListStatus(
        userID: userID, groupID: groupID);
    messageListStatus.haveMoreLatestData = res.haveMoreLatestData;
    messageListStatus.haveMorePreviousData = res.haveMorePreviousData;

    return;
  }

  Future<void> loadMessageList({
    String? userID,
    String? groupID,
    required TencentCloudChatMessageLoadDirection direction,
    int count = 20,
    String? lastMsgID,
  }) async {
    final messageListStatus = _messageGlobalData.getMessageListStatus(
        userID: userID, groupID: groupID);

    if (lastMsgID != null &&
            (direction == TencentCloudChatMessageLoadDirection.previous &&
                !messageListStatus.haveMorePreviousData) ||
        (direction == TencentCloudChatMessageLoadDirection.latest &&
            !messageListStatus.haveMoreLatestData)) {
      return;
    }
    final isFinished = await _messageGlobalData.loadMessageList(
      direction: direction,
      userID: userID,
      groupID: groupID,
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

  get haveMorePreviousData => _messageGlobalData
      .getMessageListStatus(userID: _userID, groupID: _groupID)
      .haveMorePreviousData;

  get haveMoreLatestData => _messageGlobalData
      .getMessageListStatus(userID: _userID, groupID: _groupID)
      .haveMoreLatestData;

  void init({
    String? userID,
    String? groupID,
    TencentCloudChatMessageConfig? config,
  }) async {
    _userID = TencentCloudChatUtils.checkString(userID);
    _groupID = TencentCloudChatUtils.checkString(groupID);
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
    }

    _initSticker();

    if (TencentCloudChatUtils.checkString(_groupID) != null) {
      // getDataFromCache
      var list = TencentCloudChat.cache.getGroupMemberListFromCache(_groupID!);
      if (list.isNotEmpty) {
        setGroupMemberList(list);
      }
      _loadGroupInfo();
      _loadGroupMemberList();
    }
    TencentCloudChatSDK.manager
        .getConversationManager()
        .cleanConversationUnreadMessageCount(
          conversationID: TencentCloudChatUtils.checkString(_groupID) != null
              ? "group_$_groupID"
              : "c2c_$_userID",
          cleanTimestamp: 0,
          cleanSequence: 0,
        );
  }

  void unInit() {
    _userID = null;
    _groupID = null;
    _groupInfo = null;
    _groupMemberList.clear();
    _messagesMentionedMe.clear();
    _conversation = null;
    _inSelectMode = false;
    _selectedMessages.clear();
    _repliedMessage = null;
    notifyListeners();
  }

  getVideoAndImageElem() {
    int convType = TencentCloudChatUtils.checkString(_groupID) == null
        ? ConversationType.V2TIM_C2C
        : ConversationType.V2TIM_GROUP;
    String convKey = TencentCloudChatUtils.checkString(_groupID) == null
        ? (_userID ?? "")
        : _groupID!;
    TencentCloudChatMessageSDK.getLocalMessageByElemType(
            lastMsgId: "", convType: convType, convKey: convKey)
        .then((value) {});
  }

  void _initSticker() {
    final List<TencentCloudChatStickerSet> stickerSetList = [];
    if (_config.enableDefaultEmojis(userID: _userID, groupID: _groupID)) {
      stickerSetList.add(defaultQQStickerSet);
    }
    final List<TencentCloudChatStickerSet> customStickerSets =
        _config.additionalStickerSets(userID: _userID, groupID: _groupID);
    stickerSetList.addAll(customStickerSets);
    _stickerData = TencentCloudChatMessageStickerData(stickerSetList);
  }

  void _loadGroupInfo() async {
    final groupInfoList = await TencentCloudChatGroupSDK()
        .getGroupsInfo(groupIDList: [_groupID ?? ""]);
    _groupInfo = groupInfoList?.first.groupInfo;
  }

  Future<List<V2TimGroupMemberFullInfo?>> _loadGroupMemberList(
      {String nextSeq = "0"}) async {
    final res = await TencentCloudChatGroupSDK().getGroupMemberList(
      groupID: _groupID ?? "",
      filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
      nextSeq: nextSeq,
    );
    List<V2TimGroupMemberFullInfo?> list = [];
    if (res?.code == 0) {
      final result = res?.data;
      final List<V2TimGroupMemberFullInfo?> tempMemberList =
          result?.memberInfoList ?? [];
      list.addAll(tempMemberList);
      if (TencentCloudChatUtils.checkString(result?.nextSeq) != null &&
          result!.nextSeq != "0") {
        list.addAll(await _loadGroupMemberList(nextSeq: result.nextSeq!));
      }
    }
    setGroupMemberList(list);
    if (TencentCloudChatUtils.checkString(_groupID) != null) {
      List<V2TimGroupMemberFullInfo> newList = [];
      if (list.isNotEmpty) {
        for (var i = 0; i < list.length; i++) {
          var item = list[i];
          if (item != null) {
            newList.add(item);
          }
        }
      }
      TencentCloudChat.cache.cacheGroupMemberList(
        _groupID!,
        newList,
      );
    }
    return list;
  }

  List<V2TimMessage> getMessageListForRender({String? messageListKey}) {
    final messageListPointer = _messageGlobalData.getMessageList(
        key: TencentCloudChatUtils.checkString(messageListKey) ??
            TencentCloudChatUtils.checkString(_groupID) ??
            _userID ??
            "");

    _sendMessageReadReceipt(messageListPointer);

    final messageList = [...messageListPointer.reversed];

    final timeDividerConfig =
        _config.timeDividerConfig(userID: _userID, groupID: _groupID);
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

    if (interval != null) {
      for (var item in messageList) {
        if (listWithTimestamp.isEmpty ||
            (listWithTimestamp[listWithTimestamp.length - 1].timestamp !=
                    null &&
                item.timestamp != null &&
                (item.timestamp! -
                        listWithTimestamp[listWithTimestamp.length - 1]
                            .timestamp! >
                    interval))) {
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
        DateTime currentItemDate =
            DateTime.fromMillisecondsSinceEpoch(item.timestamp! * 1000);

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
    final useReadReceipt =
        TencentCloudChatUtils.checkString(_groupID) != null &&
            _groupInfo != null &&
            _config
                .enabledGroupTypesForMessageReadReceipt(
                    userID: _userID, groupID: _groupID)
                .contains(_groupInfo?.groupType);
    final filteredMessageList = messageList
        .where((element) =>
            (element.isRead ?? false) == false &&
            (element.isSelf ?? true) == false)
        .toList();
    for (var element in filteredMessageList) {
      element.isRead = true;
    }

    if (TencentCloudChatUtils.checkString(_groupID) != null && useReadReceipt) {
      final List<V2TimMessage> needReceiptMessageList = filteredMessageList
          .where((element) =>
              element.needReadReceipt == true &&
              TencentCloudChatUtils.checkString(element.msgID) != null)
          .toList();
      if (needReceiptMessageList.isNotEmpty) {
        TencentCloudChatSDK.manager.getMessageManager().sendMessageReadReceipts(
              messageIDList:
                  needReceiptMessageList.map((e) => e.msgID ?? "").toList(),
            );
      }
    } else if (filteredMessageList.isNotEmpty) {
      TencentCloudChatSDK.manager
          .getConversationManager()
          .cleanConversationUnreadMessageCount(
            conversationID: TencentCloudChatUtils.checkString(_groupID) != null
                ? "group_$_groupID"
                : "c2c_$_userID",
            cleanTimestamp: 0,
            cleanSequence: 0,
          );
    }
  }

  _sendMessage({V2TimMsgCreateInfoResult? messageInfoResult}) async {
    List<V2TimMessage> currentHistoryMsgList =
        TencentCloudChat.dataInstance.messageData.getMessageList(
            key: TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");
    final messageInfo = messageInfoResult!.messageInfo;
    bool needSendRotate = false;
    if (messageInfo != null) {
      final messageInfoWithAdditionalInfo =
          TencentCloudChatMessageDataTools.setAdditionalInfoForMessage(
        messageInfo: messageInfo,
        id: messageInfoResult.id!,
        repliedMessage: _repliedMessage,
        groupID: _groupID,
        offlinePushInfo: _config.messageOfflinePushInfo(
            userID: _userID, groupID: _groupID, message: messageInfo),
        groupInfo: _groupInfo,
      );

      if (messageInfo.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
        if (messageInfo.imageElem != null) {
          if (TencentCloudChatUtils.checkString(messageInfo.imageElem!.path) !=
              null) {
            File image = File(messageInfo.imageElem!.path!);
            ImageExifInfo imageExifInfo =
                await TencentCloudChatUtils.getImageExifInfoByBuffer(
                    fileBuffer: image.readAsBytesSync());
            String currentLocal = TencentCloudChatUtils.addDataToStringFiled(
              key: "renderInfo",
              value: json.encode({
                'h': imageExifInfo.height,
                'w': imageExifInfo.width,
                'rotate': imageExifInfo.isRotate ? "1" : "0",
                "from": "send",
              }),
              currentString:
                  messageInfoWithAdditionalInfo.localCustomData ?? "",
            );

            if (imageExifInfo.isRotate) {
              needSendRotate = true;
            }
            messageInfoWithAdditionalInfo.localCustomData = currentLocal;

            TencentCloudChat.logInstance.console(
                componentName: "TencentCloudChatMessageSeparateDataProvider",
                logs:
                    "before send image message. get image info $currentLocal");
          }
        }
      }

      if (messageInfo.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
        if (messageInfo.videoElem != null) {
          if (TencentCloudChatUtils.checkString(
                  messageInfo.videoElem!.snapshotPath) !=
              null) {
            File image = File(messageInfo.videoElem!.snapshotPath!);
            ImageExifInfo imageExifInfo =
                await TencentCloudChatUtils.getImageExifInfoByBuffer(
                    fileBuffer: image.readAsBytesSync());
            String currentLocal = TencentCloudChatUtils.addDataToStringFiled(
              key: "renderInfo",
              value: json.encode({
                'h': imageExifInfo.height,
                'w': imageExifInfo.width,
                'rotate': imageExifInfo.isRotate ? "1" : "0",
                "from": "send",
              }),
              currentString:
                  messageInfoWithAdditionalInfo.localCustomData ?? "",
            );
            if (imageExifInfo.isRotate) {
              needSendRotate = true;
            }
            messageInfoWithAdditionalInfo.localCustomData = currentLocal;
            TencentCloudChat.logInstance.console(
                componentName: "TencentCloudChatMessageSeparateDataProvider",
                logs:
                    "before send image message. get image info $currentLocal");
          }
        }
      }

      currentHistoryMsgList.insert(0, messageInfoWithAdditionalInfo);
      TencentCloudChat.dataInstance.messageData.updateMessageList(
          messageList: currentHistoryMsgList,
          userID: _userID,
          groupID: _groupID);

      if (_repliedMessage != null) {
        _repliedMessage = null;
        notifyListeners();
      }

      final needReadReceipt =
          TencentCloudChatUtils.checkString(_groupID) != null &&
              _groupInfo != null &&
              _config
                  .enabledGroupTypesForMessageReadReceipt(
                      userID: _userID, groupID: _groupID)
                  .contains(_groupInfo?.groupType);

      return TencentCloudChatMessageDataTools.sendMessage(
        userID: _userID,
        groupID: _groupID,
        messageInfo: messageInfoWithAdditionalInfo,
        needReadReceipt: needReadReceipt,
        id: messageInfoResult.id as String,
        offlinePushInfo: messageInfoWithAdditionalInfo.offlinePushInfo,
        cloudCustomData: needSendRotate
            ? TencentCloudChatUtils.addDataToStringFiled(
                key: "renderInfo",
                value: json.encode({
                  "rotate": "1",
                }),
                currentString:
                    messageInfoWithAdditionalInfo.cloudCustomData ?? "",
              )
            : messageInfoWithAdditionalInfo.cloudCustomData,
      );
    }
    return null;
  }

  // Text Message
  sendTextMessage(String text, List<String> mentionedUsers) async {
    if (text.isEmpty) {
      return null;
    }
    final textMessageInfo =
        await TencentCloudChatMessageSDK().createTextMessage(
      text: text,
      mentionedUsers: mentionedUsers,
    );
    return _sendMessage(messageInfoResult: textMessageInfo);
  }

  // Image Message
  sendImageMessage(String imagePath) async {
    if (imagePath.isEmpty) {
      return null;
    }
    final messageInfo = await TencentCloudChatMessageSDK().createImageMessage(
      imagePath: imagePath,
      imageName: Pertypath().basename(imagePath),
    );

    return _sendMessage(messageInfoResult: messageInfo);
  }

  // Video Message
  sendVideoMessage(String videoPath) async {
    if (videoPath.isEmpty) {
      return null;
    }
    final plugin = FcNativeVideoThumbnail();
    String snapshotPath =
        "${(await getTemporaryDirectory()).path}${Pertypath().basename(videoPath)}.jpeg";
    await plugin.getVideoThumbnail(
      srcFile: videoPath,
      keepAspectRatio: true,
      destFile: snapshotPath,
      format: 'jpeg',
      width: 128,
      quality: 100,
      height: 128,
    );
    final String fileExtension = Pertypath().extension(videoPath).toLowerCase();
    final messageInfo = await TencentCloudChatMessageSDK().createVideoMessage(
      videoFilePath: videoPath,
      snapshotPath: snapshotPath,
      type: fileExtension,
      duration: 150,
    );

    return _sendMessage(messageInfoResult: messageInfo);
  }

  // File Message
  sendFileMessage(String filePath) async {
    if (filePath.isEmpty) {
      return null;
    }
    final messageInfo = await TencentCloudChatMessageSDK().createFileMessage(
      filePath: filePath,
      fileName: Pertypath().basename(filePath),
    );
    return _sendMessage(messageInfoResult: messageInfo);
  }

  // Voice Message
  sendVoiceMessage(String voicePath, int duration) async {
    if (voicePath.isEmpty) {
      return null;
    }

    final messageInfo = await TencentCloudChatMessageSDK().createVoiceMessage(
      voicePath: voicePath,
      duration: duration,
    );
    return _sendMessage(messageInfoResult: messageInfo);
  }

  // Forward Individually
  sendForwardIndividuallyMessage(List<String> msgIDs,
      List<({String? userID, String? groupID})> chats) async {
    List<V2TimMessage> currentHistoryMsgList =
        TencentCloudChat.dataInstance.messageData.getMessageList(
            key: TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");

    if (chats.isEmpty || msgIDs.isEmpty) {
      return null;
    }
    for (final msg in msgIDs) {
      if (TencentCloudChatUtils.checkString(msg) == null) {
        continue;
      }
      final forwardMessageInfo = await TencentCloudChatMessageSDK()
          .createForwardIndividuallyMessage(msgID: msg);
      final messageInfo = forwardMessageInfo?.messageInfo;
      if (messageInfo != null) {
        for (final chat in chats) {
          final messageInfoWithAdditionalInfo =
              TencentCloudChatMessageDataTools.setAdditionalInfoForMessage(
            messageInfo: messageInfo,
            id: messageInfo.id!,
            groupID: _groupID,
            offlinePushInfo: _config.messageOfflinePushInfo(
                userID: _userID, groupID: _groupID, message: messageInfo),
            groupInfo: _groupInfo,
          );
          final isCurrentConversation = (chat.userID == _userID &&
                  TencentCloudChatUtils.checkString(_userID) != null) ||
              (chat.groupID == _groupID &&
                  TencentCloudChatUtils.checkString(_groupID) != null);
          if (isCurrentConversation) {
            currentHistoryMsgList.insert(0, messageInfoWithAdditionalInfo);
          }
          TencentCloudChatMessageDataTools.sendMessage(
            userID: chat.userID,
            groupID: chat.groupID,
            id: messageInfo.id as String,
            isCurrentConversation: isCurrentConversation,
            offlinePushInfo: messageInfoWithAdditionalInfo.offlinePushInfo,
          );
        }
      }
    }
    TencentCloudChat.dataInstance.messageData.updateMessageList(
        messageList: currentHistoryMsgList, userID: _userID, groupID: _groupID);
  }

// Forward Combined
  sendForwardCombinedMessage(List<V2TimMessage> messages,
      List<({String? userID, String? groupID})> chats) async {
    final msgIDs = messages.map((e) => e.msgID ?? "").toList();
    List<V2TimMessage> currentHistoryMsgList =
        TencentCloudChat.dataInstance.messageData.getMessageList(
            key: TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");
    if (chats.isEmpty || msgIDs.isEmpty) {
      return null;
    }
    final forwardMessageInfo =
        await TencentCloudChatMessageSDK().createForwardCombinedMessage(
      msgIDList: msgIDs,
      title: tL10n.chatRecord,
      abstractList: TencentCloudChatMessageDataTools.getAbstractList(messages),
      compatibleText: tL10n.chatRecord,
    );
    final messageInfo = forwardMessageInfo?.messageInfo;
    if (messageInfo != null) {
      for (final chat in chats) {
        final messageInfoWithAdditionalInfo =
            TencentCloudChatMessageDataTools.setAdditionalInfoForMessage(
          messageInfo: messageInfo,
          id: messageInfo.id!,
          groupID: _groupID,
          offlinePushInfo: _config.messageOfflinePushInfo(
              userID: _userID, groupID: _groupID, message: messageInfo),
          groupInfo: _groupInfo,
        );
        final isCurrentConversation = (chat.userID == _userID &&
                TencentCloudChatUtils.checkString(_userID) != null) ||
            (chat.groupID == _groupID &&
                TencentCloudChatUtils.checkString(_groupID) != null);
        if (isCurrentConversation) {
          currentHistoryMsgList.insert(0, messageInfoWithAdditionalInfo);
        }
        TencentCloudChatMessageDataTools.sendMessage(
          userID: chat.userID,
          groupID: chat.groupID,
          id: messageInfo.id as String,
          isCurrentConversation: isCurrentConversation,
          offlinePushInfo: messageInfoWithAdditionalInfo.offlinePushInfo,
        );
      }
    }
    TencentCloudChat.dataInstance.messageData.updateMessageList(
        messageList: currentHistoryMsgList, userID: _userID, groupID: _groupID);
  }

  Future deleteMessagesForEveryone({
    required List<V2TimMessage> messages,
  }) async {
    final deleteRes = await TencentCloudChatMessageSDK()
        .deleteMessagesForEveryone(messages: messages);
    List<V2TimMessage> currentHistoryMsgList =
        TencentCloudChat.dataInstance.messageData.getMessageList(
            key: TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");

    for (final targetMessage in deleteRes) {
      currentHistoryMsgList.removeWhere((msg) =>
          ((msg.msgID == targetMessage.msgID &&
                  TencentCloudChatUtils.checkString(msg.msgID) != null) ||
              (msg.id == targetMessage.id &&
                  TencentCloudChatUtils.checkString(msg.id) != null)) &&
          TencentCloudChatUtils.checkString(msg.msgID) != null);
    }
    TencentCloudChat.dataInstance.messageData.updateMessageList(
        messageList: currentHistoryMsgList, userID: _userID, groupID: _groupID);
  }

  Future deleteMessagesForMe({
    required List<V2TimMessage> messages,
  }) async {
    List<V2TimMessage> currentHistoryMsgList =
        TencentCloudChat.dataInstance.messageData.getMessageList(
            key: TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");
    final deleteRes = await TencentCloudChatMessageSDK().deleteMessagesForMe(
        msgIDs: messages.map((e) => e.msgID ?? "").toList());
    if (deleteRes?.code == 0) {
      for (final element in messages) {
        currentHistoryMsgList.removeWhere((msg) =>
            ((msg.msgID == element.msgID &&
                    TencentCloudChatUtils.checkString(msg.msgID) != null) ||
                (msg.id == element.id &&
                    TencentCloudChatUtils.checkString(msg.id) != null)) &&
            TencentCloudChatUtils.checkString(msg.msgID) != null);
      }
    }
    TencentCloudChat.dataInstance.messageData.updateMessageList(
        messageList: currentHistoryMsgList, userID: _userID, groupID: _groupID);
  }

  Future recallMessage({
    required V2TimMessage message,
  }) async {
    List<V2TimMessage> currentHistoryMsgList =
        TencentCloudChat.dataInstance.messageData.getMessageList(
            key: TencentCloudChatUtils.checkString(_groupID) ?? _userID ?? "");
    final res = await TencentCloudChatSDK.manager
        .getMessageManager()
        .revokeMessage(msgID: message.msgID ?? "");
    if (res.code == 0) {
      final target = currentHistoryMsgList.firstWhere((element) =>
          element.msgID == message.msgID || element.id == message.id);
      target.status = MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED;
    }
    TencentCloudChat.dataInstance.messageData.updateMessageList(
        messageList: currentHistoryMsgList, userID: _userID, groupID: _groupID);
  }
}
