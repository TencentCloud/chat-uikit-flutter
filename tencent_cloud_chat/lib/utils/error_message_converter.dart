import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';

class ErrorMessageConverter {
  static Map<int, String> errorMessageMap = {
    10017: tL10n.groupMemberMute,

  };

  static String getErrorMessage(int code) {
    return errorMessageMap[code] ?? '';
  }

}