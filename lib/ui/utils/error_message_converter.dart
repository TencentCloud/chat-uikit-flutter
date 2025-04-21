import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';

class ErrorMessageConverter {
  static Map<int, String> errorCodeMap = {
    10007: TIM_t("操作权限不足"),
    20007: TIM_t("发送单聊消息，被对方拉黑，禁止发送。"),
    30010: TIM_t("您的好友数已达系统上限"),
    30014: TIM_t("对方的好友数已达系统上限"),
    30015: TIM_t("对方已是您的好友"),
    30515: TIM_t("被加好友在自己的黑名单中"),
    30516: TIM_t("对方已禁止加好友"),
    30525: TIM_t("您已被被对方设置为黑名单"),
    30539: TIM_t("等待好友审核同意"),
  };

  static String getErrorMessage(int code) {
    return errorCodeMap[code] ?? "";
  }

}