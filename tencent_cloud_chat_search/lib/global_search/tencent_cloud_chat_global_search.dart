import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_search_sdk.dart';
import 'package:tencent_cloud_chat/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_search/common/tencent_cloud_chat_search_result_box.dart';
import 'package:tencent_cloud_chat_search/common/tencent_cloud_chat_search_result_item.dart';
import 'package:tencent_cloud_chat_search/search_in_chat/tencent_cloud_chat_search_in_chat_search.dart';

class TencentCloudChatGlobalSearch extends StatefulWidget {
  final String keyWord;

  const TencentCloudChatGlobalSearch({super.key, required this.keyWord});

  @override
  State<TencentCloudChatGlobalSearch> createState() => _TencentCloudChatGlobalSearchState();
}

class _TencentCloudChatGlobalSearchState extends TencentCloudChatState<TencentCloudChatGlobalSearch> {
  final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;

  List<TencentCloudChatSearchResultItemData> _messageSearchResultItems = [];
  List<V2TimFriendInfoResult> _contactsList = [];
  List<V2TimGroupInfo> _groupsList = [];

  @override
  void initState() {
    super.initState();
    _updateSearchResult();
  }

  @override
  void didUpdateWidget(TencentCloudChatGlobalSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keyWord != oldWidget.keyWord) {
      _updateSearchResult();
    }
  }

  void _updateSearchResult() async {
    final keyword = widget.keyWord;
    if (TencentCloudChatUtils.checkString(keyword) == null) {
      _messageSearchResultItems.clear();
    } else {
      final searchMessagesResult =
          await TencentCloudChat.instance.chatSDKInstance.searchSDK.searchMessages(keyword: keyword);
      final searchContactsResult = await TencentCloudChat.instance.chatSDKInstance.searchSDK.searchContacts(keyword);
      final searchGroupsResult = await TencentCloudChat.instance.chatSDKInstance.searchSDK.searchGroups(keyword);
      safeSetState(() {
        _messageSearchResultItems = searchMessagesResult.$3;
        _contactsList = searchContactsResult;
        _groupsList = searchGroupsResult;
      });
    }
  }

  void _navigateToMessage({
    String? userID,
    String? groupID,
  }) async {
    if (TencentCloudChat.instance.dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.message)) {
      if (!isDesktop) {
        navigateToMessage(
          context: context,
          options: TencentCloudChatMessageOptions(
            userID: userID,
            groupID: groupID,
          ),
        );
      } else {
        final conv = await TencentCloudChat.instance.chatSDKInstance.conversationSDK
            .getConversation(userID: userID, groupID: groupID);
        TencentCloudChat.instance.dataInstance.conversation.currentConversation = conv;
      }
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        if (_contactsList.isNotEmpty)
          TencentCloudChatSearchResultBox(
            title: tL10n.contacts,
            resultList: _contactsList.map((e) {
              return TencentCloudChatSearchResultBoxItemData(
                keyword: widget.keyWord,
                title: TencentCloudChatUtils.checkString(e.friendInfo?.friendRemark) ??
                    TencentCloudChatUtils.checkString(e.friendInfo?.userProfile?.nickName) ??
                    e.friendInfo?.userID ??
                    "",
                avatarUrl: e.friendInfo?.userProfile?.faceUrl ?? "",
                onTap: () {
                  _navigateToMessage(
                    userID: e.friendInfo?.userID,
                  );
                },
              );
            }).toList(),
          ),
        if (_groupsList.isNotEmpty)
          TencentCloudChatSearchResultBox(
            title: tL10n.groups,
            resultList: _groupsList.map((e) {
              return TencentCloudChatSearchResultBoxItemData(
                keyword: widget.keyWord,
                title: TencentCloudChatUtils.checkString(e.groupName) ?? e.groupID,
                avatarUrl: e.faceUrl ?? "",
                onTap: () {
                  _navigateToMessage(
                    groupID: e.groupID,
                  );
                },
              );
            }).toList(),
          ),
        if (_messageSearchResultItems.isNotEmpty)
          TencentCloudChatSearchResultBox(
            title: tL10n.messages,
            resultList: _messageSearchResultItems.map((e) {
              return TencentCloudChatSearchResultBoxItemData(
                keyword: widget.keyWord,
                title: e.showName,
                subTitle: (e.totalCount ?? 0) > 99
                    ? tL10n.numMessagesOver99
                    : ((e.totalCount ?? 0) > 0 ? tL10n.numMessages(e.totalCount ?? 0) : null),
                avatarUrl: e.avatarUrl ?? "",
                onTap: () {
                  if (isDesktop) {
                    TencentCloudChatDesktopPopup.showPopupWindow(
                      title: e.showName,
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.6,
                      operationKey: TencentCloudChatPopupOperationKey.searchInChat,
                      context: context,
                      child: (closeFunc) => TencentCloudChatInChatSearch(
                        keyword: widget.keyWord,
                        userID: e.userID,
                        groupID: e.groupID,
                        conversationID: e.conversationID,
                        closeFunc: closeFunc,
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TencentCloudChatInChatSearch(
                          keyword: widget.keyWord,
                          userID: e.userID,
                          groupID: e.groupID,
                          conversationID: e.conversationID,
                          title: e.showName,
                        ),
                      ),
                    );
                  }
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}
