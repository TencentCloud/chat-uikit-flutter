import 'dart:async';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

abstract class ChatMessageProvider {
  Stream<List<V2TimMessage>> streamFor({String? userID, String? groupID});
  Future<void> sendText({String? userID, String? groupID, required String text});
  Future<void> sendImage({String? userID, String? groupID, required String imagePath, String? imageName});
  Future<void> sendFile({String? userID, String? groupID, required String filePath, String? fileName});
  Future<void> deleteMessages({String? userID, String? groupID, required List<String> msgIDs});
}

class ChatMessageProviderRegistry {
  static ChatMessageProvider? provider;
}



