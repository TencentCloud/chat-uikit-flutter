import 'dart:convert';

import 'package:tencent_cloud_chat/chat_sdk/tencent_cloud_chat_sdk.dart';
import 'package:tencent_cloud_chat/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';

class TencentCloudChatMessageSDK {
  static const String _tag = "TencentCloudChatMessageSDK";

  // Private constructor to implement the singleton pattern.
  TencentCloudChatMessageSDK._internal();

  // Factory constructor that returns the singleton instance of TencentCloudChatMessageSDK.
  factory TencentCloudChatMessageSDK() => _instance;
  static final TencentCloudChatMessageSDK _instance = TencentCloudChatMessageSDK._internal();

  /// ==== Init data and the listener ====
  V2TimAdvancedMsgListener? advancedMsgListener;

  void init({
    OnRecvC2CReadReceiptCallback? onRecvC2CReadReceipt,
    OnRecvMessageRevokedCallback? onRecvMessageRevoked,
    OnRecvNewMessageCallback? onRecvNewMessage,
    OnSendMessageProgressCallback? onSendMessageProgress,
    OnRecvMessageModified? onRecvMessageModified,
    OnRecvMessageReadReceipts? onRecvMessageReadReceipts,
    OnRecvMessageExtensionsChanged? onRecvMessageExtensionsChanged,
    OnRecvMessageExtensionsDeleted? onRecvMessageExtensionsDeleted,
    OnMessageDownloadProgressCallback? onMessageDownloadProgressCallback,
  }) {
    advancedMsgListener ??= V2TimAdvancedMsgListener(
      onRecvMessageReadReceipts: onRecvMessageReadReceipts,
      onRecvNewMessage: onRecvNewMessage,
      onMessageDownloadProgressCallback: onMessageDownloadProgressCallback,
      onSendMessageProgress: onSendMessageProgress,
      onRecvMessageModified: onRecvMessageModified,
      onRecvMessageRevoked: onRecvMessageRevoked,
    );
    TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(listener: advancedMsgListener!);
  }

  Future<V2TimMessageListResult> getHistoryMessageList({
    HistoryMsgGetTypeEnum getType = HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
    String? userID,
    String? groupID,
    int lastMsgSeq = -1,
    required int count,
    String? lastMsgID,
    List<int>? messageTypeList,
    List<int>? messageSeqList,
    int? timeBegin,
    int? timePeriod,
    bool needCache = true,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().getHistoryMessageListV2(
          count: count,
          getType: getType,
          userID: userID,
          groupID: groupID,
          lastMsgID: lastMsgID,
          lastMsgSeq: lastMsgSeq,
          messageTypeList: messageTypeList,
          messageSeqList: messageSeqList,
          timeBegin: timeBegin,
          timePeriod: timePeriod,
        );
    final response = res.data;
    TencentCloudChat.logInstance.console(
        componentName: 'GetHistoryMessageList',
        logs: "getHistoryMessageListResult -- conv: ${groupID ?? userID} - needCount:$count - needCache: $needCache - ResultLength:${res.data?.messageList.length} - period: $timePeriod - begin: $timeBegin");

    if (res.code != 0 || response == null) {
      var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
      TencentCloudChat.logInstance.console(
        componentName: componentName,
        logs: "getHistoryMessageList - ${res.desc}",
        logLevel: TencentCloudChatLogLevel.error,
      );
    }
    if (needCache) {
      if (TencentCloudChatUtils.checkString(lastMsgID) == null && timeBegin == null && lastMsgSeq == -1) {
        if (response != null) {
          if (response.messageList.isNotEmpty) {
            String key = userID == null ? "group_$groupID" : "c2c_$userID";

            TencentCloudChat.cache.cacheMessageListByConvKey(response.messageList, key);
          }
        }
      }
    }

    return (res.code == 0 && response != null) ? response : V2TimMessageListResult(isFinished: true, messageList: []);
  }

  Future<V2TimMsgCreateInfoResult?> createTextMessage({
    required String text,
    required List<String> mentionedUsers,
  }) async {
    final res = mentionedUsers.isNotEmpty
        ? await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextAtMessage(
              text: text,
              atUserList: mentionedUsers,
            )
        : await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextMessage(text: text);
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: "createTextMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createImageMessage({
    required String imagePath,
    required String imageName,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createImageMessage(imagePath: imagePath, imageName: imageName);
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: "createImageMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createFileMessage({
    required String filePath,
    required String fileName,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createFileMessage(filePath: filePath, fileName: fileName);
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: "createFileMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createVideoMessage({
    required String videoFilePath,
    required String type,
    required String snapshotPath,
    required int duration,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createVideoMessage(
          videoFilePath: videoFilePath,
          type: type,
          duration: duration,
          snapshotPath: snapshotPath,
        );
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: "createVideoMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createVoiceMessage({
    required String voicePath,
    required int duration,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createSoundMessage(
          duration: duration,
          soundPath: voicePath,
        );
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: "createVoiceMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createForwardIndividuallyMessage({
    required String msgID,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createForwardMessage(msgID: msgID);
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: "createForwardIndividuallyMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createForwardCombinedMessage({
    required List<String> msgIDList,
    required String title,
    required List<String> abstractList,
    required String compatibleText,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createMergerMessage(
          msgIDList: msgIDList,
          title: title,
          abstractList: abstractList,
          compatibleText: compatibleText,
        );
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: "createForwardCombinedMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimValueCallback<V2TimMessage>> sendMessage({
    required String id,
    String? userID,
    String? groupID,
    MessagePriorityEnum priority = MessagePriorityEnum.V2TIM_PRIORITY_NORMAL,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    bool needReadReceipt = false,
    OfflinePushInfo? offlinePushInfo,
    String? cloudCustomData,
    String? localCustomData,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
          id: id,
          receiver: userID ?? "",
          groupID: groupID ?? "",
          priority: priority,
          onlineUserOnly: onlineUserOnly,
          offlinePushInfo: offlinePushInfo,
          needReadReceipt: needReadReceipt,
          localCustomData: localCustomData,
          cloudCustomData: cloudCustomData,
        );
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: "sendMessage - ${result.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return result;
  }

  static Future<V2TimMessageOnlineUrl?> getMessageOnlineUrl({
    required String msgID,
  }) async {
    V2TimValueCallback<V2TimMessageOnlineUrl> urlRes = await TencentCloudChatSDK.manager.getMessageManager().getMessageOnlineUrl(msgID: msgID);

    if (urlRes.code == 0) {
      return urlRes.data;
    }
    TencentCloudChat.logInstance.console(
      componentName: _tag,
      logs: "get message online url failed . res is ${urlRes.toJson()}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<List<V2TimMessage>> deleteMessagesForEveryone({
    required List<V2TimMessage> messages,
  }) async {
    List<V2TimMessage> resultList = [];

    for (final message in messages) {
      // Step 1: Modify Message
      final originCloudCustomDataString = TencentCloudChatUtils.checkString(message.cloudCustomData) ?? "{}";
      dynamic cloudCustomData;
      try {
        cloudCustomData = jsonDecode(originCloudCustomDataString);
      } catch (e) {
        cloudCustomData = {};
      }

      cloudCustomData["deleteForEveryone"] = true;
      message.cloudCustomData = jsonEncode(cloudCustomData);
      V2TimValueCallback<V2TimMessageChangeInfo> modifyMessageRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().modifyMessage(message: message);

      TencentCloudChat.logInstance.console(
        componentName: _tag,
        logs: "deleteMessageForEveryone - ${modifyMessageRes.desc}",
        logLevel: TencentCloudChatLogLevel.error,
      );
      if (modifyMessageRes.code == 0) {
        resultList.add(message);
      }

      // Step 2: Recall Message
      final revokeRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().revokeMessage(msgID: message.msgID ?? "");
      if (modifyMessageRes.code != 0 && revokeRes.code == 0) {
        resultList.add(message);
      }
    }

    // Step 3: Delete Message
    TencentImSDKPlugin.v2TIMManager.getMessageManager().deleteMessages(
      msgIDs: resultList.map((e) => e.msgID ?? "").toList(),
      webMessageInstanceList: [],
    );

    return resultList;
  }

  Future<V2TimCallback?> deleteMessagesForMe({
    required List<String> msgIDs,
  }) async {
    V2TimCallback deleteMessagesRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().deleteMessages(
      msgIDs: msgIDs,
      webMessageInstanceList: [],
    );
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: "deleteMessagesForMe - ${deleteMessagesRes.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return deleteMessagesRes;
  }

  Future<V2TimValueCallback<List<V2TimMessage>>> findMessages({
    required List<String> msgIds,
  }) async {
    return await TencentImSDKPlugin.v2TIMManager.getMessageManager().findMessages(messageIDList: msgIds);
  }

  static Future<V2TimValueCallback<V2TimMessageListResult>> getLocalMessageByElemType({
    required String lastMsgId,
    bool? isNewer,
    required int convType,
    required String convKey,
  }) async {
    return await TencentImSDKPlugin.v2TIMManager.getMessageManager().getHistoryMessageListV2(
          groupID: convType == ConversationType.V2TIM_GROUP ? convKey : null,
          userID: convType == ConversationType.V2TIM_C2C ? convKey : null,
          count: 10,
          messageTypeList: [MessageElemType.V2TIM_ELEM_TYPE_IMAGE, MessageElemType.V2TIM_ELEM_TYPE_VIDEO],
          lastMsgID: lastMsgId,
          getType: isNewer == true ? HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_NEWER_MSG : HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
        );
  }

  static Future<void> setLocalCustomData({
    required String msgID,
    required String key,
    required String value,
    required String currentValue,
    required String convKey,
    required int convType,
    required String setType,
    required String currentMemoreyMsgId,
  }) async {
    var data = Map<String, dynamic>.from({});
    if (currentValue.isNotEmpty) {
      try {
        var current = json.decode(currentValue);
        data.addAll(current as Map<String, dynamic>);
      } catch (err) {
        TencentCloudChat.logInstance.console(
          componentName: _tag,
          logs: "decode current localCustomData failed. current value is $currentValue please check. $err",
          logLevel: TencentCloudChatLogLevel.error,
        );
      }
    }
    if (key.isNotEmpty && value.isNotEmpty) {
      data.addAll({
        key: value,
      });
    }
    String local = json.encode(data);
    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .setLocalCustomData(
          msgID: msgID,
          localCustomData: local,
        )
        .then((res) {
      TencentCloudChat().dataInstance.messageData.updateLocalCustomDataInMemory(
            msgID: currentMemoreyMsgId,
            data: local,
            key: convKey,
            convType: convType,
          );
      TencentCloudChat.logInstance.console(
        componentName: _tag,
        logs: "$msgID set localCustomData finish key:$key value:$value setType:$setType all data is ${json.encode(data)}",
        logLevel: TencentCloudChatLogLevel.debug,
      );
    });
  }

  static Future<List<V2TimMessage>> getMergeMessages({required String msgID}) async {
    V2TimValueCallback<List<V2TimMessage>> res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().downloadMergerMessage(msgID: msgID);
    if (res.code == 0) {
      return res.data ?? [];
    }
    return [];
  }

  static Future<V2TimCallback> clearC2CHistoryMessage({required String userID}) async {
    V2TimCallback clearC2CHistoryMessageRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearC2CHistoryMessage(userID: userID);
    return clearC2CHistoryMessageRes;
  }
}
