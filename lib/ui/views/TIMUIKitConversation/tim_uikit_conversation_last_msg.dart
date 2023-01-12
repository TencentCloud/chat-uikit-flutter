// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class TIMUIKitLastMsg extends StatefulWidget {
  final V2TimMessage? lastMsg;
  final List<V2TimGroupAtInfo?> groupAtInfoList;
  final BuildContext context;

  const TIMUIKitLastMsg(
      {Key? key,
      this.lastMsg,
      required this.groupAtInfoList,
      required this.context})
      : super(key: key);

  @override
  State<TIMUIKitLastMsg> createState() => _TIMUIKitLastMsgState();
}

class _TIMUIKitLastMsgState extends TIMUIKitState<TIMUIKitLastMsg> {
  String groupTipsAbstractText = "";

  @override
  void initState() {
    super.initState();
    _getMsgElem();
  }

  @override
  void didUpdateWidget(covariant TIMUIKitLastMsg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.lastMsg?.msgID != widget.lastMsg?.msgID) ||
        (oldWidget.lastMsg?.id != widget.lastMsg?.id)) {
      _getMsgElem();
    }
  }

  void _getMsgElem() async {
    final isRevokedMessage = widget.lastMsg!.status == 6;
    if (isRevokedMessage) {
      final isSelf = widget.lastMsg!.isSelf ?? false;
      final option1 = isSelf
          ? TIM_t("您")
          : widget.lastMsg!.nickName ?? widget.lastMsg?.sender;
      setState(() {
        groupTipsAbstractText = TIM_t_para(
            "{{option1}}撤回了一条消息", "$option1撤回了一条消息")(option1: option1);
      });
    } else {
      final newText = await _getLastMsgShowText(widget.lastMsg, widget.context);
      setState(() {
        groupTipsAbstractText = newText;
      });
    }
  }

  Future<String> _getLastMsgShowText(
      V2TimMessage? message, BuildContext context) async {
    final msgType = message!.elemType;
    switch (msgType) {
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return TIM_t("[自定义]");
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return TIM_t("[语音]");
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return widget.lastMsg?.textElem?.text ?? "";
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return TIM_t("[表情]");
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        final option1 = widget.lastMsg!.fileElem!.fileName;
        return TIM_t_para("[文件] {{option1}}", "[文件] $option1")(
            option1: option1);
      case MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS:
        return await MessageUtils.groupTipsMessageAbstract(
            widget.lastMsg!.groupTipsElem!, []);
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

  Icon? _getIconByMsgStatus(BuildContext context) {
    final msgStatus = widget.lastMsg!.status;
    final theme = Provider.of<TUIThemeViewModel>(context).theme;
    if (msgStatus == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL) {
      return Icon(Icons.error, color: theme.cautionColor, size: 16);
    }
    if (msgStatus == MessageStatus.V2TIM_MSG_STATUS_SENDING) {
      return Icon(Icons.arrow_back, color: theme.weakTextColor, size: 16);
    }
    return null;
  }

  String _getAtMessage() {
    String msg = "";
    for (var item in widget.groupAtInfoList) {
      if (item!.atType == 1) {
        msg = TIM_t("[有人@我] ");
      } else {
        msg = TIM_t("[@所有人] ");
      }
    }
    return msg;
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final icon = _getIconByMsgStatus(context);
    return Row(children: [
      if (icon != null)
        Container(
          margin: const EdgeInsets.only(right: 2),
          child: icon,
        ),
      if (widget.groupAtInfoList.isNotEmpty)
        Text(_getAtMessage(),
            style: TextStyle(color: theme.cautionColor, fontSize: 14)),
      Expanded(
          child: Text(
        groupTipsAbstractText,
        softWrap: true,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(height: 1, color: theme.weakTextColor, fontSize: 14),
      )),
    ]);
  }
}
