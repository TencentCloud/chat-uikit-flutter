
import 'package:tencent_cloud_chat/data/search/tencent_cloud_chat_search_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatSearchConfig {
  setConfigs() {
    TencentCloudChat.instance.dataInstance.search.notifyListener(TencentCloudChatSearchDataKeys.searchConfig);
  }
}
