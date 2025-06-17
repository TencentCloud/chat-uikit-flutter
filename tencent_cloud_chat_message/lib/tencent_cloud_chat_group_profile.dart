library tencent_cloud_chat_group_profile;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_group_profile_config.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_group_profile_options.dart';
import 'package:tencent_cloud_chat_common/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat_common/tuicore/tencent_cloud_chat_core.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/group_member_selector/tencent_cloud_chat_group_member_selector.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_group_profile_builders.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_group_profile_controller.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_group_profile_event_handlers.dart';
import 'package:tencent_cloud_chat_message/group_profile_widgets/tencent_cloud_chat_group_profile_body.dart';

class TencentCloudChatGroupProfile extends TencentCloudChatComponent<
    TencentCloudChatGroupProfileOptions,
    TencentCloudChatGroupProfileConfig,
    TencentCloudChatGroupProfileBuilders,
    TencentCloudChatGroupProfileEventHandlers> {
  const TencentCloudChatGroupProfile({
    required TencentCloudChatGroupProfileOptions options,
    Key? key,
    TencentCloudChatGroupProfileConfig? config,
    TencentCloudChatGroupProfileBuilders? builders,
    TencentCloudChatGroupProfileEventHandlers? eventHandlers,
    TencentCloudChatGroupProfileController? controller,
  }) : super(
          key: key,
          options: options,
          config: config,
          builders: builders,
          eventHandlers: eventHandlers,
        );

  @override
  State<StatefulWidget> createState() => _TencentCloudChatGroupProfileState();
}

class _TencentCloudChatGroupProfileState extends TencentCloudChatState<TencentCloudChatGroupProfile> {
  final Stream<TencentCloudChatGroupProfileData<dynamic>>? _groupProfileDataStream = TencentCloudChat
      .instance.eventBusInstance
      .on<TencentCloudChatGroupProfileData<dynamic>>("TencentCloudChatGroupProfileData");
  StreamSubscription<TencentCloudChatGroupProfileData<dynamic>>? _groupProfileDataSubscription;

  List<V2TimGroupMemberFullInfo> _groupMemberList = [];

  Future<V2TimGroupInfo?> _loadGroupInfo() async {
    final res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getGroupManager()
        .getGroupsInfo(groupIDList: [widget.options!.groupID]);
    if (res.code == 0 && res.data?.first != null) {
      if (res.data?.first.resultCode == 0) {
        _groupInfo = res.data!.first.groupInfo;
        return res.data!.first.groupInfo;
      }
    }
    return V2TimGroupInfo(groupID: widget.options!.groupID, groupType: "work");
  }

  V2TimGroupInfo? _groupInfo;

  String _getShowName({V2TimGroupInfo? groupInfo}) {
    if (groupInfo != null) {
      return TencentCloudChatUtils.checkString(groupInfo.groupName) ?? groupInfo.groupID;
    }
    return groupInfo?.groupID ?? widget.options!.groupID;
  }

  @override
  void initState() {
    super.initState();
    _groupMemberList = _getGroupMembersInfo();
    _addGroupProfileDataListener();
    _updateGlobalData();
  }

  @override
  void dispose() {
    _groupProfileDataSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(TencentCloudChatGroupProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _updateGlobalData(oldWidget);
  }

  _addGroupProfileDataListener() {
    _groupProfileDataSubscription = _groupProfileDataStream?.listen(_groupProfileDataHandler);
  }

  _groupProfileDataHandler(TencentCloudChatGroupProfileData data) {
    if (data.currentUpdatedFields == TencentCloudChatGroupProfileDataKeys.builder ||
        data.currentUpdatedFields == TencentCloudChatGroupProfileDataKeys.config) {
      setState(() {});
    }

    if (data.currentUpdatedFields == TencentCloudChatGroupProfileDataKeys.membersChange) {
      if (data.updateGroupID == widget.options?.groupID) {
        setState(() {
          _groupMemberList = _getGroupMembersInfo();
        });
      }
    } else if (data.currentUpdatedFields == TencentCloudChatGroupProfileDataKeys.updateGroupInfo) {
      if (data.updateGroupInfo.groupID == _groupInfo?.groupID) {
        setState(() {});
      }
    }
  }

  void _updateGlobalData([TencentCloudChatGroupProfile? oldWidget]) {
    if (widget.config != null || (oldWidget != null && oldWidget.config != widget.config && widget.config != null)) {
      TencentCloudChat.instance.dataInstance.groupProfile.groupProfileConfig = widget.config!;
    }

    if (widget.eventHandlers != null ||
        (oldWidget != null && oldWidget.eventHandlers != widget.eventHandlers && widget.eventHandlers != null)) {
      TencentCloudChat.instance.dataInstance.groupProfile.groupProfileEventHandlers = widget.eventHandlers;
    }

    if (widget.builders != null ||
        (oldWidget != null && oldWidget.builders != widget.builders && widget.builders != null)) {
      TencentCloudChat.instance.dataInstance.groupProfile.groupProfileBuilder = widget.builders;
    } else {
      TencentCloudChat.instance.dataInstance.groupProfile.groupProfileBuilder = TencentCloudChatGroupProfileBuilders();
    }
  }

  List<V2TimGroupMemberFullInfo> _getGroupMembersInfo() {
    final res = TencentCloudChat.instance.dataInstance.groupProfile.getGroupMemberList(widget.options!.groupID);
    return res.whereType<V2TimGroupMemberFullInfo>().toList();
  }

  _startVoiceCall() async {
    final useCallKit = TencentCloudChat.instance.dataInstance.basic.useCallKit;
    if (useCallKit) {
      if (TencentCloudChatUtils.checkString(widget.options?.groupID) != null) {
        final List<V2TimGroupMemberFullInfo> memberInfoList = await showGroupMemberSelector(
          groupMemberList: _groupMemberList,
          context: context,
          onSelectLabel: tL10n.startCall,
        );
        TencentCloudChatTUICore.audioCall(
          userids: memberInfoList.map((e) => e.userID).toList(),
          groupid: widget.options?.groupID,
        );
      }
    }
  }

  _startVideoCall() async {
    final useCallKit = TencentCloudChat.instance.dataInstance.basic.useCallKit;
    if (useCallKit) {
      if (TencentCloudChatUtils.checkString(widget.options?.groupID) != null) {
        final List<V2TimGroupMemberFullInfo> memberInfoList = await showGroupMemberSelector(
          groupMemberList: _groupMemberList,
          context: context,
          onSelectLabel: tL10n.startCall,
        );

        TencentCloudChatTUICore.videoCall(
          userids: memberInfoList.map((e) => e.userID).toList(),
          groupid: widget.options?.groupID,
        );
      }
    }
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return FutureBuilder(
      future: _loadGroupInfo(),
      builder: (BuildContext context, AsyncSnapshot<V2TimGroupInfo?> snapshot) {
        final groupInfo = widget.options?.groupInfo ?? snapshot.data;
        return groupInfo != null
            ? TencentCloudChatGroupProfileBody(
                groupInfo: groupInfo,
                groupMemberList: _groupMemberList,
                startVideoCall: _startVideoCall,
                startVoiceCall: _startVoiceCall,
              )
            : Container();
      },
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return FutureBuilder(
      future: _loadGroupInfo(),
      builder: (BuildContext context, AsyncSnapshot<V2TimGroupInfo?> snapshot) {
        final groupInfo = widget.options?.groupInfo ?? snapshot.data;
        return groupInfo != null
            ? TencentCloudChatThemeWidget(
                build: (context, colorTheme, textStyle) => Scaffold(
                    appBar: AppBar(
                        leading: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_rounded),
                          color: colorTheme.primaryColor,
                        ),
                        title: Text(
                          tL10n.groupDetail,
                          style: TextStyle(
                              fontSize: textStyle.fontsize_16,
                              fontWeight: FontWeight.w600,
                              color: colorTheme.contactItemFriendNameColor),
                        ),
                        centerTitle: true,
                        scrolledUnderElevation: 0.0),
                    body: TencentCloudChatGroupProfileBody(
                      groupInfo: groupInfo,
                      groupMemberList: _groupMemberList,
                      startVideoCall: _startVideoCall,
                      startVoiceCall: _startVoiceCall,
                    )))
            : Scaffold(
                appBar: AppBar(title: Text(_getShowName())),
                body: Container(),
              );
      },
    );
  }
}

/// The TencentCloudChatGroupProfileManager is responsible for managing the TencentCloudChatGroupProfile component.
/// It enables manual declaration of `TencentCloudChatGroupProfile` usage during the `initUIKit` call,
/// and provides control over the component's configuration, UI widget builders, and event listeners on a global scale,
/// affecting all instances of the TencentCloudChatGroupProfile component.
class TencentCloudChatGroupProfileManager {
  /// Allows dynamic updating of UI widget builders for all instances.
  /// Call the `setBuilders` method and pass any UI builders to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatGroupProfileBuilders get builder {
    TencentCloudChat.instance.dataInstance.groupProfile.groupProfileBuilder ??= TencentCloudChatGroupProfileBuilders();
    return TencentCloudChat.instance.dataInstance.groupProfile.groupProfileBuilder
        as TencentCloudChatGroupProfileBuilders;
  }

  /// Enables dynamic updating of configurations for all instances.
  /// Call the `setConfigs` method and pass any configurations to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatGroupProfileConfig get config {
    return TencentCloudChat.instance.dataInstance.groupProfile.groupProfileConfig;
  }

  /// Attaches listeners to Component-level events.
  /// Covers both `uiEventHandlers` (e.g., various onTap-like events) and `lifeCycleEventHandlers` (business-related events).
  /// Call `setEventHandlers` from both `uiEventHandlers` and `lifeCycleEventHandlers` to update specific event handlers.
  /// Note: This will cause the corresponding event's previously attached handlers to be invalidated, i.e., overridden.
  static TencentCloudChatGroupProfileEventHandlers get eventHandlers {
    TencentCloudChat.instance.dataInstance.groupProfile.groupProfileEventHandlers ??=
        TencentCloudChatGroupProfileEventHandlers();
    return TencentCloudChat.instance.dataInstance.groupProfile.groupProfileEventHandlers!;
  }

  /// Manually declares the usage of the `TencentCloudChatGroupProfile` component.
  /// During the `initUIKit` call, add `TencentCloudChatGroupProfileManager.register` in `usedComponentsRegister` within `components`
  /// if you plan to use this component.
  static ({TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    TencentCloudChat.instance.dataInstance.groupProfile.groupProfileBuilder ??= TencentCloudChatGroupProfileBuilders();

    TencentCloudChat.instance.dataInstance.groupProfile.groupProfileController ??=
        TencentCloudChatGroupProfileController.instance;

    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.groupProfile,
      builder: (context) => TencentCloudChatGroupProfile(
        options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatGroupProfileOptions>(context, 'options') ??
            TencentCloudChatGroupProfileOptions(
              groupID: "",
            ),
      ),
    );
    return (
      widgetBuilder: ({required Map<String, dynamic> options}) => TencentCloudChatGroupProfile(
            options: TencentCloudChatGroupProfileOptions(groupID: options["groupID"]),
          ),
    );
  }
}
