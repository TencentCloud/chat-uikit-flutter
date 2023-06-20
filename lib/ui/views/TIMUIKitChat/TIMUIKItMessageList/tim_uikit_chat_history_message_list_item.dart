import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/tim_uikit_chat_text_translate_elem.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/forward_message_screen.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:tencent_super_tooltip/tencent_super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/history_message_constant.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/time_ago.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_message_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_message_read_receipt.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/TIMUIKitMessageReaction/tim_uikit_message_reaction_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/main.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/tim_uikit_chat_custom_elem.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/tim_uikit_chat_face_elem.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_cloud_custom_data.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/radio_button.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

import '../TIMUIKitMessageItem/TIMUIKitMessageReaction/tim_uikit_message_reaction_select_emoji.dart';

typedef MessageRowBuilder = Widget? Function(
  /// current message
  V2TimMessage message,

  /// the message widget for current message, build by your custom builder or our default builder
  Widget messageWidget,

  /// scroll to the specific message, it will shows in the screen center, and call isNeedShowJumpStatus if necessary
  Function onScrollToIndex,

  /// if current message been called to jumped by other message
  bool isNeedShowJumpStatus,

  /// clear the been jumped status, recommend to execute after get 'isNeedShowJumpStatus'
  VoidCallback clearJumpStatus,

  /// scroll to specific message, it will shows on the screen top, without the call isNeedShowJumpStatus
  Function onScrollToIndexBegin,
);

typedef MessageNickNameBuilder = Widget Function(
    BuildContext context, V2TimMessage message, TUIChatSeparateViewModel model);

typedef MessageItemContent = Widget? Function(
  V2TimMessage message,
  bool isShowJump,
  VoidCallback clearJump,
);

class MessageHoverControlItem {
  String name;
  Widget icon;
  ValueChanged<TapDownDetails> onClick;

  MessageHoverControlItem(
      {required this.name, required this.icon, required this.onClick});
}

class MessageItemBuilder {
  /// text message builder, returns null means using default widget.
  final MessageItemContent? textMessageItemBuilder;

  /// text message builder for reply message, returns null means using default widget.
  final MessageItemContent? textReplyMessageItemBuilder;

  /// custom message builder, returns null means using default widget.
  final MessageItemContent? customMessageItemBuilder;

  /// image message builder, returns null means using default widget.
  final MessageItemContent? imageMessageItemBuilder;

  /// sound message builder, returns null means using default widget.
  final MessageItemContent? soundMessageItemBuilder;

  /// video message builder, returns null means using default widget.
  final MessageItemContent? videoMessageItemBuilder;

  /// file message builder, returns null means using default widget.
  final MessageItemContent? fileMessageItemBuilder;

  /// location message (LBS) item builder;
  /// recommend to use our LBS plug-in: https://pub.dev/packages/tim_ui_kit_lbs_plugin
  final MessageItemContent? locationMessageItemBuilder;

  /// face message, like emoji, message builder, returns null means using default widget.
  final MessageItemContent? faceMessageItemBuilder;

  /// group tips message builder, returns null means using default widget.
  final MessageItemContent? groupTipsMessageItemBuilder;

  /// merger message builder, returns null means using default widget.
  final MessageItemContent? mergerMessageItemBuilder;

  /// The builder for the whole message line, expect for those message type without avatar and nickname.
  /// [Update] You can only re-define the message types you need, returns null means using default row layout.
  final MessageRowBuilder? messageRowBuilder;

  /// message nick name builder
  final MessageNickNameBuilder? messageNickNameBuilder;

  MessageItemBuilder({
    this.locationMessageItemBuilder,
    this.textMessageItemBuilder,
    this.textReplyMessageItemBuilder,
    this.customMessageItemBuilder,
    this.imageMessageItemBuilder,
    this.soundMessageItemBuilder,
    this.videoMessageItemBuilder,
    this.fileMessageItemBuilder,
    this.faceMessageItemBuilder,
    this.groupTipsMessageItemBuilder,
    this.mergerMessageItemBuilder,
    this.messageRowBuilder,
    this.messageNickNameBuilder,
  });
}

class MessageToolTipItem {
  final String label;
  final String id;
  final String iconImageAsset;
  final VoidCallback onClick;

  MessageToolTipItem(
      {required this.label,
      required this.id,
      required this.iconImageAsset,
      required this.onClick});
}

class ToolTipsConfig {
  /// Whether to show the reply to a message option.
  final bool showReplyMessage;

  /// Whether to show the multiple-choice option for messages.
  final bool showMultipleChoiceMessage;

  /// Whether to show the option to delete a message.
  final bool showDeleteMessage;

  /// Whether to show the option to recall a message.
  final bool showRecallMessage;

  /// Whether to show the option to copy a message.
  final bool showCopyMessage;

  /// Whether to show the option to forward a message.
  final bool showForwardMessage;

  /// Whether to show the option to translate a text message. This module is not available by default. Please contact your Tencent Cloud sales representative or customer service team to enable this feature.
  final bool showTranslation;

  /// A builder for additional custom items. We recommend using `additionalMessageToolTips` instead of this field since version 2.0, as you only need to provide the data rather than the whole widget. This makes usage easier and you don't need to worry about the UI display.
  final Widget? Function(V2TimMessage message, Function() closeTooltip,
      [Key? key, BuildContext? context])? additionalItemBuilder;

  /// A list of additional message tooltip menu items, provided with the data only. We recommend using this field instead of the previous `additionalItemBuilder`.
  List<MessageToolTipItem> Function(
      V2TimMessage message, Function() closeTooltip)? additionalMessageToolTips;

  ToolTipsConfig(
      {this.showDeleteMessage = true,
      this.showMultipleChoiceMessage = true,
      this.showRecallMessage = true,
      this.showReplyMessage = true,
      this.showTranslation = true,
      this.showCopyMessage = true,
      this.showForwardMessage = true,
      this.additionalMessageToolTips,
      @Deprecated(
          "Please use `additionalMessageToolTips` instead. You are now only expected to specify the data, rather than providing a whole widget. This makes usage easier, as you no longer need to worry about the UI display.")
      this.additionalItemBuilder});
}

class TIMUIKitHistoryMessageListItem extends StatefulWidget {
  /// message instance
  final V2TimMessage message;

  /// tap remote user avatar callback function
  final void Function(String userID, TapDownDetails tapDetails)?
      onTapForOthersPortrait;

  /// secondary tap remote user avatar callback function
  final void Function(String userID, TapDownDetails tapDetails)?
      onSecondaryTapForOthersPortrait;

  /// the function use for reply message, when click replied message can scroll to it.
  final Function? onScrollToIndex;

  /// message is too long should scroll this message to begin so that the tool tips panel can show correctly.
  final Function? onScrollToIndexBegin;

  /// the callback for long press event, except myself avatar
  final Function(String? userId, String? nickName)?
      onLongPressForOthersHeadPortrait;

  /// message item builder, works for customize all message types and row layout.
  final MessageItemBuilder? messageItemBuilder;

  /// Control avatar hide or show
  final bool showAvatar;

  /// message sending status
  final bool showMessageSending;

  /// message is read status
  final bool showMessageReadRecipt;

  /// message read status in group
  final bool showGroupMessageReadRecipt;

  /// allow message can long press
  final bool allowLongPress;

  /// allow avatar can tap
  final bool allowAvatarTap;

  /// Auto mention user when send reply message
  final bool allowAtUserWhenReply;

  @Deprecated(
      "Nickname will not show in one-to-one chat, if you tend to control it in group chat, please use `isShowSelfNameInGroup` and `isShowOthersNameInGroup` from `config: TIMUIKitChatConfig` instead")

  /// allow show user nick name
  final bool showNickName;

  /// on message long press callback
  final Function(BuildContext context, V2TimMessage message)? onLongPress;

  /// tool tips panel configuration, long press message will show tool tips panel
  final ToolTipsConfig? toolTipsConfig;

  /// padding for each message item
  final EdgeInsetsGeometry? padding;

  /// The controller for text field.
  final TIMUIKitInputTextFieldController? textFieldController;

  /// padding for text message、sound message、reply message
  final EdgeInsetsGeometry? textPadding;

  /// avatar builder
  final Widget Function(BuildContext context, V2TimMessage message)?
      userAvatarBuilder;

  /// theme info for message and avatar
  final MessageThemeData? themeData;

  /// builder for nick name row
  final Widget Function(BuildContext context, V2TimMessage message)?
      topRowBuilder;

  /// builder for bottom raw which under message content
  final Widget Function(BuildContext context, V2TimMessage message)?
      bottomRowBuilder;

  // open MessageReaction
  final bool? isUseMessageReaction;

  /// Whether to use the default emoji
  final bool isUseDefaultEmoji;

  final List customEmojiStickerList;

  final V2TimGroupMemberFullInfo? groupMemberInfo;

  /// This parameter accepts a custom widget to be displayed when the mouse hovers over a message,
  /// replacing the default message hover action bar.
  /// Applicable only on desktop platforms.
  /// If provided, the default message action functionality will appear in the right-click context menu instead.
  final Widget Function(V2TimMessage message)? customMessageHoverBarOnDesktop;

  const TIMUIKitHistoryMessageListItem(
      {Key? key,
      required this.message,
      @Deprecated(
          "Nickname will not show in one-to-one chat, if you tend to control it in group chat, please use `isShowSelfNameInGroup` and `isShowOthersNameInGroup` from `config: TIMUIKitChatConfig` instead")
      this.showNickName = false,
      this.onScrollToIndex,
      this.onScrollToIndexBegin,
      this.onTapForOthersPortrait,
      this.messageItemBuilder,
      this.onLongPressForOthersHeadPortrait,
      this.showAvatar = true,
      this.showMessageSending = true,
      this.showMessageReadRecipt = true,
      this.allowLongPress = true,
      this.toolTipsConfig,
      this.onLongPress,
      this.showGroupMessageReadRecipt = false,
      this.allowAtUserWhenReply = true,
      this.allowAvatarTap = true,
      this.userAvatarBuilder,
      this.themeData,
      this.padding,
      this.textPadding,
      this.topRowBuilder,
      this.isUseMessageReaction,
      this.bottomRowBuilder,
      this.isUseDefaultEmoji = false,
      this.customEmojiStickerList = const [],
      this.textFieldController,
      this.onSecondaryTapForOthersPortrait,
      this.groupMemberInfo,
      this.customMessageHoverBarOnDesktop})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKItHistoryMessageListItemState();
}

class TipsActionItem extends TIMUIKitStatelessWidget {
  final String label;
  final String icon;
  final String? package;

  TipsActionItem(
      {Key? key, required this.label, required this.icon, this.package})
      : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return Column(
      children: [
        Image.asset(
          icon,
          package: package,
          width: 20,
          height: 20,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: const TextStyle(
            decoration: TextDecoration.none,
            color: Color(0xFF444444),
            fontSize: 10,
          ),
        )
      ],
    );
  }
}

class _TIMUIKItHistoryMessageListItemState
    extends TIMUIKitState<TIMUIKitHistoryMessageListItem>
    with TickerProviderStateMixin {
  SuperTooltip? tooltip;

  // ignore: unused_field
  final MessageService _messageService = serviceLocator<MessageService>();
  final TUISelfInfoViewModel selfInfoModel =
      serviceLocator<TUISelfInfoViewModel>();
  final TUIThemeViewModel themeModel = serviceLocator<TUIThemeViewModel>();

  // bool isChecked = false;
  final GlobalKey _key = GlobalKey();
  bool isShowWideToolTip = false;
  TapDownDetails? _tapDetails;

  closeTooltip() {
    tooltip?.close();
  }

  bool isReplyMessage(V2TimMessage message) {
    final hasCustomData =
        message.cloudCustomData != null && message.cloudCustomData != "";
    if (hasCustomData) {
      try {
        final CloudCustomData messageCloudCustomData = CloudCustomData.fromJson(
            json.decode(
                TencentUtils.checkString(message.cloudCustomData) != null
                    ? message.cloudCustomData!
                    : "{}"));
        if (messageCloudCustomData.messageReply != null) {
          MessageRepliedData.fromJson(messageCloudCustomData.messageReply!);
          return true;
        }
        return false;
      } catch (error) {
        return false;
      }
    }
    return false;
  }

  (bool isRevoke, bool isRevokeByAdmin) isRevokeMessage(
      V2TimMessage message, TUIChatSeparateViewModel model) {
    if (message.status == 6) {
      return (true, false);
    } else if (model.chatConfig.isGroupAdminRecallEnabled) {
      try {
        final customData = jsonDecode(message.cloudCustomData ?? "{}");
        final isRevoke = customData["isRevoke"] ?? false;
        final revokeByAdmin = customData["revokeByAdmin"] ?? false;
        return (isRevoke, revokeByAdmin);
      } catch (e) {
        return (false, false);
      }
    }
    return (false, false);
  }

  Widget _messageItemBuilder(
      V2TimMessage messageItem, TUIChatSeparateViewModel model) {
    final msgType = messageItem.elemType;
    final isShowJump = (model.jumpMsgID == messageItem.msgID) &&
        (messageItem.msgID?.isNotEmpty ?? false);
    final MessageItemBuilder? messageItemBuilder = widget.messageItemBuilder;
    final isFromSelf = messageItem.isSelf ?? true;
    void clearJump() {
      Future.delayed(const Duration(milliseconds: 100), () {
        model.jumpMsgID = "";
      });
    }

    switch (msgType) {
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        final customWidget =
            messageItemBuilder?.customMessageItemBuilder != null
                ? messageItemBuilder!.customMessageItemBuilder!(
                    messageItem,
                    isShowJump,
                    () => model.jumpMsgID = "",
                  )
                : null;
        return customWidget ??
            TIMUIKitCustomElem(
              message: messageItem,
              customElem: messageItem.customElem,
              isFromSelf: isFromSelf,
              messageBackgroundColor: widget.themeData?.messageBackgroundColor,
              messageBorderRadius: widget.themeData?.messageBorderRadius,
              messageFontStyle: widget.themeData?.messageTextStyle,
              textPadding: widget.textPadding,
              isShowMessageReaction: widget.isUseMessageReaction,
            );
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        final customWidget = messageItemBuilder?.soundMessageItemBuilder != null
            ? messageItemBuilder!.soundMessageItemBuilder!(
                messageItem,
                isShowJump,
                () => model.jumpMsgID = "",
              )
            : null;
        return customWidget ??
            TIMUIKitSoundElem(
              chatModel: model,
              message: messageItem,
              soundElem: messageItem.soundElem!,
              msgID: messageItem.msgID ?? "",
              isFromSelf: messageItem.isSelf ?? true,
              clearJump: clearJump,
              isShowJump: isShowJump,
              localCustomInt: messageItem.localCustomInt,
              borderRadius: widget.themeData?.messageBorderRadius,
              fontStyle: widget.themeData?.messageTextStyle,
              backgroundColor: widget.themeData?.messageBackgroundColor,
              textPadding: widget.textPadding,
              isShowMessageReaction: widget.isUseMessageReaction,
            );
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        if (isReplyMessage(messageItem)) {
          final customWidget =
              messageItemBuilder?.textReplyMessageItemBuilder != null
                  ? messageItemBuilder!.textReplyMessageItemBuilder!(
                      messageItem,
                      isShowJump,
                      () => model.jumpMsgID = "",
                    )
                  : null;
          return customWidget ??
              TIMUIKitReplyElem(
                message: messageItem,
                clearJump: clearJump,
                isShowJump: isShowJump,
                scrollToIndex: widget.onScrollToIndex ?? () {},
                borderRadius: widget.themeData?.messageBorderRadius,
                fontStyle: widget.themeData?.messageTextStyle,
                backgroundColor: widget.themeData?.messageBackgroundColor,
                textPadding: widget.textPadding,
                isUseDefaultEmoji: widget.isUseDefaultEmoji,
                customEmojiStickerList: widget.customEmojiStickerList,
                chatModel: model,
                isShowMessageReaction: widget.isUseMessageReaction,
              );
        }
        final customWidget = messageItemBuilder?.textMessageItemBuilder != null
            ? messageItemBuilder!.textMessageItemBuilder!(
                messageItem,
                isShowJump,
                () => model.jumpMsgID = "",
              )
            : null;
        return customWidget ??
            TIMUIKitTextElem(
              chatModel: model,
              message: messageItem,
              isFromSelf: messageItem.isSelf ?? true,
              clearJump: clearJump,
              isShowJump: isShowJump,
              borderRadius: widget.themeData?.messageBorderRadius,
              fontStyle: widget.themeData?.messageTextStyle,
              backgroundColor: widget.themeData?.messageBackgroundColor,
              textPadding: widget.textPadding,
              isShowMessageReaction: widget.isUseMessageReaction,
              isUseDefaultEmoji: widget.isUseDefaultEmoji,
              customEmojiStickerList: widget.customEmojiStickerList,
            );
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        final customWidget = messageItemBuilder?.faceMessageItemBuilder != null
            ? messageItemBuilder!.faceMessageItemBuilder!(
                messageItem,
                isShowJump,
                () => model.jumpMsgID = "",
              )
            : null;
        return customWidget ??
            TIMUIKitFaceElem(
              model: model,
              path: messageItem.faceElem!.data ?? "",
              clearJump: clearJump,
              isShowJump: isShowJump,
              message: messageItem,
              isShowMessageReaction: widget.isUseMessageReaction,
            );
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        final customWidget = messageItemBuilder?.fileMessageItemBuilder != null
            ? messageItemBuilder!.fileMessageItemBuilder!(
                messageItem,
                isShowJump,
                () => model.jumpMsgID = "",
              )
            : null;
        return customWidget ??
            TIMUIKitFileElem(
              chatModel: model,
              message: messageItem,
              messageID: messageItem.msgID,
              fileElem: messageItem.fileElem,
              isSelf: messageItem.isSelf ?? true,
              clearJump: clearJump,
              isShowJump: isShowJump,
              isShowMessageReaction: widget.isUseMessageReaction,
            );
      case MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS:
        final customWidget =
            messageItemBuilder?.groupTipsMessageItemBuilder != null
                ? messageItemBuilder!.groupTipsMessageItemBuilder!(
                    messageItem,
                    isShowJump,
                    () => model.jumpMsgID = "",
                  )
                : null;
        return customWidget ?? Text(TIM_t("[群系统消息]"));
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        final customWidget = messageItemBuilder?.imageMessageItemBuilder != null
            ? messageItemBuilder!.imageMessageItemBuilder!(
                messageItem,
                isShowJump,
                () => model.jumpMsgID = "",
              )
            : null;
        return customWidget ??
            TIMUIKitImageElem(
              clearJump: clearJump,
              isShowJump: isShowJump,
              chatModel: model,
              message: messageItem,
              isShowMessageReaction: widget.isUseMessageReaction,
              key: Key("${messageItem.seq}_${messageItem.timestamp}"),
            );
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        final customWidget = messageItemBuilder?.videoMessageItemBuilder != null
            ? messageItemBuilder!.videoMessageItemBuilder!(
                messageItem,
                isShowJump,
                () => model.jumpMsgID = "",
              )
            : null;
        return customWidget ??
            TIMUIKitVideoElem(
              messageItem,
              isShowJump: isShowJump,
              chatModel: model,
              clearJump: clearJump,
              isShowMessageReaction: widget.isUseMessageReaction,
            );
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        final customWidget =
            messageItemBuilder?.locationMessageItemBuilder != null
                ? messageItemBuilder!.locationMessageItemBuilder!(
                    messageItem,
                    isShowJump,
                    () => model.jumpMsgID = "",
                  )
                : null;
        return customWidget ?? Text(TIM_t("[位置]"));
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        final customWidget =
            messageItemBuilder?.mergerMessageItemBuilder != null
                ? messageItemBuilder!.mergerMessageItemBuilder!(
                    messageItem,
                    isShowJump,
                    () => model.jumpMsgID = "",
                  )
                : null;
        return customWidget ??
            TIMUIKitMergerElem(
                messageItemBuilder: messageItemBuilder,
                model: model,
                isShowJump: isShowJump,
                clearJump: clearJump,
                message: messageItem,
                isShowMessageReaction: widget.isUseMessageReaction,
                mergerElem: messageItem.mergerElem!,
                messageID: messageItem.msgID ?? "",
                isSelf: messageItem.isSelf ?? true);
      default:
        return Text(TIM_t("[未知消息]"));
    }
  }

  Widget _groupTipsMessageBuilder(TUIChatSeparateViewModel model) {
    final messageItem = widget.message;
    return Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: TIMUIKitGroupTipsElem(
            groupTipsElem: messageItem.groupTipsElem!,
            groupMemberList: model.groupMemberList ?? []));
  }

  Widget _selfRevokeEditMessageBuilder(theme, TUIChatSeparateViewModel model) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text.rich(TextSpan(children: [
          TextSpan(
            text: TIM_t("您撤回了一条消息，"),
            style: TextStyle(color: theme.weakTextColor),
          ),
          TextSpan(
            text: TIM_t("重新编辑"),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                widget.textFieldController
                    ?.setTextField(widget.message.textElem?.text ?? "");
              },
            style: TextStyle(color: theme.primaryColor),
          )
        ], style: const TextStyle(fontSize: 12))));
  }

  Widget _revokedMessageBuilder(theme, String option2) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(
          TIM_t_para("{{option2}}撤回了一条消息", "$option2撤回了一条消息")(option2: option2),
          style: TextStyle(color: theme.weakTextColor, fontSize: 12),
        ));
  }

  Widget _timeDividerBuilder(
      theme, int timeStamp, TUIChatSeparateViewModel model) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        model.chatConfig.timeDividerConfig?.timestampParser != null
            ? (model.chatConfig.timeDividerConfig?.timestampParser!(timeStamp))!
            : TimeAgo().getTimeForMessage(timeStamp),
        style: widget.themeData?.timelineTextStyle ??
            TextStyle(
              fontSize: 12,
              color: theme.chatTimeDividerTextColor,
            ),
      ),
    );
  }

  Widget _latestDividerBuilder(TUITheme theme) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: SizedBox(
              height: 1,
              width: 100,
              child: Container(
                  decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0x00C0E1FF),
                  theme.primaryColor ?? CommonColor.lightPrimaryColor
                ]),
              )),
            ),
          ),
          Text(
            TIM_t("以下为未读消息"),
            style: widget.themeData?.timelineTextStyle ??
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.primaryColor,
                ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 1,
              width: 100,
              child: Container(
                  decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  theme.primaryColor ?? CommonColor.primaryColor,
                  const Color(0x00C0E1FF),
                ]),
              )),
            ),
          ),
        ],
      ),
    );
  }

  bool isRevocable(int timestamp) =>
      (DateTime.now().millisecondsSinceEpoch / 1000).ceil() - timestamp < 120;

  _onOpenToolTip(
    c,
    V2TimMessage message,
    TUIChatSeparateViewModel model,
    TUITheme theme,
    TapDownDetails? details,
    bool? isFromWideTooltip,
    bool? isShowMoreSticker,
  ) {
    if (tooltip != null && tooltip!.isOpen) {
      tooltip!.close();
      return;
    }
    tooltip = null;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final isLongMessage =
        context.size!.height + 350 > screenHeight && !(isDesktopScreen);
    final tapDetails =
        (isDesktopScreen || isLongMessage) ? (details ?? _tapDetails) : details;
    final isSelf = message.isSelf ?? true;

    final targetWidth =
        min(MediaQuery.of(context).size.width * 0.84, 350).toDouble();
    final double dx = !isSelf
        ? min(tapDetails?.globalPosition.dx ?? targetWidth,
            screenWidth - targetWidth)
        : max(tapDetails?.globalPosition.dx ?? targetWidth, targetWidth)
            .toDouble();
    final double dy = min(
            tapDetails?.globalPosition.dy ?? MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.height - 320)
        .toDouble();
    final finalTapDetail = tapDetails != null
        ? TapDownDetails(
            globalPosition: Offset(dx, dy),
          )
        : null;

    initTools(
        context: c,
        model: model,
        isShowMoreSticker: isShowMoreSticker,
        details: finalTapDetail,
        theme: theme,
        isFromWideToolTip: isFromWideTooltip);
    tooltip!.show(c, targetCenter: finalTapDetail?.globalPosition);
  }

  _clickOnCurrentSticker(int sticker) async {
    for (int i = 0; i < 5; i++) {
      final res = await _modifySticker(sticker);
      if (res.code == 0) {
        break;
      }
    }
  }

  Future<V2TimValueCallback<V2TimMessageChangeInfo>> _modifySticker(
      int sticker) async {
    return await Future.delayed(const Duration(milliseconds: 50), () async {
      return await MessageReactionUtils.clickOnSticker(widget.message, sticker);
    });
  }

  initTools(
      {BuildContext? context,
      bool isLongMessage = false,
      required TUIChatSeparateViewModel model,
      TUITheme? theme,
      bool? isShowMoreSticker,
      TapDownDetails? details,
      bool? isFromWideToolTip}) {
    final isUseMessageReaction = widget.message.elemType == 2
        ? false
        : model.chatConfig.isUseMessageReaction;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final isSelf = widget.message.isSelf ?? true;
    double arrowTipDistance = 30;
    double arrowBaseWidth = 10;
    double arrowLength = 10;
    bool hasArrow = true;
    TooltipDirection popupDirection = TooltipDirection.up;
    double? left;
    double? right;
    SelectEmojiPanelPosition selectEmojiPanelPosition =
        SelectEmojiPanelPosition.down;
    if (context != null) {
      RenderBox? box = _key.currentContext?.findRenderObject() as RenderBox?;
      if (details != null && box != null) {
        double screenWidth = MediaQuery.of(context).size.width;
        final mousePosition = details.globalPosition;
        hasArrow = isDesktopScreen ? false : true;
        arrowTipDistance = 0;
        arrowBaseWidth = 0;
        arrowLength = 0;
        popupDirection = TooltipDirection.down;
        if (isSelf || (isFromWideToolTip ?? false)) {
          right = screenWidth - mousePosition.dx;
        } else {
          left = mousePosition.dx;
        }
      } else {
        if (box != null) {
          double screenWidth = MediaQuery.of(context).size.width;
          double viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
          Offset offset = box.localToGlobal(Offset.zero);
          double boxWidth = box.size.width;
          if (isSelf) {
            right = screenWidth -
                offset.dx -
                ((isUseMessageReaction) ? boxWidth : (boxWidth / 1.3));
          } else {
            left = offset.dx;
          }
          if (offset.dy < 300 && !isLongMessage && viewInsetsBottom == 0) {
            selectEmojiPanelPosition = SelectEmojiPanelPosition.up;
            popupDirection = TooltipDirection.down;
          } else if (viewInsetsBottom != 0 && offset.dy < 220) {
            selectEmojiPanelPosition = SelectEmojiPanelPosition.up;
            popupDirection = TooltipDirection.down;
          }
        }
        arrowTipDistance = (context.size!.height / 2).roundToDouble() +
            (isLongMessage ? -120 : 10);
      }
    }

    tooltip = SuperTooltip(
      popupDirection: popupDirection,
      minimumOutSidePadding: 0,
      arrowTipDistance: arrowTipDistance,
      arrowBaseWidth: arrowBaseWidth,
      arrowLength: arrowLength,
      right: right,
      left: left,
      hasArrow: hasArrow,
      borderColor: theme?.white ?? Colors.white,
      backgroundColor: theme?.white ?? Colors.white,
      shadowColor: Colors.black26,
      hasShadow: isDesktopScreen ? false : true,
      borderWidth: 1.0,
      showCloseButton: ShowCloseButton.none,
      touchThroughAreaShape: ClipAreaShape.rectangle,
      content: TIMUIKitMessageTooltip(
        iSUseDefaultHoverBar: model.chatConfig.isUseMessageHoverBarOnDesktop &&
            widget.customMessageHoverBarOnDesktop == null,
        model: model,
        groupMemberInfo: widget.groupMemberInfo,
        isShowMoreSticker: isShowMoreSticker ?? false,
        toolTipsConfig: widget.toolTipsConfig,
        isUseMessageReaction: isUseMessageReaction,
        message: widget.message,
        allowAtUserWhenReply: widget.allowAtUserWhenReply,
        onLongPressForOthersHeadPortrait:
            widget.onLongPressForOthersHeadPortrait,
        selectEmojiPanelPosition: selectEmojiPanelPosition,
        onCloseTooltip: () => tooltip?.close(),
        onSelectSticker: (int value) {
          tooltip?.close();
          _clickOnCurrentSticker(value);
        },
      ),
    );
  }

  Widget _getMessageItemBuilder(V2TimMessage message, int? messageStatues,
      TUIChatSeparateViewModel model) {
    final messageBuilder = _messageItemBuilder;

    return messageBuilder(widget.message, model);
  }

  // 弹出对话框
  Future<bool?> showResendMsgFailDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(TIM_t("您确定要重发这条消息么？")),
          actions: [
            CupertinoDialogAction(
              child: Text(TIM_t("确定")),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            CupertinoDialogAction(
              child: Text(TIM_t("取消")),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
  }

  bool isVoteMessage(V2TimMessage message) {
    bool isvote = false;
    V2TimCustomElem? custom = message.customElem;

    if (custom != null) {
      String? data = custom.data;
      if (data != null && data.isNotEmpty) {
        try {
          Map<String, dynamic> mapData = json.decode(data);
          if (mapData["businessID"] == "group_poll") {
            isvote = true;
          }
        } catch (err) {
          // err
        }
      }
    }
    return isvote;
  }

  List<MessageHoverControlItem> getMessageHoverControlBar(
      TUIChatSeparateViewModel model, TUITheme theme) {
    return [
      if (widget.isUseMessageReaction ?? false)
        MessageHoverControlItem(
          name: TIM_t("表情回应"),
          icon: Icon(
            Icons.emoji_emotions,
            size: 13,
            color: hexToColor("8f959e"),
          ),
          onClick: (details) {
            _onOpenToolTip(
                context, widget.message, model, theme, details, true, true);
          },
        ),
      if (widget.toolTipsConfig?.showReplyMessage ?? true)
        MessageHoverControlItem(
          name: TIM_t("回复"),
          icon: Icon(
            Icons.message,
            size: 13,
            color: hexToColor("8f959e"),
          ),
          onClick: (_) {
            model.repliedMessage = widget.message;
            final isSelf = widget.message.isSelf ?? true;
            final isGroup =
                TencentUtils.checkString(widget.message.groupID) != null;
            final isAtWhenReply = !isSelf &&
                isGroup &&
                widget.allowAtUserWhenReply &&
                widget.onLongPressForOthersHeadPortrait != null;

            /// If replying to a self message, do not add a at tag, only requestFocus.
            widget.onLongPressForOthersHeadPortrait!(
                !isAtWhenReply ? null : widget.message.sender,
                !isAtWhenReply ? null : widget.message.nickName);
          },
        ),
      if ((widget.toolTipsConfig?.showForwardMessage ?? true) &&
          !isVoteMessage(widget.message))
        MessageHoverControlItem(
          name: TIM_t("转发"),
          icon: Icon(
            Icons.send,
            size: 13,
            color: hexToColor("8f959e"),
          ),
          onClick: (_) {
            model.addToMultiSelectedMessageList(widget.message);
            TUIKitWidePopup.showPopupWindow(
                operationKey: TUIKitWideModalOperationKey.forward,
                context: context,
                title: TIM_t("转发"),
                submitWidget: Text(TIM_t("发送")),
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.8,
                onSubmit: () {
                  forwardMessageScreenKey.currentState?.handleForwardMessage();
                },
                child: (onClose) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ForwardMessageScreen(
                        conversationType: ConvType.c2c,
                        key: forwardMessageScreenKey,
                        onClose: onClose,
                        model: model,
                      ),
                    ),
                theme: theme);
          },
        ),
      MessageHoverControlItem(
        name: TIM_t("更多"),
        icon: Icon(
          Icons.more_horiz,
          size: 13,
          color: hexToColor("8f959e"),
        ),
        onClick: (details) {
          _onOpenToolTip(
              context, widget.message, model, theme, details, true, false);
        },
      ),
      ...?model.chatConfig.additionalDesktopMessageHoverBarItem
    ];
  }

  _onMsgSendFailIconTap(V2TimMessage message, TUIChatSeparateViewModel model) {
    final convID = model.conversationID;
    final convType = model.conversationType;
    MessageUtils.handleMessageError(
        model.reSendFailMessage(
            message: message,
            convType: convType ?? ConvType.c2c,
            convID: convID),
        context);
  }

  Widget renderHoverTipAndReadStatus(
      TUIChatSeparateViewModel model,
      bool isSelf,
      V2TimMessage message,
      bool isPeerRead,
      TUITheme theme,
      bool isDownloadWaiting) {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final wideHoverTipList = (model.chatConfig.isUseMessageHoverBarOnDesktop &&
            widget.customMessageHoverBarOnDesktop == null)
        ? getMessageHoverControlBar(model, theme)
        : [];
    final lastItemName =
        wideHoverTipList.isNotEmpty ? wideHoverTipList.last.name : "";
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isDesktopScreen &&
            isShowWideToolTip &&
            !((widget.message.elemType == 6 && isDownloadWaiting)))
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: hexToColor("d9dde0"), width: 1)),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: wideHoverTipList
                  .map((e) => Tooltip(
                        message: e.name,
                        preferBelow: false,
                        textStyle: TextStyle(fontSize: 12, color: theme.white),
                        child: Row(
                          children: [
                            InkWell(
                              onTapDown: e.onClick,
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: e.icon,
                              ),
                            ),
                            if (lastItemName != e.name)
                              SizedBox(
                                width: 1,
                                height: 22,
                                child: Container(
                                  color: theme.weakDividerColor,
                                ),
                              )
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        if (isDesktopScreen &&
            isShowWideToolTip &&
            widget.customMessageHoverBarOnDesktop != null)
          widget.customMessageHoverBarOnDesktop!(message),
        if (!isDesktopScreen ||
            (model.chatConfig.isUseMessageHoverBarOnDesktop &&
                widget.customMessageHoverBarOnDesktop == null &&
                !isShowWideToolTip))
          const SizedBox(
            height: 24,
          ),
        if (isSelf &&
            message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL)
          Container(
              padding: const EdgeInsets.only(bottom: 3),
              margin: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                onTap: () async {
                  final reSend = await showResendMsgFailDialog(context);
                  if (reSend != null) {
                    _onMsgSendFailIconTap(message, model);
                  }
                },
                child: Icon(Icons.error, color: theme.cautionColor, size: 18),
              )),
        if (model.chatConfig.isShowReadingStatus &&
            widget.showMessageReadRecipt &&
            model.conversationType == ConvType.c2c &&
            isSelf &&
            (message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC ||
                message.status == MessageStatus.V2TIM_MSG_STATUS_SENDING))
          Container(
            padding: const EdgeInsets.only(bottom: 3),
            margin: const EdgeInsets.only(right: 6),
            child: Text(
              isPeerRead ? TIM_t("已读") : TIM_t("未读"),
              style: TextStyle(
                  color: theme.chatMessageItemUnreadStatusTextColor,
                  fontSize: 12),
            ),
          ),
        if (model.chatConfig.isShowGroupReadingStatus &&
            model.chatConfig.isShowGroupMessageReadReceipt &&
            model.conversationType == ConvType.group &&
            isSelf &&
            (message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_SUCC ||
                message.status == MessageStatus.V2TIM_MSG_STATUS_SENDING))
          TIMUIKitMessageReadReceipt(
            messageItem: widget.message,
            onTapAvatar: widget.onTapForOthersPortrait,
          ),
      ],
    );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUIChatSeparateViewModel model =
        Provider.of<TUIChatSeparateViewModel>(context);
    final isDownloadWaiting = context.select<TUIChatGlobalModel, bool>(
        (value) => value.isWaiting(widget.message.msgID ?? ""));
    final TUITheme theme = value.theme;
    final message = widget.message;
    final msgType = message.elemType;
    final isSelf = message.isSelf ?? true;
    final isGroupTipsMsg =
        msgType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS;

    final revokeStatus = isRevokeMessage(message, model);
    final isRevokedMsg = revokeStatus.$1;
    final isAdminRevoke = revokeStatus.$2;

    final isTimeDivider = msgType == 11;
    final isLatestDivider = msgType == 101;
    final isPeerRead = message.isPeerRead ?? false;
    final isGroupMessage = model.conversationType == ConvType.group;
    final bool isRevokeEditable =
        widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT;
    final isShowNickNameForSelf =
        isGroupMessage && model.chatConfig.isShowSelfNameInGroup;
    final isShowNickNameForOthers =
        isGroupMessage && model.chatConfig.isShowOthersNameInGroup;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    if (isTimeDivider) {
      return _timeDividerBuilder(theme, message.timestamp ?? 0, model);
    }
    if (isLatestDivider) {
      return _latestDividerBuilder(theme);
    }
    void clearJump() {
      Future.delayed(const Duration(milliseconds: 100), () {
        model.jumpMsgID = "";
      });
    }

    if (isGroupTipsMsg) {
      if (widget.messageItemBuilder?.groupTipsMessageItemBuilder != null) {
        final groupTipsMessage =
            widget.messageItemBuilder!.groupTipsMessageItemBuilder!(
          message,
          (model.jumpMsgID == message.msgID),
          clearJump,
        );
        return groupTipsMessage ?? _groupTipsMessageBuilder(model);
      }
      return _groupTipsMessageBuilder(model);
    }

    if (isRevokedMsg) {
      final displayName = isAdminRevoke
          ? TIM_t("管理员")
          : (isSelf
              ? TIM_t("您")
              : TencentUtils.checkString(message.nickName) ??
                  TencentUtils.checkString(message.sender) ??
                  message.userID);
      return isSelf && isRevokeEditable && isRevocable(message.timestamp!)
          ? _selfRevokeEditMessageBuilder(theme, model)
          : _revokedMessageBuilder(theme, displayName ?? "");
    }

    // 使用自定义行
    if (widget.messageItemBuilder?.messageRowBuilder != null) {
      final customRow = widget.messageItemBuilder!.messageRowBuilder!(
        message,
        _getMessageItemBuilder(message, message.status, model),
        widget.onScrollToIndex ?? () {},
        message.msgID == model.jumpMsgID,
        clearJump,
        widget.onScrollToIndexBegin ?? () {},
      );
      if (customRow != null) {
        return customRow;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) => Container(
        padding: EdgeInsets.only(left: isSelf ? 0 : 16, right: isSelf ? 16 : 0),
        margin: widget.padding ?? const EdgeInsets.only(bottom: 20),
        child: Row(
          key: _key,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.isMultiSelect)
              Container(
                margin:
                    EdgeInsets.only(right: 12, top: 10, left: isSelf ? 16 : 0),
                child: CheckBoxButton(
                  isChecked: model.multiSelectedMessageList.contains(message),
                  onChanged: (value) {
                    if (value) {
                      model.addToMultiSelectedMessageList(message);
                    } else {
                      model.removeFromMultiSelectedMessageList(message);
                    }
                  },
                ),
              ),
            Expanded(
              child: MouseRegion(
                onEnter: (_) {
                  if (isDesktopScreen &&
                      model.chatConfig.isUseMessageHoverBarOnDesktop) {
                    setState(() {
                      isShowWideToolTip = true;
                    });
                  }
                },
                onExit: (_) {
                  if (isDesktopScreen &&
                      model.chatConfig.isUseMessageHoverBarOnDesktop) {
                    setState(() {
                      isShowWideToolTip = false;
                    });
                  }
                },
                child: GestureDetector(
                  behavior:
                      model.isMultiSelect ? HitTestBehavior.translucent : null,
                  onTap: () {
                    if (model.isMultiSelect) {
                      final checked =
                          model.multiSelectedMessageList.contains(message);
                      if (checked) {
                        model.removeFromMultiSelectedMessageList(message);
                      } else {
                        model.addToMultiSelectedMessageList(message);
                      }
                    } else {
                      return;
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: isSelf
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isSelf && widget.showAvatar)
                        GestureDetector(
                          onLongPress: () {
                            if (widget.onLongPressForOthersHeadPortrait !=
                                null) {}
                            if (model.chatConfig.isAllowLongPressAvatarToAt) {
                              widget.onLongPressForOthersHeadPortrait!(
                                  message.sender, message.nickName);
                            }
                          },
                          onTapDown: isDesktopScreen
                              ? (details) {
                                  if (widget.onTapForOthersPortrait != null &&
                                      widget.allowAvatarTap) {
                                    widget.onTapForOthersPortrait!(
                                        message.sender ?? "", details);
                                  }
                                }
                              : null,
                          onTap: isDesktopScreen
                              ? null
                              : () {
                                  if (widget.onTapForOthersPortrait != null &&
                                      widget.allowAvatarTap) {
                                    widget.onTapForOthersPortrait!(
                                        message.sender ?? "", TapDownDetails());
                                  }
                                },
                          onSecondaryTap: isDesktopScreen
                              ? null
                              : () {
                                  if (widget.onSecondaryTapForOthersPortrait !=
                                          null &&
                                      widget.allowAvatarTap) {
                                    widget.onSecondaryTapForOthersPortrait!(
                                        message.sender ?? "", TapDownDetails());
                                  }
                                },
                          onSecondaryTapDown: isDesktopScreen
                              ? (details) {
                                  if (widget.onSecondaryTapForOthersPortrait !=
                                          null &&
                                      widget.allowAvatarTap) {
                                    widget.onSecondaryTapForOthersPortrait!(
                                        message.sender ?? "", details);
                                  }
                                }
                              : null,
                          child: widget.userAvatarBuilder != null
                              ? widget.userAvatarBuilder!(context, message)
                              : Container(
                                  margin: (isSelf && isShowNickNameForSelf) ||
                                          (!isSelf && isShowNickNameForOthers)
                                      ? const EdgeInsets.only(top: 2)
                                      : null,
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Avatar(
                                      faceUrl: message.faceUrl ?? "",
                                      showName:
                                          MessageUtils.getDisplayName(message),
                                    ),
                                  ),
                                ),
                        ),
                      if (isSelf &&
                          widget.message.elemType == 6 &&
                          isDownloadWaiting)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: LoadingAnimationWidget.threeArchedCircle(
                            color: theme.weakTextColor ?? Colors.grey,
                            size: 20,
                          ),
                        ),
                      Container(
                        margin: widget.showAvatar
                            ? (isSelf
                                ? const EdgeInsets.only(right: 13)
                                : const EdgeInsets.only(left: 13))
                            : null,
                        child: Column(
                          crossAxisAlignment: isSelf
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if ((isSelf && isShowNickNameForSelf) ||
                                (!isSelf && isShowNickNameForOthers))
                              widget.topRowBuilder != null
                                  ? widget.topRowBuilder!(context, message)
                                  : Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7),
                                        child: Text(
                                          MessageUtils.getDisplayName(message),
                                          overflow: TextOverflow.ellipsis,
                                          style: widget.themeData
                                                  ?.nickNameTextStyle ??
                                              TextStyle(
                                                  fontSize: 12,
                                                  color: theme.weakTextColor),
                                        ),
                                      )),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (isSelf)
                                  renderHoverTipAndReadStatus(
                                      model,
                                      isSelf,
                                      message,
                                      isPeerRead,
                                      theme,
                                      isDownloadWaiting),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth * 0.77,
                                  ),
                                  child: Builder(builder: (context) {
                                    return Column(
                                      crossAxisAlignment:
                                          (message.isSelf ?? true)
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          child: IgnorePointer(
                                              ignoring: model.isMultiSelect,
                                              child: _getMessageItemBuilder(
                                                  message,
                                                  message.status,
                                                  model)),
                                          onSecondaryTapDown: (details) {
                                            if (widget.onLongPress != null) {
                                              widget.onLongPress!(
                                                  context, message);
                                              return;
                                            }
                                            if (!PlatformUtils().isMobile) {
                                              if (widget.allowLongPress) {
                                                _onOpenToolTip(
                                                    context,
                                                    message,
                                                    model,
                                                    theme,
                                                    details,
                                                    false,
                                                    false);
                                              }
                                            }
                                          },
                                          onLongPress: () {
                                            if (widget.onLongPress != null) {
                                              widget.onLongPress!(
                                                  context, message);
                                              return;
                                            }
                                            if (widget.allowLongPress &&
                                                !isDesktopScreen) {
                                              _onOpenToolTip(
                                                  context,
                                                  message,
                                                  model,
                                                  theme,
                                                  null,
                                                  false,
                                                  false);
                                            }
                                          },
                                          onTapDown: (details) {
                                            _tapDetails = details;
                                          },
                                        ),
                                        TIMUIKitTextTranslationElem(
                                            message: message,
                                            isUseDefaultEmoji:
                                                widget.isUseDefaultEmoji,
                                            customEmojiStickerList:
                                                widget.customEmojiStickerList,
                                            isFromSelf: message.isSelf ?? true,
                                            isShowJump: false,
                                            clearJump: () {},
                                            chatModel: model)
                                      ],
                                    );
                                  }),
                                ),
                                if (!isSelf &&
                                    message.elemType ==
                                        MessageElemType.V2TIM_ELEM_TYPE_SOUND &&
                                    message.localCustomInt != null &&
                                    message.localCustomInt !=
                                        HistoryMessageDartConstant.read)
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, bottom: 12),
                                      child: Icon(Icons.circle,
                                          color: theme.cautionColor, size: 10)),
                                if (!isSelf)
                                  renderHoverTipAndReadStatus(
                                      model,
                                      isSelf,
                                      message,
                                      isPeerRead,
                                      theme,
                                      isDownloadWaiting),
                              ],
                            ),
                            if (widget.bottomRowBuilder != null)
                              widget.bottomRowBuilder!(context, message)
                          ],
                        ),
                      ),
                      if (!isSelf &&
                          widget.message.elemType == 6 &&
                          isDownloadWaiting)
                        Container(
                          margin: const EdgeInsets.only(top: 24, left: 6),
                          child: LoadingAnimationWidget.threeArchedCircle(
                            color: theme.weakTextColor ?? Colors.grey,
                            size: 20,
                          ),
                        ),
                      if (isSelf && widget.showAvatar)
                        widget.userAvatarBuilder != null
                            ? widget.userAvatarBuilder!(context, message)
                            : SizedBox(
                                width: 40,
                                height: 40,
                                child: InkWell(
                                  onTapDown: (details) {
                                    if (widget.onTapForOthersPortrait != null &&
                                        widget.allowAvatarTap) {
                                      widget.onTapForOthersPortrait!(
                                          message.sender ?? "", details);
                                    }
                                  },
                                  child: Avatar(
                                      faceUrl: message.faceUrl ?? "",
                                      showName:
                                          MessageUtils.getDisplayName(message)),
                                ),
                              ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
