import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class ColumnMenuItem {
  String label;
  VoidCallback onClick;
  Widget? icon;

  ColumnMenuItem({required this.label, required this.onClick, this.icon});
}

class TencentCloudChatColumnMenu extends StatefulWidget {
  const TencentCloudChatColumnMenu({Key? key, required this.data, this.padding})
      : super(key: key);

  final List<ColumnMenuItem> data;
  final EdgeInsetsGeometry? padding;

  @override
  State<StatefulWidget> createState() => TencentCloudChatColumnMenuState();
}

class TencentCloudChatColumnMenuState
    extends TencentCloudChatState<TencentCloudChatColumnMenu> {
  List<Widget> renderMenuItems(TencentCloudChatThemeColors theme) {
    return widget.data
        .map(
          (item) => Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                item.onClick();
              },
              child: Container(
                padding: widget.padding ?? const EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) item.icon!,
                    if (item.icon != null)
                      const SizedBox(
                        height: 4,
                        width: 6,
                      ),
                    Text(
                      item.label,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: theme.primaryTextColor,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                  color: colorTheme.backgroundColor,
                  border: Border.all(color: colorTheme.dividerColor),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: colorTheme.dividerColor,
                      offset: const Offset(5, 5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: min(MediaQuery.of(context).size.width * 0.7, 350),
                  ),
                  child: Table(columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                  }, children: <TableRow>[
                    ...renderMenuItems(colorTheme)
                        .map((e) => TableRow(children: <Widget>[e]))
                  ]),
                ),
              ),
            ));
  }
}
