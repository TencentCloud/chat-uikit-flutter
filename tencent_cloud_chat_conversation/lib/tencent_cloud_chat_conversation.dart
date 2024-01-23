library tencent_cloud_chat_conversation;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_conversation_config.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_builders.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_controller.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_event_handlers.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_options.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_app_bar.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_list.dart';

import 'desktop/tencent_cloud_chat_conversation_desktop_mode.dart';

///
class TencentCloudChatConversation extends TencentCloudChatComponent<
    TencentCloudChatConversationOptions,
    TencentCloudChatConversationConfig,
    TencentCloudChatConversationBuilders,
    TencentCloudChatConversationEventHandlers,
    TencentCloudChatConversationController> {
  const TencentCloudChatConversation({
    super.key,
    super.options,
    super.config,
    super.builders,
    super.eventHandlers,
    super.controller,
  });

  @override
  TencentCloudChatConversationState createState() =>
      TencentCloudChatConversationState();
}

class TencentCloudChatConversationState
    extends TencentCloudChatState<TencentCloudChatConversation> {
  final Stream<TencentCloudChatConversationData<dynamic>>?
      _conversationDataStream = TencentCloudChat.eventBusInstance
          .on<TencentCloudChatConversationData<dynamic>>();

  final Stream<TencentCloudChatContactData<dynamic>>? _contactDataStream =
      TencentCloudChat.eventBusInstance
          .on<TencentCloudChatContactData<dynamic>>();

  late StreamSubscription<TencentCloudChatConversationData<dynamic>>?
      _conversationDataSubscription;

  late StreamSubscription<TencentCloudChatContactData<dynamic>>?
      _contactDataSubscription;

  List<V2TimConversation> _conversationList =
      TencentCloudChat.dataInstance.conversation.conversationList;

  List<V2TimUserStatus> userStatusList =
      TencentCloudChat.dataInstance.contact.userStatus;

  bool getDataEnd = TencentCloudChat.dataInstance.conversation.isGetDataEnd;

  conversationDataHandler(TencentCloudChatConversationData data) {
    if (data.currentUpdatedFields ==
        TencentCloudChatConversationDataKeys.conversationList) {
      final conversationList = data.conversationList;
      safeSetState(() {
        _conversationList = conversationList;
      });
    } else if (data.currentUpdatedFields ==
        TencentCloudChatConversationDataKeys.getDataEnd) {
      safeSetState(() {
        getDataEnd = data.isGetDataEnd;
      });
    }
  }

  contactDataHandler(TencentCloudChatContactData data) {
    if (data.currentUpdatedFields ==
        TencentCloudChatContactDataKeys.userStatusList) {
      safeSetState(() {
        userStatusList = data.userStatus;
      });
    }
  }

  _addConversationDataListener() {
    _conversationDataSubscription =
        _conversationDataStream?.listen(conversationDataHandler);
  }

  _addContactDataListener() {
    _contactDataSubscription = _contactDataStream?.listen(contactDataHandler);
  }

  @override
  void initState() {
    super.initState();
    _addConversationDataListener();
    _addContactDataListener();
    TencentCloudChat.dataInstance.conversation.conversationConfig =
        widget.config;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Container();
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: AppBar(
          backgroundColor: colorTheme.contactBackgroundColor,
          title: const TencentCloudChatConversationAppBar(),
        ),
        body: TencentCloudChatConversationList(
          conversationList: _conversationList,
          getDataEnd: getDataEnd,
          userStatusList: userStatusList,
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    if (widget.config?.useDesktopMode ?? true) {
      return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
          color: Colors.transparent,
          child: TencentCloudChatConversationDesktopMode(
            conversationList: _conversationList,
            getDataEnd: getDataEnd,
            userStatusList: userStatusList,
          ),
        ),
      );
    }
    return mobileBuilder(context);
  }

  @override
  void dispose() {
    super.dispose();
    _conversationDataSubscription?.cancel();
    _contactDataSubscription?.cancel();
  }
}

class TencentCloudChatConversationInstance {
  // Private constructor to implement the singleton pattern.
  TencentCloudChatConversationInstance._internal();

  // Factory constructor that returns the singleton instance of TencentCloudChatConversationInstance.
  factory TencentCloudChatConversationInstance() => _instance;
  static final TencentCloudChatConversationInstance _instance =
      TencentCloudChatConversationInstance._internal();

  static ({
    TencentCloudChatComponentsEnum componentEnum,
    TencentCloudChatWidgetBuilder widgetBuilder
  }) register() {
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.conversation,
      builder: (context) => TencentCloudChatConversation(
        options: TencentCloudChatRouter()
            .getArgumentFromMap<TencentCloudChatConversationOptions>(
                context, 'data'),
      ),
    );

    return (
      componentEnum: TencentCloudChatComponentsEnum.conversation,
      widgetBuilder: ({required Map<String, dynamic> options}) =>
          const TencentCloudChatConversation(),
    );
  }
}
