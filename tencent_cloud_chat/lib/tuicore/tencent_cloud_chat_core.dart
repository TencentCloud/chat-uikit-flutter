import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';

class TencentCloudChatTUICore {
  static console(String log) {
    TencentCloudChat.instance.logInstance.console(componentName: "TencentCloudChatTUICore", logs: log);
  }

  static Future<void> callService(
    String serviceName,
    String method,
    Map<String, Object> param,
  ) async {
    return TUICore.instance.callService(serviceName, method, param);
  }

  static Future<bool> getService(String serviceName) async {
    return TUICore.instance.getService(serviceName);
  }

  static Future<void> audioCall({
    required List<String> userids,
    String? groupid,
  }) async {
    console("audioCall ${userids.join(",")} total ${userids.length} groupid $groupid");
    return TUICore.instance.callService(TUICALLKIT_SERVICE_NAME, METHOD_NAME_CALL, {
      PARAM_NAME_TYPE: TYPE_AUDIO,
      PARAM_NAME_USERIDS: userids,
      PARAM_NAME_GROUPID: groupid ?? "",
    });
  }

  static Future<void> videoCall({
    required List<String> userids,
    String? groupid,
  }) async {
    console("audioCall ${userids.join(",")} total ${userids.length} groupid $groupid");
    TUICore.instance.callService(TUICALLKIT_SERVICE_NAME, METHOD_NAME_CALL, {
      PARAM_NAME_TYPE: TYPE_VIDEO,
      PARAM_NAME_USERIDS: userids,
      PARAM_NAME_GROUPID: groupid ?? "",
    });
  }
}
