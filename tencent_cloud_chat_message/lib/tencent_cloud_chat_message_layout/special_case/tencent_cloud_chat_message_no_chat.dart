import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/empty_page/tencent_cloud_chat_empty_page.dart';

class TencentCloudChatMessageNoChat extends StatefulWidget {
  const TencentCloudChatMessageNoChat({super.key});

  @override
  State<TencentCloudChatMessageNoChat> createState() =>
      _TencentCloudChatMessageNoChatState();
}

class _TencentCloudChatMessageNoChatState
    extends TencentCloudChatState<TencentCloudChatMessageNoChat> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatEmptyPage(
      icon: Icons.chat_outlined,
      primaryText: tL10n.selectAChat,
      secondaryText: tL10n.noConversationSelected,
    );
  }
}
