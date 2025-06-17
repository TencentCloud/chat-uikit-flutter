library tencent_cloud_chat_contact;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_contact_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_contact_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_group_add_member_options.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_group_management_options.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_group_member_info_options.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_group_member_list_options.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_group_transfer_owner_options.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_user_profile_options.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat_common/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat_common/eventbus/tencent_cloud_chat_eventbus.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/empty_page/tencent_cloud_chat_empty_page.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_builders.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_controller.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_options.dart';
import 'package:tencent_cloud_chat_contact/widgets/start_c2c_chat.dart';
import 'package:tencent_cloud_chat_contact/widgets/start_group_chat.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_app_bar.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application_info.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_block_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_group_application_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_group_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_list.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_group_member_info.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_group_transfer_owner.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_user_profile.dart';

class TencentCloudChatContact extends TencentCloudChatComponent<TencentCloudChatContactOptions,
    TencentCloudChatContactConfig, TencentCloudChatContactBuilders, TencentCloudChatContactEventHandlers> {
  const TencentCloudChatContact({
    super.key,
    super.options,
    super.config,
    super.builders,
    super.eventHandlers,
  });

  @override
  TencentCloudChatContactState createState() => TencentCloudChatContactState();
}

class TencentCloudChatContactState extends TencentCloudChatState<TencentCloudChatContact> {
  final Stream<TencentCloudChatContactData<dynamic>>? _contactDataStream = TencentCloudChat.instance.eventBusInstance
      .on<TencentCloudChatContactData<dynamic>>(TencentCloudChatEventBus.eventNameContact);
  late StreamSubscription<TencentCloudChatContactData<dynamic>>? _contactDataSubscription;

  final Stream<TencentCloudChatGroupProfileData<dynamic>>? _groupProfileDataStream = TencentCloudChat
      .instance.eventBusInstance
      .on<TencentCloudChatGroupProfileData<dynamic>>(TencentCloudChatEventBus.eventNameGroup);
  StreamSubscription<TencentCloudChatGroupProfileData<dynamic>>? _groupProfileDataSubscription;

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
    } else if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.builder ||
        data.currentUpdatedFields == TencentCloudChatContactDataKeys.config) {
      safeSetState(() {});
    } else if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.userStatusList) {
      safeSetState(() {});
    }
  }

  _groupProfileDataHandler(TencentCloudChatGroupProfileData data) {
    if (data.currentUpdatedFields == TencentCloudChatGroupProfileDataKeys.joinGroup) {
      setState(() {
        int index = _groupList.indexWhere((element) => element.groupID == data.updateGroupInfo.groupID);
        if (index < 0) {
          _groupList.add(data.updateGroupInfo);
        }
      });
    } else if (data.currentUpdatedFields == TencentCloudChatGroupProfileDataKeys.quitGroup) {
      setState(() {
        _groupList.removeWhere((element) => element.groupID == data.updateGroupID);
      });
    }
  }

  _addContactDataListener() {
    _contactDataSubscription = _contactDataStream?.listen(contactDataHandler);
  }

  _addGroupDataListener() {
    _groupProfileDataSubscription = _groupProfileDataStream?.listen(_groupProfileDataHandler);
  }

  @override
  void initState() {
    super.initState();
    _updateGlobalData();
    _addContactDataListener();
    _addGroupDataListener();

    if (TencentCloudChat.instance.dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.contact)) {
      if (_contactsList.isEmpty) {
        _contactsList = TencentCloudChat.instance.dataInstance.contact.contactList;
        applicationList = TencentCloudChat.instance.dataInstance.contact.applicationList;
        _applicationUnreadCount = applicationList.length;
        _groupApplicationList = TencentCloudChat.instance.dataInstance.contact.groupApplicationList;
        _groupList = TencentCloudChat.instance.dataInstance.contact.groupList;
        _blockList = TencentCloudChat.instance.dataInstance.contact.blockList;
      }
    }
  }

  @override
  void didUpdateWidget(TencentCloudChatContact oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateGlobalData(oldWidget);
  }

  void _updateGlobalData([TencentCloudChatContact? oldWidget]) {
    if (widget.config != null || (oldWidget != null && oldWidget.config != widget.config && widget.config != null)) {
      TencentCloudChat.instance.dataInstance.contact.contactConfig = widget.config!;
    }

    if (widget.eventHandlers != null ||
        (oldWidget != null && oldWidget.eventHandlers != widget.eventHandlers && widget.eventHandlers != null)) {
      TencentCloudChat.instance.dataInstance.contact.contactEventHandlers = widget.eventHandlers;
    }

    if (widget.builders != null ||
        (oldWidget != null && oldWidget.builders != widget.builders && widget.builders != null)) {
      TencentCloudChat.instance.dataInstance.contact.contactBuilder = widget.builders;
    } else {
      TencentCloudChat.instance.dataInstance.contact.contactBuilder = TencentCloudChatContactBuilders();
    }
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    List<TTabItem> getTabItem() {
      List<TTabItem> tabItemList = [];
      tabItemList.add(
        TTabItem(
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
        TTabItem(
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
        TTabItem(
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
    List<TTabItem> getTabItem() {
      List<TTabItem> tabItemList = [];
      tabItemList.add(
        TTabItem(
            id: "new_contacts",
            icon: Icons.add_box_outlined,
            name: tL10n.newContacts,
            onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TencentCloudChatContactApplication(applicationList: applicationList)))
                },
            unreadCount: _applicationUnreadCount),
      );
      tabItemList.add(
        TTabItem(
          id: "group_notification",
          icon: Icons.notification_add_outlined,
          name: tL10n.groupChatNotifications,
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TencentCloudChatContactGroupApplicationList(groupApplicationList: _groupApplicationList)))
          },
        ),
      );
      tabItemList.add(
        TTabItem(
          id: "groups",
          icon: Icons.group_add_outlined,
          name: tL10n.myGroup,
          onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TencentCloudChatContactGroupList(groupList: _groupList)))
          },
        ),
      );
      tabItemList.add(
        TTabItem(
          id: "blocked_users",
          icon: Icons.block_outlined,
          name: tL10n.blockList,
          onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TencentCloudChatContactBlockList(blackList: _blockList)))
          },
        ),
      );
      return tabItemList;
    }

    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: AppBar(
          backgroundColor: colorTheme.contactBackgroundColor,
          title: const TencentCloudChatContactAppBar(),
          scrolledUnderElevation: 0.0,
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
    _groupProfileDataSubscription?.cancel();
  }
}

/// The TencentCloudChatContactManager is responsible for managing the TencentCloudChatContact component.
/// It enables manual declaration of `TencentCloudChatContact` usage during the `initUIKit` call,
/// and provides control over the component's configuration, UI widget builders, and event listeners on a global scale,
/// affecting all instances of the TencentCloudChatContact component.
class TencentCloudChatContactManager {
  /// Allows dynamic updating of UI widget builders for all instances.
  /// Call the `setBuilders` method and pass any UI builders to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatContactBuilders get builder {
    TencentCloudChat.instance.dataInstance.contact.contactBuilder ??= TencentCloudChatContactBuilders();
    return TencentCloudChat.instance.dataInstance.contact.contactBuilder as TencentCloudChatContactBuilders;
  }

  /// Retrieves the controller for controlling `TencentCloudChatContact` components,
  /// applying to all instances.
  /// Utilize the provided control methods.
  static TencentCloudChatContactController get controller {
    TencentCloudChat.instance.dataInstance.contact.contactController ??=
        TencentCloudChatContactControllerGenerator.getInstance();
    return TencentCloudChat.instance.dataInstance.contact.contactController as TencentCloudChatContactController;
  }

  /// Enables dynamic updating of configurations for all instances.
  /// Call the `setConfigs` method and pass any configurations to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatContactConfig get config {
    return TencentCloudChat.instance.dataInstance.contact.contactConfig;
  }

  /// Attaches listeners to Component-level events.
  /// Covers both `uiEventHandlers` (e.g., various onTap-like events) and `lifeCycleEventHandlers` (business-related events).
  /// Call `setEventHandlers` from both `uiEventHandlers` and `lifeCycleEventHandlers` to update specific event handlers.
  /// Note: This will cause the corresponding event's previously attached handlers to be invalidated, i.e., overridden.
  static TencentCloudChatContactEventHandlers get eventHandlers {
    TencentCloudChat.instance.dataInstance.contact.contactEventHandlers ??= TencentCloudChatContactEventHandlers();
    return TencentCloudChat.instance.dataInstance.contact.contactEventHandlers!;
  }

  /// Manually declares the usage of the `TencentCloudChatContact` component.
  /// During the `initUIKit` call, add `TencentCloudChatContactManager.register` in `usedComponentsRegister` within `components`
  /// if you plan to use this component.
  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    TencentCloudChat.instance.dataInstance.contact.contactBuilder ??= TencentCloudChatContactBuilders();

    TencentCloudChat.instance.dataInstance.contact.contactController ??=
        TencentCloudChatContactControllerGenerator.getInstance();

    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.contact,
        builder: (context) => TencentCloudChatContact(
            options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatContactOptions>(context, 'options')));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.newContactApplication,
        builder: (context) => TencentCloudChatContactApplication(
            applicationList: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatContactApplicationData>(context, 'options')!
                .applicationList));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.blockList,
        builder: (context) => TencentCloudChatContactBlockList(
            blackList: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatContactBlockListData>(context, 'options')!
                .blockList));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.groupList,
        builder: (context) => TencentCloudChatContactGroupList(
            groupList: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatContactGroupListData>(context, 'options')!
                .groupList));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.newContactApplicationDetail,
        builder: (context) => TencentCloudChatContactApplicationInfo(
            application: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatContactApplicationInfoData>(context, 'options')!
                .application,
            applicationResult: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatContactApplicationInfoData>(context, 'options')!
                .applicationResult));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.groupApplication,
        builder: (context) => TencentCloudChatContactGroupApplicationList(
            groupApplicationList: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatContactGroupApplicationListData>(context, 'options')!
                .applicationList));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.groupMemberInfo,
        builder: (context) => TencentCloudChatGroupMemberInfo(
            memberFullInfo: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatGroupMemberInfoOptions>(context, 'options')!
                .memberFullInfo));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.groupMemberList,
        builder: (context) => TencentCloudChat.instance.dataInstance.contact.contactBuilder
            ?.getGroupMemberListPageBuilder(
                groupInfo: TencentCloudChatRouter()
                    .getArgumentFromMap<TencentCloudChatGroupMemberListOptions>(context, 'options')!
                    .groupInfo,
                memberInfoList: TencentCloudChatRouter()
                    .getArgumentFromMap<TencentCloudChatGroupMemberListOptions>(context, 'options')!
                    .memberInfoList));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.groupManagement,
        builder: (context) => TencentCloudChat.instance.dataInstance.contact.contactBuilder
            ?.getGroupManagementPageBuilder(
                groupInfo: TencentCloudChatRouter()
                    .getArgumentFromMap<TencentCloudChatGroupManagementOptions>(context, 'options')!
                    .groupInfo,
                memberList: TencentCloudChatRouter()
                    .getArgumentFromMap<TencentCloudChatGroupManagementOptions>(context, 'options')!
                    .memberInfoList));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.groupAddMember,
        builder: (context) => TencentCloudChat.instance.dataInstance.contact.contactBuilder
            ?.getGroupAddMemberPageBuilder(
                groupInfo: TencentCloudChatRouter()
                    .getArgumentFromMap<TencentCloudChatGroupAddMemberOptions>(context, 'options')!
                    .groupInfo,
                memberList: TencentCloudChatRouter()
                    .getArgumentFromMap<TencentCloudChatGroupAddMemberOptions>(context, 'options')!
                    .memberList,
                contactList: TencentCloudChatRouter()
                    .getArgumentFromMap<TencentCloudChatGroupAddMemberOptions>(context, 'options')!
                    .contactList));
    TencentCloudChatRouter().registerRouter(
        routeName: TencentCloudChatRouteNames.groupTransferOwner,
        builder: (context) => TencentCloudChatGroupTransferOwner(
            memberList: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatGroupTransferOwnerOptions>(context, 'options')!
                .memberList,
            groupInfo: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatGroupTransferOwnerOptions>(context, 'options')!
                .groupInfo));
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.userProfile,
      builder: (context) => TencentCloudChatUserProfile(
        options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatUserProfileOptions>(context, 'options') ??
            TencentCloudChatUserProfileOptions(userID: ""),
      ),
    );

    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.startGroupChat,
      builder: (context) => const StartGroupChat(),
    );

    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.startC2CChat,
      builder: (context) => const StartC2CChat(),
    );

    return (
      componentEnum: TencentCloudChatComponentsEnum.contact,
      widgetBuilder: ({required Map<String, dynamic> options}) => const TencentCloudChatContact(),
    );
  }
}
