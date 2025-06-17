import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatContactSDKGenerator {
  static TencentCloudChatContactSDK getInstance() {
    return TencentCloudChatContactSDK._();
  }
}

class TencentCloudChatContactSDK {
  static const String _tag = "TencentCloudChatUIKitContactSDK";

  TencentCloudChatContactSDK._();

  final V2TimFriendshipListener friendshipListener = V2TimFriendshipListener(
    onFriendApplicationListAdded: (applicationList) {
      TencentCloudChat.instance.dataInstance.contact
          .buildApplicationList(applicationList, 'onFriendApplicationListAdded');
    },
    onBlackListAdd: (blockList) {
      TencentCloudChat.instance.dataInstance.contact.buildBlockList(blockList, 'onBlackListAdd');
    },
    onBlackListDeleted: (blockList) {
      TencentCloudChat.instance.dataInstance.contact.deleteFromBlockList(blockList, 'onBlackListDeleted');
    },
    onFriendApplicationListDeleted: (applicationList) {
      TencentCloudChat.instance.dataInstance.contact
          .deleteApplicationList(applicationList, 'onFriendApplicationListDeleted');
    },
    onFriendApplicationListRead: () {},
    onFriendInfoChanged: (contactList) {
      TencentCloudChat.instance.dataInstance.contact.buildFriendList(contactList, 'onFriendInfoChanged');
      TencentCloudChat.instance.dataInstance.messageData.onFriendInfoChanged(contactList);
    },
    onFriendListAdded: (contactList) {
      TencentCloudChat.instance.dataInstance.contact.buildFriendList(contactList, 'onFriendListAdded');
      TencentCloudChat.instance.dataInstance.contact
          .deleteApplicationList(contactList.map((e) => e.userID).toList(), 'onFriendApplicationListDeleted');
    },
    onFriendListDeleted: (contactList) {
      TencentCloudChat.instance.dataInstance.contact.deleteFromFriendList(contactList, 'onFriendListDeleted');
      TencentCloudChat.instance.chatSDKInstance.conversationSDK
          .deleteConversation(conversationIDList: contactList.map((e) => 'c2c_$e').toList(), clearMessage: true);
    },
  );

  Future<void> getFriendList() async {
    V2TimValueCallback<List<V2TimFriendInfo>> getFriendListRes =
    await TencentCloudChat.instance.chatSDKInstance.manager.getFriendshipManager().getFriendList();
    if (getFriendListRes.code == 0) {
      List<V2TimFriendInfo> friendInfo = getFriendListRes.data ?? [];
      TencentCloudChat.instance.dataInstance.contact.buildFriendList(friendInfo, 'getFriendList');
      if (friendInfo.isNotEmpty) {
        bool isGetUserStatus = TencentCloudChat.instance.dataInstance.basic.userConfig.useUserOnlineStatus ?? true;
        TencentCloudChat.instance.logInstance.console(
          componentName: _tag,
          logs: "getFriendList exec. get user status is $isGetUserStatus",
        );
        if (isGetUserStatus) {
          List<String> userids = friendInfo.map((e) => e.userID).toList();
          await addUserStatusListener(userids: userids);
          V2TimValueCallback<List<V2TimUserStatus>> statusRes =
          await TencentCloudChat.instance.chatSDKInstance.manager.getUserStatus(userIDList: userids);
          if (statusRes.code == 0 && statusRes.data != null) {
            if (statusRes.data!.isNotEmpty) {
              TencentCloudChat.instance.dataInstance.contact.buildUserStatusList(statusRes.data!, "getUserStatus");
            }
          }
        }
      }
    }
  }

  initFriendListener() {
    TencentCloudChat.instance.chatSDKInstance.manager
        .getFriendshipManager()
        .removeFriendListener(listener: friendshipListener);
    TencentCloudChat.instance.chatSDKInstance.manager
        .getFriendshipManager()
        .addFriendListener(listener: friendshipListener);
  }

  addUserStatusListener({
    required List<String> userids,
  }) async {
    await TencentCloudChat.instance.chatSDKInstance.manager.unsubscribeUserStatus(userIDList: userids);
    await TencentCloudChat.instance.chatSDKInstance.manager.subscribeUserStatus(userIDList: userids);
  }

  Future<void> getFriendApplicationList() async {
    V2TimValueCallback<V2TimFriendApplicationResult> getFriendApplicationListRes =
    await TencentCloudChat.instance.chatSDKInstance.manager.getFriendshipManager().getFriendApplicationList();
    if (getFriendApplicationListRes.code == 0) {
      if (getFriendApplicationListRes.data!.friendApplicationList != null &&
          getFriendApplicationListRes.data!.friendApplicationList!.isNotEmpty) {
        List<V2TimFriendApplication> friendApplicationList = [];
        List<V2TimFriendInfo> contactList = TencentCloudChat.instance.dataInstance.contact.contactList;
        List<V2TimFriendApplication?> listRes = getFriendApplicationListRes.data!.friendApplicationList!;
        for (var element in listRes) {
          if (element != null) {
            int index = contactList.indexWhere((e) => e.userID == element.userID);
            if (index < 0) {
              friendApplicationList.add(element);
            }
          }
        }
        TencentCloudChat.instance.dataInstance.contact.setApplicationUnreadCount(friendApplicationList);
        TencentCloudChat.instance.dataInstance.contact
            .buildApplicationList(friendApplicationList, 'getFriendApplicationList');
      }
    }
  }

  Future<V2TimFriendOperationResult> acceptFriendApplication(String userID, FriendResponseTypeEnum? responseType,
      FriendApplicationTypeEnum? type) async {
    FriendResponseTypeEnum resType = responseType ?? TencentCloudChat.instance.dataInstance.contact.responseType;
    FriendApplicationTypeEnum applicationType = type ?? TencentCloudChat.instance.dataInstance.contact.applicationType;
    V2TimValueCallback<V2TimFriendOperationResult> res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getFriendshipManager()
        .acceptFriendApplication(responseType: resType, type: applicationType, userID: userID);
    if (res.code == 0) {
      if (res.data != null) {
        TencentCloudChat.instance.dataInstance.contact.setApplicationCode(res.data?.resultCode ?? res.code, userID);
      }
    }
    return res.data ?? V2TimFriendOperationResult(userID: userID);
  }

  Future<V2TimFriendOperationResult> refuseFriendApplication(String userID, FriendApplicationTypeEnum? type) async {
    FriendApplicationTypeEnum applicationType = type ?? TencentCloudChat.instance.dataInstance.contact.applicationType;
    V2TimValueCallback<V2TimFriendOperationResult> res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getFriendshipManager()
        .refuseFriendApplication(type: applicationType, userID: userID);
    if (res.code == 0) {
      if (res.data != null) {
        TencentCloudChat.instance.dataInstance.contact.setApplicationCode(res.data?.resultCode ?? res.code, userID);
      }
    }
    return res.data ?? V2TimFriendOperationResult(userID: userID);
  }

  Future<void> getBlockList() async {
    V2TimValueCallback<List<V2TimFriendInfo>> res =
    await TencentCloudChat.instance.chatSDKInstance.manager.getFriendshipManager().getBlackList();
    if (res.code == 0) {
      if (res.data != null) {
        List<V2TimFriendInfo> friendInfo = res.data ?? [];
        TencentCloudChat.instance.dataInstance.contact.buildBlockList(friendInfo, 'getBlackList');
      }
    }
  }

  Future<void> getGroupList() async {
    V2TimValueCallback<List<V2TimGroupInfo>> res =
    await TencentCloudChat.instance.chatSDKInstance.manager.getGroupManager().getJoinedGroupList();
    if (res.code == 0) {
      if (res.data != null) {
        TencentCloudChat.instance.dataInstance.contact.buildGroupList(res.data ?? [], 'getGroupList');
      }
    }
  }

  Future<void> checkFriend(List<String> userIDList, FriendTypeEnum? friendType) async {
    FriendTypeEnum friendTypeEnum = friendType ?? FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH;
    V2TimValueCallback<List<V2TimFriendCheckResult>> res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getFriendshipManager()
        .checkFriend(userIDList: userIDList, checkType: friendTypeEnum);
    if (res.code == 0 && res.data != null) {}
  }

  Future<V2TimValueCallback<V2TimFriendOperationResult>> addFriend(String userID, String? remark, String? friendGroup,
      String? addWording, String? addSource, FriendTypeEnum? type) async {
    String r = remark ?? "";
    String fg = friendGroup ?? "";
    String wording = addWording ?? "";
    String source = addSource ?? "";
    FriendTypeEnum t = type ?? FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH;
    V2TimValueCallback<V2TimFriendOperationResult> res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getFriendshipManager()
        .addFriend(userID: userID,
        remark: r,
        friendGroup: fg,
        addWording: wording,
        addSource: source,
        addType: t);
    return res;
  }

  Future<void> deleteConversation(String conversationID) async {
    V2TimCallback res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getConversationManager()
        .deleteConversation(conversationID: conversationID);
    if (res.code == 0) {
      TencentCloudChat.instance.dataInstance.contact.setDeleteConversationCode(res.code);
    }
  }

  Future<V2TimValueCallback<List<V2TimFriendOperationResult>>> deleteFromFriendList(List<String> userIDList,
      FriendTypeEnum? deleteType) async {
    FriendTypeEnum type = deleteType ?? FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH;
    V2TimValueCallback<List<V2TimFriendOperationResult>> res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getFriendshipManager()
        .deleteFromFriendList(userIDList: userIDList, deleteType: type);
    if (res.code == 0) {
      List<String> contactList = [];
      res.data?.forEach((element) {
        contactList.add(element.userID ?? "");
      });
      TencentCloudChat.instance.dataInstance.contact.deleteFromFriendList(contactList, "deleteFromFriendList");
    }

    return res;
  }

  Future<void> getFriendGroup(List<String>? groupNameList) async {
    V2TimValueCallback<List<V2TimFriendGroup>> res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getFriendshipManager()
        .getFriendGroups(groupNameList: groupNameList);
    if (res.code == 0) {
      TencentCloudChat.instance.dataInstance.contact.buildFriendGroup(res.data ?? [], "getFriendGroup");
    }
  }

  Future<V2TimCallback> joinGroup(String groupID, String message) async {
    V2TimCallback result =
    await TencentCloudChat.instance.chatSDKInstance.manager.joinGroup(groupID: groupID, message: message);
    return result;
  }

  Future<void> getGroupApplicationList() async {
    V2TimValueCallback<V2TimGroupApplicationResult> res =
    await TencentCloudChat.instance.chatSDKInstance.manager.getGroupManager().getGroupApplicationList();
    if (res.code == 0) {
      List<V2TimGroupApplication> list = [];
      res.data?.groupApplicationList?.forEach((element) {
        if (element != null) {
          list.add(element);
        }
      });
      TencentCloudChat.instance.dataInstance.contact.buildGroupApplicationList(list, "buildGroupApplicationList");
    }
  }

  Future<V2TimCallback> acceptGroupApplication(V2TimGroupApplication application) async {
    V2TimCallback result = await TencentCloudChat.instance.chatSDKInstance.manager
        .getGroupManager()
        .acceptGroupApplication(
        groupID: application.groupID,
        fromUser: application.fromUser ?? "",
        toUser: application.toUser ?? "",
        type: GroupApplicationTypeEnum.values[application.type],
        addTime: application.addTime ?? 0,
        webMessageInstance: "");
    if (result.code == 0) {
      // 延迟处理，避免获取到 SDK 还未更新的数据
      Future.delayed(const Duration(seconds: 1), () {
        getGroupApplicationList();
      });
    }

    return result;
  }

  Future<V2TimCallback> refuseGroupApplication(V2TimGroupApplication application) async {
    V2TimCallback result = await TencentCloudChat.instance.chatSDKInstance.manager
        .getGroupManager()
        .refuseGroupApplication(
        groupID: application.groupID,
        fromUser: application.fromUser ?? "",
        toUser: application.toUser ?? "",
        type: GroupApplicationTypeEnum.values[application.type],
        webMessageInstance: "",
        addTime: application.addTime ?? 0);
    if (result.code == 0) {
      // 延迟处理，避免获取到 SDK 还未更新的数据
      Future.delayed(const Duration(seconds: 1), () {
        getGroupApplicationList();
      });
    }

    return result;
  }

  Future<List<V2TimUserFullInfo>> getUsersInfo(List<String> userIDList) async {
    V2TimValueCallback<List<V2TimUserFullInfo>> res =
    await TencentCloudChat.instance.chatSDKInstance.manager.getUsersInfo(userIDList: userIDList);
    if (res.code == 0) {
      TencentCloudChat.instance.dataInstance.contact.buildSearchUserList(res.data ?? [], "search user list");
      return res.data ?? [];
    }
    return [];
  }

  Future<List<V2TimGroupInfo>> getGroupsInfo(List<String> groupIDList) async {
    V2TimValueCallback<List<V2TimGroupInfoResult>> res = await TencentCloudChat.instance.chatSDKInstance.manager
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
          info.lastMessageTime = element.groupInfo?.lastMessageTime; // 最后一次群发消息的时间
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

  Future<V2TimCallback> setFriendInfo(
      {required String userID, String? friendRemark, Map<String, String>? customInfo}) async {
    V2TimCallback setFriendInfoRes = await TencentCloudChat.instance.chatSDKInstance.manager
        .getFriendshipManager()
        .setFriendInfo(userID: userID, friendRemark: friendRemark, friendCustomInfo: customInfo);
    return setFriendInfoRes;
  }

  Future<V2TimCallback> setC2CReceiveMessageOpt(
      {required List<String> userIDList, required ReceiveMsgOptEnum opt}) async {
    V2TimCallback res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getMessageManager()
        .setC2CReceiveMessageOpt(userIDList: userIDList, opt: opt);
    return res;
  }

  Future<int> getC2CReceiveMessageOpt({required List<String> userIDList}) async {
    V2TimValueCallback<List<V2TimReceiveMessageOptInfo>> res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getMessageManager()
        .getC2CReceiveMessageOpt(userIDList: userIDList);
    if (res.code == 0) {
      if (res.data != null && res.data!.isNotEmpty) {
        return res.data![0].c2CReceiveMessageOpt ?? 0;
      }
    }
    return 0;
  }

  Future<V2TimValueCallback<List<V2TimFriendOperationResult>>> addToBlackList(
      {required List<String> userIDList}) async {
    V2TimValueCallback<List<V2TimFriendOperationResult>> addToBlackListRes = await TencentCloudChat
        .instance.chatSDKInstance.manager
        .getFriendshipManager()
        .addToBlackList(userIDList: userIDList //需要加入黑名单的好友id列表
    );

    return addToBlackListRes;
  }

  Future<V2TimValueCallback<List<V2TimFriendOperationResult>>> deleteFromBlackList(
      {required List<String> userIDList}) async {
    V2TimValueCallback<List<V2TimFriendOperationResult>> deleteFromBlackListRes = await TencentCloudChat
        .instance.chatSDKInstance.manager
        .getFriendshipManager()
        .deleteFromBlackList(userIDList: userIDList //需要移出黑名单的好友id列表
    );
    if (deleteFromBlackListRes.code == 0) {
      if (deleteFromBlackListRes.data != null && deleteFromBlackListRes.data!.isNotEmpty) {
        List<String> contactList = [];
        deleteFromBlackListRes.data?.forEach((element) {
          contactList.add(element.userID ?? "");
        });
        TencentCloudChat.instance.dataInstance.contact.deleteFromBlockList(contactList, "deleteFromBlockList");
      }
    }

    return deleteFromBlackListRes;
  }
}
