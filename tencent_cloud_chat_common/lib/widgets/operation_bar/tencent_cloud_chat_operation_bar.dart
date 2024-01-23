import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

enum OperationBarType { labelButton, switchControl, stringValue }

class TencentCloudChatOperationBar<T> extends StatefulWidget {
  final String label;
  final T value;
  final ValueChanged<T>? onChange;
  final OperationBarType operationBarType;

  const TencentCloudChatOperationBar({
    Key? key,
    required this.label,
    required this.value,
    this.onChange,
    required this.operationBarType,
  }) : super(key: key);

  @override
  State<TencentCloudChatOperationBar> createState() =>
      _TencentCloudChatOperationBarState<T>();
}

class _TencentCloudChatOperationBarState<T>
    extends TencentCloudChatState<TencentCloudChatOperationBar<T>> {
  @override
  Widget defaultBuilder(BuildContext context) {
    MaterialStateProperty<Color?> _getTrackColor(colorTheme) {
      final MaterialStateProperty<Color?> trackColor =
          MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          // Track color when the switch is selected.
          if (states.contains(MaterialState.selected)) {
            return colorTheme.contactAddContactFriendInfoStateButtonActiveColor;
          }
          // Otherwise return null to set default track color
          // for remaining states such as when the switch is
          // hovered, focused, or disabled.
          return null;
        },
      );
      return trackColor;
    }

    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: colorTheme.backgroundColor, width: 1)),
                color: colorTheme.inputAreaBackground,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                          color: colorTheme.secondaryTextColor, fontSize: 16),
                    ),
                  ),
                  if (widget.operationBarType == OperationBarType.labelButton)
                    TextButton(
                      onPressed: () => widget.onChange?.call(widget.value),
                      child: Text(widget.label),
                    )
                  else if (widget.operationBarType ==
                      OperationBarType.switchControl)
                    Switch(
                      value: widget.value as bool,
                      onChanged: (bool newValue) =>
                          widget.onChange?.call(newValue as T),
                      trackColor: _getTrackColor(colorTheme),
                      thumbColor: MaterialStatePropertyAll<Color>(
                          colorTheme.backgroundColor),
                      trackOutlineColor: MaterialStatePropertyAll<Color>(colorTheme
                          .contactAddContactFriendInfoStateButtonBackgroundColor),
                      inactiveThumbColor: colorTheme.backgroundColor,
                    )
                  else if (widget.operationBarType ==
                      OperationBarType.stringValue)
                    Row(
                      children: [
                        Text(widget.value.toString()),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => widget.onChange?.call(widget.value),
                        ),
                      ],
                    ),
                ],
              ),
            ));
  }
}
