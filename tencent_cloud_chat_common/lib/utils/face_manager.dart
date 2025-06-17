import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'dart:core';

class FaceManager {
  static Map<String, String> emojiMap = {
    '[TUIEmoji_Smile]': tL10n.tuiEmojiSmile,
    '[TUIEmoji_Expect]': tL10n.tuiEmojiExpect,
    '[TUIEmoji_Blink]': tL10n.tuiEmojiBlink,
    '[TUIEmoji_Guffaw]': tL10n.tuiEmojiGuffaw,
    '[TUIEmoji_KindSmile]': tL10n.tuiEmojiKindSmile,
    '[TUIEmoji_Haha]': tL10n.tuiEmojiHaha,
    '[TUIEmoji_Cheerful]': tL10n.tuiEmojiCheerful,
    '[TUIEmoji_Speechless]': tL10n.tuiEmojiSpeechless,
    '[TUIEmoji_Amazed]': tL10n.tuiEmojiAmazed,
    '[TUIEmoji_Sorrow]': tL10n.tuiEmojiSorrow,
    '[TUIEmoji_Complacent]': tL10n.tuiEmojiComplacent,
    '[TUIEmoji_Silly]': tL10n.tuiEmojiSilly,
    '[TUIEmoji_Lustful]': tL10n.tuiEmojiLustful,
    '[TUIEmoji_Giggle]': tL10n.tuiEmojiGiggle,
    '[TUIEmoji_Kiss]': tL10n.tuiEmojiKiss,
    '[TUIEmoji_Wail]': tL10n.tuiEmojiWail,
    '[TUIEmoji_TearsLaugh]': tL10n.tuiEmojiTearsLaugh,
    '[TUIEmoji_Trapped]': tL10n.tuiEmojiTrapped,
    '[TUIEmoji_Mask]': tL10n.tuiEmojiMask,
    '[TUIEmoji_Fear]': tL10n.tuiEmojiFear,
    '[TUIEmoji_BareTeeth]': tL10n.tuiEmojiBareTeeth,
    '[TUIEmoji_FlareUp]': tL10n.tuiEmojiFlareUp,
    '[TUIEmoji_Yawn]': tL10n.tuiEmojiYawn,
    '[TUIEmoji_Tact]': tL10n.tuiEmojiTact,
    '[TUIEmoji_Stareyes]': tL10n.tuiEmojiStareyes,
    '[TUIEmoji_ShutUp]': tL10n.tuiEmojiShutUp,
    '[TUIEmoji_Sigh]': tL10n.tuiEmojiSigh,
    '[TUIEmoji_Hehe]': tL10n.tuiEmojiHehe,
    '[TUIEmoji_Silent]': tL10n.tuiEmojiSilent,
    '[TUIEmoji_Surprised]': tL10n.tuiEmojiSurprised,
    '[TUIEmoji_Askance]': tL10n.tuiEmojiAskance,
    '[TUIEmoji_Ok]': tL10n.tuiEmojiOk,
    '[TUIEmoji_Shit]': tL10n.tuiEmojiShit,
    '[TUIEmoji_Monster]': tL10n.tuiEmojiMonster,
    '[TUIEmoji_Daemon]': tL10n.tuiEmojiDaemon,
    '[TUIEmoji_Rage]': tL10n.tuiEmojiRage,
    '[TUIEmoji_Fool]': tL10n.tuiEmojiFool,
    '[TUIEmoji_Pig]': tL10n.tuiEmojiPig,
    '[TUIEmoji_Cow]': tL10n.tuiEmojiCow,
    '[TUIEmoji_Ai]': tL10n.tuiEmojiAi,
    '[TUIEmoji_Skull]': tL10n.tuiEmojiSkull,
    '[TUIEmoji_Bombs]': tL10n.tuiEmojiBombs,
    '[TUIEmoji_Coffee]': tL10n.tuiEmojiCoffee,
    '[TUIEmoji_Cake]': tL10n.tuiEmojiCake,
    '[TUIEmoji_Beer]': tL10n.tuiEmojiBeer,
    '[TUIEmoji_Flower]': tL10n.tuiEmojiFlower,
    '[TUIEmoji_Watermelon]': tL10n.tuiEmojiWatermelon,
    '[TUIEmoji_Rich]': tL10n.tuiEmojiRich,
    '[TUIEmoji_Heart]': tL10n.tuiEmojiHeart,
    '[TUIEmoji_Moon]': tL10n.tuiEmojiMoon,
    '[TUIEmoji_Sun]': tL10n.tuiEmojiSun,
    '[TUIEmoji_Star]': tL10n.tuiEmojiStar,
    '[TUIEmoji_RedPacket]': tL10n.tuiEmojiRedPacket,
    '[TUIEmoji_Celebrate]': tL10n.tuiEmojiCelebrate,
    '[TUIEmoji_Bless]': tL10n.tuiEmojiBless,
    '[TUIEmoji_Fortune]': tL10n.tuiEmojiFortune,
    '[TUIEmoji_Convinced]': tL10n.tuiEmojiConvinced,
    '[TUIEmoji_Prohibit]': tL10n.tuiEmojiProhibit,
    '[TUIEmoji_666]': tL10n.tuiEmoji666,
    '[TUIEmoji_857]': tL10n.tuiEmoji857,
    '[TUIEmoji_Knife]': tL10n.tuiEmojiKnife,
    '[TUIEmoji_Like]': tL10n.tuiEmojiLike,
  };

  static List<String> findEmojiKeyListFromText(String text) {
    if (text == null || text.isEmpty) {
      return [];
    }

    List<String> emojiKeyList = [];
    // TUIKit custom emoji.
    String regexOfCustomEmoji = "\\[(\\S+?)\\]";
    Pattern patternOfCustomEmoji = RegExp(regexOfCustomEmoji);
    Iterable<Match> matcherOfCustomEmoji = patternOfCustomEmoji.allMatches(text);

    for (Match match in matcherOfCustomEmoji) {
      String? emojiName = match.group(0);
      if (emojiName != null && emojiName.isNotEmpty) {
        emojiKeyList.add(emojiName);
      }
    }

    // Universal standard emoji.
    String regexOfUniversalEmoji = getRegexOfUniversalEmoji();
    Pattern patternOfUniversalEmoji = RegExp(regexOfUniversalEmoji);
    Iterable<Match> matcherOfUniversalEmoji = patternOfUniversalEmoji.allMatches(text);

    for (Match match in matcherOfUniversalEmoji) {
      String? emojiKey = match.group(0);
      if (text.isNotEmpty && emojiKey != null && emojiKey.isNotEmpty) {
        emojiKeyList.add(emojiKey);
      }
    }

    return emojiKeyList;
  }

  static String getRegexOfUniversalEmoji() {
    String ri = "[\\U0001F1E6-\\U0001F1FF]";
    // \u0023(#), \u002A(*), \u0030(keycap 0), \u0039(keycap 9), \u00A9(©), \u00AE(®) couldn't be added to NSString directly, need to transform a little bit.
    String support = "\\U000000A9|\\U000000AE|\\u203C|\\u2049|\\u2122|\\u2139|[\\u2194-\\u2199]|[\\u21A9-\\u21AA]|[\\u21B0-\\u21B1]|\\u21C4|\\u21C5|\\u21C8|[\\u21CD-\\u21CF]|\\u21D1|[\\u21D3-\\u21D4]|[\\u21E9-\\u21EA]|[\\u21F0-\\u21F5]|[\\u21F7-\\u21FA]|\\u21FD|\\u2702|\\u2705|[\\u2708-\\u270D]|\\u270F|\\u2712|\\u2714|\\u2716|\\u271D|\\u2721|\\u2728|[\\u2733-\\u2734]|\\u2744|\\u2747|\\u274C|\\u274E|[\\u2753-\\u2755]|\\u2757|[\\u2763-\\u2764]|[\\u2795-\\u2797]|\\u27A1|\\u27B0|\\u27BF|[\\u2934-\\u2935]|[\\u2B05-\\u2B07]|[\\u2B1B-\\u2B1C]|\\u2B50|\\u2B55|\\u3030|\\u303D|\\u3297|\\u3299|\\U0001F004|\\U0001F0CF|[\\U0001F170-\\U0001F171]|[\\U0001F17E-\\U0001F17F]|\\U0001F18E|[\\U0001F191-\\U0001F19A]|[\\U0001F1E6-\\U0001F1FF]|[\\U0001F201-\\U0001F202]|\\U0001F21A|\\U0001F22F|[\\U0001F232-\\U0001F23A]|[\\U0001F250-\\U0001F251]|[\\U0001F300-\\U0001F30F]|[\\U0001F310-\\U0001F31F]|[\\U0001F320-\\U0001F321]|[\\U0001F324-\\U0001F32F]|[\\U0001F330-\\U0001F33F]|[\\U0001F340-\\U0001F34F]|[\\U0001F350-\\U0001F35F]|[\\U0001F360-\\U0001F36F]|[\\U0001F370-\\U0001F37F]|[\\U0001F380-\\U0001F38F]|[\\U0001F390-\\U0001F393]|[\\U0001F396-\\U0001F397]|[\\U0001F399-\\U0001F39B]|[\\U0001F39E-\\U0001F39F]|[\\U0001F3A0-\\U0001F3AF]|[\\U0001F3B0-\\U0001F3BF]|[\\U0001F3C0-\\U0001F3CF]|[\\U0001F3D0-\\U0001F3DF]|[\\U0001F3E0-\\U0001F3EF]|\\U0001F3F0|[\\U0001F3F3-\\U0001F3F5]|[\\U0001F3F7-\\U0001F3FF]|[\\U0001F400-\\U0001F40F]|[\\U0001F410-\\U0001F41F]|[\\U0001F420-\\U0001F42F]|[\\U0001F430-\\U0001F43F]|[\\U0001F440-\\U0001F44F]|[\\U0001F450-\\U0001F45F]|[\\U0001F460-\\U0001F46F]|[\\U0001F470-\\U0001F47F]|[\\U0001F480-\\U0001F48F]|[\\U0001F490-\\U0001F49F]|[\\U0001F4A0-\\U0001F4AF]|[\\U0001F4B0-\\U0001F4BF]|[\\U0001F4C0-\\U0001F4CF]|[\\U0001F4D0-\\U0001F4DF]|[\\U0001F4E0-\\U0001F4EF]|[\\U0001F4F0-\\U0001F4FF]|[\\U0001F500-\\U0001F50F]|[\\U0001F510-\\U0001F51F]|[\\U0001F520-\\U0001F52F]|[\\U0001F530-\\U0001F53D]|[\\U0001F549-\\U0001F54E]|[\\U0001F550-\\U0001F55F]|[\\U0001F560-\\U0001F567]|\\U0001F56F|\\U0001F570|[\\U0001F573-\\U0001F57A]|\\U0001F587|[\\U0001F58A-\\U0001F58D]|\\U0001F590|[\\U0001F595-\\U0001F596]|[\\U0001F5A4-\\U0001F5A5]|\\U0001F5A8|[\\U0001F5B1-\\U0001F5B2]|\\U0001F5BC|[\\U0001F5C2-\\U0001F5C4]|[\\U0001F5D1-\\U0001F5D3]|[\\U0001F5DC-\\U0001F5DE]|\\U0001F5E1|\\U0001F5E3|\\U0001F5E8|\\U0001F5EF|\\U0001F5F3|[\\U0001F5FA-\\U0001F5FF]|[\\U0001F600-\\U0001F60F]|[\\U0001F610-\\U0001F61F]|[\\U0001F620-\\U0001F62F]|[\\U0001F630-\\U0001F63F]|[\\U0001F640-\\U0001F64F]|[\\U0001F650-\\U0001F65F]|[\\U0001F660-\\U0001F66F]|[\\U0001F670-\\U0001F67F]|[\\U0001F680-\\U0001F68F]|[\\U0001F690-\\U0001F69F]|[\\U0001F6A0-\\U0001F6AF]|[\\U0001F6B0-\\U0001F6BF]|[\\U0001F6C0-\\U0001F6C5]|[\\U0001F6CB-\\U0001F6CF]|[\\U0001F6D0-\\U0001F6D2]|[\\U0001F6D5-\\U0001F6D7]|[\\U0001F6DD-\\U0001F6DF]|[\\U0001F6E0-\\U0001F6E5]|\\U0001F6E9|[\\U0001F6EB-\\U0001F6EC]|\\U0001F6F0|[\\U0001F6F3-\\U0001F6FC]|[\\U0001F7E0-\\U0001F7EB]|\\U0001F7F0|[\\U0001F90C-\\U0001F90F]|[\\U0001F910-\\U0001F91F]|[\\U0001F920-\\U0001F92F]|[\\U0001F930-\\U0001F93A]|[\\U0001F93C-\\U0001F93F]|[\\U0001F940-\\U0001F945]|[\\U0001F947-\\U0001F94C]|[\\U0001F94D-\\U0001F94F]|[\\U0001F950-\\U0001F95F]|[\\U0001F960-\\U0001F96F]|[\\U0001F970-\\U0001F97F]|[\\U0001F980-\\U0001F98F]|[\\U0001F990-\\U0001F99F]|[\\U0001F9A0-\\U0001F9AF]|[\\U0001F9B0-\\U0001F9BF]|[\\U0001F9C0-\\U0001F9CF]|[\\U0001F9D0-\\U0001F9DF]|[\\U0001F9E0-\\U0001F9EF]|[\\U0001F9F0-\\U0001F9FF]|[\\U0001FA70-\\U0001FA74]|[\\U0001FA78-\\U0001FA7C]|[\\U0001FA80-\\U0001FA86]|[\\U0001FA90-\\U0001FA9F]|[\\U0001FAA0-\\U0001FAAC]|[\\U0001FAB0-\\U0001FABA]|[\\U0001FAC0-\\U0001FAC5]|[\\U0001FAD0-\\U0001FAD9]|[\\U0001FAE0-\\U0001FAE7]|[\\U0001FAF0-\\U0001FAF6]";
    String unsupport = "\\u0023|\\u002A|[\\u0030-\\u0039]|";
    String emoji = unsupport + support;

    // Construct regex of emoji by the rules above.
    String eMod = "[\\U0001F3FB-\\U0001F3FF]";

    String variationSelector = "\\uFE0F";
    String keycap = "\\u20E3";
    String tags = "[\\U000E0020-\\U000E007E]";
    String termTag = "\\U000E007F";
    String zwj = "\\u200D";

    String risequence = "[$ri][$ri]";
    String element = "[$emoji]([$eMod]|$variationSelector$keycap?|[$tags]+$termTag?)?";
    String regexEmoji = "$risequence|$element($zwj($risequence|$element))*";

    return regexEmoji;
  }
}