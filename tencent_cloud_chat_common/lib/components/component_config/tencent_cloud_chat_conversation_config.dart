import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class TencentCloudChatConversationConfig {
  // A configuration option that determines whether to combine Conversation and Message on a single widget when rendering on Desktop.
  bool _useDesktopMode;

  // A configuration option that determines whether to combine Conversation and Message on a single widget when rendering on Desktop.
  bool get useDesktopMode => _useDesktopMode;

  // When true, the Conversation widget renders in desktop master-detail mode even on
  // non-desktop screen types (e.g. tablet landscape). Defaults to false to preserve
  // the original screen-size-driven behavior.
  bool _forceDesktopLayout;

  bool get forceDesktopLayout => _forceDesktopLayout;

  TencentCloudChatConversationConfig({
    bool useDesktopMode = true,
    bool forceDesktopLayout = false,
  })  : _useDesktopMode = useDesktopMode,
        _forceDesktopLayout = forceDesktopLayout;

  void setConfigs({
    bool? useDesktopMode,
    bool? forceDesktopLayout,
  }) {
    _useDesktopMode = useDesktopMode ?? _useDesktopMode;
    _forceDesktopLayout = forceDesktopLayout ?? _forceDesktopLayout;
    TencentCloudChat.instance.dataInstance.conversation
        .notifyListener(TencentCloudChatConversationDataKeys.conversationConfig);
  }
}
