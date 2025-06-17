import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_user_profile_options.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item_builders.dart';

class TencentCloudChatMessageRow extends StatefulWidget {
  final MessageRowBuilderData data;
  final MessageRowBuilderMethods methods;
  final MessageRowBuilderWidgets widgets;

  const TencentCloudChatMessageRow({
    super.key,
    required this.widgets,
    required this.data,
    required this.methods,
  });

  @override
  State<TencentCloudChatMessageRow> createState() =>
      _TencentCloudChatMessageRowState();
}

class _TencentCloudChatMessageRowState
    extends TencentCloudChatState<TencentCloudChatMessageRow> {
  late V2TimMessage _message;

  @override
  void initState() {
    super.initState();
    _message = widget.data.message;
  }

  @override
  void didUpdateWidget(covariant TencentCloudChatMessageRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_message != widget.data.message &&
        widget.data.message != oldWidget.data.message) {
      _message = widget.data.message;
    }
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    late Map<String, dynamic> cloudCustomData;
    try {
      cloudCustomData = json.decode((TencentCloudChatUtils.checkString(widget.data.message.cloudCustomData) != null) ? widget.data.message.cloudCustomData! : "{}");
    } catch (_) {
      cloudCustomData = {};
    }
    if (cloudCustomData["deleteForEveryone"] == true) {
      return Container();
    }

    final tipsItem = widget.data.message.elemType == 101 || widget.data.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS;
    final isRecalled = widget.data.message.status == MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED;
    final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        margin: EdgeInsets.only(
          bottom: getSquareSize(16),
        ),
        padding: EdgeInsets.only(right: isDesktopScreen ? getSquareSize(8) : 0, left: isDesktopScreen ? getSquareSize(8) : 0),
        color: (widget.data.isSelected && widget.data.inSelectMode) ? colorTheme.messageBeenChosenBackgroundColor : Colors.transparent,
        child: (tipsItem || isRecalled)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [widget.widgets.messageRowTips ?? Container()],
              )
            : GestureDetector(
                onTap: widget.data.inSelectMode
                    ? () {
                        widget.methods.onSelectCurrent(_message);
                      }
                    : null,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Row(
                        crossAxisAlignment: widget.data.showMessageSenderName ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        mainAxisAlignment: (widget.data.message.isSelf ?? true) ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if ((!(widget.data.message.isSelf ?? true)) &&
                              widget.data.showOthersAvatar)
                            GestureDetector(
                              onTap: TencentCloudChatUtils.checkString(widget.data.message.sender) != null
                                  ? () => navigateToUserProfile(context: context, options: TencentCloudChatUserProfileOptions(userID: widget.data.message.sender!))
                                  : null,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: getSquareSize(10)),
                                child: widget.widgets.messageRowAvatar,
                              ),
                            ),
                          Column(
                            crossAxisAlignment: (widget.data.message.isSelf ?? true) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              if (widget.data.showMessageSenderName) widget.widgets.messageRowMessageSenderName,
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        widget.data.messageRowWidth * 0.8),
                                child: widget.widgets.messageRowMessageItem ??
                                    Container(),
                              ),
                              if (widget.widgets.messageTextTranslateItem != null) ...[
                                const SizedBox(
                                  height: 4,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: min(widget.data.messageRowWidth * 0.8 * 0.9, widget.data.messageRowWidth * 0.8 - getSquareSize((_message.isSelf ?? false) ? 128 : 102))),
                                  child: widget.widgets.messageTextTranslateItem ?? Container(),
                                )
                              ],
                              if (widget.widgets.messageSoundToTextItem != null) ...[
                                const SizedBox(
                                  height: 4,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: min(widget.data.messageRowWidth * 0.8 * 0.9, widget.data.messageRowWidth * 0.8 - getSquareSize((_message.isSelf ?? false) ? 128 : 102))),
                                  child: widget.widgets.messageSoundToTextItem ?? Container(),
                                )
                              ],
                            ],
                          ),
                          if ((widget.data.message.isSelf ?? true) &&
                              widget.data.showSelfAvatar)
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: getSquareSize(10)),
                              child: widget.widgets.messageRowAvatar,
                            ),
                          if ((widget.data.message.isSelf ?? true) &&
                              !widget.data.showSelfAvatar)
                            const SizedBox(
                              width: 10,
                            ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    late Map<String, dynamic> cloudCustomData;
    try {
      cloudCustomData = json.decode((TencentCloudChatUtils.checkString(widget.data.message.cloudCustomData) != null) ? widget.data.message.cloudCustomData! : "{}");
    } catch (_) {
      cloudCustomData = {};
    }
    if (cloudCustomData["deleteForEveryone"] == true) {
      return Container();
    }

    if (widget.data.message.elemType ==
        MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
      if (widget.data.message.customElem != null) {
        if (widget.data.message.customElem!.data != null) {
          String? data = widget.data.message.customElem!.data!;
          try {
            Map<String, dynamic> jsonData = json.decode(data);
            var isCustomerServicePlugin =
                jsonData["customerServicePlugin"] ?? "";
            if (isCustomerServicePlugin == 0) {
              List<String> srcWhiteList = [
                '9',
              ];
              if (srcWhiteList.contains(jsonData["src"]) &&
                  widget.widgets.messageRowMessageItem != null) {
                return widget.widgets.messageRowMessageItem!;
              }
            }
          } catch (err) {
            return Container();
          }
        }
      }
    }

    final bool isUseTipsBuilder = TencentCloudChatMessageItemBuilders.isShowTipsMessage(_message);

    final avatarWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: getSquareSize(10)),
      child: widget.widgets.messageRowAvatar,
    );

    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        margin: EdgeInsets.only(
          bottom: getSquareSize(16),
        ),
        padding: EdgeInsets.only(right: getSquareSize(6), left: getSquareSize(6)),
        child: (isUseTipsBuilder)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  widget.widgets.messageRowTips ?? Container(),
                ],
              )
            : GestureDetector(
                onTap: widget.data.inSelectMode // tap row
                    ? () {
                        widget.methods.onSelectCurrent(_message);
                      }
                    : null,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Offstage(
                        offstage: !widget.data.inSelectMode,
                        child: Checkbox(
                          value: widget.data.isSelected,
                          visualDensity:
                              const VisualDensity(vertical: -4, horizontal: 0),
                          activeColor: colorTheme.primaryColor,
                          checkColor: colorTheme.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          onChanged: (bool? value) { // tap checkbox
                            widget.methods.onSelectCurrent(_message);
                          },
                        ),
                      ),
                      Expanded(
                          child: Row(
                            crossAxisAlignment: widget.data.showMessageSenderName ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                            mainAxisAlignment: (widget.data.message.isSelf ?? true) ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              if ((widget.data.message.isSelf ?? true) || (!(widget.data.message.isSelf ?? true)) && widget.data.showOthersAvatar)
                                Opacity(
                                  opacity: ((!(widget.data.message.isSelf ?? true)) && widget.data.showOthersAvatar) ? 1 : 0,
                                  child: avatarWidget,
                                ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: (widget.data.message.isSelf ?? true) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      if (widget.data.showMessageSenderName) widget.widgets.messageRowMessageSenderName,
                                      widget.widgets.messageRowMessageItem ?? Container(),
                                      if (widget.widgets.messageTextTranslateItem != null) ...[
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        widget.widgets.messageTextTranslateItem ?? Container()
                                      ],
                                      if (widget.widgets.messageSoundToTextItem != null) ...[
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        widget.widgets.messageSoundToTextItem ?? Container()
                                      ],
                                    ],
                                  )),
                              if (!(widget.data.message.isSelf ?? true) || ((widget.data.message.isSelf ?? true) && widget.data.showSelfAvatar))
                                Opacity(
                                  opacity: ((widget.data.message.isSelf ?? true) &&
                                          widget.data.showSelfAvatar)
                                      ? 1
                                      : 0,
                                  child: avatarWidget,
                                ),
                              if ((widget.data.message.isSelf ?? true) &&
                                  !widget.data.showSelfAvatar)
                                const SizedBox(
                                  width: 10,
                                ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
