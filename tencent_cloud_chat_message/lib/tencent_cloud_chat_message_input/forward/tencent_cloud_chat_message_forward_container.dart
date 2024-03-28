import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';

enum TencentCloudChatForwardType { individually, combined }

class TencentCloudChatMessageForwardContainer extends StatefulWidget {
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
  });

  @override
  State<TencentCloudChatMessageForwardContainer> createState() => _TencentCloudChatMessageForwardContainerState();
}

class _TencentCloudChatMessageForwardContainerState extends TencentCloudChatState<TencentCloudChatMessageForwardContainer> {
  @override
  Widget defaultBuilder(BuildContext context) {
    final conversationList = TencentCloudChat().dataInstance.conversation.conversationList;
    final contactList = TencentCloudChat().dataInstance.contact.contactList;
    final groupList = TencentCloudChat().dataInstance.contact.groupList;

    return TencentCloudChatMessageBuilders.getMessageForwardBuilder(
      type: widget.type,
      conversationList: conversationList.toList(),
      onSelectConversations: (chatList) {
        final messageModal = TencentCloudChatMessageDataProviderInherited.of(widget.context);
        if (widget.type == TencentCloudChatForwardType.individually) {
          messageModal.sendForwardIndividuallyMessage(widget.messages.map((e) => e.msgID ?? "").toList(), chatList);
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
      groupList: groupList,
      contactList: contactList,
    );
  }
}
