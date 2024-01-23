import 'dart:async';

import 'package:tencent_cloud_chat/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

/// Dispatches events to listeners using the Dart [Stream] API. The [EventBus]
/// enables decoupled applications. It allows objects to interact without
/// requiring to explicitly define listeners and keeping track of them.
///
/// Not all events should be broadcasted through the [EventBus] but only those of
/// general interest.
///
/// Events are normal Dart objects. By specifying a class, listeners can
/// filter events.
///
class TencentCloudChatEventBus {
  static final List<String> allowList = [
    "TencentCloudChatTheme",
    "TencentCloudChat"
  ];

  static final StreamController _streamController =
      StreamController.broadcast(sync: false);

  static final TencentCloudChatEventBus _instance =
      TencentCloudChatEventBus._internal();

  static final Map<String, Stream> _subscriptions = {};
  static final Map<String, dynamic> _cachedEvent = {};
  factory TencentCloudChatEventBus() {
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
  Stream<T>? on<T>() {
    if (allowList.contains(_formatToComponentName(T.toString()))) {
      Stream<T> steam =
          _streamController.stream.where((event) => event is T).cast<T>();

      _subscriptions.addAll({
        T.toString(): steam,
      });
      if (_cachedEvent.containsKey(T.toString())) {
        // TencentCloudChat.logInstance.console(
        //   componentName: runtimeType.toString(),
        //   logs: "When ${T.toString()} subscribing to listen, it is detected that there is a cached event to be triggered.",
        //   logLevel: TencentCloudChatLogLevel.info,
        // );
        fire(_cachedEvent[T.toString()] as T);
      }
      return steam;
    } else {
      TencentCloudChat.logInstance.console(
        componentName: runtimeType.toString(),
        logs: "You must monitor a value of a certain type, not a dynamic type.",
        logLevel: TencentCloudChatLogLevel.error,
      );
    }
    return null;
  }

  /// Fires a new event on the event bus with the specified [event].
  ///
  void fire(event) {
    String eventName = event.runtimeType.toString();
    if (_subscriptions.containsKey(eventName)) {
      Future.delayed(Duration.zero, () {
        _streamController.add(event);
      });
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
