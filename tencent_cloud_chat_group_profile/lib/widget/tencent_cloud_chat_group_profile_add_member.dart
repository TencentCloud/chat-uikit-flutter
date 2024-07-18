// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_null_comparison
import 'package:azlistview_all_platforms/azlistview_all_platforms.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_member_list.dart';

class TencentCloudChatGroupProfileAddMember extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberList;
  final List<V2TimFriendInfo> contactList;
  const TencentCloudChatGroupProfileAddMember({super.key, required this.memberList, required this.contactList, required this.groupInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfileAddMemberState();
}

class TencentCloudChatGroupProfileAddMemberState extends TencentCloudChatState<TencentCloudChatGroupProfileAddMember> {
  submitAdd() async {
    List<String> userIDList = [];
    for (int i = 0; i < selectedContacts.length; i++) {
      userIDList.add(selectedContacts[i].userID);
    }
    await TencentCloudChat.instance.chatSDKInstance.groupSDK.inviteUserToGroup(groupID: widget.groupInfo.groupID, userList: userIDList);
  }

  List<V2TimFriendInfo> selectedContacts = [];
  onChanged(selected) {
    selectedContacts = selected;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
            appBar: AppBar(
              title: Text(
                tL10n.addMembers,
                style: const TextStyle(fontSize: 17),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    submitAdd();
                    Navigator.pop(context);
                  },
                  child: Text(
                    tL10n.confirm,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            body: TencentCloudChatGroupProfilAddMemberList(
              contactList: widget.contactList,
              memberList: widget.memberList,
              onSelectedMemberItemChange: onChanged,
            )));
  }
}

class TencentCloudChatGroupProfilAddMemberList extends StatefulWidget {
  final List<V2TimGroupMemberFullInfo> memberList;
  final List<V2TimFriendInfo>? contactList;
  final Function onSelectedMemberItemChange;
  const TencentCloudChatGroupProfilAddMemberList({
    Key? key,
    required this.memberList,
    this.contactList,
    required this.onSelectedMemberItemChange,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfilAddMemberListState();
}

class TencentCloudChatGroupProfilAddMemberListState extends TencentCloudChatState<TencentCloudChatGroupProfilAddMemberList> {
  List<ISuspensionBeanImpl> list = [];
  List<V2TimFriendInfo> selectedMember = [];
  List<V2TimGroupMemberFullInfo> selectedSilencedMember = [];
  @override
  initState() {
    super.initState();
    list = _getListTag();
  }

  _getShowName(V2TimFriendInfo item) {
    final friendRemark = item.friendRemark ?? "";
    final nickName = item.userProfile?.nickName ?? "";
    final userID = item.userID;
    final showName = nickName != "" ? nickName : userID;
    return friendRemark != "" ? friendRemark : showName;
  }

  List<ISuspensionBeanImpl> _getListTag() {
    final List<ISuspensionBeanImpl> showList = List.empty(growable: true);
    if (widget.contactList != null) {
      for (var i = 0; i < widget.contactList!.length; i++) {
        final item = widget.contactList![i];
        final name = TencentCloudChatUtils.checkString(widget.contactList![i].userProfile?.nickName) ?? widget.contactList![i].userID;
        String tag = name.substring(0, 1).toUpperCase();
        if (RegExp("[A-Z]").hasMatch(tag)) {
          showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: tag));
        } else {
          tag = "#";
          showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: "#"));
        }
      }
    } else {
      for (var i = 0; i < widget.memberList.length; i++) {
        final item = widget.memberList[i];
        final name = TencentCloudChatUtils.checkString(item.nameCard) ?? item.userID;
        String tag = name.substring(0, 1).toUpperCase();
        if (RegExp("[A-Z]").hasMatch(tag)) {
          showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: tag));
        } else {
          tag = "#";
          showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: "#"));
        }
      }
    }

    SuspensionUtil.sortListBySuspensionTag(showList);
    SuspensionUtil.setShowSuspensionStatus(showList);
    return showList;
  }

  Widget _buildItem(V2TimFriendInfo item) {
    final showName = _getShowName(item);
    final faceUrl = item.userProfile?.faceUrl ?? "";

    bool disabled = false;
    if (widget.memberList != null && widget.memberList.isNotEmpty) {
      disabled = ((widget.memberList.indexWhere((element) => element.userID == item.userID))) > -1;
    }

    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              padding: EdgeInsets.symmetric(
                vertical: getHeight(8),
                horizontal: getWidth(16),
              ),
              color: colorTheme.backgroundColor,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12, bottom: 8),
                    child: CheckBoxButton(
                      disabled: disabled,
                      isChecked: selectedMember.contains(item),
                      onChanged: (isChecked) {
                        if (isChecked) {
                          selectedMember.add(item);
                        } else {
                          selectedMember.remove(item);
                        }
                        if (widget.onSelectedMemberItemChange != null) {
                          widget.onSelectedMemberItemChange(selectedMember);
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 12),
                    margin: const EdgeInsets.only(right: 12),
                    child: TencentCloudChatAvatar(
                      imageList: [TencentCloudChatUtils.checkString(faceUrl)],
                      scene: TencentCloudChatAvatarScene.groupProfile,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 10, bottom: 20, right: 28),
                    child: Text(
                      showName,
                      style: TextStyle(color: colorTheme.groupProfileTextColor, fontSize: textStyle.fontsize_14),
                    ),
                  )),
                ],
              ),
            ));
  }

  Widget _buildMemberSilencedItem(V2TimGroupMemberFullInfo item) {
    bool disabled = false;
    final currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    if (item.muteUntil != null && item.muteUntil! > 0) {
      disabled = item.muteUntil! * 1000 > currentTimeStamp;
    }
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              padding: EdgeInsets.symmetric(
                vertical: getHeight(8),
                horizontal: getWidth(16),
              ),
              color: colorTheme.backgroundColor,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12, bottom: 8),
                    child: CheckBoxButton(
                      disabled: disabled,
                      isChecked: selectedSilencedMember.contains(item),
                      onChanged: (isChecked) {
                        if (isChecked) {
                          selectedSilencedMember.add(item);
                        } else {
                          selectedSilencedMember.remove(item);
                        }
                        if (widget.onSelectedMemberItemChange != null) {
                          widget.onSelectedMemberItemChange(selectedSilencedMember);
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 12),
                    margin: const EdgeInsets.only(right: 12),
                    child: TencentCloudChatAvatar(
                      imageList: [TencentCloudChatUtils.checkString(item.faceUrl)],
                      scene: TencentCloudChatAvatarScene.groupProfile,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 10, bottom: 20, right: 28),
                    child: Text(
                      TencentCloudChatUtils.checkString(item.nameCard) ?? item.userID,
                      style: TextStyle(color: colorTheme.groupProfileTextColor, fontSize: textStyle.fontsize_14),
                    ),
                  )),
                ],
              ),
            ));
  }

  Widget _buildTag(String tag) {
    return Container(
        height: getSquareSize(40),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 16.0, bottom: 5),
        // color: Color.fromARGB(255, 255, 255, 255),
        alignment: Alignment.bottomLeft,
        child: TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => Text(
                  tag,
                  style: TextStyle(
                    fontSize: textStyle.fontsize_14,
                    fontWeight: FontWeight.w600,
                    color: colorTheme.contactItemFriendNameColor,
                  ),
                )));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    if (widget.contactList != null) {
      return Scrollbar(
          child: AzListView(
        data: list,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index].friendInfo;
          return InkWell(
            onTap: () {
              if (selectedMember.contains(item)) {
                selectedMember.remove(item);
              } else {
                selectedMember.add(item);
              }
              if (widget.onSelectedMemberItemChange != null) {
                widget.onSelectedMemberItemChange(selectedMember);
              }
              setState(() {});
              return;
            },
            child: _buildItem(item),
          );
        },
        indexBarData: SuspensionUtil.getTagIndexList(list).where((element) => element != "@").toList(),
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        susItemHeight: getSquareSize(30),
        susItemBuilder: (context, index) {
          ISuspensionBeanImpl tag = list[index];
          if (tag.getSuspensionTag() == "@") {
            return Container();
          }
          return _buildTag(tag.getSuspensionTag());
        },
      ));
    }
    return Scrollbar(
        child: AzListView(
      data: list,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index].friendInfo;
        return InkWell(
          onTap: () {
            if (selectedSilencedMember.contains(item)) {
              selectedSilencedMember.remove(item);
            } else {
              selectedSilencedMember.add(item);
            }
            widget.onSelectedMemberItemChange(selectedSilencedMember);
                      setState(() {});
            return;
          },
          child: _buildMemberSilencedItem(item),
        );
      },
      indexBarData: SuspensionUtil.getTagIndexList(list).where((element) => element != "@").toList(),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      susItemHeight: getSquareSize(30),
      susItemBuilder: (context, index) {
        ISuspensionBeanImpl tag = list[index];
        if (tag.getSuspensionTag() == "@") {
          return Container();
        }
        return _buildTag(tag.getSuspensionTag());
      },
    ));
  }
}

class CheckBoxButton extends StatelessWidget {
  final bool isChecked;
  final Function(bool isChecked)? onChanged;
  final bool disabled;
  final bool onlyShow;
  final double? size;

  const CheckBoxButton({this.disabled = false, Key? key, this.size, this.onlyShow = false, required this.isChecked, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration = !isChecked ? BoxDecoration(border: Border.all(color: Colors.black), shape: BoxShape.circle, color: Colors.white) : const BoxDecoration(shape: BoxShape.circle, color: Colors.blue);

    if (disabled) {
      boxDecoration = const BoxDecoration(shape: BoxShape.circle, color: Colors.grey);
    }
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Center(
            child: onlyShow
                ? Container(
                    height: size ?? 22,
                    width: size ?? 22,
                    decoration: boxDecoration,
                    child: Icon(
                      Icons.check,
                      size: size != null ? (size! / 2) : 11,
                      color: Colors.white,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      if (onChanged != null && !disabled) {
                        onChanged!(!isChecked);
                      }
                    },
                    child: Container(
                      height: size ?? 22,
                      width: size ?? 22,
                      decoration: boxDecoration,
                      child: Icon(
                        Icons.check,
                        size: size != null ? (size! / 2) : 11,
                        color: Colors.white,
                      ),
                    ),
                  )));
  }
}
