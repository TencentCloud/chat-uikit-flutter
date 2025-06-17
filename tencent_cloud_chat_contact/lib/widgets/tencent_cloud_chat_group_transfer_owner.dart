// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_null_comparison
import 'package:azlistview_all_platforms/azlistview_all_platforms.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_contact/model/contact_presenter.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_group_member_list.dart';

class TencentCloudChatGroupTransferOwner extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberList;
  const TencentCloudChatGroupTransferOwner({super.key, required this.memberList, required this.groupInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupTransferOwnerState();
}

class TencentCloudChatGroupTransferOwnerState extends TencentCloudChatState<TencentCloudChatGroupTransferOwner> {
  ContactPresenter contactPresenter = ContactPresenter();
  List<V2TimGroupMemberFullInfo> memberList = [];

  @override
  void initState() {
    super.initState();
    memberList.addAll(widget.memberList);
    memberList.removeWhere((memberInfo) => (memberInfo.userID == widget.groupInfo.owner));
  }

  submitTransfer() async {
    await contactPresenter.transferGroupOwner(groupID: widget.groupInfo.groupID, userID: selectedMember!.userID);
  }

  V2TimGroupMemberFullInfo? selectedMember;
  onChanged(selected) {
    selectedMember = selected;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_rounded),
                color: colorTheme.primaryColor,
              ),
              title: Text(
                tL10n.transferGroupOwner,
                style: TextStyle(
                    fontSize: textStyle.fontsize_16,
                    fontWeight: FontWeight.w600,
                    color: colorTheme.contactItemFriendNameColor),
              ),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () async {
                    submitTransfer();
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
            body: TencentCloudChatGroupTransferMemberList(
              memberList: memberList,
              onSelectedMemberItemChange: onChanged,
            )));
  }
}

class TencentCloudChatGroupTransferMemberList extends StatefulWidget {
  final List<V2TimGroupMemberFullInfo> memberList;
  final Function onSelectedMemberItemChange;
  const TencentCloudChatGroupTransferMemberList({
    Key? key,
    required this.memberList,
    required this.onSelectedMemberItemChange,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupTransferMemberListState();
}

class TencentCloudChatGroupTransferMemberListState extends TencentCloudChatState<TencentCloudChatGroupTransferMemberList> {
  List<ISuspensionBeanImpl> list = [];
  V2TimGroupMemberFullInfo? selectedMember;
  @override
  initState() {
    super.initState();
    list = _getListTag();
  }

  _getShowName(V2TimGroupMemberFullInfo item) {
    final nameCard = item.nameCard;
    final friendRemark = item.friendRemark ?? "";
    final nickName = item.nickName ?? "";
    final userID = item.userID;
    if (nameCard != null && nameCard.isNotEmpty) {
      return nameCard;
    } else if (friendRemark != null && friendRemark.isNotEmpty) {
      return friendRemark;
    } else if (nickName != null && nickName.isNotEmpty) {
      return nickName;
    } else {
      return userID;
    }
  }

  List<ISuspensionBeanImpl> _getListTag() {
    final List<ISuspensionBeanImpl> showList = List.empty(growable: true);

    for (var i = 0; i < widget.memberList.length; i++) {
      final item = widget.memberList[i];
      final name = TencentCloudChatUtils.checkString(item.nameCard) ?? item.userID;
      String tag = name.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: tag));
      } else {
        tag = "#";
        showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: "#"));
      }
    }

    SuspensionUtil.sortListBySuspensionTag(showList);
    SuspensionUtil.setShowSuspensionStatus(showList);
    return showList;
  }

  Widget _buildItem(V2TimGroupMemberFullInfo item) {
    final showName = _getShowName(item);
    final faceUrl = item.faceUrl ?? "";

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
                      isChecked: selectedMember == item,
                      onChanged: (isChecked) {
                        if (isChecked) {
                          selectedMember = item;
                        } else {
                          selectedMember = null;
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
    return Scrollbar(
        child: AzListView(
      data: list,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index].memberInfo;
        return InkWell(
          onTap: () {
            selectedMember = item;
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
