import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_download_utils.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';

// This enum represents the different data keys for the message data.
enum TencentCloudChatMessageDataKeys { none, messageHighlighted, messageReadReceipts, messageList, downloadMessage, sendMessageProgress, currentPlayAudioInfo, messageNeedUpdate, config, builder, userStatusChange, friendInfoChange, networkConnectSuccess }

/// An enumeration of load direction of message data
enum TencentCloudChatMessageLoadDirection { previous, latest }

/// Class for downloading messages queue
// class DownloadMessageQueueData {
//   /// === message ID ===
//   final String msgID;

//   /// === message type ===
//   final int messageType;

//   /// === image type ===
//   final int imageType;

//   /// === value that check whether image is snapshot ===
//   final bool isSnapshot;

//   /// === message key, could be user ID or group ID ===
//   final String key; // userID or groupID

//   /// === conversation type ===
//   final int conversationType;

//   /// === current download size ===
//   int currentDownloadSize = 0;

//   /// === total message size ===
//   int totalSize = 0;

//   /// === is download finished ===
//   bool downloadFinish = false;

//   /// === download message's path ===
//   String? path;

//   /// === snapshot path ===
//   String? snapPath;

//   DownloadMessageQueueData({
//     required this.conversationType,
//     required this.key,
//     required this.msgID,
//     required this.messageType,
//     required this.imageType,
//     required this.isSnapshot,
//   });
// }

enum AudioPlayType {
  path,
  online,
}

/// Class for audio message
class AudioPlayInfo {
  /// === audio type ===
  final AudioPlayType type;

  /// === audio path ===
  final String path;

  /// === audio message ID ===
  final String msgID;

  /// === audio total seconds ===
  final int totalSecond;

  /// === conversation key ===
  final String convKey;

  /// === conversation type ===
  final int convType;

  AudioPlayInfo({
    required this.type,
    required this.path,
    required this.msgID,
    required this.totalSecond,
    required this.convKey,
    required this.convType,
  });
}

/// Class for sending message
class SendingMessageData {
  /// === message created ID ===
  final String createID;

  /// === sdk ID ===
  final String sdkID;

  /// === progress ===
  final int progress;

  /// === message ===
  final V2TimMessage message;

  /// === value if send message is completed ===
  final bool isSendComplete;

  SendingMessageData({
    required this.createID,
    required this.message,
    required this.progress,
    required this.sdkID,
    required this.isSendComplete,
  });

  Map<String, dynamic> toJson() {
    return Map.from({
      "createID": createID,
      "sdkID": sdkID,
      "progress": progress,
      "message-elemType": message.elemType,
      "isSendComplete": isSendComplete,
    });
  }
}

/// Class for message list status
class MessageListStatus {
  /// === value for having more previous message data ===
  bool haveMorePreviousData;

  /// === value for having more latest message data ===
  bool haveMoreLatestData;

  MessageListStatus({this.haveMorePreviousData = true, this.haveMoreLatestData = false});
}

/// Class for currently played audio information
class CurrentPlayAudioInfo {
  /// === progress ===
  final double progress;

  /// === audio info ===
  final AudioPlayInfo playInfo;

  /// === value for playing is completed ===
  final bool isCompleted;

  /// === value for audio is paused ===
  final bool isPaused;

  CurrentPlayAudioInfo({
    required this.progress,
    required this.playInfo,
    required this.isCompleted,
    required this.isPaused,
  });
}

// This class represents the message data and provides methods for updating and notifying listeners.
class TencentCloudChatMessageData<T> extends TencentCloudChatDataAB<T> {
  /// === tag ===
  final String _tag = "TencentCloudChatMessageData";

  /// === download message queue ===
  // final List<DownloadMessageQueueData> _downloadQueue = [];

  /// === removed download message queue ===
  // final List<DownloadMessageQueueData> _removedDownloadQueue = [];

  /// === currently downloading message ===
  List<DownloadMessageQueueData> _currentDownloadMessage = [];

  /// === Is downloading messages ===
  // bool _isDownloading = false;

  /// === current operating user ID ===
  String? currentOperateUserID;

  /// === current operating group ID ===
  String? currentOperateGroupID;

  /// === audio player ===
  AudioPlayer? player;

  /// === currently playing audio information ===
  CurrentPlayAudioInfo? _currentPlayAudioInfo;

  /// === audio information ===
  AudioPlayInfo? _audioPlayInfo;

  /// ==== TencentCloudChatMessageConfig ====
  TencentCloudChatMessageConfig messageConfig = TencentCloudChatMessageConfig();

  /// ==== Event Handlers ====
  TencentCloudChatMessageEventHandlers? messageEventHandlers;

  /// === Controller ===
  TencentCloudChatComponentBaseController? messageController;

  /// === Message Builder ===
  TencentCloudChatComponentBuilder? messageBuilder;

  /// === Message need update ===
  V2TimMessage? _messageNeedUpdate;

  V2TimMessage? get messageNeedUpdate => _messageNeedUpdate;

  set messageNeedUpdate(V2TimMessage? value) {
    _messageNeedUpdate = value;
    if (value != null) {
      notifyListener(TencentCloudChatMessageDataKeys.messageNeedUpdate as T);
    }
  }

  /// === user id set of user status change ===
  Set<String?> userStatusChangeSet = {};

  /// === friend user id set of friend info change ===
  Set<String?> friendInfoChangeSet = {};

  // Constructor for TencentCloudChatMessageData
  TencentCloudChatMessageData(super.currentUpdatedFields);

  /// ==== Init data and the listener ====
  void init() {
    TencentCloudChat.instance.chatSDKInstance.messageSDK.init(
      onRecvMessageReadReceipts: onReceiveMessageReadReceipts,
      onRecvNewMessage: onReceiveNewMessage,
      onMessageDownloadProgressCallback: TencentCloudChatDownloadUtils.handleDownloadProgressEvent,
      onSendMessageProgress: onSendMessageProgressFromSDK,
      onRecvMessageModified: onReceiveMessageModified,
      onRecvC2CReadReceipt: onReceiveC2CMessageReadReceipts,
      onRecvMessageRevoked: onReceiveMessageRecalled,
      onRecvMessageRevokedWithInfo: onRecvMessageRevokedWithInfo,
    );
    player = AudioPlayer();
    player!.setVolume(1);
    player!.onPlayerStateChanged.listen(
      (PlayerState state) {
        console(logs: "onPlayerStateChanged ${state.name}, messageID: ${_audioPlayInfo?.msgID}");
        if (state == PlayerState.playing) {
          updateCurrentAudioPlayInfo(isCompleted: false, progress: _currentPlayAudioInfo?.progress ?? 0, isPaused: false);
        } else if (state == PlayerState.paused) {
          updateCurrentAudioPlayInfo(isCompleted: false, progress: _currentPlayAudioInfo?.progress ?? 0, isPaused: true);
        } else if (state == PlayerState.stopped) {
          // When receiving this event, _currentPlayAudioInfo may be changed
          // No notifications should be sent at this time
        } else if (state == PlayerState.completed) {
          player!.seek(Duration.zero);
          updateCurrentAudioPlayInfo(isCompleted: true, progress: 1);
          Future.delayed(const Duration(milliseconds: 1500), () async {
            playNextAudio(_audioPlayInfo!.msgID);
          });
        }
      },
      onDone: () {
        console(logs: "onPlayerStateChanged onDone");
      },
      onError: (Object error) {
        console(logs: "onPlayerStateChanged $error");
      },
      cancelOnError: true,
    );
    player!.onPlayerComplete.listen(
      (event) {
        console(logs: "onPlayerComplete");
      },
      onDone: () {
        console(logs: "onPlayerComplete onDone");
      },
      onError: (Object error) {
        console(logs: "onPlayerComplete $error");
      },
      cancelOnError: true,
    );
    player!.onPositionChanged.listen(
      (event) {
        if (_audioPlayInfo != null) {
          if (_audioPlayInfo!.totalSecond != 0 && event.inMilliseconds != 0) {
            console(logs: "onPositionChanged (ms) ${event.inMilliseconds} / ${_audioPlayInfo!.totalSecond * 1000}, isPaused: ${player!.state == PlayerState.paused}, messageID: ${_audioPlayInfo?.msgID}");
            updateCurrentAudioPlayInfo(isCompleted: false, progress: event.inMilliseconds / (_audioPlayInfo!.totalSecond * 1000), isPaused: player!.state == PlayerState.paused);
          }
        }
      },
      onDone: () {
        console(logs: "onPositionChanged onDone");
      },
      onError: (Object error) {
        console(logs: "onPositionChanged $error");
      },
      cancelOnError: true,
    );
    TencentCloudChatDownloadUtils.init();
  }

  /// function for getting sending message progress
  onSendMessageProgressFromSDK(V2TimMessage message, int progress) {
    if (!kIsWeb) {
      onSendMessageProgress(
        message: message,
        progress: progress,
        isSendComplete: false,
      );
    }
  }

  /// ==== Message Read Receipt Map ====
  Map<String, V2TimMessageReceipt> _messageReadReceiptMap = {};

  Map<String, V2TimMessageReceipt> get messageReadReceiptMap => _messageReadReceiptMap;

  Map<String, SendingMessageData> _messageProgressData = {};

  Map<String, SendingMessageData> get messageProgressData => _messageProgressData;

  /// function for checking whether the conditions for automatically playing audio are satisfied
  bool checkAutoPlayConditions(String msgID) {
    return _audioPlayInfo != null && _currentPlayAudioInfo != null && _audioPlayInfo!.msgID == msgID && _currentPlayAudioInfo!.isCompleted;
  }

  /// function for playing next audio
  playNextAudio(String msgID) async {
    if (checkAutoPlayConditions(msgID)) {
      String convKey = _audioPlayInfo!.convKey;
      int convType = _audioPlayInfo!.convType;
      String msgID = _audioPlayInfo!.msgID;
      var messageList = getMessageList(key: convKey);
      var idx = messageList.indexWhere((element) => element.msgID == msgID);
      if (idx > -1) {
        var leftMessageList = messageList.getRange(0, idx).toList().reversed.toList();
        var nextIndex = leftMessageList.indexWhere((element) => element.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND);
        if (nextIndex > -1) {
          var nextSoundMessage = leftMessageList[nextIndex];
          if (nextSoundMessage.soundElem != null) {
            var soundElem = nextSoundMessage.soundElem!;
            late AudioPlayType type;
            String p = "";
            int totalSecond = soundElem.duration ?? 0;
            String nextMsgId = nextSoundMessage.msgID ?? "";
            if (TencentCloudChatUtils.checkString(soundElem.localUrl) != null || TencentCloudChatUtils.checkString(soundElem.path) != null) {
              type = AudioPlayType.path;
              if (TencentCloudChatUtils.checkString(soundElem.localUrl) != null) {
                p = soundElem.localUrl!;
              } else {
                p = soundElem.path!;
              }
            } else {
              type = AudioPlayType.online;
              var urlRes = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getMessageOnlineUrl(msgID: nextMsgId);
              if (urlRes != null) {
                if (urlRes.soundElem != null) {
                  if (TencentCloudChatUtils.checkString(urlRes.soundElem!.url) != null) {
                    p = urlRes.soundElem!.url!;
                  }
                }
              }
            }
            if (checkAutoPlayConditions(msgID) && p.isNotEmpty && totalSecond > 0 && nextMsgId.isNotEmpty) {
              console(logs: "start play next audio, messageID: $nextMsgId");
              await playAudio(source: AudioPlayInfo(type: type, path: p, msgID: nextMsgId, totalSecond: totalSecond, convKey: convKey, convType: convType));
            }
          }
        }
      }
    }
  }

  /// function for updating currently played audio information
  /// [progress] (required) progress of currently played audio
  /// [isCompleted] (required) whether currently played audio is finished
  /// [isPaused] (optional) whether currently played audio is paused
  updateCurrentAudioPlayInfo({
    required double progress,
    required bool isCompleted,
    bool? isPaused,
  }) {
    if (_audioPlayInfo != null) {
      _currentPlayAudioInfo = CurrentPlayAudioInfo(
        progress: progress,
        playInfo: _audioPlayInfo!,
        isCompleted: isCompleted,
        isPaused: isPaused ?? false,
      );
      notifyListener(TencentCloudChatMessageDataKeys.currentPlayAudioInfo as T);
    }
  }

  /// function for updating message read receipt
  /// [msgID] (required) message ID
  /// [receipt] (required) message read receipt
  void updateMessageReadReceipt({required String msgID, required V2TimMessageReceipt receipt}) {
    _messageReadReceiptMap[msgID] = receipt;
    notifyListener(TencentCloudChatMessageDataKeys.messageReadReceipts as T);
  }

  /// function for getting message read Receipt
  /// [msgID] (required) message ID
  /// [userID] (required) user ID
  /// [timestamp] (required) timestamp
  /// returns V2TimMessageReceipt as a result
  V2TimMessageReceipt getMessageReadReceipt({
    required String msgID,
    required String userID,
    required int timestamp,
  }) {
    return _messageReadReceiptMap.putIfAbsent(
      msgID,
      () => V2TimMessageReceipt(
        userID: userID,
        timestamp: timestamp,
        readCount: 0,
        unreadCount: 1,
      ),
    );
  }

  /// function for checking if audio is playing
  /// [msgID] (required) message ID
  /// returns a bool value
  bool isPlaying({
    required String msgID,
  }) {
    bool res = false;
    if (_audioPlayInfo != null) {
      if (_audioPlayInfo!.msgID == msgID) {
        if (player?.state == PlayerState.playing) {
          res = true;
        }
      }
    }
    return res;
  }

  /// function for checking if audio is paused
  /// [msgID] (required) message ID
  /// returns a bool value
  bool isPause({
    required String msgID,
  }) {
    bool res = false;
    if (_audioPlayInfo != null) {
      if (_audioPlayInfo!.msgID == msgID) {
        if (player?.state == PlayerState.paused) {
          res = true;
        }
      }
    }
    return res;
  }

  /// function for playing audio message
  /// [source] (required) audio message's source
  playAudio({
    required AudioPlayInfo source,
  }) async {
    if (player?.state == PlayerState.playing) {
      console(logs: "audio playing stop first, stop messageID: ${_audioPlayInfo?.msgID}");
      await player?.stop();
      updateCurrentAudioPlayInfo(isCompleted: false, progress: _currentPlayAudioInfo?.progress ?? 0, isPaused: true);
      player!.seek(Duration.zero);
      _audioPlayInfo = null;
      _currentPlayAudioInfo = null;
    }
    console(logs: "current messageID: ${source.msgID}, audio path: ${source.path}");

    var allowext = ["mp3", 'wav', 'm4a'];
    if (source.type == AudioPlayType.path) {
      File f = File(source.path);
      var type = source.path.split(".").last.toLowerCase();
      var typeArr = type.split('?');

      if (typeArr.isNotEmpty) {
        type = typeArr[0];
      }
      if (!allowext.contains(type)) {
        return console(logs: "the audio type:$type is not allowed ");
      }
      if (f.existsSync()) {
        _audioPlayInfo = source;
        _currentPlayAudioInfo = CurrentPlayAudioInfo(
          progress: 0,
          playInfo: source,
          isCompleted: false,
          isPaused: false,
        );
        console(logs: "start play audio, messageID: ${source.msgID}");
        await player?.play(DeviceFileSource(source.path));
      } else {
        console(logs: "audio play by path. path not exists");
      }
    } else {
      var type = source.path.split(".").last.toLowerCase();
      var typeArr = type.split('?');

      if (typeArr.isNotEmpty) {
        type = typeArr[0];
      }

      if (!allowext.contains(type)) {
        return console(logs: "the audio type:$type is not allowed ");
      }
      _audioPlayInfo = source;
      _currentPlayAudioInfo = CurrentPlayAudioInfo(
        progress: 0,
        playInfo: source,
        isCompleted: false,
        isPaused: false,
      );
      await player?.play(UrlSource(source.path));
    }
  }

  /// function for resuming audio
  resumeAudio() async {
    if (player?.state == PlayerState.paused) {
      console(logs: "audio resume, messageID: ${_audioPlayInfo?.msgID}");
      await player?.resume();
    } else {
      console(logs: "current state is ${player?.state.name}, no need to resume");
    }
  }

  /// function for pausing audio
  pauseAudio() async {
    if (player?.state == PlayerState.playing) {
      console(logs: "audio pause, messageID: ${_audioPlayInfo?.msgID}");
      await player?.pause();
    } else {
      console(logs: "current state is ${player?.state.name}, no need to pause");
    }
  }

  /// function for stop playing audio
  stopPlayAudio() async {
    try {
      if (player?.state == PlayerState.playing) {
        console(logs: "audio stop, messageID: ${_audioPlayInfo?.msgID}");
        await player?.stop();
        updateCurrentAudioPlayInfo(isCompleted: false, progress: _currentPlayAudioInfo?.progress ?? 0, isPaused: true);
        player!.seek(Duration.zero);
        _audioPlayInfo = null;
        _currentPlayAudioInfo = null;
      } else {
        console(logs: "current state is ${player?.state.name}, no need to stop");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  onSendMessageProgress({required V2TimMessage message, required int progress, required bool isSendComplete, String? id}) {
    String? createID = TencentCloudChatUtils.checkString(message.id) ?? id;
    if (TencentCloudChatUtils.checkString(createID) != null) {
      if (_messageProgressData[createID] == null || !_messageProgressData[createID]!.isSendComplete) {
        _messageProgressData[createID!] = SendingMessageData(
          createID: createID,
          message: message,
          sdkID: message.msgID ?? "",
          progress: progress,
          isSendComplete: isSendComplete,
        );

        notifyListener(TencentCloudChatMessageDataKeys.sendMessageProgress as T);
      }
    }
  }

  // Callback for receiving c2c message read receipts.
  void onReceiveC2CMessageReadReceipts(List<V2TimMessageReceipt> receiptList) {
    try {
      for (var receipt in receiptList) {
        final userID = receipt.userID;
        final messageList = _messageListMap[userID];
        final isNotEmpty = messageList?.isNotEmpty ?? false;
        if (isNotEmpty) {
          for (V2TimMessage element in messageList!) {
            final isSelf = element.isSelf ?? true;
            final isPeerRead = element.isPeerRead ?? false;
            if (isSelf && !isPeerRead) {
              element.isPeerRead = true;
            }
          }
          updateMessageList(messageList: messageList, userID: userID);
        }
      }
    } catch (_) {}
  }

  // Callback for receiving message read receipts.
  void onReceiveMessageReadReceipts(List<V2TimMessageReceipt> receiptList) {
    try {
      for (var receipt in receiptList) {
        final msgID = receipt.msgID;
        if (msgID != null) {
          _messageReadReceiptMap[msgID] = receipt;
        }
      }
      notifyListener(TencentCloudChatMessageDataKeys.messageReadReceipts as T);
      // ignore: empty_catches
    } catch (e) {}
  }

  /// Function for getting message read receipt
  getMsgReadReceipt(List<V2TimMessage> message) async {
    final msgIDs = message.where((e) => (e.isSelf ?? true) && (e.needReadReceipt ?? false)).map((e) => e.msgID ?? '').toList();
    if (msgIDs.isNotEmpty) {
      final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageReadReceipts(messageIDList: msgIDs);
      if (res.code == 0) {
        final receiptList = res.data;
        if (receiptList != null) {
          for (var item in receiptList) {
            _messageReadReceiptMap[item.msgID ?? ""] = item;
          }
        }
      }
      notifyListener(TencentCloudChatMessageDataKeys.messageReadReceipts as T);
    }
  }

  /// ==== Message List ====
  int maxMessageCount = 50;

  Map<String, List<V2TimMessage>> _messageListMap = {};

  Map<String, MessageListStatus> _messageListStatusMap = {};

  Map<String, List<V2TimMessage>> get messageListMap => _messageListMap;

  List<DownloadMessageQueueData> get currentDownloadMessage => _currentDownloadMessage;

  CurrentPlayAudioInfo? get currentPlayAudioInfo => _currentPlayAudioInfo;

  set messageListMap(Map<String, List<V2TimMessage>> value) {
    _messageListMap = value;
    notifyListener(TencentCloudChatMessageDataKeys.messageList as T);
  }

  // ignore: unnecessary_getters_setters
  Map<String, MessageListStatus> get messageListStatusMap => _messageListStatusMap;

  set messageListStatusMap(Map<String, MessageListStatus> value) {
    _messageListStatusMap = value;
  }

  /// function for getting message list status
  /// [userID] (optional)
  /// [groupID] (optional)
  /// returns MessageListStatus
  MessageListStatus getMessageListStatus({
    String? userID,
    String? groupID,
  }) {
    final key = TencentCloudChatUtils.checkString(groupID) ?? TencentCloudChatUtils.checkString(userID) ?? "";
    return _messageListStatusMap.putIfAbsent(key, () => MessageListStatus());
  }

  /// function for clearing message list status
  /// [userID] (optional) string
  /// [groupID] (optional) string
  /// message list status would be clear according to the sequence of groupID - userID
  clearMessageListStatus({
    String? userID,
    String? groupID,
  }) {
    final key = TencentCloudChatUtils.checkString(groupID) ?? TencentCloudChatUtils.checkString(userID) ?? "";
    _messageListStatusMap[key] = MessageListStatus();
  }

  /// function for getting message list
  /// [key] (optional) string
  /// returns list of V2TimMessage
  List<V2TimMessage> getMessageList({
    required String key,
  }) {
    final messageList = _messageListMap[key] ?? [];
    return messageList.toList();
  }

  void updateDownloadingMessage(List<DownloadMessageQueueData> currentDownload) {
    _currentDownloadMessage = currentDownload;
    notifyListener(TencentCloudChatMessageDataKeys.downloadMessage as T);
  }

  /// function for updating message list
  /// [userID] (optional) string
  /// [groupID] (optional) string
  /// [messageList] (required) List<V2TimMessage>
  /// [disableNotify] (optional) bool , default value is false
  void updateMessageList({
    String? userID,
    String? groupID,
    String? topicID,
    required List<V2TimMessage> messageList,
    bool disableNotify = false,
  }) {
    final userID0 = TencentCloudChatUtils.checkString(userID);
    final groupID0 = TencentCloudChatUtils.checkString(groupID);
    final topicID0 = TencentCloudChatUtils.checkString(topicID);
    _messageListMap[topicID0 ?? groupID0 ?? userID0 ?? ""] = messageList;

    if (!disableNotify) {
      notifyListener(
        TencentCloudChatMessageDataKeys.messageList as T,
        userID: userID0,
        groupID: topicID0 ?? groupID0,
      );
    }
  }

  void clearMessageList({String? userID, String? groupID}) {
    if (userID != null) {
      _messageListMap.remove(userID);
    } else if (groupID != null) {
      _messageListMap.remove(groupID);
    }

    notifyListener(
      TencentCloudChatMessageDataKeys.messageList as T,
      userID: userID,
      groupID: groupID,
    );
  }

  /// Callback for receiving message was modified
  /// function(V2TimMessage)
  void onReceiveMessageModified(V2TimMessage newMessage) {
    String conversationID = TencentCloudChatUtils.checkString(newMessage.groupID) ?? TencentCloudChatUtils.checkString(newMessage.userID) ?? "";
    List<V2TimMessage> messageList = getMessageList(key: conversationID);

    // Check if the message list already contains the new message.
    int index = messageList.indexWhere((element) => element.msgID == newMessage.msgID);

    if (index > -1) {
      messageList.replaceRange(index, index + 1, [newMessage]);
      // Update the message list in the data store.
      messageNeedUpdate = newMessage;

      updateMessageList(
        userID: newMessage.userID,
        groupID: newMessage.groupID,
        messageList: messageList,
        disableNotify: true,
      );
    }
  }

  /// Callback for receiving message was recalled
  /// function(V2TimMessage)
  void onReceiveMessageRecalled(String msgID) async {
    // replaced with onRecvMessageRevokedWithInfo
  }

  void onRecvMessageRevokedWithInfo(String msgID, V2TimUserFullInfo operateUser, String reason) async {
    final findRes = await TencentCloudChat.instance.chatSDKInstance.messageSDK.findMessages(msgIds: [msgID]);
    if (findRes.code == 0 && findRes.data != null && findRes.data!.isNotEmpty && findRes.data?.first != null) {
      final V2TimMessage targetMessage = findRes.data!.first;
      targetMessage.status = MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED;
      targetMessage.revokerInfo = operateUser;
      targetMessage.revokeReason = reason;

      String conversationID = TencentCloudChatUtils.checkString(targetMessage.groupID) ?? TencentCloudChatUtils.checkString(targetMessage.userID) ?? "";
      List<V2TimMessage> messageList = getMessageList(key: conversationID);
      // Check if the message list already contains the new message.
      int index = messageList.indexWhere((element) => element.msgID == targetMessage.msgID);
      if (index > -1) {
        messageList.replaceRange(index, index + 1, [targetMessage]);
        // Update the message list in the data store.
        updateMessageList(
          userID: targetMessage.userID,
          groupID: targetMessage.groupID,
          messageList: messageList,
          disableNotify: true,
        );

        messageNeedUpdate = targetMessage;
      }
    }
  }

  /// Callback for receiving new message
  /// function(V2TimMessage)
  void onReceiveNewMessage(V2TimMessage newMessage) {
    String conversationID = TencentCloudChatUtils.checkString(newMessage.groupID) ?? TencentCloudChatUtils.checkString(newMessage.userID) ?? "";
    List<V2TimMessage> messageList = getMessageList(key: conversationID);

    // Check if the message list already contains the new message.
    bool messageExists = messageList.any((message) => message.msgID == newMessage.msgID);

    if (!messageExists) {
      // If the new message is consecutive, add it to the list.
      if (!getMessageListStatus(userID: newMessage.userID, groupID: newMessage.groupID).haveMoreLatestData) {
        messageList.insert(0, newMessage);

        // Ensure the message list doesn't exceed the maximum message count.
        if (messageList.length > maxMessageCount) {
          messageList = messageList.take(maxMessageCount).toList();
          final key = TencentCloudChatUtils.checkString(newMessage.groupID) ?? TencentCloudChatUtils.checkString(newMessage.userID) ?? "";
          _messageListStatusMap[key]!.haveMorePreviousData = true;
        }

        // Update the message list in the data store.
        updateMessageList(userID: newMessage.userID, groupID: newMessage.groupID, messageList: messageList);
      }
    }
  }

  /// Callback for user status change
  /// function(V2TimMessage)
  void onUserStatusChanged(List<V2TimUserStatus> userStatusList) {
    userStatusChangeSet = userStatusList.map((e) => e.userID).toSet();

    notifyListener(TencentCloudChatMessageDataKeys.userStatusChange as T);
  }

  /// Callback for friend info change
  /// function(V2TimMessage)
  void onFriendInfoChanged(List<V2TimFriendInfo> friendInfoList) {
    friendInfoChangeSet = friendInfoList.map((e) => e.userID).toSet();

    notifyListener(TencentCloudChatMessageDataKeys.friendInfoChange as T);
  }

  /// Callback for network connect success
  /// function(V2TimMessage)
  void onConnectSuccess() {
    notifyListener(TencentCloudChatMessageDataKeys.networkConnectSuccess as T);
  }

  /// function for loading list to specific message
  /// [userID] (optional) string
  /// [groupID] (optional) string
  /// [count] (optional) int, default value is 20
  /// [msgID] (optional) string
  /// [timeStamp] (optional) int
  /// [seq] (optional) int
  /// Returns {[haveMoreLatestData],[haveMorePreviousData]} according to msgID, timestamp and seq
  Future<
      ({
        bool haveMoreLatestData,
        bool haveMorePreviousData,
        V2TimMessage? targetMessage,
      })> loadToSpecificMessage({
    String? userID,
    String? groupID,
    String? topicID,
    int count = 20,
    String? msgID,
    int? timeStamp,
    int? seq,
  }) async {
    assert((userID == null) != (groupID == null));

    final messageListStatus = getMessageListStatus(userID: userID, groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID);
    // Update the message list in the data store.
    List<V2TimMessage> messageList = getMessageList(
      key: (TencentCloudChatUtils.checkString(topicID) ?? TencentCloudChatUtils.checkString(groupID) ?? TencentCloudChatUtils.checkString(userID)) ?? "",
    );

    final contains = messageList.isNotEmpty ? messageList.any((element) => (element.msgID == msgID && TencentCloudChatUtils.checkString(msgID) != null)) ||
        (timeStamp != null && timeStamp > 0 && (messageList.last.timestamp ?? 0) > timeStamp && (messageList.first.timestamp ?? 0) < timeStamp) : false;

    final isGroup = TencentCloudChatUtils.checkString(groupID) != null;
    if (!contains) {
      if (TencentCloudChatPlatformAdapter().isWeb && TencentCloudChatUtils.checkString(userID) != null) {
        return (
          haveMoreLatestData: messageListStatus.haveMoreLatestData,
          haveMorePreviousData: messageListStatus.haveMorePreviousData,
          targetMessage: null,
        );
      }

      /// latest messages
      final latestMessageResponse = isGroup
          ? await TencentCloudChat.instance.chatSDKInstance.messageSDK.getHistoryMessageList(
              userID: userID,
              groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID,
              count: count,
              getType: HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_NEWER_MSG,
              lastMsgSeq: ((TencentCloudChatPlatformAdapter().isWeb || msgID == null) && seq != null) ? seq : -1,
              lastMsgID: (TencentCloudChatPlatformAdapter().isWeb && seq != null) ? null : msgID,
              timeBegin: (msgID == null && seq == null && timeStamp != null) ? timeStamp : null,
            )
          : await TencentCloudChat.instance.chatSDKInstance.messageSDK.getHistoryMessageList(
              userID: userID,
              groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID,
              count: count,
              getType: HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_NEWER_MSG,
              lastMsgID: (TencentCloudChatPlatformAdapter().isWeb && seq != null) ? null : msgID,
              timeBegin: (msgID == null && seq == null && timeStamp != null) ? timeStamp : null,
            );
      List<V2TimMessage> latestMessageList = latestMessageResponse.messageList.reversed.toList();
      if (TencentCloudChatUtils.checkString(groupID) != null) {
        getMsgReadReceipt(latestMessageList);
      }
      messageListStatus.haveMoreLatestData = !latestMessageResponse.isFinished;

      /// Previous messages
      List<V2TimMessage> previousMessageList = [];
      if (latestMessageList.isNotEmpty) {
        final previousMessageResponse = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getHistoryMessageList(
          userID: userID,
          groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID,
          count: count,
          lastMsgID: latestMessageList.last.msgID,
        );
        previousMessageList = previousMessageResponse.messageList;
        messageListStatus.haveMorePreviousData = !previousMessageResponse.isFinished;
      }

      List<V2TimMessage> finalMessageList = [...latestMessageList, ...previousMessageList];

      if (TencentCloudChatUtils.checkString(groupID) != null) {
        getMsgReadReceipt(finalMessageList);
      }

      if (finalMessageList.isNotEmpty) {
        updateMessageList(topicID: topicID, userID: userID, groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID, messageList: finalMessageList);
      }

      V2TimMessage? targetMessage = finalMessageList.firstWhereOrNull((element) => (element.msgID == msgID && TencentCloudChatUtils.checkString(msgID) != null));

      if (targetMessage == null && (timeStamp != null && timeStamp > 0) && msgID == null && (!isGroup || seq != null /**/)) {
        for (int i = finalMessageList.length - 1; i >= 0; i--) {
          final currentMessage = finalMessageList[i];
          if ((currentMessage.timestamp != null && currentMessage.timestamp! > 0) && TencentCloudChatUtils.checkString(currentMessage.msgID) != null) {
            if (currentMessage.timestamp! <= timeStamp) {
              continue;
            } else {
              targetMessage = finalMessageList[i];
              break;
            }
          }
        }
      }

      if (targetMessage == null && (seq != null && seq > 0)) {
        for (int i = finalMessageList.length - 1; i >= 0; i--) {
          final currentMessage = finalMessageList[i];
          if (TencentCloudChatUtils.checkString(currentMessage.seq) != null && TencentCloudChatUtils.checkString(currentMessage.msgID) != null) {
            if (currentMessage.seq! != seq.toString()) {
              continue;
            } else {
              targetMessage = finalMessageList[max(0, i - 1)];
              break;
            }
          }
        }
      }

      final TencentCloudChatPluginItem? reactionPlugin = TencentCloudChat.instance.dataInstance.basic.plugins.firstWhereOrNull((e) => e.name == "messageReaction");
      if (reactionPlugin != null) {
        await reactionPlugin.pluginInstance.callMethod(
            methodName: "getMessageReactions",
            data: json.encode({
              "msgIDList": finalMessageList.map((element) => element.msgID ?? "").toList(),
              "webMessageInstanceList": TencentCloudChatPlatformAdapter().isWeb ? finalMessageList.map((element) => element.messageFromWeb ?? "").toList() : [],
            }));
      }

      return (
        haveMoreLatestData: messageListStatus.haveMoreLatestData,
        haveMorePreviousData: previousMessageList.isNotEmpty ? messageListStatus.haveMorePreviousData : false,
        targetMessage: targetMessage,
      );
    } else {
      V2TimMessage? targetMessage = messageList.firstWhereOrNull((element) => (element.msgID == msgID && TencentCloudChatUtils.checkString(msgID) != null));

      if (targetMessage == null && (timeStamp != null && timeStamp > 0)) {
        for (int i = messageList.length - 1; i >= 0; i--) {
          final currentMessage = messageList[i];
          if ((currentMessage.timestamp != null && currentMessage.timestamp! > 0) && currentMessage.msgID != null) {
            if (currentMessage.timestamp! <= timeStamp) {
              continue;
            } else {
              targetMessage = messageList[max(0, i - 1)];
              break;
            }
          }
        }
      }

      if (targetMessage == null && (seq != null && seq > 0)) {
        for (int i = messageList.length - 1; i >= 0; i--) {
          final currentMessage = messageList[i];
          if (TencentCloudChatUtils.checkString(currentMessage.seq) != null && TencentCloudChatUtils.checkString(currentMessage.msgID) != null) {
            if (currentMessage.seq! != seq.toString()) {
              continue;
            } else {
              targetMessage = messageList[max(0, i - 1)];
              break;
            }
          }
        }
      }

      final TencentCloudChatPluginItem? reactionPlugin = TencentCloudChat.instance.dataInstance.basic.plugins.firstWhereOrNull((e) => e.name == "messageReaction");
      if (reactionPlugin != null) {
        await reactionPlugin.pluginInstance.callMethod(
            methodName: "getMessageReactions",
            data: json.encode({
              "msgIDList": messageList.map((element) => element.msgID ?? "").toList(),
              "webMessageInstanceList": TencentCloudChatPlatformAdapter().isWeb ? messageList.map((element) => element.messageFromWeb ?? "").toList() : [],
            }));
      }

      return (
        haveMoreLatestData: messageListStatus.haveMoreLatestData,
        haveMorePreviousData: messageListStatus.haveMorePreviousData,
        targetMessage: targetMessage,
      );
    }
  }

  /// function to load message list
  /// [userID] (optional) string
  /// [groupID] (optional) string
  /// [direction] (required) TencentCloudChatMessageLoadDirection
  /// [count] (optional) int, default value is 20
  /// [lastMsgID] (optional) string
  Future<bool> loadMessageList({
    String? userID,
    String? groupID,
    String? topicID,
    required TencentCloudChatMessageLoadDirection direction,
    int count = 20,
    String? lastMsgID,
    int? lastMsgSeq,
  }) async {
    assert((userID == null) != (groupID == null));
    // Load messages from the server.
    final response = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getHistoryMessageList(
      userID: userID,
      groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID,
      getType: direction == TencentCloudChatMessageLoadDirection.latest ? HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_NEWER_MSG : HistoryMsgGetTypeEnum.V2TIM_GET_CLOUD_OLDER_MSG,
      count: count,
      lastMsgID: (TencentCloudChatPlatformAdapter().isWeb && (lastMsgSeq ?? -1) > -1) ? null : lastMsgID,
      lastMsgSeq: lastMsgSeq ?? -1,
    );

    List<V2TimMessage> loadedMessages = response.messageList;
    if (TencentCloudChatPlatformAdapter().isWeb && direction == TencentCloudChatMessageLoadDirection.latest && (lastMsgSeq ?? -1) > -1) {
      loadedMessages.removeAt(0);
    }
    if (TencentCloudChatUtils.checkString(groupID) != null) {
      getMsgReadReceipt(loadedMessages);
    }

    // Update the message list in the data store.
    List<V2TimMessage> messageList = getMessageList(key: (TencentCloudChatUtils.checkString(topicID) ?? TencentCloudChatUtils.checkString(groupID) ?? TencentCloudChatUtils.checkString(userID)) ?? "");

    if (TencentCloudChatUtils.checkString(lastMsgID) == null) {
      messageList.clear();
      clearMessageListStatus(userID: userID, groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID);
    }

    if (direction == TencentCloudChatMessageLoadDirection.previous) {
      messageList.addAll(loadedMessages);
    } else {
      messageList.insertAll(0, loadedMessages.reversed);
    }

    // Ensure the message list doesn't exceed the maximum message count.
    if (messageList.length > maxMessageCount && !(TencentCloudChatPlatformAdapter().isWeb)) {
      final messageListStatus = getMessageListStatus(userID: userID, groupID: TencentCloudChatUtils.checkString(topicID) ?? groupID);
      int removeCount = messageList.length - maxMessageCount;
      final removeStart = direction == TencentCloudChatMessageLoadDirection.previous ? 0 : messageList.length - removeCount;
      final removeEnd = direction == TencentCloudChatMessageLoadDirection.previous ? removeCount : messageList.length;

      if (direction == TencentCloudChatMessageLoadDirection.latest && removeCount > 0) {
        messageListStatus.haveMorePreviousData = true;
      }

      if (direction == TencentCloudChatMessageLoadDirection.previous && removeCount > 0) {
        messageListStatus.haveMoreLatestData = true;
      }
      messageList.removeRange(removeStart, removeEnd);
    }

    TencentCloudChat.instance.logInstance.console(
        componentName: 'GetHistoryMessageListMessageData',
        logs:
            "updateMessageList -- conv: ${TencentCloudChatUtils.checkString(topicID) ?? groupID ?? userID} - needCount:$count - ResultLength:${loadedMessages.length} - Result:${loadedMessages.map((element) => element.toJson()).toList()}");

    final TencentCloudChatPluginItem? reactionPlugin = TencentCloudChat.instance.dataInstance.basic.plugins.firstWhereOrNull((e) => e.name == "messageReaction");
    if (reactionPlugin != null) {
      TencentCloudChat.instance.logInstance.console(
        componentName: 'getMessageReactions',
        logs: "webMessageInstanceList -- ${TencentCloudChatPlatformAdapter().isWeb ? loadedMessages.map((element) => element.messageFromWeb ?? "").toList() : []}",
      );
      await reactionPlugin.pluginInstance.callMethod(
          methodName: "getMessageReactions",
          data: json.encode({
            "msgIDList": loadedMessages.map((element) => element.msgID ?? "").toList(),
            "webMessageInstanceList": TencentCloudChatPlatformAdapter().isWeb ? loadedMessages.map((element) => element.messageFromWeb ?? "").toList() : [],
          }));
    }

    updateMessageList(
      topicID: topicID,
      userID: userID,
      groupID: groupID,
      messageList: messageList,
    );
    return TencentCloudChatPlatformAdapter().isWeb ? (response.messageList.isEmpty || response.isFinished) : response.isFinished;
  }

  /// ==== Message Highlight ====

  // The message ID of the currently highlighted message.
  V2TimMessage? _messageHighlighted;

  // Getter for the messageHighlighted property.
  V2TimMessage? get messageHighlighted => _messageHighlighted;

  // Setter for the messageHighlighted property.
  set messageHighlighted(V2TimMessage? value) {
    _messageHighlighted = value;
    console(logs: "Message highlighted changed. Current value is $_messageHighlighted");
    notifyListener(
      TencentCloudChatMessageDataKeys.messageHighlighted as T,
      userID: value?.userID,
      groupID: value?.groupID,
    );
  }

  /// function for updating local custom data in memory
  /// [msgID]  (required) string
  /// [data]  (required) string
  /// [key]  (required) string
  /// [convType] (required) int
  void updateLocalCustomDataInMemory({
    required String msgID,
    required String data,
    required String key,
    required int convType,
  }) {
    var msgList = getMessageList(key: key);
    var idx = msgList.indexWhere((element) => element.msgID == msgID);

    if (idx > -1) {
      var msg = msgList[idx];
      msg.localCustomData = data;
      var replacements = [msg];
      msgList.replaceRange(idx, (idx + 1), replacements);
      console(logs: "update memory local custom data success $idx $msgID $data");
      updateMessageList(
        messageList: msgList,
        userID: convType == ConversationType.V2TIM_C2C ? key : null,
        groupID: convType == ConversationType.V2TIM_GROUP ? key : null,
        disableNotify: true, // disable this time notify. use widget state .
      );
    }
  }

  /// function for updating currently downloading message's local url in memory
  /// [progress] V2TimMessageDownloadProgress
  // void updateMessageLocalUrlInMemory(V2TimMessageDownloadProgress progress) {
  //   String msgID = progress.msgID;
  //   if (_currentDownloadMessage != null) {
  //     String currentDownloadMsgID = _currentDownloadMessage!.msgID;
  //     if (currentDownloadMsgID == msgID) {
  //       var msgList = getMessageList(key: _currentDownloadMessage!.key);
  //       var idx = msgList.indexWhere((element) => element.msgID == msgID);
  //       if (idx > -1) {
  //         var msg = msgList[idx];
  //         // add local url
  //         if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_FILE) {
  //           if (msg.fileElem != null) {
  //             msg.fileElem!.localUrl = progress.path;
  //             TencentCloudChat.instance.logInstance.console(
  //               componentName: _tag,
  //               logs: "update memery file message local snanp path $msgID",
  //               logLevel: TencentCloudChatLogLevel.debug,
  //             );
  //           }
  //         } else if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
  //           if (msg.imageElem != null) {
  //             List<V2TimImage?> images = msg.imageElem!.imageList ?? [];
  //             for (var i = 0; i < images.length; i++) {
  //               V2TimImage? image = images[i];
  //               if (image != null) {
  //                 if (image.type == _currentDownloadMessage?.imageType) {
  //                   image.localUrl = progress.path;
  //                   TencentCloudChat.instance.logInstance.console(
  //                     componentName: _tag,
  //                     logs: "update memery image message local path $msgID",
  //                     logLevel: TencentCloudChatLogLevel.debug,
  //                   );
  //                 }
  //               }
  //             }
  //           }
  //         } else if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
  //           if (msg.soundElem != null) {
  //             msg.soundElem!.localUrl = progress.path;
  //             TencentCloudChat.instance.logInstance.console(
  //               componentName: _tag,
  //               logs: "update memery sound message local snanp path $msgID",
  //               logLevel: TencentCloudChatLogLevel.debug,
  //             );
  //           }
  //         } else if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
  //           if (msg.videoElem != null) {
  //             if (_currentDownloadMessage?.isSnapshot == true) {
  //               msg.videoElem!.localSnapshotUrl = progress.path;
  //               TencentCloudChat.instance.logInstance.console(
  //                 componentName: _tag,
  //                 logs: "update memery video message local snanp path $msgID",
  //                 logLevel: TencentCloudChatLogLevel.debug,
  //               );
  //             } else {
  //               msg.videoElem!.localVideoUrl = progress.path;
  //               TencentCloudChat.instance.logInstance.console(
  //                 componentName: _tag,
  //                 logs: "update memery video message local path $msgID",
  //                 logLevel: TencentCloudChatLogLevel.debug,
  //               );
  //             }
  //           }
  //         }
  //         var replacements = [msg];
  //         msgList.replaceRange(idx, (idx + 1), replacements);
  //         updateMessageList(
  //           messageList: msgList,
  //           userID: _currentDownloadMessage?.conversationType == ConversationType.V2TIM_C2C ? _currentDownloadMessage?.key : null,
  //           groupID: _currentDownloadMessage?.conversationType == ConversationType.V2TIM_GROUP ? _currentDownloadMessage?.key : null,
  //           disableNotify: true, // disable this time notify. use widget state .
  //         );
  //       }
  //     }
  //   }
  // }

  /// function for updating current downloading message progress
  /// after updating, function will notify listener [TencentCloudChatMessageDataKeys.downloadMessag]
  /// [progress] V2TimMessageDownloadProgress
  // void updateCurrentDownloadMessage(V2TimMessageDownloadProgress progress) {
  //   if (_currentDownloadMessage != null) {
  //     _currentDownloadMessage?.currentDownloadSize = progress.currentSize;
  //     _currentDownloadMessage?.totalSize = progress.totalSize;
  //     _currentDownloadMessage?.downloadFinish = progress.isFinish;
  //     if (progress.isFinish) {
  //       if (_currentDownloadMessage?.isSnapshot == true) {
  //         _currentDownloadMessage?.snapPath = progress.path;
  //       } else {
  //         _currentDownloadMessage?.path = progress.path;
  //       }
  //     }
  //     notifyListener(TencentCloudChatMessageDataKeys.downloadMessage as T);
  //   }
  // }

  // List<String> messageDownloadFinishedList = [];

  /// Callback for message downloading progress
  /// function(V2TimMessageDownloadProgress)
  // void onMessageDownload(V2TimMessageDownloadProgress progress) async {
  //   updateCurrentDownloadMessage(progress);
  //   if (!messageDownloadFinishedList.contains(progress.msgID) && progress.isFinish == true) {
  //     messageDownloadFinishedList.add(progress.msgID);
  //     _isDownloading = false;
  //     TencentCloudChat.instance.logInstance.console(
  //       componentName: _tag,
  //       logs: "${progress.msgID} isError ${progress.isError} download finished",
  //       logLevel: TencentCloudChatLogLevel.debug,
  //     );
  //     if (_downloadQueue.any((ele) => ele.msgID == progress.msgID)) {
  //       _downloadQueue.removeWhere((ele) => ele.msgID == progress.msgID);
  //     }
  //     updateMessageLocalUrlInMemory(progress);
  //     await Future.delayed(const Duration(seconds: 1));
  //     startDownload();
  //   }
  // }

  /// function for removing message from download queue
  /// [msgID] (required) string, messageID
  // removeFromDownloadQueue({
  //   required String msgID,
  // }) {
  //   int removeIndex = _removedDownloadQueue.indexWhere((element) => element.msgID == msgID);
  //   int currentIndex = _downloadQueue.indexWhere((element) => element.msgID == msgID);
  //   if (currentIndex > -1) {
  //     if (removeIndex == -1) {}
  //   }
  //   _removedDownloadQueue.add(_downloadQueue.firstWhere((element) => element.msgID == msgID));
  //   _downloadQueue.removeWhere((element) => element.msgID == msgID);
  //   TencentCloudChat.instance.logInstance.console(
  //     componentName: _tag,
  //     logs: "$msgID has been remove from download queue",
  //     logLevel: TencentCloudChatLogLevel.debug,
  //   );
  // }

  /// function for adding message to downloading queue
  /// [data] (required) DownloadMessageQueueData
  /// [isClick] (optional) bool
  // addDownloadMessageToQueue({
  //   required DownloadMessageQueueData data,
  //   bool? isClick,
  // }) {
  //   if (TencentCloudChat.instance.dataInstance.basic.userConfig.autoDownloadMultimediaMessage == true || isClick == true || data.isSnapshot == true) {
  //     int idx = _downloadQueue.indexWhere((element) => element.msgID == data.msgID);
  //     if (idx > -1) {
  //       TencentCloudChat.instance.logInstance.console(
  //         componentName: _tag,
  //         logs: "${data.msgID} is already add to the download queue",
  //         logLevel: TencentCloudChatLogLevel.debug,
  //       );
  //       return;
  //     }
  //     if (_currentDownloadMessage != null) {
  //       if (data.msgID == _currentDownloadMessage!.msgID && data.isSnapshot != true) {
  //         TencentCloudChat.instance.logInstance.console(
  //           componentName: _tag,
  //           logs: "${data.msgID} is downloading",
  //           logLevel: TencentCloudChatLogLevel.debug,
  //         );
  //         return;
  //       }
  //     }
  //     TencentCloudChat.instance.logInstance.console(
  //       componentName: _tag,
  //       logs: "${data.msgID} add message to the queue message type ${data.messageType}",
  //       logLevel: TencentCloudChatLogLevel.debug,
  //     );
  //     _downloadQueue.add(data);
  //     if (!_isDownloading) {
  //       startDownload();
  //     }
  //   } else {
  //     TencentCloudChat.instance.logInstance.console(
  //       componentName: _tag,
  //       logs: "download message end.",
  //       logLevel: TencentCloudChatLogLevel.debug,
  //     );
  //   }
  // }

  /// function for start downling data in downloading queue
  // startDownload() {
  //   if (_downloadQueue.isNotEmpty) {
  //     DownloadMessageQueueData readyToDownload = _downloadQueue.removeAt(0);
  //     _currentDownloadMessage = readyToDownload;
  //     downloadMessage(
  //       msgID: readyToDownload.msgID.replaceAll("-snap", ""), // replace snap
  //       messageType: readyToDownload.messageType,
  //       imageType: readyToDownload.imageType,
  //       isSnapshot: readyToDownload.isSnapshot,
  //     );
  //   } else {
  //     _currentDownloadMessage = null;
  //     TencentCloudChat.instance.logInstance.console(
  //       componentName: _tag,
  //       logs: "download message end.",
  //       logLevel: TencentCloudChatLogLevel.debug,
  //     );
  //     _isDownloading = false;
  //   }
  // }

  /// function for checking if message is downloading
  /// [msgID] (required) messageID
  /// returns bool value whether message is downloading
  // bool isDownloading({
  //   required msgID,
  // }) {
  //   return _currentDownloadMessage?.msgID == msgID;
  // }

  /// function for checking if message is in downloading queue
  /// [msgID] (required) messageID
  /// returns bool value whether message is in downloading queue
  // bool isInDownloadQueue({
  //   required msgID,
  // }) {
  //   return _downloadQueue.indexWhere((element) => element.msgID == msgID) > -1;
  // }

  // downloadMessage({
  //   required String msgID,
  //   required int messageType,
  //   required int imageType,
  //   required bool isSnapshot,
  // }) {
  //   _isDownloading = true;
  //   TencentCloudChat.instance.chatSDKInstance.manager.getMessageManager().downloadMessage(msgID: msgID, messageType: messageType, imageType: imageType, isSnapshot: isSnapshot).then((value) {
  //     if (value.code != 0) {
  //       _isDownloading = false;
  //       startDownload();
  //     }

  //     TencentCloudChat.instance.logInstance.console(
  //       componentName: _tag,
  //       logs: "start downlaod message ($msgID) ${value.toJson()}",
  //       logLevel: TencentCloudChatLogLevel.debug,
  //     );
  //   });
  // }

  /// ==== Common Functions ====

  // Convert the message data to a JSON object.
  @override
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({"messageHighlighted": _messageHighlighted});
  }

  @override
  void notifyListener(T key, {String? userID, String? groupID}) {
    var event = TencentCloudChatMessageData<T>(key);
    event.currentOperateUserID = userID;
    event.currentOperateGroupID = groupID;
    event._messageHighlighted = _messageHighlighted;
    event._messageListMap = _messageListMap;
    event._messageListStatusMap = _messageListStatusMap;
    event._messageNeedUpdate = _messageNeedUpdate;
    event._messageProgressData = _messageProgressData;
    event._messageReadReceiptMap = _messageReadReceiptMap;
    event._audioPlayInfo = _audioPlayInfo;
    event._currentPlayAudioInfo = _currentPlayAudioInfo;
    event._currentDownloadMessage = _currentDownloadMessage;
    event.userStatusChangeSet = userStatusChangeSet;
    event.friendInfoChangeSet = friendInfoChangeSet;

    TencentCloudChat.instance.eventBusInstance.fire(event, "TencentCloudChatMessageData");
  }

  @override
  void clear() {
    _currentDownloadMessage = [];
    currentOperateUserID = "";
    currentOperateGroupID = "";
    _currentPlayAudioInfo = null;
    _audioPlayInfo = null;
    _messageNeedUpdate = null;
    userStatusChangeSet.clear();
    friendInfoChangeSet.clear();
    _messageReadReceiptMap.clear();
    _messageProgressData.clear();
    _messageListMap.clear();
    _messageListStatusMap.clear();
    _messageHighlighted = null;
  }
}
