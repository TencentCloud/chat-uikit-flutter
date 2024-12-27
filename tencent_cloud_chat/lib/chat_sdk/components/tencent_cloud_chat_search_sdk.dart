import 'dart:math';

import 'package:collection/collection.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';

class TencentCloudChatSearchSDKGenerator {
  static TencentCloudChatSearchSDK getInstance() {
    return TencentCloudChatSearchSDK._();
  }
}

enum KeywordListMatchType { V2TIM_KEYWORD_LIST_MATCH_TYPE_OR, V2TIM_KEYWORD_LIST_MATCH_TYPE_AND }

class TencentCloudChatSearchResultItemData {
  final String showName;
  final String? avatarUrl;
  final int? totalCount;
  final String? userID;
  final String? groupID;
  final String conversationID;
  final List<V2TimMessage> messageList;

  TencentCloudChatSearchResultItemData({
    this.userID,
    required this.messageList,
    this.groupID,
    required this.conversationID,
    required this.showName,
    this.totalCount,
    this.avatarUrl,
  });
}

class TencentCloudChatSearchSDK {
  static const String _tag = "TencentCloudChatUIKitSearchSDK";

  TencentCloudChatSearchSDK._() {}

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: log,
    );
  }

  String? _extractIdFromConversationId(String conversationId, bool isUserId) {
    String prefix = isUserId ? 'c2c_' : 'group_';
    if (conversationId.startsWith(prefix)) {
      return conversationId.substring(prefix.length);
    }
    return null;
  }

  String buildConversationId({String? userID, String? groupID}) {
    if (groupID != null) {
      return 'group_$groupID';
    } else if (userID != null) {
      return 'c2c_$userID';
    } else {
      throw ArgumentError('Either userId or groupId must be provided.');
    }
  }

  Future<List<V2TimFriendInfoResult>> searchContacts(String keyword) async {
    if (TencentCloudChatPlatformAdapter().isWeb) {
      return [];
    }
    final res = await TencentCloudChat.instance.chatSDKInstance.manager.v2TIMFriendshipManager.searchFriends(
      searchParam: V2TimFriendSearchParam(
        keywordList: [
          keyword,
        ],
      ),
    );
    return res.data ?? [];
  }

  Future<List<V2TimGroupInfo>> searchGroups(String keyword) async {
    if (TencentCloudChatPlatformAdapter().isWeb) {
      return [];
    }
    final res = await TencentCloudChat.instance.chatSDKInstance.manager.v2TIMGroupManager.searchGroups(
      searchParam: V2TimGroupSearchParam(
        keywordList: [
          keyword,
        ],
      ),
    );
    return res.data ?? [];
  }

  Future<(int?, String?, List<TencentCloudChatSearchResultItemData>, String?)> searchMessages(
      {required String keyword, String? conversationID, List<int>? messageTypeList, String? cursor}) async {
    final localRes = (TencentCloudChatUtils.checkString(cursor) != null || TencentCloudChatPlatformAdapter().isWeb)
        ? null
        : await TencentCloudChat.instance.chatSDKInstance.manager.v2TIMMessageManager.searchLocalMessages(
            searchParam: V2TimMessageSearchParam(
              conversationID: conversationID,
              type: KeywordListMatchType.V2TIM_KEYWORD_LIST_MATCH_TYPE_OR.index,
              messageTypeList: (messageTypeList ?? []).isNotEmpty ? messageTypeList! : null,
              keywordList: [
                keyword,
              ],
            ),
          );

    final cloudRes = await TencentCloudChat.instance.chatSDKInstance.manager.v2TIMMessageManager.searchCloudMessages(
      searchParam: V2TimMessageSearchParam(
        searchCount: 100,
        type: KeywordListMatchType.V2TIM_KEYWORD_LIST_MATCH_TYPE_OR.index,
        conversationID: conversationID,
        messageTypeList: (messageTypeList ?? []).isNotEmpty ? messageTypeList! : null,
        searchCursor: cursor,
        keywordList: [
          keyword,
        ],
      ),
    );

    final resList = localRes?.data?.messageSearchResultItems ?? [];
    if ((cloudRes.data?.messageSearchResultItems ?? []).isNotEmpty) {
      for (final cloudResultItem in cloudRes.data!.messageSearchResultItems!) {
        final target = resList.indexWhere((e) => e.conversationID == cloudResultItem.conversationID);
        if (target > -1) {
          final cloudList = cloudResultItem.messageList ?? [];
          cloudList.map((cloudMessageItem) {
            if (!((resList[target].messageList ?? []).any((e) => e.msgID == cloudMessageItem.msgID))) {
              resList[target].messageList?.add(cloudMessageItem);
            }
          });
          resList[target].messageCount =
              max((cloudResultItem.messageCount ?? 0), (resList[target].messageList?.length ?? 0));
        } else {
          resList.add(cloudResultItem);
        }
      }
    }

    final conversationList = TencentCloudChat.instance.dataInstance.conversation.conversationList;
    final List<TencentCloudChatSearchResultItemData> searchResultConversationList = [];
    resList.forEach((element) async {
      if ((element.messageCount ?? 0) > 0 && TencentCloudChatUtils.checkString(element.conversationID) != null) {
        final conversationID = element.conversationID ?? "";
        V2TimConversation? targetConversation = conversationList.firstWhereOrNull((conversation) =>
            conversation.conversationID == conversationID && TencentCloudChatUtils.checkString(conversationID) != null);
        targetConversation ??= await TencentCloudChat.instance.chatSDKInstance.conversationSDK.getConversation(
          conversationID: conversationID,
        );
        searchResultConversationList.add(
          TencentCloudChatSearchResultItemData(
            messageList: element.messageList ?? [],
            showName: targetConversation.showName ?? element.conversationID ?? "",
            avatarUrl: targetConversation.faceUrl,
            totalCount: element.messageCount,
            conversationID: element.conversationID!,
            userID: targetConversation.userID ?? _extractIdFromConversationId(element.conversationID ?? "", true),
            groupID: targetConversation.groupID ?? _extractIdFromConversationId(element.conversationID ?? "", false),
          ),
        );
      }
    });
    return (
      localRes?.data?.totalCount,
      localRes?.data?.searchCursor,
      searchResultConversationList,
      cloudRes.data?.searchCursor
    );
  }
}
