import 'dart:convert';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_message_sdk.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_viewer/tencent_cloud_chat_message_videoplayer.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_image.dart';

class ZoomPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  ZoomPageRoute({
    required this.builder,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );
          },
        );
}

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
      var oldeRres = await TencentCloudChatMessageSDK.getLocalMessageByElemType(
        lastMsgId: msgID,
        convKey: widget.convKey,
        convType: widget.convType,
      );
      var newRes = await TencentCloudChatMessageSDK.getLocalMessageByElemType(
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
        if (image.type == TimImageType.origin.index) {
          origin = image.localUrl ?? "";
          isOrigin = true;
        }
        if (image.type == TimImageType.thumb.index) {
          thumb = image.localUrl ?? "";
        }
      }
    }
    return (isOrigin, origin.isEmpty ? thumb : origin);
  }

  getImageOnlineStumbUrl(V2TimImageElem imageElem) {
    List<V2TimImage?> imageList = imageElem.imageList ?? [];
    return imageList.firstWhere((element) => element?.type == TimImageType.thumb.index)?.url;
  }

  console(String log) {
    TencentCloudChat.logInstance.console(
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
    int type = TimImageType.origin.index;

    TencentCloudChat().dataInstance.messageData.addDownloadMessageToQueue(
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
        var image = imageList.firstWhere((element) => element?.type == TimImageType.origin.index, orElse: () => null);
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

    return TencentCloudChat().dataInstance.messageData.isDownloading(msgID: message.msgID);
  }

  @override
  Widget build(BuildContext context) {
    var haslocalurl = hasOriginLocalUrl();
    var videomessage = isVideo();
    var isdownloading = isDownloading();
    return GestureDetector(
      onTap: closeViewer,
      onDoubleTap: () {},
      child: Scaffold(
        backgroundColor: Colors.black,
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
                        child: Swiper(
                          controller: controller,
                          itemBuilder: (BuildContext context, int index) {
                            V2TimMessage message = messages[index];
                            if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
                              if (message.imageElem != null) {
                                if (widget.isSending) {
                                  var lp = message.imageElem!.path ?? "";
                                  if (lp.isNotEmpty) {
                                    return PhotoView(
                                      imageProvider: Image.file(
                                        File(lp),
                                      ).image,
                                    );
                                  }
                                }
                                var (_, local) = getImageLocalurl(message.imageElem!);
                                var thumbUrl = getImageOnlineStumbUrl(message.imageElem!);
                                if (local.isNotEmpty) {
                                  return PhotoView(
                                    imageProvider: Image.file(
                                      File(local),
                                    ).image,
                                  );
                                }

                                if (TencentCloudChatUtils.checkString(thumbUrl) != null) {
                                  return PhotoView(
                                    imageProvider: Image.network(
                                      thumbUrl,
                                    ).image,
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
