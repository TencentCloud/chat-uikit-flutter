import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_setting_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/emoji_text.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_at_text.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field_layout/narrow.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field_layout/wide.dart';

enum MuteStatus { none, me, all }

typedef CustomStickerPanel = Widget Function({
  void Function() sendTextMessage,
  void Function(int index, String data) sendFaceMessage,
  void Function() deleteText,
  void Function(int unicode) addText,
  void Function(String singleEmojiName) addCustomEmojiText,
  List<CustomEmojiFaceData> defaultCustomEmojiStickerList,

  /// If non-null, requires the child to have exactly this width.
  double? width,

  /// If non-null, requires the child to have exactly this height.
  double? height,
});

class TIMUIKitInputTextField extends StatefulWidget {
  /// conversation id
  final String conversationID;

  final TIMUIKitChatConfig? chatConfig;

  /// conversation type
  final ConvType conversationType;

  /// init text, use for draft text re-view
  final String? initText;

  /// messageList widget scroll controller
  final AutoScrollController? scrollController;

  /// messageList widget scroll controller
  final AutoScrollController? atMemberPanelScroll;

  /// hint text for textField widget
  final String? hintText;

  /// config for more panel
  final MorePanelConfig? morePanelConfig;

  /// show send audio icon
  final bool showSendAudio;

  /// show send emoji icon
  final bool showSendEmoji;

  /// show more panel
  final bool showMorePanel;

  /// background color
  final Color? backgroundColor;

  /// control input field behavior
  final TIMUIKitInputTextFieldController? controller;

  /// on text changed
  final void Function(String)? onChanged;

  final TUIChatSeparateViewModel model;

  /// Whether to use the default emoji
  final bool isUseDefaultEmoji;

  final List<CustomEmojiFaceData> customEmojiStickerList;

  /// sticker panel customization
  final CustomStickerPanel? customStickerPanel;

  /// Conversation need search
  final V2TimConversation currentConversation;

  final String? groupType;

  final String? groupID;

  const TIMUIKitInputTextField(
      {Key? key,
      required this.conversationID,
      required this.conversationType,
      this.initText,
      this.hintText,
      this.scrollController,
      this.morePanelConfig,
      this.customStickerPanel,
      this.showSendAudio = true,
      this.showSendEmoji = true,
      this.showMorePanel = true,
      this.backgroundColor,
      this.controller,
      this.onChanged,
      this.isUseDefaultEmoji = false,
      this.customEmojiStickerList = const [],
      required this.model,
      required this.currentConversation,
      this.groupType,
      this.atMemberPanelScroll,
      this.groupID,
      this.chatConfig})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends TIMUIKitState<TIMUIKitInputTextField> {
  final TUIChatGlobalModel globalModel = serviceLocator<TUIChatGlobalModel>();
  final TUISettingModel settingModel = serviceLocator<TUISettingModel>();
  final RegExp atTextReg = RegExp(r'@([^@\s]*)');
  late FocusNode focusNode;
  String zeroWidthSpace = '\ufeff';
  String lastText = "";
  String languageType = "";
  int? currentCursor;
  bool isAddingAtSearchWords = false;
  double inputWidth = 900;
  Map<String, V2TimGroupMemberFullInfo> mentionedMembersMap = {};
  late TextEditingController textEditingController;
  final TUIConversationViewModel conversationModel = serviceLocator<TUIConversationViewModel>();
  final TUISelfInfoViewModel selfModel = serviceLocator<TUISelfInfoViewModel>();
  MuteStatus muteStatus = MuteStatus.none;
  bool _isComposingText = false;
  int latestSendEditStatusTime = DateTime.now().millisecondsSinceEpoch;
  List<CustomStickerPackage> stickerPackageList = [];

  generateStickerList() {
    if (widget.customStickerPanel != null) {
      // Keep using original scheme.
      return;
    }
    final stickerConfig = widget.model.chatConfig.stickerPanelConfig ?? StickerPanelConfig();
    if (stickerConfig.useTencentCloudChatStickerPackage) {
      final tccEmojiSet = TUIKitStickerConstData.emojiList.firstWhere((element) => element.name == "tcc1");
      stickerPackageList.add(CustomStickerPackage(
          name: tccEmojiSet.name,
          baseUrl: "assets/custom_face_resource/${tccEmojiSet.name}",
          isEmoji: tccEmojiSet.isEmoji,
          isDefaultEmoji: true,
          stickerList: tccEmojiSet.list.asMap().keys.map((idx) => CustomSticker(index: idx, name: tccEmojiSet.list[idx])).toList(),
          menuItem: CustomSticker(
            index: 0,
            name: tccEmojiSet.icon,
          )));
    }
    if (stickerConfig.useQQStickerPackage) {
      final qqEmojiSet = TUIKitStickerConstData.emojiList.firstWhere((element) => element.name == "4349");
      stickerPackageList.add(CustomStickerPackage(
          name: qqEmojiSet.name,
          baseUrl: "assets/custom_face_resource/${qqEmojiSet.name}",
          isEmoji: qqEmojiSet.isEmoji,
          isDefaultEmoji: true,
          stickerList: qqEmojiSet.list.asMap().keys.map((idx) => CustomSticker(index: idx, name: qqEmojiSet.list[idx])).toList(),
          menuItem: CustomSticker(
            index: 0,
            name: qqEmojiSet.icon,
          )));
    }
    if (stickerConfig.unicodeEmojiList.isNotEmpty) {
      final defEmojiList = TUIKitStickerConstData.defaultUnicodeEmojiList.map((emojiItem) {
        return CustomSticker(index: 0, name: emojiItem.toString(), unicode: emojiItem);
      }).toList();
      stickerPackageList.add(CustomStickerPackage(name: "defaultEmoji", stickerList: defEmojiList, menuItem: defEmojiList[0]));
    }
    stickerPackageList.addAll(stickerConfig.customStickerPackages);

    return stickerPackageList;
  }

  setCurrentCursor(int? value) {
    currentCursor = value;
  }

  RegExp emojiRegex() => RegExp(
      r'[#*0-9]\uFE0F?\u20E3|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26AA\u26B0\u26B1\u26BD\u26BE\u26C4\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0-\u26F5\u26F7\u26F8\u26FA\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2757\u2763\u27A1\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B55\u3030\u303D\u3297\u3299]\uFE0F?|[\u261D\u270C\u270D](?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?|[\u270A\u270B](?:\uD83C[\uDFFB-\uDFFF])?|[\u23E9-\u23EC\u23F0\u23F3\u25FD\u2693\u26A1\u26AB\u26C5\u26CE\u26D4\u26EA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2795-\u2797\u27B0\u27BF\u2B50]|\u26F9(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|\u2764\uFE0F?(?:\u200D(?:\uD83D\uDD25|\uD83E\uDE79))?|\uD83C(?:[\uDC04\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]\uFE0F?|[\uDF85\uDFC2\uDFC7](?:\uD83C[\uDFFB-\uDFFF])?|[\uDFC3\uDFC4\uDFCA](?:\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDFCB\uDFCC](?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uDDE6\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF]|\uDDE7\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF]|\uDDE8\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF]|\uDDE9\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF]|\uDDEA\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA]|\uDDEB\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7]|\uDDEC\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE]|\uDDED\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA]|\uDDEE\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9]|\uDDEF\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5]|\uDDF0\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF]|\uDDF1\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE]|\uDDF2\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF]|\uDDF3\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF]|\uDDF4\uD83C\uDDF2|\uDDF5\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE]|\uDDF6\uD83C\uDDE6|\uDDF7\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC]|\uDDF8\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF]|\uDDF9\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF]|\uDDFA\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF]|\uDDFB\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA]|\uDDFC\uD83C[\uDDEB\uDDF8]|\uDDFD\uD83C\uDDF0|\uDDFE\uD83C[\uDDEA\uDDF9]|\uDDFF\uD83C[\uDDE6\uDDF2\uDDFC]|\uDFF3\uFE0F?(?:\u200D(?:\u26A7\uFE0F?|\uD83C\uDF08))?|\uDFF4(?:\u200D\u2620\uFE0F?|\uDB40\uDC67\uDB40\uDC62\uDB40(?:\uDC65\uDB40\uDC6E\uDB40\uDC67|\uDC73\uDB40\uDC63\uDB40\uDC74|\uDC77\uDB40\uDC6C\uDB40\uDC73)\uDB40\uDC7F)?)|\uD83D(?:[\uDC08\uDC26](?:\u200D\u2B1B)?|[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3]\uFE0F?|[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDC8F\uDC91\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC](?:\uD83C[\uDFFB-\uDFFF])?|[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6](?:\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDD74\uDD90](?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?|[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC25\uDC27-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDC8E\uDC90\uDC92-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE2D\uDE2F-\uDE34\uDE37-\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEDC-\uDEDF\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB\uDFF0]|\uDC15(?:\u200D\uD83E\uDDBA)?|\uDC3B(?:\u200D\u2744\uFE0F?)?|\uDC41\uFE0F?(?:\u200D\uD83D\uDDE8\uFE0F?)?|\uDC68(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D(?:[\uDC68\uDC69]\u200D\uD83D(?:\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?)|[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?)|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C(?:\uDFFB(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFC-\uDFFF])))?|\uDFFC(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB\uDFFD-\uDFFF])))?|\uDFFD(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])))?|\uDFFE(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB-\uDFFD\uDFFF])))?|\uDFFF(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?\uDC68\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D\uDC68\uD83C[\uDFFB-\uDFFE])))?))?|\uDC69(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:\uDC8B\u200D\uD83D)?[\uDC68\uDC69]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D(?:[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?|\uDC69\u200D\uD83D(?:\uDC66(?:\u200D\uD83D\uDC66)?|\uDC67(?:\u200D\uD83D[\uDC66\uDC67])?))|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C(?:\uDFFB(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFC-\uDFFF])))?|\uDFFC(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB\uDFFD-\uDFFF])))?|\uDFFD(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])))?|\uDFFE(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFD\uDFFF])))?|\uDFFF(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D\uD83D(?:[\uDC68\uDC69]|\uDC8B\u200D\uD83D[\uDC68\uDC69])\uD83C[\uDFFB-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83D[\uDC68\uDC69]\uD83C[\uDFFB-\uDFFE])))?))?|\uDC6F(?:\u200D[\u2640\u2642]\uFE0F?)?|\uDD75(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|\uDE2E(?:\u200D\uD83D\uDCA8)?|\uDE35(?:\u200D\uD83D\uDCAB)?|\uDE36(?:\u200D\uD83C\uDF2B\uFE0F?)?)|\uD83E(?:[\uDD0C\uDD0F\uDD18-\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2\uDDD3\uDDD5\uDEC3-\uDEC5\uDEF0\uDEF2-\uDEF8](?:\uD83C[\uDFFB-\uDFFF])?|[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD4\uDDD6-\uDDDD](?:\uD83C[\uDFFB-\uDFFF])?(?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDDDE\uDDDF](?:\u200D[\u2640\u2642]\uFE0F?)?|[\uDD0D\uDD0E\uDD10-\uDD17\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCC\uDDD0\uDDE0-\uDDFF\uDE70-\uDE7C\uDE80-\uDE88\uDE90-\uDEBD\uDEBF-\uDEC2\uDECE-\uDEDB\uDEE0-\uDEE8]|\uDD3C(?:\u200D[\u2640\u2642]\uFE0F?|\uD83C[\uDFFB-\uDFFF])?|\uDDD1(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83E\uDDD1))|\uD83C(?:\uDFFB(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFC-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?|\uDFFC(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB\uDFFD-\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?|\uDFFD(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?|\uDFFE(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB-\uDFFD\uDFFF]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?|\uDFFF(?:\u200D(?:[\u2695\u2696\u2708]\uFE0F?|\u2764\uFE0F?\u200D(?:\uD83D\uDC8B\u200D)?\uD83E\uDDD1\uD83C[\uDFFB-\uDFFE]|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E(?:[\uDDAF-\uDDB3\uDDBC\uDDBD]|\uDD1D\u200D\uD83E\uDDD1\uD83C[\uDFFB-\uDFFF])))?))?|\uDEF1(?:\uD83C(?:\uDFFB(?:\u200D\uD83E\uDEF2\uD83C[\uDFFC-\uDFFF])?|\uDFFC(?:\u200D\uD83E\uDEF2\uD83C[\uDFFB\uDFFD-\uDFFF])?|\uDFFD(?:\u200D\uD83E\uDEF2\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])?|\uDFFE(?:\u200D\uD83E\uDEF2\uD83C[\uDFFB-\uDFFD\uDFFF])?|\uDFFF(?:\u200D\uD83E\uDEF2\uD83C[\uDFFB-\uDFFE])?))?)');

  bool isEmoji(String input) {
    return emojiRegex().hasMatch(input);
  }

  void deleteStickerFromText() {
    String originalText = textEditingController.text;

    if (originalText == zeroWidthSpace) {
      _handleSoftKeyBoardDelete();
    } else if (originalText.isNotEmpty) {
      String text = originalText;
      final cursorPosition = currentCursor ?? originalText.length;

      if (cursorPosition > 0) {
        final EmojiUtil emojiUtil = EmojiUtil();
        int removeLength = 1;
        int openBracketIndex = originalText.lastIndexOf('[', cursorPosition - 1);

        if (openBracketIndex != -1 && originalText[cursorPosition - 1] == ']') {
          // Small png emoji
          String key = originalText.substring(openBracketIndex, cursorPosition);

          if (emojiUtil.emojiMap.containsKey(key)) {
            removeLength = cursorPosition - openBracketIndex;
          }
        } else if (cursorPosition > 1 && isEmoji(originalText.substring(cursorPosition - 2, cursorPosition))) {
          removeLength = 2;
        }

        text = originalText.substring(0, cursorPosition - removeLength) + originalText.substring(cursorPosition);
        currentCursor = (currentCursor ?? removeLength) - removeLength;
      }

      textEditingController.text = text;

      if (TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop) {
        textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: currentCursor ?? textEditingController.text.length));
        focusNode.requestFocus();
      }
    }
  }

  void addStickerToText(String sticker) {
    final currentText = textEditingController.text;
    if (currentCursor != null && currentCursor! > -1 && currentCursor! < currentText.length + 1) {
      final firstString = currentText.substring(0, currentCursor);
      final secondString = currentText.substring(currentCursor!);
      currentCursor = currentCursor! + sticker.length;
      textEditingController.text = "$firstString$sticker$secondString";
    } else {
      currentCursor = null;
      textEditingController.text = "$currentText$sticker";
    }

    if (TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop) {
      textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: currentCursor ?? textEditingController.text.length));
      focusNode.requestFocus();
    }
  }

  String _filterU200b(String text) {
    return text.replaceAll(RegExp(r'\ufeff'), "");
  }

  Future handleSetDraftText({String? id, ConvType? convType, String? groupID}) async {
    String text = textEditingController.text;
    String convID = id ?? widget.conversationID;
    final isTopic = convID.contains("@TOPIC#");
    String conversationID = isTopic ? convID : ((convType ?? widget.conversationType) == ConvType.c2c ? "c2c_$convID" : "group_$convID");
    String draftText = _filterU200b(text);
    return await conversationModel.setConversationDraft(groupID: groupID ?? widget.groupID, isTopic: isTopic, isAllowWeb: widget.model.chatConfig.isUseDraftOnWeb, conversationID: conversationID, draftText: draftText);
  }

// 和onSubmitted一样，只是保持焦点的不同
  onEmojiSubmitted() {
    lastText = "";
    final text = textEditingController.text.trim();
    final convType = widget.conversationType;
    conversationModel.clearWebDraft(conversationID: widget.conversationID);
    if (text.isNotEmpty && text != zeroWidthSpace) {
      if (widget.model.repliedMessage != null) {
        MessageUtils.handleMessageError(
            widget.model.sendReplyMessage(
              text: text,
              convID: widget.conversationID,
              convType: convType,
              atUserIDList: getUserIdFromMemberInfoMap(),
            ),
            context);
      } else {
        MessageUtils.handleMessageError(
            widget.model.sendTextMessage(
              text: text,
              convID: widget.conversationID,
              convType: convType,
            ),
            context);
      }
      textEditingController.clear();
      goDownBottom();
    }
    currentCursor = null;
  }

// index为emoji的index,data为baseurl+name
  onCustomEmojiFaceSubmitted(int index, String data) {
    final convType = widget.conversationType;

    // This part of the code is written to adapt to the Native side requirements.
    // It extracts the substring needed to interact with Native side by splitting
    // and parsing the given data value.
    RegExp regex = RegExp(r'assets\/custom_face_resource\/(4350|4351|4352)');
    if (regex.hasMatch(data)) {
      index += 1;
      data = (data.split("/")[3]).split("@")[0];
    }

    if (widget.model.repliedMessage != null) {
      MessageUtils.handleMessageError(widget.model.sendFaceMessage(index: index, data: data, convID: widget.conversationID, convType: convType), context);
    } else {
      MessageUtils.handleMessageError(widget.model.sendFaceMessage(index: index, data: data, convID: widget.conversationID, convType: convType), context);
    }
  }

  List<String> getUserIdFromMemberInfoMap() {
    List<String> userList = [];
    mentionedMembersMap.forEach((String key, V2TimGroupMemberFullInfo info) {
      userList.add(info.userID);
    });

    return userList;
  }

  onSubmitted() async {
    conversationModel.clearWebDraft(conversationID: widget.conversationID);
    lastText = "";
    final text = textEditingController.text.trim();
    final convType = widget.conversationType;
    if (text.isNotEmpty && text != zeroWidthSpace) {
      if (widget.model.repliedMessage != null) {
        MessageUtils.handleMessageError(widget.model.sendReplyMessage(text: text, convID: widget.conversationID, convType: convType, atUserIDList: getUserIdFromMemberInfoMap()), context);
      } else if (mentionedMembersMap.isNotEmpty) {
        widget.model.sendTextAtMessage(text: text, convType: widget.conversationType, convID: widget.conversationID, atUserList: getUserIdFromMemberInfoMap());
      } else {
        MessageUtils.handleMessageError(widget.model.sendTextMessage(text: text, convID: widget.conversationID, convType: convType), context);
      }
      textEditingController.clear();
      currentCursor = null;
      lastText = "";
      mentionedMembersMap = {};

      goDownBottom();
      _handleSendEditStatus("", false);
    }
  }

  void goDownBottom() {
    if (globalModel.getMessageListPosition(widget.conversationID) == HistoryMessagePosition.notShowLatest) {
      return;
    }
    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        if (widget.scrollController != null) {
          widget.scrollController!.animateTo(
            widget.scrollController!.position.minScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
          );
        }
        // ignore: empty_catches
      } catch (e) {}
    });
  }

  _onCursorChange() {
    final selection = textEditingController.selection;
    currentCursor = selection.baseOffset;
  }

  _handleSoftKeyBoardDelete() {
    if (widget.model.repliedMessage != null) {
      widget.model.repliedMessage = null;
    }
  }

  String _getShowName(V2TimGroupMemberFullInfo? item) {
    return TencentUtils.checkStringWithoutSpace(item?.nameCard) ?? TencentUtils.checkStringWithoutSpace(item?.nickName) ?? TencentUtils.checkStringWithoutSpace(item?.userID) ?? "";
  }

  mentionMemberInMessage(String? userID, String? nickName) {
    if (TencentUtils.checkString(userID) == null) {
      focusNode.requestFocus();
    } else {
      final memberInfo = widget.model.groupMemberList?.firstWhereOrNull((element) => element?.userID == userID) ??
          V2TimGroupMemberFullInfo(
            userID: userID ?? "",
            nickName: nickName,
          );
      final showName = _getShowName(memberInfo);
      mentionedMembersMap["@$showName"] = memberInfo;
      String text = "${textEditingController.text}@$showName ";
      //please do not delete space
      focusNode.requestFocus();
      textEditingController.text = text;
      textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
      lastText = text;
      _isComposingText = false;
      narrowTextFieldKey.currentState?.showKeyboard = true;
    }
  }

  bool shouldRemoveAtTag(String atTag, String deletedChar) {
    final atMemberArray = [];
    mentionedMembersMap.forEach((key, value) {
      atMemberArray.add(key);
    });
    for (String member in atMemberArray) {
      if (atTag == member && member.contains(deletedChar)) {
        return true;
      }
    }
    return false;
  }

  Offset getAtPosition(String text, int atPlace) {
    final textBeforeAt = text.substring(0, atPlace + 1);
    final textPainter = TextPainter(
      text: TextSpan(text: textBeforeAt, style: const TextStyle(fontSize: 14)),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: inputWidth);
    final TextPosition lastLineOffset = textPainter.getPositionForOffset(Offset(textPainter.width, textPainter.height));
    final Offset caretPosition = textPainter.getOffsetForCaret(lastLineOffset, Rect.zero);
    final dx = min(inputWidth - 180, caretPosition.dx + 16);
    final dy = max(24, 21 * widget.model.chatConfig.desktopMessageInputFieldLines - caretPosition.dy).toDouble();

    return Offset(dx, dy);
  }

  calculateRemoveRemainAt(String text) {
    Map<String, V2TimGroupMemberFullInfo> map = {};
    Iterable<Match> matches = atTextReg.allMatches(text);
    List<String?> parseAtList = [];
    for (final item in matches) {
      final str = item.group(0);
      parseAtList.add(str);
    }
    for (String? key in parseAtList) {
      if (key != null && mentionedMembersMap[key] != null) {
        map[key] = mentionedMembersMap[key]!;
      }
    }
    mentionedMembersMap = map;
  }

  updateMentionedMap() {
    Map<String, V2TimGroupMemberFullInfo> map = {};
    Iterable<Match> matches = atTextReg.allMatches(textEditingController.text);
    List<String?> parseAtList = [];
    for (final item in matches) {
      final str = item.group(0);
      parseAtList.add(str);
    }
    for (String? key in parseAtList) {
      if (key != null && mentionedMembersMap[key] != null) {
        map[key] = mentionedMembersMap[key]!;
      }
    }
    mentionedMembersMap = map;
  }

  (int, String, bool)? findChangedCharacter(String originalString, String newString) {
    if (newString.length < originalString.length) {
      final originalStringLength = originalString.length;
      final newStringLength = newString.length;
      for (int i = 0; i < newString.length; ++i) {
        if (originalString[originalStringLength - i - 1] != newString[newStringLength - i - 1]) {
          return (newStringLength - i, originalString[originalStringLength - i - 1], false);
        }
      }
      return (newString.length, originalString[newString.length], false);
    } else if (newString.length > originalString.length) {
      for (int i = 0; i < originalString.length; ++i) {
        if (originalString[i] != newString[i]) {
          return (i, newString[i], true);
        }
      }
      return (originalString.length, newString[originalString.length], true);
    } else {
      return null;
    }
  }

  _handleAtText(String text, TUIChatSeparateViewModel model) async {
    final text = textEditingController.text;
    final String originalText = lastText;
    String? groupID = widget.conversationType == ConvType.group ? widget.conversationID : null;
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    if (groupID == null) {
      lastText = text;
      return;
    }

    int textLength = text.length;
    // 删除的话
    if (originalText.length > textLength) {
      final List<Diff> differencesList = diff(originalText, text);
      final diffIndex = differencesList.first.text.length - 1;
      int atIndex = originalText.lastIndexOf('@', diffIndex);
      int spaceIndex = originalText.indexOf(' ', diffIndex);
      if (diffIndex < 0 || atIndex < 0 || spaceIndex <= atIndex) {
        lastText = text;
      } else {
        String atTag = originalText.substring(atIndex, spaceIndex);
        String deletedChar = originalText[diffIndex];
        if (shouldRemoveAtTag(atTag, deletedChar)) {
          final newText = originalText.substring(0, atIndex) + originalText.substring(spaceIndex + 1);
          textEditingController.text = newText;
          textEditingController.selection = TextSelection.collapsed(offset: atIndex);
          lastText = newText;
          updateMentionedMap();
          return;
        }
      }
      updateMentionedMap();
    }

    final int selfRole = widget.model.selfMemberInfo?.role ?? 0;
    final bool canAtAll = (selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN || selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER);

    if (isDesktopScreen) {
      (int, String, bool)? changedCharacterRecord = findChangedCharacter(originalText, text);
      int? changedTextPosition = changedCharacterRecord?.$1;
      String? changedCharacter = changedCharacterRecord?.$2;
      bool isAdded = changedCharacterRecord?.$3 ?? false;

      String? subText, keyword;
      int? atPlace;

      if (changedTextPosition != null) {
        subText = isAdded == true ? text.substring(0, changedTextPosition + 1) : text.substring(0, changedTextPosition);
        atPlace = subText.lastIndexOf('@');
        if (atPlace != -1) {
          keyword = text.substring(atPlace + 1, changedTextPosition + (isAdded ? 1 : 0));
        }
      } else {
        atPlace = -1;
      }

      if (atPlace >= 0) {
        if (isAdded && changedCharacter == "@") {
          final atPosition = getAtPosition(text, atPlace);
          model.atPositionX = atPosition.dx;
          model.atPositionY = atPosition.dy;
          isAddingAtSearchWords = true;
        }
        List<V2TimGroupMemberFullInfo> showAtMemberList = (model.groupMemberList ?? [])
            .where((element) {
              final showName = (TencentUtils.checkStringWithoutSpace(element?.friendRemark) ??
                      TencentUtils.checkStringWithoutSpace(element?.nameCard) ??
                      TencentUtils.checkStringWithoutSpace(element?.nickName) ??
                      TencentUtils.checkStringWithoutSpace(element?.userID) ??
                      "")
                  .toLowerCase();
              keyword ??= "";
              return element != null && showName.contains(keyword!.toLowerCase()) && TencentUtils.checkString(showName) != null && element.userID != widget.model.selfMemberInfo?.userID;
            })
            .whereType<V2TimGroupMemberFullInfo>()
            .toList();

        showAtMemberList.sort((V2TimGroupMemberFullInfo userA, V2TimGroupMemberFullInfo userB) {
          final isUserAIsGroupAdmin = userA.role == 300;
          final isUserAIsGroupOwner = userA.role == 400;

          final isUserBIsGroupAdmin = userB.role == 300;
          final isUserBIsGroupOwner = userB.role == 400;

          final String userAName = _getShowName(userA);
          final String userBName = _getShowName(userB);

          if (isUserAIsGroupOwner != isUserBIsGroupOwner) {
            return isUserAIsGroupOwner ? -1 : 1;
          }

          if (isUserAIsGroupAdmin != isUserBIsGroupAdmin) {
            return isUserAIsGroupAdmin ? -1 : 1;
          }

          return userAName.compareTo(userBName);
        });

        keyword ??= "";
        if (canAtAll && showAtMemberList.isNotEmpty && keyword!.isEmpty) {
          showAtMemberList = [V2TimGroupMemberFullInfo(userID: "__kImSDK_MesssageAtALL__", nickName: TIM_t("所有人")), ...showAtMemberList];
        }

        model.activeAtIndex = 0;
        model.showAtMemberList = showAtMemberList;

        isAddingAtSearchWords = showAtMemberList.isNotEmpty;
      } else {
        model.activeAtIndex = -1;
        model.showAtMemberList = [];
        isAddingAtSearchWords = false;
      }
    } else if (textLength > 0 && text[textLength - 1] == "@" && lastText.length < textLength) {
      V2TimGroupMemberFullInfo? memberInfo = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AtText(groupMemberList: model.groupMemberList, groupInfo: model.groupInfo, groupID: groupID, canAtAll: canAtAll, groupType: widget.groupType),
        ),
      );
      final showName = _getShowName(memberInfo);
      if (memberInfo != null) {
        mentionedMembersMap["@$showName"] = memberInfo;
        textEditingController.text = "$text$showName ";
        lastText = "$text$showName ";
      }
    }
    lastText = textEditingController.text;
  }

  void replaceAtTag(String selectedMember) {
    int cursorPosition = textEditingController.selection.baseOffset;
    int atIndex = textEditingController.text.lastIndexOf('@', cursorPosition - 1);
    if (atIndex >= 0) {
      String beforeAt = textEditingController.text.substring(0, atIndex);
      String afterAt = textEditingController.text.substring(cursorPosition);
      textEditingController.text = beforeAt + '@' + selectedMember + ' ' + afterAt;
      textEditingController.selection = TextSelection.collapsed(offset: atIndex + selectedMember.length + 2);
      lastText = beforeAt + '@' + selectedMember + ' ' + afterAt;
    }
  }

  void handleAtMember({V2TimGroupMemberFullInfo? memberInfo, bool? isAddToCursorPosition = false}) {
    if (memberInfo != null) {
      final String showName = _getShowName(memberInfo);
      mentionedMembersMap["@$showName"] = memberInfo;
      replaceAtTag(showName);
      widget.model.showAtMemberList = [];
      widget.model.activeAtIndex = -1;
      focusNode.requestFocus();
    }
  }

  KeyEventResult handleDesktopKeyEvent(FocusNode node, RawKeyEvent event) {
    final activeIndex = widget.model.activeAtIndex;
    final showMemberList = widget.model.showAtMemberList;
    final isPressEnter = (event.physicalKey == PhysicalKeyboardKey.enter) || (event.physicalKey == PhysicalKeyboardKey.numpadEnter);
    if (event.runtimeType == RawKeyDownEvent) {
      if (event.physicalKey == PhysicalKeyboardKey.backspace) {
        if (textEditingController.text.isEmpty && lastText.isEmpty) {
          widget.model.repliedMessage = null;
          return KeyEventResult.handled;
        }
      } else if ((event.isShiftPressed || event.isAltPressed || event.isControlPressed || event.isMetaPressed) && isPressEnter) {
        final offset = textEditingController.selection.baseOffset;
        textEditingController.text = '${lastText.substring(0, offset)}\n${lastText.substring(offset)}';
        textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: offset + 1));
        lastText = textEditingController.text;

        return KeyEventResult.handled;
      } else if (isPressEnter) {
        if (!_isComposingText) {
          if (!isAddingAtSearchWords || widget.model.showAtMemberList.isEmpty) {
            onSubmitted();
          } else {
            isAddingAtSearchWords = false;
            final V2TimGroupMemberFullInfo? memberInfo = showMemberList[activeIndex];
            if (memberInfo != null) {
              handleAtMember(memberInfo: memberInfo, isAddToCursorPosition: true);
            }
          }
          return KeyEventResult.handled;
        }
      }

      if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) && isAddingAtSearchWords && showMemberList.isNotEmpty) {
        final newIndex = max(activeIndex - 1, 0);
        widget.model.activeAtIndex = newIndex;
        widget.atMemberPanelScroll?.scrollToIndex(newIndex, preferPosition: AutoScrollPosition.middle);
        return KeyEventResult.handled;
      }

      if (event.isKeyPressed(LogicalKeyboardKey.arrowDown) && isAddingAtSearchWords && showMemberList.isNotEmpty) {
        final newIndex = min(activeIndex + 1, showMemberList.length - 1);
        widget.model.activeAtIndex = newIndex;
        widget.atMemberPanelScroll?.scrollToIndex(newIndex, preferPosition: AutoScrollPosition.middle);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    if (PlatformUtils().isWeb || PlatformUtils().isDesktop) {
      focusNode = FocusNode(
        onKey: (node, event) => handleDesktopKeyEvent(node, event),
      );
    } else {
      focusNode = FocusNode();
    }
    textEditingController = widget.controller?.textEditingController ?? TextEditingController();
    if (widget.initText != null) {
      textEditingController.text = widget.initText!;
    }
    if (widget.controller != null) {
      widget.controller?.addListener(controllerHandler);
    }
    final AppLocale appLocale = I18nUtils.findDeviceLocale(null);
    languageType = (appLocale == AppLocale.zhHans || appLocale == AppLocale.zhHant) ? 'zh' : 'en';
    textEditingController.addListener(() {
      _isComposingText = textEditingController.value.composing.start != -1;
    });
    generateStickerList();
  }

  controllerHandler() {
    final actionType = widget.controller?.actionType;
    if (actionType == ActionType.longPressToAt) {
      mentionMemberInMessage(widget.controller?.atUserID, widget.controller?.atUserName);
    } else if (actionType == ActionType.setTextField) {
      final newText = widget.controller?.inputText ?? "";
      textEditingController.text = newText;
      textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
      lastText = textEditingController.text;
      focusNode.requestFocus();
      return;
    } else if (actionType == ActionType.requestFocus) {
      focusNode.requestFocus();
      return;
    } else if (actionType == ActionType.handleAtMember) {
      handleAtMember(memberInfo: widget.controller?.groupMemberFullInfo);
      return;
    }
  }

  @override
  void didUpdateWidget(TIMUIKitInputTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.conversationID != oldWidget.conversationID) {
      mentionedMembersMap.clear();
      handleSetDraftText(id: oldWidget.conversationID, convType: oldWidget.conversationType, groupID: oldWidget.groupID);
      if (oldWidget.initText != widget.initText) {
        textEditingController.text = widget.initText ?? "";
      } else {
        textEditingController.clear();
      }
    }
    if (widget.initText != oldWidget.initText && TencentUtils.checkString(widget.initText) != null) {
      textEditingController.text = widget.initText!;
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    handleSetDraftText();
    if (widget.controller != null) {
      widget.controller?.removeListener(controllerHandler);
    }
    focusNode.dispose();
    super.dispose();
  }

  Future<bool> getMemberMuteStatus(String userID) async {
    // Get the mute state of the members recursively
    if (widget.model.groupMemberList?.any((item) => (item?.userID == userID)) ?? false) {
      final int muteUntil = widget.model.groupMemberList?.firstWhere((item) => (item?.userID == userID))?.muteUntil ?? 0;
      return muteUntil * 1000 > DateTime.now().millisecondsSinceEpoch;
    } else {
      return false;
    }
  }

  _getMuteType(TUIChatSeparateViewModel model) async {
    if (!mounted) {
      return;
    }

    final int selfRole = widget.model.selfMemberInfo?.role ?? 0;
    final bool willNotBeenMuted = (selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN || selfRole == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER);

    if (widget.conversationType == ConvType.group && !willNotBeenMuted) {
      if ((model.groupInfo?.isAllMuted ?? false) && muteStatus != MuteStatus.all) {
        Future.delayed(const Duration(seconds: 0), () {
          setState(() {
            muteStatus = MuteStatus.all;
          });
        });
      } else if (selfModel.loginInfo?.userID != null && await getMemberMuteStatus(selfModel.loginInfo!.userID!) && muteStatus != MuteStatus.me) {
        Future.delayed(const Duration(seconds: 0), () {
          setState(() {
            muteStatus = MuteStatus.me;
          });
        });
      } else if (!(model.groupInfo?.isAllMuted ?? false) && !(selfModel.loginInfo?.userID != null && await getMemberMuteStatus(selfModel.loginInfo!.userID!)) && muteStatus != MuteStatus.none) {
        Future.delayed(const Duration(seconds: 0), () {
          setState(() {
            muteStatus = MuteStatus.none;
          });
        });
      }
    }
  }

  _handleSendEditStatus(String value, bool status) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (value.isNotEmpty && widget.conversationType == ConvType.c2c) {
      if (status) {
        if (now - latestSendEditStatusTime < 5 * 1000) {
          return;
        }
      }
      // send status
      globalModel.sendEditStatusMessage(status, widget.conversationID);
      latestSendEditStatusTime = now;
    } else {
      globalModel.sendEditStatusMessage(false, widget.conversationID);
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    final TUIChatSeparateViewModel model = Provider.of<TUIChatSeparateViewModel>(context);

    _getMuteType(model);

    return Selector<TUIChatSeparateViewModel, V2TimMessage?>(
        builder: ((context, value, child) {
          String? getForbiddenText() {
            if (!(model.isGroupExist)) {
              return "群组不存在";
            } else if (model.isNotAMember) {
              return "您不是群成员";
            } else if (muteStatus == MuteStatus.all) {
              return "全员禁言中";
            } else if (muteStatus == MuteStatus.me) {
              return "您被禁言";
            }
            return null;
          }

          final forbiddenText = getForbiddenText();
          return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            inputWidth = constraints.maxWidth;
            return TUIKitScreenUtils.getDeviceWidget(
                context: context,
                defaultWidget: TIMUIKitTextFieldLayoutNarrow(
                    stickerPackageList: stickerPackageList,
                    onEmojiSubmitted: onEmojiSubmitted,
                    onCustomEmojiFaceSubmitted: onCustomEmojiFaceSubmitted,
                    backSpaceText: deleteStickerFromText,
                    addStickerToText: addStickerToText,
                    customStickerPanel: widget.customStickerPanel,
                    forbiddenText: forbiddenText,
                    onChanged: widget.onChanged,
                    backgroundColor: widget.backgroundColor,
                    morePanelConfig: widget.morePanelConfig,
                    repliedMessage: value,
                    currentCursor: currentCursor,
                    hintText: widget.hintText,
                    isUseDefaultEmoji: widget.isUseDefaultEmoji,
                    languageType: languageType,
                    textEditingController: textEditingController,
                    conversationID: widget.conversationID,
                    conversationType: widget.conversationType,
                    focusNode: focusNode,
                    controller: widget.controller,
                    setCurrentCursor: setCurrentCursor,
                    onCursorChange: _onCursorChange,
                    model: model,
                    handleSendEditStatus: _handleSendEditStatus,
                    handleAtText: (text) {
                      _handleAtText(text, model);
                    },
                    handleSoftKeyBoardDelete: _handleSoftKeyBoardDelete,
                    onSubmitted: onSubmitted,
                    goDownBottom: goDownBottom,
                    showSendAudio: widget.showSendAudio,
                    showSendEmoji: widget.showSendEmoji,
                    showMorePanel: widget.showMorePanel,
                    customEmojiStickerList: widget.customEmojiStickerList),
                desktopWidget: TIMUIKitTextFieldLayoutWide(
                    stickerPackageList: stickerPackageList,
                    chatConfig: widget.chatConfig ?? widget.model.chatConfig,
                    theme: theme,
                    currentConversation: widget.currentConversation,
                    onEmojiSubmitted: onEmojiSubmitted,
                    onCustomEmojiFaceSubmitted: onCustomEmojiFaceSubmitted,
                    backSpaceText: deleteStickerFromText,
                    addStickerToText: addStickerToText,
                    customStickerPanel: widget.customStickerPanel,
                    forbiddenText: forbiddenText,
                    onChanged: widget.onChanged,
                    backgroundColor: widget.backgroundColor,
                    morePanelConfig: widget.morePanelConfig,
                    repliedMessage: value,
                    currentCursor: currentCursor,
                    hintText: widget.hintText,
                    isUseDefaultEmoji: widget.isUseDefaultEmoji,
                    languageType: languageType,
                    textEditingController: textEditingController,
                    conversationID: widget.conversationID,
                    conversationType: widget.conversationType,
                    focusNode: focusNode,
                    controller: widget.controller,
                    setCurrentCursor: setCurrentCursor,
                    onCursorChange: _onCursorChange,
                    model: model,
                    handleSendEditStatus: _handleSendEditStatus,
                    handleAtText: (text) {
                      _handleAtText(text, model);
                    },
                    onSubmitted: onSubmitted,
                    goDownBottom: goDownBottom,
                    showSendAudio: widget.showSendAudio,
                    showSendEmoji: widget.showSendEmoji,
                    showMorePanel: widget.showMorePanel,
                    customEmojiStickerList: widget.customEmojiStickerList));
          });
        }),
        selector: (c, model) => model.repliedMessage);
  }
}
