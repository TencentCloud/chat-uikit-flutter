library tencent_cloud_chat_search;

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_search_config.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_search_event_handlers.dart';
import 'package:tencent_cloud_chat/components/component_options/tencent_cloud_chat_search_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_route_names.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_router.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_component_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_search/data/defines.dart';
import 'package:tencent_cloud_chat_search/global_search/tencent_cloud_chat_global_search.dart';
import 'package:tencent_cloud_chat_search/search_in_chat/tencent_cloud_chat_search_in_chat_search.dart';
import 'package:tencent_cloud_chat_search/tencent_cloud_chat_search_builders.dart';
import 'package:tencent_cloud_chat_search/tencent_cloud_chat_seatch_controller.dart';

class TencentCloudChatSearch extends TencentCloudChatComponent<TencentCloudChatSearchOptions,
    TencentCloudChatSearchConfig, TencentCloudChatSearchBuilders, TencentCloudChatSearchEventHandlers> {
  const TencentCloudChatSearch({
    super.key,
    super.options,
    super.config,
    super.builders,
    super.eventHandlers,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatSearchState();
}

class TencentCloudChatSearchState extends TencentCloudChatState<TencentCloudChatSearch> {
  @override
  Widget defaultBuilder(BuildContext context) {
    final searchMode = ((TencentCloudChatUtils.checkString(widget.options?.userID) == null) &&
            (TencentCloudChatUtils.checkString(widget.options?.groupID) == null))
        ? TencentCloudChatSearchMode.global
        : TencentCloudChatSearchMode.inChat;
    return searchMode == TencentCloudChatSearchMode.global
        ? TencentCloudChatGlobalSearch(
            keyWord: widget.options?.keyWord ?? "",
          )
        : TencentCloudChatInChatSearch(
            closeFunc: widget.options?.closeFunc,
            keyword: widget.options?.keyWord ?? "",
            userID: widget.options?.userID ?? "",
            groupID: widget.options?.groupID ?? "",
            conversationID: TencentCloudChat.instance.chatSDKInstance.searchSDK.buildConversationId(
              userID: widget.options?.userID ?? "",
              groupID: widget.options?.groupID ?? "",
            ),
          );
  }
}

/// The TencentCloudChatSearchManager is responsible for managing the TencentCloudChatSearch component.
/// It enables manual declaration of `TencentCloudChatSearch` usage during the `initUIKit` call,
/// and provides control over the component's configuration, UI widget builders, and event listeners on a global scale,
/// affecting all instances of the TencentCloudChatSearch component.
class TencentCloudChatSearchManager {
  /// Allows dynamic updating of UI widget builders for all instances.
  /// Call the `setBuilders` method and pass any UI builders to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatSearchBuilders get builder {
    TencentCloudChat.instance.dataInstance.search.searchBuilder ??= TencentCloudChatSearchBuilders();
    return TencentCloudChat.instance.dataInstance.search.searchBuilder as TencentCloudChatSearchBuilders;
  }

  /// Retrieves the controller for controlling `TencentCloudChatSearch` components,
  /// applying to all instances.
  /// Utilize the provided control methods.
  static TencentCloudChatSearchController get controller {
    TencentCloudChat.instance.dataInstance.search.searchController ??=
        TencentCloudChatSearchControllerGenerator.getInstance();
    return TencentCloudChat.instance.dataInstance.search.searchController as TencentCloudChatSearchController;
  }

  /// Enables dynamic updating of configurations for all instances.
  /// Call the `setConfigs` method and pass any configurations to be modified,
  /// which will replace the previous configuration and apply changes immediately.
  static TencentCloudChatSearchConfig get config {
    return TencentCloudChat.instance.dataInstance.search.searchConfig;
  }

  /// Attaches listeners to Component-level events.
  /// Covers both `uiEventHandlers` (e.g., various onTap-like events) and `lifeCycleEventHandlers` (business-related events).
  /// Call `setEventHandlers` from both `uiEventHandlers` and `lifeCycleEventHandlers` to update specific event handlers.
  /// Note: This will cause the corresponding event's previously attached handlers to be invalidated, i.e., overridden.
  static TencentCloudChatSearchEventHandlers get eventHandlers {
    TencentCloudChat.instance.dataInstance.search.searchEventHandlers ??= TencentCloudChatSearchEventHandlers();
    return TencentCloudChat.instance.dataInstance.search.searchEventHandlers!;
  }

  /// Manually declares the usage of the `TencentCloudChatSearch` component.
  /// During the `initUIKit` call, add `TencentCloudChatSearchManager.register` in `usedComponentsRegister` within `components`
  /// if you plan to use this component.
  static ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) register() {
    TencentCloudChatRouter().registerRouter(
      routeName: TencentCloudChatRouteNames.search,
      builder: (context) => TencentCloudChatSearch(
        options: TencentCloudChatRouter().getArgumentFromMap<TencentCloudChatSearchOptions>(context, 'data'),
      ),
    );

    TencentCloudChat.instance.dataInstance.search.searchBuilder ??= TencentCloudChatSearchBuilders();

    TencentCloudChat.instance.dataInstance.search.searchController ??=
        TencentCloudChatSearchControllerGenerator.getInstance();

    return (
      componentEnum: TencentCloudChatComponentsEnum.search,
      widgetBuilder: ({required Map<String, dynamic> options}) => TencentCloudChatSearch(
            options: TencentCloudChatSearchOptions(
              userID: options["userID"],
              groupID: options["groupID"],
              keyWord: options["keyWord"],
              closeFunc: options["closeFunc"],
            ),
          ),
    );
  }
}
