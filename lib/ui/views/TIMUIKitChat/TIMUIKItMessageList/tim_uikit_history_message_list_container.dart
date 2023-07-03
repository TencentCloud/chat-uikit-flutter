// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field_controller.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/history_message_constant.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/TIMUIKitTongue/tim_uikit_chat_history_message_list_tongue.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list_config.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list_item.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_chat_config.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

enum LoadingPlace {
  none,
  top,
  bottom,
}

class TIMUIKitHistoryMessageListContainer extends StatefulWidget {
  final Widget Function(BuildContext, V2TimMessage?)? itemBuilder;
  final AutoScrollController? scrollController;
  final String conversationID;
  final Function(String? userId, String? nickName)?
      onLongPressForOthersHeadPortrait;
  final List<V2TimGroupAtInfo?>? groupAtInfoList;
  final V2TimMessage? initFindingMsg;

  /// message item builder, works for customize all message types and row layout.
  final MessageItemBuilder? messageItemBuilder;

  /// The controller for text field.
  final TIMUIKitInputTextFieldController? textFieldController;

  /// the builder for avatar
  final Widget Function(BuildContext context, V2TimMessage message)?
      userAvatarBuilder;

  /// the builder for tongue
  final TongueItemBuilder? tongueItemBuilder;

  final Widget? Function(V2TimMessage message, Function() closeTooltip,
      [Key? key, BuildContext? context])? extraTipsActionItemBuilder;

  /// conversation type
  final ConvType conversationType;

  /// Avatar and name in message reaction tap callback.
  final void Function(String userID, TapDownDetails tapDetails)? onTapAvatar;

  /// Avatar and name in message reaction secondary tap callback.
  final void Function(String userID, TapDownDetails tapDetails)?
      onSecondaryTapAvatar;

  @Deprecated(
      "Nickname will not show in one-to-one chat, if you tend to control it in group chat, please use `isShowSelfNameInGroup` and `isShowOthersNameInGroup` from `config: TIMUIKitChatConfig` instead")
  final bool showNickName;

  final TIMUIKitHistoryMessageListConfig? mainHistoryListConfig;

  /// tool tips panel configuration, long press message will show tool tips panel
  final ToolTipsConfig? toolTipsConfig;

  /// Whether to use the default emoji
  final bool isUseDefaultEmoji;

  final List customEmojiStickerList;

  final bool isAllowScroll;

  final V2TimConversation conversation;

  final V2TimGroupMemberFullInfo? groupMemberInfo;

  /// This parameter accepts a custom widget to be displayed when the mouse hovers over a message,
  /// replacing the default message hover action bar.
  /// Applicable only on desktop platforms.
  /// If provided, the default message action functionality will appear in the right-click context menu instead.
  final Widget Function(V2TimMessage message)? customMessageHoverBarOnDesktop;

  const TIMUIKitHistoryMessageListContainer({
    Key? key,
    this.itemBuilder,
    this.scrollController,
    required this.conversationID,
    required this.conversationType,
    this.userAvatarBuilder,
    this.onLongPressForOthersHeadPortrait,
    this.groupAtInfoList,
    this.messageItemBuilder,
    this.tongueItemBuilder,
    this.extraTipsActionItemBuilder,
    this.isAllowScroll = true,
    this.onTapAvatar,
    @Deprecated(
        "Nickname will not show in one-to-one chat, if you tend to control it in group chat, please use `isShowSelfNameInGroup` and `isShowOthersNameInGroup` from `config: TIMUIKitChatConfig` instead")
    this.showNickName = true,
    this.initFindingMsg,
    this.mainHistoryListConfig,
    this.toolTipsConfig,
    this.isUseDefaultEmoji = false,
    this.customEmojiStickerList = const [],
    this.textFieldController,
    required this.conversation,
    this.onSecondaryTapAvatar,
    this.groupMemberInfo,
    this.customMessageHoverBarOnDesktop,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _TIMUIKitHistoryMessageListContainerState();
}

class _TIMUIKitHistoryMessageListContainerState
    extends TIMUIKitState<TIMUIKitHistoryMessageListContainer> {
  late TIMUIKitHistoryMessageListController _historyMessageListController;

  List<V2TimMessage?> historyMessageList = [];

  Future<void> requestForData(String? lastMsgID, LoadDirection direction,
      TUIChatSeparateViewModel model,
      [int? count]) async {
    if ((direction == LoadDirection.previous && model.haveMoreData) ||
        (direction == LoadDirection.latest && model.haveMoreLatestData)) {
      await model.loadChatRecord(
          direction: direction,
          count: count ?? (kIsWeb ? 15 : HistoryMessageDartConstant.getCount),
          lastMsgID: lastMsgID);
    }
  }

  Widget Function(BuildContext, V2TimMessage)? _getTopRowBuilder(
      TUIChatSeparateViewModel model) {
    if (widget.messageItemBuilder?.messageNickNameBuilder != null) {
      return (BuildContext context, V2TimMessage message) {
        return widget.messageItemBuilder!.messageNickNameBuilder!(
            context, message, model);
      };
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _historyMessageListController = TIMUIKitHistoryMessageListController(
        scrollController: widget.scrollController);
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final chatConfig = Provider.of<TIMUIKitChatConfig>(context);
    final TUIChatSeparateViewModel model =
        Provider.of<TUIChatSeparateViewModel>(context, listen: false);

    return TIMUIKitHistoryMessageListSelector(
      conversationID: model.conversationID,
      builder: (context, messageList, child) {
        return TIMUIKitHistoryMessageList(
          conversation: widget.conversation,
          model: model,
          isAllowScroll: widget.isAllowScroll,
          controller: _historyMessageListController,
          groupAtInfoList: widget.groupAtInfoList,
          mainHistoryListConfig: widget.mainHistoryListConfig,
          itemBuilder: (context, message) {
            return TIMUIKitHistoryMessageListItem(
                customMessageHoverBarOnDesktop:
                    widget.customMessageHoverBarOnDesktop,
                groupMemberInfo: widget.groupMemberInfo,
                textFieldController: widget.textFieldController,
                userAvatarBuilder: widget.userAvatarBuilder,
                customEmojiStickerList: widget.customEmojiStickerList,
                isUseDefaultEmoji: widget.isUseDefaultEmoji,
                topRowBuilder: _getTopRowBuilder(model),
                onScrollToIndex: _historyMessageListController.scrollToIndex,
                onScrollToIndexBegin:
                    _historyMessageListController.scrollToIndexBegin,
                toolTipsConfig: widget.toolTipsConfig ??
                    ToolTipsConfig(
                        additionalItemBuilder:
                            widget.extraTipsActionItemBuilder),
                message: message!,
                showAvatar: chatConfig.isShowAvatar,
                onSecondaryTapForOthersPortrait: widget.onSecondaryTapAvatar,
                onTapForOthersPortrait: widget.onTapAvatar,
                messageItemBuilder: widget.messageItemBuilder,
                onLongPressForOthersHeadPortrait:
                    widget.onLongPressForOthersHeadPortrait,
                allowAtUserWhenReply: chatConfig.isAtWhenReply,
                allowAvatarTap: chatConfig.isAllowClickAvatar,
                allowLongPress: chatConfig.isAllowLongPressMessage,
                isUseMessageReaction: chatConfig.isUseMessageReaction);
          },
          tongueItemBuilder: widget.tongueItemBuilder,
          initFindingMsg: widget.initFindingMsg,
          messageList: messageList,
          onLoadMore: (String? a, LoadDirection direction, [int? b]) async {
            return await requestForData(a, direction, model, b);
          },
        );
      },
    );
  }
}
