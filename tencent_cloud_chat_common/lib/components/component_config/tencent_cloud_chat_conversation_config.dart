import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatConversationConfig {
  // A configuration option that determines whether to combine Conversation and Message on a single widget when rendering on Desktop.
  bool _useDesktopMode;

  // A configuration option that determines whether to combine Conversation and Message on a single widget when rendering on Desktop.
  bool get useDesktopMode => _useDesktopMode;

  TencentCloudChatConversationConfig({
    bool useDesktopMode = true,
  }) : _useDesktopMode = useDesktopMode;

  void setConfigs({
    bool? useDesktopMode,
  }) {
    _useDesktopMode = useDesktopMode ?? _useDesktopMode;
    TencentCloudChat.instance.dataInstance.conversation
        .notifyListener(TencentCloudChatConversationDataKeys.conversationConfig);
  }
}
