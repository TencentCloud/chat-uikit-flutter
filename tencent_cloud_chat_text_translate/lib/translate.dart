import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_intl/tencent_cloud_chat_intl.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

class TencentCloudChatTranslate extends StatefulWidget {
  final String sourceText;
  final String targetLanguage;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Function()? onTranslateSuccess;
  final Function()? onTranslateFailed;
  const TencentCloudChatTranslate(
      {super.key,
      this.decoration,
      this.textStyle,
      this.padding,
      this.onTranslateSuccess,
      this.onTranslateFailed,
      required this.sourceText,
      required this.targetLanguage});

  @override
  State<TencentCloudChatTranslate> createState() =>
      _TencentCloudChatTranslateState();
}

class _TencentCloudChatTranslateState extends State<TencentCloudChatTranslate> {
  String translatedText = '';
  bool isTranslating = false;
  bool isError = false;

  @override
  initState() {
    translateText();
    super.initState();
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
                      : Text(
                          translatedText,
                          style:
                              widget.textStyle ?? const TextStyle(fontSize: 14),
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

  translateText() async {
    setState(() {
      if (mounted) {
        isTranslating = true;
        isError = false;
      }
    });
    final translateResult = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .translateText(
            texts: [widget.sourceText],
            targetLanguage: widget.targetLanguage);
    isTranslating = false;
    if (translateResult.code == 0 && translateResult.data != null) {
      final response = translateResult.data![widget.sourceText] ?? "";
      setState(() {
        translatedText = response;
      });
      if (widget.onTranslateSuccess != null) {
        widget.onTranslateSuccess!();
      }
    } else {
      setState(() {
        isError = true;
        translatedText = translateResult.desc;
      });
      if (widget.onTranslateFailed != null) {
        widget.onTranslateFailed!();
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
