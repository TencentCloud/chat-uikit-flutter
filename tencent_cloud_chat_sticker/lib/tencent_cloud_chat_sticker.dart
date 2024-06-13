library tencent_cloud_chat_sticker;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_default.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_init_data.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_model.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_utils.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_version_info.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_widget.dart';

class TencentCloudChatStickerPluginExpWidgetName {
  static const String stickerPannel = "stickerPannel";
  static const String getStickerWidgetForMessageItem = "getStickerWidgetForMessageItem";
}

class TencentCloudChatStickerPluginExpMethodName {
  static const String replaceTextToMarkDownData = "replaceTextToMarkDownData";
  static const String getStickerAssetsFromText = "getStickerAssetsFromText";
  static const String getAssetImagePathByName = "getAssetImagePathByName";
}

class TencentCloudChatStickerPlugin extends TencentCloudChatPlugin {
  static TencentCloudChatStickerInitData initData = TencentCloudChatStickerInitData();

  @override
  Future<Map<String, dynamic>> callMethod({required String methodName, String? data}) async {
    if (methodName == TencentCloudChatStickerPluginExpMethodName.replaceTextToMarkDownData) {
      RegExp emojiExp = RegExp(r"\[TUIEmoji_(\w{2,})\]");
      String text = data ?? "";
      text = text.replaceAllMapped(emojiExp, (match) {
        String emojiName = match.group(0) ?? "";
        if (emojiName.isNotEmpty) {
          if (tencentCloudChatStickerDefault.containsValue(emojiName)) {
            tencentCloudChatStickerDefault.forEach((emojiAssets, value) {
              if (value == emojiName) {
                emojiName = '![$value](resource:$emojiAssets#30x30)';
              }
            });
          }
        }
        return emojiName;
      });
      return {
        "text": text,
      };
    }
    return {};
  }

  late BuildContext buildContext;

  TencentCloudChatStickerPlugin._internal();
  factory TencentCloudChatStickerPlugin({
    required BuildContext context,
  }) {
    _instance.buildContext = context;
    return _instance;
  }

  static final TencentCloudChatStickerPlugin _instance = TencentCloudChatStickerPlugin._internal();

  @override
  TencentCloudChatPlugin getInstance() {
    return _instance;
  }

  @override
  Future<Widget?> getWidget({
    required String methodName,
    Map<String, String>? data,
    Map<String, TencentCloudChatPluginTapFn>? fns,
  }) async {
    if (methodName == TencentCloudChatStickerPluginExpWidgetName.stickerPannel) {
      return const TencentCloudChatStickerPannel();
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> init(String? data) async {
    var hint = "The userID key must be passed in the initData map to ensure that TencentCloudChatStickerPlugin knows who is using this plugin.";
    var type = TencentCloudChatStickerUtils.getDeviceType(buildContext);
    if (data != null) {
      initData = TencentCloudChatStickerInitData.fromJson(json.decode(data));
      var hasUserID = true;
      if (initData.userID == null) {
        hasUserID = false;
      } else {
        if (initData.userID!.isEmpty) {
          hasUserID = false;
        }
      }
      if (!hasUserID) {
        TencentCloudChatStickerUtils.log(hint);
        return initData.toJson();
      }

      if (initData.useDefaultCustomFace_4350 == true) {
        // add default sticker to sticker list;
        List<TencentCloudChatCustomStickerItem> stickers = [];
        tencentCloudChatStickerCustomFace4350.forEach((key, value) {
          stickers.add(
            TencentCloudChatCustomStickerItem(name: value, path: key),
          );
        });
        initData.customStickerLists ??= [];
        initData.customStickerLists!.insert(
          0,
          TencentCloudChatCustomSticker(
            name: "",
            stickers: stickers,
            iconPath: tencentCloudChatStickerCustomFace4350.keys.first,
            type: 1,
            rowNum: type == StickerDeviceScreenType.mobile ? 4 : 8,
            iconSize: 30,
            index: 1,
          ),
        );
      }
      if (initData.useDefaultCustomFace_4351 == true) {
        // add default sticker to sticker list;
        List<TencentCloudChatCustomStickerItem> stickers = [];
        tencentCloudChatStickerCustomFace4351.forEach((key, value) {
          stickers.add(
            TencentCloudChatCustomStickerItem(name: value, path: key),
          );
        });
        initData.customStickerLists ??= [];
        initData.customStickerLists!.insert(
          0,
          TencentCloudChatCustomSticker(
            name: "",
            stickers: stickers,
            iconPath: tencentCloudChatStickerCustomFace4351.keys.first,
            type: 1,
            iconSize: 30,
            rowNum: type == StickerDeviceScreenType.mobile ? 4 : 8,
            index: 2,
          ),
        );
      }
      if (initData.useDefaultCustomFace_4352 == true) {
        // add default sticker to sticker list;
        List<TencentCloudChatCustomStickerItem> stickers = [];
        tencentCloudChatStickerCustomFace4352.forEach((key, value) {
          stickers.add(
            TencentCloudChatCustomStickerItem(name: value, path: key),
          );
        });
        initData.customStickerLists ??= [];
        initData.customStickerLists!.insert(
          0,
          TencentCloudChatCustomSticker(
            name: "",
            stickers: stickers,
            iconPath: tencentCloudChatStickerCustomFace4352.keys.first,
            type: 1,
            iconSize: 30,
            rowNum: type == StickerDeviceScreenType.mobile ? 4 : 6,
            index: 3,
          ),
        );
      }
      if (initData.useDefaultSticker == true) {
        // add default sticker to sticker list;
        List<TencentCloudChatCustomStickerItem> stickers = [];
        tencentCloudChatStickerDefault.forEach((key, value) {
          stickers.add(
            TencentCloudChatCustomStickerItem(name: value, path: key),
          );
        });
        initData.customStickerLists ??= [];
        initData.customStickerLists!.insert(
          0,
          TencentCloudChatCustomSticker(
            name: "所有表情",
            stickers: stickers,
            iconPath: tencentCloudChatStickerDefault.keys.first,
            type: 0,
            rowNum: type == StickerDeviceScreenType.mobile ? 7 : 10,
            index: 0,
          ),
        );
      }
      TencentCloudChatStickerUtils.log("Init success. Info ${json.encode(
        initData.toJson(),
      )} ${json.encode(
        TencentCloudChatStickerVersionInfo().toJson(),
      )}");
    } else {
      TencentCloudChatStickerUtils.log(hint);
    }
    return initData.toJson();
  }

  @override
  Future<Map<String, dynamic>> unInit(String? data) async {
    TencentCloudChatStickerUtils.log("this plugin not need to unInit");
    return initData.toJson();
  }

  @override
  Map<String, dynamic> callMethodSync({required String methodName, String? data}) {
    if (methodName == TencentCloudChatStickerPluginExpMethodName.getStickerAssetsFromText) {
      if (data != null) {
        RegExp emojiExp = RegExp(r"\[TUIEmoji_(\w{2,})\]");
        String text = data;
        bool hasEmoji = false;
        text = text.replaceAllMapped(emojiExp, (match) {
          String emojiName = match.group(0) ?? "";
          if (emojiName.isNotEmpty) {
            if (tencentCloudChatStickerDefault.containsValue(emojiName)) {
              tencentCloudChatStickerDefault.forEach((emojiAssets, value) {
                if (value == emojiName) {
                  emojiName = emojiAssets;
                  hasEmoji = true;
                }
              });
            }
          }
          return emojiName;
        });
        return {
          "text": text,
          "hasEmoji": hasEmoji,
        };
      }
    } else if (methodName == TencentCloudChatStickerPluginExpMethodName.getAssetImagePathByName) {
      String res = "";
      if (data != null) {
        String emojiName = data;
        if (tencentCloudChatStickerDefault.containsValue(emojiName)) {
          tencentCloudChatStickerDefault.forEach((emojiAssets, value) {
            if (value == emojiName) {
              res = emojiAssets;
            }
          });
        }
      }
      return {
        "emojiAssets": res,
      };
    } else if (methodName == TencentCloudChatStickerPluginExpMethodName.replaceTextToMarkDownData) {
      RegExp emojiExp = RegExp(r"\[TUIEmoji_(\w{2,})\]");
      String text = data ?? "";
      text = text.replaceAllMapped(emojiExp, (match) {
        String emojiName = match.group(0) ?? "";
        if (emojiName.isNotEmpty) {
          if (tencentCloudChatStickerDefault.containsValue(emojiName)) {
            tencentCloudChatStickerDefault.forEach((emojiAssets, value) {
              if (value == emojiName) {
                emojiName = '![$value](resource:$emojiAssets#30x30)';
              }
            });
          }
        }
        return emojiName;
      });
      return {
        "text": text,
      };
    }
    return {};
  }

  @override
  Widget? getWidgetSync({required String methodName, Map<String, String>? data, Map<String, TencentCloudChatPluginTapFn>? fns}) {
    if (methodName == TencentCloudChatStickerPluginExpWidgetName.getStickerWidgetForMessageItem) {
      if (data == null) {
        return null;
      }
      if (data.containsKey("index") && data.containsKey('data')) {
        var index = int.parse(data['index'] ?? "0");
        var dataStr = data['data'] ?? "";
        if (initData.customStickerLists != null) {
          int sindex = initData.customStickerLists!.indexWhere((element) => element.index == index);
          if (sindex > -1) {
            TencentCloudChatCustomSticker stickerStruct = initData.customStickerLists![sindex];

            int psindex = stickerStruct.stickers.indexWhere((element) => element.name.contains(dataStr));
            if (psindex > -1) {
              TencentCloudChatCustomStickerItem p = stickerStruct.stickers[psindex];
              return Image(
                image: AssetImage(
                  p.path,
                  package: "tencent_cloud_chat_sticker",
                ),
                width: 100,
              );
            }
          }
        }
      } else {
        TencentCloudChatStickerUtils.log("the getWidget method api ${TencentCloudChatStickerPluginExpWidgetName.getStickerWidgetForMessageItem} is not called correctly. you must contain the index and data keys at the same time.");
        return null;
      }
    }
    return null;
  }
}
