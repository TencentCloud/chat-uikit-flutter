import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

enum TencentCloudChatSettingsDataKeys { none, userInfo }

class TencentCloudChatSettingsData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatSettingsData(super.currentUpdatedFields);

  @override
  void notifyListener(T key) {
    currentUpdatedFields = key;
    TencentCloudChat.eventBusInstance.fire(this);
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
