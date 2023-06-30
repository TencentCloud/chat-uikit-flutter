import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/drag_widget.dart';

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

    final TUISelfInfoViewModel selfInfoViewModel =
        serviceLocator<TUISelfInfoViewModel>();

    if (selfInfoViewModel.globalConfig?.showDesktopModalFunc != null) {
      final res = await selfInfoViewModel.globalConfig!.showDesktopModalFunc!(
          operationKey,
          context,
          child,
          theme,
          width,
          height,
          offset,
          initText,
          borderRadius,
          isDarkBackground,
          title,
          onSubmit,
          submitWidget,
          onConfirm,
          onCancel);

      if (res == true) {
        return;
      }
    }

    final isUseMaterialAlert = (offset == null);

    final Widget contentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(16)),
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
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        color: theme?.darkTextColor ?? const Color(0xFF444444)),
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
                    child: onSubmit != null
                        ? (submitWidget ?? const Icon(Icons.check))
                        : const Icon(Icons.close),
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
                            style: TextStyle(
                                color: theme?.weakTextColor ?? Colors.black),
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
          barrierDismissible: false,
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
                  return Future.value(false);
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
}
