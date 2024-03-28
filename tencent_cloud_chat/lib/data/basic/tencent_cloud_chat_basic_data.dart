import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_user_config.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

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
class TencentCloudChatBasicData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatBasicData(super.currentUpdatedFields);

  void clear() {
    _hasLoggedIn = false;
    _currentUser = null;
  }

  /// ==== useCallKit ====
  bool _useCallKit = false;

  // ignore: unnecessary_getters_setters
  bool get useCallKit => _useCallKit;

  set useCallKit(bool value) {
    _useCallKit = value;
  }

  double? get keyboardHeight {
    return TencentCloudChat.cache.getCurrentDeviceKeyBordHeight();
  }

  set keyboardHeight(double? value) {
    if (value != null) {
      TencentCloudChat.cache.cacheCurrentDeviceKeyBordHeight(value);
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
    return TencentCloudChat.cache.getCurrentLoginUserInfo() ?? _currentUser;
  }

  void updateCurrentUserInfo({required V2TimUserFullInfo userFullInfo}) {
    _currentUser = userFullInfo;
    TencentCloudChat.cache.cacheCurrentLoginUserInfo(userFullInfo);
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
    notifyListener(TencentCloudChatBasicDataKeys.addUsedComponent as T);
  }

  /// ==== config for components ====
  TencentCloudChatMessageConfig? _messageConfig;

  TencentCloudChatMessageConfig get messageConfig => _messageConfig ?? TencentCloudChatMessageConfig();

  set messageConfig(TencentCloudChatMessageConfig value) {
    _messageConfig = value;
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
    TencentCloudChat.eventBusInstance.fire(this);
  }
}
