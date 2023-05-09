import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_preview.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_text.dart';

import 'models/link_preview_content.dart';

class LinkPreviewEntry {
  /// get the text message with hyperlinks
  static LinkPreviewText? getHyperlinksText(String messageText, bool isMarkdown,
      {Function(String)? onLinkTap,
      bool? isEnableTextSelection,
      bool isUseDefaultEmoji = false,
      List customEmojiStickerList = const []}) {
    return ({TextStyle? style}) {
      return isMarkdown
          ? LinkTextMarkdown(
              messageText: messageText, style: style, onLinkTap: onLinkTap)
          : LinkText(
              isEnableTextSelection: isEnableTextSelection,
              messageText: messageText,
              style: style,
              onLinkTap: onLinkTap,
              isUseDefaultEmoji: isUseDefaultEmoji,
              customEmojiStickerList: customEmojiStickerList);
    };
  }

  /// get the [LinkPreviewContent] with preview widget and website information for the first link.
  /// If you provide `onUpdateMessage(String linkInfoJson)`, it can save the link info to local custom data than call updating the message on UI automatically.
  static Future<LinkPreviewContent?> getFirstLinkPreviewContent(
      {required V2TimMessage message,
      ValueChanged<V2TimMessage>? onUpdateMessage}) async {
    final String? messageText = message.textElem?.text;
    if (messageText == null) {
      return null;
    }

    final List<String> urlMatches = LinkUtils.getURLMatches(messageText);
    if (urlMatches.isEmpty) {
      return null;
    }

    final List<LocalCustomDataModel?> previewItemList =
        await LinkUtils.getURLPreview([urlMatches[0]]);
    if (previewItemList.isNotEmpty) {
      final LocalCustomDataModel previewItem = previewItemList.first!;
      if (onUpdateMessage != null) {
        LinkUtils.saveToLocalAndUpdate(message, previewItem, onUpdateMessage);
      }
      return LinkPreviewContent(
        linkInfo: previewItem,
        linkPreviewWidget: LinkPreviewWidget(linkPreview: previewItem),
      );
    } else {
      return null;
    }
  }

  /// get the [LinkPreviewContent] with preview widget and website information for all the links
  static Future<List<LinkPreviewContent?>?> getAllLinkPreviewContent(
      V2TimMessage message) async {
    final String? messageText = message.textElem?.text;
    if (messageText == null) {
      return null;
    }

    final List<String> urlMatches = LinkUtils.getURLMatches(messageText);
    if (urlMatches.isEmpty) {
      return [];
    }

    final List<LocalCustomDataModel> previewItemList =
        await LinkUtils.getURLPreview([urlMatches[0]]);
    if (previewItemList.isNotEmpty) {
      final List<LinkPreviewContent?> resultList = previewItemList
          .map((e) => LinkPreviewContent(
                linkInfo: e,
                linkPreviewWidget: LinkPreviewWidget(linkPreview: e),
              ))
          .toList();

      return resultList;
    } else {
      return [];
    }
  }

  static String linkInfoToString(LocalCustomDataModel linkInfo) {
    return linkInfo.toString();
  }
}
