import 'dart:io';

import 'package:chewie_for_us/chewie_for_us.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_column_menu/tencent_cloud_chat_column_menu.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/drag_area/tencent_cloud_chat_drag_area.dart';
import 'package:video_player/video_player.dart';

enum TencentCloudChatDesktopPopupActionButtonType { primary, secondary }

class TencentCloudChatDesktopPopup {
  static OverlayEntry? entry;
  static bool isShow = false;

  static showColumnMenu({
    required BuildContext context,
    required Offset offset,
    required List<ColumnMenuItem> items,
  }) {
    showPopupWindow(
        isDarkBackground: false,
        operationKey: TencentCloudChatPopupOperationKey.custom,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        context: context,
        offset: offset,
        child: (closeFunc) => TencentCloudChatColumnMenu(
              data: items
                  .map((e) => ColumnMenuItem(
                      label: e.label,
                      icon: e.icon,
                      onClick: () {
                        closeFunc();
                        e.onClick();
                      }))
                  .toList(),
            ));
  }

  static showSecondaryConfirmDialog({
    required TencentCloudChatPopupOperationKey operationKey,
    required BuildContext context,
    required String text,
    String? title,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    double? width,
    double? height,
    List<({String label, VoidCallback onTap, TencentCloudChatDesktopPopupActionButtonType type})>? actions,
  }) {
    return TencentCloudChatDesktopPopup.showPopupWindow(
      operationKey: operationKey,
      context: context,
      isDarkBackground: false,
      onCancel: (actions ?? []).isEmpty ? onCancel : null,
      onConfirm: (actions ?? []).isEmpty ? onConfirm : null,
      width: width ?? 400,
      height: height ?? ((TencentCloudChatUtils.checkString(title) != null) ? 160 : 120),
      child: (onClose) => TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: (actions ?? []).isEmpty ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
            children: [
              if (TencentCloudChatUtils.checkString(title) != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: textStyle.fontsize_18,
                    ),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: colorTheme.primaryColor),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: textStyle.fontsize_16,
                      ),
                    ),
                  ),
                ],
              ),
              if ((actions ?? []).isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 16,
                        alignment: WrapAlignment.end,
                        children: (actions ?? []).map(
                          (e) {
                            {
                              if (e.type == TencentCloudChatDesktopPopupActionButtonType.secondary) {
                                return OutlinedButton(
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
                                      return BorderSide(color: colorTheme.dividerColor, width: 1);
                                    }),
                                  ),
                                  onPressed: () {
                                    e.onTap();
                                    onClose();
                                  },
                                  child: Text(
                                    e.label,
                                    style: TextStyle(color: colorTheme.secondaryTextColor),
                                  ),
                                );
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  e.onTap();
                                  onClose();
                                },
                                child: Text(
                                  e.label,
                                  style: TextStyle(color: colorTheme.primaryColor),
                                ),
                              );
                            }
                          },
                        ).toList(),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static showPopupWindow({
    required TencentCloudChatPopupOperationKey operationKey,
    required BuildContext context,
    required Widget Function(VoidCallback closeFunc) child,
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

    final isUseMaterialAlert = (offset == null);

    final Widget contentWidget = TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => ClipRRect(
        borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(16)),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(16)),
            color: colorTheme.backgroundColor,
            border: isDarkBackground
                ? Border.all(
                    width: 2,
                    color: colorTheme.dividerColor,
                  )
                : null,
            boxShadow: (isDarkBackground || isUseMaterialAlert)
                ? null
                : [
                    BoxShadow(
                      color: colorTheme.dividerColor,
                      offset: const Offset(3, 3),
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
                    color: colorTheme.dividerColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, color: colorTheme.primaryTextColor),
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
                    color: colorTheme.dividerColor,
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
                              style: ButtonStyle(
                                side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
                                  return BorderSide(color: colorTheme.dividerColor, width: 1);
                                }),
                              ),
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
                                tL10n.cancel,
                                style: TextStyle(color: colorTheme.secondaryTextColor),
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
                                tL10n.confirm,
                                style: TextStyle(color: colorTheme.primaryColor),
                              )),
                        ),
                    ],
                  ),
                )
            ],
          ),
        ),
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
        child: TencentCloudChatDragArea(
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

    String removeQueryString(String urlString) {
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

    String fileExtension = Pertypath().extension(isLocalResource ? mediaPath : removeQueryString(mediaPath));
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
                              tL10n.openInNewWindow,
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
