import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_code_info.dart';

enum LogicLogLevel {
  debug,
  error,
  info,
}

typedef OnTencentCloudChatSDKFailedCallback = void Function(String apiName, int code, String desc);

typedef OnTencentCloudChatUIKitUserNotificationEvent = void Function(
    TencentCloudChatComponentsEnum component, TencentCloudChatUserNotificationEvent event);

typedef OnTencentCloudChatUIKitLogicExecCallback = void Function(String fileName, LogicLogLevel logLevel, String data);

class TencentCloudChatCallbacks {
  static String componentName = "TencentCloudChatCallbacks";

  final V2TimSDKListener? onSDKEvent;
  OnTencentCloudChatSDKFailedCallback? onSDKFailed;
  OnTencentCloudChatUIKitUserNotificationEvent? onUserNotificationEvent;

  TencentCloudChatCallbacks({
    OnTencentCloudChatSDKFailedCallback? onTencentCloudChatSDKFailedCallback,
    OnTencentCloudChatUIKitUserNotificationEvent? onTencentCloudChatUIKitUserNotificationEvent,
    V2TimSDKListener? onTencentCloudChatSDKEvent,
  })  : onUserNotificationEvent = onTencentCloudChatUIKitUserNotificationEvent,
        onSDKEvent = onTencentCloudChatSDKEvent,
        onSDKFailed = onTencentCloudChatSDKFailedCallback;
}
