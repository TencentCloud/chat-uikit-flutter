import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_list.dart';

class TencentCloudChatConversationDesktopMode extends StatefulWidget {
  const TencentCloudChatConversationDesktopMode({super.key});

  @override
  State<TencentCloudChatConversationDesktopMode> createState() => _TencentCloudChatConversationDesktopModeState();
}

class _TencentCloudChatConversationDesktopModeState
    extends TencentCloudChatState<TencentCloudChatConversationDesktopMode> {
  late TextEditingController _textEditingController;

  final Stream<TencentCloudChatConversationData<dynamic>>? _conversationDataStream = TencentCloudChat
      .instance.eventBusInstance
      .on<TencentCloudChatConversationData<dynamic>>("TencentCloudChatConversationData");
  StreamSubscription<TencentCloudChatConversationData<dynamic>>? _conversationDataSubscription;

  final Stream<TencentCloudChatBasicData<dynamic>>? _basicDataStream =
      TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatBasicData<dynamic>>("TencentCloudChatBasicData");
  StreamSubscription<TencentCloudChatBasicData<dynamic>>? _basicDataSubscription;

  V2TimConversation? _currentConversation;
  V2TimMessage? _currentTargetMessage;

  TencentCloudChatWidgetBuilder? _messageWidget;
  TencentCloudChatWidgetBuilder? _globalSearchWidget;
  String _searchText = "";

  @override
  void dispose() {
    _conversationDataSubscription?.cancel();
    _basicDataSubscription?.cancel();
    _textEditingController.removeListener(_searchTextListenerHandler);
    super.dispose();
  }

  _conversationDataHandler(TencentCloudChatConversationData data) {
    bool needUpdate = false;
    if (data.currentTargetMessage != _currentTargetMessage && data.currentTargetMessage != null) {
      _currentTargetMessage = data.currentTargetMessage;
      data.currentTargetMessage = null;
      _searchText = "";
      _textEditingController.clear();
      needUpdate = true;
    } else {
      _currentTargetMessage = null;
    }

    /// === Current Conversation ===
    /// === Current Conversation ===
    if (data.currentConversation?.conversationID != _currentConversation?.conversationID) {
      needUpdate = true;
      _currentConversation = data.currentConversation;
    }

    if(needUpdate){
      safeSetState(() {});
    }
  }

  _addConversationDataListener() {
    _conversationDataSubscription = _conversationDataStream?.listen(_conversationDataHandler);
  }

  void _addBasicEventListener() {
    _basicDataSubscription = _basicDataStream?.listen((event) {
      if (event.currentUpdatedFields == TencentCloudChatBasicDataKeys.addUsedComponent) {
        final messageWidget =
            TencentCloudChat.instance.dataInstance.basic.componentsMap[TencentCloudChatComponentsEnum.message];
        final searchWidget =
            TencentCloudChat.instance.dataInstance.basic.componentsMap[TencentCloudChatComponentsEnum.search];
        if (messageWidget != _messageWidget) {
          safeSetState(() {
            _messageWidget = messageWidget;
          });
        }
        if (searchWidget != _globalSearchWidget) {
          safeSetState(() {
            _globalSearchWidget = searchWidget;
          });
          if (_globalSearchWidget != null) {
            _textEditingController.addListener(_searchTextListenerHandler);
          } else {
            _textEditingController.removeListener(_searchTextListenerHandler);
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _addBasicEventListener();
    _addConversationDataListener();
    _messageWidget = TencentCloudChat.instance.dataInstance.basic.componentsMap[TencentCloudChatComponentsEnum.message];
    _globalSearchWidget =
        TencentCloudChat.instance.dataInstance.basic.componentsMap[TencentCloudChatComponentsEnum.search];
    _textEditingController = TextEditingController();
    if (_globalSearchWidget != null) {
      _textEditingController.addListener(_searchTextListenerHandler);
    }
  }

  void _searchTextListenerHandler() {
    final text = _textEditingController.text;
    safeSetState(() {
      _searchText = text;
    });
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
                Row(
                  children: [
                    Expanded(
                      child: TencentCloudChat.instance.dataInstance.conversation.conversationBuilder
                              ?.getConversationHeaderBuilder(
                                textEditingController: _textEditingController,
                              )
                              .$1 ??
                          Container(),
                    ),
                  ],
                ),
                // const TencentCloudChatConversationDesktopSearchAndAdd(),
                Expanded(
                  child: (TencentCloudChatUtils.checkString(_searchText) != null && _globalSearchWidget != null)
                      ? _globalSearchWidget!(
                          options: {
                            "keyWord": _searchText,
                          },
                        )
                      : TencentCloudChatConversationList(
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
                  "userID": TencentCloudChatUtils.checkString(_currentConversation?.userID),
                  "groupID": TencentCloudChatUtils.checkString(_currentConversation?.groupID),
                  "targetMessage": _currentTargetMessage,
                },
              ),
            ),
        ],
      ),
    );
  }
}
