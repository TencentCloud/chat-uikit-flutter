import 'dart:html';

import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tencent_cloud_chat_push/common/common_defines.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push_method_channel.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push_platform_interface.dart';

class MockTencentCloudChatPushPlatform with MockPlatformInterfaceMixin implements TencentCloudChatPushPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<TencentCloudChatPushResult> configFCMPrivateRing({required String channelId, required String ringName, required bool enable}) {
    // TODO: implement configFCMPrivateRing
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> disableAutoRegisterPush() {
    // TODO: implement disableAutoRegisterPush
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> registerOnNotificationClickedEvent({required Function({required String ext, String? userID, String? groupID}) onNotificationClicked}) {
    // TODO: implement registerOnNotificationClickedEvent
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> registerPush({String? configJson}) {
    // TODO: implement registerPush
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> setPushBrandId({required int brandId}) {
    // TODO: implement setPushBrandId
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> unRegisterPush() {
    // TODO: implement unRegisterPush
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> setBusID({required int busID}) {
    // TODO: implement setBusID
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> setApplicationGroupID({required String applicationGroupID}) {
    // TODO: implement setApplicationGroupID
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult<String>> checkPushStatus({required int brandID}) {
    // TODO: implement checkPushStatus
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult<String>> getAndroidPushToken() {
    // TODO: implement getAndroidPushToken
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> registerOnAppWakeUpEvent({required VoidCallback onAppWakeUpEvent}) {
    // TODO: implement registerOnAppWakeUpEvent
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> setAndroidPushToken({required String businessID, required String pushToken}) {
    // TODO: implement setAndroidPushToken
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> setAndroidCustomConfigFile({required String configs}) {
    // TODO: implement setAndroidCustomConfigFile
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> setXiaoMiPushStorageRegion({required int region}) {
    // TODO: implement setXiaoMiPushStorageRegion
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult<int>> getPushBrandId() {
    // TODO: implement getPushBrandId
    throw UnimplementedError();
  }

  @override
  Future<TencentCloudChatPushResult> setCustomFCMRing({required String channelId, required String ringName, required bool enable}) {
    // TODO: implement setCustomFCMRing
    throw UnimplementedError();
  }
  
}

void main() {
  final TencentCloudChatPushPlatform initialPlatform = TencentCloudChatPushPlatform.instance;

  test('$MethodChannelTencentCloudChatPush is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTencentCloudChatPush>());
  });

  test('getPlatformVersion', () async {
    TencentCloudChatPush tencentCloudChatPushPlugin = TencentCloudChatPush();
    MockTencentCloudChatPushPlatform fakePlatform = MockTencentCloudChatPushPlatform();
    TencentCloudChatPushPlatform.instance = fakePlatform;

    expect(await tencentCloudChatPushPlugin.getPlatformVersion(), '42');
  });
}
