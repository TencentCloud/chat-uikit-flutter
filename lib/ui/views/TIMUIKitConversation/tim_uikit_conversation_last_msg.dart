// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_at_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_at_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/common_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme_view_model.dart';

class TIMUIKitLastMsg extends StatefulWidget {
  final V2TimMessage? lastMsg;
  final List<V2TimGroupAtInfo?> groupAtInfoList;
  final BuildContext context;
  final double fontSize;
  bool isDisturb;
  int unreadCount;
  String draftText;

  TIMUIKitLastMsg(
      {Key? key,
      this.lastMsg,
      required this.groupAtInfoList,
      this.isDisturb = false,
      this.unreadCount = 0,
      required this.draftText,
      required this.context,
      this.fontSize = 14.0})
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
        (oldWidget.lastMsg?.id != widget.lastMsg?.id) ||
        (oldWidget.lastMsg?.status != widget.lastMsg?.status) ||
        (oldWidget.unreadCount != widget.unreadCount)) {
      _getMsgElem();
    }
  }

  (bool isRevoke, bool isRevokeByAdmin) isRevokeMessage(V2TimMessage? message) {
    if (message == null) {
      return (false, false);
    }
    if (message.status == 6) {
      return (true, false);
    } else {
      try {
        final customData = jsonDecode(message.cloudCustomData ?? "{}");
        final isRevoke = customData["isRevoke"] ?? false;
        final revokeByAdmin = customData["revokeByAdmin"] ?? false;
        return (isRevoke, revokeByAdmin);
      } catch (e) {
        return (false, false);
      }
    }
  }

  void _getMsgElem() async {
    final revokeStatus = isRevokeMessage(widget.lastMsg);
    final isRevokedMessage = revokeStatus.$1;
    final isAdminRevoke = revokeStatus.$2;
    if (isRevokedMessage) {
      final isSelf = widget.lastMsg!.isSelf ?? true;
      final option1 =
          isAdminRevoke ? TIM_t("管理员") : (isSelf ? TIM_t("您") : widget.lastMsg!.nickName ?? widget.lastMsg?.sender);
      if (mounted) {
        setState(() {
          groupTipsAbstractText = TIM_t_para("{{option1}}撤回了一条消息", "$option1撤回了一条消息")(option1: option1);
        });
      }
    } else {
      String msgShowText = await _getLastMsgShowText(widget.lastMsg, widget.context) ?? "";
      if (mounted) {
        setState(() {
          groupTipsAbstractText = msgShowText;
        });
      }
    }
  }

  String _getDisturbUnreadCountInfo() {
    if (widget.isDisturb && widget.unreadCount > 0) {
      final option1 = widget.unreadCount.toString();
      String unreadCountText = TIM_t_para("[{{option1}} 条]", "[$option1 条]")(option1: option1);
      return unreadCountText;
    }

    return "";
  }

  Future<String?> _getLastMsgShowText(V2TimMessage? message, BuildContext context) async {
    final msgType = message!.elemType;
    switch (msgType) {
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return TIM_t("[自定义]");
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return TIM_t("[语音]");
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return (widget.lastMsg?.textElem?.text)?.trim() ?? "";
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return TIM_t("[表情]");
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        final option1 = widget.lastMsg!.fileElem!.fileName;
        return TIM_t_para("[文件] {{option1}}", "[文件] $option1")(option1: option1);
      case MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS:
        return await MessageUtils.groupTipsMessageAbstract(widget.lastMsg!.groupTipsElem!, []);
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return TIM_t("[图片]");
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        return TIM_t("[视频]");
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        return TIM_t("[位置]");
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        return TIM_t("[聊天记录]");
      default:
        return null;
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
    bool atMe = false;
    bool atAll = false;
    String msg = "";
    for (var item in widget.groupAtInfoList) {
      if (item!.atType == 1) {
        atMe = true;
        continue;
      } else if (item!.atType == 2) {
        atAll = true;
        continue;
      } else if (item!.atType == 3) {
        atMe = true;
        atAll = true;
        continue;
      }
    }

    if (atAll && atMe) {
      msg = TIM_t("[@所有人][有人@我]");
    } else if (atAll) {
      msg = TIM_t("[@所有人]");
    } else if (atMe) {
      msg = TIM_t("[有人@我]");
    }

    return msg;
  }

  String _getDraftShowText() {
    final draftShowText = TIM_t("草稿");
    return '[$draftShowText]';
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final TUITheme theme = value.theme;
    final icon = _getIconByMsgStatus(context);
    String disturbUnreadCountInfo = _getDisturbUnreadCountInfo();
    return Row(children: [
      if (icon != null)
        Container(
          margin: const EdgeInsets.only(right: 2),
          child: icon,
        ),
      if (widget.groupAtInfoList.isNotEmpty)
        Text(_getAtMessage(), style: TextStyle(color: theme.cautionColor, fontSize: widget.fontSize)),
      if (widget.draftText != null && widget.draftText != "")
        Text(_getDraftShowText(),
            style: TextStyle(color: theme.conversationItemDraftTextColor, fontSize: widget.fontSize)),
      if (disturbUnreadCountInfo != "")
        Text(disturbUnreadCountInfo, style: TextStyle(color: theme.weakTextColor, fontSize: widget.fontSize)),
      if (widget.draftText != null && widget.draftText != "")
        Expanded(
          child: ExtendedText(groupTipsAbstractText,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(height: 1, color: theme.weakTextColor, fontSize: widget.fontSize),
              specialTextSpanBuilder: DefaultSpecialTextSpanBuilder(
                isUseQQPackage: true,
                isUseTencentCloudChatPackage: true,
                showAtBackground: true,
              )),
        ),
      if (widget.draftText == null || widget.draftText == "" && TencentUtils.checkString(groupTipsAbstractText) != null)
        Expanded(
          child: ExtendedText(groupTipsAbstractText,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(height: 1, color: theme.weakTextColor, fontSize: widget.fontSize),
              specialTextSpanBuilder: DefaultSpecialTextSpanBuilder(
                isUseQQPackage: true,
                isUseTencentCloudChatPackage: true,
                showAtBackground: true,
              )),
        )
    ]);
  }
}
