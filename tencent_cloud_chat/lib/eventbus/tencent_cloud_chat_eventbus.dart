import 'dart:async';

import 'package:tencent_cloud_chat/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class TencentCloudChatEventBusGenerator {
  static TencentCloudChatEventBus getInstance() {
    return TencentCloudChatEventBus._();
  }
}

/// Dispatches events to listeners using the Dart [Stream] API. The [EventBus]
/// enables decoupled applications. It allows objects to interact without
/// requiring to explicitly define listeners and keeping track of them.
///
/// Not all events should be broadcast through the [EventBus] but only those of
/// general interest.
///
/// Events are normal Dart objects. By specifying a class, listeners can
/// filter events.
///
class TencentCloudChatEventBus {
  static final List<String> allowList = ["TencentCloudChatConversationData","TencentCloudChatTheme", "TencentCloudChat", "TencentCloudChatGroupProfileData"];

  static final StreamController _streamController = StreamController.broadcast(sync: false);

  static final TencentCloudChatEventBus _instance = TencentCloudChatEventBus._internal();

  static final Map<String, Stream> _subscriptions = {};
  static final Map<String, dynamic> _cachedEvent = {};

  factory TencentCloudChatEventBus._() {
    return _instance;
  }

  TencentCloudChatEventBus._internal();

  String _formatToComponentName(String tName) {
    if (tName.contains("TencentCloudChat")) {
      return "TencentCloudChat";
    } else {
      return tName;
    }
  }

  /// Listens for events of Type [T] and its subtypes.
  ///
  /// The method is called like this: myEventBus.on<MyType>();
  ///
  /// If the method is called without a type parameter, the [Stream] contains every
  /// event of this [EventBus].
  ///
  /// The returned [Stream] is a broadcast stream so multiple subscriptions are
  /// allowed.
  ///
  /// Each listener is handled independently, and if they pause, only the pausing
  /// listener is affected. A paused listener will buffer events internally until
  /// unpaused or canceled. So it's usually better to just cancel and later
  /// subscribe again (avoids memory leak).
  ///
  Stream<T>? on<T>(String widgetName) {
    if (allowList.contains(_formatToComponentName(widgetName))) {
      Stream<T> steam = _streamController.stream.where((event) => event is T).cast<T>();

      _subscriptions.addAll({
        widgetName: steam,
      });
      if (_cachedEvent.containsKey(widgetName)) {
        fire(_cachedEvent[widgetName] as T, widgetName);
      }
      return steam;
    } else {
      TencentCloudChat.instance.logInstance.console(
        componentName: runtimeType.toString(),
        logs: "You must monitor a value of a certain type, not a dynamic type.",
        logLevel: TencentCloudChatLogLevel.error,
      );
    }
    return null;
  }

  /// Fires a new event on the event bus with the specified [event].
  ///
  void fire(event, String eventName) {
    if (_subscriptions.containsKey(eventName)) {
      _streamController.add(event);
      _cachedEvent.remove(eventName);
    } else {
      _cachedEvent.addAll({
        eventName: event,
      });
    }
  }

  /// Destroy this [EventBus]. This is generally only in a testing context.
  ///
  void destroy() {
    _cachedEvent.clear();
    _subscriptions.clear();
    _streamController.close();
  }
}
