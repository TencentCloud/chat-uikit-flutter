library tencent_cloud_chat_message;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_group_profile.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_info/tencent_cloud_chat_message_info.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_info/tencent_cloud_chat_message_info_options.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/tencent_cloud_chat_message_input_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/tencent_cloud_chat_message_layout_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/tencent_cloud_chat_message_list_view_container.dart';

class TencentCloudChatMessage extends TencentCloudChatComponent<TencentCloudChatMessageOptions, TencentCloudChatMessageConfig, TencentCloudChatMessageBuilders, TencentCloudChatMessageEventHandlers> {
  const TencentCloudChatMessage({
    required TencentCloudChatMessageOptions options,
    Key? key,
    TencentCloudChatMessageConfig? config,
    TencentCloudChatMessageBuilders? builders,
    TencentCloudChatMessageEventHandlers? eventHandlers,
  }) : super(
          key: key,
          options: options,
          config: config,
          builders: builders,
          eventHandlers: eventHandlers,
        );

  @override
  State<StatefulWidget> createState() => _TencentCloudChatMessageState();
}

class _TencentCloudChatMessageState extends TencentCloudChatState<TencentCloudChatMessage> {
  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData<dynamic>>("TencentCloudChatMessageData");
  StreamSubscription<TencentCloudChatMessageData<dynamic>>? _messageDataSubscription;

  final TencentCloudChatMessageSeparateDataProvider _messageSeparateDataProvider = TencentCloudChatMessageSeparateDataProvider();

  @override
  void initState() {
    super.initState();
    _addMessageDataListener();
    _messageSeparateDataProvider.init(
      userID: widget.options?.userID,
      groupID: widget.options?.groupID,
      topicID: widget.options?.topicID,
      config: widget.config,
      eventHandlers: widget.eventHandlers,
      controller: null,
      builders: widget.builders,
    );
  }

  @override
  void didUpdateWidget(covariant TencentCloudChatMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.options?.userID != oldWidget.options?.userID && !(TencentCloudChatUtils.checkString(widget.options?.userID) == null && TencentCloudChatUtils.checkString(oldWidget.options?.userID) == null)) ||
        (widget.options?.groupID != oldWidget.options?.groupID && !(TencentCloudChatUtils.checkString(widget.options?.groupID) == null && TencentCloudChatUtils.checkString(oldWidget.options?.groupID) == null)) ||
        (widget.options?.topicID != oldWidget.options?.topicID && !(TencentCloudChatUtils.checkString(widget.options?.topicID) == null && TencentCloudChatUtils.checkString(oldWidget.options?.topicID) == null))) {
      _messageSeparateDataProvider.unInit();
      _messageSeparateDataProvider.init(
        userID: widget.options?.userID,
        groupID: widget.options?.groupID,
        topicID: widget.options?.topicID,
        config: widget.config,
        eventHandlers: widget.eventHandlers,
        controller: null,
        builders: widget.builders,
      );
    }
    _updateGlobalData(oldWidget);
  }

  void _updateGlobalData(TencentCloudChatMessage oldWidget) {
    if ((oldWidget.config != widget.config && widget.config != null)) {
      _messageSeparateDataProvider.config = widget.config!;
    }

    if ((oldWidget.eventHandlers != widget.eventHandlers && widget.eventHandlers != null)) {
      _messageSeparateDataProvider.messageEventHandlers = widget.eventHandlers;
    }

    if ((oldWidget.builders != widget.builders && widget.builders != null)) {
      _messageSeparateDataProvider.messageBuilders = widget.builders;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageSeparateDataProvider.dispose();
    _messageDataSubscription?.cancel();
  }

  _addMessageDataListener() {
    _messageDataSubscription = _messageDataStream?.listen(_messageDataHandler);
  }

  _messageDataHandler(TencentCloudChatMessageData data) {
    if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.builder && TencentCloudChat.instance.dataInstance.messageData.messageBuilder != null) {
      _messageSeparateDataProvider.messageBuilders = TencentCloudChat.instance.dataInstance.messageData.messageBuilder as TencentCloudChatMessageBuilders?;
      setState(() {});
    }

    if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.config) {
      _messageSeparateDataProvider.config = TencentCloudChat.instance.dataInstance.messageData.messageConfig;
      setState(() {});
    }

    if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.userStatusChange && (TencentCloudChat.instance.dataInstance.basic.userConfig.useUserOnlineStatus ?? true) &&
        widget.options?.userID != null && data.userStatusChangeSet.contains(widget.options?.userID)) {
      safeSetState(() {});
    }

    if (data.currentUpdatedFields == TencentCloudChatMessageDataKeys.friendInfoChange && widget.options?.userID != null && data.friendInfoChangeSet.contains(widget.options?.userID)) {
      _messageSeparateDataProvider.unInit();
      _messageSeparateDataProvider.init(
        userID: widget.options?.userID,
        groupID: widget.options?.groupID,
        topicID: widget.options?.topicID,
        config: widget.config,
        eventHandlers: widget.eventHandlers,
        controller: null,
        builders: widget.builders,
      );
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    bool hasChat = true;
    String? userID = widget.options!.userID;
    String? groupID = widget.options!.groupID;
    if (widget.options != null) {
      bool hasC2CChat = true;
      bool hasGroupChat = true;
      if (widget.options!.userID == null || widget.options!.userID!.isEmpty) {
        hasC2CChat = false;
        userID = null;
      }
      if (widget.options!.groupID == null || widget.options!.groupID!.isEmpty) {
        hasGroupChat = false;
        groupID = null;
      }

      if (hasC2CChat == hasGroupChat) {
        hasChat = false;
      }
    }
    final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
    return hasChat
        ? TencentCloudChatMessageDataProviderInherited(
            dataProvider: _messageSeparateDataProvider,
            child: TencentCloudChatMessageLayoutContainer(
              userID: userID,
              groupID: groupID,
              topicID: widget.options!.topicID,
              header: TencentCloudChatMessageHeaderContainer(
                toolbarHeight: getHeight(isDesktop ? 64 : 60),
                userID: userID,
                groupID: groupID,
                topicID: widget.options!.topicID,
              ),
              messageListView: TencentCloudChatMessageListViewContainer(
                userID: userID,
                groupID: groupID,
                topicID: widget.options!.topicID,
                targetMessage: widget.options?.targetMessage,
              ),
              messageInput: TencentCloudChatMessageInputContainer(
                userID: userID,
                groupID: groupID,
                topicID: widget.options!.topicID,
                draftText: widget.options!.draftText,
              ),
            ),
          )
        : widget.builders?.getMessageNoChatBuilder() ?? TencentCloudChat.instance.dataInstance.messageData.messageBuilder?.getMessageNoChatBuilder() ?? TencentCloudChatMessageBuilders().getMessageNoChatBuilder() ?? Container();
  }
}

/// The TencentCloudChatMessageManager is responsible for managing the TencentCloudChatMessage component.
/// It enables manual declaration of `TencentCloudChatMessage` usage during the `initUIKit` call,
/// and provides control over the component's configuration, UI widget builders, and event listeners on a global scale,
/// affecting all instances of the TencentCloudChatMessage component.
class TencentCloudChatMessageManager {
  /// Allows dynamic updating of UI widget builders for all instances.
  /// Call the `setBuilders` method and pass any UI builders to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatMessageBuilders get builder {
    TencentCloudChat.instance.dataInstance.messageData.messageBuilder ??= TencentCloudChatMessageBuilders();
    return TencentCloudChat.instance.dataInstance.messageData.messageBuilder as TencentCloudChatMessageBuilders;
  }

  /// Retrieves the controller for controlling `TencentCloudChatMessage` components,
  /// applying to all instances.
  /// Utilize the provided control methods.
  static TencentCloudChatMessageController get controller {
    TencentCloudChat.instance.dataInstance.messageData.messageController ??= TencentCloudChatMessageControllerGenerator.getInstance();
    return TencentCloudChat.instance.dataInstance.messageData.messageController as TencentCloudChatMessageController;
  }

  /// Enables dynamic updating of configurations for all instances.
  /// Call the `setConfigs` method and pass any configurations to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  /// Note: This will cause the all configs that specified through the input parameter of each instance to be invalidated, i.e., overridden.
  static TencentCloudChatMessageConfig get config {
    return TencentCloudChat.instance.dataInstance.messageData.messageConfig;
  }

  /// Attaches listeners to Component-level events.
  /// Covers both `uiEventHandlers` (e.g., various onTap-like events) and `lifeCycleEventHandlers` (business-related events).
  /// Call `setEventHandlers` from both `uiEventHandlers` and `lifeCycleEventHandlers` to update specific event handlers.
  /// Note: This will cause the corresponding event's previously attached handlers to be invalidated, i.e., overridden.
  static TencentCloudChatMessageEventHandlers get eventHandlers {
    TencentCloudChat.instance.dataInstance.messageData.messageEventHandlers ??= TencentCloudChatMessageEventHandlers();
    return TencentCloudChat.instance.dataInstance.messageData.messageEventHandlers!;
  }

  /// Manually declares the usage of the `TencentCloudChatMessage` component.
  /// During the `initUIKit` call, add `TencentCloudChatMessageManager.register` in `usedComponentsRegister` within `components`
  /// if you plan to use this component.
  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    TencentCloudChat.instance.dataInstance.messageData.init();

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

    TencentCloudChat.instance.dataInstance.messageData.messageBuilder ??= TencentCloudChatMessageBuilders();

    TencentCloudChat.instance.dataInstance.messageData.messageController ??= TencentCloudChatMessageControllerGenerator.getInstance();

    TencentCloudChatGroupProfileManager.register();

    return (
      componentEnum: TencentCloudChatComponentsEnum.message,
      widgetBuilder: ({required Map<String, dynamic> options}) => TencentCloudChatMessage(
            options: TencentCloudChatMessageOptions(
              userID: options["userID"],
              groupID: options["groupID"],
              topicID: options["topicID"],
              targetMessage: options["targetMessage"],
            ),
          ),
    );
  }
}

class TencentCloudChatMessageInstance {
  /// Use `TencentCloudChatMessageManager.register` instead.
  /// This method will be removed in a future version.
  static ({
    TencentCloudChatComponentsEnum componentEnum,
    TencentCloudChatWidgetBuilder widgetBuilder,
  }) register() {
    return TencentCloudChatMessageManager.register();
  }
}
