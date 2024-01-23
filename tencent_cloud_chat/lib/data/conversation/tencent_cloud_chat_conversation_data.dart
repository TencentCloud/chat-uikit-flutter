import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_conversation_config.dart';
import 'package:tencent_cloud_chat/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

/// An enumeration of conversation data keys TencentCloudChat conversation component
enum TencentCloudChatConversationDataKeys {
  none,
  conversationList,
  totalUnreadCount,
  getDataEnd,
  currentConversation,
  conversationConfig,
}

/// A class that manages the conversation data for TencentCloudChat conversation component
///
/// This class extends [TencentCloudChatUIKitCoreDataAB] and provides
/// functionality for managing the status of conversation component.
class TencentCloudChatConversationData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatConversationData(super.currentUpdatedFields);

  /// === Conversation Config ===
  static TencentCloudChatConversationConfig? _conversationConfig;

  TencentCloudChatConversationConfig? get conversationConfig =>
      _conversationConfig;

  set conversationConfig(TencentCloudChatConversationConfig? value) {
    _conversationConfig = value;
    notifyListener(
        TencentCloudChatConversationDataKeys.conversationConfig as T);
  }

  /// === Current Conversation ===
  static V2TimConversation? _currentConversation;

  V2TimConversation? get currentConversation => _currentConversation;

  set currentConversation(V2TimConversation? value) {
    _currentConversation = value;
    notifyListener(
        TencentCloudChatConversationDataKeys.currentConversation as T);
  }

  /// === conversation list ===
  static List<V2TimConversation> _conversationList = [];

  /// === current conversation list sequence when getting conversation list ===
  static String currentGetConversationListSeq = "0";

  /// === conversation count when getting conversation list ===
  static int getConversationListCount = 20;

  /// === value to check if the conversation list is finished when getting conversation list ==
  static bool isGetConversationFinished = false;

  /// === convesation total unread count ==
  static int _totalUnreadCount = 0;

  /// === value that all data is got ===
  static bool _isGetDataEnd = false;

  setTotalUnreadCount(int count) {
    _totalUnreadCount = count;
    notifyListener(TencentCloudChatConversationDataKeys.totalUnreadCount as T);
  }

  void updateIsGetDataEnd(bool status) {
    _isGetDataEnd = status;
    notifyListener(TencentCloudChatConversationDataKeys.getDataEnd as T);
  }

  int get totalUnreadCount => _totalUnreadCount;

  List<V2TimConversation> get conversationList => _conversationList;

  set conversationList(List<V2TimConversation> value) {
    _conversationList = value;
  }

  bool get isGetDataEnd => _isGetDataEnd;

  void buildConversationList(List<V2TimConversation> convList, String action) {
    for (var element in convList) {
      var index = _conversationList
          .indexWhere((ele) => element.conversationID == ele.conversationID);
      if (index > -1) {
        _conversationList[index] = element;
      } else {
        _conversationList.add(element);
      }
    }
    // sort
    _conversationList.sort(
      (a, b) {
        int aR = a.orderkey ?? 0;
        int bR = b.orderkey ?? 0;
        return bR.compareTo(aR);
      },
    );
    console(
        logs:
            "$action buildConversationList ${convList.length} conv changed. total conv length is ${_conversationList.length}");
    TencentCloudChat.cache.cacheConversationList(_conversationList);
    notifyListener(TencentCloudChatConversationDataKeys.conversationList as T);
  }

  void removeConversation(List<String> convIds) {
    for (var i = 0; i < convIds.length; i++) {
      String convID = convIds[i];
      _conversationList
          .removeWhere((element) => element.conversationID == convID);
      console(
          logs:
              "removeConversation $convID conv changed. total conv length is ${_conversationList.length}");
    }
    notifyListener(TencentCloudChatConversationDataKeys.conversationList as T);
  }

  @override
  void notifyListener(T key) {
    currentUpdatedFields = key;
    TencentCloudChat.eventBusInstance.fire(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "conversationList": _conversationList.map((e) => e.toJson()).toList(),
      "currentGetConversationListSeq": currentGetConversationListSeq,
      "getConversationListCount": getConversationListCount,
      "isGetConversationFinished": isGetConversationFinished,
    });
  }
}
