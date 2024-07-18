library tencent_cloud_chat_message_reaction;

import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:tencent_cloud_chat_message_reaction/data/message_reaction_data.dart';
import 'package:tencent_cloud_chat_message_reaction/widgets/reaction_list/reaction_list_item.dart';
import 'package:tencent_cloud_chat_message_reaction/widgets/reaction_list/reaction_list.dart';
import 'package:tencent_cloud_chat_message_reaction/widgets/reaction_selector/reaction_selector_panel.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_reaction.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sdk/utils/utils.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_default.dart';

class TencentCloudChatMessageReactionPluginExpWidgetName {
  static const String messageReactionItem = "messageReactionItem";
  static const String messageReactionList = "messageReactionList";
  static const String messageReactionSelector = "messageReactionSelector";
}

class TencentCloudChatMessageReactionPluginExpMethodName {
  static const String getMessageReactions = "getMessageReactions";
}

class TencentCloudChatMessageReaction extends TencentCloudChatPlugin {
  late BuildContext buildContext;

  static final TencentCloudChatMessageReaction _instance = TencentCloudChatMessageReaction._internal();

  static TencentCloudChatMessageReaction get instance => _instance;

  TencentCloudChatMessageReaction._internal();

  factory TencentCloudChatMessageReaction({
    required BuildContext context,
  }) {
    _instance.buildContext = context;
    return _instance;
  }

  final TencentCloudChatMessageReactionData reactionData = TencentCloudChatMessageReactionData();

  @override
  Future<Map<String, dynamic>> callMethod({required String methodName, String? data}) async {
    if (methodName == TencentCloudChatMessageReactionPluginExpMethodName.getMessageReactions && data != null) {
      final dataJson = json.decode(data);
      final List<dynamic> msgIDList = dataJson['msgIDList'];
      final List<String> msgIDListString = msgIDList.map((e) => e.toString()).toList();

      final List<dynamic> webMessageInstanceList = dataJson['webMessageInstanceList'];
      final List<String> webMessageInstanceListString = webMessageInstanceList.map((e) => e.toString()).toList();
      await reactionData.loadMessageReactions(
        msgIDList: msgIDListString,
        webMessageInstanceList: webMessageInstanceListString,
      );
      return {};
    }
    return {};
  }

  @override
  Map<String, dynamic> callMethodSync({required String methodName, String? data}) {
    return {};
  }

  @override
  TencentCloudChatPlugin getInstance() {
    return _instance;
  }

  @override
  Future<Widget?> getWidget(
      {required String methodName, Map<String, String>? data, Map<String, TencentCloudChatPluginTapFn>? fns}) async {
    if (methodName == TencentCloudChatMessageReactionPluginExpWidgetName.messageReactionItem) {
      return null;
    }
    return null;
  }

  @override
  Widget? getWidgetSync(
      {required String methodName, Map<String, String>? data, Map<String, TencentCloudChatPluginTapFn>? fns}) {
    if (methodName == TencentCloudChatMessageReactionPluginExpWidgetName.messageReactionItem && data != null) {
      final json = Utils.formatJson(data);
      return TencentCloudChatMessageReactionItem(
        msgID: json["msgID"],
        messageReaction: V2TimMessageReaction.fromJson(jsonDecode(json["messageReaction"])),
        primaryColor: int.parse(json["primaryColor"]),
        borderColor: int.parse(json["borderColor"]),
        textColor: int.parse(json["textColor"]),
      );
    } else if (methodName == TencentCloudChatMessageReactionPluginExpWidgetName.messageReactionList && data != null) {
      final json = Utils.formatJson(data);
      return TencentCloudChatMessageReactionList(
        msgID: json["msgID"],
        primaryColor: int.parse(json["primaryColor"]),
        borderColor: int.parse(json["borderColor"]),
        textColor: int.parse(json["textColor"]),
        platformMode: json["platformMode"],
      );
    } else if (methodName == TencentCloudChatMessageReactionPluginExpWidgetName.messageReactionSelector &&
        data != null) {
      final json = Utils.formatJson(data);
      return TencentCloudMessageReactionSelectorPanel(
        msgID: json["msgID"],
        backgroundColor: int.parse(json["backgroundColor"]),
        borderColor: int.parse(json["borderColor"]),
        platformMode: json["platformMode"],
      );
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> init(String? data) async {
    reactionData.init();
    tencentCloudChatStickerDefault.forEach((key, value) {
      reactionData.messageReactionLabelToAsset[value] = key;
      reactionData.messageReactionStickerList.add(value);
    });

    final sortOrder = {
      "[TUIEmoji_Like]": 1,
      "[TUIEmoji_Celebrate]": 2,
      "[TUIEmoji_Heart]": 3,
      "[TUIEmoji_Ok]": 4,
      "[TUIEmoji_Flower]": 5,
      "[TUIEmoji_Pig]": 6
    };

    reactionData.messageReactionStickerList.sort((a, b) {
      final orderA = sortOrder[a] ?? double.maxFinite.toInt();
      final orderB = sortOrder[b] ?? double.maxFinite.toInt();
      return orderA - orderB;
    });
    return Map<String, dynamic>.from({});
  }

  @override
  Future<Map<String, dynamic>> unInit(String? data) async {
    return Map<String, dynamic>.from({});
  }
}
