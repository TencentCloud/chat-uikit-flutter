import 'package:tencent_cloud_chat/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatGroupProfileConfig {
  setConfigs() {
    TencentCloudChat.instance.dataInstance.groupProfile
        .notifyListener(TencentCloudChatGroupProfileDataKeys.config);
  }
}
