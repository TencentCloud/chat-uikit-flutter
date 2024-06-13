class TencentCloudChatStickerVersionInfo {
  static const String name = "TencentCloudChatStickerPlugin";
  static const String author = "xingchenhe@tencent.com";
  static const String description = "tencent cloud chat sticker plugin";
  static const String version = "1.0.0";

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "name": name,
      "author": author,
      "description": description,
      "version": version,
    });
  }
}
