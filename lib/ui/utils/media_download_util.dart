import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/history_message_constant.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:universal_html/html.dart' as html;

class MediaDownloadUtil {
  static final MediaDownloadUtil of = MediaDownloadUtil._();
  MediaDownloadUtil._();

  final CoreServicesImpl _coreServices = serviceLocator<CoreServicesImpl>();
  final TUIChatGlobalModel _model = serviceLocator<TUIChatGlobalModel>();

  Future<void> saveImg(
    BuildContext context,
    TUITheme theme, {
    V2TimMessage? cusMsg,
    V2TimMessage? message,
  }) async {
    try {
      String? imageUrl;
      bool isAssetBool = false;
      final msg = cusMsg ?? message;
      if (msg == null) return;

      final imageElem = msg.imageElem;

      if (imageElem != null) {
        final originUrl = _getOriginImgURLOf(msg);
        final localUrl = imageElem.imageList?.firstOrNull?.localUrl;
        final filePath = imageElem.path;
        final isWeb = PlatformUtils().isWeb;

        if (!isWeb && filePath != null && File(filePath).existsSync()) {
          imageUrl = filePath;
          isAssetBool = true;
        } else if (localUrl != null &&
            (!isWeb && File(localUrl).existsSync())) {
          imageUrl = localUrl;
          isAssetBool = true;
        } else {
          imageUrl = originUrl;
          isAssetBool = false;
        }
      }

      if (imageUrl != null) {
        return await _saveImageToLocal(
          context,
          imageUrl,
          isLocalResource: isAssetBool,
          theme: theme,
          message: msg,
        );
      }
    } catch (e) {
      _coreServices.callOnCallback(
        TIMCallback(
          infoCode: 6660414,
          infoRecommendText: TIM_t("正在下载中"),
          type: TIMCallbackType.INFO,
        ),
      );
      return;
    }
  }

  Future<void> saveVideo(
    BuildContext context, {
    required V2TimVideoElem videoElement,
    required V2TimMessage message,
  }) async {
    if (PlatformUtils().isWeb) {
      return await _saveNetworkVideo(
        context,
        videoElement.videoPath!,
        isAsset: true,
        message: message,
      );
    }
    if (videoElement.videoPath != '' && videoElement.videoPath != null) {
      File f = File(videoElement.videoPath!);
      if (f.existsSync()) {
        return await _saveNetworkVideo(
          context,
          videoElement.videoPath!,
          isAsset: true,
          message: message,
        );
      }
    }
    if (videoElement.localVideoUrl != '' &&
        videoElement.localVideoUrl != null) {
      File f = File(videoElement.localVideoUrl!);
      if (f.existsSync()) {
        return await _saveNetworkVideo(
          context,
          videoElement.localVideoUrl!,
          isAsset: true,
          message: message,
        );
      }
    }
    return await _saveNetworkVideo(
      context,
      videoElement.videoUrl!,
      isAsset: false,
      message: message,
    );
  }
}

extension _MediaDownloadUtilPrivate on MediaDownloadUtil {
  // 保存网络图片到本地
  Future<void> _saveImageToLocal(
    context,
    String imageUrl, {
    bool isLocalResource = true,
    TUITheme? theme,
    required V2TimMessage message,
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
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (PlatformUtils().isMobile) {
        if ((androidInfo.version.sdkInt) >= 33) {
          final photos = await Permissions.checkPermission(
            context,
            Permission.photos.value,
            theme,
          );
          if (!photos) {
            return;
          }
        } else {
          final storage = await Permissions.checkPermission(
            context,
            Permission.storage.value,
          );
          if (!storage) {
            return;
          }
        }
      }
    }

    if (!isLocalResource) {
      if (message.msgID == null || message.msgID!.isEmpty) {
        return;
      }

      if (_model.getMessageProgress(message.msgID) == 100) {
        String savePath;
        if (message.imageElem!.path != null && message.imageElem!.path != '') {
          savePath = message.imageElem!.path!;
        } else {
          savePath = _model.getFileMessageLocation(message.msgID);
        }
        File f = File(savePath);
        if (f.existsSync()) {
          var result = await ImageGallerySaver.saveFile(savePath);

          if (PlatformUtils().isIOS) {
            if (result['isSuccess']) {
              _coreServices.callOnCallback(
                TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("图片保存成功"),
                  infoCode: 6660406,
                ),
              );
            } else {
              _coreServices.callOnCallback(
                TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("图片保存失败"),
                  infoCode: 6660407,
                ),
              );
            }
          } else {
            if (result != null) {
              _coreServices.callOnCallback(
                TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("图片保存成功"),
                  infoCode: 6660406,
                ),
              );
            } else {
              _coreServices.callOnCallback(
                TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("图片保存失败"),
                  infoCode: 6660407,
                ),
              );
            }
          }
          return;
        }
      } else {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("the message is downloading"),
            infoCode: -1,
          ),
        );
      }
      return;
    }

    var result = await ImageGallerySaver.saveFile(imageUrl);

    if (PlatformUtils().isIOS) {
      if (result['isSuccess']) {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("图片保存成功"),
            infoCode: 6660406,
          ),
        );
      } else {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("图片保存失败"),
            infoCode: 6660407,
          ),
        );
      }
    } else {
      if (result != null) {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("图片保存成功"),
            infoCode: 6660406,
          ),
        );
      } else {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("图片保存失败"),
            infoCode: 6660407,
          ),
        );
      }
    }
    return;
  }

  //保存网络视频到本地
  Future<void> _saveNetworkVideo(
    context,
    String videoUrl, {
    bool isAsset = true,
    required V2TimMessage message,
  }) async {
    if (PlatformUtils().isWeb) {
      RegExp exp = RegExp(r"((\.){1}[^?]{2,4})");
      String? suffix = exp.allMatches(videoUrl).last.group(0);
      var xhr = html.HttpRequest();
      xhr.open('get', videoUrl);
      xhr.responseType = 'arraybuffer';
      xhr.onLoad.listen((event) {
        final a = html.AnchorElement(
            href: html.Url.createObjectUrl(html.Blob([xhr.response])));
        a.download = '${md5.convert(utf8.encode(videoUrl)).toString()}$suffix';
        a.click();
        a.remove();
      });
      xhr.send();
      return;
    }
    if (PlatformUtils().isMobile) {
      if (PlatformUtils().isIOS) {
        if (!await Permissions.checkPermission(
          context,
          Permission.photosAddOnly.value,
        )) {
          return;
        }
      } else {
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if ((androidInfo.version.sdkInt) >= 33) {
          final videos = await Permissions.checkPermission(
            context,
            Permission.videos.value,
          );

          if (!videos) {
            return;
          }
        } else {
          final storage = await Permissions.checkPermission(
            context,
            Permission.storage.value,
          );
          if (!storage) {
            return;
          }
        }
      }
    }
    String savePath = videoUrl;
    if (!isAsset) {
      if (message.msgID == null || message.msgID!.isEmpty) {
        return;
      }
      if (_model.getMessageProgress(message.msgID) == 100) {
        String savePath;
        if (message.videoElem!.localVideoUrl != null &&
            message.videoElem!.localVideoUrl != '') {
          savePath = message.videoElem!.localVideoUrl!;
        } else {
          savePath = _model.getFileMessageLocation(message.msgID);
        }
        File f = File(savePath);
        if (f.existsSync()) {
          var result = await ImageGallerySaver.saveFile(savePath);
          if (PlatformUtils().isIOS) {
            if (result['isSuccess']) {
              _coreServices.callOnCallback(
                TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("视频保存成功"),
                  infoCode: 6660402,
                ),
              );
            } else {
              _coreServices.callOnCallback(
                TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("视频保存失败"),
                  infoCode: 6660403,
                ),
              );
            }
          } else {
            if (result != null) {
              _coreServices.callOnCallback(
                TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("视频保存成功"),
                  infoCode: 6660402,
                ),
              );
            } else {
              _coreServices.callOnCallback(
                TIMCallback(
                  type: TIMCallbackType.INFO,
                  infoRecommendText: TIM_t("视频保存失败"),
                  infoCode: 6660403,
                ),
              );
            }
          }
        }
      } else {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("the message is downloading"),
            infoCode: -1,
          ),
        );
      }
      return;
    }
    var result = await ImageGallerySaver.saveFile(savePath);
    if (PlatformUtils().isIOS) {
      if (result['isSuccess']) {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("视频保存成功"),
            infoCode: 6660402,
          ),
        );
      } else {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("视频保存失败"),
            infoCode: 6660403,
          ),
        );
      }
    } else {
      if (result != null) {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("视频保存成功"),
            infoCode: 6660402,
          ),
        );
      } else {
        _coreServices.callOnCallback(
          TIMCallback(
            type: TIMCallbackType.INFO,
            infoRecommendText: TIM_t("视频保存失败"),
            infoCode: 6660403,
          ),
        );
      }
    }
    return;
  }

  String _getOriginImgURLOf(V2TimMessage message) {
    // 实际拿的是原图
    V2TimImage? img = MessageUtils.getImageFromImgList(
      message.imageElem!.imageList,
      HistoryMessageDartConstant.oriImgPrior,
    );
    return img == null ? message.imageElem!.path! : img.url!;
  }
}
