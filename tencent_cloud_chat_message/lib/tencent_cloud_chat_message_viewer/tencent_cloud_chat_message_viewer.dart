// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_viewer/tencent_cloud_chat_message_videoplayer.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_image.dart';

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

  (bool, String) getImageLocalurl(V2TimImageElem imageElem) {
    String thumb = "";
    String origin = "";
    bool isOrigin = false;

    List<V2TimImage?> imageList = imageElem.imageList ?? [];
    for (var i = 0; i < imageList.length; i++) {
      var image = imageList[i];
      if (image != null) {
        if (image.type == ImageType.origin.index) {
          origin = image.localUrl ?? "";
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

    TencentCloudChat.instance.dataInstance.messageData.addDownloadMessageToQueue(
      data: DownloadMessageQueueData(
        conversationType: conversationType,
        msgID: widget.message.msgID ?? "",
        messageType: MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
        imageType: type,
        // download origin image
        isSnapshot: false,
        key: key,
      ),
      isClick: isClick,
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

    return TencentCloudChat.instance.dataInstance.messageData.isDownloading(msgID: message.msgID);
  }

  @override
  Widget build(BuildContext context) {
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
      onDoubleTap: () {},
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0),
        body: SafeArea(
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
                      Positioned(
                        child: Padding(
                          padding: TencentCloudChatPlatformAdapter().isDesktop
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
                                      console("view sending path");
                                      return Image.file(
                                        File(lp),
                                      );
                                    }
                                  }
                                  var (isOrigin, local) = getImageLocalurl(message.imageElem!);
                                  var originOrl = getImageOnlineOriginUrl(message.imageElem!);
                                  if (local.isNotEmpty) {
                                    console("view local url is origin $isOrigin");
                                    return Image.file(
                                      File(local),
                                    );
                                  }

                                  if (TencentCloudChatUtils.checkString(originOrl) != null) {
                                    console("view online origin url");
                                    return Image.network(
                                      originOrl,
                                    );
                                  }
                                }
                              } else if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
                                return TencentCloudChatMessageVideoPlayer(
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
      ),
    );
  }
}
