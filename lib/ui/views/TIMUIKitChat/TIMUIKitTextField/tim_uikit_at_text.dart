import 'package:flutter/material.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_search_param.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_search_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member_search_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_ui_group_member_search.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/group_member_list.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme.dart';

class AtText extends StatefulWidget {
  final String? groupID;
  final V2TimGroupInfo? groupInfo;
  final List<V2TimGroupMemberFullInfo?>? groupMemberList;
  final VoidCallback? closeFunc;
  final Function(List<V2TimGroupMemberFullInfo> memberInfo)? onChooseMember;
  final bool canAtAll;

  // some Group type cant @all
  final String? groupType;

  const AtText({
    this.groupID,
    this.groupType,
    Key? key,
    this.groupInfo,
    this.groupMemberList,
    this.closeFunc,
    this.onChooseMember,
    this.canAtAll = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AtTextState();
}

class _AtTextState extends TIMUIKitState<AtText> {
  final GroupServices _groupServices = serviceLocator<GroupServices>();
  final TUISelfInfoViewModel _selfInfoViewModel = serviceLocator<TUISelfInfoViewModel>();

  List<V2TimGroupMemberFullInfo?>? groupMemberList;
  List<V2TimGroupMemberFullInfo?>? searchMemberList;

  List<V2TimGroupMemberFullInfo> selectedGroupMemberList = [];

  @override
  void initState() {
    groupMemberList = widget.groupMemberList;
    searchMemberList = groupMemberList;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submitAtMemberList() {
    if (widget.closeFunc != null) {
      widget.closeFunc!();
    }

    if (widget.onChooseMember != null) {
      widget.onChooseMember!(selectedGroupMemberList);
    } else {
      Navigator.pop(context, selectedGroupMemberList);
    }
  }

  Future<V2TimValueCallback<V2GroupMemberInfoSearchResult>> searchGroupMember(
      V2TimGroupMemberSearchParam searchParam) async {
    final res = await _groupServices.searchGroupMembers(searchParam: searchParam);

    if (res.code == 0) {}
    return res;
  }

  handleSearchGroupMembers(String searchText, context) async {
    final res = await searchGroupMember(V2TimGroupMemberSearchParam(
      keywordList: [searchText],
      groupIDList: [widget.groupID!],
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
      searchMemberList = list;
    }

    setState(() {
      searchMemberList = isSearchTextExist(searchText) ? searchMemberList : groupMemberList;
    });
  }

  bool isSearchTextExist(String? searchText) {
    return searchText != null && searchText != "";
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    V2TimUserFullInfo? loginUserInfo = _selfInfoViewModel.loginInfo;
    if (loginUserInfo != null) {
      searchMemberList?.removeWhere((memberInfo) {
        return memberInfo?.userID == loginUserInfo.userID;
      });
    }

    Widget mentionedMembersBody() {
      return GroupProfileMemberList(
          groupType: widget.groupType ?? "",
          memberList: searchMemberList ?? [],
          canAtAll: widget.canAtAll,
          canSelectMember: true,
          canSlideDelete: false,
          onSelectedMemberChange: (selectedMemberList) {
            selectedGroupMemberList = selectedMemberList;
            bool isAtAllSelected = selectedGroupMemberList.where((element) {
              return element.userID == GroupProfileMemberList.AT_ALL_USER_ID;
            }).isNotEmpty;

            if (isAtAllSelected) {
              _submitAtMemberList();
            }
          },
          touchBottomCallBack: () {
            // Get all by once, unnecessary to load more
          },
          customTopArea: PlatformUtils().isWeb
              ? null
              : GroupMemberSearchTextField(
                  onTextChange: (text) => handleSearchGroupMembers(text, context),
                ));
    }

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: mentionedMembersBody(),
        defaultWidget: Scaffold(
            appBar: AppBar(
              shadowColor: theme.weakBackgroundColor,
              iconTheme: IconThemeData(
                color: theme.appbarTextColor,
              ),
              backgroundColor: theme.appbarBgColor ?? theme.primaryColor,
              leading: Row(
                children: [
                  IconButton(
                    padding: const EdgeInsets.only(left: 16),
                    constraints: const BoxConstraints(),
                    icon: Image.asset(
                      'images/arrow_back.png',
                      package: 'tencent_cloud_chat_uikit',
                      height: 34,
                      width: 34,
                      color: theme.appbarTextColor,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              centerTitle: true,
              leadingWidth: 100,
              title: Text(
                TIM_t("选择提醒人"),
                style: TextStyle(
                  color: theme.appbarTextColor,
                  fontSize: 17,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _submitAtMemberList();
                  },
                  child: Text(
                    TIM_t("确定"),
                    style: TextStyle(
                      color: theme.appbarTextColor,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            body: mentionedMembersBody()));
  }
}
