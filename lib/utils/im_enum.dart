import 'package:collection/collection.dart';

class IMChatCustomItemType {
  // 职位卡片 优化，
  static const String B_ZTSALE_JOB_CARD_OPTIMIZE = 'B_ZTSALE_JOB_CARD_OPTIMIZE';

  // 职位卡片
  static const String B_ZTSALE_JOB_CARD = 'B_ZTSALE_JOB_CARD';

  // 机器人 选项
  static const String B_ZTSALE_ROBOT_QA_OPTIONS = 'B_ZTSALE_ROBOT_QA_OPTIONS';

  // 机器人 选项
  static const String B_ZTSALE_ROBOT_JOBS_OPTIONS =
      'B_ZTSALE_ROBOT_JOBS_OPTIONS';

  // jd内容卡片
  static const String B_ZTSALE_JD_DETAILS_CARD = 'B_ZTSALE_JD_DETAILS_CARD';

  // 更换服务顾问提示消息（带查看历史消息按钮）
  static const String B_ZTSALE_REPLACE_TIP = 'B_ZTSALE_REPLACE_TIP';

  // 立即解析
  static const String B_ZTSALE_ROBOT_JD_QA_ASK = 'B_ZTSALE_ROBOT_JD_QA_ASK';

  // tip
  static const String TIP = 'TIP';
}

//会话类型c2c单聊  group群聊
enum IMConversationType {
  c2c(value: 1),
  group(value: 2);

  final int? value;

  const IMConversationType({this.value});
}

//用户类型
enum IMAccountType { C, ZT, S, B }

class IMServiceMessageType {
  static const String TIMTextElem = 'TIMTextElem';
  static const String TIMLocationElem = 'TIMLocationElem';
  static const String TIMFaceElem = 'TIMFaceElem';
  static const String TIMCustomElem = 'TIMCustomElem';
  static const String TIMSoundElem = 'TIMSoundElem';
  static const String TIMImageElem = 'TIMImageElem';
  static const String TIMFileElem = 'TIMFileElem';
  static const String TIMVideoFileElem = 'TIMVideoFileElem';
  static const String TIMRelayElem = 'TIMRelayElem';
}
