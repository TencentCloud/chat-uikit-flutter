import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/shimmer/tencent_cloud_chat_list_shimmer.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_item.dart';

class TencentCloudChatConversationList extends StatefulWidget {
  final V2TimConversation? currentConversation;

  const TencentCloudChatConversationList({
    super.key,
    this.currentConversation,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatConversationListState();
}

class TencentCloudChatConversationListState extends TencentCloudChatState<TencentCloudChatConversationList> {
  final Stream<TencentCloudChatConversationData<dynamic>>? _conversationDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatConversationData<dynamic>>("TencentCloudChatConversationData");

  late StreamSubscription<TencentCloudChatConversationData<dynamic>>? _conversationDataSubscription;

  List<V2TimConversation> _conversationList = TencentCloudChat.instance.dataInstance.conversation.conversationList;

  bool _getDataEnd = TencentCloudChat.instance.dataInstance.conversation.isGetDataEnd;

  final Stream<TencentCloudChatContactData<dynamic>>? _contactDataStream = TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatContactData<dynamic>>("TencentCloudChatContactData");

  late StreamSubscription<TencentCloudChatContactData<dynamic>>? _contactDataSubscription;

  List<V2TimUserStatus> _userStatusList = TencentCloudChat.instance.dataInstance.contact.userStatus;

  _contactDataHandler(TencentCloudChatContactData data) {
    if (data.currentUpdatedFields == TencentCloudChatContactDataKeys.userStatusList) {
      safeSetState(() {
        _userStatusList = data.userStatus;
      });
    }
  }

  _addContactDataListener() {
    _contactDataSubscription = _contactDataStream?.listen(_contactDataHandler);
  }

  _conversationDataHandler(TencentCloudChatConversationData data) {
    if (data.currentUpdatedFields == TencentCloudChatConversationDataKeys.conversationList) {
      final conversationList = data.conversationList;
      safeSetState(() {
        _conversationList = conversationList;
      });
    } else if (data.currentUpdatedFields == TencentCloudChatConversationDataKeys.getDataEnd) {
      final conversationList = data.conversationList;
      safeSetState(() {
        _conversationList = conversationList;
        _getDataEnd = data.isGetDataEnd;
      });
    }
  }

  _addConversationDataListener() {
    _conversationDataSubscription = _conversationDataStream?.listen(_conversationDataHandler);
  }

  @override
  void initState() {
    super.initState();
    _addConversationDataListener();
    _addContactDataListener();
  }

  @override
  void dispose() {
    super.dispose();
    _conversationDataSubscription?.cancel();
    _contactDataSubscription?.cancel();
  }

  bool getIsOnline(V2TimConversation conv) {
    bool res = false;
    if (conv.type == ConversationType.V2TIM_C2C) {
      String userID = conv.userID ?? "";
      if (userID.isNotEmpty) {
        int index = _userStatusList.indexWhere((element) => element.userID == userID);
        if (index > -1) {
          if (_userStatusList[index].statusType == 1) {
            res = true;
          }
        }
      }
    }
    return res;
  }

  Widget conversationListWidget() {
    var conv = _conversationList;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: ListView.builder(
          itemCount: conv.length,
          itemBuilder: (context, index) {
            var conversation = conv[index];
            var isOnline = getIsOnline(conversation);
            return TencentCloudChatConversationItem(
              conversation: conversation,
              isOnline: isOnline,
              isSelected: widget.currentConversation?.conversationID == conversation.conversationID && TencentCloudChatUtils.checkString(widget.currentConversation?.conversationID) != null,
            );
          },
        ));
  }

  Widget _noConversationWidget() {
    return Center(
      child: Text(tL10n.noConversation),
    );
  }

  Widget _conversationLoading() {
    return const TencentCloudChatListShimmer();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    var conversationList = _conversationList;
    var loaded = _getDataEnd;
    return TencentCloudChatThemeWidget(build: (ctx, colors, fontSize) {
      if (!loaded) {
        return _conversationLoading();
      }
      return conversationList.isNotEmpty ? conversationListWidget() : _noConversationWidget();
    });
  }
}
