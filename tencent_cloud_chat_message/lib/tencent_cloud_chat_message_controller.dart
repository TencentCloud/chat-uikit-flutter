import 'package:flutter/foundation.dart';

enum EventName {
  scrollToBottom,
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
}
