import 'dart:async';
import 'dart:convert';

import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/utils/sdk_const.dart';
import 'package:tencent_cloud_chat_intl/tencent_cloud_chat_intl.dart';
import 'package:tencent_cloud_chat_message/common/text_compiler/tencent_cloud_chat_message_text_compiler.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_text_translate/translate_utils.dart';
import 'package:tencent_cloud_chat_text_translate/translationData.dart';

class TencentCloudChatTranslate extends StatefulWidget {
  final String sourceText;
  final String targetLanguage;
  List<String> groupAtUserList = [];
  String localCustomData = '';
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Function(String)? onTranslateSuccess;
  final Function()? onTranslateFailed;
  TencentCloudChatTranslate(
      {super.key,
      this.decoration,
      this.textStyle,
      this.padding,
      this.onTranslateSuccess,
      this.onTranslateFailed,
      required this.sourceText,
      required this.targetLanguage,
      required this.groupAtUserList,
      required this.localCustomData});

  @override
  State<TencentCloudChatTranslate> createState() =>
      _TencentCloudChatTranslateState();
}

class _TencentCloudChatTranslateState extends State<TencentCloudChatTranslate> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;
  String translatedText = '';
  bool isTranslating = false;
  bool isError = false;

  @override
  initState() {
    translateText();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
              decoration: widget.decoration ??
                  const BoxDecoration(
                      color: Color(0xFFF2F7FF),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isTranslating
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.grey,
                          ))
                      : ExtendedText(
                          translatedText,
                          specialTextSpanBuilder: TencentCloudChatSpecialTextSpanBuilder(
                            onTapUrl: (String value) {},
                            showAtBackground: true,
                            stickerPluginInstance: dataProvider.stickerPluginInstance,
                          ),
                          style:
                              widget.textStyle ?? const  TextStyle(fontSize: 14),
                        ),
                  if (!isTranslating) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: Transform.scale(
                            scale: 0.6,
                            child: Checkbox(
                              mouseCursor: SystemMouseCursors.basic,
                              splashRadius: 0,
                              shape: const CircleBorder(),
                              activeColor: const Color(0xffA0A0A0),
                              value: true,
                              onChanged: (bool? value) {},
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          tL10n.translatedBy,
                          style:
                              const TextStyle(fontSize: 10, color: Color(0xffA0A0A0)),
                        ),
                      ],
                    )
                  ]
                ],
              )),
        ),
        if (isError) ...[
          const SizedBox(
            width: 4,
          ),
          InkWell(
              onTap: () {
                translateText();
              },
              child: const Icon(
                size: 20,
                Icons.refresh_outlined,
                color: Colors.grey,
              ))
        ]
      ],
    );
  }

  _translateMessage(String originalText, List<String> groupAtUserNicknameList) async {
    Map<String, List<String>> splitMap = TranslateUtils.splitTextByEmojiAndAtUsers(widget.sourceText, groupAtUserNicknameList);
    List<String>? toTranslateTextList = splitMap[TranslateUtils.splitTextForTranslation];
    if (toTranslateTextList == null || toTranslateTextList.isEmpty) {
      List<String>? splitTextList = splitMap[TranslateUtils.splitText];
      String translateTextResult = "";
      if (splitTextList != null) {
        for (String result in splitTextList) {
          translateTextResult += result;
        }
      }

      try {
        Map<String, dynamic> jsonMap = jsonDecode(widget.localCustomData);
        jsonMap["translation"] = translateTextResult;
        jsonMap["translationViewStatus"] = TranslationData.msgTranslateStatusShown;
        widget.localCustomData = jsonEncode(jsonMap);
        widget.onTranslateSuccess!(widget.localCustomData);
        setState(() {
          isTranslating = false;
          translatedText = translateTextResult;
        });
        return translateTextResult;
      } catch (e) {
        print(e);
      }

      return translateTextResult;
    }

    final translateResult = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .translateText(
        texts: toTranslateTextList,
        targetLanguage: widget.targetLanguage);

    if (translateResult.code == 0 && translateResult.data != null) {
      Map<String, String>? translateMap = translateResult.data;
      List<String>? splitTextList = splitMap[TranslateUtils.splitText];
      List<String>? translationIndexList = splitMap[TranslateUtils.splitTextIndexForTranslation];
      for (String indexString in translationIndexList!) {
        int index = int.parse(indexString);
        String? originText = splitTextList?[index];
        String? translatedTextResult = translateMap?[originText];
        if (translatedTextResult!.isNotEmpty) {
          splitTextList?[index] = translatedTextResult;
        }
      }

      String translateTextResult = "";
      for (String result in splitTextList!) {
        translateTextResult += result;
      }

      try {
        Map<String, dynamic> jsonMap;
        if (widget.localCustomData.isEmpty) {
          jsonMap = <String, dynamic>{};
        } else {
          jsonMap = jsonDecode(widget.localCustomData);
        }

        jsonMap["translation"] = translateTextResult;
        jsonMap["translationViewStatus"] = TranslationData.msgTranslateStatusShown;
        widget.localCustomData = jsonEncode(jsonMap);
        widget.onTranslateSuccess!(widget.localCustomData);
        setState(() {
          isTranslating = false;
          translatedText = translateTextResult;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  translateText() async {
    // find translation text and status from localCustomData
    if (widget.localCustomData.isNotEmpty) {
      // parse JSON String to Map<String, dynamic>
      try {
        Map<String, dynamic> jsonMap = jsonDecode(widget.localCustomData);
        TranslationData translationData = TranslationData.fromJson(jsonMap);
        if (translationData.translationViewStatus == TranslationData.msgTranslateStatusHidden) {
          setState(() {
            isTranslating = false;
            translatedText = translationData.translation;
            jsonMap["translationViewStatus"] = TranslationData.msgTranslateStatusShown;
            widget.localCustomData = jsonEncode(jsonMap);
            widget.onTranslateSuccess!(widget.localCustomData);
          });
        } else if (translationData.translationViewStatus == TranslationData.msgTranslateStatusShown) {
          setState(() {
            isTranslating = false;
            translatedText = translationData.translation;
          });
        }
        return;
      } catch (e) {
        print(e);
      }
    }

    List<String> atRealUserIDList = [];
    List<String> groupAtUserNicknameList = [];
    List<int> atAllIndexList = [];
    for (int i = 0; i < widget.groupAtUserList.length; i++) {
      String userID = widget.groupAtUserList[i];
      if (userID == SDKConst.sdkAtAllUserID) {
        atAllIndexList.add(i);
      } else {
        atRealUserIDList.add(userID);
      }
    }

    if (atRealUserIDList.isEmpty) {
      for (var index in atAllIndexList) {
        groupAtUserNicknameList.add(tL10n.atAll);
      }
      _translateMessage(widget.sourceText, groupAtUserNicknameList);
    } else {
      var result = await TencentImSDKPlugin.v2TIMManager.getUsersInfo(userIDList: atRealUserIDList);
      if (result.code == 0 && result.data != null) {
        for (var userID in widget.groupAtUserList) {
          for (V2TimUserFullInfo userFullInfo in result.data!) {
            if (userID == SDKConst.sdkAtAllUserID) {
              break;
            }

            if (userID == userFullInfo.userID) {
              groupAtUserNicknameList.add(userFullInfo.nickName ?? userFullInfo.userID!);
              break;
            }
          }
        }

        for (int index in atAllIndexList) {
          groupAtUserNicknameList.insert(index, tL10n.atAll);
        }
        _translateMessage(widget.sourceText, groupAtUserNicknameList);
      }
    }
  }
}

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String text = ".";
  Timer? timer;
  @override
  void initState() {
    loadingText();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }

  loadingText() {
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (text == '.') {
        text = '..';
      } else if (text == '..') {
        text = '...';
      } else {
        text = '.';
      }
      setState(() {});
    });
  }
}
