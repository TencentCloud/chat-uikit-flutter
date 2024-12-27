
import 'package:tencent_cloud_chat_push/common/tim_push_message.dart';

typedef OnRecvPushMessageCallback = void Function(
    TimPushMessage msg,
    );

typedef OnRevokePushMessageCallback = void Function(
    String msgID,
    );

typedef OnNotificationClickedCallback = void Function(
    String ext,
    );

class TIMPushListener {
  OnRecvPushMessageCallback onRecvPushMessage = (
      TimPushMessage message,
      ) {};
  OnRevokePushMessageCallback onRevokePushMessage = (
      String msgID,
      ) {};
  OnNotificationClickedCallback onNotificationClicked= (
      String ext,
      ) {};

  TIMPushListener({
    OnRecvPushMessageCallback? onRecvPushMessage,
    OnRevokePushMessageCallback? onRevokePushMessage,
    OnNotificationClickedCallback? onNotificationClicked,
  }) {
    if (onRecvPushMessage != null) {
      this.onRecvPushMessage = onRecvPushMessage;
    }

    if (onRevokePushMessage != null) {
      this.onRevokePushMessage = onRevokePushMessage;
    }

    if (onNotificationClicked != null) {
      this.onNotificationClicked = onNotificationClicked;
    }
  }
}