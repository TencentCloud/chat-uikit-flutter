
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tencent_cloud_chat_push/common/common_defines.dart';

import 'tencent_cloud_chat_push_method_channel.dart';

abstract class TencentCloudChatPushPlatform extends PlatformInterface {
  /// Constructs a TencentCloudChatPushPlatform.
  TencentCloudChatPushPlatform() : super(token: _token);

  static final Object _token = Object();

  static TencentCloudChatPushPlatform _instance = MethodChannelTencentCloudChatPush();

  /// The default instance of [TencentCloudChatPushPlatform] to use.
  ///
  /// Defaults to [MethodChannelTencentCloudChatPush].
  static TencentCloudChatPushPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TencentCloudChatPushPlatform] when
  /// they register themselves.
  static set instance(TencentCloudChatPushPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> registerOnNotificationClickedEvent({
    required Function({required String ext, String? userID, String? groupID}) onNotificationClicked,
  }) {
    throw UnimplementedError('registerOnNotificationClickedEvent() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> registerOnAppWakeUpEvent({
    required VoidCallback onAppWakeUpEvent,
  }) {
    throw UnimplementedError('registerOnAppWakeUpEvent() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> registerPush({String? configJson}) {
    throw UnimplementedError('registerPush() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> unRegisterPush() {
    throw UnimplementedError('unRegisterPush() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> disableAutoRegisterPush() {
    throw UnimplementedError('disableAutoRegisterPush() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> configFCMPrivateRing({
    required String channelId,
    required String ringName,
    required bool enable,
  }) {
    throw UnimplementedError('configFCMPrivateRing() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> setPushBrandId({required int brandId}) {
    throw UnimplementedError('setPushBrandId() has not been implemented.');
  }

  Future<TencentCloudChatPushResult<int>> getPushBrandId() {
    throw UnimplementedError('getPushBrandId() has not been implemented.');
  }

  Future<TencentCloudChatPushResult<String>> checkPushStatus({required int brandID}) {
    throw UnimplementedError('checkPushStatus() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> setBusID({required int busID}) {
    throw UnimplementedError('setBusID() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> setApplicationGroupID({required String applicationGroupID}) {
    throw UnimplementedError('setApplicationGroupID() has not been implemented.');
  }

  Future<TencentCloudChatPushResult<String>> getAndroidPushToken() async {
    throw UnimplementedError('getAndroidPushToken() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> setAndroidPushToken({
    required String businessID,
    required String pushToken,
  }) async {
    throw UnimplementedError('setAndroidPushToken() has not been implemented.');
  }

  Future<TencentCloudChatPushResult> setAndroidCustomTIMPushConfigs({
    required String configs,
  }) async {
    throw UnimplementedError('setAndroidCustomTIMPushConfigs() has not been implemented.');
  }
}
