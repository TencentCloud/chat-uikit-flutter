import 'dart:convert';

import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_code_info.dart';

enum LogicLogLevel {
  debug,
  error,
  info,
}

typedef OnTencentCloudChatSDKFailedCallback = void Function(String apiName, int code, String desc);

typedef OnTencentCloudChatUIKitUserNotificationEvent = void Function(TencentCloudChatComponentsEnum component, TencentCloudChatUserNotificationEvent event);

typedef OnTencentCloudChatUIKitLogicExecCallback = void Function(String fileName, LogicLogLevel logLevel, String data);

class TencentCloudChatCallbacks {
  static String componentName = "TencentCloudChatCallbacks";

  final OnTencentCloudChatSDKFailedCallback? _onTencentCloudChatSDKFailedCallback;
  final OnTencentCloudChatUIKitUserNotificationEvent? _onTencentCloudChatUIKitUserNotificationEvent;

  OnTencentCloudChatSDKFailedCallback? onSDKFailed;
  OnTencentCloudChatUIKitUserNotificationEvent? onUserNotificationEvent;

  static OnTencentCloudChatUIKitLogicExecCallback onTencentCloudChatUIKitLogicCallback = (String fileName, LogicLogLevel logLevel, String data) {
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: json.encode({
        "fileName": fileName,
        "logLevel": logLevel,
        "data": data,
      }),
    );
  };

  TencentCloudChatCallbacks({
    OnTencentCloudChatSDKFailedCallback? onTencentCloudChatSDKFailedCallback,
    OnTencentCloudChatUIKitUserNotificationEvent? onTencentCloudChatUIKitUserNotificationEvent,
  })  : _onTencentCloudChatUIKitUserNotificationEvent = onTencentCloudChatUIKitUserNotificationEvent,
        _onTencentCloudChatSDKFailedCallback = onTencentCloudChatSDKFailedCallback;

  activateCallbackModule() {
    onSDKFailed = (String apiName, int code, String desc) {
      TencentCloudChat.logInstance.console(
        componentName: componentName,
        logs: json.encode({
          "apiName": apiName,
          "code": code,
          "desc": desc,
        }),
      );
      if (_onTencentCloudChatSDKFailedCallback != null) {
        _onTencentCloudChatSDKFailedCallback!(apiName, code, desc);
      }
    };

    onUserNotificationEvent = (TencentCloudChatComponentsEnum component, TencentCloudChatUserNotificationEvent event) {
      TencentCloudChat.logInstance.console(
        componentName: componentName,
        logs: json.encode({
          "component": component.toString(),
          "eventCode": event.eventCode,
          "text": event.text,
        }),
      );

      if (_onTencentCloudChatUIKitUserNotificationEvent != null) {
        _onTencentCloudChatUIKitUserNotificationEvent!(component, event);
      }
    };
  }
}
