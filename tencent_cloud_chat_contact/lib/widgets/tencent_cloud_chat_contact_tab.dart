// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatContactTabItem extends StatefulWidget {
  final TTabItem item;

  const TencentCloudChatContactTabItem({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactTabItemState();
}

class TencentCloudChatContactTabItemState extends TencentCloudChatState<TencentCloudChatContactTabItem> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatContactTab(item: widget.item);
  }
}

class TencentCloudChatContactTab extends StatefulWidget {
  final TTabItem item;

  const TencentCloudChatContactTab({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactTabState();
}

class TencentCloudChatContactTabState extends TencentCloudChatState<TencentCloudChatContactTab> {
  Widget getUnreadCount() {
    if (widget.item.unreadCount != null) {
      return TencentCloudChatContactTabItemApplicationCount(count: widget.item.unreadCount ?? 0);
    }
    return Container();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => GestureDetector(
        onTap: widget.item.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: getHeight(12), horizontal: getWidth(16)),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorTheme.contactItemTabItemBorderColor)),
            color: colorTheme.contactTabItemBackgroundColor,
          ),
          child: Row(
            children: [
              SizedBox(
                width: getSquareSize(24),
                height: getSquareSize(24),
                child: Icon(
                  widget.item.icon,
                  color: colorTheme.primaryColor,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: getWidth(4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.item.name,
                            style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400, color: colorTheme.contactItemTabItemNameColor),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          getUnreadCount(),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: colorTheme.contactItemTabItemNameColor,
                          )
                        ],
                      )))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Material(
        color: colorTheme.contactTabItemBackgroundColor,
        child: InkWell(
          onTap: widget.item.onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: getHeight(12), horizontal: getWidth(16)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorTheme.contactItemTabItemBorderColor),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.item.icon,
                  color: colorTheme.primaryColor,
                  size: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: getWidth(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.item.name,
                          style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.secondaryTextColor),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        getUnreadCount(),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: colorTheme.contactItemTabItemNameColor,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TencentCloudChatContactTabItemApplicationCount extends StatefulWidget {
  final int count;

  const TencentCloudChatContactTabItemApplicationCount({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactTabItemApplicationCountState();
}

class TencentCloudChatContactTabItemApplicationCountState extends TencentCloudChatState<TencentCloudChatContactTabItemApplicationCount> {
  @override
  Widget defaultBuilder(BuildContext context) {
    if (widget.count > 0) {
      String text = widget.count.toString();
      return TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => Container(
                height: getHeight(16),
                width: text.length == 1 ? getWidth(16) : getWidth(26),
                decoration: BoxDecoration(
                  color: colorTheme.tipsColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      getSquareSize(8),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textStyle.fontsize_10,
                      fontWeight: FontWeight.w600,
                      color: colorTheme.contactApplicationUnreadCountTextColor,
                    ),
                  ),
                ),
              ));
    }
    return Container();
  }
}
