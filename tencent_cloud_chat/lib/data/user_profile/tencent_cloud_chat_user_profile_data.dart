import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_user_profile_config.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_user_profile_event_handlers.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder.dart';

enum TencentCloudChatUserProfileDataKeys { none, config, builder }

class TencentCloudChatUserProfileData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatUserProfileData(super.currentUpdatedFields);

  String onlineStatus = "";

  /// === User Profile Config ===
  TencentCloudChatUserProfileConfig _userProfileConfig =
      TencentCloudChatUserProfileConfig();

  TencentCloudChatUserProfileConfig get userProfileConfig => _userProfileConfig;

  set userProfileConfig(TencentCloudChatUserProfileConfig value) {
    _userProfileConfig = value;
    notifyListener(TencentCloudChatUserProfileDataKeys.config as T);
  }

  /// ==== Event Handlers ====
  TencentCloudChatUserProfileEventHandlers? userProfileEventHandlers;

  /// === Controller ===
  TencentCloudChatComponentBaseController? userProfileController;

  /// === User Profile Builder ===
  TencentCloudChatComponentBuilder? _userProfileBuilder;

  TencentCloudChatComponentBuilder? get userProfileBuilder =>
      _userProfileBuilder;

  set userProfileBuilder(TencentCloudChatComponentBuilder? value) {
    _userProfileBuilder = value;
    notifyListener(TencentCloudChatUserProfileDataKeys.builder as T);
  }

  @override
  void notifyListener(T key) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
