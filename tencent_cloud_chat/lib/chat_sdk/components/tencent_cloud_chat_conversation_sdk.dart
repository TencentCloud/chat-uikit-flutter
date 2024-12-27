import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';

class TencentCloudChatConversationSDKGenerator {
  static TencentCloudChatConversationSDK getInstance() {
    return TencentCloudChatConversationSDK._();
  }
}

class TencentCloudChatConversationSDK {
  static const String _tag = "TencentCloudChatUIKitConversationSDK";

  TencentCloudChatConversationSDK._();

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: log,
    );
  }

  Future<V2TimCallback> pinConversation({
    required String conversationID,
    required bool isPinned,
  }) async {
    V2TimCallback pinRes =
        await TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().pinConversation(
              conversationID: conversationID,
              isPinned: isPinned,
            );

    console("pinConversation exec, conversationID is $conversationID res is ${pinRes.code} desc is ${pinRes.desc}");

    return pinRes;
  }

  Future<V2TimConversation> getConversation({String? userID, String? groupID, String? conversationID}) async {
    final convID = conversationID ?? (TencentCloudChatUtils.checkString(userID) != null ? "c2c_$userID" : "group_$groupID");
    final res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getConversationManager()
        .getConversation(conversationID: convID);
    if (res.code == 0 && res.data != null) {
      return res.data!;
    }
    if (TencentCloudChatUtils.checkString(userID) != null) {
      V2TimUserFullInfo? userProfile;
      final userProfileRes =
          await TencentCloudChat.instance.chatSDKInstance.manager.getUsersInfo(userIDList: [userID ?? ""]);
      if (userProfileRes.data != null && userProfileRes.data!.isNotEmpty) {
        userProfile = userProfileRes.data!.first;
      }
      return V2TimConversation(
        conversationID: convID,
        userID: TencentCloudChatUtils.checkString(userID),
        faceUrl: TencentCloudChatUtils.checkString(userProfile?.faceUrl),
        showName: TencentCloudChatUtils.checkString(userProfile?.nickName) ??
            TencentCloudChatUtils.checkString(userProfile?.userID) ??
            TencentCloudChatUtils.checkString(userID) ??
            tL10n.chat,
        type: 1,
      );
    } else {
      V2TimGroupInfo? groupInfo;
      final groupInfoRes = await TencentCloudChat.instance.chatSDKInstance.manager
          .getGroupManager()
          .getGroupsInfo(groupIDList: [groupID ?? ""]);
      if (groupInfoRes.data != null && groupInfoRes.data!.isNotEmpty) {
        groupInfo = groupInfoRes.data!.first.groupInfo;
      }
      return V2TimConversation(
        conversationID: convID,
        groupID: groupID,
        groupType: groupInfo?.groupType,
        faceUrl: TencentCloudChatUtils.checkString(groupInfo?.faceUrl),
        showName: TencentCloudChatUtils.checkString(groupInfo?.groupName) ??
            TencentCloudChatUtils.checkString(groupID) ??
            tL10n.chat,
        type: 2,
      );
    }
  }

  deleteConversation({
    required List<String> conversationIDList,
    required bool clearMessage,
  }) async {
    V2TimValueCallback<List<V2TimConversationOperationResult>> deleteRes =
    await TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().deleteConversationList(
      conversationIDList: conversationIDList,
      clearMessage: clearMessage,
    );

    console(
        "deleteConversationList exec, conversationID is ${conversationIDList.join(',')} res is ${deleteRes.code} desc is ${deleteRes.desc}");
  }

}
