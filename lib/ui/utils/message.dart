// ignore_for_file: unrelated_type_equality_checks, avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/history_message_constant.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/time.dart';
import 'package:collection/collection.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/common_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/logger.dart';

class MessageUtils {
  // 判断CallingData的方式和Trtc的方法一致
  static isCallingData(String data) {
    try {
      Map<String, dynamic> customMap = jsonDecode(data);

      if (customMap.containsKey('businessID') && customMap['businessID'] == 1) {
        return true;
      }
    } catch (e) {
      outputLogger.i("isCallingData json parse error");
      return false;
    }
    return false;
  }

  // 是否是群组TRTC信息
  static isGroupCallingMessage(V2TimMessage message) {
    final isGroup = message.groupID != null;
    final isCustomMessage =
        message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM;
    if (isCustomMessage) {
      final customElemData = message.customElem?.data ?? "";
      return isCallingData(customElemData) && isGroup;
    }
    return false;
  }

  static Future<String> _getGroupChangeType(V2TimGroupChangeInfo info,
      List<V2TimGroupMemberFullInfo?> groupMemberList) async {
    int? type = info.type;
    var value = info.value;
    String s = TIM_t('群资料信息');
    switch (type) {
      case GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_CUSTOM:
        s = TIM_t("自定义字段");
        break;
      case GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_FACE_URL:
        s = TIM_t("群头像");
        break;
      case GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_INTRODUCTION:
        s = TIM_t("群简介");
        break;
      case GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_NAME:
        s = TIM_t("群名称");
        break;
      case GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_NOTIFICATION:
        s = TIM_t("群公告");
        break;
      case GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_OWNER:
        s = TIM_t("群主");
        final V2TimGroupMemberFullInfo? groupMemberInfo = groupMemberList
            .firstWhereOrNull((element) => element?.userID == value);
        if (groupMemberInfo != null) {
          value = TencentUtils.checkString(groupMemberInfo.friendRemark) ??
              TencentUtils.checkString(groupMemberInfo.nameCard) ??
              TencentUtils.checkString(groupMemberInfo.nickName) ??
              TencentUtils.checkString(groupMemberInfo.userID);
        } else {
          final res = await TencentImSDKPlugin.v2TIMManager
              .getUsersInfo(userIDList: [value ?? ""]);
          if (res.code == 0) {
            final List<V2TimUserFullInfo> data = res.data ?? [];
            if (data.isNotEmpty) {
              final firstPerson = data[0];
              value = TencentUtils.checkString(firstPerson.nickName) ??
                  TencentUtils.checkString(firstPerson.userID);
            }
          }
        }
        break;
      case GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_SHUT_UP_ALL:
        s = TIM_t("全员禁言状态");
        break;
      case GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_RECEIVE_MESSAGE_OPT:
        s = TIM_t("消息接收方式");
        break;
      case GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_GROUP_ADD_OPT:
        s = TIM_t("加群方式");
        break;
    }

    final String option8 = s;
    if (value != null && value.isNotEmpty) {
      return TIM_t_para("{{option8}}为 ", "$option8为 ")(option8: option8) +
          value;
    } else {
      return option8;
    }
  }

  static String? _getOpUserNick(V2TimGroupMemberInfo? opUser) {
    if(opUser == null){
      return "";
    }
    return TencentUtils.checkString(opUser.friendRemark) ??
        TencentUtils.checkString(opUser.nickName) ??
        TencentUtils.checkString(opUser.userID);
  }

  static String? _getMemberNickName(V2TimGroupMemberInfo e) {
    final friendRemark = e.friendRemark;
    final nameCard = e.nameCard;
    final nickName = e.nickName;
    final userID = e.userID;

    if (friendRemark != null && friendRemark != "") {
      return friendRemark;
    } else if (nameCard != null && nameCard != "") {
      return nameCard;
    } else if (nickName != null && nickName != "") {
      return nickName;
    } else {
      return userID;
    }
  }

  static Future<String> groupTipsMessageAbstract(
      V2TimGroupTipsElem groupTipsElem,
      List<V2TimGroupMemberFullInfo?> groupMemberList) async {
    String displayMessage;
    final operationType = groupTipsElem.type;
    final operationMember = groupTipsElem.opMember;
    final memberList = groupTipsElem.memberList;
    final opUserNickName = _getOpUserNick(operationMember);
    switch (operationType) {
      case GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_GROUP_INFO_CHANGE:
        final String? option7 = opUserNickName ?? "";
        final groupChangeInfoList = groupTipsElem.groupChangeInfoList ?? [];
        String changedInfoString = "";
        for (V2TimGroupChangeInfo? element in groupChangeInfoList) {
          final newText = await _getGroupChangeType(element!, groupMemberList);
          changedInfoString +=
              (changedInfoString.isEmpty ? "" : " / ") + newText;
        }
        if (changedInfoString.isEmpty) {
          changedInfoString = TIM_t("群资料");
        }
        displayMessage =
            TIM_t_para("{{option7}}修改", "$option7修改")(option7: option7) +
                changedInfoString;
        break;
      case GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_QUIT:
        final String? option6 = opUserNickName ?? "";
        displayMessage =
            TIM_t_para("{{option6}}退出群聊", "$option6退出群聊")(option6: option6);
        break;
      case GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_INVITE:
        final option5 =
        memberList!.map((e) => _getMemberNickName(e!).toString()).join("、");
        final inviteUser = _getOpUserNick(operationMember);
        displayMessage = '$inviteUser' +
            TIM_t_para("邀请{{option5}}加入群组", "邀请$option5加入群组")(option5: option5);
        break;
      case GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_KICKED:
        final option4 =
        memberList!.map((e) => _getMemberNickName(e!).toString()).join("、");
        final kickUser = _getOpUserNick(operationMember);
        displayMessage = '$kickUser' +
            TIM_t_para("将{{option4}}踢出群组", "将$option4踢出群组")(option4: option4);
        break;
      case GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_JOIN:
        final option3 =
        memberList!.map((e) => _getMemberNickName(e!).toString()).join("、");
        displayMessage = TIM_t_para("用户{{option3}}加入了群聊", "用户$option3加入了群聊")(
            option3: option3);
        break;
      case GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_MEMBER_INFO_CHANGE:
        displayMessage = groupTipsElem.memberList!.map((e) {
          final changedMember = groupTipsElem.memberChangeInfoList!
              .firstWhere((element) => element!.userID == e!.userID);
          final isMute = changedMember!.muteTime != 0;
          final option2 = _getMemberNickName(e!);
          final displayMessage = isMute ? TIM_t("禁言") : TIM_t("解除禁言");
          return TIM_t_para("{{option2}} 被", "$option2 被")(option2: option2) +
              displayMessage;
        }).join("、");
        break;
      case GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_SET_ADMIN:
        final adminMember =
        memberList!.map((e) => _getMemberNickName(e!).toString()).join("、");
        final opMember = _getOpUserNick(operationMember);
        final option1 = adminMember;
        displayMessage = '$opMember' +
            TIM_t_para("将 {{option1}} 设置为管理员", "将 $option1 设置为管理员")(
                option1: option1);
        break;
      case GroupTipsElemType.V2TIM_GROUP_TIPS_TYPE_CANCEL_ADMIN:
        final adminMember =
        memberList!.map((e) => _getMemberNickName(e!).toString()).join("、");
        final opMember = _getOpUserNick(operationMember);
        final option1 = adminMember;
        displayMessage = '$opMember' +
            TIM_t_para("将 {{option1}} 取消管理员", "将 $option1 取消管理员")(
                option1: option1);
        break;
      default:
        final String option2 = operationType.toString();
        displayMessage =
            TIM_t_para("系统消息 {{option2}}", "系统消息 $option2")(option2: option2);
        break;
    }
    return displayMessage;
  }

  static String formatVideoTime(int time) {
    List<int> times = [];
    if (time <= 0) return '0:01';
    if (time >= TimeConst.DAY_SEC) return '1d+';
    for (int idx = 0; idx < TimeConst.SEC_SERIES.length; idx++) {
      int sec = TimeConst.SEC_SERIES[idx];
      if (time >= sec) {
        times.add((time / sec).floor());
        time = time % sec;
      } else if (idx > 0) {
        times.add(0);
      }
    }
    times.add(time);
    String formatTime = times[0].toString();
    for (int idx = 1; idx < times.length; idx++) {
      if (times[idx] < 10) {
        formatTime += ':0${times[idx].toString()}';
      } else {
        formatTime += ':${times[idx].toString()}';
      }
    }
    return formatTime;
  }

  static String handleCustomMessageString(V2TimMessage message) {
    return TIM_t("消息");
  }

  static Widget wrapMessageTips(Widget child, TUITheme? theme) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10), child: child);
  }

  static String getAbstractMessageAsync(V2TimMessage message,
      List<V2TimGroupMemberFullInfo?> groupMemberList) {
    final msgType = message.elemType;
    switch (msgType) {
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return handleCustomMessageString(message);
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return TIM_t("[语音]");
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return message.textElem!.text as String;
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return TIM_t("[表情]");
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        final String? option2 = message.fileElem!.fileName ?? "";
        return TIM_t_para("[文件] {{option2}}", "[文件] $option2")(
            option2: option2);
      case MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS:
        return TIM_t("群提示");
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return TIM_t("[图片]");
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        return TIM_t("[视频]");
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        return TIM_t("[位置]");
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        return TIM_t("[聊天记录]");
      default:
        return TIM_t("未知消息");
    }
  }

  static V2TimImage? getImageFromImgList(
      List<V2TimImage?>? list, List<String> order) {
    V2TimImage? img;
    try {
      for (String type in order) {
        img = list?.firstWhere(
                (e) =>
            e?.type == HistoryMessageDartConstant.V2_TIM_IMAGE_TYPES[type],
            orElse: () => null);
      }
    } catch (e) {
      outputLogger.i('getImageFromImgList error ${e.toString()}');
    }
    return img;
  }

  static String getDisplayName(V2TimMessage message) {
    final friendRemark = message.friendRemark ?? "";
    final nameCard = message.nameCard ?? "";
    final nickName = message.nickName ?? "";
    final sender = message.sender ?? "";
    final displayName = friendRemark.isNotEmpty
        ? friendRemark
        : nameCard.isNotEmpty
        ? nameCard
        : nickName.isNotEmpty
        ? nickName
        : sender;
    return displayName.toString();
  }

  static Future<V2TimValueCallback<V2TimMessage>?> handleMessageError(
      Future<V2TimValueCallback<V2TimMessage>?> fun,
      BuildContext context) async {
    final res = await fun;
    return handleMessageErrorCode(res, context);
  }

  static V2TimValueCallback<V2TimMessage>? handleMessageErrorCode(
      V2TimValueCallback<V2TimMessage>? sendMsgRes, BuildContext context) {
    if (sendMsgRes == null) return null;

    return sendMsgRes;
  }
}
