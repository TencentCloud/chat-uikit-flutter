import 'package:tencent_cloud_chat/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

/// An abstract class for handling core data in TencentCloudChat.
///
/// This class provides a base for managing the core data in the Chat UIKit,
/// including methods for converting data to JSON and notifying listeners.
abstract class TencentCloudChatDataAB<T> {
  Map<String, dynamic> toJson();

  void notifyListener(T key);

  late T currentUpdatedFields;

  TencentCloudChatDataAB(this.currentUpdatedFields);

  /// A helper method for logging console messages.
  ///
  /// The [logs] parameter is the message to log.
  /// The [logLevel] parameter is optional and can be used to specify the log level.
  console({
    required String logs,
    TencentCloudChatLogLevel? logLevel,
  }) {
    var componentName =
        runtimeType.toString().replaceAll("TencentCloudChat", "");
    TencentCloudChat.logInstance.console(
      componentName: componentName,
      logs: logs,
      logLevel: logLevel,
    );
  }
}
