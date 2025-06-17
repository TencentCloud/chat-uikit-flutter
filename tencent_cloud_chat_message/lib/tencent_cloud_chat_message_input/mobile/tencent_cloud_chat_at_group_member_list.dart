// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:azlistview_all_platforms/azlistview_all_platforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/utils/sdk_const.dart';

class ISuspensionBeanImpl<T> extends ISuspensionBean {
  String tagIndex;
  T memberInfo;

  ISuspensionBeanImpl({required this.tagIndex, required this.memberInfo});

  @override
  String getSuspensionTag() => tagIndex;
}

class TencentCloudChatAtGroupMemberList extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberInfoList;

  const TencentCloudChatAtGroupMemberList({
    Key? key,
    required this.groupInfo,
    required this.memberInfoList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatAtGroupMemberListState();
}

class TencentCloudChatAtGroupMemberListState extends TencentCloudChatState<TencentCloudChatAtGroupMemberList> {
  final List<V2TimGroupMemberFullInfo> selectMembers = [];

  void _onSelectGroupMember(bool isSelect, V2TimGroupMemberFullInfo memberFullInfo) {
    if (isSelect) {
      selectMembers.add(memberFullInfo);
      if (memberFullInfo.userID == SDKConst.sdkAtAllUserID) {
        _submitAtMemberList();
      }
    } else {
      selectMembers.removeWhere((element) => element.userID == memberFullInfo.userID);
    }
  }

  void _submitAtMemberList() {
    Navigator.pop(context, selectMembers);
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            color: colorTheme.backgroundColor,
            child: Center(
              child: TencentCloudChatGroupProfileMemberListAzList(
                groupInfo: widget.groupInfo,
                memberInfoList: widget.memberInfoList,
                onSelectGroupMember: _onSelectGroupMember,
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
                onTap: () async {
                  _submitAtMemberList();
                },
                child: Row(children: [
                  Padding(padding: EdgeInsets.only(left: getWidth(10))),
                  Icon(
                    Icons.arrow_back_ios_outlined,
                    color: colorTheme.primaryColor,
                    size: getSquareSize(24),
                  ),
                  Padding(padding: EdgeInsets.only(left: getWidth(8))),
                  Text(
                    tL10n.back,
                    style: TextStyle(
                      color: colorTheme.primaryColor,
                      fontSize: textStyle.fontsize_14,
                    ),
                  )
                ]),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _submitAtMemberList();
                  },
                  child: Text(
                    tL10n.confirm,
                    style: TextStyle(
                      color: colorTheme.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
              scrolledUnderElevation: 0.0,
            ),
            body: Container(
                color: colorTheme.backgroundColor,
                child: Center(
                  child: TencentCloudChatGroupProfileMemberListAzList(
                    groupInfo: widget.groupInfo,
                    memberInfoList: widget.memberInfoList,
                    onSelectGroupMember: _onSelectGroupMember,
                  ),
                ))));
  }
}

class TencentCloudChatGroupProfileMemberListAzList extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberInfoList;
  final Function(bool isSelect, V2TimGroupMemberFullInfo memberFullInfo) onSelectGroupMember;

  const TencentCloudChatGroupProfileMemberListAzList({
    Key? key,
    required this.groupInfo,
    required this.memberInfoList,
    required this.onSelectGroupMember,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfileMemberListAzListState();
}

class TencentCloudChatGroupProfileMemberListAzListState
    extends TencentCloudChatState<TencentCloudChatGroupProfileMemberListAzList> {
  List<ISuspensionBeanImpl> list = [];

  @override
  initState() {
    super.initState();
    list = _getListTag();
  }

  List<ISuspensionBeanImpl> _getListTag() {
    final List<ISuspensionBeanImpl> showList = List.empty(growable: true);
    for (var i = 0; i < widget.memberInfoList.length; i++) {
      final item = widget.memberInfoList[i];
      String showName = widget.memberInfoList[i].userID;
      if (TencentCloudChatUtils.checkString(widget.memberInfoList[i].nickName) != null) {
        showName = widget.memberInfoList[i].nickName!;
      }

      String showNamePinyin = PinyinHelper.getPinyinE(showName);
      String tag = showNamePinyin.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: tag));
      } else {
        tag = "#";
        showList.add(ISuspensionBeanImpl(memberInfo: item, tagIndex: "#"));
      }
    }
    SuspensionUtil.sortListBySuspensionTag(showList);
    // add @everyone item
    final canAtGroupType = ["Work", "Public", "Meeting"];
    if (canAtGroupType.contains(widget.groupInfo.groupType)) {
      showList.insert(
          0,
          ISuspensionBeanImpl(
              memberInfo: V2TimGroupMemberFullInfo(
                  userID: SDKConst.sdkAtAllUserID, nickName: tL10n.atAll),
              tagIndex: ""));
    }
    SuspensionUtil.setShowSuspensionStatus(showList);
    return showList;
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
        return TencentCloudChatGroupProfileMemberListItem(
          onSelectGroupMember: (bool isSelect) async {
            widget.onSelectGroupMember(isSelect, item);
          },
          memberFullInfo: item,
          groupInfo: widget.groupInfo,
        );
      },
      indexBarData: SuspensionUtil.getTagIndexList(list),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      susItemBuilder: (context, index) {
        ISuspensionBeanImpl tag = list[index];
        if (tag.getSuspensionTag() == "") {
          return Container();
        } else {
          return TencentCloudChatGroupProfileMemberListTag(
            tag: tag.getSuspensionTag(),
          );
        }
      },
      susItemHeight: getSquareSize(0),
    ));
  }
}

class TencentCloudChatGroupProfileMemberListItem extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final V2TimGroupMemberFullInfo memberFullInfo;
  final Function(bool isSelect) onSelectGroupMember;

  const TencentCloudChatGroupProfileMemberListItem(
      {super.key, required this.memberFullInfo, required this.groupInfo, required this.onSelectGroupMember});

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfileMemberListItemState();
}

class TencentCloudChatGroupProfileMemberListItemState
    extends TencentCloudChatState<TencentCloudChatGroupProfileMemberListItem> {
  bool isSelected = false;

  @override
  Widget defaultBuilder(BuildContext context) {
    String showName = widget.memberFullInfo.userID;
    if (TencentCloudChatUtils.checkString(widget.memberFullInfo.nickName) != null) {
      showName = widget.memberFullInfo.nickName!;
    }

    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              color: colorTheme.backgroundColor,
              child: InkWell(
                  onTap: () {
                    isSelected = !isSelected;
                    widget.onSelectGroupMember(isSelected);
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getHeight(8),
                      horizontal: getWidth(8),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          side: BorderSide(width: 1, color: colorTheme.primaryTextColor),
                          onChanged: (bool? value) {
                            isSelected = value ?? false;
                            widget.onSelectGroupMember(isSelected);
                            setState(() {});
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: getWidth(16)),
                            child: TencentCloudChatAvatar(
                              imageList: [TencentCloudChatUtils.checkString(widget.memberFullInfo.faceUrl)],
                              width: getSquareSize(40),
                              height: getSquareSize(40),
                              borderRadius: getSquareSize(20),
                              scene: TencentCloudChatAvatarScene.groupProfile,
                            )),
                        Expanded(
                            child: Text(
                          showName,
                          style: TextStyle(color: colorTheme.groupProfileTextColor, fontSize: textStyle.fontsize_14),
                        )),
                      ],
                    ),
                  )),
            ));
  }
}

class TencentCloudChatGroupProfileMemberListTag extends StatefulWidget {
  final String tag;

  const TencentCloudChatGroupProfileMemberListTag({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfileMemberListTagState();
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
            alignment: Alignment.bottomLeft,
            child: Text(
              "${widget.tag}",
              style: TextStyle(
                fontSize: textStyle.fontsize_14,
                fontWeight: FontWeight.w400,
                color: colorTheme.contactItemFriendNameColor,
              ),
            )));
  }
}
