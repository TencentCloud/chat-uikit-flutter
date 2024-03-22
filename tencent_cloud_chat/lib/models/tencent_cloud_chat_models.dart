import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_user_config.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/data/theme/tencent_cloud_chat_theme_model.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_init_data_config.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

typedef TencentCloudChatPluginWidget = Widget Function(V2TimMessage message);
typedef MessageBuilderForPlugin = Widget Function(V2TimMessage message);
typedef ConversationBuilderForPlugin = Widget Function(
    V2TimConversation conversation);
typedef PlaceHolderBuilder = Widget Function();

typedef TencentCloudChatWidgetBuilder = Widget Function(
    {required Map<String, dynamic> options});

typedef TencentCloudChatModularUIPackageRegister = ({
  TencentCloudChatComponentsEnum componentEnum,
  TencentCloudChatWidgetBuilder widgetBuilder,
})
    Function();

/// This class represents the configuration for Tencent Cloud Chat.
class TencentCloudChatConfig {
  /// The brightness mode of the application (light or dark).
  Brightness? brightness;

  /// The theme config.
  TencentCloudChatThemeModel? themeConfig;

  /// List of registration functions for the used components of the Chat UIKit.
  ///
  /// Each modular UI package component used in the Chat UIKit must have its registration method included here.
  /// Include the registration methods of the components you are using.
  ///
  /// Based on the components you're using in your application, include the corresponding register methods in the list.
  /// Example usage:
  /// ```dart
  /// usedComponentsRegister: [
  ///   TencentCloudChatConversationInstance.register,  // Conversation component
  ///   TencentCloudChatMessageInstance.register,       // Message component
  ///   TencentCloudChatUserProfileInstance.register,   // UserProfile component
  ///   TencentCloudChatGroupProfileInstance.register,  // GroupProfile component
  ///   TencentCloudChatContactInstance.register,       // Contact component
  /// ]
  /// ```
  List<TencentCloudChatModularUIPackageRegister> usedComponentsRegister;

  /// Preload core data configuration. Optional configuration items include conversation data configuration, joined group data configuration, and contact data configuration.
  TencentCloudChatInitDataConfig? preloadDataConfig;

  /// The configuration for the TencentCloudChatMessage component.
  TencentCloudChatMessageConfig? messageConfig;

  /// User related configuration
  TencentCloudChatUserConfig? userConfig;

  /// Constructor for TencentCloudChatConfig.
  ///
  /// [usedComponentsRegister]: The list of register functions of used components of the Chat UIKit.
  /// [themeConfig]: The theme configuration for the app.
  /// [brightness]: The brightness mode of the app (light or dark).
  /// [preloadDataConfig]: The configuration for preloading data in the app.
  /// [messageConfig]: The configuration for the TencentCloudChatMessage component.
  TencentCloudChatConfig({
    required this.usedComponentsRegister,
    this.themeConfig,
    this.brightness,
    this.preloadDataConfig,
    this.messageConfig,
    this.userConfig,
  });
}

/// This class represents the initial options for Tencent Cloud Chat.
class TencentCloudChatInitOptions {
  /// The user ID for the Chat SDK.
  String userID;

  /// The user signature for the Chat SDK.
  String userSig;

  /// The Chat SDKAppID.
  int sdkAppID;

  V2TimSDKListener? sdkListener;

  /// Constructor for TencentCloudChatInitOptions.
  ///
  /// [sdkAppID]: The Chat SDKAppID.
  /// [userID]: The user ID for the Chat SDK.
  /// [userSig]: The user signature for the Chat SDK.
  TencentCloudChatInitOptions({
    required this.sdkAppID,
    required this.userID,
    required this.userSig,
    this.sdkListener,
  });
}

class TencentCloudChatPluginItem {
  final TencentCloudChatPlugin pluginInstance;
  final String name;
  Map<String, dynamic>? initData;
  TencentCloudChatPluginTapFn? tapFn;

  TencentCloudChatPluginItem({
    required this.name,
    required this.pluginInstance,
    this.initData,
    this.tapFn,
  });
}
