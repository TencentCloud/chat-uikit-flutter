// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_contacts_info.dart';

class TencentCloudChatContactAddContacts extends StatefulWidget {
  const TencentCloudChatContactAddContacts({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsState();
}

class TencentCloudChatContactAddContactsState extends TencentCloudChatState<TencentCloudChatContactAddContacts> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              height: getHeight(800),
              decoration: BoxDecoration(color: colorTheme.contactAddContactBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(getWidth(10)))),
              child: const Scaffold(
                backgroundColor: Colors.transparent,
                appBar: TencentCloudChatContactAddContactsAppBar(),
                body: TencentCloudChatContactAddContactBody(),
              ),
            ));
  }
}

class TencentCloudChatContactAddContactsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TencentCloudChatContactAddContactsAppBar({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsAppBarState();

  @override
  Size get preferredSize => const Size(15, 50);
}

class TencentCloudChatContactAddContactsAppBarState extends TencentCloudChatState<TencentCloudChatContactAddContactsAppBar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              tL10n.addContact,
              style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.contactItemFriendNameColor),
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

class TencentCloudChatContactAddContactBody extends StatefulWidget {
  const TencentCloudChatContactAddContactBody({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactBodyState();
}

class TencentCloudChatContactAddContactBodyState extends TencentCloudChatState<TencentCloudChatContactAddContactBody> {
  bool isSearch = false;

  _startSearch() {
    safeSetState(() {
      isSearch = true;
    });
  }

  Widget beforeSearch() {
    String userID = TencentCloudChat.instance.dataInstance.basic.currentUser!.userID ?? "";
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
                      decoration: BoxDecoration(color: colorTheme.contactSearchBackgroundColor, borderRadius: BorderRadius.circular(getSquareSize(4))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: getSquareSize(14), color: colorTheme.contactNoListColor),
                          SizedBox(
                            width: getWidth(8),
                          ),
                          Text(
                            "User ID",
                            style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.contactNoListColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  transformAlignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: getHeight(3)),
                  child: Text(
                    "My User ID: $userID ",
                    style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.contactNoListColor),
                  ),
                )
              ],
            ));
  }

  List<V2TimUserFullInfo> userList = [];

  _onSearchUser(String searchID) async {
    List<V2TimUserFullInfo> list = await TencentCloudChat.instance.chatSDKInstance.contactSDK.getUsersInfo([searchID]);
    safeSetState(() {
      userList = list;
    });
  }

  Widget afterSearch() {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                TencentCloudChatContactAddContactSearchBar(searchUser: _onSearchUser),
                Expanded(
                    child: TencentCloudChatContactAddContactList(
                  userFullInfoList: userList,
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
}

class TencentCloudChatContactAddContactSearchBar extends StatefulWidget {
  final Function searchUser;

  const TencentCloudChatContactAddContactSearchBar({super.key, required this.searchUser});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactSearchBarState();
}

class TencentCloudChatContactAddContactSearchBarState extends TencentCloudChatState<TencentCloudChatContactAddContactSearchBar> {
  final TextEditingController _searchID = TextEditingController();
  String searchID = "";

  onSearchIDChanged(String value) {
    searchID = value;
  }

  _searchUser() {
    widget.searchUser(searchID);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              color: colorTheme.contactAddContactBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: getHeight(6), horizontal: getWidth(8)),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(color: colorTheme.backgroundColor, borderRadius: BorderRadius.circular(getSquareSize(4))),
                    width: getWidth(300),
                    child: TextField(
                      autofocus: true,
                      controller: _searchID,
                      textAlign: TextAlign.start,
                      onChanged: (String value) {
                        onSearchIDChanged(value);
                      },
                      style: TextStyle(color: colorTheme.contactItemFriendNameColor),
                      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: getHeight(6), horizontal: getWidth(12)), border: InputBorder.none, hintText: 'Search User ID', isDense: true),
                      cursorColor: colorTheme.contactSearchCursorColor,
                      cursorRadius: Radius.circular(getSquareSize(2)),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w500, color: colorTheme.contactSearchButtonColor),
                    ),
                    onPressed: _searchUser,
                    child: const Text('Search'),
                  )
                ],
              ),
            ));
  }
}

class TencentCloudChatContactAddContactList extends StatefulWidget {
  final List<V2TimUserFullInfo> userFullInfoList;

  const TencentCloudChatContactAddContactList({
    Key? key,
    required this.userFullInfoList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactListState();
}

class TencentCloudChatContactAddContactListState extends TencentCloudChatState<TencentCloudChatContactAddContactList> {
  @override
  Widget defaultBuilder(BuildContext context) {
    var list = widget.userFullInfoList;
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Center(
              child: list.isNotEmpty
                  ? ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return TencentCloudChatContactAddContactListItem(userFullInfo: widget.userFullInfoList[index]);
                      })
                  : Container(
                      padding: EdgeInsets.only(top: getHeight(33)),
                      child: Center(
                          child: Text(
                        tL10n.none,
                        style: TextStyle(
                          fontSize: textStyle.fontsize_12,
                          color: colorTheme.contactNoListColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ))),
            ));
  }
}

class TencentCloudChatContactAddContactListItem extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatContactAddContactListItem({
    Key? key,
    required this.userFullInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactListItemState();
}

class TencentCloudChatContactAddContactListItemState extends TencentCloudChatState<TencentCloudChatContactAddContactListItem> {
  openContactsInfo() {
    showModalBottomSheet<void>(
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return TencentCloudChatContactAddContactsInfo(userFullInfo: widget.userFullInfo);
        });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => GestureDetector(
            onTap: openContactsInfo,
            child: Container(
              color: colorTheme.backgroundColor,
              margin: EdgeInsets.only(top: getHeight(10)),
              padding: EdgeInsets.symmetric(vertical: getHeight(10), horizontal: getWidth(3)),
              child: Row(children: [TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAddContactListItemAvatarBuilder(widget.userFullInfo), TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAddContactListItemContentBuilder(widget.userFullInfo)]),
            )));
  }
}

class TencentCloudChatContactAddContactListItemAvatar extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatContactAddContactListItemAvatar({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactListItemAvatarState();
}

class TencentCloudChatContactAddContactListItemAvatarState extends TencentCloudChatState<TencentCloudChatContactAddContactListItemAvatar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(13),
        ),
        child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
          scene: TencentCloudChatAvatarScene.contacts,
          imageList: [TencentCloudChatUtils.checkString(widget.userFullInfo.faceUrl)],
          width: getSquareSize(43),
          height: getSquareSize(43),
          borderRadius: getSquareSize(41),
        ));
  }
}

class TencentCloudChatChontactAddContactListItemContent extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatChontactAddContactListItemContent({
    Key? key,
    required this.userFullInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactsAddContactListItemContentState();
}

class TencentCloudChatContactsAddContactListItemContentState extends TencentCloudChatState<TencentCloudChatChontactAddContactListItemContent> {
  getNickName() {
    String nick = "";
    if (widget.userFullInfo.nickName != null && widget.userFullInfo.nickName!.isNotEmpty) {
      nick = widget.userFullInfo.nickName!;
    } else {
      nick = (widget.userFullInfo.selfSignature ?? widget.userFullInfo.userID)!;
    }
    return nick;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                getNickName(),
                style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.contactItemFriendNameColor),
              ),
              Text(
                'ID:${widget.userFullInfo.userID}',
                style: TextStyle(fontSize: textStyle.fontsize_12, fontWeight: FontWeight.w400, color: colorTheme.contactItemFriendNameColor),
              ),
            ])));
  }
}
