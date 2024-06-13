import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_push/common/common_defines.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push_modal.dart';

import 'tencent_cloud_chat_push_platform_interface.dart';

/// An implementation of [TencentCloudChatPushPlatform] that uses method channels.
class MethodChannelTencentCloudChatPush extends TencentCloudChatPushPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel = const MethodChannel('tencent_cloud_chat_push');

  final TencentCloudChatPushModal _tencentCloudChatPushModal = TencentCloudChatPushModal();

  @override
  Future<String?> getPlatformVersion() async {
    final version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<TencentCloudChatPushResult> registerOnNotificationClickedEvent({
    required Function({required String ext, String? userID, String? groupID}) onNotificationClicked,
  }) async {
    try {
      _tencentCloudChatPushModal.onNotificationClicked = onNotificationClicked;
      _methodChannel.setMethodCallHandler(_tencentCloudChatPushModal.handleMethod);
      if(Platform.isAndroid || Platform.isIOS){
        await _methodChannel.invokeMethod("registerOnNotificationClickedEvent");
      }
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> registerOnAppWakeUpEvent({
    required VoidCallback onAppWakeUpEvent,
  }) async {
    try {
      _tencentCloudChatPushModal.onAppWakeUp = onAppWakeUpEvent;
      _methodChannel.setMethodCallHandler(_tencentCloudChatPushModal.handleMethod);
      if(Platform.isAndroid){
        await _methodChannel.invokeMethod("registerOnAppWakeUpEvent");
      }
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> registerPush({String? configJson}) async {
    try {
      if(Platform.isIOS || Platform.isAndroid){
        await _methodChannel.invokeMethod("registerPush", {"push_config_json": configJson ?? ""});
      }
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> unRegisterPush() async {
    try {
      await _methodChannel.invokeMethod("unRegisterPush");
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> disableAutoRegisterPush() async {
    try {
      await _methodChannel.invokeMethod("disableAutoRegisterPush");
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> configFCMPrivateRing({
    required String channelId,
    required String ringName,
    required bool enable,
  }) async {
    try {
      await _methodChannel.invokeMethod("configFCMPrivateRing", {
        "fcm_push_channel_id": channelId,
        "private_ring_name": ringName,
        "enable_fcm_private_ring": enable.toString(),
      });
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> setPushBrandId({required int brandId}) async {
    try {
      await _methodChannel.invokeMethod("setPushBrandId", {
        "brand_id": brandId.toString(),
      });
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult<int>> getPushBrandId() async {
    try {
      final res = await _methodChannel.invokeMethod("getPushBrandId");
      return TencentCloudChatPushResult(code: 0, data: int.tryParse(res.toString()));
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult<String>> checkPushStatus({required int brandID}) async {
    try {
      final res = await _methodChannel.invokeMethod("checkPushStatus", {
        "brand_id": brandID.toString(),
      });
      return TencentCloudChatPushResult(code: 0, data: res);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> setBusID({required int busID}) async {
    try {
      if (Platform.isIOS) {
        await _methodChannel.invokeMethod("setBusId", {"busId": busID});
      }
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> setApplicationGroupID({required String applicationGroupID}) async {
    try {
      await _methodChannel.invokeMethod("setApplicationGroupID", {"applicationGroupID": applicationGroupID});
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult<String>> getAndroidPushToken() async {
    try {
      final res = await _methodChannel.invokeMethod("getAndroidPushToken");
      return TencentCloudChatPushResult(code: 0, data: res);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> setAndroidPushToken({
    required String businessID,
    required String pushToken,
  }) async {
    try {
      await _methodChannel.invokeMethod("setAndroidPushToken", {
        "business_id": businessID,
        "push_token": pushToken,
      });
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }

  @override
  Future<TencentCloudChatPushResult> setAndroidCustomTIMPushConfigs({
    required String configs,
  }) async {
    try {
      await _methodChannel.invokeMethod("setAndroidCustomTIMPushConfigs", {
        "configs": configs,
      });
      return TencentCloudChatPushResult(code: 0);
    } on PlatformException catch (e) {
      return TencentCloudChatPushResult(
        code: int.tryParse(e.code) ?? -1,
        errorMessage: e.message,
      );
    }
  }
}
