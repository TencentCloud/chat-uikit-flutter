import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_user_config.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

/// An enumeration of basic data keys for TencentCloudChat Core.
enum TencentCloudChatBasicDataKeys {
  none,
  hasInitialized,
  usedComponents,
  hasLoggedIn,
  selfInfo,
  addUsedComponent,
}

/// A class that manages the basic data for TencentCloudChat Core.
///
/// This class extends [TencentCloudChatUIKitCoreDataAB] and provides
/// functionality for managing the initialization status of the UIKit Core.
class TencentCloudChatBasicData<T> extends TencentCloudChatDataAB<T> with WidgetsBindingObserver {
  TencentCloudChatBasicData(super.currentUpdatedFields);

  @override
  void clear() {
    _hasLoggedIn = false;
    _currentUser = null;
  }

  /// === AppLifecycleState ===
  AppLifecycleState appLifecycleState = AppLifecycleState.resumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleState = state;
  }

  /// ==== useCallKit ====
  bool _useCallKit = false;

  // ignore: unnecessary_getters_setters
  bool get useCallKit => _useCallKit;

  set useCallKit(bool value) {
    _useCallKit = value;
  }

  double? get keyboardHeight {
    return TencentCloudChat.instance.cache.getCurrentDeviceKeyBordHeight();
  }

  set keyboardHeight(double? value) {
    if (value != null) {
      TencentCloudChat.instance.cache.cacheCurrentDeviceKeyBordHeight(value);
    }
  }

  /// ==== hasInitialized ====

  bool _hasInitialized = false;

  bool _hasLoggedIn = false;

  int _sdkappid = 0;

  List<TencentCloudChatPluginItem> plugins = [];

  int get sdkappid => _sdkappid;

  bool get hasLoggedIn => _hasLoggedIn;

  bool get hasInitialized => _hasInitialized;

  final TencentCloudChatUserConfig _userConfig = TencentCloudChatUserConfig(
    useUserOnlineStatus: true,
    autoDownloadMultimediaMessage: false,
  );

  /// ==== userConfig ====

  TencentCloudChatUserConfig get userConfig => _userConfig;

  addPlugin(TencentCloudChatPluginItem plugin) {
    plugins.add(plugin);
  }

  hasPlugins(String name) {
    return plugins.indexWhere((element) => element.name == name) > -1;
  }

  TencentCloudChatPluginItem? getPlugin(String name) {
    if (hasPlugins(name)) {
      int idx = plugins.indexWhere((element) => element.name == name);
      return plugins[idx];
    }
    return null;
  }

  updateUseUserOnlineStatus(TencentCloudChatUserConfig config) {
    if (config.autoDownloadMultimediaMessage != null) {
      _userConfig.autoDownloadMultimediaMessage = config.autoDownloadMultimediaMessage;
    }
    if (config.useUserOnlineStatus != null) {
      _userConfig.useUserOnlineStatus = config.useUserOnlineStatus;
    }
  }

  updateSDKAppID({
    required int sdkappid,
  }) {
    _sdkappid = sdkappid;
  }

  bool updateLoginStatus({
    required bool status,
  }) {
    _hasLoggedIn = status;

    console(logs: "Login Status Changed. Current Status Is $status");

    notifyListener(TencentCloudChatBasicDataKeys.hasLoggedIn as T);

    return _hasLoggedIn;
  }

  /// Updates the initialization status of the UIKit Core.
  ///
  /// The [status] parameter indicates the new initialization status.
  /// Returns the updated initialization status.
  bool updateInitializedStatus({
    required bool status,
  }) {
    _hasInitialized = status;

    console(logs: "Init Status Changed. Current Status Is $status");

    notifyListener(TencentCloudChatBasicDataKeys.hasInitialized as T);

    return _hasInitialized;
  }

  /// ==== Current User ====
  V2TimUserFullInfo? _currentUser;

  V2TimUserFullInfo? get currentUser {
    return _currentUser;
  }

  void updateCurrentUserInfo({required V2TimUserFullInfo userFullInfo}) {
    _currentUser = userFullInfo;
    notifyListener(TencentCloudChatBasicDataKeys.selfInfo as T);
  }

  /// ==== version ====
  String _version = "";

  String get version => _version;

  void updateVersion({required String version}) {
    _version = version;
  }

  /// ==== usedComponents ====

  List<TencentCloudChatComponentsEnum> _usedComponents = [];

  final Map<TencentCloudChatComponentsEnum, TencentCloudChatWidgetBuilder> _componentsMap = {};

  Map<TencentCloudChatComponentsEnum, TencentCloudChatWidgetBuilder> get componentsMap => _componentsMap;

  List<TencentCloudChatComponentsEnum> get usedComponents => _usedComponents;

  set usedComponents(List<TencentCloudChatComponentsEnum> value) {
    _usedComponents = value;

    console(logs: "`usedComponents` Status Changed. Current `usedComponents` Is $_usedComponents");

    notifyListener(TencentCloudChatBasicDataKeys.usedComponents as T);
  }

  void addUsedComponent(({TencentCloudChatComponentsEnum componentEnum, TencentCloudChatWidgetBuilder widgetBuilder}) component) {
    _usedComponents.add(component.componentEnum);
    _componentsMap[component.componentEnum] = component.widgetBuilder;
    _usedComponents.toSet().toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "hasInitialized": _hasInitialized,
    });
  }

  @override
  void notifyListener(T key) {
    currentUpdatedFields = key;
    var event = TencentCloudChatBasicData<T>(key);
    event.appLifecycleState = appLifecycleState;
    event._useCallKit = _useCallKit;
    event._hasInitialized = _hasInitialized;
    event._hasLoggedIn = _hasLoggedIn;
    event._sdkappid = _sdkappid;
    event.plugins = plugins;
    event._userConfig.useUserOnlineStatus = _userConfig.useUserOnlineStatus;
    event._userConfig.autoDownloadMultimediaMessage = _userConfig.autoDownloadMultimediaMessage;
    event._currentUser = _currentUser;
    event._version = _version;
    event._usedComponents = _usedComponents;
    event._componentsMap.addAll(_componentsMap);

    TencentCloudChat.instance.eventBusInstance.fire(event, "TencentCloudChatBasicData");
  }
}
