// ignore_for_file: avoid_print

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_setting_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/common_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/listener_model/tui_group_listener_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/web_support/uikit_web_support.dart'
if (dart.library.html) 'package:tencent_cloud_chat_uikit/data_services/core/web_support/uikit_web_support_implement.dart';

typedef EmptyAvatarBuilder = Widget Function(BuildContext context);

class LoginInfo {
  final String userID;
  final String userSig;
  final int sdkAppID;
  final V2TimUserFullInfo? loginUser;

  LoginInfo(
      {this.sdkAppID = 0, this.userSig = "", this.userID = "", this.loginUser});
}

class CoreServicesImpl implements CoreServices {
  V2TimUserFullInfo? _loginInfo;
  late int _sdkAppID;
  late String _userID;
  late String _userSig;
  ValueChanged<TIMCallback>? onCallback;
  VoidCallback? webLoginSuccess;
  bool isLoginSuccess = false;

  V2TimUserFullInfo? get loginUserInfo {
    return _loginInfo;
  }

  LoginInfo get loginInfo {
    return LoginInfo(
        sdkAppID: _sdkAppID,
        userID: _userID,
        userSig: _userSig,
        loginUser: _loginInfo);
  }

  EmptyAvatarBuilder? _emptyAvatarBuilder;

  EmptyAvatarBuilder? get emptyAvatarBuilder {
    return _emptyAvatarBuilder;
  }

  setEmptyAvatarBuilder(EmptyAvatarBuilder builder) {
    _emptyAvatarBuilder = builder;
  }

  setGlobalConfig(TIMUIKitConfig? config) {
    final TUISelfInfoViewModel selfInfoViewModel =
    serviceLocator<TUISelfInfoViewModel>();
    final TUISettingModel settingModel = serviceLocator<TUISettingModel>();
    selfInfoViewModel.globalConfig = config;
    settingModel.init();
  }

  addIdentifier() {
    TUIKitWebSupport.addSetterToWindow();
    TUIKitWebSupport.addIdentifierToWindow();
  }

  @override
  Future<bool?> init({
    /// Callback from TUIKit invoke, includes IM SDK API error, notify information, Flutter error.
    ValueChanged<TIMCallback>? onTUIKitCallbackListener,
    required int sdkAppID,
    required LogLevelEnum loglevel,
    required V2TimSDKListener listener,
    LanguageEnum? language,
    String? extraLanguage,
    TIMUIKitConfig? config,

    /// Specify the current device platform, mobile or desktop, based on your needs.
    /// TUIKit will automatically determine the platform if no specification is provided. DeviceType? platform,
    DeviceType? platform,
    VoidCallback? onWebLoginSuccess}) async {
    if (platform != null) {
      TUIKitScreenUtils.deviceType = platform;
    }
    addIdentifier();
    if (extraLanguage != null) {
      Future.delayed(const Duration(milliseconds: 1), () {
        I18nUtils(null, extraLanguage);
      });
    } else if (language != null) {
      Future.delayed(const Duration(milliseconds: 1), () {
        I18nUtils(null, languageEnumToString[language]);
      });
    }
    if (onTUIKitCallbackListener != null) {
      onCallback = onTUIKitCallbackListener;
    }
    setGlobalConfig(config);
    _sdkAppID = sdkAppID;
    webLoginSuccess = onWebLoginSuccess;
    final result = await TencentImSDKPlugin.v2TIMManager.initSDK(
        sdkAppID: sdkAppID,
        loglevel: loglevel,
        listener: V2TimSDKListener(
            onConnectFailed: listener.onConnectFailed,
            onConnectSuccess: () {
              if (PlatformUtils().isWeb) {
                didLoginSuccess();
                if (onWebLoginSuccess != null) {
                  onWebLoginSuccess();
                }
              }
              listener.onConnectSuccess();
            },
            onConnecting: listener.onConnecting,
            onKickedOffline: listener.onKickedOffline,
            onUserStatusChanged: (List<V2TimUserStatus> userStatusList) {
              updateUserStatusList(userStatusList);
            },
            onSelfInfoUpdated: (V2TimUserFullInfo info) {
              listener.onSelfInfoUpdated(info);
              serviceLocator<TUISelfInfoViewModel>().setLoginInfo(info);
              _loginInfo = info;
            },
            onUserSigExpired: listener.onUserSigExpired));
    return result.data;
  }

  /// This method is used for init the TUIKit after you initialized the IM SDK from Native SDK.
  @override
  Future<void> setDataFromNative({
    /// Callback from TUIKit invoke, includes IM SDK API error, notify information, Flutter error.
    ValueChanged<TIMCallback>? onTUIKitCallbackListener,
    LanguageEnum? language,
    TIMUIKitConfig? config,
    String? extraLanguage,
    required String userId,
  }) async {
    _userID = userId;
    if (extraLanguage != null) {
      Future.delayed(const Duration(milliseconds: 1), () {
        I18nUtils(null, extraLanguage);
      });
    } else if (language != null) {
      Future.delayed(const Duration(milliseconds: 1), () {
        I18nUtils(null, languageEnumToString[language]);
      });
    }
    if (onTUIKitCallbackListener != null) {
      onCallback = onTUIKitCallbackListener;
    }
    setGlobalConfig(config);
    if (!PlatformUtils().isWeb) {
      didLoginSuccess();
    }
  }

  void addInitListener() {
    final TUIFriendShipViewModel tuiFriendShipViewModel =
    serviceLocator<TUIFriendShipViewModel>();
    final TUIConversationViewModel tuiConversationViewModel =
    serviceLocator<TUIConversationViewModel>();
    final TUIChatGlobalModel tuiChatViewModel =
    serviceLocator<TUIChatGlobalModel>();
    final TUIGroupListenerModel tuiGroupListenerModel =
    serviceLocator<TUIGroupListenerModel>();

    tuiFriendShipViewModel.addFriendListener();
    tuiConversationViewModel.setConversationListener();
    tuiChatViewModel.addAdvancedMsgListener();
    tuiGroupListenerModel.setGroupListener();
  }

  void removeListener() {
    final TUIFriendShipViewModel tuiFriendShipViewModel =
    serviceLocator<TUIFriendShipViewModel>();
    final TUIConversationViewModel tuiConversationViewModel =
    serviceLocator<TUIConversationViewModel>();
    final TUIChatGlobalModel tuiChatViewModel =
    serviceLocator<TUIChatGlobalModel>();
    final TUIGroupListenerModel tuiGroupListenerModel =
    serviceLocator<TUIGroupListenerModel>();

    tuiFriendShipViewModel.removeFriendshipListener();
    tuiConversationViewModel.removeConversationListener();
    tuiChatViewModel.removeAdvanceMsgListener();
    tuiGroupListenerModel.removeGroupListener();
  }

  callOnCallback(TIMCallback callbackValue) {
    if (onCallback != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        onCallback!(callbackValue);
      });
    } else {
      print(
          "TUIKit Callback: ${callbackValue.type} - ${callbackValue
              .stackTrace}");
    }
  }

  initDataModel() {
    final TUIFriendShipViewModel tuiFriendShipViewModel =
    serviceLocator<TUIFriendShipViewModel>();
    final TUIConversationViewModel tuiConversationViewModel =
    serviceLocator<TUIConversationViewModel>();

    tuiFriendShipViewModel.initFriendShipModel();
    tuiConversationViewModel.initConversation();
  }

  clearData() {
    final TUIFriendShipViewModel tuiFriendShipViewModel =
    serviceLocator<TUIFriendShipViewModel>();
    final TUIConversationViewModel tuiConversationViewModel =
    serviceLocator<TUIConversationViewModel>();
    final TUIChatGlobalModel tuiChatViewModel =
    serviceLocator<TUIChatGlobalModel>();

    tuiFriendShipViewModel.clearData();
    tuiConversationViewModel.clearData();
    tuiChatViewModel.clearData();
  }

  updateUserStatusList(List<V2TimUserStatus> newUserStatusList) {
    try {
      final TUISelfInfoViewModel selfInfoViewModel =
      serviceLocator<TUISelfInfoViewModel>();
      if (selfInfoViewModel.globalConfig?.isShowOnlineStatus == false) {
        return;
      }

      final TUIFriendShipViewModel tuiFriendShipViewModel =
      serviceLocator<TUIFriendShipViewModel>();
      final currentUserStatusList = tuiFriendShipViewModel.userStatusList;

      for (int i = 0; i < newUserStatusList.length; i++) {
        final int indexInCurrentUserList = currentUserStatusList.indexWhere(
                (element) => element.userID == newUserStatusList[i].userID);
        if (indexInCurrentUserList == -1) {
          currentUserStatusList.add(newUserStatusList[i]);
        } else {
          currentUserStatusList[indexInCurrentUserList] = newUserStatusList[i];
        }
      }

      tuiFriendShipViewModel.userStatusList = currentUserStatusList;
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Future<V2TimCallback> login({
    required String userID,
    required String userSig,
  }) async {
    _userID = userID;
    _userSig = userSig;
    V2TimCallback result = await TencentImSDKPlugin.v2TIMManager
        .login(userID: userID, userSig: userSig);
    if (!PlatformUtils().isWeb) {
      didLoginSuccess();
    }
    if (result.code != 0) {
      callOnCallback(TIMCallback(
          type: TIMCallbackType.API_ERROR,
          errorCode: result.code,
          errorMsg: result.desc));
    }
    return result;
  }

  void didLoginSuccess() async {
    if (isLoginSuccess == true) {
      return;
    }
    isLoginSuccess = true;
    addInitListener();
    initDataModel();

    if (TencentUtils.checkString(_userID) == null) {
      V2TimValueCallback<String> getLoginUserRes =
      await TencentImSDKPlugin.v2TIMManager.getLoginUser();
      if (getLoginUserRes.code == 0) {
        _userID = getLoginUserRes.data ?? "";
      }
    }

    getUsersInfoWithRetry();
  }

  void getUsersInfoWithRetry() async {
    V2TimValueCallback<List<V2TimUserFullInfo>>? res;
    bool success = false;

    while (!success) {
      res = await getUsersInfo(userIDList: [_userID]);
      if (res.code == 0 &&
          res.data != null &&
          res.data!.isNotEmpty &&
          res.data!.firstWhereOrNull((element) => element.userID == _userID) !=
              null) {
        success = true;
      } else {
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    _loginInfo =
        res?.data!.firstWhereOrNull((element) => element.userID == _userID);
    final TUISelfInfoViewModel selfInfoViewModel =
    serviceLocator<TUISelfInfoViewModel>();
    if (_loginInfo != null) {
      selfInfoViewModel.setLoginInfo(_loginInfo);
    }
  }

  // Deprecated
  void didLoginOut() {
    removeListener();
    clearData();
    _loginInfo = null;
    serviceLocator<TUISelfInfoViewModel>().setLoginInfo(_loginInfo);
  }

  @override
  Future<V2TimCallback> logout() async {
    final result = await TencentImSDKPlugin.v2TIMManager.logout();
    isLoginSuccess = false;
    removeListener();
    clearData();
    serviceLocator<TUISelfInfoViewModel>().setLoginInfo(null);
    return result;
  }

  @override
  Future<V2TimCallback> logoutWithoutClearData() async {
    final result = await TencentImSDKPlugin.v2TIMManager.logout();
    isLoginSuccess = false;
    removeListener();
    serviceLocator<TUISelfInfoViewModel>().setLoginInfo(null);
    return result;
  }

  @override
  Future unInit() async {
    final result = await TencentImSDKPlugin.v2TIMManager.unInitSDK();
    return result;
  }

  @override
  Future<V2TimValueCallback<List<V2TimUserFullInfo>>> getUsersInfo({
    required List<String> userIDList,
  }) {
    return TencentImSDKPlugin.v2TIMManager.getUsersInfo(userIDList: userIDList);
  }

  @override
  Future<V2TimCallback> setOfflinePushConfig({
    required String token,
    bool isTPNSToken = false,
    int? businessID,
  }) {
    return TencentImSDKPlugin.v2TIMManager
        .getOfflinePushManager()
        .setOfflinePushConfig(
      businessID: businessID?.toDouble() ?? 0,
      token: token,
      isTPNSToken: isTPNSToken,
    );
  }

  @override
  Future<V2TimCallback> setSelfInfo({
    required V2TimUserFullInfo userFullInfo,
  }) {
    return TencentImSDKPlugin.v2TIMManager
        .setSelfInfo(userFullInfo: userFullInfo);
  }

  @override
  setTheme({required TUITheme theme}) {
    // 合并传入Theme和默认Theme
    final TUIThemeViewModel _theme = serviceLocator<TUIThemeViewModel>();
    Map<String, Color?> jsonMap = Map.from(CommonColor.defaultTheme.toJson());
    Map<String, Color?> jsonInputThemeMap = Map.from(theme.toJson());

    jsonInputThemeMap.forEach((key, value) {
      if (value != null) {
        jsonMap.update(key, (v) => value);
      }
    });
    _theme.theme = TUITheme.fromJson(jsonMap);
  }

  @override
  setDarkTheme() {
    final TUIThemeViewModel _theme = serviceLocator<TUIThemeViewModel>();
    _theme.theme = TUITheme.dark; //Dark
  }

  @override
  setLightTheme() {
    final TUIThemeViewModel _theme = serviceLocator<TUIThemeViewModel>();
    _theme.theme = TUITheme.light; //Light
  }

  @override
  Future<V2TimCallback> setOfflinePushStatus(
      {required AppStatus status, int? totalCount}) {
    if (status == AppStatus.foreground) {
      return TencentImSDKPlugin.v2TIMManager
          .getOfflinePushManager()
          .doForeground();
    } else {
      return TencentImSDKPlugin.v2TIMManager
          .getOfflinePushManager()
          .doBackground(unreadCount: totalCount ?? 0);
    }
  }

  @override
  setDeviceType(DeviceType deviceType) {
    TUIKitScreenUtils.deviceType = deviceType;
  }
}
