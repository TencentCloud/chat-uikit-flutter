import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_download_utils.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_permission_handlers.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/file_icon/tencent_cloud_chat_file_icon.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item.dart';

enum TimFileCurrentRenderType {
  online,
  local,
  path,
}

class TimFileCurrentRenderInfo {
  final TimFileCurrentRenderType type;
  final String path;

  TimFileCurrentRenderInfo({
    required this.path,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return Map.from({
      "path": path,
      "type": type.name,
    });
  }
}

class TencentCloudChatMessageFile extends TencentCloudChatMessageItemBase {
  const TencentCloudChatMessageFile({
    super.key,
    required super.data,
    required super.methods,
  });

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageFileState();
}

class _TencentCloudChatMessageFileState extends TencentCloudChatMessageState<TencentCloudChatMessageFile> {
  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData<dynamic>>("TencentCloudChatMessageData");
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? __messageDataSubscription;

  final String _tag = "TencentCloudChatMessageFile";

  bool isErrorMessage = false;

  int renderRandom = Random().nextInt(100000);

  bool _webDownloading = false;

  TimFileCurrentRenderInfo? currentRenderSoundInfo;

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: json.encode(
        {
          "msgID": widget.data.message.msgID,
          "log": log,
        },
      ),
    );
  }

  DownloadMessageQueueData generateDownloadData({
    required int type,
    required int conversationType,
    required String key,
    V2TimMessage? message,
  }) {
    message ??= widget.data.message;
    return DownloadMessageQueueData(
      conversationType: conversationType,
      msgID: message.msgID ?? "",
      messageType: MessageElemType.V2TIM_ELEM_TYPE_FILE,
      imageType: type,
      // download origin image
      isSnapshot: false,
      key: key,
      convID: key,
    );
  }

  addDownloadMessageToQueue() {
    if (hasLocalFile()) {
      console("has local url. download break");
      return;
    }
    if (isSendingMessage()) {
      console("message is sending. download break");
      return;
    }
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return;
      }
      TencentCloudChatDownloadUtils.addDownloadMessageToQueue(
        data: generateDownloadData(type: 0, conversationType: conversationType, key: key),
      );
    }
  }

  bool isSendingMessage() {
    if (widget.data.message.status == 1) {
      return true;
    }
    return false;
  }

  bool hasSelfClientPath() {
    if (widget.data.message.fileElem != null) {
      if (TencentCloudChatUtils.checkString(widget.data.message.fileElem!.path) != null) {
        return true;
      }
    }
    return false;
  }

  bool hasLocalFile() {
    bool res = false;
    if (widget.data.message.fileElem != null) {
      V2TimFileElem fileElement = widget.data.message.fileElem!;
      String localUrl = "";

      if (TencentCloudChatUtils.checkString(fileElement.localUrl) != null) {
        localUrl = fileElement.localUrl!;
        console(localUrl);
      }

      if (localUrl.isNotEmpty) {
        res = true;
      }
    }
    if (currentdownload?.path != null && currentdownload?.downloadFinish == true) {
      res = true;
    }
    return res;
  }

  getLocalUrl() {
    if (TencentCloudChatUtils.checkString(widget.data.message.fileElem!.localUrl) == null) {
      if (currentdownload != null) {
        return currentdownload?.path;
      }
    }
    return widget.data.message.fileElem!.localUrl!;
  }

  getLocalPath() {
    return widget.data.message.fileElem!.path!;
  }

  getFileUrl() async {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      // check if exits local url. if not get online url
      bool hasLocal = hasLocalFile();
      bool isSending = isSendingMessage();
      bool hasClientPath = hasSelfClientPath();
      if (hasLocal) {
        safeSetState(() {
          currentRenderSoundInfo = TimFileCurrentRenderInfo(path: getLocalUrl(), type: TimFileCurrentRenderType.local);
        });
        return;
      }

      if (isSending && hasClientPath) {
        safeSetState(() {
          currentRenderSoundInfo = TimFileCurrentRenderInfo(path: getLocalPath(), type: TimFileCurrentRenderType.path);
        });
        return;
      }
      V2TimMessageOnlineUrl? data = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getMessageOnlineUrl(msgID: widget.data.message.msgID!);
      if (data == null) {
        safeSetState(() {
          isErrorMessage = true;
        });
      } else {
        if (data.fileElem != null) {
          if (TencentCloudChatUtils.checkString(data.fileElem!.url) != null) {
            safeSetState(() {
              currentRenderSoundInfo = TimFileCurrentRenderInfo(path: data.fileElem!.url!, type: TimFileCurrentRenderType.online);
            });
          } else {
            safeSetState(() {
              isErrorMessage = true;
            });
          }
        } else {
          safeSetState(() {
            isErrorMessage = true;
          });
        }
      }
    } else {
      safeSetState(() {
        isErrorMessage = true;
      });
    }
  }

  getFileExt() {
    String ext = '';
    if (widget.data.message.fileElem != null) {
      String fileName = widget.data.message.fileElem!.fileName ?? "";
      if (fileName.isNotEmpty) {
        return fileName.split(".").last;
      }
    }
    return ext;
  }

  fileIconWidget(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    String ext = getFileExt();
    return TencentCloudChatFileIcon(
      size: getSquareSize(22),
      fileFormat: ext,
      padding: const EdgeInsets.all(0),
    );
  }

  fileNameWidget(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    var fileName = '';
    if (widget.data.message.fileElem != null) {
      fileName = widget.data.message.fileElem!.fileName ?? "";
    }
    var ext = getFileExt();
    fileName = fileName.replaceAll(".$ext", "");
    if (fileName.length > 10) {
      fileName = "${fileName.substring(0, 8)}...";
    }
    return Expanded(
      child: Container(
        height: getHeight(22),
        padding: EdgeInsets.symmetric(horizontal: getSquareSize(4)),
        child: Row(
          children: [
            Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorTheme.secondaryTextColor,
                fontSize: textStyle.fontsize_14,
              ),
            ),
            Expanded(
              child: Text(
                ".$ext",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorTheme.secondaryTextColor,
                  fontSize: textStyle.fontsize_14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renderFileWidget(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle, bool isErrpr, TimFileCurrentRenderInfo? renderInfo) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      child: Container(
        padding: EdgeInsets.all(getSquareSize(12)),
        decoration: BoxDecoration(
          color: colorTheme.dividerColor,
          borderRadius: BorderRadius.all(
            Radius.circular(getSquareSize(8)),
          ),
        ),
        child: Row(
          children: [
            fileIconWidget(colorTheme, textStyle),
            fileNameWidget(colorTheme, textStyle),
            if (!TencentCloudChatPlatformAdapter().isWeb) _clientDownloadStatus(colorTheme, textStyle),
            if (TencentCloudChatPlatformAdapter().isWeb) _webDownloadStatus(colorTheme, textStyle),
          ],
        ),
      ),
    );
  }

  int onTapDownTime = 0;

  onTapDown(TapDownDetails details) {
    if (!widget.data.inSelectMode) {
      onTapDownTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  onTapUp(TapUpDetails details) {
    if (widget.data.inSelectMode) {
      return;
    }
    int onTapUpTime = DateTime.now().millisecondsSinceEpoch;
    if (onTapUpTime - onTapDownTime > 300 && onTapDownTime > 0) {
      console("tap to long break.");
      return;
    }
    if (widget.data.renderOnMenuPreview) {
      return;
    }
    onTapDownTime = 0;
    _openFile();
  }

  void _downloadWebFile(String fileUrl) async {
    safeSetState(() {
      _webDownloading = true;
    });
    String fileName = Uri.parse(fileUrl).pathSegments.last;
    try {
      http.Response response = await http.get(
        Uri.parse(fileUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      final html.AnchorElement downloadAnchor = html.document.createElement('a') as html.AnchorElement;

      final html.Blob blob = html.Blob([response.bodyBytes]);

      downloadAnchor.href = html.Url.createObjectUrlFromBlob(blob);
      downloadAnchor.download = widget.data.message.fileElem?.fileName ?? fileName;

      downloadAnchor.click();
    } catch (e) {
      html.AnchorElement(
        href: widget.data.message.fileElem?.path ?? "",
      )
        ..setAttribute("download", widget.data.message.fileElem?.fileName ?? fileName)
        ..setAttribute("target", '_blank')
        ..style.display = "none"
        ..click();
    }
    safeSetState(() {
      _webDownloading = false;
    });
  }

  _openFile() async {
    if (TencentCloudChatPlatformAdapter().isWeb) {
      if (!_webDownloading) {
        _downloadWebFile(widget.data.message.fileElem?.path ?? "");
      }
      return;
    }

    if (TencentCloudChatPlatformAdapter().isAndroid) {
      final DeviceInfoPlugin packageInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await packageInfo.androidInfo;
      if ((androidInfo.version.sdkInt) <= 32) {
        if (!await TencentCloudChatPermissionHandler.checkPermission('storage', context)) {
          return;
        }
      }
    }

    if (widget.data.message.status == 1) {
      if (TencentCloudChatUtils.checkString(widget.data.message.fileElem!.path) != null) {
        if (File(widget.data.message.fileElem!.path!).existsSync()) {
          return await OpenFile.open(widget.data.message.fileElem!.path!);
        }
      }
    }

    if (TencentCloudChatUtils.checkString(getLocalPath()) != null) {
      return await OpenFile.open(getLocalPath());
    } else if (hasLocalFile()) {
      return await OpenFile.open(getLocalUrl());
    } else {
      console("message has not local path . download first");
    }
  }

  Widget messageInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(0),
          topRight: const Radius.circular(0),
          bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
          bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (sentFromSelf) messageStatusIndicator(),
          messageTimeIndicator(
            textColor: Colors.white,
          ),
          SizedBox(
            width: getWidth(8),
          ),
        ],
      ),
    );
  }

  DownloadMessageQueueData? currentdownload;

  downloadCallback(TencentCloudChatMessageData data) {
    if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.downloadMessage) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }

      int idx = data.currentDownloadMessage.indexWhere((ele) => ele.getUniqueueKey() == generateDownloadData(type: 0, conversationType: conversationType, key: key).getUniqueueKey());

      if (idx > -1) {
        safeSetState(() {
          currentdownload = data.currentDownloadMessage[idx];
        });
      }
    }
  }

  void addDownloadListener() {
    __messageDataSubscription = _messageDataStream?.listen(downloadCallback);
  }

  bool isDownloading() {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      return TencentCloudChatDownloadUtils.isDownloading(data: generateDownloadData(type: 0, conversationType: conversationType, key: key));
    }
    return false;
  }

  bool isInDownloadQueue() {
    if (TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      return TencentCloudChatDownloadUtils.isInDownloadQueue(data: generateDownloadData(type: 0, conversationType: conversationType, key: key));
    }
    return false;
  }

  removeFromDownloadQueue() {
    bool inQueue = isInDownloadQueue();
    if (inQueue == true && TencentCloudChatUtils.checkString(widget.data.message.msgID) != null) {
      String key = TencentCloudChatUtils.checkString(widget.data.message.userID) ?? widget.data.message.groupID ?? "";
      int conversationType = TencentCloudChatUtils.checkString(widget.data.message.userID) == null ? ConversationType.V2TIM_GROUP : ConversationType.V2TIM_C2C;
      if (key.isEmpty) {
        console("add to download queue error. key is empty.");
        return false;
      }
      TencentCloudChatDownloadUtils.removeFromDownloadQueue(data: generateDownloadData(type: 0, conversationType: conversationType, key: key));
      safeSetState(() {
        renderRandom = Random().nextInt(10000);
      });
    }
  }

  Widget getDownloadingWidget({
    required double progress,
    bool? inQueue,
    required TencentCloudChatThemeColors colorTheme,
    required TencentCloudChatTextStyle textStyle,
  }) {
    if (progress == 0) {
      return SizedBox(
        width: getSquareSize(22),
        height: getSquareSize(22),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
    return GestureDetector(
      onTap: removeFromDownloadQueue,
      child: SizedBox(
        width: getSquareSize(22),
        height: getSquareSize(22),
        child: CircularProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(colorTheme.primaryColor),
          strokeWidth: 2,
        ),
      ),
    );
  }

  bool isCurrentFileOpen() {
    return false;
  }

  Widget _webDownloadStatus(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    return _webDownloading
        ? getDownloadingWidget(
            progress: 0,
            colorTheme: colorTheme,
            textStyle: textStyle,
          )
        : Container();
  }

  Widget _clientDownloadStatus(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    if (isSendingMessage()) {
      return SizedBox(
        height: getHeight(22),
        width: getWidth(22),
        child: const CircularProgressIndicator(
          strokeWidth: 1,
        ),
      );
    }

    Widget needDownload = GestureDetector(
      onTap: () {
        addDownloadMessageToQueue();
        setState(() {
          renderRandom = Random().nextInt(100000);
        });
      },
      child: Icon(
        Icons.download_for_offline_outlined,
        color: colorTheme.secondaryTextColor,
        weight: getSquareSize(20),
      ),
    );

    late Widget finalRenderDownloadStatusWidget;

    if (hasLocalFile() || currentdownload?.downloadFinish == true) {
      return SizedBox(
        height: getHeight(22),
        width: getWidth(22),
      );
    } else {
      if (isDownloading()) {
        finalRenderDownloadStatusWidget = getDownloadingWidget(
          progress: currentdownload == null ? 0 : (currentdownload!.downloadFinish ? 1 : (currentdownload!.currentDownloadSize / (currentdownload!.totalSize == 0 ? 1 : currentdownload!.totalSize))),
          colorTheme: colorTheme,
          textStyle: textStyle,
        );
      } else if (isInDownloadQueue()) {
        finalRenderDownloadStatusWidget = getDownloadingWidget(
          progress: 0,
          colorTheme: colorTheme,
          textStyle: textStyle,
        );
      } else {
        finalRenderDownloadStatusWidget = needDownload;
      }
    }

    return finalRenderDownloadStatusWidget;
  }

  String getCurrentFileFileSize() {
    int fileSizeInKB = 0;
    if (widget.data.message.fileElem != null) {
      fileSizeInKB = widget.data.message.fileElem!.fileSize ?? 0;
    }
    fileSizeInKB = (fileSizeInKB / 1024).floor();
    if (fileSizeInKB < 1024) {
      return '$fileSizeInKB KB';
    } else if (fileSizeInKB < 1024 * 1024) {
      double fileSizeInMB = fileSizeInKB / 1024;
      return '${fileSizeInMB.toStringAsFixed(2)} MB';
    } else {
      double fileSizeInGB = fileSizeInKB / (1024 * 1024);
      return '${fileSizeInGB.toStringAsFixed(2)} GB';
    }
  }

  double generateFileUILength() {
    return getWidth(200);
  }

  @override
  void initState() {
    super.initState();
    getFileUrl();
    if (!TencentCloudChatPlatformAdapter().isWeb) {
      addDownloadListener();
    }
  }

  @override
  void dispose() {
    super.dispose();
    __messageDataSubscription?.cancel();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      String fileSize = getCurrentFileFileSize();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(8)),
        decoration: BoxDecoration(
          color: showHighlightStatus ? colorTheme.info : (sentFromSelf ? colorTheme.selfMessageBubbleColor : colorTheme.othersMessageBubbleColor),
          border: Border.all(
            color: sentFromSelf ? colorTheme.selfMessageBubbleBorderColor : colorTheme.othersMessageBubbleBorderColor,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getSquareSize(16)),
            topRight: Radius.circular(getSquareSize(16)),
            bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
            bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: renderFileWidget(colorTheme, textStyle, isErrorMessage, currentRenderSoundInfo),
                )
              ],
            ),
            SizedBox(
              height: getHeight(8),
            ),
            Row(
              mainAxisAlignment: sentFromSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        fileSize,
                        style: TextStyle(
                          color: const Color(0XFF7A7A7A),
                          fontSize: textStyle.fontsize_12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (sentFromSelf) messageStatusIndicator(),
                messageTimeIndicator(),
              ],
            ),
            messageReactionList(),
          ],
        ),
      );
    });
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      String fileSize = getCurrentFileFileSize();
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(8)),
          decoration: BoxDecoration(
            color: showHighlightStatus ? colorTheme.info : (sentFromSelf ? colorTheme.selfMessageBubbleColor : colorTheme.othersMessageBubbleColor),
            border: Border.all(
              color: sentFromSelf ? colorTheme.selfMessageBubbleBorderColor : colorTheme.othersMessageBubbleBorderColor,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSquareSize(16)),
              topRight: Radius.circular(getSquareSize(16)),
              bottomLeft: Radius.circular(getSquareSize(sentFromSelf ? 16 : 0)),
              bottomRight: Radius.circular(getSquareSize(sentFromSelf ? 0 : 16)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: renderFileWidget(colorTheme, textStyle, isErrorMessage, currentRenderSoundInfo),
                  )
                ],
              ),
              SizedBox(
                height: getHeight(8),
              ),
              Row(
                mainAxisAlignment: sentFromSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          fileSize,
                          style: TextStyle(
                            color: const Color(0XFF7A7A7A),
                            fontSize: textStyle.fontsize_12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (sentFromSelf) messageStatusIndicator(),
                  messageTimeIndicator(),
                ],
              ),
              messageReactionList(),
            ],
          ),
        ),
      );
    });
  }
}
