import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_message_reaction/data/message_reaction_data.dart';

class TencentCloudChatMessageReactionDataNotifier extends InheritedWidget {
  final TencentCloudChatMessageReactionData reactionData;

  const TencentCloudChatMessageReactionDataNotifier({
    super.key,
    required this.reactionData,
    required super.child,
  });

  static TencentCloudChatMessageReactionData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TencentCloudChatMessageReactionDataNotifier>()!.reactionData;
  }

  @override
  bool updateShouldNotify(covariant TencentCloudChatMessageReactionDataNotifier oldWidget) {
    return oldWidget.reactionData != reactionData;
  }
}
