import 'dart:convert';

import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_filter.dart';

class TencentCloudChatConversationSDKGenerator {
  static TencentCloudChatConversationSDK getInstance() {
    return TencentCloudChatConversationSDK._();
  }
}

class TencentCloudChatConversationSDK {
  static const String _tag = "TencentCloudChatUIKitConversationSDK";

  TencentCloudChatConversationSDK._() {
    conversationListener = V2TimConversationListener(
      onConversationChanged: (conversationList) {
        TencentCloudChat.instance.dataInstance.conversation
            .buildConversationList(conversationList, 'onConversationChanged');
      },
      onConversationGroupCreated: (groupName, conversationList) {},
      onConversationGroupDeleted: (groupName) {},
      onConversationGroupNameChanged: (oldName, newName) {},
      onConversationsAddedToGroup: (groupName, conversationList) {},
      onConversationsDeletedFromGroup: (groupName, conversationList) {},
      onNewConversation: (conversationList) {
        TencentCloudChat.instance.dataInstance.conversation
            .buildConversationList(conversationList, 'onNewConversation');
      },
      onSyncServerFailed: () {},
      onSyncServerFinish: () {
        Future.delayed(const Duration(seconds: 2), () {
          console("onSyncServerFinish exec, get all conversation from serve.");
          getConversationList(seq: "0");
        });
      },
      onSyncServerStart: () {},
      onTotalUnreadMessageCountChanged: (totalUnreadCount) {
        TencentCloudChat.instance.dataInstance.conversation
            .setTotalUnreadCount(totalUnreadCount);
      },
      onConversationDeleted: (conversationIDList) {
        console(
            "onConversationDeleted exec. ids is ${conversationIDList.join(",")}");
        // used in util client sync
        TencentCloudChat.instance.dataInstance.conversation
            .removeConversation(conversationIDList);
      },
      onUnreadMessageCountChangedByFilter: (filter, totalUnreadCount) {
        console("onUnreadMessageCountChangedByFilter exec");
        console(json.encode(filter.toJson()));
        console("$totalUnreadCount");
      },
    );
  }

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: log,
    );
  }

  late final V2TimConversationListener conversationListener;

  pinConversation({
    required String conversationID,
    required bool isPinned,
  }) async {
    V2TimCallback pinRes = await TencentCloudChat
        .instance.chatSDKInstance.manager
        .getConversationManager()
        .pinConversation(
          conversationID: conversationID,
          isPinned: isPinned,
        );

    console(
        "pinConversation exec, conversationID is $conversationID res is ${pinRes.code} desc is ${pinRes.desc}");
  }

  cleanConversation({
    required List<String> conversationIDList,
    required bool clearMessage,
  }) async {
    V2TimValueCallback<List<V2TimConversationOperationResult>> deleteRes =
        await TencentCloudChat.instance.chatSDKInstance.manager
            .getConversationManager()
            .deleteConversationList(
              conversationIDList: conversationIDList,
              clearMessage: clearMessage,
            );

    console(
        "deleteConversationList exec, conversationID is ${conversationIDList.join(',')} res is ${deleteRes.code} desc is ${deleteRes.desc}");
  }

  subscribeUnreadMessageCountByFilter() async {
    await TencentCloudChat.instance.chatSDKInstance.manager
        .getConversationManager()
        .subscribeUnreadMessageCountByFilter(
          filter: V2TimConversationFilter(
            conversationGroup: "test-group",
          ),
        );
  }

  addConversationListener() async {
    await TencentCloudChat.instance.chatSDKInstance.manager
        .getConversationManager()
        .removeConversationListener(listener: conversationListener);
    await TencentCloudChat.instance.chatSDKInstance.manager
        .getConversationManager()
        .addConversationListener(listener: conversationListener);
  }

  Future<V2TimConversation> getConversation(
      {String? userID, String? groupID}) async {
    assert((userID == null) != (groupID == null));

    final conversationID = TencentCloudChatUtils.checkString(userID) != null
        ? "c2c_$userID"
        : "group_$groupID";
    final res = await TencentCloudChat.instance.chatSDKInstance.manager
        .getConversationManager()
        .getConversation(conversationID: conversationID);
    if (res.code == 0 && res.data != null) {
      return res.data!;
    }
    if (TencentCloudChatUtils.checkString(userID) != null) {
      V2TimUserFullInfo? userProfile;
      final userProfileRes = await TencentCloudChat
          .instance.chatSDKInstance.manager
          .getUsersInfo(userIDList: [userID ?? ""]);
      if (userProfileRes.data != null && userProfileRes.data!.isNotEmpty) {
        userProfile = userProfileRes.data!.first;
      }
      return V2TimConversation(
        conversationID: conversationID,
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
      final groupInfoRes = await TencentCloudChat
          .instance.chatSDKInstance.manager
          .getGroupManager()
          .getGroupsInfo(groupIDList: [groupID ?? ""]);
      if (groupInfoRes.data != null && groupInfoRes.data!.isNotEmpty) {
        groupInfo = groupInfoRes.data!.first.groupInfo;
      }
      return V2TimConversation(
        conversationID: conversationID,
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

  Future<void> getConversationList({
    String? seq,
    int? count,
  }) async {
    final conversationData =
        TencentCloudChat.instance.dataInstance.conversation;
    if (seq == "0") {
      conversationData.currentGetConversationListSeq = seq!;
      conversationData.conversationList.clear();
    }
    String paramSeq = seq ?? conversationData.currentGetConversationListSeq;
    int paramCount = count ?? conversationData.getConversationListCount;

    console(
        "GetConversationList api exec. And seq is $paramSeq. count is $paramCount");
    V2TimValueCallback<V2TimConversationResult> conListRes =
        await TencentCloudChat.instance.chatSDKInstance.manager
            .getConversationManager()
            .getConversationList(
              nextSeq: paramSeq,
              count: paramCount,
            );
    if (conListRes.code == 0) {
      if (conListRes.data != null) {
        if (conListRes.data!.isFinished != null) {
          if (!conListRes.data!.isFinished!) {
            conversationData.currentGetConversationListSeq =
                conListRes.data!.nextSeq!;
          } else {
            console("GetConversationList finished");
            conversationData.currentGetConversationListSeq = "";
            getTotalUnreadCount();
          }
          conversationData.isGetConversationFinished =
              conListRes.data!.isFinished!;
        }

        if (conListRes.data!.conversationList != null) {
          if (conListRes.data!.conversationList!.isNotEmpty) {
            List<V2TimConversation?> conList =
                conListRes.data!.conversationList!;

            List<V2TimConversation> conListFormat = [];
            for (var element in conList) {
              if (element != null) {
                conListFormat.add(element);
              }
            }

            conversationData.buildConversationList(
                conListFormat, 'getConversationList');
          }
        }
      }
      _getOtherConversation();
    }
    conversationData.updateIsGetDataEnd(true);
  }

  _getOtherConversation() async {
    console(
        "Get complete conversationList asynchronously ${TencentCloudChat.instance.dataInstance.conversation.isGetConversationFinished}");
    if (!TencentCloudChat
        .instance.dataInstance.conversation.isGetConversationFinished) {
      await getConversationList(
        count: 100,
      );
      if (!TencentCloudChat
          .instance.dataInstance.conversation.isGetConversationFinished) {
        _getOtherConversation();
      }
    }
  }

  getTotalUnreadCount() async {
    V2TimValueCallback<int> totalRes = await TencentCloudChat
        .instance.chatSDKInstance.manager
        .getConversationManager()
        .getTotalUnreadMessageCount();
    if (totalRes.code == 0) {
      if (totalRes.data != null) {
        TencentCloudChat.instance.dataInstance.conversation
            .setTotalUnreadCount(totalRes.data!);
      }
    }
  }
}
