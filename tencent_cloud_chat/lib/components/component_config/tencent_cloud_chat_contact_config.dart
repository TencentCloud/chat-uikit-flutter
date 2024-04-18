import 'package:tencent_cloud_chat/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatContactConfig {
  setConfigs() {
    TencentCloudChat.instance.dataInstance.contact
        .notifyListener(TencentCloudChatContactDataKeys.config);
  }
}
