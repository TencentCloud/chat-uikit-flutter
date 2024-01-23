import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';

enum TencentCloudChatUIDataKeys {
  none,
}

class TencentCloudChatUIData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatUIData(super.currentUpdatedFields);

  @override
  void notifyListener(T key) {
    // TODO: implement notifyListener
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
