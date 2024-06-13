library tencent_cloud_chat_user_profile;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_user_profile_config.dart';
import 'package:tencent_cloud_chat/components/component_options/tencent_cloud_chat_user_profile_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/data/user_profile/tencent_cloud_chat_user_profile_data.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_user_profile/tencent_cloud_chat_user_profile_builders.dart';
import 'package:tencent_cloud_chat_user_profile/tencent_cloud_chat_user_profile_controller.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_user_profile_event_handlers.dart';
import 'package:tencent_cloud_chat_user_profile/widget/tencent_cloud_chat_user_profile_body.dart';

class TencentCloudChatUserProfile
    extends TencentCloudChatComponent<TencentCloudChatUserProfileOptions, TencentCloudChatUserProfileConfig, TencentCloudChatUserProfileBuilders, TencentCloudChatUserProfileEventHandlers> {
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
        );

  @override
  State<StatefulWidget> createState() => _TencentCloudChatUserProfileState();
}

class _TencentCloudChatUserProfileState extends TencentCloudChatState<TencentCloudChatUserProfile> {
  final Stream<TencentCloudChatUserProfileData<dynamic>>?
  _userProfileDataStream = TencentCloudChat.instance.eventBusInstance
      .on<TencentCloudChatUserProfileData<dynamic>>("TencentCloudChatUserProfileData");
  StreamSubscription<TencentCloudChatUserProfileData<dynamic>>?
  _userProfileDataSubscription;
  
  Future<V2TimUserFullInfo> _loadUserFullInfo() async {
    final res = await TencentCloudChat.instance.chatSDKInstance.manager.getUsersInfo(userIDList: [widget.options!.userID]);
    if (res.code == 0 && res.data?.first != null) {
      return res.data!.first;
    }
    return V2TimUserFullInfo(userID: widget.options!.userID);
  }

  String _getShowName({V2TimUserFullInfo? userFullInfo}) {
    if (userFullInfo != null) {
      return TencentCloudChatUtils.checkString(userFullInfo.nickName) ?? userFullInfo.userID ?? widget.options!.userID;
    }
    return userFullInfo?.userID ?? widget.options!.userID;
  }

  @override
  void initState(){
    super.initState();
    _addUserProfileDataListener();
    _updateGlobalData();
  }

  @override
  void dispose() {
    _userProfileDataSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(TencentCloudChatUserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateGlobalData(oldWidget);
  }

  _addUserProfileDataListener() {
    _userProfileDataSubscription =
        _userProfileDataStream?.listen(_userProfileDataHandler);
  }

  _userProfileDataHandler(TencentCloudChatUserProfileData data) {
    if (data.currentUpdatedFields ==
        TencentCloudChatUserProfileDataKeys.builder ||
        data.currentUpdatedFields ==
            TencentCloudChatUserProfileDataKeys.config) {
      setState(() {});
    }
  }


  void _updateGlobalData([TencentCloudChatUserProfile? oldWidget]){
    if (widget.config != null || (oldWidget != null && oldWidget.config != widget.config && widget.config != null)) {
      TencentCloudChat.instance.dataInstance.userProfile.userProfileConfig = widget.config!;
    }

    if (widget.eventHandlers != null || (oldWidget != null && oldWidget.eventHandlers != widget.eventHandlers && widget.eventHandlers != null)) {
      TencentCloudChat.instance.dataInstance.userProfile.userProfileEventHandlers = widget.eventHandlers;
    }

    if (widget.builders != null || (oldWidget != null && oldWidget.builders != widget.builders && widget.builders != null)) {
      TencentCloudChat.instance.dataInstance.userProfile.userProfileBuilder =
          widget.builders;
    } else {
      TencentCloudChat.instance.dataInstance.userProfile.userProfileBuilder =
          TencentCloudChatUserProfileBuilders();
    }
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
        builder: (BuildContext context, AsyncSnapshot<V2TimUserFullInfo> snapshot) {
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

/// The TencentCloudChatUserProfileManager is responsible for managing the TencentCloudChatUserProfile component.
/// It enables manual declaration of `TencentCloudChatUserProfile` usage during the `initUIKit` call,
/// and provides control over the component's configuration, UI widget builders, and event listeners on a global scale,
/// affecting all instances of the TencentCloudChatUserProfile component.
class TencentCloudChatUserProfileManager {
  
  /// Allows dynamic updating of UI widget builders for all instances.
  /// Call the `setBuilders` method and pass any UI builders to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatUserProfileBuilders get builder {
    TencentCloudChat.instance.dataInstance.userProfile.userProfileBuilder ??= TencentCloudChatUserProfileBuilders();
    return TencentCloudChat.instance.dataInstance.userProfile.userProfileBuilder
    as TencentCloudChatUserProfileBuilders;
  }

  /// Retrieves the controller for controlling `TencentCloudChatUserProfile` components,
  /// applying to all instances.
  /// Utilize the provided control methods.
  static TencentCloudChatUserProfileController get controller {
    TencentCloudChat.instance.dataInstance.userProfile.userProfileController ??= TencentCloudChatUserProfileControllerGenerator.getInstance();
    return TencentCloudChat.instance.dataInstance.userProfile.userProfileController
    as TencentCloudChatUserProfileController;
  }

  /// Enables dynamic updating of configurations for all instances.
  /// Call the `setConfigs` method and pass any configurations to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatUserProfileConfig get config {
    return TencentCloudChat
        .instance.dataInstance.userProfile.userProfileConfig;
  }

  /// Attaches listeners to Component-level events.
  /// Covers both `uiEventHandlers` (e.g., various onTap-like events) and `lifeCycleEventHandlers` (business-related events).
  /// Call `setEventHandlers` from both `uiEventHandlers` and `lifeCycleEventHandlers` to update specific event handlers.
  /// Note: This will cause the corresponding event's previously attached handlers to be invalidated, i.e., overridden.
  static TencentCloudChatUserProfileEventHandlers get eventHandlers {
    TencentCloudChat
        .instance.dataInstance.userProfile.userProfileEventHandlers ??=
        TencentCloudChatUserProfileEventHandlers();
    return TencentCloudChat
        .instance.dataInstance.userProfile.userProfileEventHandlers!;
  }

  /// Manually declares the usage of the `TencentCloudChatUserProfile` component.
  /// During the `initUIKit` call, add `TencentCloudChatUserProfileManager.register` in `usedComponentsRegister` within `components`
  /// if you plan to use this component.
  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    TencentCloudChat.instance.dataInstance.userProfile.userProfileBuilder ??= TencentCloudChatUserProfileBuilders();

    TencentCloudChat.instance.dataInstance.userProfile.userProfileController ??= TencentCloudChatUserProfileControllerGenerator.getInstance();

    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.userProfile,
      builder: (context) => TencentCloudChatUserProfile(
        options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatUserProfileOptions>(context, 'options') ?? TencentCloudChatUserProfileOptions(userID: ""),
      ),
    );

    return (
      componentEnum: TencentCloudChatComponentsEnum.userProfile,
      widgetBuilder: ({required Map<String, dynamic> options}) => TencentCloudChatUserProfile(
            options: TencentCloudChatUserProfileOptions(userID: options["userID"], userFullInfo: options["userFullInfo"], startVideoCall: options["startVideoCall"], startVoiceCall: options["startVoiceCall"]),
          ),
    );
  }
}

class TencentCloudChatUserProfileInstance {
  /// Use `TencentCloudChatUserProfileManager.register` instead.
  /// This method will be removed in a future version.
  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    return TencentCloudChatUserProfileManager.register();
  }
}
