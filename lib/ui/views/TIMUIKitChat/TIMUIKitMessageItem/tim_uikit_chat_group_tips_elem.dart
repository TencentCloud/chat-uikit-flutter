import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_tips_elem.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_tips_elem.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme.dart';

class TIMUIKitGroupTipsElem extends StatefulWidget {
  final V2TimGroupTipsElem groupTipsElem;
  final List<V2TimGroupMemberFullInfo?> groupMemberList;

  const TIMUIKitGroupTipsElem({Key? key, required this.groupMemberList, required this.groupTipsElem}) : super(key: key);

  @override
  State<TIMUIKitGroupTipsElem> createState() => _TIMUIKitGroupTipsElemState();
}

class _TIMUIKitGroupTipsElemState extends TIMUIKitState<TIMUIKitGroupTipsElem> {
  String groupTipsAbstractText = "";

  @override
  void initState() {
    super.initState();
    getText();
  }

  void getText() async {
    final newText = await MessageUtils.groupTipsMessageAbstract(widget.groupTipsElem, widget.groupMemberList);
    setState(() {
      groupTipsAbstractText = newText;
    });
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return MessageUtils.wrapMessageTips(
        Text(
          groupTipsAbstractText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: hexToColor("888888")),
        ),
        theme);
  }
}
