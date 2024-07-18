import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'dart:ui' as ui;

class TencentCloudChatColumnMenu extends StatefulWidget {
  const TencentCloudChatColumnMenu({Key? key, required this.data, this.padding})
      : super(key: key);

  final List<TencentCloudChatMessageGeneralOptionItem> data;
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
                item.onTap();
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 130),
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 8,),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      // if (item.icon != null || item.iconAsset != null)
                      //   const SizedBox(
                      //     height: 4,
                      //     width: 4,
                      //   ),
                      Builder(builder: (ctx){
                        if (item.iconAsset != null) {
                          final type = item.iconAsset!.path.split(".")[item.iconAsset!.path.split(".").length - 1];
                          if (type == "svg") {
                            return SvgPicture.asset(
                              item.iconAsset!.path,
                              package: item.iconAsset!.package,
                              width: 16,
                              height: 16,
                              colorFilter: ui.ColorFilter.mode(
                                theme.secondaryTextColor,
                                ui.BlendMode.srcIn,
                              ),
                            );
                          }
                          return Image.asset(
                            item.iconAsset!.path,
                            package: item.iconAsset!.package,
                            width: 14,
                            height: 14,
                            color: theme.secondaryTextColor,
                          );
                        }
                        if (item.icon != null) {
                          return Icon(
                            item.icon,
                            size: 14,
                          );
                        }
                        return Container();
                      }),
                      if (item.icon != null || item.iconAsset != null)
                        const SizedBox(
                          height: 12,
                          width: 12,
                        ),
                      Text(
                        item.label,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: theme.primaryTextColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                        width: 8,
                      ),
                    ],
                  ),
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
