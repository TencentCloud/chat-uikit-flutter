import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/controller/tencent_cloud_chat_controller_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/tencent_cloud_chat_theme.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_callbacks.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';

class TencentCloudChatCoreControllerGenerator {
  static TencentCloudChatCoreController getInstance() {
    return TencentCloudChatCoreController._();
  }
}

class TencentCloudChatCoreController {
  TencentCloudChatCoreController._();

  static bool hasInitialized = false;

  static TencentCloudChatCallbacks? _currentCallbackMountOnInit;

  /// Initializes the Tencent Cloud Chat with the given configuration.
  ///
  /// This method sets up the Tencent Cloud Chat environment, including screen adaptation,
  /// internationalization, theme configuration, component registration, and SDK initialization.
  /// It also logs in to the Tencent Cloud Chat server with the provided user ID and signature.
  ///
  /// [config]: The general configuration for Tencent Cloud Chat.
  /// [options]: The initial options for Tencent Cloud Chat, including user ID, user signature, and SDKAppID.
  /// [callbacks]: The callbacks module used for managing SDK events, SDK API errors and specific UIKit events that demand user attention.
  /// [components]: The modular UI components related settings, taking effects on a global scale.
  /// [plugins]: The list of the used plugins, such as tencent_cloud_chat_robot, etc. For specific usage, please refer to the README of each plugin.
  Future<bool> initUIKit({
    @Deprecated("Passing in `context` is no longer required and will be removed in a future version")
    BuildContext? context,
    required TencentCloudChatInitOptions options,
    required TencentCloudChatInitComponentsRelated components,
    TencentCloudChatConfig? config,
    TencentCloudChatCallbacks? callbacks,
    List<TencentCloudChatPluginItem>? plugins,
  }) async {
    if (!hasInitialized) {
      hasInitialized = true;
      _currentCallbackMountOnInit = callbacks;
      TencentCloudChatControllerUtils.addCallback(_currentCallbackMountOnInit);

      // Initialize theme
      TencentCloudChatTheme.init(themeModel: config?.themeConfig, brightness: config?.brightness);

      if (config?.userConfig != null) {
        TencentCloudChat.instance.dataInstance.basic.updateUseUserOnlineStatus(config!.userConfig!);
      }

      if (TencentCloudChatPlatformAdapter().isWeb) {
        await TencentImSDKPlugin.v2TIMManager.initSDK(
            sdkAppID: options.sdkAppID,
            loglevel: LogLevelEnum.V2TIM_LOG_INFO,
            listener: TencentCloudChat.instance.callbacks.defaultV2TimSDKListener ??
                options.sdkListener ??
                V2TimSDKListener());

        TencentCloudChatControllerUtils.initComponents(components);

        V2TimCallback res =
            await TencentImSDKPlugin.v2TIMManager.login(userID: options.userID, userSig: options.userSig);
        if (res.code == 0) {
          TencentCloudChatControllerUtils.clearData();
          TencentCloudChat.instance.dataInstance.basic.updateLoginStatus(status: true);
          TencentCloudChatControllerUtils.cacheEnvData(options.userID);
          TencentCloudChatControllerUtils.initCallService();
          TencentCloudChatControllerUtils.initPreloadData();
          TencentCloudChatControllerUtils.initPlugins(plugins);
          return true;
        }
        return false;
      } else {
        final completer = Completer<bool>();
        TencentCloudChatControllerUtils.initComponents(components);
        await TUILogin.instance.login(
          options.sdkAppID,
          options.userID,
          options.userSig,
          TUICallback(
            onSuccess: () async {
              TencentCloudChatControllerUtils.clearData();
              TencentCloudChat.instance.dataInstance.basic.updateLoginStatus(status: true);
              TencentCloudChatControllerUtils.cacheEnvData(options.userID);
              TencentCloudChatControllerUtils.initCallService();
              TencentCloudChatControllerUtils.initPreloadData();
              TencentCloudChatControllerUtils.initPlugins(plugins);
              completer.complete(true);
              return;
            },
            onError: (int code, String message) {
              completer.complete(false);
              return;
            },
          ),
          TencentCloudChat.instance.callbacks.defaultV2TimSDKListener ?? options.sdkListener,
        );

        TencentCloudChat.instance.logInstance.console(
          componentName: "TencentCloudChatCoreController",
          logs:
              "The uikit components currently used are ${TencentCloudChat.instance.dataInstance.basic.usedComponents}",
        );
        return completer.future;
      }
    } else {
      return false;
    }
  }

  /// This method is recommended for resetting the UIKit instead of using `logout`.
  /// It is suitable for situations like user logout, account switching,
  /// or any other scenarios that require clearing the data in the UIKit.
  /// If you need to actively logout from Chat, set `shouldLogout` to `true`.
  /// If it's a passive scenario, for instance, if the current user has been kicked offline,
  /// set `shouldLogout` to `false`. This will only clear the data within UIKit without executing the logout method again.
  Future<bool> resetUIKit({
    bool shouldLogout = false,
    bool shouldUnInitSDK = true,
  }) async {
    bool logoutSuccess = !shouldLogout;
    if (shouldLogout) {
      final completer = Completer<bool>();
      await TUILogin.instance.logout(TUICallback(
        onSuccess: () async {
          TencentCloudChatControllerUtils.clearData();
          removeGlobalCallback(callbacks: _currentCallbackMountOnInit);
          logoutSuccess = true;
          hasInitialized = false;
          completer.complete(logoutSuccess);
        },
        onError: (int code, String message) {
          logoutSuccess = false;
          completer.complete(logoutSuccess);
        },
      ));
      return completer.future;
    } else {
      if (shouldUnInitSDK) {
        TencentImSDKPlugin.v2TIMManager.unInitSDK();
      }
      TencentCloudChatControllerUtils.clearData();
      removeGlobalCallback(callbacks: _currentCallbackMountOnInit);
      hasInitialized = false;
      TUICore.instance.notifyEvent(logoutSuccessEvent);
    }
    return logoutSuccess;
  }

  /// Log out the current user from the Tencent Cloud Chat service.
  /// If the logout is unsuccessful, the UIKit will not be reset.
  Future<bool> logout() async {
    await TUILogin.instance.logout(TUICallback(
      onSuccess: () async {
        resetUIKit();
        return;
      },
      onError: (int code, String message) {
        return;
      },
    ));
    return true;
  }

  /// Toggles the brightness mode between light and dark.
  void toggleBrightnessMode({Brightness? brightness}) {
    TencentCloudChat.instance.dataInstance.theme.toggleBrightnessMode(brightness: brightness);
  }

  /// Returns a ThemeData instance based on the current brightness and configuration.
  ThemeData getThemeData({
    required BuildContext context,
    Brightness? brightness,
    bool needTextTheme = true,
    bool needColorScheme = true,
  }) {
    return TencentCloudChat.instance.dataInstance.theme.getThemeData(
        context: context, brightness: brightness, needColorScheme: needColorScheme, needTextTheme: needTextTheme);
  }

  /// Sets the theme colors for the specified brightness.
  void setThemeColors({
    required Brightness brightness,
    required TencentCloudChatThemeColors themeColors,
  }) {
    TencentCloudChat.instance.dataInstance.theme.setThemeColors(brightness: brightness, themeColors: themeColors);
  }

  /// Sets the brightness mode
  setBrightnessMode(Brightness value) {
    TencentCloudChat.instance.dataInstance.theme.brightness = value;
  }

  /// Get the current conversation total unread count
  hasConversationUnreadCount() {
    return TencentCloudChat.instance.dataInstance.conversation.totalUnreadCount > 0;
  }

  void initGlobalAdapterInBuildPhase(BuildContext context) {
    // Initialize screen adapter
    TencentCloudChatScreenAdapter.init(context);

    // Initialize internationalization
    TencentCloudChatIntl().init(context);
  }

  void addGlobalCallback({required TencentCloudChatCallbacks callbacks}) {
    TencentCloudChatControllerUtils.addCallback(callbacks);
  }

  void removeGlobalCallback({TencentCloudChatCallbacks? callbacks}) {
    TencentCloudChatControllerUtils.removeCallback(callbacks);
  }
}
