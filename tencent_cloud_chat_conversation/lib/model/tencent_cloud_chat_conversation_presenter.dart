import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatConversationPresenter {
  static const String _tag = "TencentCloudChatConversationPresenter";

  Future<void> getConversationList({
    String? seq,
    int? count,
  }) async {
    final conversationData = TencentCloudChat.instance.dataInstance.conversation;
    if (seq == "0") {
      conversationData.currentGetConversationListSeq = seq!;
      conversationData.conversationList.clear();
    }
    String paramSeq = seq ?? conversationData.currentGetConversationListSeq;
    int paramCount = count ?? conversationData.getConversationListCount;

    console("GetConversationList api exec. And seq is $paramSeq. count is $paramCount");
    V2TimValueCallback<V2TimConversationResult> conListRes =
    await TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().getConversationList(
      nextSeq: paramSeq,
      count: paramCount,
    );
    if (conListRes.code == 0) {
      if (conListRes.data != null) {
        if (conListRes.data!.isFinished != null) {
          if (!conListRes.data!.isFinished!) {
            conversationData.currentGetConversationListSeq = conListRes.data!.nextSeq!;
          } else {
            console("GetConversationList finished");
            conversationData.currentGetConversationListSeq = "";
            getTotalUnreadCount();
          }
          conversationData.isGetConversationFinished = conListRes.data!.isFinished!;
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

            conversationData.buildConversationList(conListFormat, 'getConversationList');
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
    if (!TencentCloudChat.instance.dataInstance.conversation.isGetConversationFinished) {
      await getConversationList(
        count: 100,
      );
      if (!TencentCloudChat.instance.dataInstance.conversation.isGetConversationFinished) {
        _getOtherConversation();
      }
    }
  }

  getTotalUnreadCount() async {
    V2TimValueCallback<int> totalRes =
    await TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().getTotalUnreadMessageCount();
    if (totalRes.code == 0) {
      if (totalRes.data != null) {
        TencentCloudChat.instance.dataInstance.conversation.setTotalUnreadCount(totalRes.data!);
      }
    }
  }

  Future<V2TimValueCallback<List<V2TimConversationOperationResult>>> cleanConversation({
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

    return deleteRes;
  }

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: log,
    );
  }
}