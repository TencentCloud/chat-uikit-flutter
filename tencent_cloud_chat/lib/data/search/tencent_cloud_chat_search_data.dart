import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_search_config.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_search_event_handlers.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

/// An enumeration of search data keys TencentCloudChat search component
enum TencentCloudChatSearchDataKeys {
  none,
  searchList,
  currentSearch,
  searchConfig,
  searchBuilder,
  searchEventHandlers,
}

/// A class that manages the search data for TencentCloudChat search component
///
/// This class extends [TencentCloudChatUIKitCoreDataAB] and provides
/// functionality for managing the status of search component.
class TencentCloudChatSearchData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatSearchData(super.currentUpdatedFields);

  /// === Search Config ===
  TencentCloudChatSearchConfig _searchConfig = TencentCloudChatSearchConfig();

  TencentCloudChatSearchConfig get searchConfig => _searchConfig;

  set searchConfig(TencentCloudChatSearchConfig value) {
    _searchConfig = value;
    notifyListener(TencentCloudChatSearchDataKeys.searchConfig as T);
  }

  /// === Search Event Handlers ===
  TencentCloudChatSearchEventHandlers? searchEventHandlers;

  /// === Search Builder ===
  TencentCloudChatComponentBuilder? _searchBuilder;

  TencentCloudChatComponentBuilder? get searchBuilder => _searchBuilder;

  set searchBuilder(TencentCloudChatComponentBuilder? value) {
    _searchBuilder = value;
    notifyListener(TencentCloudChatSearchDataKeys.searchBuilder as T);
  }

  /// === Controller ===
  TencentCloudChatComponentBaseController? searchController;

  @override
  void notifyListener(T key) {
    var event = TencentCloudChatSearchData<T>(key);
    event._searchConfig = _searchConfig;
    event.searchEventHandlers = searchEventHandlers;
    event._searchBuilder = _searchBuilder;
    event.searchController = searchController;

    TencentCloudChat.instance.eventBusInstance.fire(event, "TencentCloudChatSearchData");
  }

  @override
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({});
  }

  @override
  void clear() {

  }
}
