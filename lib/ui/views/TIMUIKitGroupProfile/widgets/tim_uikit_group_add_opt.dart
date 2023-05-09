import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/column_menu.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';



import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class GroupProfileAddOpt extends TIMUIKitStatelessWidget {
  GroupProfileAddOpt({Key? key}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final model = Provider.of<TUIGroupProfileModel>(context);
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    String addOpt = TIM_t("未知");

    final groupAddOpt = model.groupInfo?.groupAddOpt;
    switch (groupAddOpt) {
      case GroupAddOptType.V2TIM_GROUP_ADD_ANY:
        addOpt = TIM_t("自动审批");
        break;
      case GroupAddOptType.V2TIM_GROUP_ADD_AUTH:
        addOpt = TIM_t("管理员审批");
        break;
      case GroupAddOptType.V2TIM_GROUP_ADD_FORBID:
        addOpt = TIM_t("禁止加群");
        break;
    }

    final actionList = [
      {"label": TIM_t("禁止加群"), "id": GroupAddOptType.V2TIM_GROUP_ADD_FORBID},
      {"label": TIM_t("自动审批"), "id": GroupAddOptType.V2TIM_GROUP_ADD_ANY},
      {"label": TIM_t("管理员审批"), "id": GroupAddOptType.V2TIM_GROUP_ADD_AUTH}
    ];

    _handleActionTap(int addOpt) async {
      model.setGroupAddOpt(addOpt).then((res) {});
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: isDesktopScreen ? null : Border(
              bottom: BorderSide(
                  color:
                      theme.weakDividerColor ?? CommonColor.weakDividerColor))),
      child: InkWell(
        onTapDown: (details) async {
          if(isDesktopScreen){
            TUIKitWidePopup.showPopupWindow(
                operationKey: TUIKitWideModalOperationKey.groupAddOpt,
                isDarkBackground: false,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                context: context,
                offset: Offset(min(details.globalPosition.dx,
                    MediaQuery.of(context).size.width - 186), details.globalPosition.dy),
                child: (onClose) => TUIKitColumnMenu(
                  data: [
                    ...actionList
                        .map((e){
                       return ColumnMenuItem(label: e["label"] as String, onClick: (){
                         _handleActionTap(e["id"] as int);
                         onClose();
                       });
                    }),
                  ],
                )
            );
          }else{
            showCupertinoModalPopup<String>(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  title: Text(TIM_t("加群方式")),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        "cancel",
                      );
                    },
                    child: Text(TIM_t("取消")),
                    isDefaultAction: false,
                  ),
                  actions: actionList
                      .map((e) => CupertinoActionSheetAction(
                    onPressed: () {
                      _handleActionTap(e["id"] as int);
                      Navigator.pop(
                        context,
                        "cancel",
                      );
                    },
                    child: Text(
                      e["label"] as String,
                      style: TextStyle(color: theme.primaryColor),
                    ),
                    isDefaultAction: false,
                  ))
                      .toList(),
                );
              },
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              TIM_t("加群方式"),
              style: TextStyle(fontSize: isDesktopScreen ? 14 : 16, color: theme.darkTextColor),
            ),
            Row(
              children: [
                Text(
                  addOpt,
                  style: TextStyle(fontSize: isDesktopScreen ? 14 : 16, color: Colors.black),
                ),
                Icon(Icons.keyboard_arrow_right, color: theme.weakTextColor)
              ],
            )
          ],
        ),
      ),
    );
  }
}
