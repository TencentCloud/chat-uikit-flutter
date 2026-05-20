// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:azlistview_all_platforms/azlistview_all_platforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_contact/model/contact_presenter.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_group_member_info.dart';

// toxee: keep these in sync with lib/util/responsive_layout.dart —
// `masterDetailBreakpoint` (800) and the desktop max content width (1200).
// The UIKit fork can't import from the toxee app, so the constants live
// here; they move at most once per release.
const double _kToxeeMasterDetailBreakpoint = 800.0;
const double _kToxeeMasterDetailMaxWidth = 1200.0;

/// Wraps the AZ list in a max-width container when the viewport is wide
/// enough that an unconstrained list looks like a "postage stamp on 4K".
/// Below the master-detail breakpoint we pass the child through untouched
/// so phone/tablet layouts behave exactly as before.
Widget _toxeeConstrainWide(BuildContext context, Widget child) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < _kToxeeMasterDetailBreakpoint) return child;
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: _kToxeeMasterDetailMaxWidth),
    child: child,
  );
}

class ISuspensionBeanImpl<T> extends ISuspensionBean {
  String tagIndex;
  T memberInfo;

  ISuspensionBeanImpl({required this.tagIndex, required this.memberInfo});

  @override
  String getSuspensionTag() => tagIndex;
}

class TencentCloudChatGroupMemberList extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberInfoList;
  final Map<String, int>? lastMessageTimeMap;

  const TencentCloudChatGroupMemberList({
    Key? key,
    required this.groupInfo,
    required this.memberInfoList,
    this.lastMessageTimeMap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupMemberListState();
}

class TencentCloudChatGroupMemberListState extends TencentCloudChatState<TencentCloudChatGroupMemberList> {
  final Stream<TencentCloudChatGroupProfileData<dynamic>>? _groupProfileDataStream = TencentCloudChat
      .instance.eventBusInstance
      .on<TencentCloudChatGroupProfileData<dynamic>>("TencentCloudChatGroupProfileData");
  StreamSubscription<TencentCloudChatGroupProfileData<dynamic>>? _groupProfileDataSubscription;

  @override
  void initState() {
    super.initState();
    _addGroupProfileDataListener();
  }

  _addGroupProfileDataListener() {
    _groupProfileDataSubscription = _groupProfileDataStream?.listen(_groupProfileDataHandler);
  }

  _groupProfileDataHandler(TencentCloudChatGroupProfileData data) {
    if (data.currentUpdatedFields == TencentCloudChatGroupProfileDataKeys.updateMemberRole) {
      if (data.updateGroupID == widget.groupInfo.groupID) {
        bool needUpdate = false;
        List<V2TimGroupMemberInfo> updateMemberInfoList = data.updateMemberList;
        for (var updateMemberInfo in updateMemberInfoList) {
          var index = widget.memberInfoList.indexWhere((member) => member.userID == updateMemberInfo.userID);
          if (index >= 0) {
            widget.memberInfoList[index].role = data.updateMemberRole;
            needUpdate = true;
          }
        }
        if (needUpdate) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) =>
            Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    color: colorTheme.primaryColor,
                  ),
                  scrolledUnderElevation: 0.0,
                ),
                body: Container(
                    color: colorTheme.backgroundColor,
                    child: Center(
                      child: _toxeeConstrainWide(
                        context,
                        TencentCloudChatGroupMemberListAzList(
                          groupInfo: widget.groupInfo,
                          memberInfoList: widget.memberInfoList,
                          lastMessageTimeMap: widget.lastMessageTimeMap,
                        ),
                      ),
                    ))));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) =>
            Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    color: colorTheme.primaryColor,
                  ),
                  scrolledUnderElevation: 0.0,
                ),
                body: Container(
                    color: colorTheme.backgroundColor,
                    child: Center(
                      child: _toxeeConstrainWide(
                        context,
                        TencentCloudChatGroupMemberListAzList(
                          groupInfo: widget.groupInfo,
                          memberInfoList: widget.memberInfoList,
                          lastMessageTimeMap: widget.lastMessageTimeMap,
                        ),
                      ),
                    ))));
  }

  @override
  void dispose() {
    super.dispose();
    _groupProfileDataSubscription?.cancel();
  }
}

class TencentCloudChatGroupMemberListAzList extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberInfoList;
  final Map<String, int>? lastMessageTimeMap;

  const TencentCloudChatGroupMemberListAzList({
    Key? key,
    required this.groupInfo,
    required this.memberInfoList,
    this.lastMessageTimeMap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupMemberListAzListState();
}

class TencentCloudChatGroupMemberListAzListState extends TencentCloudChatState<TencentCloudChatGroupMemberListAzList> {
  ContactPresenter contactPresenter = ContactPresenter();
  Map tagCount = {};
  List<ISuspensionBeanImpl> list = [];
  int myRole = 0;

  @override
  initState() {
    super.initState();
    tagCount = {};
    list = _getListTag();
    final loginID = TencentCloudChat.instance.dataInstance.basic.currentUser!.userID;
    try {
      myRole = widget.memberInfoList
          .firstWhere((element) => element.userID == loginID)
          .role ?? 0;
    } catch (e) {
      // If current user not found in member list, default to member role
      myRole = 0; // V2TIM_GROUP_MEMBER_ROLE_MEMBER
    }
  }

  List<ISuspensionBeanImpl> _getListTag() {
    final List<ISuspensionBeanImpl> showList = List.empty(growable: true);
    final List<ISuspensionBeanImpl> adminAndOwner = List.empty(growable: true);
    for (var i = 0; i < widget.memberInfoList.length; i++) {
      final item = widget.memberInfoList[i];
      final name =
          TencentCloudChatUtils.checkString(widget.memberInfoList[i].nameCard) ??
              TencentCloudChatUtils.checkString(widget.memberInfoList[i].nickName) ?? widget.memberInfoList[i].userID;
      String tag = name.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: tag));
      } else {
        tag = "#";
        showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: "#"));
      }
      if (tagCount.containsKey(tag)) {
        tagCount[tag]++;
      } else {
        tagCount[tag] = 1;
      }
    }
    SuspensionUtil.sortListBySuspensionTag(showList);
    final List<ISuspensionBeanImpl> list = [];
    list..addAll(adminAndOwner)..addAll(showList);
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
            final item = list[index].memberInfo;
            return TencentCloudChatGroupMemberListItem(
              onDeleteGroupMember: () async {
                final deleteRes =
                await contactPresenter.kickGroupMember(groupID: widget.groupInfo.groupID, memberList: [item.userID]);
                if (deleteRes.code == 0) {
                  safeSetState(() {
                    list.removeWhere((element) => element.memberInfo.userID == item.userID);
                  });
                }
              },
              memberFullInfo: item,
              myRole: myRole,
              groupInfo: widget.groupInfo,
              lastMessageTime: widget.lastMessageTimeMap?[item.userID],
            );
          },
          indexBarData: SuspensionUtil.getTagIndexList(list).where((element) => element != "@").toList(),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          susItemBuilder: (context, index) {
            ISuspensionBeanImpl tag = list[index];
            return TencentCloudChatGroupMemberListTag(
              tag: tag.getSuspensionTag(),
              count: tagCount[tag.getSuspensionTag()],
            );
          },
          susItemHeight: getSquareSize(30),
        ));
  }
}

class TencentCloudChatGroupMemberListItem extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final V2TimGroupMemberFullInfo memberFullInfo;
  final int myRole;
  final Function() onDeleteGroupMember;
  final int? lastMessageTime;

  const TencentCloudChatGroupMemberListItem({super.key,
    required this.memberFullInfo,
    required this.myRole,
    required this.groupInfo,
    required this.onDeleteGroupMember,
    this.lastMessageTime});

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupMemberListItemState();
}

class TencentCloudChatGroupMemberListItemState extends TencentCloudChatState<TencentCloudChatGroupMemberListItem> {
  ContactPresenter contactPresenter = ContactPresenter();

  String _getRoleText() {
    switch (widget.memberFullInfo.role) {
      case GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER:
        return tL10n.groupOwner;
      case GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN:
        return tL10n.admin;
      default:
        return tL10n.groupMember;
    }
  }

  String _getLastMessageTimeText() {
    if (widget.lastMessageTime != null && widget.lastMessageTime! > 0) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(widget.lastMessageTime! * 1000);
      return TencentCloudChatIntl.getFormattedTimeString(dateTime: dateTime);
    }
    return '无';
  }

  bool canSetAdmin() {
    if (widget.groupInfo.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      return true;
    }

    return false;
  }

  bool canDeleteMember() {
    if (widget.memberFullInfo.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      return false;
    }

    if (widget.groupInfo.groupType == GroupType.AVChatRoom) {
      return false;
    }

    if (widget.myRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      return true;
    }

    if (widget.myRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN &&
        widget.memberFullInfo.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER) {
      return true;
    }

    return false;
  }

  _onSetMemberRole(GroupMemberRoleTypeEnum roleType) async {
    await contactPresenter.setGroupMemberRole(
        groupID: widget.groupInfo.groupID, userID: widget.memberFullInfo.userID, role: roleType);
  }

  bool isSelf() {
    return widget.memberFullInfo.userID == TencentCloudChat.instance.dataInstance.basic.currentUser!.userID;
  }

  Future<void> _copyMemberId() async {
    await Clipboard.setData(ClipboardData(text: widget.memberFullInfo.userID));
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('Tox ID copied'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showDesktopContextMenu(Offset globalPosition) async {
    if (isSelf()) {
      return;
    }
    final int role = widget.memberFullInfo.role ?? 0;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;

    final List<PopupMenuEntry<String>> items = <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: 'info',
        child: ListTile(
          leading: Icon(Icons.person_outline),
          title: Text('Info'),
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
      const PopupMenuItem<String>(
        value: 'copy',
        child: ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy Tox ID'),
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    ];
    if (canSetAdmin()) {
      items.add(
        PopupMenuItem<String>(
          value: 'admin',
          child: ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: Text(role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER
                ? tL10n.setAsAdmin
                : tL10n.dismissAdmin),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }
    if (canDeleteMember()) {
      items.add(
        PopupMenuItem<String>(
          value: 'remove',
          child: ListTile(
            leading: const Icon(Icons.person_remove_outlined, color: Colors.red),
            title: Text(tL10n.delete, style: const TextStyle(color: Colors.red)),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        overlay == null ? globalPosition.dx : overlay.size.width - globalPosition.dx,
        overlay == null ? globalPosition.dy : overlay.size.height - globalPosition.dy,
      ),
      items: items,
    );
    if (selected == null || !mounted) return;
    switch (selected) {
      case 'info':
        final isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
        if (isDesktop) {
          TencentCloudChatDialog.showCustomDialog(
            context: context,
            builder: (c) => TencentCloudChatGroupMemberInfo(
              memberFullInfo: widget.memberFullInfo,
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TencentCloudChatGroupMemberInfo(
                memberFullInfo: widget.memberFullInfo,
              ),
            ),
          );
        }
        break;
      case 'copy':
        await _copyMemberId();
        break;
      case 'admin':
        if (role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER) {
          await _onSetMemberRole(GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_ADMIN);
        } else {
          await _onSetMemberRole(GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER);
        }
        break;
      case 'remove':
        widget.onDeleteGroupMember();
        break;
    }
  }

  onManageMember() {
    if (isSelf()) {
      return;
    }

    int role = widget.memberFullInfo.role ?? 0;
    List<CupertinoActionSheetAction> actionList = [
      CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
          final isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
          if (isDesktop) {
            TencentCloudChatDialog.showCustomDialog(
                context: context,
                builder: (c) =>
                    TencentCloudChatGroupMemberInfo(
                      memberFullInfo: widget.memberFullInfo,
                    ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TencentCloudChatGroupMemberInfo(
                          memberFullInfo: widget.memberFullInfo,
                        )));
          }
        },
        child: Text(tL10n.info),
      ),
    ];
    if (canSetAdmin()) {
      actionList.add(
        CupertinoActionSheetAction(
          onPressed: () {
            if (role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER) {
              _onSetMemberRole(GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_ADMIN);
            } else {
              _onSetMemberRole(GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER);
            }
            Navigator.pop(context);
          },
          child:
          Text(role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER ? tL10n.setAsAdmin : tL10n.dismissAdmin),
        ),
      );
    }
    if (canDeleteMember()) {
      actionList.add(CupertinoActionSheetAction(
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
        builder: (BuildContext context) =>
            TencentCloudChatThemeWidget(
                build: (context, colorTheme, textStyle) =>
                    CupertinoActionSheet(
                      actions: actionList,
                      cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(tL10n.cancel)),
                    )));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final lastMessageTimeText = _getLastMessageTimeText();
    final roleText = _getRoleText();
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) =>
            Container(
              color: colorTheme.backgroundColor,
              child: GestureDetector(
                  onTap: onManageMember,
                  onSecondaryTapDown: TencentCloudChatPlatformAdapter().isDesktop
                      ? (TapDownDetails details) {
                          _showDesktopContextMenu(details.globalPosition);
                        }
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getHeight(10),
                      horizontal: getWidth(16),
                    ),
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: getWidth(16)),
                            child: TencentCloudChatAvatar(
                              imageList: [TencentCloudChatUtils.checkString(widget.memberFullInfo.faceUrl)],
                              width: getSquareSize(40),
                              height: getSquareSize(40),
                              borderRadius: getSquareSize(48),
                              scene: TencentCloudChatAvatarScene.groupProfile,
                            )),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        TencentCloudChatUtils.checkString(widget.memberFullInfo.nameCard) ??
                                            TencentCloudChatUtils.checkString(widget.memberFullInfo.nickName) ??
                                            widget.memberFullInfo.userID,
                                        style:
                                        TextStyle(color: colorTheme.groupProfileTextColor, fontSize: textStyle.fontsize_14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (widget.memberFullInfo.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        decoration: BoxDecoration(
                                          color: colorTheme.primaryColor.withAlpha(30),
                                          border: Border.all(color: colorTheme.primaryColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          tL10n.groupOwner,
                                          style: TextStyle(
                                            color: colorTheme.primaryColor,
                                            fontSize: textStyle.fontsize_10,
                                          ),
                                        ),
                                      ),
                                    if (widget.memberFullInfo.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        decoration: BoxDecoration(
                                          color: colorTheme.primaryColor.withAlpha(30),
                                          border: Border.all(color: colorTheme.primaryColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          tL10n.admin,
                                          style: TextStyle(
                                            color: colorTheme.primaryColor,
                                            fontSize: textStyle.fontsize_10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      roleText,
                                      style: TextStyle(
                                        color: colorTheme.groupProfileTabTextColor,
                                        fontSize: textStyle.fontsize_12,
                                      ),
                                    ),
                                    Text(
                                        '  ·  ',
                                        style: TextStyle(
                                          color: colorTheme.groupProfileTabTextColor,
                                          fontSize: textStyle.fontsize_12,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          lastMessageTimeText,
                                          style: TextStyle(
                                            color: colorTheme.groupProfileTabTextColor,
                                            fontSize: textStyle.fontsize_12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            )),
                        if (!isSelf()) Icon(Icons.arrow_forward_ios_rounded, color: colorTheme.groupProfileTabTextColor)
                      ],
                    ),
                  )),
            ));
  }
}

class TencentCloudChatGroupMemberListTag extends StatefulWidget {
  final String tag;
  final int? count;

  const TencentCloudChatGroupMemberListTag({
    Key? key,
    required this.tag,
    this.count,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupMemberListTagState();
}

class TencentCloudChatGroupMemberListTagState extends TencentCloudChatState<TencentCloudChatGroupMemberListTag> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) =>
            Container(
                decoration: BoxDecoration(
                  color: colorTheme.backgroundColor,
                ),
                height: getSquareSize(40),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
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
