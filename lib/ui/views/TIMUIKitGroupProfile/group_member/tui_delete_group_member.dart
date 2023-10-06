import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/group_member_list.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

GlobalKey<_DeleteGroupMemberPageState> deleteGroupMemberKey = GlobalKey();

class DeleteGroupMemberPage extends StatefulWidget {
  final TUIGroupProfileModel model;
  final VoidCallback? onClose;

  const DeleteGroupMemberPage({Key? key, required this.model, this.onClose}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeleteGroupMemberPageState();
}

class _DeleteGroupMemberPageState extends TIMUIKitState<DeleteGroupMemberPage> {
  List<V2TimGroupMemberFullInfo> selectedGroupMember = [];
  List<V2TimGroupMemberFullInfo?>? searchMemberList;

  bool isSearchTextExist(String? searchText) {
    return searchText != null && searchText != "";
  }

  handleSearchGroupMembers(String searchText, context) async {
    searchText = searchText;
    List<V2TimGroupMemberFullInfo?> currentGroupMember = Provider.of<TUIGroupProfileModel>(context, listen: false).groupMemberList;
    final res = await widget.model.searchGroupMember(V2TimGroupMemberSearchParam(
      keywordList: [searchText],
      groupIDList: [widget.model.groupInfo!.groupID],
    ));

    if (res.code == 0) {
      List<V2TimGroupMemberFullInfo?> list = [];
      final searchResult = res.data!.groupMemberSearchResultItems!;
      searchResult.forEach((key, value) {
        if (value is List) {
          for (V2TimGroupMemberFullInfo item in value) {
            list.add(item);
          }
        }
      });

      currentGroupMember = list;
    } else {
      currentGroupMember = [];
    }
    setState(() {
      searchMemberList = isSearchTextExist(searchText) ? currentGroupMember : null;
    });
  }

  handleRole(groupMemberList) {
    return groupMemberList?.where((value) => value?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER).toList() ?? [];
  }

  void submitDelete() async {
    if (selectedGroupMember.isNotEmpty) {
      final userIDs = selectedGroupMember.map((e) => e.userID).toList();
      widget.model.kickOffMember(userIDs);
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
          child: GroupProfileMemberList(
            memberList: handleRole(searchMemberList ?? widget.model.groupMemberList),
            canSelectMember: true,
            canSlideDelete: false,
            onSelectedMemberChange: (selectedMember) {
              selectedGroupMember = selectedMember;
            },
            touchBottomCallBack: () {},
          ),
        ),
        defaultWidget: Scaffold(
            appBar: AppBar(
                title: Text(
                  TIM_t("删除群成员"),
                  style: TextStyle(color: theme.appbarTextColor, fontSize: 17),
                ),
                actions: [
                  TextButton(
                    onPressed: submitDelete,
                    child: Text(
                      TIM_t("确定"),
                      style: TextStyle(
                        color: theme.appbarTextColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
                shadowColor: theme.weakBackgroundColor,
                backgroundColor: theme.appbarBgColor ?? theme.primaryColor,
                iconTheme: IconThemeData(
                  color: theme.appbarTextColor,
                )),
            body: GroupProfileMemberList(
              memberList: handleRole(searchMemberList ?? widget.model.groupMemberList),
              canSelectMember: true,
              canSlideDelete: false,
              onSelectedMemberChange: (selectedMember) {
                selectedGroupMember = selectedMember;
              },
              touchBottomCallBack: () {},
            )));
  }
}
