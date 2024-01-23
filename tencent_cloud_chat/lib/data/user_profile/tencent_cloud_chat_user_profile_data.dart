import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';

enum TencentCloudChatUserProfileDataKeys {
  none,
}

class TencentCloudChatUserProfileData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatUserProfileData(super.currentUpdatedFields);

  String onlineStatus = "";

  @override
  void notifyListener(T key) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
