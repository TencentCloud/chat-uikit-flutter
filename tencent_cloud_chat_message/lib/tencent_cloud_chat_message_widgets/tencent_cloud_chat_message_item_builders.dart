import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_custom.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_file.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_image.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_merge.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_sound.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_sticker.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_tips_common.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/message_type_builders/tencent_cloud_chat_message_video.dart';

import 'message_type_builders/tencent_cloud_chat_message_text.dart';

typedef MessageWidgetBuilder = Widget? Function({
  Key? key,
  required MessageItemBuilderData data,
  required MessageItemBuilderMethods methods,
});

typedef CommonTipsBuilder = Widget? Function({
  Key? key,
  required V2TimMessage message,
  required String text,
});

class TencentCloudChatMessageItemBuilders {
  static Widget getMessageTipsBuilder({
    Key? key,
    required V2TimMessage message,
    required String text,
  }) {
    final int messageType = message.elemType;
    switch (messageType) {
      case 101:
        return getCommonTipsBuilder(
          message: message,
          text: text,
        );
      default:
        return getCommonTipsBuilder(message: message, text: text);
    }
  }

  static Widget getImageMessageBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    
    return TencentCloudChatMessageImage(
      data: data,
      methods: methods,
    );
  }

  static Widget getCustomMessageBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    return TencentCloudChatMessageCustom(
      key: key,
      data: data,
      methods: methods,
    );
  }

  static Widget getVideoMessageBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    return TencentCloudChatMessageVideo(
      data: data,
      methods: methods,
    );
  }

  static Widget getSoundMessageBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    return TencentCloudChatMessageSound(
      key: key,
      data: data,
      methods: methods,
    );
  }

  static Widget getFileMessageBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    return TencentCloudChatMessageFile(
      key: key,
      data: data,
      methods: methods,
    );
  }

  static Widget getFaceMessageBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    return TencentCloudChatMessageSticker(
      key: key,
      data: data,
      methods: methods,
    );
  }

  static Widget getLocationMessageBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    return const Text("Location message todo");
  }

  static Widget getMergeMessageBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    return TencentCloudChatMessageMerge(
      key: key,
      data: data,
      methods: methods,
    );
  }

  static Widget getMessageItemBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    final int messageType = data.message.elemType;

    final tipsItem = data.message.elemType == 101 || data.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS;
    final recalledMessage = data.message.status == MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED;

    if (tipsItem || recalledMessage) {
      return getCommonTipsBuilder(
        message: data.message,
        text: data.altText,
        buttonText: (recalledMessage && (data.message.isSelf ?? true))
            ? (
                text: tL10n.reEdit,
                onTap: () => methods.setMessageTextWithMentions(
                      messageText: TencentCloudChatUtils.getMessageSummary(message: data.message, needStatus: false),
                      groupMembersNeedToMention: data.message.groupAtUserList ?? [],
                    )
              )
            : null,
      );
    }

    switch (messageType) {
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return getTextMessageBuilder(
          key: key,
          data: data,
          methods: methods,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return getImageMessageBuilder(
          key: key,
          data: data,
          methods: methods,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return getFaceMessageBuilder(
          key: key,
          data: data,
          methods: methods,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        return getFileMessageBuilder(
          key: key,
          data: data,
          methods: methods,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        return getLocationMessageBuilder(
          key: key,
          data: data,
          methods: methods,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return getSoundMessageBuilder(
          key: key,
          data: data,
          methods: methods,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        return getVideoMessageBuilder(
          key: key,
          data: data,
          methods: methods,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        return getMergeMessageBuilder(
          key: key,
          data: data,
          methods: methods,
        );
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return getCustomMessageBuilder(
          key: key,
          data: data,
          methods: methods,
        );
    }
    return Text(tL10n.messageInfo);
  }

  static Widget getCommonTipsBuilder({
    Key? key,
    required V2TimMessage message,
    required String text,
    ({String text, VoidCallback onTap})? buttonText,
  }) {
    return TencentCloudChatMessageTipsCommon(
      key: key,
      text: text,
      message: message,
      buttonText: buttonText,
    );
  }

  static Widget getTextMessageBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    return TencentCloudChatMessageText(
      key: key,
      data: data,
      methods: methods,
    );
  }
}
