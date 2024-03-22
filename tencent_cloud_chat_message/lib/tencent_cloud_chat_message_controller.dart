import 'package:flutter/foundation.dart';

enum EventName {
  scrollToBottom,
  scrollToSpecificMessage,
}

class TencentCloudChatMessageController extends ChangeNotifier {
  EventName? eventName;
  String? eventValue;

  _triggerEvent(EventName name, String? value) {
    eventName = name;
    eventValue = value;
    notifyListeners();
  }

  void scrollToBottom() {
    _triggerEvent(EventName.scrollToBottom, null);
  }

  void scrollToSpecificMessage(String? msgID) {
    _triggerEvent(EventName.scrollToSpecificMessage, msgID);
  }
}
