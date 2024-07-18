import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tencent_cloud_chat/cache/tencent_cloud_chat_cache.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';

class TencentCloudChatCacheGlobal {
  final String _tag = "TencentCloudChatCacheGlobal";

  console(String log) {
    TencentCloudChat.instance.logInstance.console(componentName: _tag, logs: log);
  }

  static Box? _box;

  static bool _inited = false;

  Future<bool> init(String name) async {
    await Hive.initFlutter();
    String md5 = TencentCloudChatUtils.getMd5ByString(name);
    _box = await Hive.openBox("TCCFGLOBAL-$md5");

    console("box path is ${_box!.path}");

    console("Hive init success");
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
    String hivekey = TencentCloudChatCacheKey.locale.name;
    await _box!.put(hivekey, TencentCloudChatIntl.serializeLocale(locale));
    console("set $hivekey to hive. ${TencentCloudChatIntl.serializeLocale(locale)}");
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
    String hivekey = TencentCloudChatCacheKey.locale.name;

    String origindata = _box!.get(hivekey, defaultValue: "");

    console("getCachedLocale length $origindata");

    return TencentCloudChatIntl.deserializeLocale(origindata);
  }
}
