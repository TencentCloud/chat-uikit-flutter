import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/conversation_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation_item.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';

typedef ConversationItemBuilder = Widget Function(V2TimConversation conversationItem, [V2TimUserStatus? onlineStatus]);

typedef ConversationItemSlideBuilder = List<ConversationItemSlidePanel> Function(V2TimConversation conversationItem);

typedef ConversationItemSecondaryMenuBuilder = Widget Function(V2TimConversation conversationItem, VoidCallback onClose);

class TIMUIKitConversation extends StatefulWidget {
  /// the callback after clicking conversation item
  final ValueChanged<V2TimConversation>? onTapItem;

  /// conversation controller
  final TIMUIKitConversationController? controller;

  /// the builder for conversation item
  final ConversationItemBuilder? itemBuilder;

  /// the builder for Slidable item for each conversation item, shows on narrow screens.
  final ConversationItemSlideBuilder? itemSlideBuilder;

  /// the widget of secondary tap menu for each conversation item, shows on wide screens.
  final ConversationItemSecondaryMenuBuilder? itemSecondaryMenuBuilder;

  /// the widget shows when no conversation exists
  final Widget Function()? emptyBuilder;

  /// the filter for conversation
  final bool Function(V2TimConversation? conversation)? conversationCollector;

  /// the builder for the second line in each conservation item,
  /// usually shows the summary of the last message
  final LastMessageBuilder? lastMessageBuilder;

  /// The life cycle hooks for `TIMUIKitConversation`
  final ConversationLifeCycle? lifeCycle;

  /// Control if shows the online status for each user on its avatar.
  final bool isShowOnlineStatus;

  /// Control if shows the identifier that the conversation has a draft text, inputted in previous.
  final bool isShowDraft;

  const TIMUIKitConversation(
      {Key? key,
      this.lifeCycle,
      this.onTapItem,
      this.controller,
      this.itemSecondaryMenuBuilder,
      this.itemBuilder,
      this.isShowDraft = true,
      this.itemSlideBuilder,
      this.conversationCollector,
      this.emptyBuilder,
      this.lastMessageBuilder,
      this.isShowOnlineStatus = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TIMUIKitConversationState();
  }
}

class ConversationItemSlidePanel extends TIMUIKitStatelessWidget {
  ConversationItemSlidePanel({
    Key? key,
    this.flex = 1,
    this.backgroundColor = Colors.white,
    this.foregroundColor,
    this.autoClose = true,
    required this.onPressed,
    this.icon,
    this.spacing = 4,
    this.label,
  })  : assert(flex > 0),
        assert(icon != null || label != null),
        super(key: key);

  /// {@macro slidable.actions.flex}
  final int flex;

  /// {@macro slidable.actions.backgroundColor}
  final Color backgroundColor;

  /// {@macro slidable.actions.foregroundColor}
  final Color? foregroundColor;

  /// {@macro slidable.actions.autoClose}
  final bool autoClose;

  /// {@macro slidable.actions.onPressed}
  final SlidableActionCallback? onPressed;

  /// An icon to display above the [label].
  final IconData? icon;

  /// The space between [icon] and [label] if both set.
  ///
  /// Defaults to 4.
  final double spacing;

  /// A label to display below the [icon].
  final String? label;

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return SlidableAction(
      onPressed: onPressed,
      flex: flex,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      autoClose: autoClose,
      label: label,
      spacing: spacing,
    );
  }
}

class _TIMUIKitConversationState extends TIMUIKitState<TIMUIKitConversation> {
  final TUIConversationViewModel model = serviceLocator<TUIConversationViewModel>();
  late TIMUIKitConversationController _timuiKitConversationController;
  final TUIThemeViewModel themeViewModel = serviceLocator<TUIThemeViewModel>();
  final TUIFriendShipViewModel friendShipViewModel = serviceLocator<TUIFriendShipViewModel>();
  late AutoScrollController _autoScrollController;

  @override
  void initState() {
    super.initState();
    final controller = getController();
    _timuiKitConversationController = controller;
    _timuiKitConversationController.model = model;
    _autoScrollController = AutoScrollController();
  }

  TIMUIKitConversationController getController() {
    return widget.controller ?? TIMUIKitConversationController();
  }

  void onTapConvItem(V2TimConversation conversation) {
    if (widget.onTapItem != null) {
      widget.onTapItem!(conversation);
    }
    model.setSelectedConversation(conversation);
  }

  _clearHistory(V2TimConversation conversationItem) {
    _timuiKitConversationController.clearHistoryMessage(conversation: conversationItem);
  }

  _pinConversation(V2TimConversation conversation) {
    _timuiKitConversationController.pinConversation(conversationID: conversation.conversationID, isPinned: !conversation.isPinned!);
  }

  _deleteConversation(V2TimConversation conversation) {
    _timuiKitConversationController.deleteConversation(conversationID: conversation.conversationID);
  }

  List<V2TimConversation?> getFilteredConversation() {
    List<V2TimConversation?> filteredConversationList = model.conversationList.where((element) => (element?.groupID != null || element?.userID != null)).toList();
    if (widget.conversationCollector != null) {
      filteredConversationList = filteredConversationList.where(widget.conversationCollector!).toList();
    }
    return filteredConversationList;
  }

  _onScrollToConversation(String conversationID) {
    final msgList = getFilteredConversation();
    bool isFound = false;
    int targetIndex = 1;
    for (int i = msgList.length - 1; i >= 0; i--) {
      final currentConversation = msgList[i];
      if (currentConversation?.conversationID == conversationID) {
        isFound = true;
        targetIndex = i;
        break;
      }
    }

    if (isFound) {
      _autoScrollController.scrollToIndex(
        targetIndex,
        preferPosition: AutoScrollPosition.begin,
      );
    }
  }

  Widget _defaultSecondaryMenu(V2TimConversation conversationItem, VoidCallback onClose) {
    return TUIKitColumnMenu(data: [
      if (!PlatformUtils().isWeb)
        ColumnMenuItem(
            label: TIM_t("清除消息"),
            icon: const Icon(Icons.clear_all, size: 16),
            onClick: () {
              onClose();
              _clearHistory(conversationItem);
            }),
      ColumnMenuItem(
          label: conversationItem.isPinned! ? TIM_t("取消置顶") : TIM_t("置顶"),
          icon: Icon(conversationItem.isPinned! ? Icons.vertical_align_bottom : Icons.vertical_align_top, size: 16),
          onClick: () {
            onClose();
            _pinConversation(conversationItem);
          }),
      ColumnMenuItem(
          label: TIM_t("删除会话"),
          icon: const Icon(Icons.delete_outline, size: 16),
          onClick: () {
            onClose();
            _deleteConversation(conversationItem);
          }),
    ]);
  }

  List<ConversationItemSlidePanel> _defaultSlideBuilder(
    V2TimConversation conversationItem,
  ) {
    final theme = themeViewModel.theme;
    return [
      if (!PlatformUtils().isWeb)
        ConversationItemSlidePanel(
          onPressed: (context) {
            _clearHistory(conversationItem);
          },
          backgroundColor: theme.conversationItemSliderClearBgColor ?? CommonColor.primaryColor,
          foregroundColor: theme.conversationItemSliderTextColor,
          label: TIM_t("清除"),
          spacing: 0,
          autoClose: true,
        ),
      ConversationItemSlidePanel(
        onPressed: (context) {
          _pinConversation(conversationItem);
        },
        backgroundColor: theme.conversationItemSliderPinBgColor ?? CommonColor.infoColor,
        foregroundColor: theme.conversationItemSliderTextColor,
        label: conversationItem.isPinned! ? TIM_t("取消置顶") : TIM_t("置顶"),
      ),
      ConversationItemSlidePanel(
        onPressed: (context) {
          _deleteConversation(conversationItem);
        },
        backgroundColor: theme.conversationItemSliderDeleteBgColor ?? Colors.red,
        foregroundColor: theme.conversationItemSliderTextColor,
        label: TIM_t("删除"),
      )
    ];
  }

  Widget _getSecondaryMenu(V2TimConversation conversation, VoidCallback onClose) {
    if (widget.itemSecondaryMenuBuilder != null) {
      return widget.itemSecondaryMenuBuilder!(conversation, onClose);
    }
    return _defaultSecondaryMenu(conversation, onClose);
  }

  ConversationItemSlideBuilder _getSlideBuilder() {
    return widget.itemSlideBuilder ?? _defaultSlideBuilder;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: model), ChangeNotifierProvider.value(value: friendShipViewModel)],
        builder: (BuildContext context, Widget? w) {
          final _model = Provider.of<TUIConversationViewModel>(context);
          bool haveMoreData = _model.haveMoreData;
          final _friendShipViewModel = Provider.of<TUIFriendShipViewModel>(context);
          _model.lifeCycle = widget.lifeCycle;

          List<V2TimConversation?> filteredConversationList = getFilteredConversation();

          if (TencentUtils.checkString(_model.scrollToConversation) != null) {
            _onScrollToConversation(_model.scrollToConversation!);
            _model.clearScrollToConversation();
          }

          Widget conversationList() {
            return filteredConversationList.isNotEmpty
                ? ListView.builder(
                    controller: _autoScrollController,
                    shrinkWrap: true,
                    itemCount: filteredConversationList.length,
                    itemBuilder: (context, index) {
                      if (index == filteredConversationList.length - 1) {
                        if (haveMoreData) {
                          _timuiKitConversationController.loadData();
                        }
                      }

                      final conversationItem = filteredConversationList[index];

                      final V2TimUserStatus? onlineStatus = _friendShipViewModel.userStatusList.firstWhere((item) => item.userID == conversationItem?.userID, orElse: () => V2TimUserStatus(statusType: 0));

                      if (widget.itemBuilder != null) {
                        return widget.itemBuilder!(conversationItem!, onlineStatus);
                      }

                      final slideChildren = _getSlideBuilder()(conversationItem!);

                      final isCurrent = conversationItem.conversationID == model.selectedConversation?.conversationID;

                      final isPined = conversationItem.isPinned ?? false;

                      Widget conversationLineItem() {
                        return Material(
                          color: (isCurrent && isDesktopScreen)
                              ? theme.conversationItemChooseBgColor
                              : isPined
                                  ? theme.conversationItemPinedBgColor
                                  : theme.conversationItemBgColor,
                          child: GestureDetector(
                            child: TIMUIKitConversationItem(
                                isCurrent: isCurrent,
                                isShowDraft: widget.isShowDraft,
                                lastMessageBuilder: widget.lastMessageBuilder,
                                faceUrl: conversationItem.faceUrl ?? "",
                                nickName: conversationItem.showName ?? "",
                                isDisturb: conversationItem.recvOpt != 0,
                                lastMsg: conversationItem.lastMessage,
                                isPined: isPined,
                                groupAtInfoList: conversationItem.groupAtInfoList ?? [],
                                unreadCount: conversationItem.unreadCount ?? 0,
                                draftText: conversationItem.draftText,
                                onlineStatus: (widget.isShowOnlineStatus && conversationItem.userID != null && conversationItem.userID!.isNotEmpty) ? onlineStatus : null,
                                draftTimestamp: conversationItem.draftTimestamp,
                                convType: conversationItem.type),
                            onTap: () => onTapConvItem(conversationItem),
                          ),
                        );
                      }

                      return TUIKitScreenUtils.getDeviceWidget(
                          context: context,
                          desktopWidget: AutoScrollTag(
                            key: ValueKey(conversationItem.conversationID),
                            controller: _autoScrollController,
                            index: index,
                            child: InkWell(
                              onSecondaryTapDown: (details) {
                                TUIKitWidePopup.showPopupWindow(
                                    operationKey: TUIKitWideModalOperationKey.conversationSecondaryMenu,
                                    isDarkBackground: false,
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    context: context,
                                    offset: Offset(min(details.globalPosition.dx, MediaQuery.of(context).size.width - 80), min(details.globalPosition.dy, MediaQuery.of(context).size.height - 130)),
                                    child: (onClose) => _getSecondaryMenu(conversationItem, onClose));
                              },
                              child: conversationLineItem(),
                            ),
                          ),
                          defaultWidget: AutoScrollTag(
                            key: ValueKey(conversationItem.conversationID),
                            controller: _autoScrollController,
                            index: index,
                            child: Slidable(groupTag: 'conversation-list', child: conversationLineItem(), endActionPane: ActionPane(extentRatio: slideChildren.length > 2 ? 0.77 : 0.5, motion: const DrawerMotion(), children: slideChildren)),
                          ));
                    })
                : (widget.emptyBuilder != null ? widget.emptyBuilder!() : Container());
          }

          return TUIKitScreenUtils.getDeviceWidget(
              context: context,
              defaultWidget: SlidableAutoCloseBehavior(
                child: EasyRefresh(
                  header: CustomizeBallPulseHeader(color: theme.primaryColor),
                  onRefresh: () async {
                    model.refresh();
                  },
                  child: conversationList(),
                ),
              ),
              desktopWidget: Scrollbar(controller: _autoScrollController, child: conversationList()));
        });
  }
}
