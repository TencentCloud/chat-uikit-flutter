library tencent_cloud_chat_contact;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/empty_page/tencent_cloud_chat_empty_page.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_builders.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_config.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_controller.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_event_handlers.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_options.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_app_bar.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application_info.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_block_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_group_application_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_group_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_tab.dart';

class TencentCloudChatContact extends TencentCloudChatComponent<TencentCloudChatContactOptions, TencentCloudChatContactConfig, TencentCloudChatContactBuilders, TencentCloudChatContactEventHandlers, TencentCloudChatContactController> {
  const TencentCloudChatContact({super.key, super.options, super.config, super.builders, super.eventHandlers, super.controller});

  @override
  TencentCloudChatContactState createState() => TencentCloudChatContactState();
}

class TencentCloudChatContactState extends TencentCloudChatState<TencentCloudChatContact> {
  final Stream<TencentCloudChatContactData<dynamic>>? _contactDataStream = TencentCloudChat.eventBusInstance.on<TencentCloudChatContactData<dynamic>>();
  late StreamSubscription<TencentCloudChatContactData<dynamic>>? _contactDataSubscription;

  List<V2TimFriendApplication> applicationList = [];

  List<V2TimGroupInfo> _groupList = [];

  List<V2TimFriendInfo> _blockList = [];

  List<V2TimFriendInfo> _contactsList = [];

  List<V2TimGroupApplication> _groupApplicationList = [];

  int _applicationUnreadCount = 0;

  Widget? _desktopModule;
  String? _title;

  contactDataHandler(TencentCloudChatContactData data) {
    if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.contactList) {
      safeSetState(() {
        _contactsList = data.contactList;
      });
    } else if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.applicationList) {
      safeSetState(() {
        applicationList = data.applicationList;
        _applicationUnreadCount = data.applicationList.length;
      });
    } else if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.groupList) {
      safeSetState(() {
        _groupList = data.groupList;
      });
    } else if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.blockList) {
      safeSetState(() {
        _blockList = data.blockList;
      });
    } else if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.applicationCount) {
      safeSetState(() {
        _applicationUnreadCount = data.applicationUnreadCount;
      });
    } else if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.groupApplicationList) {
      safeSetState(() {
        _groupApplicationList = data.groupApplicationList;
      });
    }
  }

  _addContactDataListener() {
    _contactDataSubscription = _contactDataStream?.listen(contactDataHandler);
  }

  @override
  void initState() {
    super.initState();
    _addContactDataListener();
    if (TencentCloudChat.dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.contact)) {
      if (_contactsList.isEmpty) {
        _contactsList = TencentCloudChat.dataInstance.contact.contactList;
        applicationList = TencentCloudChat.dataInstance.contact.applicationList;
        _applicationUnreadCount = applicationList.length;
        _groupApplicationList = TencentCloudChat.dataInstance.contact.groupApplicationList;
        _groupList = TencentCloudChat.dataInstance.contact.groupList;
        _blockList = TencentCloudChat.dataInstance.contact.blockList;
      }
    }
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    List<TabItem> getTabItem() {
      List<TabItem> tabItemList = [];
      tabItemList.add(
        TabItem(
            id: "new_contacts",
            icon: Icons.add_box_outlined,
            name: tL10n.newContacts,
            onTap: () {
              setState(() {
                _title = tL10n.newContacts;
                _desktopModule = TencentCloudChatContactApplication(applicationList: applicationList);
              });
            },
            unreadCount: _applicationUnreadCount),
      );
      tabItemList.add(
        TabItem(
          id: "group_notification",
          icon: Icons.notification_add_outlined,
          name: tL10n.groupChatNotifications,
          onTap: () {
            setState(() {
              _title = tL10n.groupChatNotifications;
              _desktopModule = TencentCloudChatContactGroupApplicationList(groupApplicationList: _groupApplicationList);
            });
          },
        ),
      );
      tabItemList.add(
        TabItem(
          id: "blocked_users",
          icon: Icons.block_outlined,
          name: tL10n.blockList,
          onTap: () {
            setState(() {
              _title = tL10n.blockList;
              _desktopModule = TencentCloudChatContactBlockList(blackList: _blockList);
            });
          },
        ),
      );
      return tabItemList;
    }

    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Material(
        child: Column(
          children: [
            TencentCloudChatContactAppBar(
              title: _title,
            ),
            Expanded(
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: getWidth(280)),
                    child: TencentCloudChatContactList(
                      contactList: _contactsList,
                      tabList: getTabItem(),
                      groupList: _groupList,
                    ),
                  ),
                  Expanded(
                    child: _desktopModule ??
                        TencentCloudChatEmptyPage(
                          icon: Icons.contacts_outlined,
                          primaryText: tL10n.contacts,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    List<TabItem> getTabItem() {
      List<TabItem> tabItemList = [];
      tabItemList.add(
        TabItem(
            id: "new_contacts",
            icon: Icons.add_box_outlined,
            name: tL10n.newContacts,
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => TencentCloudChatContactApplication(applicationList: applicationList)))},
            unreadCount: _applicationUnreadCount),
      );
      tabItemList.add(
        TabItem(
          id: "group_notification",
          icon: Icons.notification_add_outlined,
          name: tL10n.groupChatNotifications,
          onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => TencentCloudChatContactGroupApplicationList(groupApplicationList: _groupApplicationList)))},
        ),
      );
      tabItemList.add(
        TabItem(
          id: "groups",
          icon: Icons.group_add_outlined,
          name: tL10n.myGroup,
          onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => TencentCloudChatContactGroupList(groupList: _groupList)))},
        ),
      );
      tabItemList.add(
        TabItem(
          id: "blocked_users",
          icon: Icons.block_outlined,
          name: tL10n.blockList,
          onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => TencentCloudChatContactBlockList(blackList: _blockList)))},
        ),
      );
      return tabItemList;
    }

    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: AppBar(
          backgroundColor: colorTheme.contactBackgroundColor,
          title: const TencentCloudChatContactAppBar(),
        ),
        body: TencentCloudChatContactList(
          contactList: _contactsList,
          tabList: getTabItem(),
          groupList: _groupList,
        ),
      ),
    );

    // return TencentCloudChatContactGroupList(groupList: groupList);
  }

  @override
  void dispose() {
    super.dispose();
    _contactDataSubscription?.cancel();
  }
}

class TencentCloudChatContactInstance {
  TencentCloudChatContactInstance._internal();

  factory TencentCloudChatContactInstance() => _instance;
  static final TencentCloudChatContactInstance _instance = TencentCloudChatContactInstance._internal();

  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.contact,
        builder: (context) => TencentCloudChatContact(
              options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatContactOptions>(context, 'options'),
            ));
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.newContactApplication,
      builder: (context) => TencentCloudChatContactApplication(
        applicationList: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatContactApplicationData>(context, 'options')!.applicationList,
      ),
    );
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.blockList,
      builder: (context) => TencentCloudChatContactBlockList(
        blackList: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatContactBlockListData>(context, 'options')!.blockList,
      ),
    );
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.groupList,
      builder: (context) => TencentCloudChatContactGroupList(
        groupList: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatContactGroupListData>(context, 'options')!.groupList,
      ),
    );
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.newContactApplicationDetail,
      builder: (context) => TencentCloudChatContactApplicationInfo(
        application: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatContactApplicationInfoData>(context, 'options')!.application,
        applicationResult: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatContactApplicationInfoData>(context, 'options')!.applicationResult,
      ),
    );
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.groupApplication,
      builder: (context) => TencentCloudChatContactGroupApplicationList(
        groupApplicationList: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatContactGroupApplicationListData>(context, 'options')!.applicationList,
      ),
    );
    return (
      componentEnum: TencentCloudChatComponentsEnum.contact,
      widgetBuilder: ({required Map<String, dynamic> options}) => const TencentCloudChatContact(),
    );
  }
}
