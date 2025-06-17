import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/utils/face_manager.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_common/widgets/gesture/tencent_cloud_chat_gesture.dart';
import 'package:tencent_cloud_chat_conversation/model/tencent_cloud_chat_conversation_presenter.dart';

class TencentCloudChatConversationItem extends StatefulWidget {
  final V2TimConversation conversation;
  final bool isOnline;
  final bool isSelected;

  const TencentCloudChatConversationItem({
    super.key,
    required this.conversation,
    required this.isOnline,
    this.isSelected = false,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatConversationItemState();
}

class TencentCloudChatConversationItemState extends TencentCloudChatState<TencentCloudChatConversationItem> {
  final bool useDesktopMode = (TencentCloudChat.instance.dataInstance.conversation.conversationConfig.useDesktopMode) &&
      (TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop);
  TencentCloudChatConversationPresenter conversationPresenter = TencentCloudChatConversationPresenter();

  _navigateToMessage() async {
    final options = TencentCloudChatMessageOptions(
      userID: widget.conversation.groupID == null ? widget.conversation.userID : null,
      groupID: widget.conversation.groupID,
      draftText: widget.conversation.draftText,
    );

    final res = await TencentCloudChat
            .instance.dataInstance.conversation.conversationEventHandlers?.uiEventHandlers.onTapConversationItem
            ?.call(
          conversation: widget.conversation,
          messageOptions: options,
          inDesktopMode: useDesktopMode,
        ) ??
        false;
    if (res) {
      return;
    }

    if (useDesktopMode &&
        TencentCloudChat.instance.dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.message)) {
      // Desktop combined navigator
      TencentCloudChat.instance.dataInstance.conversation.currentConversation = widget.conversation;
    } else if (TencentCloudChat.instance.dataInstance.basic.usedComponents
        .contains(TencentCloudChatComponentsEnum.message)) {
      // Mobile navigator
      navigateToMessage(
        context: context,
        options: options,
      );
    } else {
      // Custom onTap event
    }
  }

  isPin() {
    return widget.conversation.isPinned ?? false;
  }

  _showDesktopMenu(TapDownDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;

    final items = [
      TencentCloudChatMessageGeneralOptionItem(
        label: isPin() ? tL10n.unpin : tL10n.pin,
        onTap: _pinConversation,
      ),
      TencentCloudChatMessageGeneralOptionItem(
        label: tL10n.markAsRead,
        onTap: _markAsRead,
      ),
      TencentCloudChatMessageGeneralOptionItem(
        label: tL10n.hide,
        onTap: _hideConversation,
      ),
      TencentCloudChatMessageGeneralOptionItem(
        label: tL10n.delete,
        onTap: _deleteConversation,
      ),
    ];

    final tapDetails = details;
    final double dy = min(tapDetails.globalPosition.dy, screenHeight - (items.length * 38)).toDouble();

    TencentCloudChatDesktopPopup.showColumnMenu(
      context: context,
      offset: Offset(details.globalPosition.dx + 10, dy),
      items: items,
    );
  }

  _markAsRead({Offset? offset}) {
    TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().cleanConversationUnreadMessageCount(
          conversationID: widget.conversation.conversationID,
          cleanTimestamp: 0,
          cleanSequence: 0,
        );
  }

  showMoreItemAction(
      BuildContext context, TencentCloudChatTextStyle fontSize, TencentCloudChatThemeColors colors) async {
    TextStyle style = TextStyle(
      fontSize: fontSize.fontsize_16,
      fontWeight: FontWeight.w400,
      color: colors.conversationItemMoreActionItemNormalTextColor,
    );
    TextStyle deleteStyle = TextStyle(
      fontSize: fontSize.fontsize_16,
      fontWeight: FontWeight.w400,
      color: colors.conversationItemMoreActionItemDeleteTextColor,
    );
    TextStyle cancelStyle = TextStyle(
      fontSize: fontSize.fontsize_16,
      fontWeight: FontWeight.w600,
      color: colors.conversationItemMoreActionItemNormalTextColor,
    );
    final actions = <BottomSheetAction>[
      BottomSheetAction(
          title: Text(
            tL10n.hide,
            style: style,
          ),
          onPressed: (context) async {
            await _hideConversation();
            hideMoreItemAction();
          }),
      BottomSheetAction(
          title: Text(
            tL10n.delete,
            style: deleteStyle,
          ),
          onPressed: (context) async {
            await _deleteConversation();
            hideMoreItemAction();
          }),
    ];

    if (widget.conversation.unreadCount! > 0) {
      actions.insert(0, BottomSheetAction(
          title: Text(
            tL10n.markAsRead,
            style: style,
          ),
          onPressed: (context) {
            _markAsRead();
            hideMoreItemAction();
          }));
    }

    await showAdaptiveActionSheet(
      context: context,
      title: Text(tL10n.more),
      androidBorderRadius: 30,
      actions: actions,
      cancelAction: CancelAction(
        title: Text(
          tL10n.cancel,
          style: cancelStyle,
        ),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  Widget conversationInner(TencentCloudChatThemeColors colors) {
    bool pinned = isPin();
    final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;

    return Ink(
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(
            width: 1,
            color: Color.fromARGB(8, 0, 0, 0),
          ),
        ),
        color: widget.isSelected
            ? colors.primaryColor.withOpacity(0.05)
            : (pinned ? colors.conversationItemIsPinedBgColor : colors.conversationItemNormalBgColor),
      ),
      child: TencentCloudChatGesture(
        onTap: _navigateToMessage,
        onSecondaryTapDown: isDesktopScreen ? (_) => _showDesktopMenu(_) : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: getHeight(12),
            horizontal: getWidth(8),
          ),
          child: Row(
            children: [
              TencentCloudChat.instance.dataInstance.conversation.conversationBuilder?.getConversationItemAvatarBuilder(
                widget.conversation,
                widget.isOnline,
              ),
              TencentCloudChat.instance.dataInstance.conversation.conversationBuilder
                  ?.getConversationItemContentBuilder(
                widget.conversation,
              ),
              TencentCloudChat.instance.dataInstance.conversation.conversationBuilder?.getConversationItemInfoBuilder(
                widget.conversation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  hideMoreItemAction({Offset? offset}) {
    Navigator.of(context).pop();
  }

  _hideConversation({Offset? offset}) async {
    await TencentCloudChat.instance.chatSDKInstance.manager.getConversationManager().markConversation(
        markType: 8,
        enableMark: true,
        conversationIDList: [widget.conversation.conversationID]);
  }

  _deleteConversation({Offset? offset}) async {
    var result = await conversationPresenter
        .cleanConversation(conversationIDList: [widget.conversation.conversationID], clearMessage: true);

    if (result.code == 0) {
      TencentCloudChat.instance.dataInstance.messageData.clearMessageList(userID: widget.conversation.userID, groupID: widget.conversation.groupID);
    }
  }

  _pinConversation({Offset? offset}) async {
    await TencentCloudChat.instance.chatSDKInstance.conversationSDK.pinConversation(
      conversationID: widget.conversation.conversationID,
      isPinned: isPin() ? false : true,
    );
  }

  bool _isHidden() {
    // V2TIM_CONVERSATION_MARK_TYPE_HIDE = 0x1 << 3
    return widget.conversation.markList?.contains(8) ?? false;
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (ctx, colors, fontSize) => conversationInner(colors),
    );
  }

  @override
  Widget tabletAppBuilder(BuildContext context) {
    return defaultBuilder(context);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return _isHidden() ? const SizedBox() : TencentCloudChatThemeWidget(
      build: (ctx, colors, fontSize) => SwipeActionCell(
        key: ObjectKey(widget.conversation.conversationID),
        trailingActions: <SwipeAction>[
          SwipeAction(
            title: isPin() ? tL10n.unpin : tL10n.pin,
            onTap: (CompletionHandler handler) async {
              await _pinConversation();
            },
            color: colors.conversationItemSwipeActionOneBgColor,
            icon: Icon(
              isPin() ? Icons.vertical_align_bottom_rounded : Icons.vertical_align_top_rounded,
              color: colors.conversationItemSwipeActionOneTextColor,
            ),
            style: TextStyle(
              fontSize: fontSize.fontsize_12,
              color: colors.conversationItemSwipeActionOneTextColor,
            ),
          ),
          SwipeAction(
            title: tL10n.more,
            onTap: (CompletionHandler handler) async {
              await showMoreItemAction(ctx, fontSize, colors);
            },
            color: colors.conversationItemSwipeActionTwoBgColor,
            icon: Icon(
              Icons.expand_circle_down_outlined,
              color: colors.conversationItemSwipeActionTwoTextColor,
            ),
            style: TextStyle(
              fontSize: fontSize.fontsize_12,
              color: colors.conversationItemSwipeActionTwoTextColor,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        child: conversationInner(colors),
      ),
    );
  }
}

class TencentCloudChatConversationItemAvatar extends StatefulWidget {
  final V2TimConversation conversation;
  final bool isOnline;

  const TencentCloudChatConversationItemAvatar({
    super.key,
    required this.conversation,
    required this.isOnline,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatConversationItemAvatarState();
}

class TencentCloudChatConversationItemAvatarState
    extends TencentCloudChatState<TencentCloudChatConversationItemAvatar> {
  List<String> getAvatar() {
    return [widget.conversation.faceUrl ?? ''];
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
    return TencentCloudChatThemeWidget(
      build: (ctx, colors, fonts) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(isDesktop ? 10 : 8),
        ),
        child: SizedBox(
          width: getSquareSize(isDesktop ? 38 : 40),
          height: getSquareSize(isDesktop ? 38 : 40),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                  imageList: getAvatar(),
                  width: getSquareSize(isDesktop ? 38 : 40),
                  height: getSquareSize(isDesktop ? 38 : 40),
                  borderRadius: getSquareSize(isDesktop ? 19 : 20),
                  scene: TencentCloudChatAvatarScene.conversationList,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  width: getSquareSize(isDesktop ? 9 : 10),
                  height: getSquareSize(isDesktop ? 9 : 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isOnline ? colors.conversationItemUserStatusBgColor : Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          getSquareSize(5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TencentCloudChatConversationItemContent extends StatefulWidget {
  final V2TimConversation conversation;

  const TencentCloudChatConversationItemContent({
    super.key,
    required this.conversation,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatConversationItemContentState();
}

class TencentCloudChatConversationItemContentState
    extends TencentCloudChatState<TencentCloudChatConversationItemContent> {
  String getDraftText() {
    String draft = "";
    if (widget.conversation.draftText != null) {
      draft = widget.conversation.draftText!;
    }
    if (draft.isNotEmpty) {
      draft = "[${tL10n.draft}]$draft";
    }
    return draft;
  }

  Widget getLastMessageStatus(TencentCloudChatThemeColors colorTheme) {
    Widget? wid;
    if (widget.conversation.lastMessage != null) {
      var message = widget.conversation.lastMessage!;
      if (message.status == 1) {
        // sending
        wid = Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            Icons.arrow_circle_left,
            size: getSquareSize(14),
            color: colorTheme.conversationItemSendingIconColor,
          ),
        );
      }
      if (message.status == 3) {
        // failed
        wid = Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            Icons.error_rounded,
            size: getSquareSize(14),
            color: colorTheme.conversationItemSendFailedIconColor,
          ),
        );
      }
    }
    wid ??= Container();
    return wid;
  }

  getDraftWidget(TencentCloudChatTextStyle textStyle, TencentCloudChatThemeColors colorTheme) {
    var draft = getDraftText();
    Widget draftWidget = draft.isEmpty
        ? Container()
        : Text(
            draft,
            style: TextStyle(
              color: colorTheme.conversationItemDraftTextColor,
              fontSize: textStyle.fontsize_12,
              fontWeight: FontWeight.w400,
            ),
          );
    return draftWidget;
  }

  getLastMessageWidget(TencentCloudChatTextStyle textStyle, TencentCloudChatThemeColors colorTheme) {
    final laseMessage = widget.conversation.lastMessage;
    String originalText = TencentCloudChatUtils.getMessageSummary(
      message: laseMessage,
      messageReceiveOption: widget.conversation.recvOpt,
      unreadCount: widget.conversation.unreadCount,
      draftText: widget.conversation.draftText,
    );

    String replaceText = FaceManager.emojiMap.keys.fold(originalText, (previous, key) {
      return previous.replaceAll(key, FaceManager.emojiMap[key]!);
    });

    return Expanded(
      child: Text(
        replaceText,
        style: TextStyle(
          fontSize: textStyle.fontsize_12,
          fontWeight: FontWeight.w400,
          color: colorTheme.conversationItemLastMessageTextColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  int? _getShowAtType(List<V2TimGroupAtInfo> mentionedInfoList) {
    // 1 TIM_AT_ME = 1
    // 2 TIM_AT_ALL = 2
    // 3 TIM_AT_ALL_AT_ME = 3
    int? atType;
    if (mentionedInfoList.isNotEmpty) {
      atType = mentionedInfoList.first.atType;
      for (var info in mentionedInfoList.skip(1)) {
        if (info.atType != atType) {
          atType = 3;
          break;
        }
      }
    }

    return atType;
  }

  getGroupAtInfo(TencentCloudChatTextStyle textStyle, TencentCloudChatThemeColors colorTheme) {
    List<Widget> tips = [];

    var style = TextStyle(
      color: colorTheme.conversationItemGroupAtInfoTextColor,
      fontSize: textStyle.fontsize_12,
      fontWeight: FontWeight.w400,
    );
    if (widget.conversation.groupAtInfoList != null) {
      if (widget.conversation.groupAtInfoList!.isNotEmpty) {
        List<V2TimGroupAtInfo> mentionedInfoList = [];

        for (var element in widget.conversation.groupAtInfoList!) {
          if (element != null) {
            mentionedInfoList.add(element);
          }
        }

        int? atType = _getShowAtType(mentionedInfoList);
        if (atType != null) {
          String atTips = '';
          switch (atType) {
            case 1:
              atTips = "[${tL10n.atMeTips}] ";
              break;
            case 2:
              atTips = "[${tL10n.atAllTips}] ";
              break;
            case 3:
              atTips = "[${tL10n.atAllTips}] [${tL10n.atMeTips}] ";
              break;
            default:
              print("error: invalid atType!");
              break;
          }

          if (atTips.isNotEmpty) {
            tips.add(Text(
              atTips,
              style: style,
            ));
          }
        }
      }
    }
    if (tips.isNotEmpty) {
      return Row(
        children: tips,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return Expanded(
      child: TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
        Widget status = getLastMessageStatus(colorTheme);
        Widget draft = getDraftWidget(textStyle, colorTheme);
        Widget lastMessage = getLastMessageWidget(textStyle, colorTheme);
        Widget mentionedInfo = getGroupAtInfo(textStyle, colorTheme);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              widget.conversation.showName ?? widget.conversation.conversationID,
              style: TextStyle(
                fontSize: textStyle.fontsize_13,
                fontWeight: FontWeight.w600,
                color: colorTheme.conversationItemShowNameTextColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: getHeight(4),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                draft,
                status,
                mentionedInfo,
                lastMessage,
              ],
            )
          ],
        );
      }),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Expanded(
      child: TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
        Widget status = getLastMessageStatus(colorTheme);
        Widget draft = getDraftWidget(textStyle, colorTheme);
        Widget lastMessage = getLastMessageWidget(textStyle, colorTheme);
        Widget mentionedInfo = getGroupAtInfo(textStyle, colorTheme);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              widget.conversation.showName ?? widget.conversation.conversationID,
              style: TextStyle(
                fontSize: textStyle.fontsize_14,
                fontWeight: FontWeight.w600,
                color: colorTheme.conversationItemShowNameTextColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                draft,
                status,
                mentionedInfo,
                lastMessage,
              ],
            )
          ],
        );
      }),
    );
  }
}

class TencentCloudChatConversationItemInfoUnreadCount extends StatefulWidget {
  final V2TimConversation conversation;

  const TencentCloudChatConversationItemInfoUnreadCount({super.key, required this.conversation});

  @override
  State<StatefulWidget> createState() => TencentCloudChatConversationItemInfoUnreadCountState();
}

class TencentCloudChatConversationItemInfoUnreadCountState
    extends TencentCloudChatState<TencentCloudChatConversationItemInfoUnreadCount> {
  bool hasUnreadCount() {
    bool has = false;
    if (widget.conversation.unreadCount != null) {
      if (widget.conversation.unreadCount! > 0) {
        has = true;
      }
    }
    return has;
  }

  String unReadCountDisplayText() {
    String text = "";
    int count = widget.conversation.unreadCount ?? 0;
    if (count > 99) {
      text = "99+";
    } else {
      text = "$count";
    }
    return text;
  }

  Widget unreadCountWidget(context, TencentCloudChatThemeColors colorTheme, textStyle) {
    String text = unReadCountDisplayText();
    return Container(
      height: getHeight(16),
      width: text.length == 1 ? getWidth(16) : getWidth(26),
      decoration: BoxDecoration(
        color: colorTheme.conversationItemUnreadCountBgColor,
        borderRadius: BorderRadius.all(
          Radius.circular(
            getSquareSize(8),
          ),
        ),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getFontSize(10),
            fontWeight: FontWeight.w600,
            color: colorTheme.conversationItemUnreadCountTextColor,
          ),
        ),
      ),
    );
  }

  Widget noUnreadPlaceHolderWidget() {
    return SizedBox(
      height: getHeight(16),
    );
  }

  Widget notificationOffWidget(TencentCloudChatThemeColors colorTheme) {
    return Icon(
      Icons.notifications_off,
      size: getSquareSize(14),
      color: colorTheme.conversationItemNoReceiveIconColor,
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    bool hasUnread = hasUnreadCount();
    int receiveOption = widget.conversation.recvOpt ?? 0;
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      if (receiveOption != 0) {
        return notificationOffWidget(colorTheme);
      } else {
        if (hasUnread) {
          return unreadCountWidget(context, colorTheme, textStyle);
        } else {
          return noUnreadPlaceHolderWidget();
        }
      }
    });
  }
}

class TencentCloudChatConversationItemInfoTimeAndStatus extends StatefulWidget {
  final V2TimConversation conversation;

  const TencentCloudChatConversationItemInfoTimeAndStatus({
    super.key,
    required this.conversation,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatConversationItemInfoTimeAndStatusState();
}

class TencentCloudChatConversationItemInfoTimeAndStatusState
    extends TencentCloudChatState<TencentCloudChatConversationItemInfoTimeAndStatus> {
  bool hasLastMessage() {
    return widget.conversation.lastMessage != null;
  }

  String getLastMessageTimeText() {
    String text = '';
    if (widget.conversation.lastMessage != null) {
      if (widget.conversation.lastMessage!.timestamp != null) {
        text = TencentCloudChatIntl.formatTimestampToHumanReadable(
          widget.conversation.lastMessage!.timestamp!,
          context,
        );
      }
    }
    return text;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    String timeText = getLastMessageTimeText();
    if (!hasLastMessage()) {
      return Container();
    }
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            timeText,
            style: TextStyle(
              fontSize: textStyle.fontsize_12,
              fontWeight: FontWeight.w400,
              color: colorTheme.conversationItemTimeTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class TencentCloudChatConversationItemInfo extends StatefulWidget {
  final V2TimConversation conversation;

  const TencentCloudChatConversationItemInfo({
    super.key,
    required this.conversation,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatConversationItemInfoState();
}

class TencentCloudChatConversationItemInfoState extends TencentCloudChatState<TencentCloudChatConversationItemInfo> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return SizedBox(
      width: getWidth(96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TencentCloudChatConversationItemInfoUnreadCount(
            conversation: widget.conversation,
          ),
          TencentCloudChatConversationItemInfoTimeAndStatus(
            conversation: widget.conversation,
          ),
        ],
      ),
    );
  }
}
