import 'package:tencent_cloud_chat_common/utils/face_manager.dart';

class TranslateUtils {
  static const String splitText = "split_result";
  static const String splitTextForTranslation = "split_translation";
  static const String splitTextIndexForTranslation = "split_translation_index";

  static Map<String, List<String>> splitTextByEmojiAndAtUsers(String text, List<String> userList) {
    if (text == null || text.isEmpty) {
      return {};
    }

    List<String> result = [];
    List<String> atUsers = [];
    if (userList != null && userList.isNotEmpty) {
      for (String user in userList) {
        String atUser = "@$user";
        atUsers.add(atUser);
      }
    }

    List<String> splitResultByAtUsers = splitByKeyList(atUsers, text);
    int textIndex = 0;
    List<String> needTranslationTextIndexList = [];
    for (int i = 0; i < splitResultByAtUsers.length; i++) {
      String splitString = splitResultByAtUsers[i];
      if (atUsers.isNotEmpty && atUsers.contains(splitString)) {
        result.add(splitString);
        textIndex++;
      } else {
        List<String> emojiKeyList = FaceManager.findEmojiKeyListFromText(splitString);
        if (emojiKeyList != null && emojiKeyList.isNotEmpty) {
          List<String> splitByEmojiResultList = splitByKeyList(emojiKeyList, splitString);
          for (int j = 0; j < splitByEmojiResultList.length; j++) {
            String splitStringByEmoji = splitByEmojiResultList[j];
            result.add(splitStringByEmoji);
            String emojiKey = "";
            if (emojiKeyList.isNotEmpty) {
              emojiKey = emojiKeyList[0];
            }

            if (emojiKey.isNotEmpty && splitStringByEmoji == emojiKey) {
              emojiKeyList.removeAt(0);
            } else if (splitStringByEmoji.trim().isNotEmpty) {
                needTranslationTextIndexList.add(textIndex.toString());
            }
            textIndex++;
          }
        } else {
          if (splitString.trim().isNotEmpty) {
            needTranslationTextIndexList.add(textIndex.toString());
          }
          result.add(splitString);
          textIndex++;
        }
      }
    }

    List<String> needTranslationTextList = [];
    for (int i = 0; i < needTranslationTextIndexList.length; i++) {
      int needTranslationIndex = int.parse(needTranslationTextIndexList[i]);
      needTranslationTextList.add(result[needTranslationIndex]);
    }
    Map<String, List<String>> resultMap = {
      splitText: result,
      splitTextForTranslation: needTranslationTextList,
      splitTextIndexForTranslation: needTranslationTextIndexList,
    };

    return resultMap;
  }

  static List<String> splitByKeyList(List<String> keyList, String text) {
    List<String> splitResultByKeyList = [];
    if (text == null || text.isEmpty) {
      return splitResultByKeyList;
    }

    if (keyList == null || keyList.isEmpty) {
      splitResultByKeyList.add(text);
      return splitResultByKeyList;
    }

    // 使用正则表达式创建模式
    String pattern = keyList.map((key) => RegExp.escape(key)).join('|');
    RegExp regExp = RegExp('($pattern)');

    // 使用正则表达式分割字符串
    List<String> result = text.split(regExp);

    var matches = regExp.allMatches(text);
    var matchList = matches.toList();
    // 重新插入关键字
    for (int i = 0; i < result.length; i++) {
      splitResultByKeyList.add(result[i]);
      if (i < matchList.length) {
        splitResultByKeyList.add(matchList[i].group(0)!);
      }
    }

    return splitResultByKeyList;
  }
}
