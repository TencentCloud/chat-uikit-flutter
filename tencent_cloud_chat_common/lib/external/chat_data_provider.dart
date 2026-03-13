import 'dart:async';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';

abstract class ChatDataProvider {
  Stream<List<V2TimConversation>> get conversationStream;
  Stream<int> get totalUnreadStream;
  Future<List<V2TimConversation>> getInitialConversations();
}

class ChatDataProviderRegistry {
  static ChatDataProvider? provider;
}



