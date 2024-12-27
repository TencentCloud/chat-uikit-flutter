import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatGroupPresenter {
  Future<List<V2TimGroupInfoResult>?> getGroupsInfo({
    required List<String> groupIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupsInfo(groupIDList: groupIDList);
    if (res.code == 0) {
      return res.data;
    } else {
      return null;
    }
  }

  Future<V2TimCallback> quitGroup({required String groupID}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.quitGroup(groupID: groupID);
    return res;
  }

  Future<V2TimCallback> dismissGroup({required String groupID}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.dismissGroup(groupID: groupID);
    return res;
  }

  Future<V2TimCallback> clearGroupHistoryMessage({required String groupID}) async {
    V2TimCallback clearGroupHistoryMessageRes =
    await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearGroupHistoryMessage(groupID: groupID);
    return clearGroupHistoryMessageRes;
  }
}