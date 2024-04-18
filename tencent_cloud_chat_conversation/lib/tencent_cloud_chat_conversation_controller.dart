import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_base_controller.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatConversationControllerGenerator {
  static TencentCloudChatConversationController getInstance() {
    return TencentCloudChatConversationController._();
  }
}

class TencentCloudChatConversationController
    extends TencentCloudChatComponentBaseController {
  TencentCloudChatConversationController._();

  /// Updating the conversation list with the latest conversations, sync with server.
  void updateConversationList({
    String? seq,
    int? count,
  }) {
    TencentCloudChat.instance.chatSDKInstance.conversationSDK.getConversationList(
      seq: seq,
      count: count,
    );
  }
}
