import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_callbacks.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
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

      if (componentConfigs.userProfileConfig != null) {
        TencentCloudChat.instance.dataInstance.userProfile.userProfileConfig = componentConfigs.userProfileConfig!;
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

      if (componentEventHandlers.userProfileEventHandlers != null) {
        TencentCloudChat.instance.dataInstance.userProfile.userProfileEventHandlers = componentEventHandlers.userProfileEventHandlers!;
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
      if (componentControllers.userProfileController != null) {
        TencentCloudChat.instance.dataInstance.userProfile.userProfileController = componentControllers.userProfileController!;
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

      if (componentBuilders.userProfileBuilder != null) {
        TencentCloudChat.instance.dataInstance.userProfile.userProfileBuilder = componentBuilders.userProfileBuilder!;
      }

      if (componentBuilders.groupProfileBuilder != null) {
        TencentCloudChat.instance.dataInstance.groupProfile.groupProfileBuilder = componentBuilders.groupProfileBuilder!;
      }
    }
  }

  static initPreloadData() {
    _initConversationData();
    _initMessageData();
    _initContactData();
  }

  static _initConversationData() async {
    List<V2TimConversation> convList = TencentCloudChat.instance.cache.getConversationListFromCache();
    if (convList.isNotEmpty) {
      TencentCloudChat.instance.dataInstance.conversation.updateIsGetDataEnd(true);
      TencentCloudChat.instance.dataInstance.conversation.conversationList = convList;
      TencentCloudChat.instance.dataInstance.conversation.buildConversationList(convList, "getConversationListFromCache");
    }

    TencentCloudChat.instance.chatSDKInstance.conversationSDK.getConversationList(seq: "0");

    try {
      await TencentCloudChat.instance.chatSDKInstance.conversationSDK.subscribeUnreadMessageCountByFilter();
    } catch (e) {
      debugPrint(e.toString());
    }

    TencentCloudChat.instance.chatSDKInstance.conversationSDK.addConversationListener();
  }

  static _initMessageData() async {
    if (TencentCloudChat.instance.dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.message)) {
      List<String> convKey = TencentCloudChat.instance.cache.getAllConvKey();
      if (convKey.isNotEmpty) {
        for (var i = 0; i < convKey.length; i++) {
          var keyItem = convKey[i];
          var messageList = TencentCloudChat.instance.cache.getMessageListByConvKey(keyItem);
          TencentCloudChat.instance.dataInstance.messageData.updateMessageList(messageList: messageList, userID: keyItem.contains("c2c_") ? keyItem : null, groupID: keyItem.contains("group_") ? keyItem : null);
        }
      }
    }
  }

  static _initContactData() async {
    TencentCloudChat.instance.chatSDKInstance.contactSDK.addFriendListener();

    TencentCloudChat.instance.chatSDKInstance.groupSDK.addGroupListener();

    TencentCloudChat.instance.chatSDKInstance.contactSDK.getFriendList();

    TencentCloudChat.instance.chatSDKInstance.contactSDK.getFriendApplicationList();

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
