import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/desktop/tencent_cloud_chat_message_input_desktop.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_input/mobile/tencent_cloud_chat_message_input_mobile.dart';

class TencentCloudChatMessageInput extends StatefulWidget {
  final MessageInputBuilderWidgets? widgets;
  final MessageInputBuilderData data;
  final MessageInputBuilderMethods methods;

  const TencentCloudChatMessageInput({
    super.key,
    this.widgets,
    required this.data,
    required this.methods,
  });

  @override
  State<TencentCloudChatMessageInput> createState() =>
      _TencentCloudChatMessageInputState();
}

class _TencentCloudChatMessageInputState
    extends TencentCloudChatState<TencentCloudChatMessageInput> {
  String? _getMessageInputStatusText() {
    String? result;
    switch (widget.data.status) {
      case TencentCloudChatMessageInputStatus.canSendMessage:
        break;
      case TencentCloudChatMessageInputStatus.cantSendMessage:
        result = tL10n.cantSendMessage;
        break;
      case TencentCloudChatMessageInputStatus.noSuchGroup:
        result = tL10n.noSuchGroup;
        break;
      case TencentCloudChatMessageInputStatus.notGroupMember:
        result = tL10n.notGroupMember;
        break;
      case TencentCloudChatMessageInputStatus.userNotFound:
        result = tL10n.userNotFound;
        break;
      case TencentCloudChatMessageInputStatus.userBlockedYou:
        result = tL10n.userBlockedYou;
        break;
      case TencentCloudChatMessageInputStatus.muted:
        result = tL10n.muted;
        break;
      case TencentCloudChatMessageInputStatus.groupMuted:
        result = tL10n.groupMuted;
        break;
    }
    return result;
  }

  @override
  Widget tabletAppBuilder(BuildContext context) {
    return defaultBuilder(context);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    _getMessageInputStatusText();
    return TencentCloudChatMessageInputMobile(
      key: Key(TencentCloudChatUtils.checkString(widget.data.topicID) ?? TencentCloudChatUtils.checkString(widget.data.groupID) ?? widget.data.userID ?? ""),
      inputMethods: widget.methods,
      inputData: widget.data,
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    final String? statusText = _getMessageInputStatusText();
    return TencentCloudChatMessageInputDesktop(
      key: Key(TencentCloudChatUtils.checkString(widget.data.topicID) ?? TencentCloudChatUtils.checkString(widget.data.groupID) ?? widget.data.userID ?? ""),
      inputMethods: widget.methods,
      inputData: widget.data,
      statusText: statusText,
    );
  }
}
