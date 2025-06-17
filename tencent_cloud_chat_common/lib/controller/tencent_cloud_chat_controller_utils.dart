import 'dart:convert';

import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_callbacks.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';

class TencentCloudChatControllerUtils {
  static removeCallback(TencentCloudChatCallbacks? callbacks) {
    if(callbacks != null){
      TencentCloudChat.instance.callbacks.removeCallback(callbacks);
    }
  }

  static addCallback(TencentCloudChatCallbacks? callbacks) {
    if(callbacks != null){
      TencentCloudChat.instance.callbacks.addCallback(callbacks);
    }
  }

  static _initUsedComponents(
    TencentCloudChatInitComponentsRelated components,
  ) {
    for (final func in components.usedComponentsRegister) {
      final ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) component = func();
      TencentCloudChat.instance.dataInstance.basic.addUsedComponent(component);
    }
    TencentCloudChat.instance.dataInstance.basic.notifyListener(TencentCloudChatBasicDataKeys.addUsedComponent);
  }

  static initComponents(TencentCloudChatInitComponentsRelated components) {
    // Set the config for each components
    _mountComponentConfigs(components.componentConfigs);

    // Set the event handlers for each components
    _mountEventHandlers(components.componentEventHandlers);

    // // Set the controllers for each components
    // _mountControllers(components.componentControllers);

    // Set the builders for each components
    _mountBuilders(components.componentBuilders);

    // Register components to routing table
    _initUsedComponents(components);
  }

  static _mountComponentConfigs(TencentCloudChatComponentConfigs? componentConfigs) {
    if (componentConfigs != null) {
      if (componentConfigs.messageConfig != null) {
        TencentCloudChat.instance.dataInstance.messageData.messageConfig = componentConfigs.messageConfig!;
      }

      if (componentConfigs.conversationConfig != null) {
        TencentCloudChat.instance.dataInstance.conversation.conversationConfig = componentConfigs.conversationConfig!;
      }

      if (componentConfigs.contactConfig != null) {
        TencentCloudChat.instance.dataInstance.contact.contactConfig = componentConfigs.contactConfig!;
      }

      if (componentConfigs.groupProfileConfig != null) {
        TencentCloudChat.instance.dataInstance.groupProfile.groupProfileConfig = componentConfigs.groupProfileConfig!;
      }
    }
  }

  static _mountEventHandlers(TencentCloudChatComponentEventHandlers? componentEventHandlers) {
    if (componentEventHandlers != null) {
      if (componentEventHandlers.messageEventHandlers != null) {
        TencentCloudChat.instance.dataInstance.messageData.messageEventHandlers = componentEventHandlers.messageEventHandlers!;
      }

      if (componentEventHandlers.conversationEventHandlers != null) {
        TencentCloudChat.instance.dataInstance.conversation.conversationEventHandlers = componentEventHandlers.conversationEventHandlers!;
      }

      if (componentEventHandlers.contactEventHandlers != null) {
        TencentCloudChat.instance.dataInstance.contact.contactEventHandlers = componentEventHandlers.contactEventHandlers!;
      }

      if (componentEventHandlers.groupProfileEventHandlers != null) {
        TencentCloudChat.instance.dataInstance.groupProfile.groupProfileEventHandlers = componentEventHandlers.groupProfileEventHandlers!;
      }
    }
  }

  static _mountControllers(TencentCloudChatComponentControllers? componentControllers) {
    if (componentControllers != null) {
      if (componentControllers.messageController != null) {
        TencentCloudChat.instance.dataInstance.messageData.messageController = componentControllers.messageController!;
      }
      if (componentControllers.conversationController != null) {
        TencentCloudChat.instance.dataInstance.conversation.conversationController = componentControllers.conversationController!;
      }
      if (componentControllers.contactController != null) {
        TencentCloudChat.instance.dataInstance.contact.contactController = componentControllers.contactController!;
      }
      if (componentControllers.groupProfileController != null) {
        TencentCloudChat.instance.dataInstance.groupProfile.groupProfileController = componentControllers.groupProfileController!;
      }
    }
  }

  static _mountBuilders(TencentCloudChatComponentBuilders? componentBuilders) {
    if (componentBuilders != null) {
      if (componentBuilders.conversationBuilder != null) {
        TencentCloudChat.instance.dataInstance.conversation.conversationBuilder = componentBuilders.conversationBuilder!;
      }

      if (componentBuilders.messageBuilder != null) {
        TencentCloudChat.instance.dataInstance.messageData.messageBuilder = componentBuilders.messageBuilder!;
      }

      if (componentBuilders.contactBuilder != null) {
        TencentCloudChat.instance.dataInstance.contact.contactBuilder = componentBuilders.contactBuilder!;
      }

      if (componentBuilders.groupProfileBuilder != null) {
        TencentCloudChat.instance.dataInstance.groupProfile.groupProfileBuilder = componentBuilders.groupProfileBuilder!;
      }
    }
  }

  static clearData() {
    TencentCloudChat.instance.dataInstance.basic.clear();
    TencentCloudChat.instance.dataInstance.contact.clear();
    TencentCloudChat.instance.dataInstance.conversation.clear();
    TencentCloudChat.instance.dataInstance.groupProfile.clear();
    TencentCloudChat.instance.dataInstance.messageData.clear();
    TencentCloudChat.instance.dataInstance.search.clear();
  }

  static initPreloadData() {
    _initListener();
    _initContactData();
  }

  static _initListener() {
    TencentCloudChat.instance.chatSDKInstance.contactSDK.initFriendListener();
    TencentCloudChat.instance.chatSDKInstance.groupSDK.initGroupListener();
  }

  static _initContactData() async {
    TencentCloudChat.instance.chatSDKInstance.contactSDK.getFriendList();

    TencentCloudChat.instance.chatSDKInstance.contactSDK.getFriendApplicationList();

    TencentCloudChat.instance.chatSDKInstance.contactSDK.getGroupApplicationList();

    TencentCloudChat.instance.chatSDKInstance.contactSDK.getBlockList();

    TencentCloudChat.instance.chatSDKInstance.contactSDK.getGroupList();
  }

  static initPlugins(List<TencentCloudChatPluginItem>? plugins) async {
    if (plugins != null) {
      for (var i = 0; i < plugins.length; i++) {
        var plugin = plugins[i];
        await plugin.pluginInstance.init(json.encode(plugin.initData ?? {}));
        TencentCloudChat.instance.dataInstance.basic.addPlugin(plugin);
      }
    }
  }

  static initCallService() {
    if (TencentCloudChatPlatformAdapter().isMobile) {
      TUICore.instance.getService(TUICALLKIT_SERVICE_NAME).then((value) {
        TencentCloudChat.instance.dataInstance.basic.useCallKit = value;
      });
    }
  }

  static cacheEnvData(String userID) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getUsersInfo(userIDList: [userID]);
    if (result.code == 0 && result.data != null) {
      TencentCloudChat.instance.dataInstance.basic.updateCurrentUserInfo(userFullInfo: result.data!.first);
    }

    V2TimValueCallback<String> versionRes = await TencentImSDKPlugin.v2TIMManager.getVersion();
    if (versionRes.code == 0) {
      TencentCloudChat.instance.dataInstance.basic.updateVersion(version: versionRes.data ?? "");
    }
  }
}
