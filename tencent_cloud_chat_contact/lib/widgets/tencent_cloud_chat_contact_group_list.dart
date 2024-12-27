// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:azlistview_all_platforms/azlistview_all_platforms.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_azlist.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_leading.dart';

class TencentCloudChatContactGroupList extends StatefulWidget {
  final List<V2TimGroupInfo> groupList;

  const TencentCloudChatContactGroupList({
    Key? key,
    required this.groupList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupListState();
}

class TencentCloudChatContactGroupListState extends TencentCloudChatState<TencentCloudChatContactGroupList> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
            appBar: AppBar(
              leadingWidth: getWidth(100),
              leading: const TencentCloudChatContactLeading(),
              title: Text(
                tL10n.myGroup,
                style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.contactItemFriendNameColor),
              ),
              centerTitle: true,
              backgroundColor: colorTheme.contactBackgroundColor,
            ),
            body: Container(
              color: colorTheme.contactApplicationBackgroundColor,
              child: Center(
                child: TencentCloudChatContactGroupAzList(groupList: widget.groupList),
              ),
            )));
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
                body: Container(
              color: colorTheme.contactApplicationBackgroundColor,
              child: Center(
                child: TencentCloudChatContactGroupAzList(groupList: widget.groupList),
              ),
            )));
  }
}

class TencentCloudChatContactGroupAzList extends StatefulWidget {
  final List<V2TimGroupInfo> groupList;

  const TencentCloudChatContactGroupAzList({super.key, required this.groupList});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupAzListState();
}

class TencentCloudChatContactGroupAzListState extends TencentCloudChatState<TencentCloudChatContactGroupAzList> {
  Map tagCount = {};

  List<ISuspensionBeanImpl> _getGroupList() {
    final List<ISuspensionBeanImpl> showList = List.empty(growable: true);
    for (var i = 0; i < widget.groupList.length; i++) {
      final item = widget.groupList[i];
      final name = widget.groupList[i].groupName ?? widget.groupList[i].groupID;
      String tag = name.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: tag));
      } else {
        tag = "#";
        showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: "#"));
      }
      if (tagCount.containsKey(tag)) {
        int value = tagCount[tag];
        tagCount[tag] = value + 1;
      } else {
        tagCount[tag] = 1;
      }
    }
    SuspensionUtil.sortListBySuspensionTag(showList);
    SuspensionUtil.setShowSuspensionStatus(showList);
    return showList;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final showList = _getGroupList();
    if (widget.groupList.isEmpty) {
      return TencentCloudChatThemeWidget(
          build: (context, colors, fontSize) => Center(
                child: Text(
                  // localization tL10n.noContact
                  tL10n.noContact,
                  style: TextStyle(
                    fontSize: fontSize.fontsize_12,
                    color: colors.contactNoListColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ));
    }
    return Scrollbar(
        child: AzListView(
      indexBarData: SuspensionUtil.getTagIndexList(showList).where((element) => element != "@").toList(),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      data: showList,
      itemCount: showList.length,
      itemBuilder: (context, index) {
        final group = showList[index].friendInfo;
        return TencentCloudChatContactGroupItem(group: group);
      },
      susItemBuilder: (context, index) {
        ISuspensionBeanImpl tag = showList[index];
        return TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactGroupListTagBuilder(tag.getSuspensionTag(), tagCount[tag.getSuspensionTag()]);
      },
      susItemHeight: getSquareSize(30),
    ));
  }
}

class TencentCloudChatContactGroupItem extends StatefulWidget {
  final V2TimGroupInfo group;

  const TencentCloudChatContactGroupItem({super.key, required this.group});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupItemState();
}

class TencentCloudChatContactGroupItemState extends TencentCloudChatState<TencentCloudChatContactGroupItem> {
  final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
  navigateToChat() async {
    final tryUseOnNavigateToChat = await TencentCloudChat.instance.dataInstance.contact.contactEventHandlers?.uiEventHandlers.onNavigateToChat?.call(userID: null, groupID: widget.group.groupID) ?? false;
    if(!tryUseOnNavigateToChat){
      if (TencentCloudChat.instance.dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.message)) {
        if(!isDesktop){
          navigateToMessage(
            context: context,
            options: TencentCloudChatMessageOptions(
              userID: null,
              groupID: widget.group.groupID,
            ),
          );
        } else {
          final conv = await TencentCloudChat.instance.chatSDKInstance.conversationSDK.getConversation(
            groupID: widget.group.groupID,
          );
          TencentCloudChat.instance.dataInstance.conversation.currentConversation = conv;
        }
      }
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, color, textStyle) => Material(
              color: color.backgroundColor,
              child: InkWell(
                  onTap: navigateToChat,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getHeight(7),
                      horizontal: getWidth(3),
                    ),
                    child: Row(children: [TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactGroupListItemAvatarBuilder(widget.group), TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactGroupListItemContentBuilder(widget.group)]),
                  )),
            ));
  }
}

class TencentCloudChatContactGroupItemAvatar extends StatefulWidget {
  final V2TimGroupInfo group;

  const TencentCloudChatContactGroupItemAvatar({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupItemAvatarState();
}

class TencentCloudChatContactGroupItemAvatarState extends TencentCloudChatState<TencentCloudChatContactGroupItemAvatar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(13),
        ),
        child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
          scene: TencentCloudChatAvatarScene.contacts,
          imageList: [TencentCloudChatUtils.checkString(widget.group.faceUrl)],
          width: getSquareSize(40),
          height: getSquareSize(40),
          borderRadius: getSquareSize(58),
        ));
  }
}

class TencentCloudChatContactGroupItemContent extends StatefulWidget {
  final V2TimGroupInfo group;

  const TencentCloudChatContactGroupItemContent({super.key, required this.group});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupItemContentState();
}

class TencentCloudChatContactGroupItemContentState extends TencentCloudChatState<TencentCloudChatContactGroupItemContent> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Expanded(
        child: TencentCloudChatThemeWidget(
            build: (context, color, text) => Row(
                  children: [
                    Text(
                      widget.group.groupName ?? widget.group.groupID,
                      style: TextStyle(
                        fontSize: text.fontsize_14,
                        fontWeight: FontWeight.w400,
                        color: color.contactItemFriendNameColor,
                      ),
                    )
                  ],
                )));
  }
}

class TencentCloudChatContactGroupListTag extends StatefulWidget {
  final String tag;
  final int? count;

  const TencentCloudChatContactGroupListTag({super.key, required this.tag, this.count});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupListTagState();
}

class TencentCloudChatContactGroupListTagState extends TencentCloudChatState<TencentCloudChatContactGroupListTag> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            color: colorTheme.contactApplicationBackgroundColor,
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

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            decoration: BoxDecoration(
              color: colorTheme.backgroundColor,
              border: Border(
                  bottom: BorderSide(
                width: 1,
                color: colorTheme.contactItemTabItemBorderColor,
              )),
            ),
            height: getSquareSize(40),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 16.0, bottom: 3),
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

class TencentCloudChatContactGroupListData {
  final List<V2TimGroupInfo> groupList;

  TencentCloudChatContactGroupListData({required this.groupList});

  Map<String, dynamic> toMap() {
    return {'groupList': groupList.toString()};
  }

  static TencentCloudChatContactGroupListData fromMap(Map<String, dynamic> map) {
    return TencentCloudChatContactGroupListData(groupList: map['groupList'] as List<V2TimGroupInfo>);
  }
}
