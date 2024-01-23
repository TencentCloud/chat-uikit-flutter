import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';

typedef CommonAvatarBuilder = Widget? Function({
  required TencentCloudChatAvatarScene scene,
  double? width,
  double? height,
  double? borderRadius,
  required List<String> imageList,
  Decoration? decoration,
});

typedef ShowDesktopPopupFunc = Future<bool> Function({
  required BuildContext context,
  required Widget Function(VoidCallback closeFunc) child,
  double? width,
  double? height,
  Offset? offset,
  String? initText,
  BorderRadius? borderRadius,
  bool? isDarkBackground,
  String? title,
  VoidCallback? onSubmit,
  Widget? submitWidget,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
});

class TencentCloudChatCommonBuilders {
  static CommonAvatarBuilder? _commonAvatarBuilder;
  static ShowDesktopPopupFunc? _showDesktopPopupFunc;

  TencentCloudChatCommonBuilders({
    CommonAvatarBuilder? commonAvatarBuilder,
    ShowDesktopPopupFunc? showDesktopPopupFunc,
  }) {
    _commonAvatarBuilder = commonAvatarBuilder;
    _showDesktopPopupFunc = showDesktopPopupFunc;
  }

  static showDesktopPopup({
    TencentCloudChatPopupOperationKey? operationKey,
    required BuildContext context,
    required Widget Function(VoidCallback closeFunc) child,
    double? width,
    double? height,
    Offset? offset,
    String? initText,
    BorderRadius? borderRadius,
    bool? isDarkBackground,
    String? title,
    VoidCallback? onSubmit,
    Widget? submitWidget,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final bool? res = await _showDesktopPopupFunc?.call(
      context: context,
      child: child,
      width: width,
      height: height,
      offset: offset,
      initText: initText,
      borderRadius: borderRadius,
      isDarkBackground: isDarkBackground,
      title: title,
      onSubmit: onSubmit,
      submitWidget: submitWidget,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
    if (res != true) {
      TencentCloudChatDesktopPopup.showPopupWindow(
        operationKey: operationKey ?? TencentCloudChatPopupOperationKey.custom,
        context: context,
        child: child,
        width: width,
        height: height,
        offset: offset,
        initText: initText,
        borderRadius: borderRadius,
        isDarkBackground: isDarkBackground = true,
        title: title,
        onSubmit: onSubmit,
        submitWidget: submitWidget,
        onConfirm: onConfirm,
        onCancel: onCancel,
      );
    }
  }

  static Widget getCommonAvatarBuilder({
    required TencentCloudChatAvatarScene scene,
    double? width,
    double? height,
    double? borderRadius,
    required List<String> imageList,
    Decoration? decoration,
  }) {
    Widget? widget;

    if (_commonAvatarBuilder != null) {
      widget = _commonAvatarBuilder!(
        scene: scene,
        width: width,
        height: height,
        borderRadius: borderRadius,
        imageList: imageList,
        decoration: decoration,
      );
    }
    return widget ??
        TencentCloudChatAvatar(
          scene: scene,
          width: width,
          height: height,
          borderRadius: borderRadius,
          imageList: imageList,
          decoration: decoration,
        );
  }
}
