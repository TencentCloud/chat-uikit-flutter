import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_push/common/utils.dart';

class TencentCloudChatPushModal {
  TencentCloudChatPushModal._internal();

  factory TencentCloudChatPushModal() => _instance;
  static final TencentCloudChatPushModal _instance = TencentCloudChatPushModal._internal();

  Function({required String ext, String? userID, String? groupID})? onNotificationClicked;
  VoidCallback? onAppWakeUp;

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
      default:
        throw UnsupportedError("Unrecognized Event");
    }
  }
}
