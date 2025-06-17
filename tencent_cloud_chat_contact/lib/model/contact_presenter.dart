import 'dart:convert';

import 'package:tencent_cloud_chat_common/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/message_custom.dart';

class ContactPresenter {
  static const String _tag = "ContactPresenter";

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

  Future<V2TimValueCallback<String>> createGroup(
      String groupType, String groupID, String groupName, String faceUrl, List<V2TimGroupMember>? memberList) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().createGroup(
        groupType: groupType, groupID: groupID, groupName: groupName, faceUrl: faceUrl, memberList: memberList);
    if (result.code != 0) {
      TencentCloudChat.instance.logInstance.console(
        componentName: _tag,
        logs: "createGroup - code:${result.code}, desc:${result.desc}",
        logLevel: TencentCloudChatLogLevel.error,
      );
    } else {
      var loginUserResult = await TencentImSDKPlugin.v2TIMManager.getLoginUser();
      final messageCustom = MessageCustom(
        version: MessageCustom.groupCreateVersion,
        businessID: MessageCustom.businessIDGroupCreate,
        opUser: loginUserResult.data!,
        content: tL10n.createGroupTips,
        cmd: groupType == GroupType.Community ? 1 : 0,
      );

      // 转换为 JSON 字符串
      final jsonData = jsonEncode(messageCustom.toJson());
      final createResult =
          await TencentImSDKPlugin.v2TIMManager.getMessageManager().createCustomMessage(data: jsonData);
      if (createResult.code == 0) {
        await Future.delayed(const Duration(milliseconds: 200));

        final sendMessageResult = await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: createResult.data?.id ?? '',
              groupID: result.data as String,
              receiver: "",
            );
        if (sendMessageResult.code != 0) {
          TencentCloudChat.instance.logInstance.console(
            componentName: _tag,
            logs: "sendCreateGroupCustomMessage code:${result.code}, desc:${result.desc}",
            logLevel: TencentCloudChatLogLevel.error,
          );
        }
      }
    }

    return result;
  }

  Future<List<V2TimGroupInfoResult>?> getGroupsInfo({
    required List<String> groupIDList,
  }) async {
    final result = await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupsInfo(groupIDList: groupIDList);
    if (result.code == 0) {
      return result.data;
    } else {
      TencentCloudChat.instance.logInstance.console(
        componentName: _tag,
        logs: "getGroupsInfo - code:${result.code}, desc:${result.desc}",
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
    final result = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupMemberList(groupID: groupID, filter: filter, nextSeq: nextSeq, count: count, offset: offset);
    if (result.code == 0) {
      return result;
    }

    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: "getGroupMemberList - code:${result.code}, desc:${result.desc}",
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

  Future<V2TimCallback> transferGroupOwner({required String groupID, required String userID}) async {
    V2TimCallback transferOwnerResult = await TencentImSDKPlugin.v2TIMManager.getGroupManager().transferGroupOwner(
        groupID: groupID,
        userID: userID,
    );
    return transferOwnerResult;
  }
}
