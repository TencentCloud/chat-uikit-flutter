// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/text_input_bottom_sheet.dart';


import 'package:tencent_im_base/tencent_im_base.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class GroupProfileNameCard extends TIMUIKitStatelessWidget {
  GroupProfileNameCard({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    final model = Provider.of<TUIGroupProfileModel>(context);
    if (model == null) {
      return Container();
    }
    final nameCard = model.getSelfNameCard();

    controller.text = nameCard;
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color:
                      theme.weakDividerColor ?? CommonColor.weakDividerColor))),
      child: InkWell(
        onTap: () async {
          TextInputBottomSheet.showTextInputBottomSheet(
              context, TIM_t("修改我的群昵称"), TIM_t("仅限中文、字母、数字和下划线，2-20个字"),
                  (String nameCard) async {
                    final text = nameCard.trim();
                    model.setNameCard(text);
              }, theme);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              TIM_t("我的群昵称"),
              style: TextStyle(fontSize: 16, color: theme.darkTextColor),
            ),
            Row(
              children: [
                Text(
                  nameCard,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
