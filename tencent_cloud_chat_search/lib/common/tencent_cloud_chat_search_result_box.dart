import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_search/common/tencent_cloud_chat_search_result_item.dart';


class TencentCloudChatSearchResultBox extends StatefulWidget {
  final String title;
  final List<TencentCloudChatSearchResultBoxItemData> resultList;

  const TencentCloudChatSearchResultBox({Key? key, required this.title, required this.resultList}) : super(key: key);

  @override
  State<TencentCloudChatSearchResultBox> createState() => _TencentCloudChatSearchResultBoxState();
}

class _TencentCloudChatSearchResultBoxState extends State<TencentCloudChatSearchResultBox> {
  int _resultListRenderCount = 5;

  @override
  Widget build(BuildContext context) {
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) => Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 14,  color: colorTheme.primaryTextColor ),
            ),
          ),
          Divider(
            color: colorTheme.dividerColor.withOpacity(0.8),
          ),
          Column(
            children: [
              ...widget.resultList.getRange(0, min(widget.resultList.length, _resultListRenderCount)).map((e) {
                return TencentCloudChatSearchResultItem(data: e,);
              }).toList(),
              if (_resultListRenderCount < widget.resultList.length)
                ListTile(
                  title: const Text("More", style: TextStyle(fontSize: 14),),
                  onTap: () {
                    setState(() {
                      _resultListRenderCount += 5;
                    });
                  },
                ),
            ],
          )
        ],
      ),
    ));
  }
}
