import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tencent_cloud_chat_push/common/common_defines.dart';
import 'package:tencent_cloud_chat_push/common/defines.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push_platform_interface.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudChatPush {
  final tag = "TIMPush TencentCloudChatPushFlutter";
  TencentCloudChatPush._internal();

  factory TencentCloudChatPush() => _instance;
  static final TencentCloudChatPush _instance =
      TencentCloudChatPush._internal();

  // static TencentCloudChatPush get getInstance => _instance;

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
  Future<TencentCloudChatPushResult> registerOnNotificationClickedEvent({
    required Function({required String ext, String? userID, String? groupID})
        onNotificationClicked,
  }) {
    return TencentCloudChatPushPlatform.instance
        .registerOnNotificationClickedEvent(
      onNotificationClicked: onNotificationClicked,
    );
  }

  /// This method registers a callback function for handling app wake up.
  /// It's recommended to call this method as soon as the app starts to ensure that
  /// the Dart layer can receive the app wake up event to login Chat service.
  ///
  /// Only works on Android.
  Future<TencentCloudChatPushResult> registerOnAppWakeUpEvent({
    required VoidCallback onAppWakeUpEvent,
  }) {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag registerOnAppWakeUpEvent",
    );
    return TencentCloudChatPushPlatform.instance.registerOnAppWakeUpEvent(
      onAppWakeUpEvent: onAppWakeUpEvent,
    );
  }

  /// This method registers a callback function for handling notification clicks
  /// and also initializes the Tencent Cloud Chat SDK with the provided configuration.
  /// It must be called after the Tencent Cloud Chat SDK has been successfully logged in.
  /// If the app can log in to Tencent Cloud Chat quickly after starting, calling this
  /// method will automatically register the notification click callback and initialize
  /// the SDK, reducing the need to call the registerOnNotificationClickedEvent method.
  /// However, the timing of receiving notification click events depends on when the
  /// user wishes to receive them. Once the callback is registered, the app will
  /// receive notification click events.
  Future<TencentCloudChatPushResult> registerPush({
    required Function({required String ext, String? userID, String? groupID})
        onNotificationClicked,
    String? androidPushOEMConfig,
    int? apnsCertificateID,
  }) async {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag registerPush start",
    );
    if (apnsCertificateID != null) {
      await TencentCloudChatPushPlatform.instance
          .setBusID(busID: apnsCertificateID);
    }
    final loginMap = TencentImSDKPlugin.v2TIMManager.getCurrentLoginInfo();
    final int? sdkAppID = int.tryParse(loginMap["a"] ?? "");
    final String? userID = loginMap["u"];
    final String? userSig = loginMap["s"];

    if (sdkAppID == null) {
      return TencentCloudChatPushResult(
        code: -1,
        errorMessage:
            "Please initialize Tencent Cloud Chat SDK before register push plugin.",
      );
    }
    if (userID == null || userSig == null) {
      return TencentCloudChatPushResult(
        code: -1,
        errorMessage:
            "Please log in to Tencent Cloud Chat SDK before register push plugin.",
      );
    }


    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag registerPush checked login status complete",
    );

    final completer = Completer<TencentCloudChatPushResult>();

    final registerOnNotificationClickedEventRes =
        await TencentCloudChatPushPlatform.instance
            .registerOnNotificationClickedEvent(
      onNotificationClicked: onNotificationClicked,
    );
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag registerPush registerOnNotificationClickedEvent completed",
    );
    if (registerOnNotificationClickedEventRes.code == 0) {
      final registerPushRes = await TencentCloudChatPushPlatform.instance
          .registerPush(configJson: androidPushOEMConfig);
      TencentImSDKPlugin.manager?.uikitTrace(
        trace: "$tag registerPush completed",
      );
      completer.complete(registerPushRes);
    }else{
      TencentImSDKPlugin.manager?.uikitTrace(
        trace: "$tag registerOnNotificationClickedEvent failed",
      );
      completer.complete(registerOnNotificationClickedEventRes);
    }

    return completer.future;
  }

  /// Unregister the push plugin and log out from the Tencent Cloud Chat
  Future<TencentCloudChatPushResult> unRegisterPush() async {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag unRegisterPush",
    );
    return TencentCloudChatPushPlatform.instance.unRegisterPush();
  }

  /// Disable the auto-registration of the push plugin
  Future<TencentCloudChatPushResult> disableAutoRegisterPush() {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag disableAutoRegisterPush",
    );
    return TencentCloudChatPushPlatform.instance.disableAutoRegisterPush();
  }

  /// Configure the private ring settings for Google FCM notifications
  Future<TencentCloudChatPushResult> configFCMPrivateRing({
    required String channelId,
    required String ringName,
    required bool enable,
  }) {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag configFCMPrivateRing - $channelId - $ringName - $enable",
    );
    return TencentCloudChatPushPlatform.instance.configFCMPrivateRing(
      channelId: channelId,
      ringName: ringName,
      enable: enable,
    );
  }

  /// Set the push brand ID for the push plugin
  Future<TencentCloudChatPushResult> setPushBrandId(
      {required TencentCloudChatPushBrandID brandID}) {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag setPushBrandId - $brandID",
    );
    return TencentCloudChatPushPlatform.instance.setPushBrandId(
      brandId: brandIdToInt(brandID),
    );
  }

  Future<TencentCloudChatPushResult<TencentCloudChatPushBrandID>>
      getPushBrandId() async {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag getPushBrandId - start",
    );
    final result = await TencentCloudChatPushPlatform.instance.getPushBrandId();
    final brandId = intToBrandId(result.data ?? 0);
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag getPushBrandId - finished - $brandId",
    );
    return TencentCloudChatPushResult<TencentCloudChatPushBrandID>(
      code: result.code,
      errorMessage: result.errorMessage,
      data: brandId,
    );
  }

  Future<TencentCloudChatPushResult<String>> checkPushStatus(
      {required TencentCloudChatPushBrandID brandID}) {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag checkPushStatus",
    );
    return TencentCloudChatPushPlatform.instance
        .checkPushStatus(brandID: brandIdToInt(brandID));
  }

  /// Set the Certificate ID for Apple Devices.
  ///
  /// Only works on APNS temporarily, while Android Devices please specify with JSON file from console or `androidPushOEMConfig` on `registerPush` method.
  Future<TencentCloudChatPushResult> setApnsCertificateID(
      {required int apnsCertificateID}) {

    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag setApnsCertificateID - $apnsCertificateID",
    );
    return TencentCloudChatPushPlatform.instance
        .setBusID(busID: apnsCertificateID);
  }

  /// Set the application group ID for Apple Devices.
  ///
  /// Only works on APNS.
  Future<TencentCloudChatPushResult> setApplicationGroupID(
      {required String applicationGroupID}) {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag setApplicationGroupID - $applicationGroupID",
    );
    return TencentCloudChatPushPlatform.instance
        .setApplicationGroupID(applicationGroupID: applicationGroupID);
  }

  /// Get the device push token.
  ///
  /// Only works on Android.
  Future<TencentCloudChatPushResult<String>> getAndroidPushToken() async {
    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag getAndroidPushToken",
    );
    return TencentCloudChatPushPlatform.instance.getAndroidPushToken();
  }

  /// Set the device token with business ID from Tencent Cloud Chat console manually.
  ///
  /// Only works on Android.
  Future<TencentCloudChatPushResult> setAndroidPushToken({
    required String businessID,
    required String pushToken,
  }) async {

    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag setAndroidPushToken - $businessID - $pushToken",
    );
    return TencentCloudChatPushPlatform.instance.setAndroidPushToken(
      businessID: businessID,
      pushToken: pushToken,
    );
  }

  /// Replaces the default push configuration file 'timpush-configs.json' read by the plugin with a custom one.
  /// This method should be called before registering the push service (registerPush method).
  ///
  /// This is primarily used to dynamically switch between different push registration configurations under
  /// different environments, such as integrating and testing push functions under different configuration files
  /// in production and testing environments.
  ///
  /// Only works on Android.
  Future<TencentCloudChatPushResult> setAndroidCustomTIMPushConfigs({
    /// The name of the custom configuration file. The path should remain the same: "project_root_directory/android/app/src/assets/"
    required String configs,
  }) async {

    TencentImSDKPlugin.manager?.uikitTrace(
      trace: "$tag setAndroidCustomTIMPushConfigs - $configs",
    );
    return TencentCloudChatPushPlatform.instance.setAndroidCustomTIMPushConfigs(
      configs: configs,
    );
  }

  getInstance() {
    return _instance;
  }
}
