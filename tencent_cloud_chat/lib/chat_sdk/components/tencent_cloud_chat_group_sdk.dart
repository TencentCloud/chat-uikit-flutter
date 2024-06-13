// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:tencent_cloud_chat/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatGroupSDKGenerator {
  static TencentCloudChatGroupSDK getInstance() {
    return TencentCloudChatGroupSDK._();
  }
}

class TencentCloudChatGroupSDK {
  TencentCloudChatGroupSDK._();

  Future<List<V2TimTopicInfoResult>?> getTopicInfo({
    required String groupID,
    required List<String> topicIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getTopicInfoList(topicIDList: topicIDList, groupID: groupID,);
    if (res.code == 0) {
      return res.data;
    } else {
      var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
      TencentCloudChat.instance.logInstance.console(
        componentName: componentName,
        logs: "getGroupsInfo - ${res.desc}",
        logLevel: TencentCloudChatLogLevel.error,
      );
      return null;
    }
  }

  Future<List<V2TimGroupInfoResult>?> getGroupsInfo({
    required List<String> groupIDList,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupsInfo(groupIDList: groupIDList);
    if (res.code == 0) {
      return res.data;
    } else {
      var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
      TencentCloudChat.instance.logInstance.console(
        componentName: componentName,
        logs: "getGroupsInfo - ${res.desc}",
        logLevel: TencentCloudChatLogLevel.error,
      );
      return null;
    }
  }

  Future<V2TimValueCallback<V2TimGroupMemberInfoResult>?> getGroupMemberList({
    required String groupID,
    required GroupMemberFilterTypeEnum filter,
    required String nextSeq,
    int count = 15,
    int offset = 0,
  }) async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupMemberList(groupID: groupID, filter: filter, nextSeq: nextSeq, count: count, offset: offset);
    if (res.code == 0) {
      return res;
    }
    var componentName = runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.instance.logInstance.console(
      componentName: componentName,
      logs: "getGroupMemberList - ${res.desc}",
      logLevel: TencentCloudChatLogLevel.error,
    );
    return null;
  }

  final V2TimGroupListener groupListener = V2TimGroupListener(
    onAllGroupMembersMuted: (groupID, isMute) {},
    onApplicationProcessed: (groupID, opUser, isAgreeJoin, opReason) {},
    onGrantAdministrator: (groupID, opUser, memberList) {},
    onGroupAttributeChanged: (groupID, groupAttributeMap) {},
    onGroupCounterChanged: (groupID, key, newValue) {},
    onGroupCreated: (groupID) {},
    onGroupDismissed: (groupID, opUser) {},
    onGroupInfoChanged: (groupID, changeInfos) {
      List<V2TimConversation> conversationList = TencentCloudChat.instance.dataInstance.conversation.conversationList;
      int index = conversationList.indexWhere((element) => element.conversationID == "group_${groupID}");
      if (index > -1) {
        V2TimConversation conversation = conversationList[index];
        for (int i = 0; i < changeInfos.length; i++) {
          switch (changeInfos[i].type) {
            case 1:
              conversation.showName = changeInfos[i].value;
              break;
            case 4:
              conversation.faceUrl = changeInfos[i].value;
              break;
            default:
              break;
          }
        }
        TencentCloudChat.instance.dataInstance.conversation.buildConversationList([conversation], "onGroupInfoChanged");
      }
    },
    onGroupRecycled: (groupID, opUser) {},
    onMemberEnter: (groupID, memberList) {},
    onMemberInfoChanged: (groupID, v2TIMGroupMemberChangeInfoList) {},
    onMemberInvited: (groupID, opUser, memberList) {},
    onMemberKicked: (groupID, opUser, memberList) {},
    onMemberLeave: (groupID, member) {},
    onMemberMarkChanged: (groupID, memberIDList, markType, enableMark) {},
    onQuitFromGroup: (groupID) {},
    onReceiveJoinApplication: (groupID, member, opReason) {},
    onReceiveRESTCustomData: (groupID, customData) {},
    onRevokeAdministrator: (groupID, opUser, memberList) {},
    onTopicCreated: (groupID, topicID) {},
    onTopicDeleted: (groupID, topicIDList) {},
    onTopicInfoChanged: (groupID, topicInfo) {},
  );

  addGroupListener() async {
    await TencentCloudChat.instance.chatSDKInstance.manager.removeGroupListener(listener: groupListener);
    await TencentCloudChat.instance.chatSDKInstance.manager.addGroupListener(listener: groupListener);
  }

  Future<V2TimCallback> setGroupInfo({
    required String groupID,
    required String groupType,
    String? groupName,
    String? notification,
    String? introduction,
    String? faceUrl,
    bool? isAllMuted,
    int? groupAddOpt,
  }) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupInfo(
        info: V2TimGroupInfo(
            groupID: groupID,
            groupType: groupType,
            groupName: groupName,
            notification: notification,
            introduction: introduction,
            faceUrl: faceUrl,
            isAllMuted: isAllMuted,
            groupAddOpt: groupAddOpt));
    return res;
  }

  Future<V2TimCallback> setGroupMemberRole(
      {required String groupID, required String userID, required GroupMemberRoleTypeEnum role}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .setGroupMemberRole(groupID: groupID, userID: userID, role: role);
    return res;
  }

  Future<V2TimCallback> kickGroupMember(
      {required String groupID, required List<String> memberList, String reason = ""}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .kickGroupMember(groupID: groupID, memberList: memberList, reason: reason);
    return res;
  }

  Future<V2TimCallback> setGroupMemberInfo(
      {required String groupID, required String userID, String? nameCard, Map<String, String>? customInfo}) async {
    V2TimCallback setGroupMemberInfoRes = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .setGroupMemberInfo(groupID: groupID, userID: userID, nameCard: nameCard, customInfo: customInfo);
    return setGroupMemberInfoRes;
  }

  Future<V2TimCallback> setGroupReceiveMessageOpt({required String groupID, required ReceiveMsgOptEnum opt}) async {
    V2TimCallback setGroupReceiveMessageOptRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().setGroupReceiveMessageOpt(groupID: groupID, opt: opt);
    return setGroupReceiveMessageOptRes;
  }

  Future<V2TimCallback> clearGroupHistoryMessage({required String groupID}) async {
    V2TimCallback clearGroupHistoryMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearGroupHistoryMessage(groupID: groupID);
    return clearGroupHistoryMessageRes;
  }

  Future<V2TimCallback> quitGroup({required String groupID}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.quitGroup(
      groupID: groupID,
    );
    return res;
  }

  Future<V2TimCallback> dismissGroup({required String groupID}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.dismissGroup(groupID: groupID);
    return res;
  }

  inviteUserToGroup({required String groupID, required List<String> userList}) async {
    await TencentImSDKPlugin.v2TIMManager.getGroupManager().inviteUserToGroup(
          groupID: groupID,
          userList: userList,
        );
  }

  Future<V2TimCallback> muteGroupMember({required String groupID, required String userID, required int seconds}) async {
    V2TimCallback muteGroupMemberRes = await TencentImSDKPlugin.v2TIMManager.getGroupManager().muteGroupMember(
        groupID: groupID, // 禁言的群组id
        userID: userID, // 禁言的用户id
        seconds: seconds // 禁言时间
        );
    return muteGroupMemberRes;
  }
}
