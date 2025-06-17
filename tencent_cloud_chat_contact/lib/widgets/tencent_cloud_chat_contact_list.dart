import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_azlist.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_group_list.dart';

class TencentCloudChatContactList extends StatefulWidget {
  final List<V2TimFriendInfo> contactList;
  final List<TTabItem>? tabList;
  final List<V2TimGroupInfo> groupList;

  const TencentCloudChatContactList({
    super.key,
    required this.contactList,
    this.tabList,
    required this.groupList,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactListState();
}

class TencentCloudChatContactListState extends TencentCloudChatState<TencentCloudChatContactList> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatContactAzlist(contactList: widget.contactList, tabList: widget.tabList);
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: 1,
              color: colorTheme.dividerColor,
            ),
          ),
        ),
        child: DefaultTabController(
          length: 2,
          child: Container(
            color: colorTheme.backgroundColor,
            child: Column(
              children: [
                TabBar(
                  isScrollable: false,
                  labelColor: colorTheme.primaryColor,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelColor: colorTheme.secondaryTextColor,
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: colorTheme.primaryColor,
                  tabs: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(top: 2),
                      child: Text(tL10n.contacts),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(top: 2),
                      child: Text(tL10n.groups),
                    ),
                  ],
                ),
                Expanded(
                    child: TabBarView(
                  children: [
                    TencentCloudChatContactAzlist(contactList: widget.contactList, tabList: widget.tabList),
                    TencentCloudChatContactGroupList(groupList: widget.groupList),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
