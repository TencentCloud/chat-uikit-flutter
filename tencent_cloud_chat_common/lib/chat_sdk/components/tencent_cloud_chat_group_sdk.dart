// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat_common/eventbus/tencent_cloud_chat_eventbus.dart';
import 'package:tencent_cloud_chat_common/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_code_info.dart';

class TencentCloudChatGroupSDKGenerator {
  static TencentCloudChatGroupSDK getInstance() {
    return TencentCloudChatGroupSDK._();
  }
}

class TencentCloudChatGroupSDK {
  static const String _tag = "TencentCloudChatGroupSDK";

  TencentCloudChatGroupSDK._();

  late V2TimGroupListener groupListener = V2TimGroupListener(
    onAllGroupMembersMuted: (groupID, isMute) {},
    onGrantAdministrator: (groupID, opUser, memberList) {
      TencentCloudChat.instance.dataInstance.groupProfile
          .updateGroupMemberRole(groupID, memberList, GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN);
    },
    onRevokeAdministrator: (groupID, opUser, memberList) {
      TencentCloudChat.instance.dataInstance.groupProfile
          .updateGroupMemberRole(groupID, memberList, GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER);
    },
    onGroupAttributeChanged: (groupID, groupAttributeMap) {},
    onGroupCounterChanged: (groupID, key, newValue) {},
    onGroupCreated: (groupID) {
      handleJoinGroup(groupID, null);
    },
    onGroupDismissed: (groupID, opUser) {
      notifyGroupDismissed(groupID);
      handleQuitFromGroup(groupID);
    },
    onGroupInfoChanged: (groupID, changeInfos) {
      TencentCloudChat.instance.dataInstance.contact.updateGroupInfo(groupID, changeInfos);
    },
    onGroupRecycled: (groupID, opUser) {
      handleQuitFromGroup(groupID);
    },
    // Only applicants can receive
    onApplicationProcessed: (groupID, opUser, isAgreeJoin, opReason) {},
    onReceiveJoinApplication: (groupID, member, opReason) {
      TencentCloudChat.instance.chatSDKInstance.contactSDK.getGroupApplicationList();
    },
    onMemberEnter: (groupID, memberList) async {
      handleMemberEnter(groupID, memberList);
    },
    onMemberInfoChanged: (groupID, v2TIMGroupMemberChangeInfoList) {
      TencentCloudChat.instance.dataInstance.groupProfile
          .updateGroupMemberInfo(groupID, v2TIMGroupMemberChangeInfoList);
    },
    onMemberInvited: (groupID, opUser, memberList) {
      TencentCloudChat.instance.dataInstance.groupProfile.addGroupMember(groupID, memberList);
      if (memberList.indexWhere(
              (element) => element.userID == TencentCloudChat.instance.dataInstance.basic.currentUser?.userID) >=
          0) {
        handleJoinGroup(groupID, null);
      }
    },
    onMemberKicked: (groupID, opUser, memberList) {
      TencentCloudChat.instance.dataInstance.groupProfile.deleteGroupMember(groupID, memberList);
      if (memberList.indexWhere(
              (element) => element.userID == TencentCloudChat.instance.dataInstance.basic.currentUser?.userID) >=
          0) {
        handleQuitFromGroup(groupID);
      }
    },
    onMemberLeave: (groupID, member) {
      TencentCloudChat.instance.dataInstance.groupProfile.deleteGroupMember(groupID, [member]);
    },
    onMemberMarkChanged: (groupID, memberIDList, markType, enableMark) {},
    onQuitFromGroup: (groupID) {
      handleQuitFromGroup(groupID);
    },
    onReceiveRESTCustomData: (groupID, customData) {},
  );

  void notifyGroupDismissed(String groupID) {
    V2TimGroupInfo groupInfo = TencentCloudChat.instance.dataInstance.contact.getGroupInfo(groupID);
    TencentCloudChat.instance.callbacks.onUserNotificationEvent(
        TencentCloudChatComponentsEnum.contact,
        TencentCloudChatUserNotificationEvent(
          eventCode: 0,
          text: tL10n.dismissGroupTips(groupInfo.groupName ?? groupInfo.groupID),
        ));
  }

  Future<void> handleJoinGroup(String groupID, V2TimGroupInfo? groupInfo) async {
    if (groupInfo == null) {
      var result = await getGroupsInfo(groupIDList: [groupID]);
      if (result != null) {
        V2TimGroupInfoResult groupInfoResult = result[0];
        groupInfo = groupInfoResult.groupInfo!;
      }
    }

    if (groupInfo != null) {
      TencentCloudChat.instance.dataInstance.contact.addGroupInfoToJoinedGroupList(groupInfo);
    }
  }

  void handleQuitFromGroup(String groupID) {
    TencentCloudChat.instance.dataInstance.contact.deleteGroupInfoFromJoinedGroupList(groupID);
  }

  void handleMemberEnter(String groupID, List<V2TimGroupMemberInfo> memberList) async {
    TencentCloudChat.instance.dataInstance.groupProfile.addGroupMember(groupID, memberList);
    for (var member in memberList) {
      if (member.userID == TencentCloudChat.instance.dataInstance.basic.currentUser?.userID) {
        var result = await getGroupsInfo(groupIDList: [groupID]);
        if (result != null) {
          V2TimGroupInfoResult groupInfoResult = result[0];
          V2TimGroupInfo? groupInfo = groupInfoResult.groupInfo;

          handleJoinGroup(groupID, groupInfo);
          if (groupInfo?.owner == member.userID) {
            return;
          }

          String groupName = groupInfo?.groupName ?? groupInfo?.groupID ?? '';
          TencentCloudChat.instance.callbacks.onUserNotificationEvent(
              TencentCloudChatComponentsEnum.contact,
              TencentCloudChatUserNotificationEvent(
                eventCode: 0,
                text: '${tL10n.joinedTip}$groupName',
              ));
        }
      }
    }
  }

  initGroupListener() {
    TencentCloudChat.instance.chatSDKInstance.manager.removeGroupListener(listener: groupListener);
    TencentCloudChat.instance.chatSDKInstance.manager.addGroupListener(listener: groupListener);
  }

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

  Future<V2TimValueCallback<List<V2TimGroupMemberFullInfo>>> getGroupMembersInfo({
    required String groupID,
    required List<String> memberList,
  }) async {
    return TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupMembersInfo(groupID: groupID, memberList: memberList);
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
    int? approveOpt,
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
            groupAddOpt: groupAddOpt,
            approveOpt: approveOpt));
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

  Future<V2TimValueCallback<List<V2TimGroupMemberOperationResult>>> inviteUserToGroup(
      {required String groupID, required List<String> userList}) async {
    return TencentImSDKPlugin.v2TIMManager.getGroupManager().inviteUserToGroup(
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

  Future<List<V2TimGroupInfo>> getJoinedGroupList() async {
    V2TimValueCallback<List<V2TimGroupInfo>> result =
        await TencentCloudChat.instance.chatSDKInstance.manager.getGroupManager().getJoinedGroupList();
    if (result.code == 0) {
      if (result.data != null) {
        return result.data ?? [];
      }
    } else {
      TencentCloudChat.instance.logInstance.console(
        componentName: _tag,
        logs: "getJoinedGroupList - code:${result.code}, desc:${result.desc}",
        logLevel: TencentCloudChatLogLevel.error,
      );
    }

    return [];
  }

  Future<V2TimCallback> quitGroup({required String groupID}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.quitGroup(groupID: groupID);
    if (res.code == 0) {
      TencentCloudChat.instance.dataInstance.contact.deleteGroupInfoFromJoinedGroupList(groupID);

      var groupProfileEvent = TencentCloudChatGroupProfileData(TencentCloudChatGroupProfileDataKeys.quitGroup);
      groupProfileEvent.updateGroupID = groupID;
      TencentCloudChat.instance.eventBusInstance.fire(groupProfileEvent, TencentCloudChatEventBus.eventNameGroup);
    }

    return res;
  }

  Future<V2TimCallback> dismissGroup({required String groupID}) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.dismissGroup(groupID: groupID);
    if (res.code == 0) {
      TencentCloudChat.instance.dataInstance.contact.deleteGroupInfoFromJoinedGroupList(groupID);

      var groupProfileEvent = TencentCloudChatGroupProfileData(TencentCloudChatGroupProfileDataKeys.quitGroup);
      groupProfileEvent.updateGroupID = groupID;
      TencentCloudChat.instance.eventBusInstance.fire(groupProfileEvent, TencentCloudChatEventBus.eventNameGroup);
    }
    return res;
  }

  Future<V2TimCallback> clearGroupHistoryMessage({required String groupID}) async {
    V2TimCallback clearGroupHistoryMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearGroupHistoryMessage(groupID: groupID);
    return clearGroupHistoryMessageRes;
  }

}
