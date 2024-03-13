import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable_for_tencent_im/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/conversation_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

import 'kxim_uikit_conversation_item.dart';
import 'tim_uikit_conversation_last_msg.dart';

typedef KXConversationItemBuilder = Widget Function(
    V2TimConversation conversationItem,
    [V2TimUserStatus? onlineStatus]);

typedef KXConversationSkinBuilder = DecorationImage? Function(
  V2TimConversation conversationItem,
);

typedef KXConversationEnableEndActionCaller = bool Function(
  V2TimConversation conversationItem,
);

typedef KXConversationAvatarBuilder = Widget? Function(
  V2TimConversation conversationItem,
);

typedef KXConversationsFilter = List<V2TimConversation?> Function(
  List<V2TimConversation?> conversations,
);

typedef KXConversationMedalBuilder = Widget? Function(
  V2TimConversation conversationItem,
);

typedef KXConversationItemSlidableBuilder = List<ConversationItemSlidablePanel>
    Function(V2TimConversation conversationItem);

class KXIMUIKitConversation extends StatefulWidget {
  /// 在顶部显示的组件：比如搜索按钮
  final List<Widget> topWidgets;

  /// 会话过滤：可以添加自己需要的操作逻辑：比如把持康讯通知在第一个
  final KXConversationsFilter? cusConversationsFilter;

  /// 会话皮肤
  final KXConversationSkinBuilder? skinBuilder;

  /// 勋章
  final KXConversationMedalBuilder? medalBuilder;

  /// 头像
  final KXConversationAvatarBuilder? avatarBuilder;

  /// 是否允许侧滑操作
  final KXConversationEnableEndActionCaller? enableEndActionCaller;

  /// the callback after clicking conversation item
  final ValueChanged<V2TimConversation>? onTapItem;

  /// conversation controller
  final TIMUIKitConversationController? controller;

  /// the builder for conversation item
  final KXConversationItemBuilder? itembuilder;

  /// the builder for slidable item for each conversation item
  final KXConversationItemSlidableBuilder? itemSlidableBuilder;

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
  /// Also, you have better specifying the `draftText` field for `TIMUIKitChat`, from the `draftText` in `V2TimConversation`,
  /// to meet the identifier shows here.
  final bool isShowDraft;

  final CustomLastMsgBuilder? customLastMsgBuilder;

  const KXIMUIKitConversation({
    Key? key,
    this.lifeCycle,
    this.onTapItem,
    this.controller,
    this.itembuilder,
    this.isShowDraft = true,
    this.itemSlidableBuilder,
    this.conversationCollector,
    this.emptyBuilder,
    this.lastMessageBuilder,
    this.isShowOnlineStatus = true,
    this.topWidgets = const [],
    this.skinBuilder,
    this.medalBuilder,
    this.avatarBuilder,
    this.enableEndActionCaller,
    this.cusConversationsFilter,
    this.customLastMsgBuilder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KXIMUIKitConversationState();
  }
}

class ConversationItemSlidablePanel extends TIMUIKitStatelessWidget {
  ConversationItemSlidablePanel({
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

class _KXIMUIKitConversationState extends TIMUIKitState<KXIMUIKitConversation> {
  final TUIConversationViewModel model =
      serviceLocator<TUIConversationViewModel>();
  late TIMUIKitConversationController _timuiKitConversationController;
  final TUIThemeViewModel themeViewModel = serviceLocator<TUIThemeViewModel>();
  final TUIFriendShipViewModel friendShipViewModel =
      serviceLocator<TUIFriendShipViewModel>();
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
    _timuiKitConversationController.clearHistoryMessage(
        conversation: conversationItem);
  }

  _pinConversation(V2TimConversation conversation) {
    _timuiKitConversationController.pinConversation(
        conversationID: conversation.conversationID,
        isPinned: !conversation.isPinned!);
  }

  _deleteConversation(V2TimConversation conversation) {
    _timuiKitConversationController.deleteConversation(
        conversationID: conversation.conversationID);
  }

  List<ConversationItemSlidablePanel> _defaultSlidableBuilder(
    V2TimConversation conversationItem,
  ) {
    final theme = themeViewModel.theme;
    return [
      if (!PlatformUtils().isWeb)
        ConversationItemSlidablePanel(
          onPressed: (context) {
            _clearHistory(conversationItem);
          },
          backgroundColor: theme.conversationItemSliderClearBgColor ??
              CommonColor.primaryColor,
          foregroundColor: theme.conversationItemSliderTextColor,
          label: TIM_t("清除聊天"),
          spacing: 0,
          autoClose: true,
        ),
      ConversationItemSlidablePanel(
        onPressed: (context) {
          _pinConversation(conversationItem);
        },
        backgroundColor:
            theme.conversationItemSliderPinBgColor ?? CommonColor.infoColor,
        foregroundColor: theme.conversationItemSliderTextColor,
        label: conversationItem.isPinned! ? TIM_t("取消置顶") : TIM_t("置顶"),
      ),
      ConversationItemSlidablePanel(
        onPressed: (context) {
          _deleteConversation(conversationItem);
        },
        backgroundColor:
            theme.conversationItemSliderDeleteBgColor ?? Colors.red,
        foregroundColor: theme.conversationItemSliderTextColor,
        label: TIM_t("删除"),
      )
    ];
  }

  KXConversationItemSlidableBuilder _getSlidableBuilder() {
    return widget.itemSlidableBuilder ?? _defaultSlidableBuilder;
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

  @override
  void dispose() {
    super.dispose();
    // model.dispose();
  }

  List<V2TimConversation?> getFilteredConversation() {
    List<V2TimConversation?> filteredConversationList = model.conversationList
        .where(
            (element) => (element?.groupID != null || element?.userID != null))
        .toList();
    if (widget.conversationCollector != null) {
      filteredConversationList = filteredConversationList
          .where(widget.conversationCollector!)
          .toList();
    }
    if (widget.cusConversationsFilter != null) {
      filteredConversationList = widget.cusConversationsFilter!(
        List.from(filteredConversationList),
      );
    }
    return filteredConversationList;
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: model),
        ChangeNotifierProvider.value(value: friendShipViewModel)
      ],
      builder: (BuildContext context, Widget? w) {
        final _model = Provider.of<TUIConversationViewModel>(context);
        bool haveMoreData = _model.haveMoreData;
        final _friendShipViewModel =
            Provider.of<TUIFriendShipViewModel>(context);
        _model.lifeCycle = widget.lifeCycle;

        List<V2TimConversation?> filteredConversationList =
            getFilteredConversation();

        if (TencentUtils.checkString(_model.scrollToConversation) != null) {
          _onScrollToConversation(_model.scrollToConversation!);
          _model.clearScrollToConversation();
        }

        int childCount =
            widget.topWidgets.length + filteredConversationList.length;

        return SlidableAutoCloseBehavior(
          child: EasyRefresh(
            // header: CustomizeBallPulseHeader(color: theme.primaryColor),
            // onRefresh: () async {
            //   model.refresh();
            // },
            child: childCount > 0
                ? ListView.builder(
                    controller: _autoScrollController,
                    shrinkWrap: true,
                    itemCount: childCount,
                    itemBuilder: (context, index) {
                      if (index < widget.topWidgets.length) {
                        return widget.topWidgets[index];
                      }
                      if (index == childCount - 1) {
                        if (haveMoreData) {
                          _timuiKitConversationController.loadData();
                        }
                      }

                      final conversationIndex =
                          index - widget.topWidgets.length;

                      final conversationItem =
                          filteredConversationList[conversationIndex];

                      final V2TimUserStatus? onlineStatus =
                          _friendShipViewModel.userStatusList.firstWhere(
                              (item) => item.userID == conversationItem?.userID,
                              orElse: () => V2TimUserStatus(statusType: 0));

                      if (widget.itembuilder != null) {
                        return widget.itembuilder!(
                            conversationItem!, onlineStatus);
                      }

                      final slidableChildren =
                          _getSlidableBuilder()(conversationItem!);

                      // 默认就是 true，表示需要支持侧滑事件，如果需要不支持，请明确返回 false
                      final enableEndAction = widget.enableEndActionCaller
                              ?.call(conversationItem) ??
                          true;
                      return AutoScrollTag(
                        key: ValueKey(conversationItem.conversationID),
                        controller: _autoScrollController,
                        index: conversationIndex,
                        child: Slidable(
                          groupTag: 'conversation-list',
                          child: InkWell(
                            child: KXIMUIKitConversationItem(
                                isCurrent: model
                                        .selectedConversation?.conversationID ==
                                    conversationItem.conversationID,
                                isShowDraft: widget.isShowDraft,
                                cusAvatar: widget.avatarBuilder
                                    ?.call(conversationItem),
                                skinImage:
                                    widget.skinBuilder?.call(conversationItem),
                                medal:
                                    widget.medalBuilder?.call(conversationItem),
                                lastMessageBuilder: widget.lastMessageBuilder,
                                customLastMsgBuilder:
                                    widget.customLastMsgBuilder,
                                faceUrl: conversationItem.faceUrl ?? "",
                                nickName: conversationItem.showName ?? "",
                                isDisturb: conversationItem.recvOpt != 0,
                                lastMsg: conversationItem.lastMessage,
                                isPined: conversationItem.isPinned ?? false,
                                groupAtInfoList:
                                    conversationItem.groupAtInfoList ?? [],
                                unreadCount: conversationItem.unreadCount ?? 0,
                                draftText: conversationItem.draftText,
                                onlineStatus: (widget.isShowOnlineStatus &&
                                        conversationItem.userID != null &&
                                        conversationItem.userID!.isNotEmpty)
                                    ? onlineStatus
                                    : null,
                                draftTimestamp: conversationItem.draftTimestamp,
                                convType: conversationItem.type),
                            onTap: () => onTapConvItem(conversationItem),
                          ),
                          endActionPane: enableEndAction
                              ? ActionPane(
                                  extentRatio:
                                      slidableChildren.length > 2 ? 0.77 : 0.5,
                                  motion: const DrawerMotion(),
                                  children: slidableChildren,
                                )
                              : null,
                        ),
                      );
                    },
                  )
                : (widget.emptyBuilder != null
                    ? widget.emptyBuilder!()
                    : Container()),
          ),
        );
      },
    );
  }
}
