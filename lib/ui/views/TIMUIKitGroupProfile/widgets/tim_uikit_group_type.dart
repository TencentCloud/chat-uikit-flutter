import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class GroupProfileType extends TIMUIKitStatelessWidget {
  GroupProfileType({Key? key}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    String groupType;
    final model = Provider.of<TUIGroupProfileModel>(context);
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    final type = model.groupInfo?.groupType;
    switch (type) {
      case GroupType.AVChatRoom:
        groupType = TIM_t("聊天室");
        break;
      case GroupType.Meeting:
        groupType = TIM_t("会议群");
        break;
      case GroupType.Public:
        groupType = TIM_t("公开群");
        break;
      case GroupType.Work:
        groupType = TIM_t("工作群");
        break;
      default:
        groupType = TIM_t("未知群");
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: isDesktopScreen ? null : Border(
              bottom: BorderSide(
                  color:
                      theme.weakDividerColor ?? CommonColor.weakDividerColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            TIM_t("群类型"),
            style: TextStyle(
                fontSize: isDesktopScreen ? 14 : 16, color: theme.darkTextColor),
          ),
          Text(
            groupType,
            style: TextStyle(
                fontSize: isDesktopScreen ? 14 : 16, color: theme.weakTextColor),
          )
        ],
      ),
    );
  }
}
