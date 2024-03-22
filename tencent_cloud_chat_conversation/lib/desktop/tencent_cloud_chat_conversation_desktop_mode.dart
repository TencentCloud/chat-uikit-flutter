import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_builders.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_list.dart';

class TencentCloudChatConversationDesktopMode extends StatefulWidget {
  const TencentCloudChatConversationDesktopMode({super.key});

  @override
  State<TencentCloudChatConversationDesktopMode> createState() =>
      _TencentCloudChatConversationDesktopModeState();
}

class _TencentCloudChatConversationDesktopModeState
    extends TencentCloudChatState<TencentCloudChatConversationDesktopMode> {
  final Stream<TencentCloudChatConversationData<dynamic>>?
      _conversationDataStream = TencentCloudChat.eventBusInstance
          .on<TencentCloudChatConversationData<dynamic>>();

  V2TimConversation? _currentConversation;
  bool _isShowSearch = false;
  bool _isShowGroupProfile = false;

  TencentCloudChatWidgetBuilder? _messageWidget;

  @override
  void didUpdateWidget(TencentCloudChatConversationDesktopMode oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  _conversationDataHandler(TencentCloudChatConversationData data) {
    /// === Current Conversation ===
    if (data.currentConversation?.conversationID !=
        _currentConversation?.conversationID) {
      setState(() {
        _currentConversation = data.currentConversation;
      });
    }
  }

  _addConversationDataListener() {
    _conversationDataStream?.listen(_conversationDataHandler);
  }

  void _addBasicEventListener() {
    TencentCloudChat.eventBusInstance
        .on<TencentCloudChatBasicData<TencentCloudChatBasicDataKeys>>()
        ?.listen((event) {
      if (event.currentUpdatedFields ==
          TencentCloudChatBasicDataKeys.addUsedComponent) {
        final messageWidget = TencentCloudChat.dataInstance.basic
            .componentsMap[TencentCloudChatComponentsEnum.message];
        if (messageWidget != _messageWidget) {
          safeSetState(() {
            _messageWidget = messageWidget;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _addBasicEventListener();
    _addConversationDataListener();

    _messageWidget = TencentCloudChat.dataInstance.basic
        .componentsMap[TencentCloudChatComponentsEnum.message];
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
                            child: TencentCloudChatConversationBuilders
                                    .getConversationHeaderBuilder()
                                .$1,
                          ),
                        ],
                      ),
                      // const TencentCloudChatConversationDesktopSearchAndAdd(),
                      Expanded(
                        child: TencentCloudChatConversationList(
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
