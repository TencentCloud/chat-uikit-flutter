import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_operation_item.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class GroupMessageDisturb extends TIMUIKitStatelessWidget {
  GroupMessageDisturb({Key? key}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final model = Provider.of<TUIGroupProfileModel>(context);
    final isShowDisturb = model.groupInfo?.groupType == "Meeting" ? false : true;
    final isDisturb = model.conversation?.recvOpt != 0;
    if (!isShowDisturb) {
      return Container();
    }
    return TIMUIKitOperationItem(
      isEmpty: false,
      operationName: TIM_t("消息免打扰"),
      type: "switch",
      isUseCheckedBoxOnWide: true,
      operationValue: isDisturb,
      onSwitchChange: (value) {
        model.setMessageDisturb(value);
      },
    );
  }
}
