import 'package:tencent_cloud_chat/data/user_profile/tencent_cloud_chat_user_profile_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatUserProfileConfig {
  setConfigs() {
    TencentCloudChat.instance.dataInstance.userProfile
        .notifyListener(TencentCloudChatUserProfileDataKeys.config);
  }
}
