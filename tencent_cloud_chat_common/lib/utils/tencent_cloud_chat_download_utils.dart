import 'dart:async';
import 'dart:convert';

import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class DownloadMessageQueueData {
  /// === message ID ===
  final String msgID;

  /// === message type ===
  final int messageType;

  /// === image type ===
  final int imageType;

  /// === value that check whether image is snapshot ===
  final bool isSnapshot;

  /// === message key, could be user ID or group ID ===
  final String key; // userID or groupID

  /// === conversation type ===
  final int conversationType;

  /// === current download size ===
  int currentDownloadSize = 0;

  /// === total message size ===
  int totalSize = 0;

  /// === is download finished ===
  bool downloadFinish = false;

  /// === download message's path ===
  String? path;

  /// === snapshot path ===
  String? snapPath;

  final String convID;

  String getUniqueueKey() {
    return "${msgID}_${imageType}_$isSnapshot";
  }

  DownloadMessageQueueData({
    required this.convID,
    required this.conversationType,
    required this.key,
    required this.msgID,
    required this.messageType,
    required this.imageType,
    required this.isSnapshot,
  });
}

class TencentCloudChatDownloadUtils {
  static const String _tag = "TencentCloudChatDownloadUtils";
  static Map<String, List<DownloadMessageQueueData>> downloadQueue = {};
  static List<DownloadMessageQueueData> currentDownloadingList = [];
  static Timer? timmer;
  static init() {
    timmer = Timer.periodic(const Duration(seconds: 1), startDownload);
  }

  static disose() {
    if (timmer != null) {
      if (timmer!.isActive) {
        timmer!.cancel();
      }
    }
  }

  static void downloadMessage({
    required String msgID,
    required int messageType,
    required int imageType,
    required bool isSnapshot,
  }) {
    TencentCloudChat.instance.chatSDKInstance.manager
        .getMessageManager()
        .downloadMessage(
          msgID: msgID,
          messageType: messageType,
          imageType: imageType,
          isSnapshot: isSnapshot,
        )
        .then((value) {
      currentDownloadingList.removeWhere((ele) => ele.getUniqueueKey() == "${msgID}_${imageType}_$isSnapshot");
      if (value.code == 0) {
        console("start download message success ($msgID) ${value.toJson()}");
      } else {
        console("start download message failed ($msgID) ${value.toJson()}");
      }
    });
  }

  static bool isInDownloadQueue({
    required DownloadMessageQueueData data,
  }) {
    bool res = false;
    if (downloadQueue.containsKey(data.convID)) {
      if (downloadQueue[data.convID] != null) {
        List<DownloadMessageQueueData> queueData = downloadQueue[data.convID]!;
        if (queueData.isNotEmpty) {
          console(downloadQueue[data.convID]!.first.getUniqueueKey());
        }

        if (downloadQueue[data.convID]!.indexWhere((ele) => ele.getUniqueueKey() == data.getUniqueueKey()) > -1) {
          res = true;
        }
      }
    }
    console("${data.convID} ${data.getUniqueueKey()} is in download queue: $res");
    return res;
  }

  static bool isDownloading({
    required DownloadMessageQueueData data,
  }) {
    bool res = false;
    if (currentDownloadingList.indexWhere((ele) => ele.getUniqueueKey() == data.getUniqueueKey()) > -1) {
      res = true;
    }
    return res;
  }

  static List<String> messageDownloadFinishedList = [];

  static void updateCurrentDownloadMessage(V2TimMessageDownloadProgress progress) {
    String messageIdentfif = "${progress.msgID}_${progress.type}_${progress.isSnapshot}";

    int idx = currentDownloadingList.indexWhere((ele) => ele.getUniqueueKey() == messageIdentfif);
    if (idx > -1) {
      DownloadMessageQueueData currentProgressData = currentDownloadingList[idx];
      currentProgressData.currentDownloadSize = progress.currentSize;
      currentProgressData.totalSize = progress.totalSize;
      currentProgressData.downloadFinish = progress.isFinish;
      if (progress.isFinish) {
        if (currentProgressData.isSnapshot == true) {
          currentProgressData.snapPath = progress.path;
        } else {
          currentProgressData.path = progress.path;
        }
      }

      for (var i = 0; i < currentDownloadingList.length; i++) {
        console("update download progress ${currentDownloadingList[i].currentDownloadSize} ${currentDownloadingList[i].totalSize}");
      }
      TencentCloudChat.instance.dataInstance.messageData.updateDownloadingMessage(currentDownloadingList);
    }
  }

  static void handleDownloadProgressEvent(V2TimMessageDownloadProgress progress) {
    String messageIdentfif = "${progress.msgID}_${progress.type}_${progress.isSnapshot}";
    if (!messageDownloadFinishedList.contains(messageIdentfif) && progress.isFinish == true) {
      messageDownloadFinishedList.add(messageIdentfif);
      console("${progress.msgID} isError ${progress.isError} download finished");

      updateMessageLocalUrlInMemory(progress);
    }

    updateCurrentDownloadMessage(progress);
  }

  static void updateMessageLocalUrlInMemory(V2TimMessageDownloadProgress progress) {
    String messageIdentfif = "${progress.msgID}_${progress.type}_${progress.isSnapshot}";

    int idx = currentDownloadingList.indexWhere((ele) => ele.getUniqueueKey() == messageIdentfif);

    String msgID = progress.msgID;
    if (idx > -1) {
      DownloadMessageQueueData currentProgressData = currentDownloadingList[idx];
      String currentDownloadMsgID = currentProgressData.msgID;
      if (currentDownloadMsgID == msgID) {
        var msgList = TencentCloudChat.instance.dataInstance.messageData.getMessageList(key: currentProgressData.key);
        var idx = msgList.indexWhere((element) => element.msgID == msgID);
        if (idx > -1) {
          var msg = msgList[idx];
          // add local url
          if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_FILE) {
            if (msg.fileElem != null) {
              msg.fileElem!.localUrl = progress.path;
              console("update memery file message local snanp path $msgID");
            }
          } else if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
            if (msg.imageElem != null) {
              List<V2TimImage?> images = msg.imageElem!.imageList ?? [];
              for (var i = 0; i < images.length; i++) {
                V2TimImage? image = images[i];
                if (image != null) {
                  if (image.type == currentProgressData.imageType) {
                    image.localUrl = progress.path;
                    console("update memery image message local path $msgID");
                  }
                }
              }
            }
          } else if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
            if (msg.soundElem != null) {
              msg.soundElem!.localUrl = progress.path;
              console("update memery sound message local snanp path $msgID");
            }
          } else if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
            if (msg.videoElem != null) {
              if (currentProgressData.isSnapshot == true) {
                msg.videoElem!.localSnapshotUrl = progress.path;
                console("update memery video message local snanp path $msgID");
              } else {
                msg.videoElem!.localVideoUrl = progress.path;
                console("update memery video message local path $msgID");
              }
            }
          }
          var replacements = [msg];
          msgList.replaceRange(idx, (idx + 1), replacements);
          TencentCloudChat.instance.dataInstance.messageData.updateMessageList(
            messageList: msgList,
            userID: currentProgressData.conversationType == ConversationType.V2TIM_C2C ? currentProgressData.key : null,
            groupID: currentProgressData.conversationType == ConversationType.V2TIM_GROUP ? currentProgressData.key : null,
            disableNotify: true, // disable this time notify. use widget state .
          );

          TencentCloudChat.instance.dataInstance.messageData.messageNeedUpdate = msg;
        }
      }
    } else {
      console("updateMessageLocalUrlInMemory failed. no downloading message");
    }
  }

  static startDownload(Timer timer) {
    List<String> convIDs = downloadQueue.keys.toList();
    if (convIDs.isEmpty) {
      return;
    }
    for (var i = 0; i < convIDs.length; i++) {
      String convID = convIDs[i];
      if (downloadQueue.containsKey(convID)) {
        List<DownloadMessageQueueData> convDownloadList = downloadQueue[convID] ?? [];
        if (convDownloadList.isEmpty) {
          continue;
        }
        console("current download queue convIDs is ${json.encode(convIDs)}");
        int indexForConvID = currentDownloadingList.indexWhere((ele) => ele.convID == convID);
        if (indexForConvID > -1) {
          console("$convID has downloading message. break. the message is ${currentDownloadingList[indexForConvID].path}");
          continue;
        }
        if (convDownloadList.isNotEmpty) {
          DownloadMessageQueueData downloaddata = convDownloadList.removeAt(0);
          downloadQueue[convID] = convDownloadList;
          currentDownloadingList.add(downloaddata);
          downloadMessage(
            msgID: downloaddata.msgID,
            messageType: downloaddata.messageType,
            imageType: downloaddata.imageType,
            isSnapshot: downloaddata.isSnapshot,
          );
        } else {
          console("$convID has no message waiting for download");
        }
      }
    }
  }

  static void console(String logs) {
    TencentCloudChat.instance.logInstance.console(componentName: _tag, logs: logs);
  }

  static String genrateUniqueDownloadMessageKey({
    required String msgID,
    required int imageType,
    required bool isSnap,
  }) {
    return "${msgID}_${imageType}_$isSnap";
  }

  static void addDownloadMessageToQueue({
    required DownloadMessageQueueData data,
  }) {
    if (downloadQueue.containsKey(data.convID)) {
      if (downloadQueue[data.convID] != null) {
        int idx = downloadQueue[data.convID]!.indexWhere((element) => element.getUniqueueKey() == data.getUniqueueKey());
        if (idx > -1) {
          console("${data.getUniqueueKey()} is already add to the download queue");
          return;
        }
      }
    } else {
      downloadQueue[data.convID] = [];
    }
    int curDownloadingIdx = currentDownloadingList.indexWhere((ele) => ele.getUniqueueKey() == data.getUniqueueKey());
    if (curDownloadingIdx > -1) {
      console("${data.msgID} is downloading");
      return;
    }
    downloadQueue[data.convID]!.add(data);

    console("add ${data.msgID} to the download queue. message type ${data.messageType}");
  }

  static void removeFromDownloadQueue({
    required DownloadMessageQueueData data,
  }) {
    if (downloadQueue.containsKey(data.convID)) {
      if (downloadQueue[data.convID] != null) {
        downloadQueue[data.convID]!.removeWhere((ele) => ele.getUniqueueKey() == data.getUniqueueKey());
        console("remove ${data.getUniqueueKey()} from download queue success");
      }
    } else {
      console("the ${data.getUniqueueKey()} is not add to download. pealse check");
    }
  }
}
