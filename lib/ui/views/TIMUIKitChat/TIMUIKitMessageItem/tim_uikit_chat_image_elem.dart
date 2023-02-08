// ignore_for_file: prefer_typing_uninitialized_variables,  unused_import

import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';

import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';

import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/history_message_constant.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/TIMUIKitMessageReaction/tim_uikit_message_reaction_wrapper.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/image_screen.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/toast.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class TIMUIKitImageElem extends StatefulWidget {
  final V2TimMessage message;
  final bool isShowJump;
  final VoidCallback? clearJump;
  final String? isFrom;
  final bool? isShowMessageReaction;
  final TUIChatSeparateViewModel chatModel;

  const TIMUIKitImageElem(
      {required this.message,
      this.isShowJump = false,
      required this.chatModel,
      this.clearJump,
      this.isFrom,
      Key? key,
      this.isShowMessageReaction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitImageElem();
}

class _TIMUIKitImageElem extends TIMUIKitState<TIMUIKitImageElem> {
  double? networkImagePositionRadio; // 加这个字段用于异步获取被安全打击后的兜底图的比例
  final TUIChatGlobalModel model = serviceLocator<TUIChatGlobalModel>();
  final MessageService _messageService = serviceLocator<MessageService>();
  Widget? imageItem;
  bool isSent = false;

  @override
  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  String getBigPicUrl() {
    // 实际拿的是原图
    V2TimImage? img = MessageUtils.getImageFromImgList(
        widget.message.imageElem!.imageList,
        HistoryMessageDartConstant.oriImgPrior);
    return img == null ? widget.message.imageElem!.path! : img.url!;
  }

  Widget errorDisplay(BuildContext context, TUITheme? theme) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            width: 1,
            color: theme?.black ?? Colors.white,
          )),
      height: 100,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: theme?.weakTextColor ?? Colors.grey,
              size: 28,
            )
          ],
        ),
      ),
    );
  }

  Widget getImage(image, {imageElem}) {
    Widget res = ClipRRect(
      clipper: ImageClipper(),
      child: image,
    );

    return res;
  }

  //保存网络图片到本地
  Future<void> _saveImageToLocal(
    context,
    String imageUrl, {
    bool isAsset = true,
    TUITheme? theme,
  }) async {
    if (PlatformUtils().isWeb) {
      download(imageUrl) async {
        final http.Response r = await http.get(Uri.parse(imageUrl));
        final data = r.bodyBytes;
        final base64data = base64Encode(data);
        final a =
            html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');
        a.download = md5.convert(utf8.encode(imageUrl)).toString();
        a.click();
        a.remove();
      }

      download(imageUrl);
      return;
    }

    if (PlatformUtils().isIOS) {
      if (!await Permissions.checkPermission(
          context, Permission.photosAddOnly.value, theme!, false)) {
        return;
      }
    } else {
      if (!await Permissions.checkPermission(
          context, Permission.storage.value, theme!)) {
        return;
      }
    }

    // 本地资源的情况下
    if (!isAsset) {
      if (widget.message.msgID == null || widget.message.msgID!.isEmpty) {
        return;
      }

      if (model.getMessageProgress(widget.message.msgID) == 100) {
        String savePath;
        if (widget.message.imageElem!.path != null &&
            widget.message.imageElem!.path != '') {
          savePath = widget.message.imageElem!.path!;
        } else {
          savePath = model.getFileMessageLocation(widget.message.msgID);
        }
        File f = File(savePath);
        if (f.existsSync()) {
          var result = await ImageGallerySaver.saveFile(savePath);

          if (PlatformUtils().isIOS) {
            if (result['isSuccess']) {
              onTIMCallback(TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("图片保存成功"),
                  infoCode: 6660406));
            } else {
              onTIMCallback(TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("图片保存失败"),
                  infoCode: 6660407));
            }
          } else {
            if (result != null) {
              onTIMCallback(TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("图片保存成功"),
                  infoCode: 6660406));
            } else {
              onTIMCallback(TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("图片保存失败"),
                  infoCode: 6660407));
            }
          }
          return;
        }
      } else {
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("the message is downloading"),
            infoCode: -1));
      }
      return;
    }
    // model.setMessageProgress(widget.message.msgID!, 0);
    // var result =
    //     await ImageGallerySaver.saveImage(Uint8List.fromList(response));

    var result = await ImageGallerySaver.saveFile(imageUrl);

    if (PlatformUtils().isIOS) {
      if (result['isSuccess']) {
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("图片保存成功"),
            infoCode: 6660406));
      } else {
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("图片保存失败"),
            infoCode: 6660407));
      }
    } else {
      if (result != null) {
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("图片保存成功"),
            infoCode: 6660406));
      } else {
        onTIMCallback(TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("图片保存失败"),
            infoCode: 6660407));
      }
    }
    return;
  }

  Future<void> _saveImg(TUITheme theme) async {
    String? path = widget.message.imageElem!.path;
    if (path != null && PlatformUtils().isWeb
        ? true
        : File(path!).existsSync()) {
      return await _saveImageToLocal(context, path, isAsset: true, theme: theme);
    } else {
      String imgUrl = getBigPicUrl();
      if (widget.message.imageElem!.imageList![0]!.localUrl != '' &&
          widget.message.imageElem!.imageList![0]!.localUrl != null) {
        File f = File(widget.message.imageElem!.imageList![0]!.localUrl!);
        if (f.existsSync()) {
          return await _saveImageToLocal(
            context,
            widget.message.imageElem!.imageList![0]!.localUrl!,
            isAsset: true,
            theme: theme,
          );
        }
      }
      if (widget.message.imageElem!.path != '' &&
          widget.message.imageElem!.path != null) {
        File f = File(widget.message.imageElem!.path!);
        if (f.existsSync()) {
          return await _saveImageToLocal(
            context,
            widget.message.imageElem!.path!,
            isAsset: true,
            theme: theme,
          );
        }
      }
      return await _saveImageToLocal(
        context,
        imgUrl,
        isAsset: false,
        theme: theme,
      );
    }
  }

  V2TimImage? getImageFromList(V2TimImageTypesEnum imgType) {
    V2TimImage? img = MessageUtils.getImageFromImgList(
        widget.message.imageElem!.imageList,
        HistoryMessageDartConstant.imgPriorMap[imgType] ??
            HistoryMessageDartConstant.oriImgPrior);

    return img;
  }

  Widget errorPage(theme) => Container(
      height: MediaQuery.of(context).size.height,
      color: theme.black,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: errorDisplay(context, theme),
      ));

  Widget _renderLocalImage(
      String imgPath, dynamic heroTag, double positionRadio, TUITheme? theme) {
    double? currentPositionRadio;

    File imgF = File(imgPath);
    bool isExist = imgF.existsSync();

    if (!isExist) {
      return errorDisplay(context, theme);
    }
    Image image = Image.file(imgF);

    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((image, synchronousCall) {
      if (image.image.width != 0 && image.image.height != 0) {
        currentPositionRadio = image.image.width / image.image.height;
      }
    }));
    final message = widget.message;
    final preloadImage = model.preloadImageMap[
        message.seq! + message.timestamp.toString() + (message.msgID ?? "")];

    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        AspectRatio(
          aspectRatio: currentPositionRadio ?? positionRadio,
          child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
        ),
        getImage(
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false, // set to false
                      pageBuilder: (_, __, ___) => ImageScreen(
                          imageProvider: FileImage(File(imgPath)),
                          heroTag: heroTag,
                          messageID: widget.message.msgID,
                          downloadFn: () async {
                            return await _saveImg(theme!);
                          }),
                    ),
                  );
                },
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Hero(
                    tag: heroTag,
                    child: preloadImage != null
                        ? RawImage(
                            image: preloadImage,
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                          )
                        : Image.file(
                            File(imgPath),
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                          ),
                  ),
                )),
            imageElem: null)
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (!PlatformUtils().isWeb) {
      if ((widget.message.msgID != null && widget.message.msgID != '') &&
          (widget.message.imageElem!.imageList![0]!.localUrl == null ||
              widget.message.imageElem!.imageList![0]!.localUrl!.isEmpty)) {
        _messageService.downloadMessage(
            msgID: widget.message.msgID!,
            messageType: 3,
            imageType: 0,
            isSnapshot: false);
        _messageService.downloadMessage(
            msgID: widget.message.msgID!,
            messageType: 3,
            imageType: 1,
            isSnapshot: false);
        _messageService.downloadMessage(
            msgID: widget.message.msgID!,
            messageType: 3,
            imageType: 2,
            isSnapshot: false);
      }
    }
    // 先暂时下掉用网络图片计算尺寸比例的feature，在没有找到准确的判断图片是否被打击前
    // setOnlineImageRatio();
  }

  void setOnlineImageRatio() {
    if (networkImagePositionRadio == null) {
      V2TimImage? smallImg = getImageFromList(V2TimImageTypesEnum.small);
      V2TimImage? originalImg = getImageFromList(V2TimImageTypesEnum.original);
      Image image = Image.network(smallImg?.url ?? originalImg?.url ?? "");

      image.image
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool _) {
        if (info.image.width != 0 && info.image.height != 0) {
          setState(() {
            networkImagePositionRadio = (info.image.width / info.image.height);
          });
        }
      }));
    }
  }

  Widget _renderNetworkImage(
      dynamic heroTag, double positionRadio, TUITheme? theme,
      {String? path, V2TimImage? originalImg, V2TimImage? smallImg}) {
    try {
      String bigImgUrl = originalImg?.url ?? getBigPicUrl();
      if (bigImgUrl.isEmpty && smallImg?.url != null) {
        bigImgUrl = smallImg!.url!;
      }
      return Stack(
        alignment: widget.message.isSelf ?? false
            ? AlignmentDirectional.topEnd
            : AlignmentDirectional.topStart,
        children: [
          getImage(
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) => ImageScreen(
                            imageProvider: CachedNetworkImageProvider(
                              path ?? bigImgUrl,
                              cacheKey: widget.message.msgID,
                            ),
                            heroTag: heroTag,
                            messageID: widget.message.msgID,
                            downloadFn: () async {
                              return await _saveImg(theme!);
                            })),
                  );
                },
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Hero(
                      tag: heroTag,
                      child: PlatformUtils().isWeb
                          ? Image.network(
                              path ?? smallImg?.url ?? originalImg!.url!,
                              fit: BoxFit.contain)
                          :
                          // Image.network(smallImg?.url ?? ""),
                          CachedNetworkImage(
                              // width: double.infinity,
                              alignment: Alignment.topCenter,
                              imageUrl:
                                  path ?? smallImg?.url ?? originalImg!.url!,
                              // use small image in message list as priority
                              errorWidget: (context, error, stackTrace) =>
                                  errorPage(theme),
                              fit: BoxFit.contain,
                              cacheKey: smallImg?.uuid ?? originalImg!.uuid,
                              placeholder: (context, url) =>
                                  Image(image: MemoryImage(kTransparentImage)),
                              fadeInDuration: const Duration(milliseconds: 0),
                            )),
                ),
              ),
              imageElem: e)
        ],
      );
    } catch (e) {
      return errorDisplay(context, theme);
    }
  }

  bool isNeedShowLocalPath() {
    final current = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
    final timeStamp = widget.message.timestamp ?? current;
    return (widget.message.isSelf ?? false) &&
        (isSent || current - timeStamp < 300);
  }

  Widget? _renderImage(dynamic heroTag, TUITheme? theme,
      {V2TimImage? originalImg, V2TimImage? smallImg}) {
    double positionRadio = 1.0;
    if (smallImg?.width != null &&
        smallImg?.height != null &&
        smallImg?.width != 0 &&
        smallImg?.height != 0) {
      positionRadio = (smallImg!.width! / smallImg.height!);
    }

    if (PlatformUtils().isWeb && widget.message.imageElem!.path != null) {
      // Displaying on Web only
      return _renderNetworkImage(heroTag, positionRadio, theme,
          smallImg: smallImg,
          originalImg: originalImg,
          path: widget.message.imageElem!.path);
    }

    try {
      if ((isNeedShowLocalPath() &&
          widget.message.imageElem!.path != null &&
          widget.message.imageElem!.path!.isNotEmpty &&
          File(widget.message.imageElem!.path!).existsSync())) {
        return _renderLocalImage(widget.message.imageElem!.path!, heroTag,
            networkImagePositionRadio ?? positionRadio, theme);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    try {
      if (smallImg?.localUrl != null &&
          smallImg?.localUrl != "" &&
          File((smallImg?.localUrl!)!).existsSync()) {
        return _renderLocalImage(smallImg!.localUrl!, heroTag,
            networkImagePositionRadio ?? positionRadio, theme);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    if ((smallImg?.url ?? originalImg?.url) != null &&
        (smallImg?.url ?? originalImg?.url)!.isNotEmpty) {
      return _renderNetworkImage(heroTag, positionRadio, theme,
          smallImg: smallImg, originalImg: originalImg);
    }

    return errorDisplay(context, theme);
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    if (widget.message.status == MessageStatus.V2TIM_MSG_STATUS_SENDING) {
      isSent = true;
    }
    final heroTag =
        "${widget.message.msgID ?? widget.message.id ?? widget.message.timestamp ?? DateTime.now().millisecondsSinceEpoch}${widget.isFrom}";

    V2TimImage? originalImg = getImageFromList(V2TimImageTypesEnum.original);
    V2TimImage? smallImg = getImageFromList(V2TimImageTypesEnum.small);
    return TIMUIKitMessageReactionWrapper(
        chatModel: widget.chatModel,
        isShowJump: widget.isShowJump,
        clearJump: widget.clearJump,
        isFromSelf: widget.message.isSelf ?? true,
        isShowMessageReaction: widget.isShowMessageReaction ?? true,
        message: widget.message,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.5,
              minWidth: 64,
              maxHeight: 256,
            ),
            child: _renderImage(heroTag, theme,
                originalImg: originalImg, smallImg: smallImg),
          );
        }));
  }
}

class ImageClipper extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, min(size.height, 256)),
        const Radius.circular(5));
  }

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) {
    return oldClipper != this;
  }
}
