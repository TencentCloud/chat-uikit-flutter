library tencent_cloud_chat_conversation;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_conversation_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_conversation_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_builders.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_controller.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_options.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_app_bar.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_list.dart';

import 'desktop/tencent_cloud_chat_conversation_desktop_mode.dart';

class TencentCloudChatConversation extends TencentCloudChatComponent<
    TencentCloudChatConversationOptions,
    TencentCloudChatConversationConfig,
    TencentCloudChatConversationBuilders,
    TencentCloudChatConversationEventHandlers> {
  const TencentCloudChatConversation({
    super.key,
    super.options,
    super.config,
    super.builders,
    super.eventHandlers,
  });

  @override
  TencentCloudChatConversationState createState() => TencentCloudChatConversationState();
}

class TencentCloudChatConversationState extends TencentCloudChatState<TencentCloudChatConversation> {
  final Stream<TencentCloudChatConversationData<dynamic>>? _conversationDataStream = TencentCloudChat
      .instance.eventBusInstance
      .on<TencentCloudChatConversationData<dynamic>>("TencentCloudChatConversationData");
  StreamSubscription<TencentCloudChatConversationData<dynamic>>? _conversationDataSubscription;

  late bool _useDesktopMode;
  late TextEditingController _textEditingController;
  TencentCloudChatWidgetBuilder? _globalSearchWidget;
  String _searchText = "";

  bool includeSearch =
      TencentCloudChat.instance.dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.search);

  final Stream<TencentCloudChatBasicData<dynamic>>? _basicDataStream =
      TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatBasicData<dynamic>>("TencentCloudChatBasicData");

  StreamSubscription<TencentCloudChatBasicData<dynamic>>? _basicDataSubscription;

  @override
  void initState() {
    super.initState();
    _addConversationDataListener();
    _updateGlobalData();
    _useDesktopMode = TencentCloudChat.instance.dataInstance.conversation.conversationConfig.useDesktopMode;

    TencentCloudChat.instance.logInstance.console(
        componentName: 'TencentCloudChatConversation',
        logs: "add _conversationDataStream start ${_conversationDataStream != null}");

    _textEditingController = TextEditingController();
    _addBasicEventListener();
    _globalSearchWidget =
        TencentCloudChat.instance.dataInstance.basic.componentsMap[TencentCloudChatComponentsEnum.search];
    if (_globalSearchWidget != null) {
      _textEditingController.addListener(_searchTextListenerHandler);
    }
  }

  void _addBasicEventListener() {
    _basicDataSubscription = _basicDataStream?.listen((event) {
      if (event.currentUpdatedFields == TencentCloudChatBasicDataKeys.addUsedComponent) {
        safeSetState(() {
          includeSearch = TencentCloudChat.instance.dataInstance.basic.usedComponents
              .contains(TencentCloudChatComponentsEnum.search);
        });
        final searchWidget =
            TencentCloudChat.instance.dataInstance.basic.componentsMap[TencentCloudChatComponentsEnum.search];
        if (searchWidget != _globalSearchWidget) {
          safeSetState(() {
            _globalSearchWidget = searchWidget;
          });
          if (_globalSearchWidget != null) {
            _textEditingController.removeListener(_searchTextListenerHandler);
            _textEditingController.addListener(_searchTextListenerHandler);
          } else {
            _textEditingController.removeListener(_searchTextListenerHandler);
          }
        }
      }
    });
  }

  void _searchTextListenerHandler() {
    final text = _textEditingController.text;
    safeSetState(() {
      _searchText = text;
    });
  }

  @override
  void didUpdateWidget(TencentCloudChatConversation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateGlobalData(oldWidget);
  }

  @override
  void dispose() {
    _conversationDataSubscription?.cancel();
    _basicDataSubscription?.cancel();
    _textEditingController.removeListener(_searchTextListenerHandler);
    _textEditingController.dispose();
    super.dispose();
  }

  _addConversationDataListener() {
    _conversationDataSubscription = _conversationDataStream?.listen(_conversationDataHandler);
  }

  _conversationDataHandler(TencentCloudChatConversationData data) {
    /// === useDesktopMode ===
    if (data.conversationConfig.useDesktopMode != _useDesktopMode) {
      setState(() {
        _useDesktopMode = data.conversationConfig.useDesktopMode;
      });
    }

    if (data.currentUpdatedFields == TencentCloudChatConversationDataKeys.conversationBuilder) {
      setState(() {});
    }
  }

  void _updateGlobalData([TencentCloudChatConversation? oldWidget]) {
    if (widget.config != null || (oldWidget != null && oldWidget.config != widget.config && widget.config != null)) {
      TencentCloudChat.instance.dataInstance.conversation.conversationConfig = widget.config!;
    }

    if (widget.eventHandlers != null ||
        (oldWidget != null && oldWidget.eventHandlers != widget.eventHandlers && widget.eventHandlers != null)) {
      TencentCloudChat.instance.dataInstance.conversation.conversationEventHandlers = widget.eventHandlers;
    }

    if (widget.builders != null ||
        (oldWidget != null && oldWidget.builders != widget.builders && widget.builders != null)) {
      TencentCloudChat.instance.dataInstance.conversation.conversationBuilder = widget.builders;
    } else {
      TencentCloudChat.instance.dataInstance.conversation.conversationBuilder = TencentCloudChatConversationBuilders();
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Container();
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    final header =
        TencentCloudChat.instance.dataInstance.conversation.conversationBuilder?.getConversationHeaderBuilder(
      textEditingController: _textEditingController,
    );
    if (header?.$2 ?? false) {
      return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
          child: Column(
            children: [
              Container(
                color: colorTheme.backgroundColor,
                child: header?.$1,
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
            backgroundColor: colorTheme.backgroundColor,
            title: header?.$1,
            scrolledUnderElevation: 0.0,
          ),
          body: Column(
            children: [
              if (includeSearch)
                Container(
                  color: colorTheme.backgroundColor,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: TencentCloudChatAppBarSearchItem(
                    textEditingController: _textEditingController,
                  ),
                ),
              if (includeSearch)
                Divider(
                  height: 1,
                  color: colorTheme.dividerColor,
                ),
              (TencentCloudChatUtils.checkString(_searchText) != null && _globalSearchWidget != null)
                  ? Expanded(
                      child: _globalSearchWidget!(
                        options: {
                          "keyWord": _searchText,
                        },
                      ),
                    )
                  : const Expanded(
                      child: TencentCloudChatConversationList(),
                    ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    if (_useDesktopMode) {
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

/// The TencentCloudChatConversationManager is responsible for managing the TencentCloudChatConversation component.
/// It enables manual declaration of `TencentCloudChatConversation` usage during the `initUIKit` call,
/// and provides control over the component's configuration, UI widget builders, and event listeners on a global scale,
/// affecting all instances of the TencentCloudChatConversation component.
class TencentCloudChatConversationManager {
  /// Allows dynamic updating of UI widget builders for all instances.
  /// Call the `setBuilders` method and pass any UI builders to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatConversationBuilders get builder {
    TencentCloudChat.instance.dataInstance.conversation.conversationBuilder ??= TencentCloudChatConversationBuilders();
    return TencentCloudChat.instance.dataInstance.conversation.conversationBuilder
        as TencentCloudChatConversationBuilders;
  }

  /// Retrieves the controller for controlling `TencentCloudChatConversation` components,
  /// applying to all instances.
  /// Utilize the provided control methods.
  static TencentCloudChatConversationController get controller {
    TencentCloudChat.instance.dataInstance.conversation.conversationController ??=
        TencentCloudChatConversationController.instance;
    return TencentCloudChat.instance.dataInstance.conversation.conversationController
        as TencentCloudChatConversationController;
  }

  /// Enables dynamic updating of configurations for all instances.
  /// Call the `setConfigs` method and pass any configurations to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatConversationConfig get config {
    return TencentCloudChat.instance.dataInstance.conversation.conversationConfig;
  }

  /// Attaches listeners to Component-level events.
  /// Covers both `uiEventHandlers` (e.g., various onTap-like events) and `lifeCycleEventHandlers` (business-related events).
  /// Call `setEventHandlers` from both `uiEventHandlers` and `lifeCycleEventHandlers` to update specific event handlers.
  /// Note: This will cause the corresponding event's previously attached handlers to be invalidated, i.e., overridden.
  static TencentCloudChatConversationEventHandlers get eventHandlers {
    TencentCloudChat.instance.dataInstance.conversation.conversationEventHandlers ??=
        TencentCloudChatConversationEventHandlers();
    return TencentCloudChat.instance.dataInstance.conversation.conversationEventHandlers!;
  }

  /// Manually declares the usage of the `TencentCloudChatConversation` component.
  /// During the `initUIKit` call, add `TencentCloudChatConversationManager.register` in `usedComponentsRegister` within `components`
  /// if you plan to use this component.
  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.conversation,
      builder: (context) => TencentCloudChatConversation(
        options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatConversationOptions>(context, 'data'),
      ),
    );

    TencentCloudChat.instance.dataInstance.conversation.conversationBuilder ??= TencentCloudChatConversationBuilders();

    TencentCloudChat.instance.dataInstance.conversation.conversationController ??=
        TencentCloudChatConversationController.instance;

    TencentCloudChatConversationController.instance.init();

    return (
      componentEnum: TencentCloudChatComponentsEnum.conversation,
      widgetBuilder: ({required Map<String, dynamic> options}) => const TencentCloudChatConversation(),
    );
  }
}

class TencentCloudChatConversationInstance {
  /// Use `TencentCloudChatConversationManager.register` instead.
  /// This method will be removed in a future version.
  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    return TencentCloudChatConversationManager.register();
  }
}
