import 'dart:convert';

import 'package:tencent_cloud_chat/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimUIKitListener.dart';

class TencentCloudChatMessageSDKGenerator {
  static TencentCloudChatMessageSDK getInstance() {
    return TencentCloudChatMessageSDK._();
  }
}

class TencentCloudChatMessageSDK {
  static const String _tag = "TencentCloudChatMessageSDK";

  TencentCloudChatMessageSDK._();

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
    OnRecvMessageReactionsChanged? onRecvMessageReactionsChanged,
    OnMessageDownloadProgressCallback? onMessageDownloadProgressCallback,
    OnRecvMessageRevoked? onRecvMessageRevokedWithInfo,
  }) {
    if (advancedMsgListener != null) {
      TencentImSDKPlugin.v2TIMManager.getMessageManager().removeAdvancedMsgListener(listener: advancedMsgListener!);
      advancedMsgListener = null;
    }
    advancedMsgListener = V2TimAdvancedMsgListener(
      onRecvMessageReadReceipts: onRecvMessageReadReceipts,
      onRecvNewMessage: (V2TimMessage msg) {
        onRecvNewMessage?.call(msg);

        TencentCloudChat.instance.dataInstance.conversation.unhideConversation(userID: msg.userID, groupID: msg.groupID);
      },
      onMessageDownloadProgressCallback: onMessageDownloadProgressCallback,
      onSendMessageProgress: onSendMessageProgress,
      onRecvMessageModified: onRecvMessageModified,
      onRecvMessageRevoked: onRecvMessageRevoked,
      onRecvC2CReadReceipt: onRecvC2CReadReceipt,
      onRecvMessageReactionsChanged: onRecvMessageReactionsChanged,
      onRecvMessageExtensionsChanged: onRecvMessageExtensionsChanged,
      onRecvMessageExtensionsDeleted: onRecvMessageExtensionsDeleted,
      onRecvMessageRevokedWithInfo: onRecvMessageRevokedWithInfo,
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
    TencentCloudChat.instance.logInstance.console(
      componentName: 'GetHistoryMessageList',
      logs:
          "getHistoryMessageListResult -- conv: ${groupID ?? userID} - needCount:$count - ResultLength:${res.data?.messageList.length} - period: $timePeriod - begin: $timeBegin - lastMsgID:$lastMsgID - lastMsgSeq:$lastMsgSeq",
    );

    if (res.code != 0 || response == null) {
      var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
      TencentCloudChat.instance.logInstance.console(
        componentName: componentName,
        logs: "getHistoryMessageList - ${res.desc}",
        logLevel: TencentCloudChatLogLevel.error,
      );
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
    TencentCloudChat.instance.logInstance.console(
      componentName: componentName,
      logs: "createTextMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createFaceMessage({
    required int index,
    required String name,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createFaceMessage(index: index, data: name);
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.instance.logInstance.console(
      componentName: componentName,
      logs: "createFaceMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createImageMessage({
    String? imagePath,
    String? imageName,
    dynamic inputElement,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createImageMessage(
          imagePath: imagePath ?? "",
          imageName: imageName,
          inputElement: inputElement,
        );
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.instance.logInstance.console(
      componentName: componentName,
      logs: "createImageMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createFileMessage({
    String? filePath,
    String? fileName,
    dynamic inputElement,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createFileMessage(
          filePath: filePath ?? "",
          fileName: fileName ?? "",
          inputElement: inputElement,
        );
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.instance.logInstance.console(
      componentName: componentName,
      logs: "createFileMessage - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimMsgCreateInfoResult?> createVideoMessage({
    required String videoFilePath,
    required String type,
    String? snapshotPath,
    required int duration,
    dynamic inputElement,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createVideoMessage(
          videoFilePath: videoFilePath,
          type: type,
          inputElement: inputElement,
          duration: duration,
          snapshotPath: snapshotPath ?? "",
        );
    if (res.code == 0) {
      final messageResult = res.data;
      return messageResult;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.instance.logInstance.console(
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
    TencentCloudChat.instance.logInstance.console(
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
    TencentCloudChat.instance.logInstance.console(
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
    TencentCloudChat.instance.logInstance.console(
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
    TencentCloudChat.instance.logInstance.console(
      componentName: componentName,
      logs: "sendMessage - ${result.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return result;
  }

  Future<V2TimValueCallback<V2TimMessage>> reSendMessage({required String msgID}) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getMessageManager().reSendMessage(msgID: msgID);
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.instance.logInstance.console(
      componentName: componentName,
      logs: "reSendMessage - ${result.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return result;
  }

  Future<V2TimMessageOnlineUrl?> getMessageOnlineUrl({
    required String msgID,
  }) async {
    V2TimValueCallback<V2TimMessageOnlineUrl> urlRes =
        await TencentCloudChat.instance.chatSDKInstance.manager.getMessageManager().getMessageOnlineUrl(msgID: msgID);

    if (urlRes.code == 0) {
      return urlRes.data;
    }
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: "get message online url failed . res is ${urlRes.toJson()}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  Future<V2TimCallback?> deleteMessagesForMe({
    required List<String> msgIDs,
    required List<dynamic> webMessageInstanceList,
  }) async {
    V2TimCallback deleteMessagesRes = await TencentImSDKPlugin.v2TIMManager.getMessageManager().deleteMessages(
          msgIDs: msgIDs,
          webMessageInstanceList: webMessageInstanceList,
        );
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.instance.logInstance.console(
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

  Future<V2TimValueCallback<V2TimMessageListResult>> getLocalMessageByElemType({
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
          getType: isNewer == true
              ? HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_NEWER_MSG
              : HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
        );
  }

  Future<void> setLocalCustomData({
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
        TencentCloudChat.instance.logInstance.console(
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
      TencentCloudChat.instance.dataInstance.messageData.updateLocalCustomDataInMemory(
        msgID: currentMemoreyMsgId,
        data: local,
        key: convKey,
        convType: convType,
      );
      TencentCloudChat.instance.logInstance.console(
        componentName: _tag,
        logs:
            "$msgID set localCustomData finish key:$key value:$value setType:$setType all data is ${json.encode(data)}",
        logLevel: TencentCloudChatLogLevel.debug,
      );
    });
  }

  Future<List<V2TimMessage>> getMergeMessages({required String msgID}) async {
    V2TimValueCallback<List<V2TimMessage>> res =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().downloadMergerMessage(msgID: msgID);
    if (res.code == 0) {
      return res.data ?? [];
    }
    return [];
  }

  Future<V2TimCallback> clearC2CHistoryMessage({required String userID}) async {
    V2TimCallback clearC2CHistoryMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearC2CHistoryMessage(userID: userID);
    return clearC2CHistoryMessageRes;
  }

  String addUIKitListener({
    required var listener,
  }) {
    String id = TencentImSDKPlugin.v2TIMManager.addUIKitListener(
      listener: V2TimUIKitListener(
        onUiKitEventEmit: listener,
      ),
    );
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: "addUIKitListener $id",
      logLevel: TencentCloudChatLogLevel.debug,
    );
    return id;
  }

  void removeUIKitListener({
    required String listenerID,
  }) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: "removeUIKitListener $listenerID",
      logLevel: TencentCloudChatLogLevel.debug,
    );
    TencentImSDKPlugin.v2TIMManager.removeUIKitListener(uuid: listenerID);
  }
}
