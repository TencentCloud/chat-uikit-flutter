// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';

import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/tim_uikit_search.dart';

import 'package:tencent_cloud_chat_uikit/data_services/conversation/conversation_services.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/shared_data_widget.dart';

class GroupProfileGroupSearch extends TIMUIKitStatelessWidget {
  GroupProfileGroupSearch({Key? key, required this.onJumpToSearch})
      : super(key: key);
  final ConversationService _conversationService =
      serviceLocator<ConversationService>();

  final Function(V2TimConversation?) onJumpToSearch;

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    final model = Provider.of<TUIGroupProfileModel>(context);

    return InkWell(
      onTap: () async {
        V2TimConversation? conversation =
            await _conversationService.getConversation(
                conversationID: "group_${model.groupInfo!.groupID}");
        if (conversation != null) {
          onJumpToSearch(conversation);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: theme.weakDividerColor ??
                        CommonColor.weakDividerColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              TIM_t("查找聊天内容"),
              style: TextStyle(fontSize: 16, color: theme.darkTextColor),
            ),
            Icon(Icons.keyboard_arrow_right, color: theme.weakTextColor)
          ],
        ),
      ),
    );
  }
}
