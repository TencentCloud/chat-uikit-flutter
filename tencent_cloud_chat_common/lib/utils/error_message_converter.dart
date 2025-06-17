import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

class ErrorMessageConverter {
  static Map<int, String> errorMessageMap = {
    10017: tL10n.groupMemberMute,
    10008: tL10n.serverGroupInvalidReq,
    10024: tL10n.serverGroupReqAlreadyBeenProcessed,
  };

  static String getErrorMessage(int code, String desc) {
    return errorMessageMap[code] ?? desc;
  }

}