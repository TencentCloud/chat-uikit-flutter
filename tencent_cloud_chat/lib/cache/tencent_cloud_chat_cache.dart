import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

enum TencentCloudChatCacheKey {
  conversationList,
  messageListByConvKey,
  loadedConvKey,
  groupMemberList,
  currentDeviceKeyboardHeight,
  currentLoginUserInfo,
  locale,
  permission,
}

class TencentCloudChatCacheGenerator {
  static TencentCloudChatCache getInstance() {
    return TencentCloudChatCache._();
  }
}

class TencentCloudChatCache {
  final String _tag = "TencentCloudChatCache";
  TencentCloudChatCache._();

  console(String log) {
    TencentCloudChat.instance.logInstance
        .console(componentName: _tag, logs: log);
  }

  static bool _inited = false;

  static String _perfix = "";

  static Box? _box;

  Future<bool> init({
    required int sdkAppID,
    required String currentLoginUserId,
  }) async {
    if (currentLoginUserId.isNotEmpty && sdkAppID != 0) {
      _perfix = "$sdkAppID-$currentLoginUserId-";
    } else {
      console("please init and login first");
      return false;
    }

    await Hive.initFlutter();

    _box = await Hive.openBox("TCCF");

    console("box path is ${_box!.path}");

    console("Hive init success");

    _inited = true;

    return true;
  }

  Future<void> cacheConversationList(List<V2TimConversation> convList) async {
    if (_box == null || !_inited) {
      console("cacheConversationList _box is null or _inited is false");
      return;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return;
    }
    String key = TencentCloudChatCacheKey.conversationList.name;
    await _box!.put(
        "$_perfix$key", convList.map((e) => json.encode(e.toJson())).toList());
    console("set $key to hive. ${convList.length}");
  }

  List<V2TimConversation> getConversationListFromCache() {
    if (_box == null || !_inited) {
      console("cacheConversationList _box is null or _inited is false");
      return [];
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return [];
    }
    String key = TencentCloudChatCacheKey.conversationList.name;
    List<dynamic> origindata = _box!.get("$_perfix$key", defaultValue: []);
    final pp = _perfix;

    console(pp);
    List<Map<String, dynamic>> data = origindata
        .map((e) => json.decode(e.toString()))
        .toList()
        .cast<Map<String, dynamic>>();
    console("getConversationListFromCache length ${data.length}");
    return data.map((e) => V2TimConversation.fromJson(e)).toList();
  }

  Future<void> cacheMessageListByConvKey(
      List<V2TimMessage> convList, String convKey) async {
    if (_box == null || !_inited) {
      console("cacheMessageListByConvKey _box is null or _inited is false");
      return;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return;
    }
    String key = TencentCloudChatCacheKey.messageListByConvKey.name;
    String hivekey = "$_perfix$key-$convKey";
    await _box!
        .put(hivekey, convList.map((e) => json.encode(e.toJson())).toList());
    await cacheLoadedConvKey(convKey);
    console("set $key to hive. ${convList.length}");
  }

  List<V2TimMessage> getMessageListByConvKey(String convKey) {
    if (_box == null || !_inited) {
      console("getMessageListByConvKey _box is null or _inited is false");
      return [];
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return [];
    }
    String key = TencentCloudChatCacheKey.messageListByConvKey.name;
    String hivekey = "$_perfix$key-$convKey";
    List<String> origindata = _box!.get(hivekey, defaultValue: []);

    List<Map<String, dynamic>> data = origindata
        .map((e) => json.decode(e))
        .toList()
        .cast<Map<String, dynamic>>();
    console("getMessageListByConvKey length ${data.length}");
    return data.map((e) => V2TimMessage.fromJson(e)).toList();
  }

  Future<void> cacheLoadedConvKey(String convKey) async {
    if (_box == null || !_inited) {
      console("cacheLoadedConvKey _box is null or _inited is false");
      return;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return;
    }
    String key = TencentCloudChatCacheKey.loadedConvKey.name;
    String hivekey = "$_perfix$key";
    List<String> keys = getAllConvKey();

    if (!keys.contains(convKey)) {
      keys.add(convKey);
      console("cacheLoadedConvKey ${json.encode(keys)}");
      await _box!.put(hivekey, keys);
    } else {
      console("ignore to add key");
    }
  }

  List<String> getAllConvKey() {
    if (_box == null || !_inited) {
      console("getMessageListByConvKey _box is null or _inited is false");
      return [];
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return [];
    }
    String key = TencentCloudChatCacheKey.loadedConvKey.name;
    String hivekey = "$_perfix$key";
    List<dynamic> origindata = _box!.get(hivekey, defaultValue: []);

    console("getAllConvKey length ${origindata.length}");
    return origindata.map((e) => e.toString()).toList();
  }

  Future<void> cacheGroupMemberList(
      String groupID, List<V2TimGroupMemberFullInfo> memberList) async {
    if (_box == null || !_inited) {
      console("cacheGroupMemberList _box is null or _inited is false");
      return;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return;
    }
    String key = TencentCloudChatCacheKey.groupMemberList.name;
    String hivekey = "$_perfix$key-$groupID";
    await _box!
        .put(hivekey, memberList.map((e) => json.encode(e.toJson())).toList());
    console("set $key to hive. ${memberList.length}");
  }

  List<V2TimGroupMemberFullInfo> getGroupMemberListFromCache(String groupID) {
    if (_box == null || !_inited) {
      console("getGroupMemberListFromCache _box is null or _inited is false");
      return [];
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return [];
    }
    String key = TencentCloudChatCacheKey.groupMemberList.name;

    String hivekey = "$_perfix$key-$groupID";

    List<dynamic> origindata = _box!.get(hivekey, defaultValue: []);

    List<Map<String, dynamic>> data = origindata
        .map((e) => json.decode(e.toString()))
        .toList()
        .cast<Map<String, dynamic>>();
    return data.map((e) => V2TimGroupMemberFullInfo.fromJson(e)).toList();
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
    String key = TencentCloudChatCacheKey.permission.name;
    String hivekey = "$_perfix$key";

    final currentPermission = getPermission();
    final newPermission = "$currentPermission $permission";
    await _box!.put(hivekey, newPermission);
    console("set $key to hive. $newPermission}");
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
    String key = TencentCloudChatCacheKey.permission.name;

    String hivekey = "$_perfix$key";

    String origindata = _box!.get(hivekey, defaultValue: "");

    console("getCurrentDeviceKeyBordHeight length $origindata");
    return origindata;
  }

  Future<void> cacheCurrentDeviceKeyBordHeight(double height) async {
    if (_box == null || !_inited) {
      console(
          "cacheCurrentDeviceKeyBordHeight _box is null or _inited is false");
      return;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return;
    }
    String key = TencentCloudChatCacheKey.currentDeviceKeyboardHeight.name;
    String hivekey = "$_perfix$key";
    await _box!.put(hivekey, height.toString());
    console("set $key to hive. ${height.toString()}");
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
    String key = TencentCloudChatCacheKey.currentDeviceKeyboardHeight.name;

    String hivekey = "$_perfix$key";

    String origindata = _box!.get(hivekey, defaultValue: "280");

    console("getCurrentDeviceKeyBordHeight length $origindata");
    return double.parse(origindata);
  }

  Future<void> cacheCurrentLoginUserInfo(V2TimUserFullInfo userInfo) async {
    if (_box == null || !_inited) {
      console("cacheCurrentLoginUserInfo _box is null or _inited is false");
      return;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return;
    }
    String key = TencentCloudChatCacheKey.currentLoginUserInfo.name;
    String hivekey = "$_perfix$key";
    await _box!.put(hivekey, json.encode(userInfo.toJson()));
    console("set $key to hive. userid ${userInfo.userID}");
  }

  V2TimUserFullInfo? getCurrentLoginUserInfo() {
    if (_box == null || !_inited) {
      console("getCurrentLoginUserInfo _box is null or _inited is false");
      return null;
    }
    if (!_box!.isOpen) {
      console("box is not open");
      return null;
    }
    String key = TencentCloudChatCacheKey.currentLoginUserInfo.name;

    String hivekey = "$_perfix$key";

    String origindata = _box!.get(hivekey, defaultValue: "");

    if (origindata.isNotEmpty) {
      var info = V2TimUserFullInfo.fromJson(json.decode(origindata));
      return info;
    }
    return null;
  }

  List<V2TimGroupMemberFullInfo> getGroupMemberInfoFromCache(
      {required String groupID, required List<String> members}) {
    List<V2TimGroupMemberFullInfo> allMembers =
        getGroupMemberListFromCache(groupID);

    return allMembers
        .takeWhile((value) => members.contains(value.userID))
        .toList();
  }
}
