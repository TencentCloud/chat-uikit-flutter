import 'package:tencent_cloud_chat_uikit/import_proxy/general.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'platform/web_import.dart'
// ignore: uri_does_not_exist
    if (dart.library.io) 'platform/native_import.dart';

abstract class ImportProxy {
  getFlutterPluginRecord();

  factory ImportProxy() => getImportProxy();
}
