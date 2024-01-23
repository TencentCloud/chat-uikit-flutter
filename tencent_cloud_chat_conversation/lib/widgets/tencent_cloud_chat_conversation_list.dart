import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/shimmer/tencent_cloud_chat_list_shimmer.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_item.dart';

class TencentCloudChatConversationList extends StatefulWidget {
  final List<V2TimConversation> conversationList;
  final List<V2TimUserStatus> userStatusList;
  final bool getDataEnd;
  final V2TimConversation? currentConversation;

  const TencentCloudChatConversationList({
    super.key,
    required this.conversationList,
    required this.getDataEnd,
    required this.userStatusList,
    this.currentConversation,
  });

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatConversationListState();
}

class TencentCloudChatConversationListState
    extends State<TencentCloudChatConversationList> {
  bool getIsOnline(V2TimConversation conv) {
    bool res = false;
    if (conv.type == ConversationType.V2TIM_C2C) {
      String userID = conv.userID ?? "";
      if (userID.isNotEmpty) {
        int index = widget.userStatusList
            .indexWhere((element) => element.userID == userID);
        if (index > -1) {
          if (widget.userStatusList[index].statusType == 1) {
            res = true;
          }
        }
      }
    }
    return res;
  }

  Widget conversationListWidget() {
    var conv = widget.conversationList;
    return ListView.builder(
      itemCount: conv.length,
      itemBuilder: (context, index) {
        var conversation = conv[index];
        var isOnline = getIsOnline(conversation);
        return TencentCloudChatConversationItem(
          conversation: conversation,
          isOnline: isOnline,
          isSelected: widget.currentConversation?.conversationID ==
                  conversation.conversationID &&
              TencentCloudChatUtils.checkString(
                      widget.currentConversation?.conversationID) !=
                  null,
        );
      },
    );
  }

  Widget noConversationWidget() {
    return Center(
      child: Text(tL10n.noConversation),
    );
  }

  Widget conversationLoading() {
    return const TencentCloudChatListShimmer();
  }

  @override
  Widget build(BuildContext context) {
    var conversationList = widget.conversationList;
    var loaded = widget.getDataEnd;
    return TencentCloudChatThemeWidget(build: (ctx, colors, fontSize) {
      if (!loaded) {
        return conversationLoading();
      }
      return conversationList.isNotEmpty
          ? conversationListWidget()
          : noConversationWidget();
    });
  }
}
