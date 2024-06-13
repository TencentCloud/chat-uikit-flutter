import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_message_calling_message/tencent_cloud_chat_message_calling_message.dart';

class GroupCallMessageItem extends StatefulWidget {
  final V2TimMessage? customMessage;

  const GroupCallMessageItem({
    Key? key,
    this.customMessage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupCallMessageItemState();
}

class _GroupCallMessageItemState extends State<GroupCallMessageItem> {
  // 并不是所有的消息都需要展示
  /// check if the message would be shown
  /// not all message should be shown
  bool isShow = true;

  // CustomMessage最终展示的内容
  /// text be shown for custom messasge
  String customMessageShowText = "[自定义]";

  @override
  void initState() {
    super.initState();
    final customElem = widget.customMessage?.customElem;
    final groupId = widget.customMessage?.groupID;
    final callingMessage = CallingMessage.getCallMessage(customElem);
    getShowActionType(callingMessage!, groupId: groupId);
  }

  String getShowName(V2TimGroupMemberFullInfo info) {
    if (info.friendRemark != null && info.friendRemark!.isNotEmpty) {
      return info.friendRemark!;
    } else if (info.nickName != null && info.nickName!.isNotEmpty) {
      return info.nickName!;
    } else if (info.nameCard != null && info.nameCard!.isNotEmpty) {
      return info.nameCard!;
    } else {
      return info.userID;
    }
  }

  getShowNameListFromGroupList(List<String> inviteList, List<V2TimGroupMemberFullInfo?> groupInfoList) {
    final showNameList = [];
    for (var info in groupInfoList) {
      final isContains = inviteList.contains(info!.userID);
      if (isContains) {
        showNameList.add(getShowName(info));
      }
    }

    return showNameList;
  }

// 先更新为userID的封装
  /// This function get text of invitee user ID from inviteeList
  handleShowUserIDFromInviteList(List<String> inviteeList, String actionTypeText) {
    String nameStr = "";
    for (String showName in inviteeList) {
      nameStr = "$nameStr、$showName";
    }
    nameStr = nameStr.isNotEmpty ? nameStr.substring(1) : nameStr;
    setState(() {
      customMessageShowText = "$nameStr $actionTypeText";
    });
  }

  // 后更新showName的封装
  /// this function get text of user name from list
  handleShowNameStringFromList(List<dynamic> showNameList, String actionTypeText) {
    if (showNameList.isEmpty) {
      return;
    }
    if (mounted) {
      if (showNameList.length == 1) {
        setState(() {
          customMessageShowText = "${showNameList[0]} $actionTypeText";
        });
      } else {
        String nameStr = "";
        for (String showName in showNameList) {
          nameStr = "$nameStr、$showName";
        }
        nameStr = nameStr.substring(1);
        setState(() {
          customMessageShowText = "$nameStr $actionTypeText";
        });
      }
    }
  }

  // 封装需要节流获取情况用户成员的情况
  /// this function encapsulates the situation where user members need to be throttled to obtain the status
  handleThrottleGetShowName(String groupId, String actionTypeText, CallingMessage callingMessage) {
    handleShowUserIDFromInviteList(callingMessage.inviteeList!, actionTypeText);
  }

  getShowActionType(CallingMessage callingMessage, {String? groupId}) async {
    final isEnd = CallingMessage.isGroupCallEndExist(callingMessage);
    if (isEnd && !widget.customMessage!.isSelf!) {
      isShow = true;
      customMessageShowText = "通话结束";
      return;
    }

    isShow = CallingMessage.isShowInGroup(callingMessage);
    if (!isShow) {
      return;
    }

    final actionType = callingMessage.actionType!;
    final actionTypeText = CallingMessage.getActionType(callingMessage);
    // 1发起通话
    if (actionType == 1 && groupId != null) {
      String nameStr = "";
      var infoList = TencentCloudChat.instance.cache
          .getGroupMemberInfoFromCache(groupID: groupId, members: [callingMessage.inviter!]);
      // TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupMembersInfo(groupID: groupId, memberList: [callingMessage.inviter!]).then((V2TimValueCallback<List<V2TimGroupMemberFullInfo>> res) {
      //   List<V2TimGroupMemberFullInfo>? infoList = res.data ?? [];

      // });
      for (var element in infoList) {
        final showName = getShowName(element);
        nameStr = "$nameStr$showName";
      }
      setState(() {
        customMessageShowText = "$nameStr $actionTypeText";
      });
    }
    // 2取消通话
    if (actionType == 2 && groupId != null) {
      setState(() {
        customMessageShowText = actionTypeText;
      });
    }
    // 3为接受
    if (actionType == 3 && groupId != null) {
      List<String> inviteeShowNameList = [];

      var infos = TencentCloudChat.instance.cache
          .getGroupMemberInfoFromCache(groupID: groupId, members: callingMessage.inviteeList ?? []);
      for (var element in infos) {
        inviteeShowNameList.add(getShowName(element));
      }
      callingMessage.inviteeList = inviteeShowNameList;
      handleThrottleGetShowName(groupId, actionTypeText, callingMessage);
    }
    // 4为拒绝
    if (actionType == 4 && groupId != null) {
      List<String> inviteeShowNameList = [];

      var infos = TencentCloudChat.instance.cache
          .getGroupMemberInfoFromCache(groupID: groupId, members: callingMessage.inviteeList ?? []);
      for (var element in infos) {
        inviteeShowNameList.add(getShowName(element));
      }
      callingMessage.inviteeList = inviteeShowNameList;
      handleThrottleGetShowName(groupId, actionTypeText, callingMessage);
    }
    // 5 为超时
    if (actionType == 5 && groupId != null) {
      String nameStr = "";

      var infos = TencentCloudChat.instance.cache
          .getGroupMemberInfoFromCache(groupID: groupId, members: callingMessage.inviteeList ?? []);
      for (var element in infos) {
        final showName = getShowName(element);
        nameStr = "$nameStr、$showName";
      }
      nameStr = nameStr.substring(1);

      setState(() {
        customMessageShowText = "$nameStr $actionTypeText";
      });
    }

    // return TIMUIKitCustomElem.getActionType(actionType);
  }

  static isCallEndExist(CallingMessage callMsg) {
    int? callEnd = callMsg.callEnd;
    int? actionType = callMsg.actionType;
    if (actionType == 2) return false;
    return callEnd == null
        ? false
        : callEnd > 0
            ? true
            : false;
  }

  Widget _callElemBuilder(BuildContext context) {
    final customElem = widget.customMessage?.customElem;
    final callingMessage = CallingMessage.getCallMessage(customElem);
    String showText = "[自定义]";
    if (callingMessage != null) {
      // 如果是结束消息
      final isCallEnd = isCallEndExist(callingMessage);

      String? option2 = "";
      if (isCallEnd) {
        option2 = CallingMessage.getShowTime(callingMessage.callEnd!);
      }
      showText = isCallEnd ? "通话时间：$option2" : customMessageShowText;

      return Text(
        showText,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0XFF888888)),
        textAlign: TextAlign.center,
        softWrap: true,
      );
    } else {
      return Text(showText);
    }
  }

  Widget wrapMessageTips(Widget child) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 10), child: child);
  }

  @override
  Widget build(BuildContext context) {
    return isShow ? wrapMessageTips(_callElemBuilder(context)) : const SizedBox();
  }
}
