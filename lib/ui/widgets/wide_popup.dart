// ignore_for_file: unused_import

import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/drag_widget.dart';
import 'package:video_player/video_player.dart';

class TUIKitWidePopup {
  static OverlayEntry? entry;
  static bool isShow = false;

  static showSecondaryConfirmDialog({
    required TUIKitWideModalOperationKey operationKey,
    required BuildContext context,
    required String text,
    required TUITheme theme,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return TUIKitWidePopup.showPopupWindow(
        operationKey: operationKey,
        context: context,
        isDarkBackground: false,
        onCancel: onCancel,
        onConfirm: onConfirm,
        width: 350,
        height: 120,
        child: (onClose) => Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Icon(Icons.info, color: theme.primaryColor),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(child: Text(text))
                ],
              ),
            ));
  }

  static showPopupWindow({
    /// You could determine this field as `TUIKitWideModalOperationKey.custom` for your own business needs.
    required TUIKitWideModalOperationKey operationKey,
    required BuildContext context,
    required Widget Function(VoidCallback closeFunc) child,
    TUITheme? theme,
    double? width,
    double? height,
    Offset? offset,
    String? initText,
    BorderRadius? borderRadius,
    bool isDarkBackground = true,
    String? title,
    VoidCallback? onSubmit,
    Widget? submitWidget,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    if (isShow) {
      return;
    }
    isShow = true;

    final TUISelfInfoViewModel selfInfoViewModel = serviceLocator<TUISelfInfoViewModel>();

    if (selfInfoViewModel.globalConfig?.showDesktopModalFunc != null) {
      final res = await selfInfoViewModel.globalConfig!.showDesktopModalFunc!(operationKey, context, child, theme, width, height, offset, initText, borderRadius, isDarkBackground, title, onSubmit, submitWidget, onConfirm, onCancel);

      if (res == true) {
        return;
      }
    }

    final isUseMaterialAlert = (offset == null);

    final Widget contentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(16)),
        color: theme?.wideBackgroundColor ?? const Color(0xFFffffff),
        border: isDarkBackground
            ? Border.all(
                width: 2,
                color: theme?.weakBackgroundColor ?? const Color(0xFFbebebe),
              )
            : null,
        boxShadow: (isDarkBackground || isUseMaterialAlert)
            ? null
            : const [
                BoxShadow(
                  color: Color(0xFFbebebe),
                  offset: Offset(3, 3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Column(
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hexToColor("f5f6f7"),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, color: theme?.darkTextColor ?? const Color(0xFF444444)),
                  ),
                  InkWell(
                    onTap: () {
                      if (onSubmit != null) {
                        onSubmit();
                      }
                      isShow = false;
                      if (offset == null) {
                        Navigator.pop(context);
                      } else {
                        entry?.remove();
                        entry = null;
                      }
                    },
                    child: onSubmit != null ? (submitWidget ?? const Icon(Icons.check)) : const Icon(Icons.close),
                  )
                ],
              ),
            ),
          if (title != null)
            SizedBox(
              height: 1,
              child: Container(
                color: theme?.weakDividerColor ?? const Color(0xFFE5E6E9),
              ),
            ),
          if (height != null && width != null)
            Expanded(child: child(() {
              isShow = false;
              if (isUseMaterialAlert) {
                Navigator.pop(context);
              } else {
                entry?.remove();
                entry = null;
              }
            })),
          if (height == null || width == null)
            child(() {
              isShow = false;
              if (isUseMaterialAlert) {
                Navigator.pop(context);
              } else {
                entry?.remove();
                entry = null;
              }
            }),
          if (onCancel != null || onConfirm != null)
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onCancel != null)
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: OutlinedButton(
                          onPressed: () {
                            isShow = false;
                            if (isUseMaterialAlert) {
                              Navigator.pop(context);
                            } else {
                              entry?.remove();
                              entry = null;
                            }
                            onCancel();
                          },
                          child: Text(
                            TIM_t("取消"),
                            style: TextStyle(color: theme?.weakTextColor ?? Colors.black),
                          )),
                    ),
                  if (onConfirm != null)
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: ElevatedButton(
                          onPressed: () {
                            isShow = false;
                            if (isUseMaterialAlert) {
                              Navigator.pop(context);
                            } else {
                              entry?.remove();
                              entry = null;
                            }
                            onConfirm();
                          },
                          child: Text(
                            TIM_t("确定"),
                            style: TextStyle(color: theme?.primaryColor),
                          )),
                    ),
                ],
              ),
            )
        ],
      ),
    );

    if (isUseMaterialAlert) {
      return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return WillPopScope(
                child: AlertDialog(
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  content: contentWidget,
                ),
                onWillPop: () {
                  isShow = false;
                  return Future.value(true);
                });
          });
    }

    if (entry != null) {
      return;
    }

    entry = OverlayEntry(builder: (BuildContext context) {
      return Material(
        color: Colors.transparent,
        child: TUIKitDragArea(
            backgroundColor: isDarkBackground ? const Color(0x7F000000) : null,
            closeFun: () {
              isShow = false;
              if (entry != null) {
                entry?.remove();
                entry = null;
              }
            },
            initOffset: offset,
            child: contentWidget),
      );
    });
    Overlay.of(context).insert(entry!);
  }

  static void showMedia({
    String? mediaLocalPath,
    String? mediaURL,
    required BuildContext context,
    required VoidCallback onClickOrigin,
    double? aspectRatio,
  }) async {
    assert((mediaLocalPath != null) || (mediaURL != null), "At least one of mediaLocalPath or mediaURL must be provided.");

    String _removeQueryString(String urlString) {
      Uri uri = Uri.parse(urlString);
      Uri cleanUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: uri.path,
      );
      return cleanUri.toString();
    }

    final String mediaPath = mediaLocalPath ?? mediaURL ?? "";
    final isLocalResource = mediaLocalPath != null;

    String fileExtension = p.extension(isLocalResource ? mediaPath : _removeQueryString(mediaPath));
    bool isVideo = ['.mp4', '.avi', '.mov', '.flv', '.wmv'].contains(fileExtension);

    VideoPlayerController? videoController;
    ChewieController? chewieController;
    Widget mediaWidget;
    double? aspectRatioFinal = aspectRatio;

    if (isVideo) {
      if (isLocalResource) {
        videoController = VideoPlayerController.file(File(mediaPath));
      } else {
        videoController = VideoPlayerController.networkUrl(Uri.parse(mediaPath));
      }

      await videoController.initialize();
      aspectRatioFinal = videoController.value.aspectRatio;

      chewieController = ChewieController(
        allowFullScreen: false,
        videoPlayerController: videoController,
        aspectRatio: aspectRatioFinal,
        autoPlay: true,
        looping: false,
        autoInitialize: true,
      );

      mediaWidget = Chewie(controller: chewieController);
    } else {
      mediaWidget = isLocalResource ? Image.file(File(mediaPath), fit: BoxFit.contain) : Image.network(mediaPath, fit: BoxFit.contain);
    }

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return WillPopScope(
            child: AlertDialog(
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              content: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.85,
                          maxHeight: MediaQuery.of(context).size.height * 0.82,
                        ),
                        child: aspectRatioFinal != null ? AspectRatio(aspectRatio: aspectRatioFinal, child: mediaWidget) : mediaWidget,
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: onClickOrigin,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 0),
                              child: Icon(
                                Icons.open_in_new,
                                size: 14,
                                color: Colors.grey.shade200,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            // Custom Text Widget with designer baseline
                            Text(
                              TIM_t("在新窗口中打开"),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onWillPop: () {
              if (isVideo) videoController?.dispose();
              return Future.value(true);
            },
          );
        });
  }
}
