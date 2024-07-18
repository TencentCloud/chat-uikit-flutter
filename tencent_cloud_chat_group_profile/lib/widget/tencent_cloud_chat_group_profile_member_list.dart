// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:azlistview_all_platforms/azlistview_all_platforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_member_info.dart';

class ISuspensionBeanImpl<T> extends ISuspensionBean {
  String tagIndex;
  T friendInfo;

  ISuspensionBeanImpl({required this.tagIndex, required this.friendInfo});

  @override
  String getSuspensionTag() => tagIndex;
}

class TencentCloudChatGroupProfileMemberList extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberInfoList;
  const TencentCloudChatGroupProfileMemberList({
    Key? key,
    required this.groupInfo,
    required this.memberInfoList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileMemberListState();
}

class TencentCloudChatGroupProfileMemberListState
    extends TencentCloudChatState<TencentCloudChatGroupProfileMemberList> {
  @override
  Widget? desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            color: colorTheme.backgroundColor,
            child: Center(
              child: TencentCloudChatGroupProfileMemberListAzList(
                groupInfo: widget.groupInfo,
                memberInfoList: widget.memberInfoList,
              ),
            )));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
            appBar: AppBar(
              leadingWidth: getWidth(100),
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(children: [
                  Padding(padding: EdgeInsets.only(left: getWidth(10))),
                  Icon(
                    Icons.arrow_back_ios_outlined,
                    color: colorTheme.contactBackButtonColor,
                    size: getSquareSize(24),
                  ),
                  Padding(padding: EdgeInsets.only(left: getWidth(8))),
                  Text(
                    tL10n.back,
                    style: TextStyle(
                      color: colorTheme.contactBackButtonColor,
                      fontSize: textStyle.fontsize_14,
                    ),
                  )
                ]),
              ),
            ),
            body: Container(
                color: colorTheme.backgroundColor,
                child: Center(
                  child: TencentCloudChatGroupProfileMemberListAzList(
                    groupInfo: widget.groupInfo,
                    memberInfoList: widget.memberInfoList,
                  ),
                ))));
  }
}

class TencentCloudChatGroupProfileMemberListAzList extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberInfoList;
  const TencentCloudChatGroupProfileMemberListAzList({
    Key? key,
    required this.groupInfo,
    required this.memberInfoList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileMemberListAzListState();
}

class TencentCloudChatGroupProfileMemberListAzListState
    extends TencentCloudChatState<
        TencentCloudChatGroupProfileMemberListAzList> {
  Map tagCount = {};
  List<ISuspensionBeanImpl> list = [];
  int myRole = 0;
  @override
  initState() {
    super.initState();
    tagCount = {};
    list = _getListTag();
    final loginID =
        TencentCloudChat.instance.dataInstance.basic.currentUser!.userID;
    myRole = widget.memberInfoList
            .firstWhere((element) => element.userID == loginID)
            .role ??
        0;
  }

  List<ISuspensionBeanImpl> _getListTag() {
    final List<ISuspensionBeanImpl> showList = List.empty(growable: true);
    final List<ISuspensionBeanImpl> adminAndOwner = List.empty(growable: true);
    for (var i = 0; i < widget.memberInfoList.length; i++) {
      final item = widget.memberInfoList[i];
      final name = TencentCloudChatUtils.checkString(
              widget.memberInfoList[i].nameCard) ??
          widget.memberInfoList[i].userID;
      String tag = name.substring(0, 1).toUpperCase();
      final role = item.role;
      if (role != null &&
          role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN) {
        adminAndOwner.add(
            ISuspensionBeanImpl(friendInfo: item, tagIndex: "Administrator"));
        tag = "Administrator";
      } else if (role != null &&
          role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
        tag = "Owner";
        adminAndOwner
            .add(ISuspensionBeanImpl(friendInfo: item, tagIndex: "Owner"));
      } else if (RegExp("[A-Z]").hasMatch(tag)) {
        showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: tag));
      } else {
        tag = "#";
        showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: "#"));
      }
      if (tagCount.containsKey(tag)) {
        tagCount[tag]++;
      } else {
        tagCount[tag] = 1;
      }
    }
    SuspensionUtil.sortListBySuspensionTag(showList);
    final List<ISuspensionBeanImpl> list = [];
    list
      ..addAll(adminAndOwner)
      ..addAll(showList);
    SuspensionUtil.setShowSuspensionStatus(list);
    return list;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    if (widget.memberInfoList.isEmpty) {
      return Container();
    }
    return Scrollbar(
        child: AzListView(
      data: list,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index].friendInfo;
        return TencentCloudChatGroupProfileMemberListItem(
          onDeleteGroupMember: () async {
            final deleteRes = await TencentCloudChat
                .instance.chatSDKInstance.groupSDK
                .kickGroupMember(
                    groupID: widget.groupInfo.groupID,
                    memberList: [item.userID]);
            if (deleteRes.code == 0) {
              safeSetState(() {
                list.removeWhere(
                    (element) => element.friendInfo.userID == item.userID);
              });
            }
          },
          memberFullInfo: item,
          myRole: myRole,
          groupInfo: widget.groupInfo,
        );
      },
      indexBarData: SuspensionUtil.getTagIndexList(list)
          .where((element) => element != "@")
          .toList(),
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      susItemBuilder: (context, index) {
        ISuspensionBeanImpl tag = list[index];
        return TencentCloudChatGroupProfileMemberListTag(
          tag: tag.getSuspensionTag(),
          count: tagCount[tag.getSuspensionTag()],
        );
      },
      susItemHeight: getSquareSize(30),
    ));
  }
}

class TencentCloudChatGroupProfileMemberListItem extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final V2TimGroupMemberFullInfo memberFullInfo;
  final int myRole;
  final Function() onDeleteGroupMember;
  const TencentCloudChatGroupProfileMemberListItem(
      {super.key,
      required this.memberFullInfo,
      required this.myRole,
      required this.groupInfo,
      required this.onDeleteGroupMember});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileMemberListItemState();
}

class TencentCloudChatGroupProfileMemberListItemState
    extends TencentCloudChatState<TencentCloudChatGroupProfileMemberListItem> {
  bool canSetAdmin() {
    if (widget.memberFullInfo.role ==
        GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      return false;
    }
    if (widget.groupInfo.groupType == GroupType.AVChatRoom ||
        widget.groupInfo.groupType == GroupType.Work) {
      return false;
    }
    if (widget.myRole != GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN) {
      return false;
    }
    return true;
  }

  bool canDeleteMember() {
    if (widget.memberFullInfo.role ==
        GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      return false;
    }
    if (widget.groupInfo.groupType == GroupType.AVChatRoom) {
      return false;
    }
    if (widget.groupInfo.groupType == GroupType.Work) {
      if (widget.myRole != GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
        return false;
      }
      return true;
    }
    if (widget.myRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      return true;
    }
    if (widget.myRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN &&
        widget.memberFullInfo.role ==
            GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER) {
      return true;
    }
    return false;
  }

  _onSetMemberRole(GroupMemberRoleTypeEnum roleType) async {
    await TencentCloudChat.instance.chatSDKInstance.groupSDK.setGroupMemberRole(
        groupID: widget.groupInfo.groupID,
        userID: widget.memberFullInfo.userID,
        role: roleType);
  }

  onManageMember() {
    int role = widget.memberFullInfo.role ?? 0;
    List<CupertinoActionSheetAction> action = [
      CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
          final isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
          if (isDesktop) {
            TencentCloudChatDialog.showCustomDialog(
                context: context,
                builder: (c) => TencentCloudChatGroupProfileMemberInfo(
                      memberFullInfo: widget.memberFullInfo,
                    ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TencentCloudChatGroupProfileMemberInfo(
                          memberFullInfo: widget.memberFullInfo,
                        )));
          }
        },
        child: Text(tL10n.info),
      ),
    ];
    if (canSetAdmin()) {
      action.insert(
        1,
        CupertinoActionSheetAction(
          onPressed: () {
            if (role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER) {
              _onSetMemberRole(
                  GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_ADMIN);
            } else {
              _onSetMemberRole(
                  GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_ADMIN);
            }
            Navigator.pop(context);
          },
          child: Text(role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER
              ? tL10n.setAsAdmin
              : tL10n.dismissAdmin),
        ),
      );
    }
    if (canDeleteMember()) {
      action.insert(
          1,
          CupertinoActionSheetAction(
            onPressed: () {
              widget.onDeleteGroupMember();
              Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: Text(tL10n.delete),
          ));
    }
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => CupertinoActionSheet(
                  actions: action,
                  cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(tL10n.cancel)),
                )));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              color: colorTheme.backgroundColor,
              child: GestureDetector(
                  onTap: onManageMember,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getHeight(8),
                      horizontal: getWidth(16),
                    ),
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: getWidth(16)),
                            child: TencentCloudChatAvatar(
                              imageList: [
                                TencentCloudChatUtils.checkString(
                                    widget.memberFullInfo.faceUrl)
                              ],
                              width: getSquareSize(40),
                              height: getSquareSize(40),
                              borderRadius: getSquareSize(48),
                              scene: TencentCloudChatAvatarScene.groupProfile,
                            )),
                        Expanded(
                            child: Text(
                          TencentCloudChatUtils.checkString(
                                  widget.memberFullInfo.nameCard) ??
                              widget.memberFullInfo.userID,
                          style: TextStyle(
                              color: colorTheme.groupProfileTextColor,
                              fontSize: textStyle.fontsize_14),
                        )),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: colorTheme.groupProfileTabTextColor,
                        )
                      ],
                    ),
                  )),
            ));
  }
}

class TencentCloudChatGroupProfileMemberListTag extends StatefulWidget {
  final String tag;
  final int? count;
  const TencentCloudChatGroupProfileMemberListTag({
    Key? key,
    required this.tag,
    this.count,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileMemberListTagState();
}

class TencentCloudChatGroupProfileMemberListTagState
    extends TencentCloudChatState<TencentCloudChatGroupProfileMemberListTag> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            decoration: BoxDecoration(
              color: colorTheme.backgroundColor,
            ),
            height: getSquareSize(40),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 16.0, bottom: 3),
            // color: Color.fromARGB(255, 255, 255, 255),
            alignment: Alignment.bottomLeft,
            child: Text(
              "${widget.tag} (${widget.count})",
              style: TextStyle(
                fontSize: textStyle.fontsize_14,
                fontWeight: FontWeight.w400,
                color: colorTheme.contactItemFriendNameColor,
              ),
            )));
  }
}
