import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_options/tencent_cloud_chat_user_profile_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_message/data/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/menu/tencent_cloud_chat_message_item_with_menu_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item_container.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_reply_view.dart';

class TencentCloudChatMessageRow extends StatefulWidget {
  final V2TimMessage message;

  /// The width of the message row, which represents the available width
  /// for displaying the message on the screen. This is useful for
  /// automatically wrapping text messages in a message bubble.
  final double messageRowWidth;

  final String? userID;
  final String? groupID;

  final bool inSelectMode;
  final bool isSelected;
  final ValueChanged<V2TimMessage> onSelectCurrent;
  final SendingMessageData? sendingMessageData;
  final bool isMergeMessage;
  final Future<bool> Function({
    required bool highLightTargetMessage,
    V2TimMessage? message,
    int? timeStamp,
    int? seq,
  }) loadToSpecificMessage;
  final bool showMessageStatusIndicator;
  final bool showMessageTimeIndicator;
  final bool showSelfAvatar;
  final bool showOthersAvatar;

  const TencentCloudChatMessageRow({
    super.key,
    required this.message,
    required this.messageRowWidth,
    required this.inSelectMode,
    required this.isSelected,
    required this.onSelectCurrent,
    this.sendingMessageData,
    required this.isMergeMessage,
    required this.loadToSpecificMessage,
    required this.userID,
    required this.groupID,
    required this.showMessageStatusIndicator,
    required this.showMessageTimeIndicator,
    required this.showSelfAvatar,
    required this.showOthersAvatar,
  });

  @override
  State<TencentCloudChatMessageRow> createState() => _TencentCloudChatMessageRowState();
}

class _TencentCloudChatMessageRowState extends TencentCloudChatState<TencentCloudChatMessageRow> {
  late V2TimMessage _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
  }

  @override
  void didUpdateWidget(covariant TencentCloudChatMessageRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_message != widget.message && widget.message != oldWidget.message) {
      safeSetState(() {
        _message = widget.message;
      });
    }
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    final cloudCustomData = jsonDecode((TencentCloudChatUtils.checkString(widget.message.cloudCustomData) != null) ? widget.message.cloudCustomData! : "{}");
    if (cloudCustomData["deleteForEveryone"] == true) {
      return Container();
    }
    final tipsItem = widget.message.elemType == 101 || widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS;
    final isRecalled = widget.message.status == MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED;

    final messageReply = TencentCloudChatUtils.parseMessageReply(TencentCloudChatUtils.checkString(widget.message.cloudCustomData));
    final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;

    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        padding: EdgeInsets.symmetric(vertical: getSquareSize(6), horizontal: isDesktopScreen ? getSquareSize(8) : 0),
        color: (widget.isSelected && widget.inSelectMode) ? colorTheme.messageBeenChosenBackgroundColor : Colors.transparent,
        child: (tipsItem || isRecalled)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TencentCloudChatMessageItemContainer(
                    message: widget.message,
                    messageRowWidth: widget.messageRowWidth,
                    isMergeMessage: widget.isMergeMessage,
                    messageBuilder: (
                      ctx,
                      bool shouldBeHighlighted,
                      void Function() clearHighlightFunc,
                      V2TimMessageReceipt? messageReceipt,
                      String? text,
                      SendingMessageData? sendingMessageData,
                    ) {
                      return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.tencentCloudChatMessageItemBuilders.getMessageTipsBuilder(
                                message: widget.message,
                                text: text ?? "",
                              ) ??
                          Container();
                    },
                  )
                ],
              )
            : GestureDetector(
                onTap: widget.inSelectMode
                    ? () {
                        widget.onSelectCurrent(_message);
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: (widget.message.isSelf ?? true) ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if ((!(widget.message.isSelf ?? true)) && widget.showOthersAvatar)
                            GestureDetector(
                              onTap: TencentCloudChatUtils.checkString(widget.message.sender) != null ? () => navigateToUserProfile(context: context, options: TencentCloudChatUserProfileOptions(userID: widget.message.sender!)) : null,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: getSquareSize(10)),
                                child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                                  scene: TencentCloudChatAvatarScene.messageListForOthers,
                                  imageList: [widget.message.faceUrl ?? ""],
                                  width: getSquareSize(36),
                                  height: getSquareSize(36),
                                  borderRadius: getSquareSize(18),
                                ),
                              ),
                            ),
                          Column(
                            crossAxisAlignment: (widget.message.isSelf ?? true) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              TencentCloudChatMessageItemWithMenuContainer(
                                isMergeMessage: widget.isMergeMessage,
                                messageItem: ({required bool renderOnMenuPreview}) => TencentCloudChatMessageItemContainer(
                                  message: widget.message,
                                  messageRowWidth: widget.messageRowWidth,
                                  isMergeMessage: widget.isMergeMessage,
                                  messageBuilder: (
                                    ctx,
                                    bool shouldBeHighlighted,
                                    void Function() clearHighlightFunc,
                                    V2TimMessageReceipt? messageReceipt,
                                    String? text,
                                    SendingMessageData? sendingMessageData,
                                  ) {
                                    if (sendingMessageData?.message != null) {
                                      _message = sendingMessageData!.message;
                                    }
                                    return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.tencentCloudChatMessageItemBuilders.getMessageItemBuilder(
                                              message: _message,
                                              userID: widget.userID,
                                              groupID: widget.groupID,
                                              renderOnMenuPreview: renderOnMenuPreview,
                                              inSelectMode: widget.inSelectMode,
                                              onSelectMessage: () => widget.onSelectCurrent(_message),
                                              shouldBeHighlighted: shouldBeHighlighted,
                                              showMessageStatusIndicator: widget.showMessageStatusIndicator,
                                              showMessageTimeIndicator: widget.showMessageTimeIndicator,
                                              clearHighlightFunc: clearHighlightFunc,
                                              messageReceipt: messageReceipt,
                                              messageRowWidth: widget.messageRowWidth,
                                              sendingMessageData: sendingMessageData,
                                              isMergeMessage: widget.isMergeMessage,
                                            ) ??
                                        Container();
                                  },
                                ),
                                useMessageReaction: true,
                                message: widget.message,
                              ),
                              if (TencentCloudChatUtils.checkString(messageReply.messageID) != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TencentCloudChatMessageReplyView(
                                      messageSender: messageReply.messageSender,
                                      messageAbstract: messageReply.messageAbstract,
                                      messageID: messageReply.messageID!,
                                      messageSeq: messageReply.messageSeq,
                                      messageTimestamp: messageReply.messageTimestamp,
                                      onTriggerNavigation: () async {
                                        final res = await widget.loadToSpecificMessage(
                                            highLightTargetMessage: true,
                                            message: V2TimMessage(
                                              msgID: messageReply.messageID,
                                              elemType: 0,
                                              timestamp: messageReply.messageTimestamp,
                                              seq: messageReply.messageSeq?.toString(),
                                            ));
                                        if (!res) {
                                          TencentCloudChat.instance.callbacks?.onUserNotificationEvent?.call(
                                            TencentCloudChatComponentsEnum.message,
                                            TencentCloudChatCodeInfo.originalMessageNotFound,
                                          );
                                        }
                                      },
                                    )
                                  ],
                                )
                            ],
                          ),
                          if ((widget.message.isSelf ?? true) && widget.showSelfAvatar)
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: getSquareSize(10)),
                              child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                                scene: TencentCloudChatAvatarScene.messageListForSelf,
                                imageList: [widget.message.faceUrl ?? ""],
                                width: getSquareSize(36),
                                height: getSquareSize(36),
                                borderRadius: getSquareSize(18),
                              ),
                            ),
                          if ((widget.message.isSelf ?? true) && !widget.showSelfAvatar)
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
    final cloudCustomData = jsonDecode((TencentCloudChatUtils.checkString(widget.message.cloudCustomData) != null) ? widget.message.cloudCustomData! : "{}");
    if (cloudCustomData["deleteForEveryone"] == true) {
      return Container();
    }

    final tipsItem = widget.message.elemType == 101 || widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS;
    final isRecalled = widget.message.status == MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED;

    final messageReply = TencentCloudChatUtils.parseMessageReply(TencentCloudChatUtils.checkString(widget.message.cloudCustomData));

    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => AnimatedContainer(
        padding: EdgeInsets.symmetric(vertical: getSquareSize(6)),
        color: (widget.isSelected && widget.inSelectMode) ? colorTheme.messageBeenChosenBackgroundColor : Colors.transparent,
        duration: const Duration(milliseconds: 300),
        child: (tipsItem || isRecalled)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TencentCloudChatMessageItemContainer(
                    message: widget.message,
                    messageRowWidth: widget.messageRowWidth,
                    isMergeMessage: widget.isMergeMessage,
                    messageBuilder: (
                      ctx,
                      bool shouldBeHighlighted,
                      void Function() clearHighlightFunc,
                      V2TimMessageReceipt? messageReceipt,
                      String? text,
                      SendingMessageData? sendingMessageData,
                    ) {
                      return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.tencentCloudChatMessageItemBuilders.getMessageTipsBuilder(
                                message: widget.message,
                                text: text ?? "",
                              ) ??
                          Container();
                    },
                  )
                ],
              )
            : GestureDetector(
                onTap: widget.inSelectMode
                    ? () {
                        widget.onSelectCurrent(_message);
                      }
                    : null,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Offstage(
                        offstage: !widget.inSelectMode,
                        child: Checkbox(
                          value: widget.isSelected,
                          visualDensity: const VisualDensity(vertical: -4, horizontal: 0),
                          activeColor: colorTheme.primaryColor,
                          checkColor: colorTheme.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          onChanged: (bool? value) {
                            widget.onSelectCurrent(_message);
                          },
                        ),
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: (widget.message.isSelf ?? true) ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if ((!(widget.message.isSelf ?? true)) && widget.showOthersAvatar)
                            GestureDetector(
                              onTap: TencentCloudChatUtils.checkString(widget.message.sender) != null ? () => navigateToUserProfile(context: context, options: TencentCloudChatUserProfileOptions(userID: widget.message.sender!)) : null,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: getSquareSize(10)),
                                child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                                  scene: TencentCloudChatAvatarScene.messageListForOthers,
                                  imageList: [widget.message.faceUrl ?? ""],
                                  width: getSquareSize(36),
                                  height: getSquareSize(36),
                                  borderRadius: getSquareSize(18),
                                ),
                              ),
                            ),
                          Column(
                            crossAxisAlignment: (widget.message.isSelf ?? true) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              TencentCloudChatMessageItemWithMenuContainer(
                                isMergeMessage: widget.isMergeMessage,
                                messageItem: ({required bool renderOnMenuPreview}) => TencentCloudChatMessageItemContainer(
                                  message: widget.message,
                                  messageRowWidth: widget.messageRowWidth,
                                  isMergeMessage: widget.isMergeMessage,
                                  messageBuilder: (
                                    ctx,
                                    bool shouldBeHighlighted,
                                    void Function() clearHighlightFunc,
                                    V2TimMessageReceipt? messageReceipt,
                                    String? text,
                                    SendingMessageData? sendingMessageData,
                                  ) {
                                    if (sendingMessageData?.message != null) {
                                      _message = sendingMessageData!.message;
                                    }
                                    return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.tencentCloudChatMessageItemBuilders.getMessageItemBuilder(
                                              message: _message,
                                              renderOnMenuPreview: renderOnMenuPreview,
                                              userID: widget.userID,
                                              groupID: widget.groupID,
                                              inSelectMode: widget.inSelectMode,
                                              showMessageStatusIndicator: widget.showMessageStatusIndicator,
                                              showMessageTimeIndicator: widget.showMessageTimeIndicator,
                                              onSelectMessage: () => widget.onSelectCurrent(_message),
                                              shouldBeHighlighted: shouldBeHighlighted,
                                              clearHighlightFunc: clearHighlightFunc,
                                              messageReceipt: messageReceipt,
                                              messageRowWidth: widget.messageRowWidth,
                                              sendingMessageData: sendingMessageData,
                                              isMergeMessage: widget.isMergeMessage,
                                            ) ??
                                        Container();
                                  },
                                ),
                                useMessageReaction: true,
                                message: widget.message,
                              ),
                              if (TencentCloudChatUtils.checkString(messageReply.messageID) != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TencentCloudChatMessageReplyView(
                                      messageSender: messageReply.messageSender,
                                      messageAbstract: messageReply.messageAbstract,
                                      messageID: messageReply.messageID!,
                                      messageTimestamp: messageReply.messageTimestamp,
                                      messageSeq: messageReply.messageSeq,
                                      onTriggerNavigation: () async {
                                        final res = await widget.loadToSpecificMessage(
                                            highLightTargetMessage: true,
                                            message: V2TimMessage(
                                              msgID: messageReply.messageID,
                                              elemType: 0,
                                              timestamp: messageReply.messageTimestamp,
                                              seq: messageReply.messageSeq?.toString(),
                                            ));
                                        if (!res) {
                                          TencentCloudChat.instance.callbacks?.onUserNotificationEvent?.call(
                                            TencentCloudChatComponentsEnum.message,
                                            TencentCloudChatCodeInfo.originalMessageNotFound,
                                          );
                                        }
                                      },
                                    )
                                  ],
                                )
                            ],
                          ),
                          if ((widget.message.isSelf ?? true) && widget.showSelfAvatar)
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: getSquareSize(10)),
                              child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                                scene: TencentCloudChatAvatarScene.messageListForSelf,
                                imageList: [widget.message.faceUrl ?? ""],
                                width: getSquareSize(36),
                                height: getSquareSize(36),
                                borderRadius: getSquareSize(18),
                              ),
                            ),
                          if ((widget.message.isSelf ?? true) && !widget.showSelfAvatar)
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
