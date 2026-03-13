import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';

class TencentCloudChatMessageDataProviderInherited extends InheritedWidget {
  final TencentCloudChatMessageSeparateDataProvider dataProvider;

  const TencentCloudChatMessageDataProviderInherited(
      {Key? key, required this.dataProvider, required Widget child})
      : super(key: key, child: child);

  static TencentCloudChatMessageSeparateDataProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            TencentCloudChatMessageDataProviderInherited>()!
        .dataProvider;
  }
  
  // CRITICAL: Provide messageBuilders getter for convenience
  TencentCloudChatMessageBuilders? get messageBuilders => dataProvider.messageBuilders;
  
  // CRITICAL: Provide getSelectedMessages method for convenience
  List<V2TimMessage> getSelectedMessages() => dataProvider.getSelectedMessages();

  @override
  bool updateShouldNotify(
      TencentCloudChatMessageDataProviderInherited oldWidget) {
    return oldWidget.dataProvider != dataProvider;
  }
}
