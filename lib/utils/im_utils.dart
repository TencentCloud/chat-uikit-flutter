import 'package:zhaopin/app_config.dart';
import 'package:zhaopin/im/tencent_cloud_chat_uikit.dart';

class IMUtils {
  // 生成不同环境下的IMUserID
  // C112-> C112_dev
  static String userIDWithEnv(String? userID) {
    if (userID == null) return '';
    if (AppConfig.env == Env.pro) return userID;
    if (userID.contains('_')) return userID;
    return '${userID}_${AppConfig.env.name}';
  }

  // 根据IMUserID获取业务userID
  // C112_dev  -> 112
  static String businessUserIDByIMUserID({required String? userID}) {
    if (userID == null) return '';
    final tmpUserID = userID.split('_')[0];
    if (tmpUserID.startsWith('C') ||
        tmpUserID.startsWith('B') ||
        tmpUserID.startsWith('S')) {
      return tmpUserID.substring(1);
    } else if (tmpUserID.startsWith('ZT')) {
      return tmpUserID.substring(2);
    }
    return userID;
  }

  static String? getLastMsgShowText(V2TimMessage? message) {
    if (message == null) return "";
    final msgType = message.elemType;
    switch (msgType) {
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return "[自定义]";
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return "[语音]";
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return (message.textElem?.text)?.trim() ?? "";
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return "[表情]";
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        final option1 = message.fileElem!.fileName;
        return "[文件] $option1";
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return "[图片]";
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        return "[视频]";
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        return "[位置]";
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        return "[聊天记录]";
      default:
        return null;
    }
  }
}
