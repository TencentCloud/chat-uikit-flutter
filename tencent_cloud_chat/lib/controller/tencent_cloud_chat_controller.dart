import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_contact_sdk.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_conversation_sdk.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_group_sdk.dart';
import 'package:tencent_cloud_chat/chat_sdk/tencent_cloud_chat_sdk.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat/data/theme/tencent_cloud_chat_theme.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_callbacks.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';

class TencentCloudChatCoreController {
  static bool hasInitialized = false;

  /// Initializes the Tencent Cloud Chat with the given configuration.
  ///
  /// This method sets up the Tencent Cloud Chat environment, including screen adaptation,
  /// internationalization, theme configuration, component registration, and SDK initialization.
  /// It also logs in to the Tencent Cloud Chat server with the provided user ID and signature.
  ///
  /// [context]: The BuildContext for the app.
  /// [config]: The general configuration for Tencent Cloud Chat.
  /// [options]: The initial options for Tencent Cloud Chat, including user ID, user signature, and SDKAppID.
  Future<void> initUIKit({
    required BuildContext context,
    required TencentCloudChatConfig config,
    required TencentCloudChatInitOptions options,
    TencentCloudChatCallbacks? callbacks,
    List<TencentCloudChatPluginItem>? plugins,
  }) async {
    final TencentCloudChatCallbacks tencentCloudChatCallbacks = callbacks ?? TencentCloudChatCallbacks();
    tencentCloudChatCallbacks.activateCallbackModule();
    TencentCloudChat().callbacks = tencentCloudChatCallbacks;

    if (!hasInitialized) {
      hasInitialized = true;

      // Initialize theme
      TencentCloudChatTheme.init(
        context: context,
        themeModel: config.themeConfig,
        brightness: config.brightness,
      );

      // Register components to routing table
      for (final func in config.usedComponentsRegister) {
        final ({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) component = func();
        TencentCloudChat().dataInstance.basic.addUsedComponent(component);
      }

      await TencentCloudChat.cache.init(sdkAppID: options.sdkAppID, currentLoginUserId: options.userID);

      List<V2TimConversation> convList = TencentCloudChat.cache.getConversationListFromCache();

      if (convList.isNotEmpty) {
        TencentCloudChat().dataInstance.conversation.updateIsGetDataEnd(true);
        TencentCloudChat().dataInstance.conversation.conversationList = convList;
        TencentCloudChat().dataInstance.conversation.buildConversationList(convList, "getConversationListFromCache");
      }

      List<String> convKey = TencentCloudChat.cache.getAllConvKey();

      if (convKey.isNotEmpty) {
        for (var i = 0; i < convKey.length; i++) {
          var keyItem = convKey[i];
          var messageList = TencentCloudChat.cache.getMessageListByConvKey(keyItem);
          TencentCloudChat().dataInstance.messageData.updateMessageList(messageList: messageList, userID: keyItem.contains("c2c_") ? keyItem : null, groupID: keyItem.contains("group_") ? keyItem : null);
        }
      }

      // Initialize Tencent Cloud Chat SDK
      await TencentCloudChat.chatSDKInstance.initSDK(
        sdkAppID: options.sdkAppID,
        sdkListener: options.sdkListener,
        logLevel: LogLevelEnum.V2TIM_LOG_NONE,
      );

      // Log in to Tencent Cloud Chat Server
      TencentCloudChat.logInstance.console(
        componentName: "TencentCloudChatCoreController",
        logs: "The uikit components currently used are ${TencentCloudChat().dataInstance.basic.usedComponents}",
      );

      // Set the config for each components
      if (config.messageConfig != null) {
        TencentCloudChat().dataInstance.basic.messageConfig = config.messageConfig!;
      }
      if (config.userConfig != null) {
        TencentCloudChat().dataInstance.basic.updateUseUserOnlineStatus(config.userConfig!);
      }

      // Login TencentCloudChat SDK
      final loginRes = await TencentCloudChat.chatSDKInstance.login(userID: options.userID, userSig: options.userSig);

      if (loginRes == true) {
        if (plugins != null) {
          for (var i = 0; i < plugins.length; i++) {
            var plugin = plugins[i];
            await plugin.pluginInstance.init(json.encode(plugin.initData));
            TencentCloudChat().dataInstance.basic.addPlugin(plugin);
          }
        }

        if (TencentCloudChatPlatformAdapter().isMobile) {
          TUICore.instance.getService(TUICALLKIT_SERVICE_NAME).then((value) {
            TencentCloudChat().dataInstance.basic.useCallKit = value;
          });
        }

        final result = await TencentImSDKPlugin.v2TIMManager.getUsersInfo(userIDList: [options.userID]);

        if (result.code == 0 && result.data != null) {
          // TencentCloudChat().dataInstance.basic.currentUser = result.data!.first;
          TencentCloudChat().dataInstance.basic.updateCurrentUserInfo(userFullInfo: result.data!.first);
        }

        V2TimValueCallback<String> versionRes = await TencentImSDKPlugin.v2TIMManager.getVersion();
        if (versionRes.code == 0) {
          TencentCloudChat().dataInstance.basic.updateVersion(version: versionRes.data ?? "");
        }

        TencentCloudChatConversationSDK.getConversationList(seq: "0");

        try {
          await TencentCloudChatConversationSDK.subscribeUnreadMessageCountByFilter();
        } catch (e) {
          debugPrint(e.toString());
        }

        TencentCloudChatConversationSDK.addConversationListener();

        TencentCloudChatContactSDK.addFriendListener();

        TencentCloudChatGroupSDK.addGroupListener();

        TencentCloudChatContactSDK.getFriendList();

        TencentCloudChatContactSDK.getFriendApplicationList();

        TencentCloudChatContactSDK.getBlackList();

        TencentCloudChatContactSDK.getGroupList();
      }
    }
    return;
  }

  /// This method is recommended for resetting the UIKit instead of using `logout`.
  /// It is suitable for situations like user logout, account switching,
  /// or any other scenarios that require clearing the data in the UIKit.
  /// If you need to actively logout from Chat, set `shouldLogout` to `true`.
  /// If it's a passive scenario, for instance, if the current user has been kicked offline,
  /// set `shouldLogout` to `false`. This will only clear the data within UIKit without executing the logout method again.
  Future<bool> resetUIKit({
    bool shouldLogout = false,
  }) async {
    bool logoutSuccess = !shouldLogout;
    if (shouldLogout) {
      try {
        await TencentCloudChatSDK.logout();
        logoutSuccess = true;
      } catch (e) {
        logoutSuccess = false;
      }
    }
    hasInitialized = false;
    TencentCloudChat().reset();
    return logoutSuccess;
  }

  /// Log out the current user from the Tencent Cloud Chat service.
  /// If the logout is unsuccessful, the UIKit will not be reset.
  Future<bool> logout() async {
    final res = await TencentCloudChatSDK.logout();
    if (res) {
      resetUIKit();
    }
    return res;
  }

  /// Toggles the brightness mode between light and dark.
  void toggleBrightnessMode({Brightness? brightness}) {
    TencentCloudChatData.theme.toggleBrightnessMode(brightness: brightness);
  }

  /// Returns a ThemeData instance based on the current brightness and configuration.
  ThemeData getThemeData({
    required BuildContext context,
    Brightness? brightness,
    bool needTextTheme = true,
    bool needColorScheme = true,
  }) {
    return TencentCloudChatData.theme.getThemeData(context: context, brightness: brightness, needColorScheme: needColorScheme, needTextTheme: needTextTheme);
  }

  /// Sets the theme colors for the specified brightness.
  void setThemeColors({
    required Brightness brightness,
    required TencentCloudChatThemeColors themeColors,
  }) {
    TencentCloudChatData.theme.setThemeColors(brightness: brightness, themeColors: themeColors);
  }

  /// Sets the brightness mode
  setBrightnessMode(Brightness value) {
    TencentCloudChatData.theme.brightness = value;
  }

  /// Get the current conversation total unread count
  hasConversationUnreadCount() {
    return TencentCloudChat().dataInstance.conversation.totalUnreadCount > 0;
  }

  void initGlobalAdapterInBuildPhase(BuildContext context) {
    // Initialize screen adapter
    TencentCloudChatScreenAdapter.init(context);

    // Initialize internationalization
    TencentCloudChatIntl().init(context);
  }
}
