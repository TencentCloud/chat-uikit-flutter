import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

import 'package:tencent_im_base/tencent_im_base.dart';

class TIMUIKitDraftText extends TIMUIKitStatelessWidget {
  final BuildContext context;
  final String draftText;
  final double fontSize;

  TIMUIKitDraftText({
    Key? key,
    this.fontSize = 14.0,
    required this.context,
    required this.draftText,
  }) : super(key: key);

  String _getDraftShowText() {
    final draftShowText = TIM_t("草稿");

    return '[$draftShowText] ';
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    return RichText(
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        children: [
          TextSpan(text: _getDraftShowText(), style: TextStyle(color: theme.conversationItemDraftTextColor)),
          TextSpan(text: draftText),
        ],
        style: TextStyle(
          height: 1,
          color: theme.conversationItemLastMessageTextColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
