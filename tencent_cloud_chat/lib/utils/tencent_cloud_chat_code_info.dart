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

  static TencentCloudChatUserNotificationEvent retrievingGroupMembers = TencentCloudChatUserNotificationEvent(
    eventCode: -10302,
    text: "Just a moment, retrieving group members.",
  );

  static TencentCloudChatUserNotificationEvent groupJoined = TencentCloudChatUserNotificationEvent(
    eventCode: -10406,
    text: tL10n.groupJoined,
  );
  static TencentCloudChatUserNotificationEvent copyFileCompleted = TencentCloudChatUserNotificationEvent(
    eventCode: -10407,
    text: tL10n.copyFileSuccess,
  );

  static TencentCloudChatUserNotificationEvent saveFileCompleted = TencentCloudChatUserNotificationEvent(
    eventCode: -10408,
    text: tL10n.saveFileSuccess,
  );

  static TencentCloudChatUserNotificationEvent saveFileFailed = TencentCloudChatUserNotificationEvent(
    eventCode: -10409,
    text: tL10n.saveFileFailed,
  );
  static TencentCloudChatUserNotificationEvent copyLinkSuccess = TencentCloudChatUserNotificationEvent(
    eventCode: -104010,
    text: tL10n.copyLinkSuccess,
  );
}
