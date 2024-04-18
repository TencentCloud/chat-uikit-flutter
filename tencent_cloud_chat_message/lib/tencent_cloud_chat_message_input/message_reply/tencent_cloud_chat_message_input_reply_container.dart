import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';

class TencentCloudChatMessageInputReplyContainer extends StatefulWidget {
  final V2TimMessage? repliedMessage;

  const TencentCloudChatMessageInputReplyContainer({super.key, this.repliedMessage});
  @override
  State<TencentCloudChatMessageInputReplyContainer> createState() => _TencentCloudChatMessageInputReplyContainerState();
}

class _TencentCloudChatMessageInputReplyContainerState extends TencentCloudChatState<TencentCloudChatMessageInputReplyContainer> {
  late TencentCloudChatMessageSeparateDataProvider dataProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataProvider = TencentCloudChatMessageDataProviderInherited.of(context);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return dataProvider.messageBuilders?.getMessageInputReplyBuilder(
      repliedMessage: widget.repliedMessage,
      onCancel: () => dataProvider.repliedMessage = null,
      onClickReply: () => TencentCloudChat.instance.dataInstance.messageData.messageHighlighted = widget.repliedMessage,
    ) ?? Container();
  }
}
