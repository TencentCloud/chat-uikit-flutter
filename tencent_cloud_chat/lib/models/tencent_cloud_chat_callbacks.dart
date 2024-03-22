import 'dart:convert';

import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

enum LogicLogLevel {
  debug,
  error,
  info,
}

typedef OnTencentCloudChatSDKFialCallback = void Function(String apiName, int code, String desc);

/// fileName当前逻辑所在文件
///
typedef OnTencentCloudChatUIKitLogicExecCallback = void Function(String fileName, LogicLogLevel logLevel, String data);

class TencentCloudChatCallbacks {
  static String componentName = "TencentCloudChatCallbacks";
  OnTencentCloudChatSDKFialCallback? onTencentCloudChatSDKFailCallback;
  static late final OnTencentCloudChatSDKFialCallback onSDKFail;
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
    this.onTencentCloudChatSDKFailCallback,
  });
  static mergeUsersCallback(TencentCloudChatCallbacks? callback) {
    onSDKFail = (String apiName, int code, String desc) {
      TencentCloudChat.logInstance.console(
        componentName: componentName,
        logs: json.encode({
          "apiName": apiName,
          "code": code,
          "desc": desc,
        }),
      );
      if (callback != null) {
        if (callback.onTencentCloudChatSDKFailCallback != null) {
          callback.onTencentCloudChatSDKFailCallback!(apiName, code, desc);
        }
      }
    };
  }
}
