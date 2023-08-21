import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_preview.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_text.dart';
import 'package:tim_ui_kit_sticker_plugin/utils/tim_custom_face_data.dart';

import 'models/link_preview_content.dart';

class LinkPreviewEntry {
  /// get the text message with hyperlinks
  static LinkPreviewText? getHyperlinksText(String messageText, bool isMarkdown,
      {Function(String)? onLinkTap,
      bool isEnableTextSelection = false,
      bool isUseQQPackage = false,
      bool isUseTencentCloudChatPackage = false,
      List<CustomEmojiFaceData> customEmojiStickerList = const []}) {
    return ({TextStyle? style}) {
      return isMarkdown
          ? LinkTextMarkdown(
              isUseQQPackage: isUseQQPackage,
              isUseTencentCloudChatPackage: isUseTencentCloudChatPackage,
              customEmojiStickerList: customEmojiStickerList,
              isEnableTextSelection: isEnableTextSelection,
              messageText: addSpaceAfterLeftBracket(
                  addSpaceBeforeHttp(replaceSingleNewlineWithTwo(messageText))),
              style: style,
              onLinkTap: onLinkTap)
          : LinkText(
              isEnableTextSelection: isEnableTextSelection,
              messageText: messageText,
              style: style,
              onLinkTap: onLinkTap,
              isUseQQPackage: isUseQQPackage,
              isUseTencentCloudChatPackage: isUseTencentCloudChatPackage,
              customEmojiStickerList: customEmojiStickerList);
    };
  }

  static String addSpaceAfterLeftBracket(String inputText) {
    return inputText.splitMapJoin(
      RegExp(r'<\w+[^<>]*>'),
      onMatch: (match) {
        return match.group(0)!.replaceFirst('<', '< ');
      },
      onNonMatch: (text) => text,
    );
  }

  static String replaceSingleNewlineWithTwo(String inputText) {
    return inputText.split('\n').join('\n\n');
  }

  static String addSpaceBeforeHttp(String inputText) {
    return inputText.splitMapJoin(
      RegExp(r'http'),
      onMatch: (match) {
        return ' http';
      },
      onNonMatch: (text) => text,
    );
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
