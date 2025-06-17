library tencent_cloud_chat_user_profile;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_contact_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_contact_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_user_profile_options.dart';
import 'package:tencent_cloud_chat_common/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_builders.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_user_profile_body.dart';

class TencentCloudChatUserProfile extends TencentCloudChatComponent<TencentCloudChatUserProfileOptions,
    TencentCloudChatContactConfig, TencentCloudChatContactBuilders, TencentCloudChatContactEventHandlers> {
  const TencentCloudChatUserProfile({
    required TencentCloudChatUserProfileOptions options,
    Key? key,
    TencentCloudChatContactConfig? config,
    TencentCloudChatContactBuilders? builders,
    TencentCloudChatContactEventHandlers? eventHandlers,
  }) : super(
          key: key,
          options: options,
          builders: builders,
          config: config,
          eventHandlers: eventHandlers,
        );

  @override
  State<StatefulWidget> createState() => _TencentCloudChatUserProfileState();
}

class _TencentCloudChatUserProfileState extends TencentCloudChatState<TencentCloudChatUserProfile> {
  final Stream<TencentCloudChatContactData<dynamic>>? _contactDataStream = TencentCloudChat.instance.eventBusInstance
      .on<TencentCloudChatContactData<dynamic>>("TencentCloudChatContactData");
  StreamSubscription<TencentCloudChatContactData<dynamic>>? _contactDataSubscription;

  Future<V2TimUserFullInfo> _loadUserFullInfo() async {
    final res =
        await TencentCloudChat.instance.chatSDKInstance.manager.getUsersInfo(userIDList: [widget.options!.userID]);
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
  void initState() {
    super.initState();
    _addUserProfileDataListener();
    _updateGlobalData();
  }

  @override
  void dispose() {
    _contactDataSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(TencentCloudChatUserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateGlobalData(oldWidget);
  }

  _addUserProfileDataListener() {
    _contactDataSubscription = _contactDataStream?.listen(_userProfileDataHandler);
  }

  _userProfileDataHandler(TencentCloudChatContactData data) {
    if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.builder ||
        data.currentUpdatedFields == TencentCloudChatContactDataKeys.config) {
      setState(() {});
    }
  }

  void _updateGlobalData([TencentCloudChatUserProfile? oldWidget]) {
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
                  isNavigatedFromChat: widget.options!.isNavigatedFromChat ?? true,
                )
              : Container();
        },
      ),
    );
  }
}
