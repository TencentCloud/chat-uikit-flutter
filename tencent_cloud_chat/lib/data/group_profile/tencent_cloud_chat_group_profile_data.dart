import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';

enum TencentCloudChatGroupProfileDataKeys {
  none,
}

class TencentCloudChatGroupProfileData<T> extends TencentCloudChatDataAB<T> {
  static final Map<String, List<String>> _groupNineSquareAvatarCache =
      Map.from({});

  TencentCloudChatGroupProfileData(super.currentUpdatedFields);

  List<String> getGroupNineSquareAvatarCacheByGroupID({
    required String groupID,
  }) {
    return _groupNineSquareAvatarCache[groupID] ?? [];
  }

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
