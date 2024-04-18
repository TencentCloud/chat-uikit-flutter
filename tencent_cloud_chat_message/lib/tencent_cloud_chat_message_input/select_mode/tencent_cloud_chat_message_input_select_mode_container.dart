import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';

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

    final defaultMessageSelectionOperationsConfig =
        dataProvider.config.defaultMessageSelectionOperationsConfig(
      userID: dataProvider.userID,
      groupID: dataProvider.groupID,
    );

    return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageInputSelectBuilder(
      messages: dataProvider.selectedMessages,
      enableMessageDeleteForEveryone: config.enableMessageDeleteForEveryone(
            userID: dataProvider.userID,
            groupID: dataProvider.groupID,
          ) &&
          defaultMessageSelectionOperationsConfig
              .enableMessageDeleteForEveryone,
      enableMessageForwardIndividually: defaultMessageSelectionOperationsConfig
          .enableMessageForwardIndividually,
      enableMessageForwardCombined:
          defaultMessageSelectionOperationsConfig.enableMessageForwardCombined,
      enableMessageDeleteForSelf:
          defaultMessageSelectionOperationsConfig.enableMessageDeleteForSelf,
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
    ) ?? Container();
  }
}
