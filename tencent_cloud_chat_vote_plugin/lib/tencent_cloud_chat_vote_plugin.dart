// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

library tencent_cloud_chat_vote_plugin;

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_custom_elem.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_message/vote_message.dart';
import 'package:tencent_cloud_chat_vote_plugin/config/tencent_cloud_chat_vote_config.dart';
export 'package:tencent_cloud_chat_vote_plugin/components/vote_create/vote_create.dart';
export 'package:tencent_cloud_chat_vote_plugin/components/vote_detail/vote_detail.dart';
export 'package:tencent_cloud_chat_vote_plugin/components/vote_message/vote_message.dart';
export 'package:tencent_cloud_chat_vote_plugin/struct/vote_custom_struct.dart';
export 'package:tencent_cloud_chat_vote_plugin/config/tencent_cloud_chat_vote_config.dart';

/// TencentCloudChatVotePlugin.
class TencentCloudChatVotePlugin extends TencentCloudChatPlugin {
  static final V2TIMManager imManager = TencentImSDKPlugin.v2TIMManager;

  // static TencentCloudChatVoteConfig? _config;

  static late String currentUser;
  static bool hasInited = false;

  static initPlugin({
    TencentCloudChatVoteConfig? config,
  }) async {
    if (config != null) {
      // _config = config;
    }
    String _currentUser = await _getCurrentLoginUser();
    if (_currentUser.isNotEmpty) {
      currentUser = _currentUser;
      hasInited = true;
    } else {
      print(
        "Very important message: Failed to initialize Tencent Cloud Chat voting plugin, please log in first and then initialize.",
      );
    }
  }

  static Future<String> _getCurrentLoginUser() async {
    V2TimValueCallback<String> ruseres = await imManager.getLoginUser();
    return ruseres.data ?? "";
  }

  static bool isVoteMessage(V2TimMessage message) {
    bool isvote = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData["businessID"] == "group_poll") {
            isvote = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isvote;
  }

  static String getConversationLastMessageInfo(V2TimMessage message) {
    String info = "";
    if (isVoteMessage(message)) {
      info = "[投票]";
    }
    return info;
  }

  @override
  Future<Map<String, dynamic>> callMethod({required String methodName, String? data}) async {
    switch (methodName) {
      case "RenderVoteMessage":
        if (data != null) {
          return Map.from({
            "widget": TencentCloudChatVoteMessage(
              message: V2TimMessage.fromJson(json.decode(data)),
            )
          });
        }
    }
    return Map.from({});
  }

  @override
  TencentCloudChatPlugin getInstance() {
    return TencentCloudChatVotePlugin();
  }

  @override
  Future<Map<String, dynamic>> init(String? data) async {
    if (data != null) {}
    initPlugin();
    return Map.from({});
  }

  @override
  Future<Map<String, dynamic>> unInit(String? data) async {
    print("tencnet cloud chat vote ignore uninit");
    return Map.from({});
  }

  @override
  Future<Widget?> getWidget({required String methodName, Map<String, String>? data, Map<String, TencentCloudChatPluginTapFn>? fns}) async {
    if (methodName == "voteMessageItem") {
      if (data == null) {
        print("render vote message from plugin . the data is required");
        return Container();
      }
      var message = data["message"];
      if (message == null) {
        print("render vote message from plugin . the data.message is required");
        return Container();
      }
      return TencentCloudChatVoteMessage(
        message: V2TimMessage.fromJson(json.decode(message)),
        onTap: (option, data) {
          if (fns != null) {
            if (fns["onTap"] != null) {
              var onTapFn = fns["onTap"]!;
              onTapFn(Map<String, String>.from({
                "option": json.encode(option.toJson()),
                "data": message,
              }));
            }
          }
        },
      );
    }
    return null;
  }

  Map<String, dynamic> callMethodSync({
    required String methodName,
    String? data,
  }) {
    return Map.from({});
  }

  Widget? getWidgetSync({
    required String methodName,
    Map<String, String>? data,
    Map<String, TencentCloudChatPluginTapFn>? fns,
  }) {
    return null;
  }
}
