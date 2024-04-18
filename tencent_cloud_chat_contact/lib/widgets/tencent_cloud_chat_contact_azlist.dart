import 'package:azlistview_all_platforms/azlistview_all_platforms.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_item.dart';

class TencentCloudChatContactAzlist extends StatefulWidget {
  final List<V2TimFriendInfo> contactList;
  final List<TTabItem>? tabList;

  const TencentCloudChatContactAzlist({super.key, required this.contactList, this.tabList});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAzlistState();
}

class TencentCloudChatContactAzlistState extends TencentCloudChatState<TencentCloudChatContactAzlist> {
  _getShowName(V2TimFriendInfo item) {
    final friendRemark = item.friendRemark ?? "";
    final nickName = item.userProfile?.nickName ?? "";
    final userID = item.userID;
    final showName = nickName != "" ? nickName : userID;
    return friendRemark != "" ? friendRemark : showName;
  }

  List<ISuspensionBeanImpl> _getFriendList() {
    final List<ISuspensionBeanImpl> showList = List.empty(growable: true);
    for (var i = 0; i < widget.contactList.length; i++) {
      final item = widget.contactList[i];
      final showName = _getShowName(item);
      String tag = showName.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        showList.add(
          ISuspensionBeanImpl(
            friendInfo: item,
            tagIndex: tag,
          ),
        );
      } else {
        showList.add(
          ISuspensionBeanImpl(
            friendInfo: item,
            tagIndex: "#",
          ),
        );
      }
    }
    SuspensionUtil.sortListBySuspensionTag(showList);
    SuspensionUtil.setShowSuspensionStatus(showList);
    return showList;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final showFriendList = _getFriendList();
    if (widget.tabList != null && widget.tabList!.isNotEmpty) {
      final topList = widget.tabList!.map((e) => ISuspensionBeanImpl(friendInfo: e, tagIndex: '@')).toList();
      showFriendList.insertAll(0, topList);
    }
    if (widget.contactList.isEmpty) {
      return TencentCloudChatThemeWidget(
        build: (context, colors, fontSize) => Column(
          children: [
            ...showFriendList.map((e) => TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactListTabItemBuilder(e.friendInfo)).toList(),
            Center(
              child: Text(
                tL10n.noContact,
                style: TextStyle(
                  fontSize: fontSize.fontsize_12,
                  color: colors.contactNoListColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scrollbar(
        child: AzListView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      data: showFriendList,
      itemCount: showFriendList.length,
      indexBarData: SuspensionUtil.getTagIndexList(showFriendList).where((element) => element != "@").toList(),
      itemBuilder: (context, index) {
        if (showFriendList[index].friendInfo is TTabItem) {
          return TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactListTabItemBuilder(showFriendList[index].friendInfo);
        } else {
          final friend = showFriendList[index].friendInfo;
          return TencentCloudChatContactItem(friend: friend);
        }
      },
      susItemBuilder: (context, index) {
        ISuspensionBeanImpl tag = showFriendList[index];
        if (tag.getSuspensionTag() == "@") {
          return Container();
        }
        return TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactListTagBuilder(tag.getSuspensionTag());
      },
      susItemHeight: getSquareSize(30),
    ));
  }
}

class ISuspensionBeanImpl<T> extends ISuspensionBean {
  String tagIndex;
  T friendInfo;

  ISuspensionBeanImpl({required this.tagIndex, required this.friendInfo});

  @override
  String getSuspensionTag() => tagIndex;
}
