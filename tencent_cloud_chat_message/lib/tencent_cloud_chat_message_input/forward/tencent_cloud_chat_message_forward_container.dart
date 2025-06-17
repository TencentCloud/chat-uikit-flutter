import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';

class TencentCloudChatMessageForwardContainer extends StatefulWidget {
  final MFInternalBuilder? messageForwardBuilder;
  final TencentCloudChatForwardType type;
  final BuildContext context;
  final List<V2TimMessage> messages;
  final VoidCallback? onCloseModal;

  const TencentCloudChatMessageForwardContainer({
    super.key,
    required this.type,
    required this.context,
    required this.messages,
    this.onCloseModal,
    required this.messageForwardBuilder,
  });

  @override
  State<TencentCloudChatMessageForwardContainer> createState() => _TencentCloudChatMessageForwardContainerState();
}

class _TencentCloudChatMessageForwardContainerState
    extends TencentCloudChatState<TencentCloudChatMessageForwardContainer> {
  @override
  Widget defaultBuilder(BuildContext context) {
    final conversationList = TencentCloudChat.instance.dataInstance.conversation.conversationList;
    final contactList = TencentCloudChat.instance.dataInstance.contact.contactList;
    final groupList = TencentCloudChat.instance.dataInstance.contact.groupList;

    return widget.messageForwardBuilder?.call(
          data: MessageForwardBuilderData(
            type: widget.type,
            conversationList: conversationList.toList(),
            groupList: groupList,
            contactList: contactList,
          ),
          methods: MessageForwardBuilderMethods(
            onSelectConversations: (chatList) {
              final messageModal = TencentCloudChatMessageDataProviderInherited.of(widget.context);
              if (widget.type == TencentCloudChatForwardType.individually) {
                messageModal.sendForwardIndividuallyMessage(
                    widget.messages.map((e) => e.msgID ?? "").toList(), chatList);
              } else {
                messageModal.sendForwardCombinedMessage(widget.messages, chatList);
              }
              messageModal.inSelectMode = false;
              if (widget.onCloseModal != null) {
                widget.onCloseModal!();
              } else {
                Navigator.pop(context);
              }
            },
            onCancel: widget.onCloseModal ?? () => Navigator.pop(context),
          ),
        ) ??
        Container();
  }
}
