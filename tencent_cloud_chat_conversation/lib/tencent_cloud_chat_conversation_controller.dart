import 'dart:async';
import 'dart:convert';

import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat_common/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat_common/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_conversation/model/tencent_cloud_chat_conversation_presenter.dart';

class TencentCloudChatConversationController extends TencentCloudChatComponentBaseController {
  static const String _tag = "TencentCloudChatConversationController";

  static TencentCloudChatConversationController? _instance;

  TencentCloudChatConversationController._internal();

  static TencentCloudChatConversationController get instance {
    _instance ??= TencentCloudChatConversationController._internal();
    return _instance!;
  }

  late V2TimConversationListener conversationListener;
  TencentCloudChatConversationPresenter conversationPresenter = TencentCloudChatConversationPresenter();

  Stream<TencentCloudChatBasicData<dynamic>>? _basicDataStream;
  StreamSubscription<TencentCloudChatBasicData<dynamic>>? _basicDataSubscription;

  Stream<TencentCloudChatGroupProfileData<dynamic>>? _groupProfileDataStream;
  StreamSubscription<TencentCloudChatGroupProfileData<dynamic>>? _groupProfileDataSubscription;

  void init() {
    _initListener();
    _initEventHandler();
  }

  void _initListener() {
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
          console("onSyncServerFinish exec, get all conversation from server.");
          conversationPresenter.getConversationList(seq: "0");
        });
      },
      onSyncServerStart: () {},
      onTotalUnreadMessageCountChanged: (totalUnreadCount) {
        TencentCloudChat.instance.dataInstance.conversation.setTotalUnreadCount(totalUnreadCount);
      },
      onConversationDeleted: (conversationIDList) {
        console("onConversationDeleted exec. ids is ${conversationIDList.join(",")}");
        // used in util client sync
        TencentCloudChat.instance.dataInstance.conversation.removeConversation(conversationIDList);
      },
      onUnreadMessageCountChangedByFilter: (filter, totalUnreadCount) {
        console("onUnreadMessageCountChangedByFilter exec");
        console(json.encode(filter.toJson()));
        console("$totalUnreadCount");
      },
    );

    TencentImSDKPlugin.v2TIMManager.getConversationManager().addConversationListener(listener: conversationListener);
  }

  void _initEventHandler() {
    _basicDataStream =
        TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatBasicData<dynamic>>("TencentCloudChatBasicData");
    _basicDataSubscription = _basicDataStream?.listen(_basicDataHandler);

    _groupProfileDataStream = TencentCloudChat.instance.eventBusInstance
        .on<TencentCloudChatGroupProfileData<dynamic>>("TencentCloudChatGroupProfileData");
    _groupProfileDataSubscription = _groupProfileDataStream?.listen(_groupProfileDataHandler);
  }

  _basicDataHandler(TencentCloudChatBasicData data) {
    if (data.currentUpdatedFields == TencentCloudChatBasicDataKeys.hasLoggedIn) {
      if (data.hasLoggedIn) {
        conversationPresenter.getConversationList(seq: "0");
      }
    }
  }

  _groupProfileDataHandler(TencentCloudChatGroupProfileData data) {
    if (data.currentUpdatedFields == TencentCloudChatGroupProfileDataKeys.quitGroup) {
      String conversationID = 'group_${data.updateGroupID}';
      conversationPresenter.cleanConversation(conversationIDList: [conversationID], clearMessage: true);
    }
  }

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: log,
    );
  }
}
