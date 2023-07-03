import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/tim_uikit_search_item_wide.dart';

import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class TIMUIKitSearchItem extends TIMUIKitStatelessWidget {
  final String faceUrl;
  final String showName;
  final String lineOne;
  final String? lineOneRight;
  final String? lineTwo;
  final VoidCallback? onClick;

  TIMUIKitSearchItem(
      {Key? key,
      required this.faceUrl,
      required this.showName,
      required this.lineOne,
      this.lineTwo,
      this.lineOneRight,
      this.onClick})
      : super(key: key);

  _renderLineOneRight(String? text, TUITheme theme) {
    if (text != null) {
      return Text(text,
          style: TextStyle(
            fontSize: 12,
            color: theme.weakTextColor,
          ));
    } else {
      return Container();
    }
  }

  _renderLineTwo(String? text, TUITheme theme) {
    return (text != null)
        ? Text(
            text,
            style: TextStyle(
                color: theme.weakTextColor, height: 1.5, fontSize: 14),
          )
        : Container(
            height: 0,
          );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return TUIKitScreenUtils.getDeviceWidget(
      context: context,
      defaultWidget: GestureDetector(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: hexToColor("DBDBDB"), width: 0.5))),
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [Avatar(faceUrl: faceUrl, showName: showName)],
                ),
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // height: 24,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            lineOne,
                            style: TextStyle(
                                color: theme.darkTextColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                          ),
                          _renderLineOneRight(lineOneRight, theme),
                        ],
                      ),
                    ),
                    _renderLineTwo(lineTwo, theme),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
      desktopWidget: TIMUIKitSearchWideItem(
          lineOneRight: lineOneRight,
          key: key,
          lineTwo: lineTwo,
          onClick: onClick,
          faceUrl: faceUrl,
          showName: showName,
          lineOne: lineOne),
    );
  }
}
