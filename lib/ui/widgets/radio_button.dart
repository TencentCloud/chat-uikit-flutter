import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class CheckBoxButton extends TIMUIKitStatelessWidget {
  final bool isChecked;
  final Function(bool isChecked)? onChanged;
  final bool disabled;
  final bool onlyShow;
  final double? size;

  CheckBoxButton(
      {this.disabled = false,
      Key? key,
      this.size,
      this.onlyShow = false,
      required this.isChecked,
      this.onChanged})
      : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    BoxDecoration boxDecoration = !isChecked
        ? BoxDecoration(
            border: Border.all(color: hexToColor("888888")),
            shape: BoxShape.circle,
            color: Colors.white)
        : BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor);

    if (disabled) {
      boxDecoration =
          const BoxDecoration(shape: BoxShape.circle, color: Colors.grey);
    }
    return Center(
        child: onlyShow
            ? Container(
                height: size ?? 22,
                width: size ?? 22,
                decoration: boxDecoration,
                child: Icon(
                  Icons.check,
                  size: size != null ? (size! / 2) : 11,
                  color: Colors.white,
                ),
              )
            : InkWell(
                onTap: () {
                  if (onChanged != null && !disabled) {
                    onChanged!(!isChecked);
                  }
                },
                child: Container(
                  height: size ?? 22,
                  width: size ?? 22,
                  decoration: boxDecoration,
                  child: Icon(
                    Icons.check,
                    size: size != null ? (size! / 2) : 11,
                    color: Colors.white,
                  ),
                ),
              ));
  }
}
