library tencent_cloud_chat_conversation;

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_conversation_config.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
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
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_list.dart';

import 'desktop/tencent_cloud_chat_conversation_desktop_mode.dart';

///
class TencentCloudChatConversation
    extends TencentCloudChatComponent<TencentCloudChatConversationOptions, TencentCloudChatConversationConfig, TencentCloudChatConversationBuilders, TencentCloudChatConversationEventHandlers, TencentCloudChatConversationController> {
  const TencentCloudChatConversation({
    super.key,
    super.options,
    super.config,
    super.builders,
    super.eventHandlers,
    super.controller,
  });

  @override
  TencentCloudChatConversationState createState() => TencentCloudChatConversationState();
}

class TencentCloudChatConversationState extends TencentCloudChatState<TencentCloudChatConversation> {
  @override
  void initState() {
    super.initState();
    TencentCloudChat().dataInstance.conversation.conversationConfig = widget.config;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Container();
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    final header = TencentCloudChatConversationBuilders.getConversationHeaderBuilder();
    if (header.$2) {
      return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
          child: Column(
            children: [
              Container(
                color: colorTheme.backgroundColor,
                child: header.$1,
              ),
              const Expanded(
                child: TencentCloudChatConversationList(),
              ),
            ],
          ),
        ),
      );
    } else {
      return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
          appBar: AppBar(
            backgroundColor: colorTheme.contactBackgroundColor,
            title: header.$1,
          ),
          body: const TencentCloudChatConversationList(),
        ),
      );
    }
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    if (widget.config?.useDesktopMode ?? true) {
      return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => const Material(
          color: Colors.transparent,
          child: TencentCloudChatConversationDesktopMode(),
        ),
      );
    }
    return mobileBuilder(context);
  }
}

class TencentCloudChatConversationInstance {
  // Private constructor to implement the singleton pattern.
  TencentCloudChatConversationInstance._internal();

  // Factory constructor that returns the singleton instance of TencentCloudChatConversationInstance.
  factory TencentCloudChatConversationInstance() => _instance;
  static final TencentCloudChatConversationInstance _instance = TencentCloudChatConversationInstance._internal();

  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.conversation,
      builder: (context) => TencentCloudChatConversation(
        options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatConversationOptions>(context, 'data'),
      ),
    );

    return (
      componentEnum: TencentCloudChatComponentsEnum.conversation,
      widgetBuilder: ({required Map<String, dynamic> options}) => const TencentCloudChatConversation(),
    );
  }
}
