import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list_item.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/merger_message_screen.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'TIMUIKitMessageReaction/tim_uikit_message_reaction_show_panel.dart';

class TIMUIKitMergerElem extends StatefulWidget {
  final V2TimMergerElem mergerElem;
  final String messageID;
  final bool isSelf;
  final bool isShowJump;
  final VoidCallback? clearJump;
  final V2TimMessage message;
  final bool? isShowMessageReaction;
  final TUIChatSeparateViewModel model;
  final MessageItemBuilder? messageItemBuilder;

  const TIMUIKitMergerElem(
      {Key? key,
      required this.message,
      required this.model,
      required this.mergerElem,
      required this.isSelf,
      this.isShowMessageReaction,
      required this.messageID,
      required this.isShowJump,
      this.clearJump,
      this.messageItemBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TIMUIKitMergerElemState();
}

class TIMUIKitMergerElemState extends TIMUIKitState<TIMUIKitMergerElem> {
  bool isShowJumpState = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  _showJumpColor() {
    int shineAmount = 6;
    setState(() {
      isShowJumpState = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (widget.clearJump != null) {
        widget.clearJump!();
      }
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          isShowJumpState = shineAmount.isOdd ? true : false;
        });
      }
      if (shineAmount == 0 || !mounted) {
        timer.cancel();
      }
      shineAmount--;
    });
  }

  _handleTap(BuildContext context, TUIChatSeparateViewModel model) async {
    try {
      if (widget.messageID != "") {
        final isDesktopScreen =
            TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

        if (isDesktopScreen) {
          TUIKitWidePopup.showPopupWindow(
            operationKey: TUIKitWideModalOperationKey.mergerMessageList,
            context: context,
            width: MediaQuery.of(context).size.width * 0.7,
            title: TIM_t("聊天记录"),
            height: MediaQuery.of(context).size.height * 0.7,
            child: (onClose) => Scrollbar(
              controller: _scrollController,
              child: MergerMessageScreen(
                  messageItemBuilder: widget.messageItemBuilder,
                  model: model,
                  msgID: widget.messageID),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MergerMessageScreen(
                    messageItemBuilder: widget.messageItemBuilder,
                    model: model,
                    msgID: widget.messageID),
              ));
        }
      }
    } catch (e) {
      onTIMCallback(TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: TIM_t("无法定位到原消息"),
          infoCode: 6660401));
    }
  }

  List<String>? _getAbstractList() {
    final length = widget.mergerElem.abstractList!.length;
    if (length <= 4) {
      return widget.mergerElem.abstractList;
    }
    return widget.mergerElem.abstractList!.getRange(0, 4).toList();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    if (widget.isShowJump) {
      Future.delayed(Duration.zero, () {
        _showJumpColor();
      });
    }
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return Container(
      constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * (isDesktopScreen ? 0.3 : 0.6)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: widget.isSelf ? const Radius.circular(10) : Radius.zero,
          bottomLeft: const Radius.circular(10),
          topRight: widget.isSelf ? Radius.zero : const Radius.circular(10),
          bottomRight: const Radius.circular(10),
        ),
        border: Border.all(
          color: isShowJumpState
              ? const Color.fromRGBO(245, 166, 35, 1)
              : (theme.weakDividerColor ?? CommonColor.weakDividerColor),
          width: 1,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          _handleTap(context, widget.model);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.mergerElem.title!,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              // const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _getAbstractList()!
                    .map(
                      (e) => Row(
                        children: [
                          Expanded(
                            child: Text(
                              e,
                              textAlign: TextAlign.left,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: theme.weakTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(
                height: 4,
              ),
              const Divider(),
              Text(
                TIM_t("聊天记录"),
                style: TextStyle(
                  color: theme.weakTextColor,
                  fontSize: 10,
                ),
              ),
              if (widget.isShowMessageReaction ?? true)
                TIMUIKitMessageReactionShowPanel(message: widget.message)
            ],
          ),
        ),
      ),
    );
  }
}
