import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_custom.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_file.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_image.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_merge.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_sound.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_tips_common.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_video.dart';

import 'message_type_builders/tencent_cloud_chat_message_text.dart';

typedef MessageWidgetBuilder = Widget? Function({
  Key? key,
  required V2TimMessage message,
  required bool shouldBeHighlighted,
  required VoidCallback clearHighlightFunc,
  required bool showMessageStatusIndicator,
  required bool showMessageTimeIndicator,
  V2TimMessageReceipt? messageReceipt,
  String? userID,
  String? groupID,
  required double messageRowWidth,
  SendingMessageData? sendingMessageData,
  required bool renderOnMenuPreview,
  required bool inSelectMode,
  required VoidCallback onSelectMessage,
});

typedef CommonTipsBuilder = Widget? Function({
  Key? key,
  required V2TimMessage message,
  required String text,
});

class TencentCloudChatMessageItemBuilders {
  MessageWidgetBuilder? _textMessageBuilder;
  CommonTipsBuilder? _commonTipsBuilder;
  MessageWidgetBuilder? _imageMessageBuilder;
  MessageWidgetBuilder? _soundMessageBuilder;
  MessageWidgetBuilder? _fileMessageBuilder;
  MessageWidgetBuilder? _videoMessageBuilder;
  MessageWidgetBuilder? _mergeMessageBuilder;
  MessageWidgetBuilder? _customMessageBuilder;

  TencentCloudChatMessageItemBuilders({
    MessageWidgetBuilder? textMessageBuilder,
    CommonTipsBuilder? commonTipsBuilder,
  }) {
    _textMessageBuilder = textMessageBuilder;
    _commonTipsBuilder = commonTipsBuilder;
  }

  Widget getMessageTipsBuilder({
    Key? key,
    required V2TimMessage message,
    required,
    required String text,
  }) {
    final int messageType = message.elemType;
    switch (messageType) {
      case 101:
// Time Divider
        return getCommonTipsBuilder(
          message: message,
          text: text,
        );
      default:
        return getCommonTipsBuilder(message: message, text: text);
    }
  }

  Widget getImageMessageBuilder({
    Key? key,
    String? userID,
    String? groupID,
    required V2TimMessage message,
    required bool shouldBeHighlighted,
    required VoidCallback clearHighlightFunc,
    V2TimMessageReceipt? messageReceipt,
    required bool showMessageStatusIndicator,
    required bool showMessageTimeIndicator,
    SendingMessageData? sendingMessageData,
    required double messageRowWidth,
    required bool renderOnMenuPreview,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
  }) {
    Widget? widget;

    if (_imageMessageBuilder != null) {
      widget = _imageMessageBuilder!(
        key: key,
        message: message,
        shouldBeHighlighted: shouldBeHighlighted,
        clearHighlightFunc: clearHighlightFunc,
        messageReceipt: messageReceipt,
        showMessageTimeIndicator: showMessageTimeIndicator,
        showMessageStatusIndicator: showMessageStatusIndicator,
        userID: userID,
        groupID: groupID,
        messageRowWidth: messageRowWidth,
        sendingMessageData: sendingMessageData,
        onSelectMessage: onSelectMessage,
        inSelectMode: inSelectMode,
        renderOnMenuPreview: renderOnMenuPreview,
      );
    }

    return widget ??
        TencentCloudChatMessageImage(
          key: key,
          message: message,
          userID: userID,
          groupID: groupID,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          messageReceipt: messageReceipt,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          messageRowWidth: messageRowWidth,
          renderOnMenuPreview: renderOnMenuPreview,
          sendingMessageData: sendingMessageData,
        );
  }

  Widget getCustomMessageBuilder({
    Key? key,
    String? userID,
    String? groupID,
    required V2TimMessage message,
    required bool shouldBeHighlighted,
    required VoidCallback clearHighlightFunc,
    V2TimMessageReceipt? messageReceipt,
    required double messageRowWidth,
    required bool showMessageStatusIndicator,
    required bool showMessageTimeIndicator,
    SendingMessageData? sendingMessageData,
    required bool renderOnMenuPreview,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
  }) {
    Widget? widget;

    if (_customMessageBuilder != null) {
      widget = _customMessageBuilder!(
        key: key,
        message: message,
        shouldBeHighlighted: shouldBeHighlighted,
        clearHighlightFunc: clearHighlightFunc,
        messageReceipt: messageReceipt,
        messageRowWidth: messageRowWidth,
        sendingMessageData: sendingMessageData,
        userID: userID,
        groupID: groupID,
        renderOnMenuPreview: renderOnMenuPreview,
        showMessageTimeIndicator: showMessageTimeIndicator,
        showMessageStatusIndicator: showMessageStatusIndicator,
        onSelectMessage: onSelectMessage,
        inSelectMode: inSelectMode,
      );
    }

    return widget ??
        TencentCloudChatMessageCustom(
          key: key,
          message: message,
          userID: userID,
          groupID: groupID,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          messageReceipt: messageReceipt,
          messageRowWidth: messageRowWidth,
          sendingMessageData: sendingMessageData,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          renderOnMenuPreview: renderOnMenuPreview,
        );
  }

  Widget getVideoMessageBuilder({
    Key? key,
    String? userID,
    String? groupID,
    required V2TimMessage message,
    required bool shouldBeHighlighted,
    required VoidCallback clearHighlightFunc,
    required bool showMessageStatusIndicator,
    required bool showMessageTimeIndicator,
    V2TimMessageReceipt? messageReceipt,
    required double messageRowWidth,
    SendingMessageData? sendingMessageData,
    required bool renderOnMenuPreview,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
  }) {
    Widget? widget;

    if (_videoMessageBuilder != null) {
      widget = _videoMessageBuilder!(
        key: key,
        message: message,
        shouldBeHighlighted: shouldBeHighlighted,
        clearHighlightFunc: clearHighlightFunc,
        messageReceipt: messageReceipt,
        messageRowWidth: messageRowWidth,
        sendingMessageData: sendingMessageData,
        userID: userID,
        groupID: groupID,
        showMessageTimeIndicator: showMessageTimeIndicator,
        showMessageStatusIndicator: showMessageStatusIndicator,
        renderOnMenuPreview: renderOnMenuPreview,
        onSelectMessage: onSelectMessage,
        inSelectMode: inSelectMode,
      );
    }

    return widget ??
        TencentCloudChatMessageVideo(
          key: key,
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          messageReceipt: messageReceipt,
          messageRowWidth: messageRowWidth,
          sendingMessageData: sendingMessageData,
          userID: userID,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          groupID: groupID,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          renderOnMenuPreview: renderOnMenuPreview,
        );
  }

  Widget getSoundMessageBuilder({
    Key? key,
    String? userID,
    String? groupID,
    required V2TimMessage message,
    required bool shouldBeHighlighted,
    required bool showMessageStatusIndicator,
    required bool showMessageTimeIndicator,
    required VoidCallback clearHighlightFunc,
    V2TimMessageReceipt? messageReceipt,
    required double messageRowWidth,
    SendingMessageData? sendingMessageData,
    CurrentPlayAudioInfo? currentPlayAudioInfo,
    required bool renderOnMenuPreview,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
  }) {
    Widget? widget;

    if (_soundMessageBuilder != null) {
      widget = _soundMessageBuilder!(
        key: key,
        message: message,
        shouldBeHighlighted: shouldBeHighlighted,
        clearHighlightFunc: clearHighlightFunc,
        messageReceipt: messageReceipt,
        onSelectMessage: onSelectMessage,
        userID: userID,
        groupID: groupID,
        showMessageTimeIndicator: showMessageTimeIndicator,
        showMessageStatusIndicator: showMessageStatusIndicator,
        inSelectMode: inSelectMode,
        messageRowWidth: messageRowWidth,
        renderOnMenuPreview: renderOnMenuPreview,
        sendingMessageData: sendingMessageData,
      );
    }

    return widget ??
        TencentCloudChatMessageSound(
          key: key,
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          messageReceipt: messageReceipt,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          renderOnMenuPreview: renderOnMenuPreview,
          userID: userID,
          groupID: groupID,
          messageRowWidth: messageRowWidth,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          sendingMessageData: sendingMessageData,
        );
  }

  Widget getFileMessageBuilder({
    Key? key,
    required V2TimMessage message,
    String? userID,
    String? groupID,
    required bool shouldBeHighlighted,
    required bool showMessageStatusIndicator,
    required bool showMessageTimeIndicator,
    required VoidCallback clearHighlightFunc,
    V2TimMessageReceipt? messageReceipt,
    required double messageRowWidth,
    SendingMessageData? sendingMessageData,
    required bool renderOnMenuPreview,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
  }) {
    Widget? widget;

    if (_fileMessageBuilder != null) {
      widget = _fileMessageBuilder!(
        key: key,
        message: message,
        userID: userID,
        groupID: groupID,
        shouldBeHighlighted: shouldBeHighlighted,
        clearHighlightFunc: clearHighlightFunc,
        onSelectMessage: onSelectMessage,
        inSelectMode: inSelectMode,
        showMessageTimeIndicator: showMessageTimeIndicator,
        showMessageStatusIndicator: showMessageStatusIndicator,
        messageReceipt: messageReceipt,
        messageRowWidth: messageRowWidth,
        renderOnMenuPreview: renderOnMenuPreview,
        sendingMessageData: sendingMessageData,
      );
    }

    return widget ??
        TencentCloudChatMessageFile(
          key: key,
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          userID: userID,
          groupID: groupID,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          renderOnMenuPreview: renderOnMenuPreview,
          messageReceipt: messageReceipt,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          messageRowWidth: messageRowWidth,
          sendingMessageData: sendingMessageData,
        );
  }

  Widget getFaceMessageBuilder({
    Key? key,
    required V2TimMessage message,
    required bool shouldBeHighlighted,
    String? userID,
    String? groupID,
    required VoidCallback clearHighlightFunc,
    V2TimMessageReceipt? messageReceipt,
    required double messageRowWidth,
    required bool showMessageStatusIndicator,
    required bool showMessageTimeIndicator,
    SendingMessageData? sendingMessageData,
    required bool renderOnMenuPreview,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
  }) {
    return const Text("Sticker Message");
  }

  Widget getLocationMessageBuilder({
    Key? key,
    required String? userID,
    required String? groupID,
    required V2TimMessage message,
    required bool shouldBeHighlighted,
    required bool showMessageStatusIndicator,
    required bool showMessageTimeIndicator,
    required VoidCallback clearHighlightFunc,
    V2TimMessageReceipt? messageReceipt,
    required double messageRowWidth,
    SendingMessageData? sendingMessageData,
    required bool renderOnMenuPreview,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
  }) {
    return const Text("Location message todo");
  }

  Widget getMergeMessageBuilder({
    Key? key,
    required V2TimMessage message,
    String? userID,
    String? groupID,
    required bool shouldBeHighlighted,
    required VoidCallback clearHighlightFunc,
    V2TimMessageReceipt? messageReceipt,
    required bool showMessageStatusIndicator,
    required bool showMessageTimeIndicator,
    required double messageRowWidth,
    SendingMessageData? sendingMessageData,
    required bool renderOnMenuPreview,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
  }) {
    Widget? widget;

    if (_mergeMessageBuilder != null) {
      widget = _mergeMessageBuilder!(
        key: key,
        message: message,
        shouldBeHighlighted: shouldBeHighlighted,
        clearHighlightFunc: clearHighlightFunc,
        renderOnMenuPreview: renderOnMenuPreview,
        onSelectMessage: onSelectMessage,
        userID: userID,
        groupID: groupID,
        inSelectMode: inSelectMode,
        showMessageTimeIndicator: showMessageTimeIndicator,
        showMessageStatusIndicator: showMessageStatusIndicator,
        messageReceipt: messageReceipt,
        messageRowWidth: messageRowWidth,
        sendingMessageData: sendingMessageData,
      );
    }

    return widget ??
        TencentCloudChatMessageMerge(
          key: key,
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          renderOnMenuPreview: renderOnMenuPreview,
          userID: userID,
          groupID: groupID,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          messageReceipt: messageReceipt,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          messageRowWidth: messageRowWidth,
          sendingMessageData: sendingMessageData,
        );
  }

  Widget getMessageItemBuilder(
      {Key? key,
      required V2TimMessage message,
      String? userID,
      String? groupID,
      required bool showMessageStatusIndicator,
      required bool showMessageTimeIndicator,
      required bool shouldBeHighlighted,
      required VoidCallback clearHighlightFunc,
      V2TimMessageReceipt? messageReceipt,
      SendingMessageData? sendingMessageData,
      CurrentPlayAudioInfo? currentPlayAudioInfo,
      required double messageRowWidth,
      required bool renderOnMenuPreview,
      required bool inSelectMode,
      required VoidCallback onSelectMessage,
      required bool isMergeMessage,
      v}) {
    final int messageType = message.elemType;
    Widget renderWidget = Text(tL10n.messageInfo);
    switch (messageType) {
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        renderWidget = getTextMessageBuilder(
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          renderOnMenuPreview: renderOnMenuPreview,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          userID: userID,
          groupID: groupID,
          messageRowWidth: messageRowWidth,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          messageReceipt: messageReceipt,
          sendingMessageData: sendingMessageData,
        );
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        renderWidget = getImageMessageBuilder(
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          userID: userID,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          groupID: groupID,
          renderOnMenuPreview: renderOnMenuPreview,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          messageRowWidth: messageRowWidth,
          messageReceipt: messageReceipt,
          sendingMessageData: sendingMessageData,
        );
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        renderWidget = getFaceMessageBuilder(
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          renderOnMenuPreview: renderOnMenuPreview,
          clearHighlightFunc: clearHighlightFunc,
          messageRowWidth: messageRowWidth,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          onSelectMessage: onSelectMessage,
          userID: userID,
          groupID: groupID,
          inSelectMode: inSelectMode,
          messageReceipt: messageReceipt,
          sendingMessageData: sendingMessageData,
        );
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        renderWidget = getFileMessageBuilder(
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          clearHighlightFunc: clearHighlightFunc,
          messageRowWidth: messageRowWidth,
          userID: userID,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          groupID: groupID,
          renderOnMenuPreview: renderOnMenuPreview,
          messageReceipt: messageReceipt,
          sendingMessageData: sendingMessageData,
        );
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        renderWidget = getLocationMessageBuilder(
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          renderOnMenuPreview: renderOnMenuPreview,
          messageRowWidth: messageRowWidth,
          onSelectMessage: onSelectMessage,
          userID: userID,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          groupID: groupID,
          inSelectMode: inSelectMode,
          messageReceipt: messageReceipt,
          sendingMessageData: sendingMessageData,
        );
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        renderWidget = getSoundMessageBuilder(
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          renderOnMenuPreview: renderOnMenuPreview,
          messageRowWidth: messageRowWidth,
          onSelectMessage: onSelectMessage,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          inSelectMode: inSelectMode,
          messageReceipt: messageReceipt,
          userID: userID,
          groupID: groupID,
          sendingMessageData: sendingMessageData,
          currentPlayAudioInfo: currentPlayAudioInfo,
        );
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        renderWidget = getVideoMessageBuilder(
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          userID: userID,
          groupID: groupID,
          renderOnMenuPreview: renderOnMenuPreview,
          messageRowWidth: messageRowWidth,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          messageReceipt: messageReceipt,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          sendingMessageData: sendingMessageData,
        );
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        renderWidget = getMergeMessageBuilder(
          message: message,
          userID: userID,
          groupID: groupID,
          shouldBeHighlighted: shouldBeHighlighted,
          renderOnMenuPreview: renderOnMenuPreview,
          clearHighlightFunc: clearHighlightFunc,
          messageRowWidth: messageRowWidth,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          messageReceipt: messageReceipt,
          sendingMessageData: sendingMessageData,
        );
        break;
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        renderWidget = getCustomMessageBuilder(
          message: message,
          renderOnMenuPreview: renderOnMenuPreview,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          userID: userID,
          groupID: groupID,
          messageRowWidth: messageRowWidth,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          messageReceipt: messageReceipt,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          sendingMessageData: sendingMessageData,
        );
        break;
    }
    return renderWidget;
  }

  Widget getCommonTipsBuilder({
    Key? key,
    required V2TimMessage message,
    required String text,
  }) {
    Widget? widget;

    if (_commonTipsBuilder != null) {
      widget = _commonTipsBuilder!(key: key, message: message, text: text);
    }

    return widget ??
        TencentCloudChatMessageTipsCommon(
            key: key, text: text, message: message);
  }

  Widget getTextMessageBuilder({
    Key? key,
    String? userID,
    String? groupID,
    required V2TimMessage message,
    required bool shouldBeHighlighted,
    required VoidCallback clearHighlightFunc,
    required bool showMessageStatusIndicator,
    required bool showMessageTimeIndicator,
    V2TimMessageReceipt? messageReceipt,
    SendingMessageData? sendingMessageData,
    required double messageRowWidth,
    required bool renderOnMenuPreview,
    required bool inSelectMode,
    required VoidCallback onSelectMessage,
  }) {
    Widget? widget;

    if (_textMessageBuilder != null) {
      widget = _textMessageBuilder!(
        key: key,
        message: message,
        shouldBeHighlighted: shouldBeHighlighted,
        clearHighlightFunc: clearHighlightFunc,
        messageReceipt: messageReceipt,
        userID: userID,
        groupID: groupID,
        messageRowWidth: messageRowWidth,
        sendingMessageData: sendingMessageData,
        renderOnMenuPreview: renderOnMenuPreview,
        showMessageTimeIndicator: showMessageTimeIndicator,
        showMessageStatusIndicator: showMessageStatusIndicator,
        onSelectMessage: onSelectMessage,
        inSelectMode: inSelectMode,
      );
    }

    return widget ??
        TencentCloudChatMessageText(
          key: key,
          message: message,
          shouldBeHighlighted: shouldBeHighlighted,
          clearHighlightFunc: clearHighlightFunc,
          userID: userID,
          groupID: groupID,
          messageReceipt: messageReceipt,
          onSelectMessage: onSelectMessage,
          inSelectMode: inSelectMode,
          messageRowWidth: messageRowWidth,
          showMessageTimeIndicator: showMessageTimeIndicator,
          showMessageStatusIndicator: showMessageStatusIndicator,
          sendingMessageData: sendingMessageData,
          renderOnMenuPreview: renderOnMenuPreview,
        );
  }
}
