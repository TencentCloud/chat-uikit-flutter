import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_column_menu/tencent_cloud_chat_column_menu.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/drag_area/tencent_cloud_chat_drag_area.dart';

enum TencentCloudChatDesktopPopupActionButtonType { primary, secondary }

class TencentCloudChatDesktopPopup {
  static OverlayEntry? entry;
  static bool isShow = false;

  static showColumnMenu({
    required BuildContext context,
    required Offset offset,
    required List<TencentCloudChatMessageGeneralOptionItem> items,
  }) {
    showPopupWindow(
        isDarkBackground: false,
        operationKey: TencentCloudChatPopupOperationKey.custom,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        context: context,
        offset: offset,
        child: (closeFunc) => TencentCloudChatColumnMenu(
              data: items
                  .map((e) => TencentCloudChatMessageGeneralOptionItem(
                      label: e.label,
                      icon: e.icon,
                      onTap: ({Offset? offset}) {
                        closeFunc();
                        e.onTap();
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
                      Expanded(child: Text(
                        title,
                        style: TextStyle(fontSize: 18, color: colorTheme.primaryTextColor),
                      ),),
                      const SizedBox(width: 16,),
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
}
