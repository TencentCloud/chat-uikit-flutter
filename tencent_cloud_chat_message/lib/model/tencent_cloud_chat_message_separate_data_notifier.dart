import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';

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

  @override
  bool updateShouldNotify(
      TencentCloudChatMessageDataProviderInherited oldWidget) {
    return oldWidget.dataProvider != dataProvider;
  }
}
