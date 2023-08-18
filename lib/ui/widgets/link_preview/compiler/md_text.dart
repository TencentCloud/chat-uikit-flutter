import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/emoji_text.dart';
import 'package:tim_ui_kit_sticker_plugin/utils/tim_custom_face_data.dart';

RegExp emojiExp = RegExp(r'\[([\u4e00-\u9fa5A-Za-z0-9]+)\]');

String mdTextCompiler(String originalText, {
  bool isUseQQPackage = false,
  bool isUseTencentCloudChatPackage = false,
  List<CustomEmojiFaceData> customEmojiStickerList = const [],
}) {
  String text = originalText;
  final EmojiUtil emojiUtil = EmojiUtil(
      isUseTencentCloudChatPackage: isUseTencentCloudChatPackage,
      isUseQQPackage: isUseQQPackage,
      customEmojiStickerList: customEmojiStickerList);

  text = text.replaceAllMapped(emojiExp, (match) {
    String key = match.group(0)!;

    // Check if the emoji exists in the emoji map
    if (emojiUtil.emojiMap.containsKey(key)) {
      String assetPath = emojiUtil.emojiMap[key]!;
      return '![sticker](resource:$assetPath#22x22)';
    }
    return key;
  });

  return text;
}