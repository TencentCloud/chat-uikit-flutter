import 'package:tencent_cloud_chat_sdk/enum/callbacks.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

enum TencentCloudChatRobotPluginEventType {
  onTap,
  onError,
  onSendMessageToRobotSuccess,
  onCreateMessageSuccess,
}

class TencentCloudChatRobotUtils {
  static Future<void> emitPluginEvent(TencentCloudChatRobotPluginEventType type,
      Map<String, dynamic> detail) async {
    await TencentImSDKPlugin.v2TIMManager.emitPluginEvent(PluginEvent(
        type: type.name,
        detail: detail,
        pluginName: "TencentCloudChatRobotPlugin"));
  }
}
