import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation_result.dart';

abstract class ConversationService {
  Future<V2TimConversationResult?> getConversationList({
    required String nextSeq,
    required int count,
  });

  Future<V2TimConversation?> getConversation({
    required String conversationID,
  });

  Future<V2TimCallback> pinConversation({
    required String conversationID,
    required bool isPinned,
  });

  Future<V2TimCallback> deleteConversation({
    required String conversationID,
  });

  Future<void> addConversationListener({
    required V2TimConversationListener listener,
  });

  Future<V2TimCallback> setConversationDraft({required String conversationID, String? draftText});

  Future<void> removeConversationListener({V2TimConversationListener? listener});

  Future<int> getTotalUnreadCount();

  Future<V2TimConversation?> getConversationListByConversationId({required String convID});
}
