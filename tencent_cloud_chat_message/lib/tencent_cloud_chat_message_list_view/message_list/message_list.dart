import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_list/default_builder.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_list/message_list_controller.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_list_view/message_list/position.dart';

const constKeepPositionOffset = 40.0;
const constLargeUnreadIndex = 100000000000;

class TencentCloudChatScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

/// Proudly modified based on https://pub.dev/packages/flutter_chat_list for our needs.
/// Thanks for their contributions.
class MessageList extends StatefulWidget {
  MessageList({
    Key? key,
    this.msgCount = 0,
    required this.onMsgKey,
    required this.itemBuilder,
    this.latestReadMsgKey,
    this.showUnreadMsgButton = true,
    this.unreadMsgCount = 0,
    this.unreadMsgButtonPosition = const Position(right: 16, bottom: 30),
    this.onLoadMsgsByLatestReadMsgKey,
    this.offsetFromUnreadTipToTop = 50,
    this.haveMorePreviousData = false,
    this.haveMoreLatestData = false,
    this.offsetToTriggerLoadPrevious,
    this.offsetToTriggerLoadLatest,
    this.onLoadPreviousMsgs,
    this.onLoadPrevMsgs,
    this.loadPreviousProgressBuilder,
    this.loadLatestProgressBuilder,
    this.showReceivedMsgButton = true,
    this.receivedMsgButtonPosition = const Position(right: 16, bottom: 30),
    this.receivedMsgButtonBuilder,
    this.onIsReceiveMessage,
    this.showScrollToTopButton = true,
    this.offsetToShowScrollToTop = 400,
    this.scrollToTopButtonBuilder,
    this.physics,
    this.scrollBehavior,
    this.onLoadLatestMsgs,
    this.controller,
    this.onLoadToLatest,
    this.listViewController,
    required this.determineIsLatestReadMessage,
    required this.onLoadToLatestReadMessage,
    required this.messagesMentionedMe,
    required this.onLoadToLatestMessageMentionedMe,
    required this.closeSticker,
  }) : super(key: key);

  final Function() closeSticker;

  /// [msgCount] is message count
  /// [onMsgKey] will return the message id
  /// [itemBuilder] is build message widget
  final int msgCount;

  final (bool, bool) Function(int index) determineIsLatestReadMessage;
  final String Function(int index) onMsgKey;
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// [latestReadMsgKey] is the messages last readed
  /// null will be all message is readed
  /// If the latestReadMessage is in [selectedMessages], It mean it should be in current view
  /// else it will be not in list.
  /// Does the widget show last message tip. Click it will jump to last message
  /// But if the last messages is not in current source.
  /// [onLoadMsgsByLatestReadMsgKey] if latestReadMessageKey in [selectedMessages]. just jump to to message.
  /// If it is not in [selectedMessages], [onLoadMsgsByLatestReadMsgKey] will invoke to load. After load, it will also jump to the latest message
  /// When user click scroll to latest unread message. The widget will scroll to the unread item to top by [offsetFromUnreadTipToTop] offset
  final int? latestReadMsgKey;
  final bool showUnreadMsgButton;
  final Position unreadMsgButtonPosition;
  final int? unreadMsgCount;
  final Future Function()? onLoadMsgsByLatestReadMsgKey;
  final double offsetFromUnreadTipToTop;
  final Future<void> Function() onLoadToLatestReadMessage;
  final Future<void> Function() onLoadToLatestMessageMentionedMe;

  /// [haveMorePreviousData] is used to tell widget there are more messages need load in scroll to end
  /// [offsetToTriggerLoadPrevious] is used to tell widget when scroll offset is reach to end by loadNextMessageOffset,
  /// [onLoadPreviousMsgs] function will invoke, null or 0 will not enable automatically invoke load function
  final bool haveMorePreviousData;
  final double? offsetToTriggerLoadPrevious;
  final Future Function()? onLoadPreviousMsgs;
  final Widget Function(BuildContext context, LoadStatus? status)? loadPreviousProgressBuilder;

  final List<V2TimMessage> messagesMentionedMe;
  // If showed mentioned me button, do not show unread message count button again.
  bool isShowedMentionedMeButton = false;

  /// Loadmore in end and loadmore in header
  /// [haveMoreLatestData] is used to tell widget there are more messages need load when scroll to first item
  /// [offsetToTriggerLoadLatest] is used to tell widget when scroll offset is reach to first item by loadPrevMessageOffset,
  /// [onLoadPrevMsgs] function will invoke, null or 0 will not enable automatically invoke load function
  final bool haveMoreLatestData;
  final double? offsetToTriggerLoadLatest;
  final Future Function()? onLoadPrevMsgs;
  final Widget Function(BuildContext context, RefreshStatus? status)? loadLatestProgressBuilder;

  /// The scroll is not in top while user read messages, in this time, new message coming, Does it need should new message coming button
  /// [onIsReceiveMessage] Does it is received message, not send or tip message
  final bool showReceivedMsgButton;
  final Position receivedMsgButtonPosition;
  final Widget Function(BuildContext context, int newCount)? receivedMsgButtonBuilder;
  final bool Function(int index)? onIsReceiveMessage;

  /// [showScrollToTopButton] is true will determine show the scroll to top button
  /// when scroll offset > [offsetToShowScrollToTop], the button will be show up
  final bool showScrollToTopButton;
  final double offsetToShowScrollToTop;
  final Widget Function(BuildContext context)? scrollToTopButtonBuilder;

  final Future Function()? onLoadLatestMsgs;

  /// When jump to top, library will detect whether the [haveMoreLatestData] is true,
  /// If the value is true, invoke [onLoadToLatest] to load first screen messages
  final Future Function()? onLoadToLatest;

  final MessageListController? controller;

  /// Inherit from scrollview
  final ScrollPhysics? physics;
  final ScrollBehavior? scrollBehavior;

  final FlutterListViewController? listViewController;

  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  late FlutterListViewController listViewController;
  final refreshController = RefreshController(initialRefresh: false);
  List<FlutterListViewItemPosition> itemPositions = [];
  int initIndex = 0;
  bool loadingMessagesOnButton = false;
  bool loadingMessageMentionedMe = false;
  bool loadingLatestReadMessage = false;

  /// Fire refresh temp variable
  double prevScrollOffset = 0;
  double? nextBottomScrollOffset;
  bool startScroll = false;

  /// keepPositionOffset will be set to 0 during refresh
  double keepPositionOffset = constKeepPositionOffset;

  /// show move to top
  ValueNotifier<bool> isShowMoveToTop = ValueNotifier<bool>(false);

  /// new message state fields
  ValueNotifier<int> newMessageCount = ValueNotifier<int>(0);
  String? firstNewMessageKey;
  int? firstNewMessageIndex;

  /// last read message state fields
  ValueNotifier<bool> showLastUnreadButton = ValueNotifier<bool>(false);

  int? lastReadMessageKey;
  int? latestUnreadMessageIndex;

  @override
  void initState() {
    listViewController = widget.listViewController ?? FlutterListViewController();
    listViewController.sliverController.onPaintItemPositionsCallback = (widgetHeight, positions) {
      itemPositions = positions;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _determineShowNewMsgCount();
        _determineShowLatestUnreadMsgButton();
      });
    };

    listViewController.addListener(_handleScrolling);

    widget.controller?.mount(this);
    lastReadMessageKey = widget.latestReadMsgKey;
    _handleLastMessageButton(true);

    super.initState();
  }

  /// New message first key
  /// When reach new message, the count will be disppear
  /// For example if new message [{id: 1},{id:2},{id:3}], the key should be 1
  /// if [hasPrevMsgs] is true, widget can calc the count, we need simple increase [newMsgCount]
  notifyNewMessageComing(String firstKey, int newMsgCount) {
    _handleNewMessageComing(firstKey, newMsgCount);
  }

  _handleLastMessageButton(bool forceToInitToTrue) {
    if (widget.showUnreadMsgButton && lastReadMessageKey != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        latestUnreadMessageIndex = constLargeUnreadIndex;
        // var newUnreadMessageIndex = _getLatestUnReadMessageIndex();
        // if (newUnreadMessageIndex != null) {
        //   latestUnreadMessageIndex = newUnreadMessageIndex;
        // }
        if (forceToInitToTrue) {
          showLastUnreadButton.value = true;
        }

        _determineShowLatestUnreadMsgButton();
      });
    } else {
      lastReadMessageKey = null;
      latestUnreadMessageIndex = null;
      if (showLastUnreadButton.value) {
        showLastUnreadButton.value = false;
      }
    }
  }

  _determineShowLatestUnreadMsgButton() {
    if (widget.showUnreadMsgButton && itemPositions.isNotEmpty) {
      if (latestUnreadMessageIndex == null || itemPositions.last.index >= latestUnreadMessageIndex!) {
        lastReadMessageKey = null;
        latestUnreadMessageIndex = null;

        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          if (showLastUnreadButton.value != false) {
            showLastUnreadButton.value = false;
          }
        });
      }
    }
  }

  _handleNewMessageComing(String? firstKey, int? newMsgCountInThisTime) {
    if (widget.showReceivedMsgButton) {
      // Next round to set key
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (firstKey != null) {
          firstNewMessageKey ??= firstKey;
        }

        if (firstNewMessageKey != null) {
          int newMsgCount = 0;
          if (widget.haveMoreLatestData) {
            if (newMsgCountInThisTime != null) {
              newMsgCount = newMessageCount.value + newMsgCountInThisTime;
            } else {
              newMsgCount = newMessageCount.value;
            }

            firstNewMessageIndex = -1;
            for (var i = 0; i < widget.msgCount; i++) {
              if (widget.onMsgKey(i) == firstNewMessageKey) {
                firstNewMessageIndex = i;
                break;
              }
            }
          } else {
            firstNewMessageIndex = null;
            for (var i = 0; i < widget.msgCount; i++) {
              if (widget.onIsReceiveMessage == null || widget.onIsReceiveMessage!(i)) {
                newMsgCount++;

                if (widget.onMsgKey(i) == firstNewMessageKey) {
                  firstNewMessageIndex = i;
                  break;
                }
              }
            }
          }

          newMessageCount.value = newMsgCount;
          _determineShowNewMsgCount();
        }
      });
    } else {
      if (newMessageCount.value != 0) {
        newMessageCount.value = 0;
        firstNewMessageKey = null;
        firstNewMessageIndex = null;
      }
    }
  }

  _determineShowNewMsgCount() {
    if (widget.showReceivedMsgButton && itemPositions.isNotEmpty) {
      if (firstNewMessageIndex == null || itemPositions[0].index <= firstNewMessageIndex!) {
        if (newMessageCount.value != 0) {
          newMessageCount.value = 0;
        }
        firstNewMessageKey = null;
        firstNewMessageIndex = null;
      }
    }
  }

  void _checkAndLoadMoreMessages() {
    TencentCloudChatUtils.debounce("_checkAndLoadMoreMessages", () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          if (listViewController.position.maxScrollExtent <= listViewController.position.viewportDimension &&
              widget.haveMorePreviousData &&
              widget.msgCount > 0 &&
              !startScroll) {
            refreshController.requestLoading(needMove: false);
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    }, duration: const Duration(milliseconds: 200));
  }

  _handleScrolling() {
    if (!startScroll) {
      startScroll = true;
    }
    widget.closeSticker();
    var offset = listViewController.offset;
    ScrollPosition position = listViewController.position;
    var maxScrollExtent = position.maxScrollExtent;

    var loadNextMessageOffset = widget.offsetToTriggerLoadPrevious ?? 0;
    var targetNextOffset = maxScrollExtent - loadNextMessageOffset;

    if (widget.haveMorePreviousData && loadNextMessageOffset > 0.0) {
      if (offset >= targetNextOffset &&
          ((nextBottomScrollOffset == null) || (nextBottomScrollOffset! < targetNextOffset))) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
          if (!refreshController.isLoading) {
            await refreshController.requestLoading(needMove: false);
          }
        });
      }
    }

    nextBottomScrollOffset = offset;

    /// Handle trigger load latest
    final torrentDistance = widget.offsetToTriggerLoadLatest ?? 0.0;
    if (widget.haveMoreLatestData && torrentDistance > 0.0) {
      if (offset <= torrentDistance && prevScrollOffset > torrentDistance) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          if (!refreshController.isRefresh) {
            refreshController.requestRefresh(needMove: false);
          }
        });
      }
    }
    prevScrollOffset = offset;

    var showTop = false;

    /// Handle move to top button display or hide
    if (offset > widget.offsetToShowScrollToTop || widget.haveMoreLatestData) {
      showTop = true;
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      isShowMoveToTop.value = showTop;
    });
  }

  @override
  void didUpdateWidget(covariant MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller?.mount(this);
    if (firstNewMessageKey != null) {
      _handleNewMessageComing(null, null);
    }
    if (oldWidget.latestReadMsgKey != widget.latestReadMsgKey) {
      lastReadMessageKey = widget.latestReadMsgKey;
      _handleLastMessageButton(true);
    } else {
      _handleLastMessageButton(false);
    }
  }

  Future _onLoadPreviousMessages() async {
    if (!widget.haveMorePreviousData) {
      refreshController.loadComplete();
      return;
    }

    try {
      if (widget.onLoadPreviousMsgs != null) {
        await widget.onLoadPreviousMsgs!();
      }

      refreshController.loadComplete();
    } catch (e, s) {
      debugPrint("load more error in chat list lib: $e, $s");
      refreshController.loadFailed();
    }
  }

  Future _onLoadLatestMessages() async {
    if (!widget.haveMoreLatestData) {
      refreshController.refreshCompleted();
      return;
    }

    keepPositionOffset = 0;
    setState(() {});

    try {
      if (widget.onLoadLatestMsgs != null) {
        await widget.onLoadLatestMsgs!();
      }

      refreshController.refreshCompleted();
    } catch (e, s) {
      debugPrint("refresh error in chat list lib: $e, $s");
      refreshController.refreshFailed();
    }

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 50), (() {
        if (mounted) {
          keepPositionOffset = constKeepPositionOffset;
          startScroll = false;
          setState(() {});
        }
      }));
    }
  }

  Future scrollToLatestMessage() async {
    setState(() {
      loadingMessagesOnButton = true;
    });

    if (widget.haveMoreLatestData) {
      if (widget.onLoadToLatest != null) {
        await widget.onLoadToLatest!();
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    setState(() {
      loadingMessagesOnButton = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listViewController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.bounceInOut);
    });
  }

  _scrollToLatestReadMessage() async {
    setState(() {
      loadingLatestReadMessage = true;
    });

    await widget.onLoadToLatestReadMessage();
    await Future.delayed(const Duration(milliseconds: 50));

    setState(() {
      loadingLatestReadMessage = false;
    });
    showLastUnreadButton.value = false;
  }

  _scrollToLatestMessageMentionedMe() async {
    setState(() {
      loadingMessageMentionedMe = true;
    });

    await widget.onLoadToLatestMessageMentionedMe();
    await Future.delayed(const Duration(milliseconds: 50));

    setState(() {
      loadingMessageMentionedMe = false;
    });
  }

  Widget _renderItem(BuildContext context, int index) {
    final (showUnreadTag, direction) = widget.determineIsLatestReadMessage(index);
    if (widget.unreadMsgCount != null && showUnreadTag) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!direction) defaultUnreadMsgTipBuilder(context, index),
                widget.itemBuilder(context, index),
                if (direction) defaultUnreadMsgTipBuilder(context, index),
              ],
            ),
          ),
        ],
      );
    }
    return widget.itemBuilder(context, index);
  }

  _renderList() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndLoadMoreMessages();
    });
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      }),
      child: Scrollbar(
        controller: listViewController,
        thickness: TencentCloudChatPlatformAdapter().isDesktop ? 0 : 4.0,
        radius: const Radius.circular(4.0),
        child: ScrollConfiguration(
          behavior: TencentCloudChatScrollBehavior(),
          child: SmartRefresher(
            enablePullDown: widget.haveMoreLatestData,
            enablePullUp: true,
            footer: CustomFooter(
              height: widget.haveMorePreviousData ? 60 : 16,
              builder: (context, mode) => widget.loadPreviousProgressBuilder != null
                  ? widget.loadPreviousProgressBuilder!(context, mode)
                  : defaultLoadPreviousProgressBuilder(
                      context,
                      mode,
                      widget.haveMorePreviousData,
                    ),
            ),
            controller: refreshController,
            onRefresh: _onLoadLatestMessages,
            onLoading: _onLoadPreviousMessages,
            child: FlutterListView(
              reverse: true,
              controller: listViewController,
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {
                  /*Add this*/
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.unknown,
                },
              ),
              delegate: FlutterListViewDelegate(
                _renderItem,
                childCount: widget.msgCount,
                onItemKey: (index) => widget.onMsgKey(index),
                keepPosition: true,
                keepPositionOffset: keepPositionOffset,
                initIndex: initIndex,
                initOffset: 0,
                initOffsetBasedOnBottom: true,
                firstItemAlign: FirstItemAlign.end,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderUnreadMsgButton() {
    return ValueListenableBuilder(
        valueListenable: showLastUnreadButton,
        builder: (context, bool showButton, child) {
          if (widget.showUnreadMsgButton &&
              showButton &&
              widget.unreadMsgCount != null &&
              widget.messagesMentionedMe.isEmpty &&
              !widget.isShowedMentionedMeButton) {
            return unreadMsgButtonBuilder(
                _scrollToLatestReadMessage, context, widget.unreadMsgCount!, loadingLatestReadMessage);
          }
          return Container();
        });
  }

  Widget _renderMessagesMentionedMeButton() {
    if (widget.messagesMentionedMe.isNotEmpty) {
      widget.isShowedMentionedMeButton = true;
      return messageMentionedMeBuilder(
          _scrollToLatestMessageMentionedMe, context, widget.messagesMentionedMe.length, loadingMessageMentionedMe);
    }
    return Container();
  }

  Widget _renderNewMessagesButtonOrScrollToTop() {
    return ValueListenableBuilder(
      valueListenable: isShowMoveToTop,
      builder: (context, bool showTop, child) => ValueListenableBuilder(
        valueListenable: newMessageCount,
        builder: (context, int newMsgCount, child) {
          Widget? renderWidget;

          if (newMsgCount > 0) {
            if (widget.showReceivedMsgButton) {
              renderWidget = _renderNewMessagesButton(newMsgCount);
            }
          }

          if (renderWidget == null && showTop) {
            if (widget.showScrollToTopButton) {
              renderWidget = _renderScrollToTop();
            }
          }

          renderWidget ??= Container();
          return renderWidget;
        },
      ),
    );
  }

  Widget _renderNewMessagesButton(int newMsgCount) {
    return receivedMsgButtonBuilder(scrollToLatestMessage, context, newMsgCount);
  }

  Widget _renderScrollToTop() {
    return scrollToTopButtonBuilder(scrollToLatestMessage, context, loadingMessagesOnButton);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(top: 0, left: 0, right: 0, bottom: 0, child: _renderList()),
      Positioned(
          top: widget.unreadMsgButtonPosition.top,
          left: widget.unreadMsgButtonPosition.left,
          right: widget.unreadMsgButtonPosition.right,
          bottom: widget.unreadMsgButtonPosition.bottom,
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 20,
            children: [
              _renderUnreadMsgButton(),
              _renderMessagesMentionedMeButton(),
            ],
          )),
      Positioned(
          top: widget.receivedMsgButtonPosition.top,
          left: widget.receivedMsgButtonPosition.left,
          right: widget.receivedMsgButtonPosition.right,
          bottom: widget.receivedMsgButtonPosition.bottom,
          child: _renderNewMessagesButtonOrScrollToTop()),
    ]);
  }

  @override
  void dispose() {
    listViewController.dispose();
    refreshController.dispose();
    isShowMoveToTop.dispose();
    newMessageCount.dispose();
    showLastUnreadButton.dispose();
    super.dispose();
  }
}
