import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_group_info.dart';
import 'dart:ui';

class TencentCloudChatContactAddGroup extends StatefulWidget {
  const TencentCloudChatContactAddGroup({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddGroupState();
}

class TencentCloudChatContactAddGroupState extends TencentCloudChatState<TencentCloudChatContactAddGroup> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        padding: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
        // color: Colors.blue.withOpacity(0.9),
        height: getHeight(800),
        decoration: BoxDecoration(
            color: colorTheme.contactAddContactBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(getWidth(10)))),
        child: const Scaffold(
            backgroundColor: Colors.transparent,
            appBar: TencentCloudChatContactAddGroupAppBar(),
            body: TencentCloudChatContactAddGroupBody()),
      ),
    );
  }
}

class TencentCloudChatContactAddGroupAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TencentCloudChatContactAddGroupAppBar({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddGroupAppBarState();

  @override
  Size get preferredSize => const Size(15, 50);
}

class TencentCloudChatContactAddGroupAppBarState extends TencentCloudChatState<TencentCloudChatContactAddGroupAppBar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              tL10n.addGroup,
              style: TextStyle(
                  fontSize: textStyle.fontsize_16,
                  fontWeight: FontWeight.w600,
                  color: colorTheme.contactItemFriendNameColor),
            ),
            centerTitle: true,
            leadingWidth: getWidth(100),
            leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: getWidth(15))),
                    Text(
                      tL10n.cancel,
                      style: TextStyle(
                        color: colorTheme.contactBackButtonColor,
                        fontSize: textStyle.fontsize_16,
                      ),
                    ),
                  ],
                ))));
  }
}

class TencentCloudChatContactAddGroupBody extends StatefulWidget {
  const TencentCloudChatContactAddGroupBody({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddGroupBodyState();
}

class TencentCloudChatContactAddGroupBodyState extends TencentCloudChatState<TencentCloudChatContactAddGroupBody> {
  final FocusNode _focusNode = FocusNode();
  bool isSearch = false;

  _startSearch() {
    safeSetState(() {
      isSearch = true;
    });
  }

  Widget beforeSearch() {
    // String userID = TencentCloudChat.instance.dataInstance.basic.currentUser!.userID ?? "";
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                GestureDetector(
                  onTap: _startSearch,
                  child: Container(
                    color: colorTheme.contactBackgroundColor,
                    padding: EdgeInsets.symmetric(vertical: getHeight(9), horizontal: getWidth(8)),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: getHeight(8)),
                      decoration: BoxDecoration(
                          color: colorTheme.contactSearchBackgroundColor,
                          borderRadius: BorderRadius.circular(getSquareSize(4))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: getSquareSize(14), color: colorTheme.contactNoListColor),
                          SizedBox(
                            width: getWidth(8),
                          ),
                          Text(
                            tL10n.groupID,
                            style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.contactNoListColor),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
  }

  final TextEditingController _searchID = TextEditingController();
  String searchID = "";

  onSearchIDChanged(String value) {
    searchID = value;
  }

  List<V2TimGroupInfo> groupList = [];

  _onSearchGroup() async {
    List<V2TimGroupInfo> list = await TencentCloudChat.instance.chatSDKInstance.contactSDK.getGroupsInfo([searchID]);
    safeSetState(() {
      groupList = list;
    });
  }

  Widget afterSearch() {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                Container(
                  color: colorTheme.contactAddContactBackgroundColor,
                  padding: EdgeInsets.symmetric(vertical: getHeight(6), horizontal: getWidth(8)),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: colorTheme.backgroundColor, borderRadius: BorderRadius.circular(getSquareSize(4))),
                        width: getWidth(280),
                        child: TextField(
                          autofocus: true,
                          focusNode: _focusNode,
                          controller: _searchID,
                          textAlign: TextAlign.start,
                          onChanged: (String value) {
                            onSearchIDChanged(value);
                          },
                          style: TextStyle(color: colorTheme.contactItemFriendNameColor),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: getHeight(6), horizontal: getWidth(12)),
                              border: InputBorder.none,
                              hintText: tL10n.searchGroupID,
                              isDense: true),
                          cursorColor: colorTheme.contactSearchCursorColor,
                          cursorRadius: Radius.circular(getSquareSize(2)),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: textStyle.fontsize_16,
                              fontWeight: FontWeight.w500,
                              color: colorTheme.contactSearchButtonColor),
                        ),
                        onPressed: () {
                          _onSearchGroup();
                          _focusNode.unfocus();
                        },
                        child: Text(tL10n.search),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: TencentCloudChatContactAddGroupList(
                  groupList: groupList,
                ))
              ],
            ));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    if (isSearch) {
      return afterSearch();
    }
    return beforeSearch();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _searchID.dispose();
  }
}

class TencentCloudChatContactAddGroupList extends StatefulWidget {
  final List<V2TimGroupInfo> groupList;

  const TencentCloudChatContactAddGroupList({super.key, required this.groupList});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddGroupListState();
}

class TencentCloudChatContactAddGroupListState extends TencentCloudChatState<TencentCloudChatContactAddGroupList> {
  @override
  Widget defaultBuilder(BuildContext context) {
    var list = widget.groupList;
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Center(
              child: list.isNotEmpty
                  ? ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return TencentCloudChatContactAddGroupListItem(
                          groupInfo: widget.groupList[index],
                        );
                      })
                  : Center(
                      child: Text(
                      tL10n.none,
                      style: TextStyle(
                        fontSize: textStyle.fontsize_12,
                        color: colorTheme.contactNoListColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
            ));
  }
}

class TencentCloudChatContactAddGroupListItem extends StatefulWidget {
  final V2TimGroupInfo groupInfo;

  const TencentCloudChatContactAddGroupListItem({super.key, required this.groupInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddGroupListItemState();
}

class TencentCloudChatContactAddGroupListItemState
    extends TencentCloudChatState<TencentCloudChatContactAddGroupListItem> {
  openGroupInfo() {
    showModalBottomSheet<void>(
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return TencentCloudChatContactAddGroupInfo(groupInfo: widget.groupInfo);
        });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => GestureDetector(
              onTap: openGroupInfo,
              child: Container(
                color: colorTheme.backgroundColor,
                margin: EdgeInsets.only(top: getHeight(10)),
                padding: EdgeInsets.symmetric(vertical: getHeight(10), horizontal: getWidth(3)),
                child: Row(
                  children: [
                    TencentCloudChatContactAddGroupListItemAvatar(
                      groupInfo: widget.groupInfo,
                    ),
                    TencentCloudChatContactAddGroupListItemContent(groupInfo: widget.groupInfo)
                  ],
                ),
              ),
            ));
  }
}

class TencentCloudChatContactAddGroupListItemAvatar extends StatefulWidget {
  final V2TimGroupInfo groupInfo;

  const TencentCloudChatContactAddGroupListItemAvatar({super.key, required this.groupInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddGroupListItemAvatarState();
}

class TencentCloudChatContactAddGroupListItemAvatarState
    extends TencentCloudChatState<TencentCloudChatContactAddGroupListItemAvatar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(13),
        ),
        child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
          scene: TencentCloudChatAvatarScene.contacts,
          imageList: [TencentCloudChatUtils.checkString(widget.groupInfo.faceUrl)],
          width: getSquareSize(50),
          height: getSquareSize(50),
          borderRadius: getSquareSize(48),
        ));
  }
}

class TencentCloudChatContactAddGroupListItemContent extends StatefulWidget {
  final V2TimGroupInfo groupInfo;

  const TencentCloudChatContactAddGroupListItemContent({super.key, required this.groupInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddGroupListItemContentState();
}

class TencentCloudChatContactAddGroupListItemContentState
    extends TencentCloudChatState<TencentCloudChatContactAddGroupListItemContent> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.groupInfo.groupName ?? widget.groupInfo.groupID,
                  style: TextStyle(
                      fontSize: textStyle.fontsize_16,
                      fontWeight: FontWeight.w600,
                      color: colorTheme.contactItemFriendNameColor),
                ),
                Text(
                  'ID:${widget.groupInfo.groupID}',
                  style: TextStyle(
                      fontSize: textStyle.fontsize_12,
                      fontWeight: FontWeight.w400,
                      color: colorTheme.contactItemFriendNameColor),
                ),
                Text(
                  'Type:${widget.groupInfo.groupType}',
                  style: TextStyle(
                      fontSize: textStyle.fontsize_12,
                      fontWeight: FontWeight.w400,
                      color: colorTheme.contactItemFriendNameColor),
                ),
              ],
            )));
  }
}
