import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';

enum TencentCloudChatCacheKey {
  currentDeviceKeyboardHeight,
  locale,
  permission,
}

class TencentCloudChatCacheGlobal {
  final String _tag = "TencentCloudChatCacheGlobal";

  static TencentCloudChatCacheGlobal? _instance;

  TencentCloudChatCacheGlobal._internal();

  static TencentCloudChatCacheGlobal get instance {
    _instance ??= TencentCloudChatCacheGlobal._internal();
    return _instance!;
  }

  console(String log) {
    TencentCloudChat.instance.logInstance.console(componentName: _tag, logs: log);
  }

  static Box? _box;

  static bool _inited = false;

  Future<bool> init(String name) async {
    if (_inited) {
      console("global box has inited");
      return true;
    }

    await Hive.initFlutter();
    String md5 = TencentCloudChatUtils.getMd5ByString(name);
    _box = await Hive.openBox("TCCFGLOBAL-$md5");
    console("global box path is ${_box!.path}");
    _inited = true;
    return true;
  }

  Future<void> cacheLocale(Locale locale) async {
    if (_box == null || !_inited) {
      console("cacheLocale _box is null or _inited is false");
      return;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return;
    }
    String hiveKey = TencentCloudChatCacheKey.locale.name;
    await _box!.put(hiveKey, TencentCloudChatIntl.serializeLocale(locale));
  }

  Locale? getCachedLocale() {
    if (_box == null || !_inited) {
      console("getCachedLocale _box is null or _inited is false");
      return null;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return null;
    }
    String hiveKey = TencentCloudChatCacheKey.locale.name;

    String originData = _box!.get(hiveKey, defaultValue: "");
    return TencentCloudChatIntl.deserializeLocale(originData);
  }

  Future<void> cachePermission(String permission) async {
    if (_box == null || !_inited) {
      console("cachePermission _box is null or _inited is false");
      return;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return;
    }
    String hiveKey = TencentCloudChatCacheKey.permission.name;

    final currentPermission = getPermission();
    final newPermission = "$currentPermission $permission";
    await _box!.put(hiveKey, newPermission);
  }

  String getPermission() {
    if (_box == null || !_inited) {
      console("getPermission _box is null or _inited is false");
      return "";
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return "";
    }

    String hiveKey = TencentCloudChatCacheKey.permission.name;

    String originData = _box!.get(hiveKey, defaultValue: "");
    return originData;
  }

  Future<void> cacheCurrentDeviceKeyBordHeight(double height) async {
    if (_box == null || !_inited) {
      console("cacheCurrentDeviceKeyBordHeight _box is null or _inited is false");
      return;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return;
    }
    String hiveKey = TencentCloudChatCacheKey.currentDeviceKeyboardHeight.name;
    await _box!.put(hiveKey, height.toString());
  }

  double getCurrentDeviceKeyBordHeight() {
    if (_box == null || !_inited) {
      console("getCurrentDeviceKeyBordHeight _box is null or _inited is false");
      return 280;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return 280;
    }

    String hiveKey = TencentCloudChatCacheKey.currentDeviceKeyboardHeight.name;
    String originData = _box!.get(hiveKey, defaultValue: "280");
    return double.parse(originData);
  }
}
