import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_search_sdk.dart';
import 'package:tencent_cloud_chat/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_search/common/filter_button.dart';
import 'package:tencent_cloud_chat_search/common/tencent_cloud_chat_search_input.dart';
import 'package:tencent_cloud_chat_search/common/tencent_cloud_chat_search_result_item.dart';
import 'package:tencent_cloud_chat_search/global_search/tencent_cloud_chat_global_search.dart';

class TencentCloudChatInChatSearch extends StatefulWidget {
  final String keyword;
  final String? userID;
  final String? groupID;
  final String conversationID;
  final VoidCallback? closeFunc;
  final String? title;

  const TencentCloudChatInChatSearch({
    super.key,
    required this.keyword,
    this.userID,
    this.groupID,
    required this.conversationID,
    this.closeFunc,
    this.title,
  });

  @override
  State<TencentCloudChatInChatSearch> createState() => _TencentCloudChatInChatSearchState();
}

class _TencentCloudChatInChatSearchState extends TencentCloudChatState<TencentCloudChatInChatSearch> {
  final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<int> _messageTypeList = [];

  List<V2TimMessage> _messageSearchResult = [];
  String _inputText = "";
  String? _cursor;

  @override
  void initState() {
    super.initState();
    _inputText = widget.keyword;
    _textEditingController.text = _inputText;
    _textEditingController.addListener(_textFieldListener);
    _scrollController.addListener(_scrollListener);
    _updateSearchResultForKeywordChange();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TencentCloudChatInChatSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keyword != oldWidget.keyword) {
      _cursor = null;
      _textEditingController.text = widget.keyword;
      _updateSearchResultForKeywordChange();
    }
  }

  void _textFieldListener() {
    _cursor = null;
    _updateSearchResultForKeywordChange();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        _loadMoreSearchResult();
      }
    }
  }

  void _updateSearchResultForKeywordChange() async {
    _inputText = _textEditingController.text;
    _cursor = null;
    if (TencentCloudChatUtils.checkString(_inputText) == null) {
      _messageSearchResult.clear();
    } else {
      final searchMessagesResult = await TencentCloudChat.instance.chatSDKInstance.searchSDK.searchMessages(
        keyword: _inputText,
        conversationID: widget.conversationID,
        messageTypeList: _messageTypeList,
      );
      if (searchMessagesResult.$3.isNotEmpty) {
        final messageList = searchMessagesResult.$3.first.messageList;
        safeSetState(() {
          _messageSearchResult = messageList;
        });
        _scrollController.animateTo(
          0,
          duration: const Duration(seconds: 0),
          curve: Curves.bounceInOut,
        );
        _cursor = searchMessagesResult.$4;
      } else {
        safeSetState(() {
          _messageSearchResult = [];
          _cursor = null;
        });
      }
    }
  }

  void _loadMoreSearchResult() async {
    if (_cursor == null) return;

    final searchMessagesResult = await TencentCloudChat.instance.chatSDKInstance.searchSDK.searchMessages(
      keyword: _inputText,
      conversationID: widget.conversationID,
      messageTypeList: _messageTypeList,
      cursor: _cursor,
    );
    if (searchMessagesResult.$3.isNotEmpty) {
      final messageList = searchMessagesResult.$3.first.messageList;
      safeSetState(() {
        _messageSearchResult = [
          ..._messageSearchResult,
          ...messageList,
        ];
      });
      _cursor = searchMessagesResult.$4;
    }
  }

  void _navigateToMessage({
    String? userID,
    String? groupID,
    V2TimMessage? targetMessage,
  }) async {
    if (targetMessage != null) {
      TencentCloudChat.instance.dataInstance.conversation.currentTargetMessage = targetMessage;
    }
    if (TencentCloudChat.instance.dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.message)) {
      if (!isDesktop) {
        navigateToMessage(
          context: context,
          options: TencentCloudChatMessageOptions(
            userID: userID,
            groupID: groupID,
            targetMessage: targetMessage,
          ),
        );
      } else {
        final conv = await TencentCloudChat.instance.chatSDKInstance.conversationSDK
            .getConversation(userID: userID, groupID: groupID);
        if (targetMessage != null) {
          TencentCloudChat.instance.dataInstance.conversation.currentTargetMessage = targetMessage;
        }
        TencentCloudChat.instance.dataInstance.conversation.currentConversation = conv;
      }
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: widget.title != null ? AppBar(
          title: Text(widget.title!),
        ) : null,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 8),
              child: TencentCloudChatSearchInput(
                textEditingController: _textEditingController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tL10n.filterBy,
                    style: TextStyle(color: colorTheme.secondaryTextColor, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: Scrollbar(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var type in [
                              MessageElemType.V2TIM_ELEM_TYPE_TEXT,
                              MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
                              MessageElemType.V2TIM_ELEM_TYPE_VIDEO,
                              MessageElemType.V2TIM_ELEM_TYPE_FILE,
                              MessageElemType.V2TIM_ELEM_TYPE_SOUND,
                              MessageElemType.V2TIM_ELEM_TYPE_FACE,
                            ])
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: TencentCloudChatSearchFilterButton(
                                  type: type,
                                  isSelected: _messageTypeList.contains(type),
                                  onSelected: (isSelected) {
                                    setState(() {
                                      if (isSelected) {
                                        _messageTypeList.add(type);
                                      } else {
                                        _messageTypeList.remove(type);
                                      }
                                      _updateSearchResultForKeywordChange();
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: colorTheme.dividerColor,
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                shrinkWrap: true,
                children: _messageSearchResult.map((e) {
                  return TencentCloudChatSearchResultItem(
                    data: TencentCloudChatSearchResultBoxItemData(
                      title: TencentCloudChatUtils.getMessageSummary(
                        message: e,
                      ),
                      avatarUrl: e.faceUrl,
                      keyword: _inputText,
                      onTap: () {
                        _navigateToMessage(
                          userID: widget.userID,
                          groupID: widget.groupID,
                          targetMessage: e,
                        );
                        widget.closeFunc?.call();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 8),
              child: TencentCloudChatSearchInput(
                textEditingController: _textEditingController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tL10n.filterBy,
                    style: TextStyle(color: colorTheme.secondaryTextColor, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var type in [
                            MessageElemType.V2TIM_ELEM_TYPE_TEXT,
                            MessageElemType.V2TIM_ELEM_TYPE_IMAGE,
                            MessageElemType.V2TIM_ELEM_TYPE_VIDEO,
                            MessageElemType.V2TIM_ELEM_TYPE_FILE,
                            MessageElemType.V2TIM_ELEM_TYPE_SOUND,
                            MessageElemType.V2TIM_ELEM_TYPE_FACE,
                          ])
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: TencentCloudChatSearchFilterButton(
                                type: type,
                                isSelected: _messageTypeList.contains(type),
                                onSelected: (isSelected) {
                                  setState(() {
                                    if (isSelected) {
                                      _messageTypeList.add(type);
                                    } else {
                                      _messageTypeList.remove(type);
                                    }
                                    _updateSearchResultForKeywordChange();
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: colorTheme.dividerColor,
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                shrinkWrap: true,
                children: _messageSearchResult.map((e) {
                  return TencentCloudChatSearchResultItem(
                    data: TencentCloudChatSearchResultBoxItemData(
                      title: TencentCloudChatUtils.getMessageSummary(
                        message: e,
                      ),
                      avatarUrl: e.faceUrl,
                      keyword: _inputText,
                      onTap: () {
                        _navigateToMessage(
                          userID: widget.userID,
                          groupID: widget.groupID,
                          targetMessage: e,
                        );
                        widget.closeFunc?.call();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
