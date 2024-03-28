library tencent_cloud_chat_message;

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat/components/components_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_info/tencent_cloud_chat_message_info.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_info/tencent_cloud_chat_message_info_options.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/tencent_cloud_chat_message_input_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/tencent_cloud_chat_message_layout_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/tencent_cloud_chat_message_list_view_container.dart';

import 'data/tencent_cloud_chat_message_separate_data.dart';

class TencentCloudChatMessage extends TencentCloudChatComponent<TencentCloudChatMessageOptions, TencentCloudChatMessageConfig, TencentCloudChatMessageBuilders, TencentCloudChatMessageEventHandlers, TencentCloudChatMessageController> {
  const TencentCloudChatMessage({
    required TencentCloudChatMessageOptions options,
    Key? key,
    TencentCloudChatMessageConfig? config,
    TencentCloudChatMessageBuilders? builders,
    TencentCloudChatMessageEventHandlers? eventHandlers,
    TencentCloudChatMessageController? controller,
  }) : super(
          key: key,
          options: options,
          config: config,
          builders: builders,
          eventHandlers: eventHandlers,
          controller: controller,
        );

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageState();
}

class _TencentCloudChatMessageState extends TencentCloudChatState<TencentCloudChatMessage> {
  final TencentCloudChatMessageSeparateDataProvider _messageSeparateDataProvider = TencentCloudChatMessageSeparateDataProvider();

  @override
  void initState() {
    super.initState();
    _messageSeparateDataProvider.init(
      userID: widget.options?.userID,
      groupID: widget.options?.groupID,
      config: widget.config,
    );
    _messageSeparateDataProvider.messageController = widget.controller ?? TencentCloudChatMessageController();
  }

  @override
  void didUpdateWidget(covariant TencentCloudChatMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.options?.userID != oldWidget.options?.userID && !(TencentCloudChatUtils.checkString(widget.options?.userID) == null && TencentCloudChatUtils.checkString(oldWidget.options?.userID) == null)) ||
        (widget.options?.groupID != oldWidget.options?.groupID && !(TencentCloudChatUtils.checkString(widget.options?.groupID) == null && TencentCloudChatUtils.checkString(oldWidget.options?.groupID) == null))) {
      _messageSeparateDataProvider.unInit();
      _messageSeparateDataProvider.init(
        userID: widget.options?.userID,
        groupID: widget.options?.groupID,
        config: widget.config,
      );
      _messageSeparateDataProvider.messageController = widget.controller ?? TencentCloudChatMessageController();
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageSeparateDataProvider.dispose();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final hasChat = (widget.options?.userID == null) != (widget.options?.groupID == null);
    final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
    return hasChat
        ? TencentCloudChatMessageDataProviderInherited(
            dataProvider: _messageSeparateDataProvider,
            child: TencentCloudChatMessageLayoutContainer(
              userID: widget.options!.userID,
              groupID: widget.options!.groupID,
              header: TencentCloudChatMessageHeaderContainer(
                toolbarHeight: getHeight(isDesktop ? 64 : 60),
                userID: widget.options!.userID,
                groupID: widget.options!.groupID,
              ),
              messageListView: TencentCloudChatMessageListViewContainer(
                userID: widget.options!.userID,
                groupID: widget.options!.groupID,
              ),
              messageInput: TencentCloudChatMessageInputContainer(
                userID: widget.options!.userID,
                groupID: widget.options!.groupID,
              ),
            ),
          )
        : TencentCloudChatMessageBuilders.getMessageNoChatBuilder();
  }
}

class TencentCloudChatMessageInstance {
  // Private constructor to implement the singleton pattern.
  TencentCloudChatMessageInstance._internal();

  // Factory constructor that returns the singleton instance of TencentCloudChatConversationInstance.
  factory TencentCloudChatMessageInstance() => _instance;
  static final TencentCloudChatMessageInstance _instance = TencentCloudChatMessageInstance._internal();

  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    TencentCloudChat().dataInstance.messageData.init();

    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.message,
      builder: (context) => TencentCloudChatMessage(
        options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatMessageOptions>(context, 'options')!,
      ),
    );

    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.messageInfo,
      builder: (context) => TencentCloudChatMessageInfo(
        options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatMessageInfoOptions>(context, 'data') ?? TencentCloudChatMessageInfoOptions(),
      ),
    );

    return (
      componentEnum: TencentCloudChatComponentsEnum.message,
      widgetBuilder: ({required Map<String, dynamic> options}) => TencentCloudChatMessage(
            options: TencentCloudChatMessageOptions(
              userID: options["userID"],
              groupID: options["groupID"],
            ),
          ),
    );
  }
}
