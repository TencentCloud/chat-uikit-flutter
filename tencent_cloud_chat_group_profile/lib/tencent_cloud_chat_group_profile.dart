library tencent_cloud_chat_group_profile;

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/chat_sdk/tencent_cloud_chat_sdk.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_group_profile_config.dart';
import 'package:tencent_cloud_chat/components/components_options/tencent_cloud_chat_group_profile_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_group_profile/tencent_cloud_chat_group_profile_builders.dart';
import 'package:tencent_cloud_chat_group_profile/tencent_cloud_chat_group_profile_controller.dart';
import 'package:tencent_cloud_chat_group_profile/tencent_cloud_chat_group_profile_event_handlers.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_body.dart';

class TencentCloudChatGroupProfile extends TencentCloudChatComponent<
    TencentCloudChatGroupProfileOptions,
    TencentCloudChatGroupProfileConfig,
    TencentCloudChatGroupProfileBuilders,
    TencentCloudChatGroupProfileEventHandlers,
    TencentCloudChatGroupProfileController> {
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
          controller: controller,
        );

  @override
  State<StatefulWidget> createState() => _TencentCloudChatGroupProfileState();
}

class _TencentCloudChatGroupProfileState
    extends TencentCloudChatState<TencentCloudChatGroupProfile> {
  Future<V2TimGroupInfo?> _loadGroupInfo() async {
    final res = await TencentCloudChatSDK.manager
        .getGroupManager()
        .getGroupsInfo(groupIDList: [widget.options!.groupID]);
    if (res.code == 0 && res.data?.first != null) {
      if (res.data?.first.resultCode == 0) {
        return res.data!.first.groupInfo;
      }
    }
    return V2TimGroupInfo(groupID: widget.options!.groupID, groupType: "work");
  }

  V2TimGroupInfo? groupInfo;

  String _getShowName({V2TimGroupInfo? groupInfo}) {
    if (groupInfo != null) {
      return TencentCloudChatUtils.checkString(groupInfo.groupName) ??
          groupInfo.groupID;
    }
    return groupInfo?.groupID ?? widget.options!.groupID;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return FutureBuilder(
      future: _loadGroupInfo(),
      builder: (BuildContext context, AsyncSnapshot<V2TimGroupInfo?> snapshot) {
        final groupInfo = widget.options?.groupInfo ?? snapshot.data;
        return groupInfo != null
            ? Scaffold(
                appBar: AppBar(title: Text(_getShowName(groupInfo: groupInfo))),
                body: TencentCloudChatGroupProfileBody(
                  groupInfo: groupInfo,
                  getGroupMembersInfo: widget.options!.getGroupMembersInfo,
                  startVideoCall: widget.options!.startVideoCall,
                  startVoiceCall: widget.options!.startVoiceCall,
                ))
            : Scaffold(
                appBar: AppBar(title: Text(_getShowName())),
                body: Container(),
              );
      },
    );
  }
}

class TencentCloudChatGroupProfileInstance {
  TencentCloudChatGroupProfileInstance._internal();

  factory TencentCloudChatGroupProfileInstance() => _instance;
  static final TencentCloudChatGroupProfileInstance _instance =
      TencentCloudChatGroupProfileInstance._internal();

  static ({
    TencentCloudChatComponentsEnum componentEnum,
    TencentCloudChatWidgetBuilder widgetBuilder
  }) register() {
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.groupProfile,
      builder: (context) => TencentCloudChatGroupProfile(
        options: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatGroupProfileOptions>(
                    context, 'options') ??
            TencentCloudChatGroupProfileOptions(
                groupID: "",
                getGroupMembersInfo: () {
                  return [];
                },
                startVideoCall: () {},
                startVoiceCall: () {}),
      ),
    );
    return (
      componentEnum: TencentCloudChatComponentsEnum.groupProfile,
      widgetBuilder: ({required Map<String, dynamic> options}) =>
          TencentCloudChatGroupProfile(
            options: TencentCloudChatGroupProfileOptions(
                groupID: options["groupID"],
                getGroupMembersInfo: options["getGroupMembersInfo"],
                startVideoCall: options["startVideoCall"],
                startVoiceCall: options["startVoiceCall"]),
          ),
    );
  }
}
