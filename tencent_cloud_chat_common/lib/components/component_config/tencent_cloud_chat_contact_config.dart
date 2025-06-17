import 'package:tencent_cloud_chat_common/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatContactConfig {
  setConfigs() {
    TencentCloudChat.instance.dataInstance.contact.notifyListener(TencentCloudChatContactDataKeys.config);
  }
}
