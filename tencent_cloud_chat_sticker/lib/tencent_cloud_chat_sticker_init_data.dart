import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_model.dart';

class TencentCloudChatStickerInitData {
  String? userID = "";
  bool? useDefaultSticker = true;
  bool? useDefaultCustomFace_4350 = true;
  bool? useDefaultCustomFace_4351 = true;
  bool? useDefaultCustomFace_4352 = true;

  List<TencentCloudChatCustomSticker>? customStickerLists = [];

  TencentCloudChatStickerInitData({
    this.userID,
    this.useDefaultSticker,
    this.customStickerLists,
    this.useDefaultCustomFace_4350,
    this.useDefaultCustomFace_4351,
    this.useDefaultCustomFace_4352,
  });

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "userID": userID ?? "",
      "useDefaultSticker": useDefaultSticker ?? true,
      "customStickerLists": (customStickerLists ?? []).map((e) => e.toJson()).toList(),
      "useDefaultCustomFace_4350": useDefaultCustomFace_4350 ?? true,
      "useDefaultCustomFace_4351": useDefaultCustomFace_4351 ?? true,
      "useDefaultCustomFace_4352": useDefaultCustomFace_4352 ?? true,
    });
  }

  static TencentCloudChatStickerInitData fromJson(Map<String, dynamic> json) {
    return TencentCloudChatStickerInitData(
      userID: json["userID"] ?? "",
      useDefaultSticker: json["useDefaultSticker"] ?? true,
      customStickerLists: (List<Map<String, dynamic>>.from(json["customStickerLists"] ?? [])).map((e) => TencentCloudChatCustomSticker.fromJson(e)).toList(),
      useDefaultCustomFace_4350: json["useDefaultCustomFace_4350"] ?? true,
      useDefaultCustomFace_4351: json["useDefaultCustomFace_4351"] ?? true,
      useDefaultCustomFace_4352: json["useDefaultCustomFace_4352"] ?? true,
    );
  }
}
