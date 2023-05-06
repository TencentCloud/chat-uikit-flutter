import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class TIMUIKitOperationItem extends TIMUIKitStatelessWidget {
  final String operationName;

  /// shows on the second line
  final String? operationDescription;
  final bool? operationValue;

  /// Is show allow edit status, while a right icon shows on mobile, and `showAllowEditStatus` shows on desktop.
  final bool showAllowEditStatus;

  /// Used on wide screen.
  final String? wideEditText;

  /// Used on wide screen.
  final bool isEmpty;

  /// the operationText widget for replacement, for developers to define what to do
  final Widget? operationRightWidget;
  final String type;
  final void Function(bool newValue)? onSwitchChange;
  final Key? itemBoxKey;
  final bool isUseCheckedBoxOnWide;

  /// Is use the small card mode on Desktop. Usually shows on the Chat page.
  final bool smallCardMode;

  TIMUIKitOperationItem(
      {Key? key,
      this.wideEditText,
      this.itemBoxKey,
      this.operationDescription,
      required this.isEmpty,
      required this.operationName,
      this.smallCardMode = false,
      this.operationValue,
      this.type = "arrow",
      this.isUseCheckedBoxOnWide = false,
      this.onSwitchChange,
      this.operationRightWidget,
      this.showAllowEditStatus = true})
      : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    return Container(
      padding: isDesktopScreen
          ? EdgeInsets.symmetric(
              horizontal: isUseCheckedBoxOnWide ? 6 : 16,
              vertical: smallCardMode ? 0 : 4)
          : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: isDesktopScreen ? null : const EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: (isDesktopScreen && isUseCheckedBoxOnWide)
          ? Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Checkbox(
                      fillColor: MaterialStateProperty.all(theme.primaryColor),
                      value: operationValue ?? false,
                      onChanged: (val) {
                        if (onSwitchChange != null) {
                          onSwitchChange!(val ?? false);
                        }
                      }),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      operationName,
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (operationDescription != null)
                      Text(
                        operationDescription!,
                        style:
                            TextStyle(color: theme.weakTextColor, fontSize: 12),
                      )
                  ],
                )),
              ],
            )
          : Row(
              mainAxisAlignment: isDesktopScreen
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (isDesktopScreen)
                  SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          operationName,
                          style: TextStyle(
                              color:
                                  isDesktopScreen ? hexToColor("7f7f7f") : null),
                        ),
                        if (operationDescription != null)
                          Text(
                            operationDescription!,
                            style: TextStyle(
                                color: theme.weakTextColor, fontSize: 12),
                          )
                      ],
                    ),
                  ),
                if (!isDesktopScreen)
                  Expanded(
                      child: SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          operationName,
                          style: TextStyle(
                              color:
                                  isDesktopScreen ? hexToColor("7f7f7f") : null),
                        ),
                        if (operationDescription != null)
                          Text(
                            operationDescription!,
                            style: TextStyle(
                                color: theme.weakTextColor, fontSize: 12),
                          )
                      ],
                    ),
                  )),
                if (type == "switch")
                  Transform.scale(
                    key: itemBoxKey,
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: operationValue ?? false,
                      onChanged: onSwitchChange,
                      activeColor: theme.primaryColor,
                    ),
                  ),
                if (type != "switch" && !isDesktopScreen)
                  Transform.scale(
                    scale: 0,
                    child: CupertinoSwitch(
                      value: false,
                      onChanged: onSwitchChange,
                    ),
                  ),
                (type != "switch" &&
                        isDesktopScreen &&
                        showAllowEditStatus &&
                        isEmpty)
                    ? MouseRegion(
                        key: itemBoxKey,
                        child: Text(
                          wideEditText ?? TIM_t("编辑"),
                          style: TextStyle(color: theme.weakTextColor),
                        ),
                      )
                    : Container(
                        width: 0,
                      ),
                if (type != "switch")
                  Expanded(
                      child: Row(
                    mainAxisAlignment: isDesktopScreen
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [Expanded(child: operationRightWidget ?? const Text(""))],
                  )),
                (type != "switch" && !isDesktopScreen && showAllowEditStatus)
                    ? const Icon(Icons.keyboard_arrow_right)
                    : Container(
                        width: 0,
                      ),
                if (type != "switch" && isDesktopScreen)
                  SizedBox(
                    width: 0,
                    child: Transform.scale(
                      scale: 0,
                      child: CupertinoSwitch(
                        value: false,
                        onChanged: onSwitchChange,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
