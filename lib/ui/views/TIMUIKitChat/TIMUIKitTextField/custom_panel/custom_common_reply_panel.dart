import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhaopin/im/base_widgets/tim_ui_kit_base.dart';
import 'package:zhaopin/im/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:zhaopin/im/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:zhaopin/im/tencent_cloud_chat_uikit.dart';
import 'package:zhaopin/services/services_locator.dart';

class CustomCommonReplyPanel extends TIMUIKitStatelessWidget {
  CustomCommonReplyPanel({
    super.key,
  });

  final replyList = [
    '你好，能帮我发布一个职位吗？',
    '请问我要发布招聘岗位，该怎么发布呢？',
  ];

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 248,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      width: screenWidth,
      child: ListView.separated(
        itemBuilder: (ctx, index) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            ServiceLocator.imMessageServices
                .sendTextMessage(text: replyList[index]);
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 45),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            alignment: Alignment.centerLeft,
            // height: 45,
            child: Text(
              replyList[index] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
        separatorBuilder: (ctx, index) => const Divider(
          height: 1,
        ),
        itemCount: replyList.length,
      ),
    );
  }
}
