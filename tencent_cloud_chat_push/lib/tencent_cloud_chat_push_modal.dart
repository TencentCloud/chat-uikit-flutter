import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_push/common/tim_push_listener.dart';
import 'package:tencent_cloud_chat_push/common/tim_push_message.dart';
import 'package:tencent_cloud_chat_push/common/utils.dart';

class TencentCloudChatPushModal {
  TencentCloudChatPushModal._internal();

  factory TencentCloudChatPushModal() => _instance;
  static final TencentCloudChatPushModal _instance = TencentCloudChatPushModal._internal();

  Function({required String ext, String? userID, String? groupID})? onNotificationClicked;
  VoidCallback? onAppWakeUp;
  List<TIMPushListener> timPushListenerList = [];
  String? mNotificationExtInfo;

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case "on_notification_clicked":
        debugPrint("TencentCloudChatPush: ${call.arguments}");
        final ext = call.arguments.toString();
        final ParseExtInfoResult conversationInfo = TencentCloudChatPushUtils.parseExtInfo(ext);
        onNotificationClicked?.call(
          ext: call.arguments.toString(),
          userID: conversationInfo.userID,
          groupID: conversationInfo.groupID,
        );
        break;
      case "on_app_wake_up":
        onAppWakeUp?.call();
        break;
      case "onRecvPushMessage":
        debugPrint("onRecvPushMessage: ${TimPushMessage.fromJson(call.arguments).toLogString()}");
        timPushListenerList.forEach((listener) {
          try {
            listener.onRecvPushMessage(TimPushMessage.fromJson(call.arguments));
          } catch (err, errorStack) {
            debugPrint("$err $errorStack");
          }
        });
        break;
      case "onRevokePushMessage":
        debugPrint("onRevokePushMessage: ${call.arguments.toString()}");
        timPushListenerList.forEach((listener) {
          try {
            listener.onRevokePushMessage(call.arguments.toString());
          } catch (err, errorStack) {
            debugPrint("$err $errorStack");
          }
        });
        break;
      case "onNotificationClicked":
        debugPrint("onNotificationClicked: ${call.arguments.toString()}");
        mNotificationExtInfo = call.arguments.toString();
        notificationClicked();
        break;
      default:
        throw UnsupportedError("Unrecognized Event");
    }
  }

  void notificationClicked() {
    if (mNotificationExtInfo == null || timPushListenerList.isEmpty) {
      return;
    }

    timPushListenerList.forEach((listener) {
      try {
        String ext = mNotificationExtInfo!;
        listener.onNotificationClicked(ext);
      } catch (err, errorStack) {
        debugPrint("$err $errorStack");
      }
    });

    mNotificationExtInfo = null;
  }

  void addPushListener(TIMPushListener listener) {
    if (timPushListenerList.contains(listener)) {
      return;
    }

    timPushListenerList.add(listener);
    notificationClicked();
  }

  void removePushListener(TIMPushListener listener) {
    if (timPushListenerList.isEmpty) {
      return;
    }

    if (timPushListenerList.contains(listener)) {
      timPushListenerList.remove(listener);
    }
  }
}
