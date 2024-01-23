import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';

class TencentCloudChatMessageInputSelectModeContainer extends StatefulWidget {
  const TencentCloudChatMessageInputSelectModeContainer({super.key});

  @override
  State<TencentCloudChatMessageInputSelectModeContainer> createState() =>
      _TencentCloudChatMessageInputSelectModeContainerState();
}

class _TencentCloudChatMessageInputSelectModeContainerState
    extends TencentCloudChatState<
        TencentCloudChatMessageInputSelectModeContainer> {
  @override
  Widget defaultBuilder(BuildContext context) {
    final dataProvider =
        TencentCloudChatMessageDataProviderInherited.of(context);
    final TencentCloudChatMessageConfig config = dataProvider.config;

    return TencentCloudChatMessageBuilders.getMessageInputSelectBuilder(
      messages: dataProvider.selectedMessages,
      useDeleteForEveryone: config.enableMessageDeleteForEveryone(
        userID: dataProvider.userID,
        groupID: dataProvider.groupID,
      ),
      onDeleteForMe: (messages) {
        dataProvider.inSelectMode = false;
        Future.delayed(const Duration(milliseconds: 10), () {
          dataProvider.deleteMessagesForMe(messages: messages);
        });
      },
      onDeleteForEveryone: (messages) {
        dataProvider.inSelectMode = false;
        Future.delayed(const Duration(milliseconds: 10), () {
          dataProvider.deleteMessagesForEveryone(messages: messages);
        });
      },
    );
  }
}
