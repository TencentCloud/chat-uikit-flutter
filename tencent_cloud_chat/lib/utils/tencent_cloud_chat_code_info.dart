import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatUserNotificationEvent {
  int eventCode;
  String text;

  TencentCloudChatUserNotificationEvent({
    required this.eventCode,
    required this.text,
  });
}

class TencentCloudChatCodeInfo {
  static TencentCloudChatUserNotificationEvent originalMessageNotFound = TencentCloudChatUserNotificationEvent(
    eventCode: -10301,
    text: tL10n.originalMessageNotFound,
  );
}
