import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

/// Enum to represent different log levels
enum TencentCloudChatLogLevel {
  none, // No logs will be displayed

  debug, // Debug logs will be displayed

  info, // Info logs will be displayed

  error, // Error logs will be displayed

  all, // All logs will be displayed
}

class TencentCloudChatLogGenerator {
  static TencentCloudChatLog getInstance() {
    return TencentCloudChatLog._();
  }
}

/// Class for logging messages
class TencentCloudChatLog {
  static const String _tag = "TencentCloudChatLog";

  /// List to cache log messages
  List<String> _cachedLogList = List.from([]);

  /// Timer to periodically write logs
  Timer? _timer;

  TencentCloudChatLog._() {
    if (_timer == null) {
      // Start a timer to periodically write logs
      _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
        _writeLog();
      });

      // Log a message when the TencentCloudChatLog component is created and the timer starts
      console(
        componentName: _tag,
        logs: "New TencentCloudChatLog Component Success. And Timer Started",
      );
    }
  }

  /// Log a message to the console
  ///
  /// [componentName] represents the name of the component or module where the log message originates from.
  ///
  /// [logs] represents the log message to be logged.
  ///
  /// [logLevel] (optional) represents the log level for the message. If not provided, the default log level will be used.
  void console({
    required String componentName,
    required String logs,
    TencentCloudChatLogLevel? logLevel,
  }) {
    var currentTime = TencentCloudChatIntl.getFormattedTimeString();

    logLevel ??= TencentCloudChatLogLevel.debug;

    var cacheLogs =
        "TCCF:$currentTime:$componentName:${logLevel.name}:{ $logs }";

    if (kDebugMode) {
      // Print the log message to the console if the app is running in debug mode
      debugPrint(cacheLogs);
    }
    if (logLevel.index > TencentCloudChatLogLevel.none.index) {
      _cachedLogList.add(cacheLogs);
    }
  }

  /// Write cached logs to a file or external storage
  ///
  /// This method is called by the timer to write the cached logs
  /// to a file or external storage.
  ///
  /// This method writes the cached logs to a file or external storage. It is called by the timer at regular intervals.
  ///
  /// Returns a [Future] that completes when the logs are written.
  ///
  /// Example:
  /// dart   /// Future<void> writeLogs() async {   ///   await _writeLog();   /// }   ///
  Future<void> _writeLog() async {
    if (_cachedLogList.isEmpty) {
      return;
    }

    TencentCloudChat.instance.chatSDKInstance
        .uikitTrace(trace: _cachedLogList.join("\n"));

    /// Log a message indicating that the timer executed and the number of logs written

    _cachedLogList = [];
  }
}
