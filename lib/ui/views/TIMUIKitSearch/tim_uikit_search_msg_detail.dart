import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/time_ago.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_input.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_item.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_search_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_showAll.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/tim_uikit_search_not_support.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';

class TIMUIKitSearchMsgDetail extends StatefulWidget {
  /// Conversation need search
  final V2TimConversation currentConversation;

  /// initial keyword
  final String keyword;

  final List<V2TimMessage>? initMessageList;

  /// the callback after clicking each conversation message item
  final Function(V2TimConversation, V2TimMessage?) onTapConversation;

  final bool? isAutoFocus;

  const TIMUIKitSearchMsgDetail(
      {Key? key,
      this.isAutoFocus = true,
      required this.currentConversation,
      required this.keyword,
      required this.onTapConversation,
      this.initMessageList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TIMUIKitSearchMsgDetailState();
}

class TIMUIKitSearchMsgDetailState
    extends TIMUIKitState<TIMUIKitSearchMsgDetail> {
  final model = serviceLocator<TUISearchViewModel>();
  String keywordState = "";
  int currentPage = 0;
  final FocusNode focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    keywordState = widget.keyword;
    updateMsgResult(widget.keyword, true);
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

  String _getMsgElem(V2TimMessage message) {
    final msgType = message.elemType;
    final revokeStatus = isRevokeMessage(message);
    final isRevokedMessage = revokeStatus.$1;
    final isAdminRevoke = revokeStatus.$2;
    if (isRevokedMessage) {
      final isSelf = message.isSelf ?? true;
      final option2 = isAdminRevoke
          ? TIM_t("管理员")
          : (isSelf ? TIM_t("您") : message.nickName ?? message.sender);
      return TIM_t_para("{{option2}}撤回了一条消息", "$option2撤回了一条消息")(
          option2: option2);
    }
    switch (msgType) {
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return TIM_t("[自定义]");
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return TIM_t("[语音]");
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return message.textElem!.text as String;
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return TIM_t("[表情]");
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        final option1 = message.fileElem!.fileName;
        return TIM_t_para("[文件] {{option1}}", "[文件] $option1")(
            option1: option1);
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

  List<Widget> _renderListMessage(
      List<V2TimMessage> msgList, BuildContext context, bool isDesktopScreen) {
    List<Widget> listWidget = [];

    listWidget = msgList.map((message) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: TIMUIKitSearchItem(
          faceUrl: message.faceUrl ?? "",
          showName: TencentUtils.checkString(message.nickName) ??
              TencentUtils.checkString(message.userID) ??
              message.sender ??
              "",
          lineOne: TencentUtils.checkString(message.nickName) ??
              TencentUtils.checkString(message.userID) ??
              message.sender ??
              "",
          lineOneRight: (isDesktopScreen && message.timestamp != null)
              ? TimeAgo().getTimeForMessage(message.timestamp!)
              : null,
          lineTwo: _getMsgElem(message),
          onClick: () {
            focusNode.unfocus();
            widget.onTapConversation(widget.currentConversation, message);
          },
        ),
      );
    }).toList();
    return listWidget;
  }

  updateMsgResult(String? keyword, bool isNewSearch) {
    if (isNewSearch) {
      setState(() {
        currentPage = 0;
        keywordState = keyword!;
      });
    }
    model.getMsgForConversation(keyword ?? keywordState,
        widget.currentConversation.conversationID, currentPage);
    setState(() {
      currentPage = currentPage + 1;
    });
  }

  Widget _renderShowALl(bool isShowMore) {
    return (isShowMore == true)
        ? Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TIMUIKitSearchShowALl(
              textShow: TIM_t("更多聊天记录"),
              onClick: () => {updateMsgResult(null, false)},
            ),
          )
        : Container();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    if (PlatformUtils().isWeb) {
      return TIMUIKitSearchNotSupport();
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: serviceLocator<TUISearchViewModel>())
      ],
      builder: (context, w) {
        final isDesktopScreen =
            TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

        List<V2TimMessage> currentMsgListForConversation =
            Provider.of<TUISearchViewModel>(context)
                .currentMsgListForConversation;
        final currentText = _controller.text;
        if (currentMsgListForConversation.isEmpty &&
            widget.initMessageList != null &&
            widget.initMessageList!.isNotEmpty &&
            currentText.isEmpty) {
          currentMsgListForConversation = widget.initMessageList!;
        }

        final int totalMsgInConversationCount =
            Provider.of<TUISearchViewModel>(context)
                .totalMsgInConversationCount;
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktopScreen)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      SizedBox(
                        child: Avatar(
                            faceUrl: widget.currentConversation.faceUrl ?? "",
                            showName: ""),
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.currentConversation.showName ??
                            widget.currentConversation.userID ??
                            "",
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.darkTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              TIMUIKitSearchInput(
                focusNode: focusNode,
                controller: _controller,
                isAutoFocus: widget.isAutoFocus,
                onChange: (String value) {
                  updateMsgResult(value, true);
                },
                initValue: widget.keyword,
                prefixIcon: Icon(
                  Icons.search,
                  size: 16,
                  color: hexToColor("979797"),
                ),
              ),
              Expanded(
                  child: Scrollbar(
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  children: [
                    ..._renderListMessage(currentMsgListForConversation,
                        context, isDesktopScreen),
                    _renderShowALl(keywordState.isNotEmpty &&
                        totalMsgInConversationCount >
                            currentMsgListForConversation.length)
                  ],
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}
