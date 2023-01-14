import 'dart:async';
import 'dart:convert';

import 'package:tencent_extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/link_preview_entry.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_preview.dart';
import 'TIMUIKitMessageReaction/tim_uikit_message_reaction_show_panel.dart';

class TIMUIKitTextTranslationElem extends StatefulWidget {
  final V2TimMessage message;
  final bool isFromSelf;
  final bool isShowJump;
  final VoidCallback clearJump;
  final TextStyle? fontStyle;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? textPadding;
  final TUIChatSeparateViewModel chatModel;
  final bool? isShowMessageReaction;
  final bool isUseDefaultEmoji;
  final List customEmojiStickerList;

  const TIMUIKitTextTranslationElem(
      {Key? key,
      required this.message,
      required this.isFromSelf,
      required this.isShowJump,
      required this.clearJump,
      this.fontStyle,
      this.borderRadius,
      this.isShowMessageReaction,
      this.backgroundColor,
      this.textPadding,
      required this.chatModel,
      this.isUseDefaultEmoji = false,
      this.customEmojiStickerList = const []})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitTextTranslationElemState();
}

class _TIMUIKitTextTranslationElemState extends TIMUIKitState<TIMUIKitTextTranslationElem> {
  bool isShowJumpState = false;
  bool isShining = false;

  @override
  void initState() {
    super.initState();
    // get the link preview info
    _getLinkPreview();
  }

  @override
  void didUpdateWidget(TIMUIKitTextTranslationElem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.msgID == null && widget.message.msgID != null) {
      _getLinkPreview();
    }
  }

  _showJumpColor() {
    if ((widget.chatModel.jumpMsgID != widget.message.msgID) &&
        (widget.message.msgID?.isNotEmpty ?? true)) {
      return;
    }
    isShining = true;
    int shineAmount = 6;
    setState(() {
      isShowJumpState = true;
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          isShowJumpState = shineAmount.isOdd ? true : false;
        });
      }
      if (shineAmount == 0 || !mounted) {
        isShining = false;
        timer.cancel();
      }
      shineAmount--;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.clearJump();
    });
  }

  // get the link preview info
  _getLinkPreview() {
    if (widget.chatModel.chatConfig.urlPreviewType !=
        UrlPreviewType.previewCardAndHyperlink) {
      return;
    }
    try {
      if (widget.message.localCustomData != null &&
          widget.message.localCustomData!.isNotEmpty) {
        final String localJSON = widget.message.localCustomData!;
        final LocalCustomDataModel? localPreviewInfo =
            LocalCustomDataModel.fromMap(json.decode(localJSON));
        // If [localCustomData] is not empty, check if the link preview info exists
        if (localPreviewInfo == null || localPreviewInfo.isLinkPreviewEmpty()) {
          // If not exists, get it
          _initLinkPreview();
        }
      } else {
        // It [localCustomData] is empty, get the link info
        _initLinkPreview();
      }
    } catch (e) {
      return null;
    }
  }

  _initLinkPreview() async {
    // Get the link preview info from extension, let it update the message UI automatically by providing a [onUpdateMessage].
    // The `onUpdateMessage` can use the `updateMessage()` from the [TIMUIKitChatController] directly.
    LinkPreviewEntry.getFirstLinkPreviewContent(
        message: widget.message,
        onUpdateMessage: () {
          widget.chatModel
              .updateMessageFromController(msgID: widget.message.msgID!);
        });
  }

  Widget? _renderPreviewWidget() {
    // If the link preview info from [localCustomData] is available, use it to render the preview card.
    // Otherwise, it will returns null.
    if (widget.message.localCustomData != null &&
        widget.message.localCustomData!.isNotEmpty) {
      try {
        final String localJSON = widget.message.localCustomData!;
        final LocalCustomDataModel? localPreviewInfo =
            LocalCustomDataModel.fromMap(json.decode(localJSON));
        if (localPreviewInfo != null && !localPreviewInfo.isLinkPreviewEmpty()) {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            child:
                // You can use this default widget [LinkPreviewWidget] to render preview card, or you can use custom widget.
                LinkPreviewWidget(linkPreview: localPreviewInfo),
          );
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    final borderRadius = widget.isFromSelf
        ? const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10))
        : const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10));
    if ((widget.chatModel.jumpMsgID == widget.message.msgID)) {}
    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        if ((widget.chatModel.jumpMsgID == widget.message.msgID) &&
            (widget.message.msgID?.isNotEmpty ?? false)) {
          widget.clearJump();
        }
      }
    }
    final defaultStyle = widget.isFromSelf
        ? theme.lightPrimaryMaterialColor.shade50
        : theme.chatMessageItemFromOthersBgColor;
    final backgroundColor = isShowJumpState
        ? const Color.fromRGBO(245, 166, 35, 1)
        : (widget.backgroundColor ?? defaultStyle);

    final LocalCustomDataModel localCustomData = LocalCustomDataModel.fromMap(
        json.decode(TencentUtils.checkString(widget.message.localCustomData) ?? "{}"));
    final String? translateText = localCustomData.translatedText;

    final textWithLink = LinkPreviewEntry.getHyperlinksText(
      translateText ?? "",
      widget.chatModel.chatConfig.isSupportMarkdownForTextMessage,
      widget.chatModel.chatConfig.onTapLink,
      widget.isUseDefaultEmoji,
      widget.customEmojiStickerList,
    );

    return TencentUtils.checkString(translateText) != null ? Container(
      margin: const EdgeInsets.only(top: 6),
      padding: widget.textPadding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: widget.borderRadius ?? borderRadius,
      ),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // If the [elemType] is text message, it will not be null here.
          // You can render the widget from extension directly, with a [TextStyle] optionally.
          widget.chatModel.chatConfig.urlPreviewType != UrlPreviewType.none
              ? textWithLink!(
                  style: widget.fontStyle ??
                      TextStyle(
                          fontSize: 16,
                          textBaseline: TextBaseline.ideographic,
                          height: widget.chatModel.chatConfig.textHight))
              : ExtendedText(translateText!,
                  softWrap: true,
                  style: widget.fontStyle ??
                      TextStyle(
                          fontSize: 16,
                          height: widget.chatModel.chatConfig.textHight),
                  specialTextSpanBuilder: DefaultSpecialTextSpanBuilder(
                    isUseDefaultEmoji: widget.isUseDefaultEmoji,
                    customEmojiStickerList: widget.customEmojiStickerList,
                    showAtBackground: true,
                  )),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.check_circle,
              color: Color(0x72282c34),
              size: 12,),
              const SizedBox(width: 4,),
              Text(TIM_t("翻译完成"),
                style: const TextStyle(
                  color: Color(0x72282c34),
                  fontSize: 10
                ),
              )
            ],
          )
        ],
      ),
    ) : const SizedBox(width: 0, height: 0);
  }
}
