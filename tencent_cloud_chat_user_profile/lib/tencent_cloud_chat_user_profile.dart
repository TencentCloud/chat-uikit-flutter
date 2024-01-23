library tencent_cloud_chat_user_profile;

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/chat_sdk/tencent_cloud_chat_sdk.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_user_profile_config.dart';
import 'package:tencent_cloud_chat/components/components_options/tencent_cloud_chat_user_profile_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_user_profile/tencent_cloud_chat_user_profile_builders.dart';
import 'package:tencent_cloud_chat_user_profile/tencent_cloud_chat_user_profile_controller.dart';
import 'package:tencent_cloud_chat_user_profile/tencent_cloud_chat_user_profile_event_handlers.dart';
import 'package:tencent_cloud_chat_user_profile/widget/tencent_cloud_chat_user_profile_body.dart';

class TencentCloudChatUserProfile extends TencentCloudChatComponent<
    TencentCloudChatUserProfileOptions,
    TencentCloudChatUserProfileConfig,
    TencentCloudChatUserProfileBuilders,
    TencentCloudChatUserProfileEventHandlers,
    TencentCloudChatUserProfileController> {
  const TencentCloudChatUserProfile({
    required TencentCloudChatUserProfileOptions options,
    Key? key,
    TencentCloudChatUserProfileConfig? config,
    TencentCloudChatUserProfileBuilders? builders,
    TencentCloudChatUserProfileEventHandlers? eventHandlers,
    TencentCloudChatUserProfileController? controller,
  }) : super(
          key: key,
          options: options,
          config: config,
          builders: builders,
          eventHandlers: eventHandlers,
          controller: controller,
        );

  @override
  State<StatefulWidget> createState() => _TencentCloudChatUserProfileState();
}

class _TencentCloudChatUserProfileState
    extends TencentCloudChatState<TencentCloudChatUserProfile> {
  Future<V2TimUserFullInfo> _loadUserFullInfo() async {
    final res = await TencentCloudChatSDK.manager
        .getUsersInfo(userIDList: [widget.options!.userID]);
    if (res.code == 0 && res.data?.first != null) {
      return res.data!.first;
    }
    return V2TimUserFullInfo(userID: widget.options!.userID);
  }

  String _getShowName({V2TimUserFullInfo? userFullInfo}) {
    if (userFullInfo != null) {
      return TencentCloudChatUtils.checkString(userFullInfo.nickName) ??
          userFullInfo.userID ??
          widget.options!.userID;
    }
    return userFullInfo?.userID ?? widget.options!.userID;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getShowName()),
      ),
      body: FutureBuilder(
        initialData: widget.options?.userFullInfo,
        future: _loadUserFullInfo(),
        builder:
            (BuildContext context, AsyncSnapshot<V2TimUserFullInfo> snapshot) {
          final userFullInfo = widget.options?.userFullInfo ?? snapshot.data;
          return userFullInfo != null
              ? TencentCloudChatUserProfileBody(
                  userFullInfo: userFullInfo,
                  startVideoCall: widget.options!.startVideoCall,
                  startVoiceCall: widget.options!.startVoiceCall,
                )
              : Container();
        },
      ),
    );
  }
}

class TencentCloudChatUserProfileInstance {
  // Private constructor to implement the singleton pattern.
  TencentCloudChatUserProfileInstance._internal();

  // Factory constructor that returns the singleton instance of TencentCloudChatUserProfileInstance.
  factory TencentCloudChatUserProfileInstance() => _instance;
  static final TencentCloudChatUserProfileInstance _instance =
      TencentCloudChatUserProfileInstance._internal();

  static ({
    TencentCloudChatComponentsEnum componentEnum,
    TencentCloudChatWidgetBuilder widgetBuilder
  }) register() {
    // TencentCloudChat.dataInstance.messageData.init();

    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.userProfile,
      builder: (context) => TencentCloudChatUserProfile(
        options: TencentCloudChatRouter()
                .getArgumentFromMap<TencentCloudChatUserProfileOptions>(
                    context, 'options') ??
            TencentCloudChatUserProfileOptions(userID: ""),
      ),
    );

    return (
      componentEnum: TencentCloudChatComponentsEnum.userProfile,
      widgetBuilder: ({required Map<String, dynamic> options}) =>
          TencentCloudChatUserProfile(
            options: TencentCloudChatUserProfileOptions(
                userID: options["userID"],
                userFullInfo: options["userFullInfo"],
                startVideoCall: options["startVideoCall"],
                startVoiceCall: options["startVoiceCall"]),
          ),
    );
  }
}
