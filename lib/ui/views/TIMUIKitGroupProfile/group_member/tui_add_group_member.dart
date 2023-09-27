import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/contact_list.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

GlobalKey<_AddGroupMemberPageState> addGroupMemberKey = GlobalKey();

class AddGroupMemberPage extends StatefulWidget {
  final TUIGroupProfileModel model;
  final VoidCallback? onClose;

  const AddGroupMemberPage({Key? key, required this.model, this.onClose}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddGroupMemberPageState();
}

class _AddGroupMemberPageState extends TIMUIKitState<AddGroupMemberPage> {
  List<V2TimFriendInfo> selectedContacts = [];

  void submitAdd() async {
    if (selectedContacts.isNotEmpty) {
      final userIDs = selectedContacts.map((e) => e.userID).toList();
      await widget.model.inviteUserToGroup(userIDs);
      widget.onClose ?? Navigator.pop(context);
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ContactList(
            bgColor: theme.wideBackgroundColor,
            groupMemberList: widget.model.groupMemberList,
            contactList: widget.model.contactList,
            isCanSelectMemberItem: true,
            onSelectedMemberItemChange: (selectedMember) {
              selectedContacts = selectedMember;
            },
          ),
        ),
        defaultWidget: Scaffold(
            appBar: AppBar(
                title: Text(
                  TIM_t("添加群成员"),
                  style: TextStyle(color: theme.appbarTextColor, fontSize: 17),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      submitAdd();
                    },
                    child: Text(
                      TIM_t("确定"),
                      style: TextStyle(
                        color: theme.appbarTextColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
                shadowColor: theme.weakDividerColor,
                backgroundColor: theme.appbarBgColor ?? theme.primaryColor,
                iconTheme: IconThemeData(
                  color: theme.appbarTextColor,
                )),
            body: ContactList(
              groupMemberList: widget.model.groupMemberList,
              contactList: widget.model.contactList,
              isCanSelectMemberItem: true,
              onSelectedMemberItemChange: (selectedMember) {
                selectedContacts = selectedMember;
              },
            )));
  }
}
