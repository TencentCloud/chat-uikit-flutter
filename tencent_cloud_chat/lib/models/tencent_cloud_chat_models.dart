import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_contact_config.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_conversation_config.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_group_profile_config.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_user_config.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_user_profile_config.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_contact_event_handlers.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_conversation_event_handlers.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_group_profile_event_handlers.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat/components/component_event_handlers/tencent_cloud_chat_user_profile_event_handlers.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/data/theme/tencent_cloud_chat_theme_model.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

typedef TencentCloudChatPluginWidget = Widget Function(V2TimMessage message);
typedef MessageBuilderForPlugin = Widget Function(V2TimMessage message);
typedef ConversationBuilderForPlugin = Widget Function(V2TimConversation conversation);
typedef PlaceHolderBuilder = Widget Function();

typedef TencentCloudChatWidgetBuilder = Widget Function({required Map<String, dynamic> options});

typedef TencentCloudChatModularUIPackageRegister = ({
  TencentCloudChatComponentsEnum componentEnum,
  TencentCloudChatWidgetBuilder widgetBuilder,
})
    Function();

/// This class represents the configuration for Tencent Cloud Chat.
class TencentCloudChatConfig {
  /// The brightness mode of the application (light or dark).
  final Brightness? brightness;

  /// The theme config.
  final TencentCloudChatThemeModel? themeConfig;

  @Deprecated(
      'Please use `usedComponentsRegister` from the `components` field within `TencentCloudChatInitComponentsRelated` when calling `initUIKit` instead.')
  final List<TencentCloudChatModularUIPackageRegister>? usedComponentsRegister;

  /// User related configuration
  final TencentCloudChatUserConfig? userConfig;

  /// Constructor for TencentCloudChatConfig.
  ///
  /// [themeConfig]: The theme configuration for the app.
  /// [brightness]: The brightness mode of the app (light or dark).
  /// [preloadDataConfig]: The configuration for preloading data in the app.
  /// [messageConfig]: The configuration for the TencentCloudChatMessage component.
  const TencentCloudChatConfig({
    @Deprecated(
        'Please use `usedComponentsRegister` from the `components` field within `TencentCloudChatInitComponentsRelated` when calling `initUIKit` instead.')
    this.usedComponentsRegister,
    this.brightness,
    this.themeConfig,
    this.userConfig,
  });
}

class TencentCloudChatInitComponentsRelated {
  /// List of registration functions for the components used in the Chat UIKit.
  ///
  /// Each modular UI package component used in the Chat UIKit must have its registration method included here.
  /// Add the registration methods of the components you are using.
  ///
  /// Depending on the components you're using in your application, include the corresponding register methods in the list.
  /// Example usage:
  /// ```dart
  /// usedComponentsRegister: [
  ///   TencentCloudChatConversationManager.register,  // Conversation component
  ///   TencentCloudChatMessageManager.register,       // Message component
  ///   TencentCloudChatUserProfileManager.register,   // UserProfile component
  ///   TencentCloudChatGroupProfileManager.register,  // GroupProfile component
  ///   TencentCloudChatContactManager.register,       // Contact component
  /// ]
  /// ```
  final List<TencentCloudChatModularUIPackageRegister> usedComponentsRegister;

  /// The configuration for each modular UI component, affecting globally.
  final TencentCloudChatComponentConfigs? componentConfigs;

  /// The builder for further customizing the UI for each modular UI component, affecting globally.
  final TencentCloudChatComponentBuilders? componentBuilders;

  /// The event handlers for events related to UI components for each modular UI component, affecting globally.
  final TencentCloudChatComponentEventHandlers? componentEventHandlers;

  /// Constructs a new instance of TencentCloudChatInitComponentsRelated with the related configurations for components when calling `initUIKit`.
  ///
  /// [usedComponentsRegister]: The list of register functions of the components used in the Chat UIKit.
  /// [componentConfigs]: The configuration for each modular UI component, affecting globally.
  /// [componentBuilders]: The builder for further customizing the UI for each modular UI component, affecting globally.
  const TencentCloudChatInitComponentsRelated({
    required this.usedComponentsRegister,
    this.componentConfigs,
    this.componentBuilders,
    this.componentEventHandlers,
  });
}

/// This class represents the initial options for Tencent Cloud Chat.
class TencentCloudChatInitOptions {
  /// The user ID for the Chat SDK.
  final String userID;

  /// The user signature for the Chat SDK.
  final String userSig;

  /// The Chat SDKAppID.
  final int sdkAppID;

  @Deprecated(
      'Please use `onTencentCloudChatSDKEvent` from the `callbacks` field within `TencentCloudChatCallbacks` when calling `initUIKit` instead.')
  final V2TimSDKListener? sdkListener;

  /// Constructor for TencentCloudChatInitOptions.
  ///
  /// [sdkAppID]: The Chat SDKAppID.
  /// [userID]: The user ID for the Chat SDK.
  /// [userSig]: The user signature for the Chat SDK.
  const TencentCloudChatInitOptions({
    required this.sdkAppID,
    required this.userID,
    required this.userSig,
    @Deprecated(
        'Please use `onTencentCloudChatSDKEvent` from the `callbacks` field within `TencentCloudChatCallbacks` when calling `initUIKit` instead.')
    this.sdkListener,
  });
}

class TencentCloudChatPluginItem {
  final TencentCloudChatPlugin pluginInstance;
  final String name;
  final Map<String, dynamic>? initData;
  final TencentCloudChatPluginTapFn? tapFn;

  const TencentCloudChatPluginItem({
    required this.name,
    required this.pluginInstance,
    this.initData,
    this.tapFn,
  });
}

/// A class containing global configuration options for each modular UI component.
class TencentCloudChatComponentConfigs {
  /// The configuration for the TencentCloudChatMessage component.
  final TencentCloudChatMessageConfig? messageConfig;

  /// The configuration for the TencentCloudChatConversation component.
  final TencentCloudChatConversationConfig? conversationConfig;

  /// The configuration for the TencentCloudChatContact component.
  final TencentCloudChatContactConfig? contactConfig;

  /// The configuration for the TencentCloudChatUserProfile component.
  final TencentCloudChatUserProfileConfig? userProfileConfig;

  /// The configuration for the TencentCloudChatGroupProfile component.
  final TencentCloudChatGroupProfileConfig? groupProfileConfig;

  /// Constructs a new instance of TencentCloudChatComponentConfigs with the specified configurations for each component.
  const TencentCloudChatComponentConfigs({
    this.messageConfig,
    this.conversationConfig,
    this.contactConfig,
    this.userProfileConfig,
    this.groupProfileConfig,
  });
}

/// A class containing custom UI builders for further customizing each modular UI component on a global scale.
class TencentCloudChatComponentBuilders {
  /// Specify an instance of `TencentCloudChatConversationBuilders` for customizing the conversation component.
  final TencentCloudChatComponentBuilder? conversationBuilder;

  /// Specify an instance of `TencentCloudChatMessageBuilders` for customizing the message component.
  final TencentCloudChatComponentBuilder? messageBuilder;

  /// Specify an instance of `TencentCloudChatContactBuilders` for customizing the contact component.
  final TencentCloudChatComponentBuilder? contactBuilder;

  /// Specify an instance of `TencentCloudChatUserProfileBuilders` for customizing the user profile component.
  final TencentCloudChatComponentBuilder? userProfileBuilder;

  /// Specify an instance of `TencentCloudChatGroupProfileBuilders` for customizing the group profile component.
  final TencentCloudChatComponentBuilder? groupProfileBuilder;

  /// Constructs a new instance of TencentCloudChatComponentBuilders with the specified custom builders for each component.
  const TencentCloudChatComponentBuilders({
    this.conversationBuilder,
    this.messageBuilder,
    this.contactBuilder,
    this.userProfileBuilder,
    this.groupProfileBuilder,
  });
}

/// The event handlers for events related to UI components for each modular UI component, affecting globally.
class TencentCloudChatComponentEventHandlers {
  final TencentCloudChatConversationEventHandlers? conversationEventHandlers;
  final TencentCloudChatMessageEventHandlers? messageEventHandlers;
  final TencentCloudChatContactEventHandlers? contactEventHandlers;
  final TencentCloudChatUserProfileEventHandlers? userProfileEventHandlers;
  final TencentCloudChatGroupProfileEventHandlers? groupProfileEventHandlers;

  /// Constructs a new instance of TencentCloudChatComponentEventHandlers with the specified event handlers for each component.
  const TencentCloudChatComponentEventHandlers({
    this.conversationEventHandlers,
    this.messageEventHandlers,
    this.contactEventHandlers,
    this.userProfileEventHandlers,
    this.groupProfileEventHandlers,
  });
}

/// The controllers for events related to UI components for each modular UI component, can be used for all corresponding instance.
class TencentCloudChatComponentControllers {
  /// Specify an instance of `TencentCloudChatConversationController` for taking over control for all `TencentCloudChatConversation` instances.
  final TencentCloudChatComponentBaseController? conversationController;

  /// Specify an instance of `TencentCloudChatMessageController` for taking over control for all `TencentCloudChatMessage` instances.
  final TencentCloudChatComponentBaseController? messageController;

  /// Specify an instance of `TencentCloudChatContactController` for taking over control for all `TencentCloudChatContact` instances.
  final TencentCloudChatComponentBaseController? contactController;

  /// Specify an instance of `TencentCloudChatUserProfileController` for taking over control for all `TencentCloudChatUserProfile` instances.
  final TencentCloudChatComponentBaseController? userProfileController;

  /// Specify an instance of `TencentCloudChatGroupProfileController` for taking over control for all `TencentCloudChatGroupProfile` instances.
  final TencentCloudChatComponentBaseController? groupProfileController;

  /// Constructs a new instance of TencentCloudChatComponentControllers with the specified controllers for each component.
  const TencentCloudChatComponentControllers({
    this.conversationController,
    this.messageController,
    this.contactController,
    this.userProfileController,
    this.groupProfileController,
  });
}

class TTabItem {
  final String id;
  final String name;
  final IconData icon;
  final Function()? onTap;
  final int? unreadCount;

  TTabItem({
    required this.id,
    required this.name,
    required this.icon,
    this.onTap,
    this.unreadCount,
  });
}

class ContactApplicationResult {
  String result;
  String userID;

  ContactApplicationResult({
    required this.result,
    required this.userID,
  });
}

enum TencentCloudChatForwardType { individually, combined }
