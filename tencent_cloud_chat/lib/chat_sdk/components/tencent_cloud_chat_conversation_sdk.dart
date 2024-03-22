import 'dart:convert';

import 'package:tencent_cloud_chat/chat_sdk/tencent_cloud_chat_sdk.dart';
import 'package:tencent_cloud_chat/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_filter.dart';

class TencentCloudChatConversationSDK {
  static const String _tag = "TencentCloudChatUIKitConversationSDK";

  static console(String log) {
    TencentCloudChat.logInstance.console(
      componentName: _tag,
      logs: log,
    );
  }

  static final V2TimConversationListener conversationListener = V2TimConversationListener(
    onConversationChanged: (conversationList) {
      TencentCloudChat.dataInstance.conversation.buildConversationList(conversationList, 'onConversationChanged');
    },
    onConversationGroupCreated: (groupName, conversationList) {},
    onConversationGroupDeleted: (groupName) {},
    onConversationGroupNameChanged: (oldName, newName) {},
    onConversationsAddedToGroup: (groupName, conversationList) {},
    onConversationsDeletedFromGroup: (groupName, conversationList) {},
    onNewConversation: (conversationList) {
      TencentCloudChat.dataInstance.conversation.buildConversationList(conversationList, 'onNewConversation');
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
      TencentCloudChat.dataInstance.conversation.setTotalUnreadCount(totalUnreadCount);
    },
    onConversationDeleted: (conversationIDList) {
      console("onConversationDeleted exec. ids is ${conversationIDList.join(",")}");
      // used in mutil client sync
      TencentCloudChat.dataInstance.conversation.removeConversation(conversationIDList);
    },
    onUnreadMessageCountChangedByFilter: (filter, totalUnreadCount) {
      console("onUnreadMessageCountChangedByFilter exec");
      console(json.encode(filter.toJson()));
      console("$totalUnreadCount");
      console("wwww");
    },
  );

  static pinConversation({
    required String conversationID,
    required bool isPinned,
  }) async {
    V2TimCallback pinRes = await TencentCloudChatSDK.manager.getConversationManager().pinConversation(
          conversationID: conversationID,
          isPinned: isPinned,
        );

    console("pinConversation exec, conversationID is $conversationID res is ${pinRes.code} desc is ${pinRes.desc}");
  }

  static cleanConversation({
    required List<String> conversationIDList,
    required bool clearMessage,
  }) async {
    V2TimValueCallback<List<V2TimConversationOperationResult>> deleteRes = await TencentCloudChatSDK.manager.getConversationManager().deleteConversationList(
          conversationIDList: conversationIDList,
          clearMessage: clearMessage,
        );

    console("deleteConversationList exec, conversationID is ${conversationIDList.join(',')} res is ${deleteRes.code} desc is ${deleteRes.desc}");
  }

  static subscribeUnreadMessageCountByFilter() async {
    await TencentCloudChatSDK.manager.getConversationManager().subscribeUnreadMessageCountByFilter(
          filter: V2TimConversationFilter(
            conversationGroup: "test-group",
          ),
        );
  }

  static addConversationListener() async {
    await TencentCloudChatSDK.manager.getConversationManager().removeConversationListener(listener: conversationListener);
    await TencentCloudChatSDK.manager.getConversationManager().addConversationListener(listener: conversationListener);
  }

  static Future<V2TimConversation> getConversation({String? userID, String? groupID}) async {
    assert((userID == null) != (groupID == null));

    final conversationID = TencentCloudChatUtils.checkString(userID) != null ? "c2c_$userID" : "group_$groupID";
    final res = await TencentCloudChatSDK.manager.getConversationManager().getConversation(conversationID: conversationID);
    if (res.code == 0 && res.data != null) {
      return res.data!;
    }
    if (TencentCloudChatUtils.checkString(userID) != null) {
      V2TimUserFullInfo? userProfile;
      final userProfileRes = await TencentCloudChatSDK.manager.getUsersInfo(userIDList: [userID ?? ""]);
      if (userProfileRes.data != null && userProfileRes.data!.isNotEmpty) {
        userProfile = userProfileRes.data!.first;
      }
      return V2TimConversation(
        conversationID: conversationID,
        userID: TencentCloudChatUtils.checkString(userID),
        faceUrl: TencentCloudChatUtils.checkString(userProfile?.faceUrl) ?? "https://comm.qq.com/im/static-files/im-demo/im_virtual_customer.png",
        showName: TencentCloudChatUtils.checkString(userProfile?.nickName) ?? TencentCloudChatUtils.checkString(userProfile?.userID) ?? TencentCloudChatUtils.checkString(userID) ?? tL10n.chat,
        type: 1,
      );
    } else {
      V2TimGroupInfo? groupInfo;
      final groupInfoRes = await TencentCloudChatSDK.manager.getGroupManager().getGroupsInfo(groupIDList: [groupID ?? ""]);
      if (groupInfoRes.data != null && groupInfoRes.data!.isNotEmpty) {
        groupInfo = groupInfoRes.data!.first.groupInfo;
      }
      return V2TimConversation(
        conversationID: conversationID,
        groupID: groupID,
        groupType: groupInfo?.groupType,
        faceUrl: TencentCloudChatUtils.checkString(groupInfo?.faceUrl) ?? "https://comm.qq.com/im/static-files/im-demo/im_virtual_customer.png",
        showName: TencentCloudChatUtils.checkString(groupInfo?.groupName) ?? TencentCloudChatUtils.checkString(groupID) ?? tL10n.chat,
        type: 2,
      );
    }
  }

  static Future<void> getConversationList({
    String? seq,
    int? count,
  }) async {
    if (seq == "0") {
      TencentCloudChatConversationData.currentGetConversationListSeq = seq!;
      TencentCloudChat.dataInstance.conversation.conversationList.clear();
    }
    String paramSeq = seq ?? TencentCloudChatConversationData.currentGetConversationListSeq;
    int paramCount = count ?? TencentCloudChatConversationData.getConversationListCount;

    console("GetConversationList api exec. And seq is $paramSeq. count is $paramCount");
    V2TimValueCallback<V2TimConversationResult> conListRes = await TencentCloudChatSDK.manager.getConversationManager().getConversationList(
          nextSeq: paramSeq,
          count: paramCount,
        );
    if (conListRes.code == 0) {
      if (conListRes.data != null) {
        if (conListRes.data!.isFinished != null) {
          if (!conListRes.data!.isFinished!) {
            TencentCloudChatConversationData.currentGetConversationListSeq = conListRes.data!.nextSeq!;
          } else {
            console("GetConversationList finished");
            TencentCloudChatConversationData.currentGetConversationListSeq = "";
            getTotalUnreadCount();
          }
          TencentCloudChatConversationData.isGetConversationFinished = conListRes.data!.isFinished!;
        }

        if (conListRes.data!.conversationList != null) {
          if (conListRes.data!.conversationList!.isNotEmpty) {
            List<V2TimConversation?> conList = conListRes.data!.conversationList!;

            List<V2TimConversation> conListFormat = [];
            for (var element in conList) {
              if (element != null) {
                conListFormat.add(element);
              }
            }

            TencentCloudChat.dataInstance.conversation.buildConversationList(conListFormat, 'getConversationList');
          }
        }
      }
      _getOtherConversation();
    }
    TencentCloudChat.dataInstance.conversation.updateIsGetDataEnd(true);
  }

  static _getOtherConversation() async {
    console("Get complete conversationList asynchronously ${TencentCloudChatConversationData.isGetConversationFinished}");
    if (!TencentCloudChatConversationData.isGetConversationFinished) {
      await TencentCloudChatConversationSDK.getConversationList(
        count: 100,
      );
      if (!TencentCloudChatConversationData.isGetConversationFinished) {
        _getOtherConversation();
      }
    }
  }

  static getTotalUnreadCount() async {
    V2TimValueCallback<int> totalRes = await TencentCloudChatSDK.manager.getConversationManager().getTotalUnreadMessageCount();
    if (totalRes.code == 0) {
      if (totalRes.data != null) {
        TencentCloudChat.dataInstance.conversation.setTotalUnreadCount(totalRes.data!);
      }
    }
  }
}
