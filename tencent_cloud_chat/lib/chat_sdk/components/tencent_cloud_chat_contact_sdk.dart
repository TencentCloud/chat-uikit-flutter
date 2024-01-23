import 'package:tencent_cloud_chat/chat_sdk/tencent_cloud_chat_sdk.dart';
import 'package:tencent_cloud_chat/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatContactSDK {
  static const String _tag = "TencentCloudChatUIKitContactSDK";

  static final V2TimFriendshipListener friendshipListener =
      V2TimFriendshipListener(
    onFriendApplicationListAdded: (applicationList) {
      TencentCloudChat.dataInstance.contact.buildApplicationList(
          applicationList, 'onFriendApplicationListAdded');
    },
    onBlackListAdd: (blockList) {
      TencentCloudChat.dataInstance.contact
          .buildBlockList(blockList, 'onBlakcListAdd');
    },
    onBlackListDeleted: (blockList) {
      TencentCloudChat.dataInstance.contact
          .deleteFromBlockList(blockList, 'onBloackListDeleted');
    },
    onFriendApplicationListDeleted: (applicationList) {
      TencentCloudChat.dataInstance.contact.deleteApplicationList(
          applicationList, 'onFriendApplicationListAdded');
    },
    onFriendApplicationListRead: () {},
    onFriendInfoChanged: (contactList) {
      TencentCloudChat.dataInstance.contact
          .buildFriendList(contactList, 'onFriendInfoChanged');
    },
    onFriendListAdded: (contactList) {
      TencentCloudChat.dataInstance.contact
          .buildFriendList(contactList, 'onFriendListAdded');
    },
    onFriendListDeleted: (contactList) {
      TencentCloudChat.dataInstance.contact
          .deleteFromFriendList(contactList, 'onFriendListDeleted');
    },
  );

  static Future<void> getFriendList() async {
    V2TimValueCallback<List<V2TimFriendInfo>> getFriendListRes =
        await TencentCloudChatSDK.manager
            .getFriendshipManager()
            .getFriendList();
    if (getFriendListRes.code == 0) {
      List<V2TimFriendInfo> friendInfo = getFriendListRes.data ?? [];
      TencentCloudChat.dataInstance.contact
          .buildFriendList(friendInfo, 'getFriendList');
      if (friendInfo.isNotEmpty) {
        bool isGetUserStatus = TencentCloudChat
                .dataInstance.basic.userConfig.useUserOnlineStatus ??
            true;
        TencentCloudChat.logInstance.console(
          componentName: _tag,
          logs: "getFriendList exec. get user status is $isGetUserStatus",
        );
        if (isGetUserStatus) {
          List<String> userids = friendInfo.map((e) => e.userID).toList();
          await addUserStatusListener(userids: userids);
          V2TimValueCallback<List<V2TimUserStatus>> statusRes =
              await TencentCloudChatSDK.manager
                  .getUserStatus(userIDList: userids);
          if (statusRes.code == 0 && statusRes.data != null) {
            if (statusRes.data!.isNotEmpty) {
              TencentCloudChat.dataInstance.contact
                  .buildUserStatusList(statusRes.data!, "getUserStatus");
            }
          }
        }
      }
    }
  }

  static addFriendListener() async {
    await TencentCloudChatSDK.manager
        .getFriendshipManager()
        .removeFriendListener(listener: friendshipListener);
    await TencentCloudChatSDK.manager
        .getFriendshipManager()
        .addFriendListener(listener: friendshipListener);
  }

  static addUserStatusListener({
    required List<String> userids,
  }) async {
    await TencentCloudChatSDK.manager
        .unsubscribeUserStatus(userIDList: userids);
    await TencentCloudChatSDK.manager.subscribeUserStatus(userIDList: userids);
  }

  static Future<void> getFriendApplicationList() async {
    V2TimValueCallback<V2TimFriendApplicationResult>
        getFriendApplicationListRes = await TencentCloudChatSDK.manager
            .getFriendshipManager()
            .getFriendApplicationList();
    if (getFriendApplicationListRes.code == 0) {
      TencentCloudChat.dataInstance.contact.setApplicationUnreadCount(
          getFriendApplicationListRes.data!.unreadCount!);
      if (getFriendApplicationListRes.data!.friendApplicationList != null &&
          getFriendApplicationListRes.data!.friendApplicationList!.isNotEmpty) {
        List<V2TimFriendApplication> friendApplicationList = [];
        List<V2TimFriendInfo> contactList =
            TencentCloudChat.dataInstance.contact.contactList;
        List<V2TimFriendApplication?> listRes =
            getFriendApplicationListRes.data!.friendApplicationList!;
        for (var element in listRes) {
          if (element != null) {
            int index =
                contactList.indexWhere((e) => e.userID == element.userID);
            if (index < 0) {
              friendApplicationList.add(element);
            }
          }
        }
        TencentCloudChat.dataInstance.contact
            .setApplicationUnreadCount(friendApplicationList.length);
        TencentCloudChat.dataInstance.contact.buildApplicationList(
            friendApplicationList, 'getFriendApplicationList');
      }
    }
  }

  static Future<V2TimFriendOperationResult> acceptFriendApplication(
      String userID,
      FriendResponseTypeEnum? responseType,
      FriendApplicationTypeEnum? type) async {
    FriendResponseTypeEnum resType =
        responseType ?? TencentCloudChatContactData.responseType;
    FriendApplicationTypeEnum applicationType =
        type ?? TencentCloudChatContactData.applicationType;
    V2TimValueCallback<V2TimFriendOperationResult> res =
        await TencentCloudChatSDK.manager
            .getFriendshipManager()
            .acceptFriendApplication(
                responseType: resType, type: applicationType, userID: userID);
    if (res.code == 0) {
      if (res.data != null) {
        TencentCloudChat.dataInstance.contact
            .setApplicationCode(res.data?.resultCode ?? res.code, userID);
      }
    }
    return res.data ?? V2TimFriendOperationResult(userID: userID);
  }

  static Future<V2TimFriendOperationResult> refuseFriendApplication(
      String userID, FriendApplicationTypeEnum? type) async {
    FriendApplicationTypeEnum applicationType =
        type ?? TencentCloudChatContactData.applicationType;
    V2TimValueCallback<V2TimFriendOperationResult> res =
        await TencentCloudChatSDK.manager
            .getFriendshipManager()
            .refuseFriendApplication(type: applicationType, userID: userID);
    if (res.code == 0) {
      if (res.data != null) {
        TencentCloudChat.dataInstance.contact
            .setApplicationCode(res.data?.resultCode ?? res.code, userID);
      }
    }
    return res.data ?? V2TimFriendOperationResult(userID: userID);
  }

  static Future<void> getBlackList() async {
    V2TimValueCallback<List<V2TimFriendInfo>> res =
        await TencentCloudChatSDK.manager.getFriendshipManager().getBlackList();
    if (res.code == 0) {
      if (res.data != null) {
        List<V2TimFriendInfo> friendInfo = res.data ?? [];
        TencentCloudChat.dataInstance.contact
            .buildBlockList(friendInfo, 'getBlackList');
      }
    }
  }

  static Future<void> getGroupList() async {
    V2TimValueCallback<List<V2TimGroupInfo>> res = await TencentCloudChatSDK
        .manager
        .getGroupManager()
        .getJoinedGroupList();
    if (res.code == 0) {
      if (res.data != null) {
        TencentCloudChat.dataInstance.contact
            .buildGroupList(res.data ?? [], 'getGroupList');
      }
    }
  }

  static Future<void> checkFriend(
      List<String> userIDList, FriendTypeEnum? friendType) async {
    FriendTypeEnum friendTypeEnum =
        friendType ?? FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH;
    V2TimValueCallback<List<V2TimFriendCheckResult>> res =
        await TencentCloudChatSDK.manager
            .getFriendshipManager()
            .checkFriend(userIDList: userIDList, checkType: friendTypeEnum);
    if (res.code == 0 && res.data != null) {}
  }

  static Future<void> addFriend(
      String userID,
      String? remark,
      String? friendGroup,
      String? addWording,
      String? addSource,
      FriendTypeEnum? type) async {
    String r = remark ?? "";
    String fg = friendGroup ?? "";
    String wording = addWording ?? "";
    String source = addSource ?? "";
    FriendTypeEnum t = type ?? FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH;
    V2TimValueCallback<V2TimFriendOperationResult> res =
        await TencentCloudChatSDK.manager.getFriendshipManager().addFriend(
            userID: userID,
            remark: r,
            friendGroup: fg,
            addWording: wording,
            addSource: source,
            addType: t);
    if (res.code == 0 && res.data != null) {
      TencentCloudChat.dataInstance.contact
          .setAddFriendCode(res.data!.resultCode ?? -1, res.data!.userID ?? "");
    }
  }

  static Future<void> deleteConversation(String conversationID) async {
    V2TimCallback res = await TencentCloudChatSDK.manager
        .getConversationManager()
        .deleteConversation(conversationID: conversationID);
    if (res.code == 0) {
      TencentCloudChat.dataInstance.contact.setDeleteConversationCode(res.code);
    }
  }

  static Future<void> deleteFromFriendList(
      List<String> userIDList, FriendTypeEnum? deleteType) async {
    FriendTypeEnum type = deleteType ?? FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH;
    V2TimValueCallback<List<V2TimFriendOperationResult>> res =
        await TencentCloudChatSDK.manager
            .getFriendshipManager()
            .deleteFromFriendList(userIDList: userIDList, deleteType: type);
    if (res.code == 0) {
      List<String> contactList = [];
      res.data?.forEach((element) {
        contactList.add(element.userID ?? "");
      });
      TencentCloudChat.dataInstance.contact
          .deleteFromFriendList(contactList, "deleteFromFriendList");
    }
  }

  static Future<void> getFriendGroup(List<String>? groupNameList) async {
    V2TimValueCallback<List<V2TimFriendGroup>> res = await TencentCloudChatSDK
        .manager
        .getFriendshipManager()
        .getFriendGroups(groupNameList: groupNameList);
    if (res.code == 0) {
      TencentCloudChat.dataInstance.contact
          .buildFriendGroup(res.data ?? [], "getFriendGroup");
    }
  }

  static Future<void> joinGroup(
      String groupID, String message, GroupType? groupType) async {
    V2TimCallback res = await TencentCloudChatSDK.manager
        .joinGroup(groupID: groupID, message: message);
    if (res.code == 0) {}
  }

  static Future<void> getGroupApplicationList() async {
    V2TimValueCallback<V2TimGroupApplicationResult> res =
        await TencentCloudChatSDK.manager
            .getGroupManager()
            .getGroupApplicationList();
    if (res.code == 0) {
      List<V2TimGroupApplication> list = [];
      res.data?.groupApplicationList?.forEach((element) {
        if (element != null) {
          list.add(element);
        }
      });
      TencentCloudChat.dataInstance.contact
          .buildGroupApplicationList(list, "buildGroupApplicationList");
    }
  }

  static Future<void> acceptGroupApplication(
      V2TimGroupApplication application) async {
    V2TimCallback res = await TencentCloudChatSDK.manager
        .getGroupManager()
        .acceptGroupApplication(
            groupID: application.groupID,
            fromUser: application.fromUser ?? "",
            toUser: application.toUser ?? "",
            type: GroupApplicationTypeEnum.values[application.type],
            webMessageInstance: "");
    if (res.code == 0) {}
  }

  static Future<void> refuseGroupApplication(
      V2TimGroupApplication application) async {
    V2TimCallback res = await TencentCloudChatSDK.manager
        .getGroupManager()
        .refuseGroupApplication(
            groupID: application.groupID,
            fromUser: application.fromUser ?? "",
            toUser: application.toUser ?? "",
            type: GroupApplicationTypeEnum.values[application.type],
            webMessageInstance: "",
            addTime: application.addTime ?? 0);
    if (res.code == 0) {}
  }

  static Future<List<V2TimUserFullInfo>> getUsersInfo(
      List<String> userIDList) async {
    V2TimValueCallback<List<V2TimUserFullInfo>> res =
        await TencentCloudChatSDK.manager.getUsersInfo(userIDList: userIDList);
    if (res.code == 0) {
      TencentCloudChat.dataInstance.contact
          .buildSearchUserList(res.data ?? [], "search user list");
      return res.data ?? [];
    }
    return [];
  }

  static Future<List<V2TimGroupInfo>> getGroupsInfo(
      List<String> groupIDList) async {
    V2TimValueCallback<List<V2TimGroupInfoResult>> res =
        await TencentCloudChatSDK.manager
            .getGroupManager()
            .getGroupsInfo(groupIDList: groupIDList);
    if (res.code == 0) {
      List<V2TimGroupInfo> result = [];
      res.data?.forEach((element) {
        V2TimGroupInfo info = V2TimGroupInfo(groupID: "", groupType: "");
        if (element.resultCode == 0) {
          info.createTime = element.groupInfo?.createTime; // 群创建时间
          info.customInfo = element.groupInfo?.customInfo; // 群自定义字段
          info.faceUrl = element.groupInfo?.faceUrl; // 群头像Url
          info.groupAddOpt = element.groupInfo?.groupAddOpt; // 群添加选项设置
          info.groupID = element.groupInfo!.groupID; // 群ID
          info.groupName = element.groupInfo?.groupName; // 群名
          info.groupType = element.groupInfo!.groupType; // 群类型
          info.introduction = element.groupInfo?.introduction; // 群介绍
          info.isAllMuted = element.groupInfo?.isAllMuted; // 群是否全体禁言
          info.isSupportTopic = element.groupInfo?.isSupportTopic; // 群是否支持话题
          info.joinTime = element.groupInfo?.joinTime; // 当前用户在此群的加入时间
          info.lastInfoTime = element.groupInfo?.lastInfoTime; // 最后一次群修改资料的时间
          info.lastMessageTime =
              element.groupInfo?.lastMessageTime; // 最后一次群发消息的时间
          info.memberCount = element.groupInfo?.memberCount; // 群员数量
          info.notification = element.groupInfo?.notification; // 群公告
          info.onlineCount = element.groupInfo?.onlineCount; // 群在线人数
          info.owner = element.groupInfo?.owner; // 群主
          info.recvOpt = element.groupInfo?.recvOpt; // 当前用户在此群中接受信息的选项
          info.role = element.groupInfo?.role; // 此用户在群中的角色
          result.add(info);
        }
      });
      return result;
    }
    return [];
  }

  static Future<V2TimCallback> setFriendInfo(
      {required String userID,
      String? friendRemark,
      Map<String, String>? customInfo}) async {
    V2TimCallback setFriendInfoRes = await TencentCloudChatSDK.manager
        .getFriendshipManager()
        .setFriendInfo(
            userID: userID,
            friendRemark: friendRemark,
            friendCustomInfo: customInfo);
    return setFriendInfoRes;
  }

  static Future<V2TimCallback> setC2CReceiveMessageOpt(
      {required List<String> userIDList,
      required ReceiveMsgOptEnum opt}) async {
    V2TimCallback res = await TencentCloudChatSDK.manager
        .getMessageManager()
        .setC2CReceiveMessageOpt(userIDList: userIDList, opt: opt);
    return res;
  }

  static Future<int> getC2CReceiveMessageOpt(
      {required List<String> userIDList}) async {
    V2TimValueCallback<List<V2TimReceiveMessageOptInfo>> res =
        await TencentCloudChatSDK.manager
            .getMessageManager()
            .getC2CReceiveMessageOpt(userIDList: userIDList);
    if (res.code == 0) {
      if (res.data != null && res.data!.isNotEmpty) {
        return res.data![0].c2CReceiveMessageOpt ?? 0;
      }
    }
    return 0;
  }

  static Future<void> addToBlackList({required List<String> userIDList}) async {
    V2TimValueCallback<List<V2TimFriendOperationResult>> addToBlackListRes =
        await TencentCloudChatSDK.manager
            .getFriendshipManager()
            .addToBlackList(userIDList: userIDList //需要加入黑名单的好友id列表
                );
    if (addToBlackListRes.code == 0) {}
  }

  static Future<void> deleteFromBlackList(
      {required List<String> userIDList}) async {
    V2TimValueCallback<List<V2TimFriendOperationResult>>
        deleteFromBlackListRes = await TencentCloudChatSDK.manager
            .getFriendshipManager()
            .deleteFromBlackList(userIDList: userIDList //需要移出黑名单的好友id列表
                );
    if (deleteFromBlackListRes.code == 0) {
      if (deleteFromBlackListRes.data != null &&
          deleteFromBlackListRes.data!.isNotEmpty) {
        List<String> contactList = [];
        deleteFromBlackListRes.data?.forEach((element) {
          contactList.add(element.userID ?? "");
        });
        TencentCloudChat.dataInstance.contact
            .deleteFromBlockList(contactList, "deleteFromBlockList");
      }
    }
  }
}
