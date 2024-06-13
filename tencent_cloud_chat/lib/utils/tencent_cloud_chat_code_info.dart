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

  static TencentCloudChatUserNotificationEvent contactAddedSuccessfully = TencentCloudChatUserNotificationEvent(
    eventCode: -10401,
    text: tL10n.contactAddedSuccessfully,
  );

  static TencentCloudChatUserNotificationEvent contactRequestSent = TencentCloudChatUserNotificationEvent(
    eventCode: -10402,
    text: tL10n.requestSent,
  );

  static TencentCloudChatUserNotificationEvent cannotAddContact = TencentCloudChatUserNotificationEvent(
    eventCode: -10403,
    text: tL10n.cannotAddContact,
  );

  static TencentCloudChatUserNotificationEvent cannotSendApplicationToWorkGroup = TencentCloudChatUserNotificationEvent(
    eventCode: -10404,
    text: tL10n.cannotSendApplicationToWorkGroup,
  );

  static TencentCloudChatUserNotificationEvent groupJoinedPermissionNeeded = TencentCloudChatUserNotificationEvent(
    eventCode: -10405,
    text: tL10n.permissionNeeded,
  );

  static TencentCloudChatUserNotificationEvent groupJoined = TencentCloudChatUserNotificationEvent(
    eventCode: -10406,
    text: tL10n.groupJoined,
  );
}
