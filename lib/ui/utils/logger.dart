import 'package:zhaopin/im/tencent_cloud_chat_uikit.dart';
import 'package:zhaopin/im/ui/utils/platform.dart';

final outputLogger = TencentCloudChatLog();

class TencentCloudChatLog{
  void i(String text){
    if(!PlatformUtils().isWeb){
      TencentImSDKPlugin.v2TIMManager
          .uikitTrace(trace: text);
    }
  }
}