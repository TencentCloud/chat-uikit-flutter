class TencentCloudChatCustomStickerItem {
  String path = "";
  String name = "";

  TencentCloudChatCustomStickerItem({
    required this.name,
    required this.path,
  });
  static TencentCloudChatCustomStickerItem fromJson(json) {
    return TencentCloudChatCustomStickerItem(name: json["name"] ?? "", path: json["path"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "name": name,
      "path": path,
    });
  }
}

class TencentCloudChatCustomSticker {
  String name = "";
  List<TencentCloudChatCustomStickerItem> stickers = [];
  int rowNum = 7;
  String iconPath = "";
  double? iconSize = 40;
  int type = 0; // 0 default 1 custom
  int index = 0;

  TencentCloudChatCustomSticker({
    required this.iconPath,
    required this.stickers,
    required this.rowNum,
    required this.name,
    required this.type,
    required this.index,
    this.iconSize,
  });

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "name": name,
      "stickers": stickers.map((e) => e.toJson()).toList(),
      "iconPath": iconPath,
      "rowNum": rowNum,
      "type": type,
      "index": index,
      "iconSize": iconSize,
    });
  }

  static TencentCloudChatCustomSticker fromJson(json) {
    return TencentCloudChatCustomSticker(
      name: json["name"] ?? "",
      stickers: (List<Map<String, dynamic>>.from((json["stickers"] ?? []))).map((e) => TencentCloudChatCustomStickerItem.fromJson(e)).toList(),
      iconPath: json["iconPath"] ?? "",
      rowNum: json["rowNum"] ?? 7,
      type: json["type"] ?? 0,
      index: json["index"] ?? 0,
      iconSize: json["iconSize"] ?? 40,
    );
  }
}
