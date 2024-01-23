import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_list.dart';

class TencentCloudChatConversationDesktopMode extends StatefulWidget {
  final List<V2TimConversation> conversationList;
  final List<V2TimUserStatus> userStatusList;
  final bool getDataEnd;

  const TencentCloudChatConversationDesktopMode(
      {super.key,
      required this.conversationList,
      required this.userStatusList,
      required this.getDataEnd});

  @override
  State<TencentCloudChatConversationDesktopMode> createState() =>
      _TencentCloudChatConversationDesktopModeState();
}

class _TencentCloudChatConversationDesktopModeState
    extends TencentCloudChatState<TencentCloudChatConversationDesktopMode> {
  final Stream<TencentCloudChatConversationData<dynamic>>?
      _conversationDataStream = TencentCloudChat.eventBusInstance
          .on<TencentCloudChatConversationData<dynamic>>();
  final _messageWidget = TencentCloudChat
      .dataInstance.basic.componentsMap[TencentCloudChatComponentsEnum.message];

  V2TimConversation? _currentConversation;
  bool _isShowSearch = false;
  bool _isShowGroupProfile = false;

  _conversationDataHandler(TencentCloudChatConversationData data) {
    /// === Current Conversation ===
    if (data.currentConversation != _currentConversation) {
      setState(() {
        _currentConversation = data.currentConversation;
      });
    }
  }

  _addConversationDataListener() {
    _conversationDataStream?.listen(_conversationDataHandler);
  }

  @override
  void initState() {
    super.initState();
    _addConversationDataListener();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Container();
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: getWidth(280)),
                  child: Column(
                    children: [
                      /// TODO: Will be replaced by the search bar in the following version.
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: getHeight(11.4),
                                horizontal: getWidth(16),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: colorTheme.dividerColor,
                                  ),
                                ),
                              ),
                              child: Text(
                                tL10n.chats,
                                style: TextStyle(
                                    color: colorTheme.settingTitleColor,
                                    fontSize: textStyle.fontsize_24 + 4,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const TencentCloudChatConversationDesktopSearchAndAdd(),
                      Expanded(
                        child: TencentCloudChatConversationList(
                          conversationList: widget.conversationList,
                          getDataEnd: widget.getDataEnd,
                          userStatusList: widget.userStatusList,
                          currentConversation: _currentConversation,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 1,
                  child: Container(
                    color: colorTheme.dividerColor,
                  ),
                ),
                if (_messageWidget != null)
                  Expanded(
                    child: _messageWidget!(
                      options: {
                        "userID": TencentCloudChatUtils.checkString(
                            _currentConversation?.userID),
                        "groupID": TencentCloudChatUtils.checkString(
                            _currentConversation?.groupID),
                      },
                    ),
                  ),
              ],
            ));
  }
}
