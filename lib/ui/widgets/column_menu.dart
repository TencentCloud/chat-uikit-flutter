import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class ColumnMenuItem {
  String label;
  VoidCallback onClick;
  Widget? icon;

  ColumnMenuItem({required this.label, required this.onClick, this.icon});
}

class TUIKitColumnMenu extends StatefulWidget {
  const TUIKitColumnMenu({Key? key, required this.data, this.padding}) : super(key: key);

  final List<ColumnMenuItem> data;
  final EdgeInsetsGeometry? padding;

  @override
  State<StatefulWidget> createState() => TUIKitColumnMenuState();
}

class TUIKitColumnMenuState extends TIMUIKitState<TUIKitColumnMenu> {

  List<Widget> renderMenuItems(TUITheme theme) {
    return widget.data
        .map(
          (item) => Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                item.onClick();
              },
              child: Container(
                padding: widget.padding ?? const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) item.icon!,
                    if (item.icon != null) const SizedBox(
                      height: 4,
                      width: 6,
                    ),
                    Text(
                      item.label,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: theme.darkTextColor,
                        fontSize: 14,
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
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: min(MediaQuery.of(context).size.width * 0.7, 350),
        ),
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
          },
          children: <TableRow>[
            ...renderMenuItems(theme).map((e) => TableRow(
              children: <Widget>[
                e
              ]
            ))
          ]
        ),
      ),
    );
  }
}
