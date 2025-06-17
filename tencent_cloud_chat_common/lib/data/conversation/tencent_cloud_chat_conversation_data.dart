import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_conversation_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_conversation_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

/// An enumeration of conversation data keys TencentCloudChat conversation component
enum TencentCloudChatConversationDataKeys {
  none,
  conversationList,
  totalUnreadCount,
  getDataEnd,
  currentConversation,
  targetMessage,
  conversationConfig,
  conversationBuilder,
  conversationEventHandlers,
}

/// A class that manages the conversation data for TencentCloudChat conversation component
///
/// This class extends [TencentCloudChatUIKitCoreDataAB] and provides
/// functionality for managing the status of conversation component.
class TencentCloudChatConversationData<T> extends TencentCloudChatDataAB<T> {
  TencentCloudChatConversationData(super.currentUpdatedFields);

  /// === Conversation Config ===
  TencentCloudChatConversationConfig _conversationConfig = TencentCloudChatConversationConfig();

  TencentCloudChatConversationConfig get conversationConfig => _conversationConfig;

  set conversationConfig(TencentCloudChatConversationConfig value) {
    _conversationConfig = value;
    notifyListener(TencentCloudChatConversationDataKeys.conversationConfig as T);
  }

  /// === Conversation Event Handlers ===
  TencentCloudChatConversationEventHandlers? conversationEventHandlers;

  /// === Conversation Builder ===
  TencentCloudChatComponentBuilder? _conversationBuilder;

  TencentCloudChatComponentBuilder? get conversationBuilder => _conversationBuilder;

  set conversationBuilder(TencentCloudChatComponentBuilder? value) {
    _conversationBuilder = value;
    notifyListener(TencentCloudChatConversationDataKeys.conversationBuilder as T);
  }

  /// === Controller ===
  TencentCloudChatComponentBaseController? conversationController;

  /// === Current Conversation ===
  V2TimConversation? _currentConversation;

  V2TimConversation? get currentConversation => _currentConversation;

  set currentConversation(V2TimConversation? value,) {
    _currentConversation = value;
    notifyListener(TencentCloudChatConversationDataKeys.currentConversation as T);
  }

  /// === Current TargetMessage ===
  V2TimMessage? currentTargetMessage;

  /// === Conversation list ===
  List<V2TimConversation> _conversationList = [];

  /// === Current conversation list sequence when getting conversation list ===
  String currentGetConversationListSeq = "0";

  /// === Conversation count when getting conversation list ===
  int getConversationListCount = 20;

  /// === Value to check if the conversation list is finished when getting conversation list ==
  bool isGetConversationFinished = false;

  /// === Conversation total unread count ==
  int _totalUnreadCount = 0;

  /// === Value that all data is got ===
  bool _isGetDataEnd = false;

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
      var index = _conversationList.indexWhere((ele) => element.conversationID == ele.conversationID);
      if (index > -1) {
        _conversationList[index] = element;
      } else {
        _conversationList.add(element);
      }
    }
    // sort
    if (TencentCloudChatPlatformAdapter().isWeb) {
      try {
        _conversationList.sort((a, b) {
          return b.lastMessage!.timestamp!.compareTo(a.lastMessage!.timestamp!);
        });

        final pinnedConversation = _conversationList.where((element) => element.isPinned == true).toList();
        _conversationList.removeWhere((element) => element.isPinned == true);
        _conversationList = [...pinnedConversation, ..._conversationList];
        // ignore: empty_catches
      } catch (e) {}
    } else {
      _conversationList.sort(
        (a, b) {
          int aR = a.orderkey ?? 0;
          int bR = b.orderkey ?? 0;
          return bR.compareTo(aR);
        },
      );
    }
    console(
        logs:
            "$action buildConversationList ${convList.length} conv changed. total conv length is ${_conversationList.length}");
    notifyListener(TencentCloudChatConversationDataKeys.conversationList as T);
  }

  void removeConversation(List<String> convIds) {
    for (var i = 0; i < convIds.length; i++) {
      String convID = convIds[i];
      _conversationList.removeWhere((element) => element.conversationID == convID);
      console(logs: "removeConversation $convID conv changed. total conv length is ${_conversationList.length}");
    }
    notifyListener(TencentCloudChatConversationDataKeys.conversationList as T);
  }

  bool _isConversationHidden(String convID) {
    var index = _conversationList.indexWhere((conv) => convID == conv.conversationID);
    if (index != -1) {
      // V2TIM_CONVERSATION_MARK_TYPE_HIDE = 0x1 << 3
      return _conversationList[index].markList?.contains(8) ?? false;
    }

    return false;
  }

  void unhideConversation({String? userID, String? groupID}) {
    String convID = '';
    if (userID != null && userID.isNotEmpty) {
      convID = 'c2c_$userID';
    } else if (groupID != null && groupID.isNotEmpty) {
      convID = 'group_$groupID';
    }

    if (convID.isNotEmpty && _isConversationHidden(convID)) {
      TencentCloudChat.instance.chatSDKInstance.manager
          .getConversationManager()
          .markConversation(markType: 8, enableMark: false, conversationIDList: [convID]);
    }
  }

  @override
  void notifyListener(T key) {
    var event = TencentCloudChatConversationData<T>(key);
    event._conversationConfig = _conversationConfig;
    event.conversationEventHandlers = conversationEventHandlers;
    event._conversationBuilder = _conversationBuilder;
    event.conversationController = conversationController;
    event._currentConversation = _currentConversation;
    event.currentTargetMessage = currentTargetMessage;
    event._conversationList = _conversationList;
    event.currentGetConversationListSeq = currentGetConversationListSeq;
    event.getConversationListCount = getConversationListCount;
    event.isGetConversationFinished = isGetConversationFinished;
    event._totalUnreadCount = _totalUnreadCount;
    event._isGetDataEnd = _isGetDataEnd;

    TencentCloudChat.instance.eventBusInstance.fire(event, "TencentCloudChatConversationData");
  }

  @override
  void clear() {
    _currentConversation = null;
    currentTargetMessage = null;
    _conversationList = [];
    currentGetConversationListSeq = "0";
    isGetConversationFinished = false;
    _totalUnreadCount = 0;
    _isGetDataEnd = false;
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
