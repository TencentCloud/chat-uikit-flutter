import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_ui_group_member_search.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/group_member_list.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

GlobalKey<_SelectNewGroupOwner> selectNewGroupOwnerKey = GlobalKey();

class SelectNewGroupOwner extends StatefulWidget {
  final String? groupID;
  final TUIGroupProfileModel model;
  final ValueChanged<List<V2TimGroupMemberFullInfo>>? onSelectedMember;

  const SelectNewGroupOwner({
    this.groupID,
    Key? key,
    required this.model,
    this.onSelectedMember,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectNewGroupOwner();
}

class _SelectNewGroupOwner extends TIMUIKitState<SelectNewGroupOwner> {
  final CoreServicesImpl _coreServicesImpl = serviceLocator<CoreServicesImpl>();
  List<V2TimGroupMemberFullInfo> selectedMember = [];
  List<V2TimGroupMemberFullInfo?>? searchMemberList;
  String? searchText;


  @override
  void dispose() {
    super.dispose();
  }

  bool isSearchTextExist(String? searchText) {
    return searchText != null && searchText != "";
  }

  handleSearchGroupMembers(String searchText, context) async {
    searchText = searchText;
    List<V2TimGroupMemberFullInfo?> currentGroupMember = widget
        .model.groupMemberList
        .where(
            (element) => element?.userID != _coreServicesImpl.loginInfo.userID)
        .toList();
    final res =
        await widget.model.searchGroupMember(V2TimGroupMemberSearchParam(
      keywordList: [searchText],
      groupIDList: [widget.model.groupInfo!.groupID],
      isSearchMemberNameCard: true,
      isSearchMemberUserID: true,
      isSearchMemberNickName: true,
      isSearchMemberRemark: true,
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
      searchMemberList =
          isSearchTextExist(searchText) ? currentGroupMember : null;
    });
  }

  onSubmit() {
    if (widget.onSelectedMember != null) {
      widget.onSelectedMember!(selectedMember);
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    Widget memberBody() {
      return GroupProfileMemberList(
        customTopArea: PlatformUtils().isWeb
            ? null
            : GroupMemberSearchTextField(
                onTextChange: (text) => handleSearchGroupMembers(text, context),
              ),
        memberList: (searchMemberList ?? widget.model.groupMemberList)
            .where((element) =>
                element?.userID != _coreServicesImpl.loginInfo.userID)
            .toList(),
        canSlideDelete: false,
        canSelectMember: true,
        maxSelectNum: 1,
        onSelectedMemberChange: (member) {
          selectedMember = member;
          setState(() {});
        },
        touchBottomCallBack: () {},
      );
    }

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        defaultWidget: Scaffold(
            appBar: AppBar(
              shadowColor: theme.weakBackgroundColor,
              iconTheme: IconThemeData(
                color: theme.appbarTextColor,
              ),
              backgroundColor: theme.appbarBgColor ??
                  theme.primaryColor,
              leading: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  TIM_t("取消"),
                  style: TextStyle(
                    color: theme.appbarTextColor,
                    fontSize: 16,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (selectedMember.isNotEmpty) {
                      Navigator.pop(context, selectedMember);
                    }
                  },
                  child: Text(
                    TIM_t("完成"),
                    style: TextStyle(
                      color: theme.appbarTextColor,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
              centerTitle: true,
              leadingWidth: 100,
              title: Text(
                "转让群主",
                style: TextStyle(
                  color: theme.appbarTextColor,
                  fontSize: 16,
                ),
              ),
            ),
            body: memberBody()),
        desktopWidget: memberBody());
  }
}
