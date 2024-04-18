import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_group_profile_config.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_group_profile_event_handlers.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder.dart';

enum TencentCloudChatGroupProfileDataKeys { none, config, builder }

class TencentCloudChatGroupProfileData<T> extends TencentCloudChatDataAB<T> {
  final Map<String, List<String>> _groupNineSquareAvatarCache = Map.from({});

  TencentCloudChatGroupProfileData(super.currentUpdatedFields);

  List<String> getGroupNineSquareAvatarCacheByGroupID({
    required String groupID,
  }) {
    return _groupNineSquareAvatarCache[groupID] ?? [];
  }

  /// === Group Profile Config ===
  TencentCloudChatGroupProfileConfig _groupProfileConfig =
      TencentCloudChatGroupProfileConfig();

  TencentCloudChatGroupProfileConfig get groupProfileConfig =>
      _groupProfileConfig;

  set groupProfileConfig(TencentCloudChatGroupProfileConfig value) {
    _groupProfileConfig = value;
    notifyListener(TencentCloudChatGroupProfileDataKeys.config as T);
  }

  /// ==== Event Handlers ====
  TencentCloudChatGroupProfileEventHandlers? groupProfileEventHandlers;

  /// === Group Profile Builder ===
  TencentCloudChatComponentBuilder? _groupProfileBuilder;

  TencentCloudChatComponentBuilder? get groupProfileBuilder =>
      _groupProfileBuilder;

  set groupProfileBuilder(TencentCloudChatComponentBuilder? value) {
    _groupProfileBuilder = value;
    notifyListener(TencentCloudChatGroupProfileDataKeys.builder as T);
  }

  /// === Controller ===
  TencentCloudChatComponentBaseController? groupProfileController;

  @override
  void notifyListener(T key) {
    // TODO: implement notifyListener
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
