import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_info/tencent_cloud_chat_message_info_options.dart';

/// TODO: 消息详情页面，展示已读回执
class TencentCloudChatMessageInfo extends StatefulWidget {
  final TencentCloudChatMessageInfoOptions options;
  const TencentCloudChatMessageInfo({super.key, required this.options});

  @override
  State<TencentCloudChatMessageInfo> createState() =>
      _TencentCloudChatMessageInfoState();
}

class _TencentCloudChatMessageInfoState
    extends TencentCloudChatState<TencentCloudChatMessageInfo> {
  @override
  Widget defaultBuilder(BuildContext context) {
    // TODO: implement defaultBuilder
    throw UnimplementedError();
  }
}
