import 'dart:convert';

import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_callbacks.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_code_info.dart';

class TencentCloudChatCallbacksTriggerGenerator {
  static TencentCloudChatCallbacksTrigger getInstance() {
    return TencentCloudChatCallbacksTrigger._();
  }
}

class TencentCloudChatCallbacksTrigger {
  TencentCloudChatCallbacksTrigger._();

  static String componentName = "TencentCloudChatCallbacks";

  V2TimSDKListener? defaultV2TimSDKListener;
  final List<TencentCloudChatCallbacks> callbacksList = [];

  void addCallback(TencentCloudChatCallbacks callbacks) {
    callbacksList.add(callbacks);
    _initDefaultV2TimSDKListener();
  }

  void removeCallback(TencentCloudChatCallbacks callbacks) {
    callbacksList.remove(callbacks);
  }

  void removeAllCallbacks() {
    callbacksList.clear();
  }

  void _initDefaultV2TimSDKListener() {
    defaultV2TimSDKListener ??= V2TimSDKListener(
      onConnecting: () {
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onConnecting();
        }
      },
      onConnectSuccess: () {
        for (final callbacks in callbacksList) {
          TencentCloudChat.instance.dataInstance.messageData.onConnectSuccess();
          callbacks.onSDKEvent?.onConnectSuccess();
        }
      },
      onConnectFailed: (int code, String error) {
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onConnectFailed(code, error);
        }
      },
      onKickedOffline: () {
        TencentCloudChat.instance.dataInstance.basic.updateLoginStatus(
          status: false,
        );
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onKickedOffline();
        }
      },
      onUserSigExpired: () {
        TencentCloudChat.instance.dataInstance.basic.updateLoginStatus(
          status: false,
        );

        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onUserSigExpired();
        }
      },
      onSelfInfoUpdated: (
        V2TimUserFullInfo info,
      ) {
        TencentCloudChat.instance.dataInstance.basic
            .updateCurrentUserInfo(userFullInfo: info);
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onSelfInfoUpdated(info);
        }
      },
      onUserStatusChanged: (List<V2TimUserStatus> userStatusList) {
        TencentCloudChat.instance.dataInstance.contact
            .buildUserStatusList(userStatusList, "onUserStatusChanged");
        TencentCloudChat.instance.dataInstance.messageData.onUserStatusChanged(userStatusList);
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onUserStatusChanged(userStatusList);
        }
      },
      onLog: (int logLevel, String logContent) {
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onLog(logLevel, logContent);
        }
      },
      onUserInfoChanged: (List<V2TimUserFullInfo> userInfoList) {
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onUserInfoChanged(userInfoList);
        }
      },
      onAllReceiveMessageOptChanged:
          (V2TimReceiveMessageOptInfo receiveMessageOptInfo) {
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent
              ?.onAllReceiveMessageOptChanged(receiveMessageOptInfo);
        }
      },
      onExperimentalNotify: (String key, dynamic param) {
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onExperimentalNotify(key, param);
        }
      },
      onUIKitEventEmited: (UIKitEvent event) {
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onUIKitEventEmited(event);
        }
      },
      onPluginEventEmited: (PluginEvent event) {
        // Handle TencentCloudChatRobot Plugin sendMessage
        if (event.pluginName == "TencentCloudChatRobotPlugin") {
          if (event.type == "onSendMessageToRobotSuccess") {
            Map<String, dynamic> messageMap =
                json.decode(event.detail["data"] ?? "{}");
            var message = V2TimMessage.fromJson(messageMap);
            TencentCloudChat.instance.dataInstance.messageData
                .onReceiveNewMessage(message);
          }
        }
        if (event.pluginName == "TencentCloudChatCustomerServicePlugin") {
          if (event.type == "onSendMessageToCustomerServiceSuccess") {
            Map<String, dynamic> messageMap =
                json.decode(event.detail["data"] ?? "{}");
            var message = V2TimMessage.fromJson(messageMap);
            TencentCloudChat.instance.dataInstance.messageData
                .onReceiveNewMessage(message);
          }
        }
        for (final callbacks in callbacksList) {
          callbacks.onSDKEvent?.onPluginEventEmited(event);
        }
      },
    );
  }

  void onSDKFailed(String apiName, int code, String desc) {
    TencentCloudChat.instance.logInstance.console(
      componentName: componentName,
      logs: json.encode({
        "apiName": apiName,
        "code": code,
        "desc": desc,
      }),
    );

    for (final callbacks in callbacksList) {
      callbacks.onSDKFailed?.call(apiName, code, desc);
    }
  }

  void onUserNotificationEvent(TencentCloudChatComponentsEnum component,
      TencentCloudChatUserNotificationEvent event) {
    TencentCloudChat.instance.logInstance.console(
      componentName: componentName,
      logs: json.encode({
        "component": component.toString(),
        "eventCode": event.eventCode,
        "text": event.text,
      }),
    );

    for (final callbacks in callbacksList) {
      callbacks.onUserNotificationEvent?.call(component, event);
    }
  }
}
