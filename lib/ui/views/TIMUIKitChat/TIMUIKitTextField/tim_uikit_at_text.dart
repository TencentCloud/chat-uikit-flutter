import 'package:azlistview_all_platforms/azlistview_all_platforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable_for_tencent_im/flutter_slidable.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/optimize_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_ui_group_member_search.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/az_list_view.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/radio_button.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class AtText extends StatefulWidget {
  final String? groupID;
  final V2TimGroupInfo? groupInfo;
  final List<V2TimGroupMemberFullInfo?>? groupMemberList;
  final VoidCallback? closeFunc;
  final Function(
          V2TimGroupMemberFullInfo memberInfo, TapDownDetails? tapDetails)?
      onChooseMember;
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

  List<V2TimGroupMemberFullInfo?>? _groupMemberList;
  List<V2TimGroupMemberFullInfo?>? _searchMemberList;

  List<V2TimGroupMemberFullInfo?>? get _realMemberList =>
      _searchMemberList?.isNotEmpty == true
          ? _searchMemberList
          : _groupMemberList ?? [];

  late EasyRefreshController _refreshController;
  late ScrollController _scrollController;
  String _nextSeq = '';

  Future<void> _getMemberList() async {
    if (_nextSeq == '0') return;
    try {
      final res = await _groupServices.getGroupMemberList(
        groupID: widget.groupID ?? '',
        filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
        count: 20,
        nextSeq: _nextSeq.isEmpty ? '0' : _nextSeq,
      );
      final groupMemberListRes = res.data;

      if (res.code == 0 && groupMemberListRes != null) {
        final groupMemberListTemp = groupMemberListRes.memberInfoList ?? [];
        _groupMemberList = [...?_groupMemberList, ...groupMemberListTemp];
        _nextSeq = groupMemberListRes.nextSeq ?? '0';
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('getGroupMemberList error: $e');
    }
  }

  @override
  void initState() {
    _refreshController = EasyRefreshController();
    _scrollController = ScrollController();
    _groupMemberList = widget.groupMemberList;
    _searchMemberList = _groupMemberList;
    _getMemberList();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _onTapMemberItem(
      V2TimGroupMemberFullInfo memberInfo, TapDownDetails? tapDetails) {
    if (widget.closeFunc != null) {
      widget.closeFunc!();
    }

    if (widget.onChooseMember != null) {
      widget.onChooseMember!(memberInfo, tapDetails);
    } else {
      Navigator.pop(context, memberInfo);
    }
  }

  Future<V2TimValueCallback<V2GroupMemberInfoSearchResult>> _searchGroupMember(
      V2TimGroupMemberSearchParam searchParam) async {
    final res =
        await _groupServices.searchGroupMembers(searchParam: searchParam);

    if (res.code == 0) {}
    return res;
  }

  _handleSearchGroupMembers(String searchText, context) async {
    final res = await _searchGroupMember(V2TimGroupMemberSearchParam(
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
      _searchMemberList = list;
    }

    if (mounted) {
      setState(() {
        _searchMemberList = _isSearchTextExist(searchText)
            ? _searchMemberList
            : _groupMemberList;
      });
    }
  }

  bool _isSearchTextExist(String? searchText) {
    return searchText != null && searchText != "";
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    Widget mentionedMembersBody() {
      return AtTextMemberList(
        groupType: widget.groupType ?? "",
        memberList: _realMemberList ?? [],
        onTapMemberItem: _onTapMemberItem,
        canAtAll: widget.canAtAll,
        canSlideDelete: false,
        touchBottomCallBack: () {
          _getMemberList();
        },
      );
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
        ),
        body: Column(
          children: [
            GroupMemberSearchTextField(
              onTextChange: (text) => _handleSearchGroupMembers(text, context),
            ),
            Expanded(
              child: mentionedMembersBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class AtTextMemberList extends StatefulWidget {
  final List<V2TimGroupMemberFullInfo?> memberList;
  final Function(String userID)? removeMember;
  final bool canSlideDelete;
  final bool canSelectMember;
  final bool canAtAll;

  // when the @ need filter some group types
  final String? groupType;
  final Function(List<V2TimGroupMemberFullInfo> selectedMember)?
      onSelectedMemberChange;
  // notice: onTapMemberItem and onSelectedMemberChange use together will triger together
  final Function(
          V2TimGroupMemberFullInfo memberInfo, TapDownDetails? tapDetails)?
      onTapMemberItem;
  // When sliding to the bottom bar callBack
  final Function()? touchBottomCallBack;

  final int? maxSelectNum;

  const AtTextMemberList({
    Key? key,
    required this.memberList,
    this.groupType,
    this.removeMember,
    this.canSlideDelete = true,
    this.canSelectMember = false,
    this.canAtAll = false,
    this.onSelectedMemberChange,
    this.onTapMemberItem,
    this.touchBottomCallBack,
    this.maxSelectNum,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AtTextMemberListState();
}

class _AtTextMemberListState extends TIMUIKitState<AtTextMemberList> {
  List<V2TimGroupMemberFullInfo> selectedMember = [];

  _getShowName(V2TimGroupMemberFullInfo? item) {
    final friendRemark = item?.friendRemark ?? "";
    final nameCard = item?.nameCard ?? "";
    final nickName = item?.nickName ?? "";
    final userID = item?.userID ?? "";
    return friendRemark.isNotEmpty
        ? friendRemark
        : nameCard.isNotEmpty
            ? nameCard
            : nickName.isNotEmpty
                ? nickName
                : userID;
  }

  List<ISuspensionBeanImpl> _getShowList(
      List<V2TimGroupMemberFullInfo?> memberList) {
    final List<ISuspensionBeanImpl> showList = List.empty(growable: true);
    for (var i = 0; i < memberList.length; i++) {
      final item = memberList[i];
      final showName = _getShowName(item);
      if (item?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER ||
          item?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN) {
        showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: "@"));
      } else {
        String pinyin = PinyinHelper.getPinyinE(showName);
        String tag = pinyin.substring(0, 1).toUpperCase();
        if (RegExp("[A-Z]").hasMatch(tag)) {
          showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: tag));
        } else {
          showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: "#"));
        }
      }
    }

    SuspensionUtil.sortListBySuspensionTag(showList);

    // add @everyone item
    if (widget.canAtAll) {
      final canAtGroupType = ["Work", "Public", "Meeting"];
      if (canAtGroupType.contains(widget.groupType)) {
        showList.insert(
          0,
          ISuspensionBeanImpl(
            memberInfo: V2TimGroupMemberFullInfo(
                userID: "__kImSDK_MesssageAtALL__", nickName: TIM_t("所有人")),
            tagIndex: "",
          ),
        );
      }
    }

    return showList;
  }

  List<V2TimGroupMemberFullInfo?> get _memberList {
    if (widget.canAtAll && widget.memberList.isNotEmpty) {
      return [
        V2TimGroupMemberFullInfo(
            userID: "__kImSDK_MesssageAtALL__", nickName: TIM_t("所有人")),
        ...widget.memberList,
      ];
    }
    return widget.memberList;
  }

  Widget _buildListItem(
      BuildContext context, V2TimGroupMemberFullInfo memberInfo) {
    final theme = Provider.of<TUIThemeViewModel>(context).theme;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor() == DeviceType.Desktop;
    final isGroupMember =
        memberInfo.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER;
    return Container(
      color: Colors.white,
      child: Slidable(
        endActionPane: widget.canSlideDelete && isGroupMember
            ? ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      if (widget.removeMember != null) {
                        widget.removeMember!(memberInfo.userID);
                      }
                    },
                    flex: 1,
                    backgroundColor:
                        theme.cautionColor ?? CommonColor.cautionColor,
                    autoClose: true,
                    label: TIM_t("删除"),
                  ),
                ],
              )
            : null,
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.black,
              title: Row(
                children: [
                  if (widget.canSelectMember)
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: CheckBoxButton(
                        onChanged: (isChecked) {
                          if (isChecked) {
                            if (widget.maxSelectNum != null &&
                                selectedMember.length >= widget.maxSelectNum!) {
                              return;
                            }
                            selectedMember.add(memberInfo);
                          } else {
                            selectedMember.remove(memberInfo);
                          }
                          if (widget.onSelectedMemberChange != null) {
                            widget.onSelectedMemberChange!(selectedMember);
                          }
                          setState(() {});
                        },
                        isChecked: selectedMember.contains(memberInfo),
                      ),
                    ),
                  Container(
                    width: isDesktopScreen ? 30 : 36,
                    height: isDesktopScreen ? 30 : 36,
                    margin: const EdgeInsets.only(right: 10),
                    child: Avatar(
                      faceUrl: memberInfo.faceUrl ?? "",
                      showName: _getShowName(memberInfo),
                      type: 1,
                    ),
                  ),
                  Text(
                    _getShowName(memberInfo),
                    style: TextStyle(
                      fontSize: isDesktopScreen ? 14 : 16,
                    ),
                  ),
                  memberInfo.role ==
                          GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER
                      ? Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Text(
                            TIM_t("群主"),
                            style: TextStyle(
                              color: theme.ownerColor,
                              fontSize: isDesktopScreen ? 10 : 12,
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.ownerColor ?? CommonColor.ownerColor,
                              width: 1,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                          ),
                        )
                      : memberInfo.role ==
                              GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN
                          ? Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                TIM_t("管理员"),
                                style: TextStyle(
                                  color: theme.adminColor,
                                  fontSize: 12,
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: theme.adminColor ??
                                        CommonColor.adminColor,
                                    width: 1),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                              ),
                            )
                          : Container()
                ],
              ),
              onTap: () {
                if (widget.onTapMemberItem != null) {
                  widget.onTapMemberItem!(memberInfo, null);
                }
                if (widget.canSelectMember) {
                  final isChecked = selectedMember.contains(memberInfo);
                  if (isChecked) {
                    selectedMember.remove(memberInfo);
                  } else {
                    if (widget.maxSelectNum != null &&
                        selectedMember.length >= widget.maxSelectNum!) {
                      return;
                    }
                    selectedMember.add(memberInfo);
                  }
                  if (widget.onSelectedMemberChange != null) {
                    widget.onSelectedMemberChange!(selectedMember);
                  }
                  setState(() {});
                }
              },
            ),
            Divider(
              thickness: 1,
              indent: 74,
              endIndent: 0,
              color: theme.weakBackgroundColor,
              height: 0,
            )
          ],
        ),
      ),
    );
  }

  static Widget getSusItem(BuildContext context, TUITheme theme, String tag,
      {double susHeight = 40}) {
    if (tag == '@') {
      tag = TIM_t("群主、管理员");
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 16.0),
      color: theme.weakBackgroundColor,
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: true,
        style: TextStyle(
          fontSize: 14.0,
          color: theme.darkTextColor,
        ),
      ),
    );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor() == DeviceType.Desktop;

    final throteFunction =
        OptimizeUtils.throttle((ScrollNotification notification) {
      final pixels = notification.metrics.pixels;
      // 总像素高度
      final maxScrollExtent = notification.metrics.maxScrollExtent;
      // 滑动百分比
      final progress = pixels / maxScrollExtent;
      if (progress >= 0.9 && widget.touchBottomCallBack != null) {
        widget.touchBottomCallBack!();
      }
    }, 300);

    return Container(
      color: isDesktopScreen ? null : theme.weakBackgroundColor,
      child: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            throteFunction(notification);
            return true;
          },
          child: _memberList.isEmpty
              ? Center(
                  child: Text(TIM_t("暂无群成员")),
                )
              : ListView.builder(
                  itemCount: _memberList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final memberInfo = _memberList[index];

                    return memberInfo == null
                        ? const SizedBox()
                        : _buildListItem(context, memberInfo);
                  },
                ),
        ),
      ),
    );

    // final showList = _getShowList(_memberList);
    // return Container(
    //   color: isDesktopScreen ? null : theme.weakBackgroundColor,
    //   child: SafeArea(
    //     child: NotificationListener<ScrollNotification>(
    //       onNotification: (ScrollNotification notification) {
    //         throteFunction(notification);
    //         return true;
    //       },
    //       child: showList.isEmpty
    //           ? Center(
    //               child: Text(TIM_t("暂无群成员")),
    //             )
    //           : Container(
    //               padding: isDesktopScreen
    //                   ? const EdgeInsets.symmetric(horizontal: 16)
    //                   : null,
    //               child: AZListViewContainer(
    //                 memberList: showList,
    //                 susItemBuilder: (context, index) {
    //                   final model = showList[index];
    //                   return getSusItem(
    //                       context, theme, model.getSuspensionTag());
    //                 },
    //                 itemBuilder: (context, index) {
    //                   final memberInfo = showList[index].memberInfo
    //                       as V2TimGroupMemberFullInfo;

    //                   return _buildListItem(context, memberInfo);
    //                 },
    //               ),
    //             ),
    //     ),
    //   ),
    // );
  }
}
