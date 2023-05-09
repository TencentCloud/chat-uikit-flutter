import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_operation_item.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class GroupPinConversation extends TIMUIKitStatelessWidget {
  GroupPinConversation({Key? key}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final model = Provider.of<TUIGroupProfileModel>(context);
    final isPined = model.conversation?.isPinned ?? false;
    return TIMUIKitOperationItem(
      isEmpty: false,
      operationName: TIM_t("置顶聊天"),
      type: "switch",
      isUseCheckedBoxOnWide: true,
      operationValue: isPined,
      onSwitchChange: (value) {
        model.pinedConversation(value);
      },
    );
  }
}
