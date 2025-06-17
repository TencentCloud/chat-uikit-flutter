import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_base_controller.dart';

class TencentCloudChatGroupProfileController extends TencentCloudChatComponentBaseController {
  static TencentCloudChatGroupProfileController? _instance;

  TencentCloudChatGroupProfileController._internal();

  static TencentCloudChatGroupProfileController get instance {
    _instance ??= TencentCloudChatGroupProfileController._internal();
    return _instance!;
  }

}
