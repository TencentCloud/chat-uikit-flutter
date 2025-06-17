import 'dart:convert';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_clipboard/image_clipboard.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_download_utils.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_viewer/tencent_cloud_chat_message_videoplayer.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_image.dart';
import 'package:url_launcher/url_launcher.dart';

class TencentCloudChatMessageViewer extends StatefulWidget {
  final String convKey;
  final V2TimMessage message;
  final int convType;
  final bool isSending;

  const TencentCloudChatMessageViewer({
    super.key,
    required this.convKey,
    required this.message,
    required this.convType,
    required this.isSending,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatMessageViewerState();
}

class TencentCloudChatMessageViewerState extends State<TencentCloudChatMessageViewer> {
  final String _tag = "TencentCloudChatMessageViewer";
  List<V2TimMessage> messages = [];
  bool isLoading = true;
  late SwiperController controller;
  int index = 0;
  final Map<String, GlobalKey> _videoPlayerKeys = {};

  GlobalKey getVideoPlayerKey(String msgId) {
    return _videoPlayerKeys.putIfAbsent(msgId, () => GlobalKey());
  }

  getMessageFromCoreData({
    required String msgID,
  }) async {
    List<V2TimMessage> msgs = [];
    if (!widget.isSending) {
      var oldeRres = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getLocalMessageByElemType(
        lastMsgId: msgID,
        convKey: widget.convKey,
        convType: widget.convType,
      );
      var newRes = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getLocalMessageByElemType(
        lastMsgId: msgID,
        convKey: widget.convKey,
        convType: widget.convType,
        isNewer: true,
      );
      if (oldeRres.code == 0 && oldeRres.data != null) {
        var ordMessageList = oldeRres.data!.messageList;
        if (ordMessageList.isNotEmpty) {
          msgs = [...msgs, ...ordMessageList.reversed.toList()];
        }
      }
      var curMessageList = [widget.message];
      if (curMessageList.isNotEmpty) {
        msgs = [...msgs, ...curMessageList];
      }
      if (newRes.code == 0 && newRes.data != null) {
        var newMessageList = newRes.data!.messageList;
        if (newMessageList.isNotEmpty) {
          msgs = [...msgs, ...newMessageList];
        }
      }
    } else {
      var curMessageList = [widget.message];
      if (curMessageList.isNotEmpty) {
        msgs = [...msgs, ...curMessageList];
      }
    }

    setState(() {
      isLoading = false;
      if (msgs.isNotEmpty) {
        messages = msgs;
        int currentIndex = msgs.indexWhere((element) => element.msgID == (widget.message.msgID ?? ""));
        if (currentIndex > -1) {
          index = currentIndex;
        }
      }
    });
  }

  closeViewer() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    controller = SwiperController();
    getMessageFromCoreData(
      msgID: widget.message.msgID ?? "",
    );
  }

  (bool, String) getImageLocalUrl(V2TimImageElem imageElem) {
    String thumb = "";
    String origin = "";
    bool isOrigin = false;

    List<V2TimImage?> imageList = imageElem.imageList ?? [];
    for (var i = 0; i < imageList.length; i++) {
      var image = imageList[i];
      if (image != null) {
        if (image.type == ImageType.origin.index) {
          origin = TencentCloudChatUtils.checkString(imageElem.path) ?? TencentCloudChatUtils.checkString(image.localUrl) ?? "";
          isOrigin = true;
        }
        if (image.type == ImageType.thumb.index) {
          thumb = image.localUrl ?? "";
        }
      }
    }
    return (isOrigin, origin.isEmpty ? thumb : origin);
  }

  getImageOnlineOriginUrl(V2TimImageElem imageElem) {
    List<V2TimImage?> imageList = imageElem.imageList ?? [];
    return imageList.firstWhere((element) => element?.type == ImageType.origin.index)?.url;
  }

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: json.encode(
        {
          "msgID": widget.message.msgID ?? "",
          "log": log,
        },
      ),
    );
  }

  generateDownloadData({
    required int type,
    required int conversationType,
    required String key,
    V2TimMessage? message,
  }) {
    return DownloadMessageQueueData(
      conversationType: conversationType,
      msgID: message?.msgID ?? "",
      messageType: MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
      imageType: type,
      // download origin image
      isSnapshot: false,
      key: key,
      convID: key,
    );
  }

  addDownloadMessageToQueue({
    bool? isClick,
    bool? isSnap,
  }) {
    String key = widget.convKey;
    int conversationType = widget.convType;
    if (key.isEmpty) {
      console("add to download queue error. key is empty. ");
      return;
    }
    int type = ImageType.origin.index;

    TencentCloudChatDownloadUtils.addDownloadMessageToQueue(
      data: generateDownloadData(type: type, conversationType: conversationType, key: key),
    );
  }

  bool hasOriginLocalUrl() {
    if (isLoading || messages.isEmpty) {
      return true;
    }
    bool res = false;
    var message = messages[index];
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
      if (message.imageElem != null) {
        var imageList = message.imageElem!.imageList ?? [];
        var image = imageList.firstWhere((element) => element?.type == ImageType.origin.index, orElse: () => null);
        if (image != null) {
          if (TencentCloudChatUtils.checkString(image.localUrl) != null) {
            res = true;
          }
        }
      }
    }
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      if (message.videoElem != null) {
        if (TencentCloudChatUtils.checkString(message.videoElem!.localVideoUrl) != null) {
          res = true;
        }
      }
    }
    return res;
  }

  bool hasLeft() {
    bool res = false;
    if (messages.length > 1) {
      if (index > 0) {
        return true;
      }
    }
    return res;
  }

  hasRight() {
    bool res = false;
    if (messages.length > 1) {
      if (index < (messages.length - 1)) {
        return true;
      }
    }
    return res;
  }

  bool isVideo() {
    bool res = false;
    if (isLoading || messages.isEmpty) {
      return res;
    }
    var message = messages[index];
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      res = true;
    }
    return res;
  }

  isDownloading() {
    if (isLoading || messages.isEmpty) {
      return false;
    }
    var message = messages[index];

    String key = widget.convKey;
    int conversationType = widget.convType;
    if (key.isEmpty) {
      console("add to download queue error. key is empty. ");
      return;
    }
    int type = ImageType.origin.index;

    return TencentCloudChatDownloadUtils.isDownloading(
      data: generateDownloadData(
        type: type,
        conversationType: conversationType,
        key: key,
        message: message,
      ),
    );
  }

  final imageClipboard = ImageClipboard();

  copyImage(String filePath) async {
    bool isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
    final isOnlineImg = filePath.startsWith('http');
    String targetPath = filePath;
    File? localFile;
    if (isOnlineImg && isDesktop) {
      final response = await http.get(Uri.parse(filePath));
      final tempDir = await getTemporaryDirectory();
      localFile = File('${tempDir.path}/temp_image.jpg');
      await localFile.writeAsBytes(response.bodyBytes);
      targetPath = localFile.path;
    }
    await imageClipboard.copyImage(targetPath);
    TencentCloudChat.instance.callbacks.onUserNotificationEvent(
      TencentCloudChatComponentsEnum.message,
      TencentCloudChatCodeInfo.copyFileCompleted,
    );
    if (localFile != null) {
      localFile.deleteSync();
    }
  }

  saveImage(String filePath) async {
    try {
      final saveDirectory = await FilePicker.platform.getDirectoryPath();
      if (saveDirectory == null) {
        return;
      }
      final savePath = '$saveDirectory/${DateTime.now().millisecondsSinceEpoch}.png';
      if (filePath.startsWith('http')) {
        http.Response response = await http.get(Uri.parse(filePath));
        if (response.statusCode == 200) {
          File file = File(savePath);
          await file.writeAsBytes(response.bodyBytes);
          return TencentCloudChat.instance.callbacks.onUserNotificationEvent(
            TencentCloudChatComponentsEnum.message,
            TencentCloudChatCodeInfo.saveFileCompleted,
          );
        }
      } else {
        File sourceFile = File(filePath);
        if (sourceFile.existsSync()) {
          File destFile = File(savePath);
          await sourceFile.copy(destFile.path);
          return TencentCloudChat.instance.callbacks.onUserNotificationEvent(
            TencentCloudChatComponentsEnum.message,
            TencentCloudChatCodeInfo.saveFileCompleted,
          );
        }
      }
      TencentCloudChat.instance.callbacks.onUserNotificationEvent(
        TencentCloudChatComponentsEnum.message,
        TencentCloudChatCodeInfo.saveFileFailed,
      );
    } catch (e) {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent(
        TencentCloudChatComponentsEnum.message,
        TencentCloudChatCodeInfo.saveFileFailed,
      );
    }
  }

  copyOnlineUrl(String fileUrl) async {
    await Clipboard.setData(ClipboardData(text: fileUrl));
    TencentCloudChat.instance.callbacks.onUserNotificationEvent(
      TencentCloudChatComponentsEnum.message,
      TencentCloudChatCodeInfo.copyLinkSuccess,
    );
  }

  openUrlInNewWindow(String fileUrl) async {
    await launchUrl(Uri.parse(fileUrl));
  }

  handleContextMenu(int type, String data) {
    switch (type) {
      case 0:
        copyImage(data);
        break;
      case 1:
        saveImage(data);
        break;
      case 2:
        copyOnlineUrl(data);
        break;
      case 3:
        openUrlInNewWindow(data);
        break;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    double verticalPadding = h * 0.1;
    double horipadding = w * 0.1;
    double itemwidth = w * 0.9;
    var haslocalurl = hasOriginLocalUrl();
    var videomessage = isVideo();
    var isdownloading = isDownloading();
    double boxWid = 60;
    var bottom = (h / 2) + (boxWid / 2) - 40; // remove appbar height

    return GestureDetector(
      onTap: closeViewer,
      child: Container(
        color: Colors.black,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                        Padding(
                          padding: isDesktop
                              ? EdgeInsets.symmetric(
                                  vertical: verticalPadding,
                                  horizontal: horipadding,
                                )
                              : const EdgeInsets.all(0),
                          child: Swiper(
                            controller: controller,
                            itemBuilder: (BuildContext context, int index) {
                              V2TimMessage message = messages[index];
                              if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
                                if (message.imageElem != null) {
                                  if (widget.isSending) {
                                    var lp = message.imageElem!.path ?? "";
                                    if (lp.isNotEmpty) {
                                      return GestureDetector(
                                        onSecondaryTapDown: (details) {
                                          TencentCloudChatDesktopPopup.showColumnMenu(
                                            context: context,
                                            offset: Offset(details.globalPosition.dx, details.globalPosition.dy),
                                            items: [
                                              TencentCloudChatMessageGeneralOptionItem(
                                                  label: tL10n.copyImageContextMenuBtnText,
                                                  icon: Icons.copy_rounded,
                                                  onTap: ({Offset? offset}) async {
                                                    handleContextMenu(0, lp);
                                                  }),
                                              if (isDesktop)
                                                TencentCloudChatMessageGeneralOptionItem(
                                                    label: tL10n.saveToLocalContextMenuBtnText,
                                                    icon: Icons.save_alt_rounded,
                                                    onTap: ({Offset? offset}) async {
                                                      handleContextMenu(1, lp);
                                                    }),
                                            ],
                                          );
                                        },
                                        child: Image.file(
                                          File(lp),
                                        ),
                                      );
                                    }
                                  }
                                  var (isOrigin, local) = getImageLocalUrl(message.imageElem!);
                                  var originUrl = getImageOnlineOriginUrl(message.imageElem!);
                                  if (local.isNotEmpty) {
                                    return GestureDetector(
                                      onSecondaryTapDown: (details) {
                                        TencentCloudChatDesktopPopup.showColumnMenu(
                                          context: context,
                                          offset: Offset(details.globalPosition.dx, details.globalPosition.dy),
                                          items: [
                                            TencentCloudChatMessageGeneralOptionItem(
                                                label: tL10n.copyImageContextMenuBtnText,
                                                icon: Icons.copy_rounded,
                                                onTap: ({Offset? offset}) async {
                                                  handleContextMenu(0, local);
                                                }),
                                            if (isDesktop)
                                              TencentCloudChatMessageGeneralOptionItem(
                                                  label: tL10n.saveToLocalContextMenuBtnText,
                                                  icon: Icons.save_alt_rounded,
                                                  onTap: ({Offset? offset}) async {
                                                    handleContextMenu(1, local);
                                                  }),
                                            if (TencentCloudChatPlatformAdapter().isWeb && TencentCloudChatUtils.checkString(originUrl) != null)
                                              TencentCloudChatMessageGeneralOptionItem(
                                                  label: tL10n.openLinkContextMenuBtnText,
                                                  icon: Icons.laptop_windows_rounded,
                                                  onTap: ({Offset? offset}) async {
                                                    handleContextMenu(3, originUrl);
                                                  }),
                                          ],
                                        );
                                      },
                                      child: Image.file(
                                        File(local),
                                      ),
                                    );
                                  } else if (TencentCloudChatUtils.checkString(originUrl) != null) {
                                    return GestureDetector(
                                      onSecondaryTapDown: (details) {
                                        TencentCloudChatDesktopPopup.showColumnMenu(
                                          context: context,
                                          offset: Offset(details.globalPosition.dx, details.globalPosition.dy),
                                          items: [
                                            TencentCloudChatMessageGeneralOptionItem(
                                                label: tL10n.copyImageContextMenuBtnText,
                                                icon: Icons.copy_rounded,
                                                onTap: ({Offset? offset}) async {
                                                  handleContextMenu(0, originUrl);
                                                }),
                                            if (isDesktop)
                                              TencentCloudChatMessageGeneralOptionItem(
                                                  label: tL10n.saveToLocalContextMenuBtnText,
                                                  icon: Icons.save_alt_rounded,
                                                  onTap: ({Offset? offset}) async {
                                                    handleContextMenu(1, originUrl);
                                                  }),
                                            if (TencentCloudChatPlatformAdapter().isWeb)
                                              TencentCloudChatMessageGeneralOptionItem(
                                                  label: tL10n.openLinkContextMenuBtnText,
                                                  icon: Icons.laptop_windows_rounded,
                                                  onTap: ({Offset? offset}) async {
                                                    handleContextMenu(3, originUrl);
                                                  }),
                                          ],
                                        );
                                      },
                                      child: Image.network(
                                        originUrl,
                                      ),
                                    );
                                  }
                                }
                              } else if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
                                return TencentCloudChatMessageVideoPlayer(
                                  key: getVideoPlayerKey(message.msgID!),
                                  message: message,
                                  controller: true,
                                  isSending: widget.isSending,
                                );
                              }
                              return Center(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.white,
                                  child: Text(
                                    "need render $index",
                                  ),
                                ),
                              );
                            },
                            itemCount: messages.length,
                            scale: 1,
                            index: index,
                            loop: false,
                            onIndexChanged: (value) {
                              setState(() {
                                index = value;
                              });
                            },
                          ),
                        ),
                      if (TencentCloudChatPlatformAdapter().isDesktop && hasLeft())
                        Positioned(
                          left: 20,
                          bottom: bottom,
                          child: MouseRegion(
                            cursor: MouseCursor.uncontrolled,
                            child: GestureDetector(
                              onTap: () async {
                                await controller.previous();
                              },
                              child: Container(
                                width: boxWid,
                                height: boxWid,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(boxWid / 2),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_circle_left_outlined,
                                    size: boxWid * 0.6,
                                    color: Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (TencentCloudChatPlatformAdapter().isDesktop && hasRight())
                        Positioned(
                          right: 20,
                          bottom: bottom,
                          child: GestureDetector(
                            onTap: () async {
                              await controller.next();
                            },
                            child: Container(
                              width: boxWid,
                              height: boxWid,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(boxWid / 2),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  size: boxWid * 0.6,
                                  Icons.arrow_circle_right_outlined,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      // if (!haslocalurl && !videomessage)
                      //   Positioned(
                      //     bottom: 0,
                      //     left: 0,
                      //     child: TextButton(
                      //       onPressed: () {
                      //         addDownloadMessageToQueue(isClick: true);
                      //       },
                      //       child: Text(isdownloading ? tL10n.downloading : tL10n.viewFullImage),
                      //     ),
                      //   ),
                    ],
                  ),
          ),
        ),
      );
  }
}
