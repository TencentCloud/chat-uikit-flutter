import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tencent_cloud_chat_push/common/common_defines.dart';
import 'package:tencent_cloud_chat_push/common/defines.dart';
import 'package:tencent_cloud_chat_push/common/tim_push_listener.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push_platform_interface.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudChatPush {
  final tag = "TIMPush TencentCloudChatPushFlutter";

  TencentCloudChatPush._internal();

  factory TencentCloudChatPush() => _instance;
  static final TencentCloudChatPush _instance = TencentCloudChatPush._internal();

  getInstance() {
    return _instance;
  }

/////////////////////////////////////////////////////////////////////////////////
//
//                         register/unregister push service
//
/////////////////////////////////////////////////////////////////////////////////

  /// 1.1 This method registers a callback function for handling notification clicks
  /// and also initializes the Tencent Cloud Chat SDK with the provided configuration.
  /// It must be called after the Tencent Cloud Chat SDK has been successfully logged in.
  /// If the app can log in to Tencent Cloud Chat quickly after starting, calling this
  /// method will automatically register the notification click callback and initialize
  /// the SDK, reducing the need to call the registerOnNotificationClickedEvent method.
  /// However, the timing of receiving notification click events depends on when the
  /// user wishes to receive them. Once the callback is registered, the app will
  /// receive notification click events.
  Future<TencentCloudChatPushResult> registerPush({
    required Function({required String ext, String? userID, String? groupID}) onNotificationClicked,
    int? sdkAppId,
    String? appKey,
    int? apnsCertificateID,
    String? applicationGroupID
  }) async {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag registerPush start",
    );

    if (apnsCertificateID != null) {
      await TencentCloudChatPushPlatform.instance.setBusID(busID: apnsCertificateID);
    }

    if (applicationGroupID != null) {
      await TencentCloudChatPushPlatform.instance.setApplicationGroupID(applicationGroupID: applicationGroupID);
    }

    final loginMap = TencentImSDKPlugin.v2TIMManager.getCurrentLoginInfo();
    final int? imSdkAppID = int.tryParse(loginMap["a"] ?? "");
    final String? userID = loginMap["u"];
    final String? userSig = loginMap["s"];

    if (imSdkAppID == null && sdkAppId == null) {
      return TencentCloudChatPushResult(
        code: -1,
        errorMessage: "Please initialize Tencent Cloud Chat SDK before register push plugin.",
      );
    }
    if ((userID == null || userSig == null) && appKey == null) {
      return TencentCloudChatPushResult(
        code: -1,
        errorMessage: "Please log in to Tencent Cloud Chat SDK before register push plugin.",
      );
    }

    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag registerPush checked login status complete",
    );

    final registerOnNotificationClickedEventRes =
    await TencentCloudChatPushPlatform.instance.registerOnNotificationClickedEvent(
      onNotificationClicked: onNotificationClicked,
    );

    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag registerPush registerOnNotificationClickedEvent completed",
    );

    if (registerOnNotificationClickedEventRes.code == 0) {
      final registerPushRes = await TencentCloudChatPushPlatform.instance.registerPush(
        sdkAppId: sdkAppId,
        appKey: appKey,
      );
      TencentImSDKPlugin.v2TIMManager.uikitTrace(
        trace: "$tag registerPush completed",
      );
      return registerPushRes;
    } else {
      TencentImSDKPlugin.v2TIMManager.uikitTrace(
        trace: "$tag registerOnNotificationClickedEvent failed",
      );
      return registerOnNotificationClickedEventRes;
    }
  }

  /// 1.2 Unregister the push plugin and log out from the Tencent Cloud Chat
  Future<TencentCloudChatPushResult> unRegisterPush() async {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag unRegisterPush",
    );
    return TencentCloudChatPushPlatform.instance.unRegisterPush();
  }

  ///  1.3 After successfully registering for the offline push notification service,
  ///  you can obtain a unique push ID, known as the RegistrationID, through this interface.
  ///  You can then use the RegistrationID to send messages to the specified device.
  ///
  ///  The RegistrationID is a unique identifier for device push notifications.
  ///  It is automatically generated upon successful registration for the push
  ///  notification service by default, but it also supports user-defined settings.
  ///  This allows users to send messages to a specified device based on the RegistrationID.
  ///  Note that the RegistrationID will change if the app is uninstalled and reinstalled.
  ///
  Future<TencentCloudChatPushResult> getRegistrationID() {
    return TencentCloudChatPushPlatform.instance.getRegistrationID();
  }

  ///  1.4 To customize the unique push identifier for the device, known as the RegistrationID,
  ///  you need to call this setting before registering for the push notification service.
  ///
  ///  The RegistrationID is a unique identifier for device push notifications.
  ///  It is automatically generated upon successful registration for the push
  ///  notification service by default, but it also supports user-defined settings.
  ///  This allows users to send messages to a specified device based on the RegistrationID.
  ///  Note that the RegistrationID will change if the app is uninstalled and reinstalled.
  ///
  Future<TencentCloudChatPushResult> setRegistrationID({required String registrationID}) {
    return TencentCloudChatPushPlatform.instance.setRegistrationID(registrationID: registrationID);
  }

/////////////////////////////////////////////////////////////////////////////////
//
//                         Push Listener
//
/////////////////////////////////////////////////////////////////////////////////

  /// 2.1 Add a Push Listener
  Future<void> addPushListener({
    required TIMPushListener listener,
  }) {
    return TencentCloudChatPushPlatform.instance.addPushListener(
      listener: listener,
    );
  }

  /// 2.2 Remove a Push Listener
  Future<void> removePushListener({
    required TIMPushListener listener,
  }) {
    return TencentCloudChatPushPlatform.instance.removePushListener(
      listener: listener,
    );
  }

/////////////////////////////////////////////////////////////////////////////////
//
//                         自定义配置
//
/////////////////////////////////////////////////////////////////////////////////

  /// 3.1 To specify that the device should use the FCM channel for offline push notifications,
  /// you need to call this before registering for the push notification service.
  /// This is commonly used for overseas push notifications via the FCM channel,
  /// such as for overseas Xiaomi devices using the FCM channel.
  ///
  /// @param enable true:using FCM; false:using native channel
  Future<TencentCloudChatPushResult> forceUseFCMPushChannel({required bool enable}) {
    return TencentCloudChatPushPlatform.instance.forceUseFCMPushChannel(enable: enable);
  }

  /// 3.2 Disable notification bar pop-ups when the app is in the foreground.
  /// When the push SDK receives an online push, it will automatically add a
  /// Notification to the notification bar. If you want to handle online push messages yourself,
  /// you can call this interface to disable the automatic notification bar pop-up feature.
  ///
  /// @param disable  true:OFF; false:ON
  Future<TencentCloudChatPushResult> disablePostNotificationInForeground({required bool disable}) {
    return TencentCloudChatPushPlatform.instance.disablePostNotificationInForeground(disable: disable);
  }

  /// 3.3 Create a client notification channel. This interface allows for custom ringtone functionality on the Android platform.
  Future<TencentCloudChatPushResult> createNotificationChannel({
    required String channelID,
    required String channelName,
    String? channelDesc,
    String? channelSound,
  }) {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag createNotificationChannel - $channelID - $channelName - $channelDesc - $channelSound",
    );
    return TencentCloudChatPushPlatform.instance.createNotificationChannel(
      channelID: channelID,
      channelName: channelName,
      channelDesc: channelDesc,
      channelSound: channelSound,
    );
  }

/////////////////////////////////////////////////////////////////////////////////
//
//     Experimental API
//
/////////////////////////////////////////////////////////////////////////////////

  /// 4.1 Experimental API
  ///
  /// @note This interface provides some experimental features.
  Future<TencentCloudChatPushResult> callExperimentalAPI({
    required String api,
    Object? param,
  }) async {
    return TencentCloudChatPushPlatform.instance.callExperimentalAPI(api: api, param: param);
  }

/////////////////////////////////////////////////////////////////////////////////
//
//     Deprecated API
//
/////////////////////////////////////////////////////////////////////////////////

  @Deprecated('Deprecated')
  Future<String?> getPlatformVersion() {
    return TencentCloudChatPushPlatform.instance.getPlatformVersion();
  }

  /// This method registers a callback function for handling notification clicks.
  /// It's recommended to call this method as soon as the app starts to ensure that
  /// the Dart layer can receive the 'ext' parameter from the notification click
  /// event, even when the app is cold-started. This allows the app to navigate
  /// to the appropriate page based on the 'ext' parameter. Registering the callback
  /// function does not require the Tencent Cloud Chat SDK to be logged in, making
  /// it suitable for scenarios where the app needs to handle notification clicks
  /// before Tencent Cloud Chat SDK login is completed.
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> registerOnNotificationClickedEvent({
    required Function({required String ext, String? userID, String? groupID}) onNotificationClicked,
  }) {
    return TencentCloudChatPushPlatform.instance.registerOnNotificationClickedEvent(
      onNotificationClicked: onNotificationClicked,
    );
  }

  /// Disable the auto-registration of the push plugin
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> disableAutoRegisterPush() {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag disableAutoRegisterPush",
    );
    return TencentCloudChatPushPlatform.instance.disableAutoRegisterPush();
  }

  /// After failing to open the local channel, probe other available channels.
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> enableBackupChannels() {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag enableBackupChannels",
    );
    return TencentCloudChatPushPlatform.instance.enableBackupChannels();
  }

  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> configFCMPrivateRing({
    required String channelId,
    required String ringName,
    required bool enable,
  }) {
    return setCustomFCMRing(
      channelId: channelId,
      ringName: ringName,
      enable: enable,
    );
  }

  /// Configure the private ring settings for Google FCM notifications
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> setCustomFCMRing({
    required String channelId,
    required String ringName,
    required bool enable,
  }) {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag setCustomFCMRing - $channelId - $ringName - $enable",
    );
    return TencentCloudChatPushPlatform.instance.setCustomFCMRing(
      channelId: channelId,
      ringName: ringName,
      enable: enable,
    );
  }

  /// Set the push brand ID for the push plugin
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> setPushBrandId({required TencentCloudChatPushBrandID brandID}) {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag setPushBrandId - $brandID",
    );
    return TencentCloudChatPushPlatform.instance.setPushBrandId(
      brandId: brandIdToInt(brandID),
    );
  }

  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult<TencentCloudChatPushBrandID>> getPushBrandId() async {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag getPushBrandId - start",
    );
    final result = await TencentCloudChatPushPlatform.instance.getPushBrandId();
    final brandId = intToBrandId(result.data ?? 0);
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag getPushBrandId - finished - $brandId",
    );
    return TencentCloudChatPushResult<TencentCloudChatPushBrandID>(
      code: result.code,
      errorMessage: result.errorMessage,
      data: brandId,
    );
  }

  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> setAndroidCustomTIMPushConfigs({
    required String configs,
  }) async {
    return setAndroidCustomConfigFile(configs: configs);
  }

  /// Replaces the default push configuration file 'timpush-configs.json' read by the plugin with a custom one.
  /// This method should be called before registering the push service (registerPush method).
  ///
  /// This is primarily used to dynamically switch between different push registration configurations under
  /// different environments, such as integrating and testing push functions under different configuration files
  /// in production and testing environments.
  ///
  /// Only works on Android.
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> setAndroidCustomConfigFile({
    /// The name of the custom configuration file. The path should remain the same: "project_root_directory/android/app/src/assets/"
    required String configs,
  }) async {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag setAndroidCustomConfigFile - $configs",
    );
    return TencentCloudChatPushPlatform.instance.setAndroidCustomConfigFile(
      configs: configs,
    );
  }

  /// Get the device push token.
  ///
  /// Only works on Android.
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult<String>> getAndroidPushToken() async {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag getAndroidPushToken",
    );
    return TencentCloudChatPushPlatform.instance.getAndroidPushToken();
  }

  /// Set the device token with business ID from Tencent Cloud Chat console manually.
  ///
  /// Only works on Android.
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> setAndroidPushToken({
    required String businessID,
    required String pushToken,
  }) async {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag setAndroidPushToken - $businessID - $pushToken",
    );
    return TencentCloudChatPushPlatform.instance.setAndroidPushToken(
      businessID: businessID,
      pushToken: pushToken,
    );
  }

  /// This method registers a callback function for handling app wake up.
  /// It's recommended to call this method as soon as the app starts to ensure that
  /// the Dart layer can receive the app wake up event to login Chat service.
  ///
  /// Only works on Android FCM data.
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> registerOnAppWakeUpEvent({
    required VoidCallback onAppWakeUpEvent,
  }) {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag registerOnAppWakeUpEvent",
    );
    return TencentCloudChatPushPlatform.instance.registerOnAppWakeUpEvent(
      onAppWakeUpEvent: onAppWakeUpEvent,
    );
  }

  @Deprecated('Deprecated：not support')
  Future<TencentCloudChatPushResult> setXiaoMiPushStorageRegion({
    required int region,
  }) async {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag setXiaoMiPushStorageRegion - $region",
    );
    return TencentCloudChatPushPlatform.instance.setXiaoMiPushStorageRegion(
      region: region,
    );
  }

  /// Set the Certificate ID for Apple Devices.
  ///
  /// Only works on APNS temporarily, while Android Devices please specify with JSON file from console or `androidPushOEMConfig` on `registerPush` method.
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> setApnsCertificateID({required int apnsCertificateID}) {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag setApnsCertificateID - $apnsCertificateID",
    );
    return TencentCloudChatPushPlatform.instance.setBusID(busID: apnsCertificateID);
  }

  /// Set the application group ID for Apple Devices.
  ///
  /// Only works on APNS.
  @Deprecated('Deprecated')
  Future<TencentCloudChatPushResult> setApplicationGroupID({required String applicationGroupID}) {
    TencentImSDKPlugin.v2TIMManager.uikitTrace(
      trace: "$tag setApplicationGroupID - $applicationGroupID",
    );
    return TencentCloudChatPushPlatform.instance.setApplicationGroupID(applicationGroupID: applicationGroupID);
  }

}