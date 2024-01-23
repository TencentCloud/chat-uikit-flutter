// ignore_for_file: unused_element

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_column_menu/tencent_cloud_chat_column_menu.dart';
import 'package:vibration/vibration.dart';

class TencentCloudChatMessageItemWithMenu extends StatefulWidget {
  final Widget Function({required bool renderOnMenuPreview}) messageItem;
  final bool useMessageReaction;
  final V2TimMessage message;
  final List<TencentCloudChatMessageGeneralOptionItem> menuOptions;
  final bool inSelectMode;
  final VoidCallback onSelectMessage;
  final bool isMergeMessage;

  /// You should close the menu (message actions) once this value changed.
  final int menuCloser;

  const TencentCloudChatMessageItemWithMenu({
    super.key,
    required this.messageItem,
    required this.useMessageReaction,
    required this.message,
    required this.menuOptions,
    required this.menuCloser,
    required this.inSelectMode,
    required this.onSelectMessage,
    required this.isMergeMessage,
  });

  @override
  State<TencentCloudChatMessageItemWithMenu> createState() =>
      _TencentCloudChatMessageItemWithMenuState();
}

class _TencentCloudChatMessageItemWithMenuState
    extends TencentCloudChatState<TencentCloudChatMessageItemWithMenu>
    with TickerProviderStateMixin {
  final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType ==
      DeviceScreenType.desktop;

  OverlayEntry? _mobileMenuOverlayEntry;
  OverlayEntry? _desktopMenuOverlayEntry;

  final GlobalKey _messageKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();
  bool _showActions = false;
  double? _menuHeight; // Store the actual menu height
  double? _menuWidth;
  final bool _reactionBarExpanded =
      false; // Whether the Message Reaction bar is expanded
  late AnimationController _messageActionsAnimationController;
  late AnimationController _listMessageScaleAnimationController;
  late AnimationController _overlayMessageScaleAnimationController;
  late AnimationController _menuAnimationController;

  late Animation<double> _listMessageScaleAnimation;
  late Animation<double> _menuAnimation;
  late Animation<double> _overlayMessageScaleAnimation;
  Timer? _messageTapDownTimer;

  @override
  void initState() {
    super.initState();
    if (isDesktop) {
    } else {
      _mobileInit();
    }
  }

  @override
  void didUpdateWidget(TencentCloudChatMessageItemWithMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (isDesktop) {
    } else {
      if (oldWidget.menuCloser != widget.menuCloser) {
        _menuAnimationController.reverse();
        _messageActionsAnimationController.reverse().then((_) {
          setState(() {
            _showActions = false;
          });
          _mobileMenuOverlayEntry!.remove();
          _mobileMenuOverlayEntry = null;
        });
      }
    }
  }

  @override
  void dispose() {
    if (isDesktop) {
    } else {
      _mobileDispose();
    }
    super.dispose();
  }

  void _mobileInit() {
    _listMessageScaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _messageActionsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _overlayMessageScaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _menuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _messageActionsAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _menuAnimationController.forward();
      } else if (status == AnimationStatus.dismissed) {
        _menuAnimationController.reverse();
      }
    });

    final menuCurve =
        CurvedAnimation(parent: _menuAnimationController, curve: Curves.ease);
    _menuAnimation = Tween<double>(begin: 0, end: 1).animate(menuCurve);
    _listMessageScaleAnimation = Tween<double>(begin: 1.0, end: 0.9)
        .animate(_listMessageScaleAnimationController);
    _overlayMessageScaleAnimation = Tween<double>(begin: 0.9, end: 1)
        .animate(_overlayMessageScaleAnimationController);
  }

  void _mobileDispose() {
    _messageActionsAnimationController.dispose();
    _listMessageScaleAnimationController.dispose();
    _menuAnimationController.dispose();
    _overlayMessageScaleAnimationController.dispose();
  }

  // Function to build the Message Reaction bar
  Widget _buildReactionBar() {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              height: _reactionBarExpanded
                  ? 200
                  : 50, // Adjust height based on _reactionBarExpanded
              color: colorTheme.backgroundColor,
              child: _reactionBarExpanded
                  ? const Column(
                      children: [
                        // Add your 4-row panel content here
                      ],
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.emoji_emotions,
                          size: textStyle.standardLargeText,
                        ),
                        Icon(
                          Icons.emoji_emotions,
                          size: textStyle.standardLargeText,
                        ),
                        Icon(
                          Icons.emoji_emotions,
                          size: textStyle.standardLargeText,
                        ),
                        Icon(
                          Icons.add,
                          size: textStyle.standardLargeText,
                        ),
                      ],
                    ),
            ));
  }

  List<TableRow> _buildMobileMenuItems({
    required TencentCloudChatThemeColors colorTheme,
    required TencentCloudChatTextStyle textStyle,
  }) {
    List<TableRow> menuItems = [];

    for (int i = 0; i < widget.menuOptions.length; i++) {
      final e = widget.menuOptions[i];

      menuItems.add(
        TableRow(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: e.onTap,
                child: Container(
                  decoration: (i < widget.menuOptions.length - 1)
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: colorTheme.dividerColor, width: 0.5),
                          ),
                        )
                      : null,
                  padding: EdgeInsets.all(getSquareSize(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.label,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: colorTheme.primaryTextColor,
                          fontSize: textStyle.standardText,
                        ),
                      ),
                      Icon(
                        e.icon,
                        color: colorTheme.primaryColor,
                        size: getFontSize(16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return menuItems;
  }

  Widget _buildMobileMenuWidget({Key? key}) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: getWidth(200)),
                child: Container(
                  key: key,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xCCbebebe),
                        offset: Offset(2, 2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      width: 1,
                      color: colorTheme.dividerColor,
                    ),
                    color: colorTheme.backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: IntrinsicColumnWidth(),
                    },
                    children: _buildMobileMenuItems(
                        colorTheme: colorTheme, textStyle: textStyle),
                  ),
                ),
              ),
            ));
  }

  void _showMobileMessageActions() {
    if (_mobileMenuOverlayEntry == null) {
      if (_menuHeight == null || _menuWidth == null) {
        // Get the menu height using GlobalKey
        final RenderBox menuBox =
            _menuKey.currentContext!.findRenderObject() as RenderBox;
        _menuHeight = menuBox.size.height;
        _menuWidth = menuBox.size.width;
      }

      final textDirection = Directionality.of(context);

      double screenHeight = MediaQuery.of(context).size.height;
      // double screenWidth = MediaQuery.of(context).size.width;

      RenderBox messageBox = context.findRenderObject() as RenderBox;
      Offset messagePosition = messageBox.localToGlobal(Offset.zero);
      double availableSpace =
          screenHeight - messagePosition.dy - messageBox.size.height - 32;

      double messageOffset = 0;

      if (availableSpace < _menuHeight!) {
        messageOffset = _menuHeight! - availableSpace + 16;
      }

      // TODO: Message Reaction 注意 RTL 适配
      // Calculate the available space and positions for the Message Reaction bar
      // double reactionBarHeight = widget.useMessageReaction ? 40 : 0;
      // bool showReactionBarAbove = messagePosition.dy - messageOffset > reactionBarHeight + 16;
      //
      // double totalHeight = messageBox.size.height + 16 + _menuHeight! + 16 + reactionBarHeight;
      //
      // if (!showReactionBarAbove && totalHeight > screenHeight - messagePosition.dy) {
      //   messageOffset += (reactionBarHeight + 16);
      // }
      //
      // if (messageOffset == 0) {
      //   _menuAnimationController.forward();
      // }
      //
      // double reactionBarTop = showReactionBarAbove ? messagePosition.dy - messageOffset - 16 - reactionBarHeight : messagePosition.dy + messageBox.size.height - messageOffset + 32 + _menuHeight!;

      double menuTop =
          messagePosition.dy + messageBox.size.height + 16 - messageOffset;

      double menuLeft = textDirection == TextDirection.ltr
          ? ((widget.message.isSelf ?? true)
              ? messagePosition.dx + messageBox.size.width - _menuWidth!
              : messagePosition.dx)
          : ((widget.message.isSelf ?? true)
              ? messagePosition.dx
              : messagePosition.dx + messageBox.size.width - _menuWidth!);

      Animation<double> messageTopTween = Tween<double>(
        begin: messagePosition.dy,
        end: messagePosition.dy - messageOffset,
      ).animate(CurvedAnimation(
          parent: _messageActionsAnimationController, curve: Curves.easeOut));

      _mobileMenuOverlayEntry = OverlayEntry(builder: (BuildContext context) {
        return AnimatedBuilder(
            animation: _messageActionsAnimationController,
            builder: (BuildContext context, Widget? child) =>
                TencentCloudChatThemeWidget(
                    build: (context, colorTheme, textStyle) => Stack(
                          children: [
                            AnimatedOpacity(
                              opacity: _messageActionsAnimationController.value,
                              duration:
                                  _messageActionsAnimationController.duration!,
                              child: GestureDetector(
                                onTap: () {
                                  _menuAnimationController.reverse();
                                  _messageActionsAnimationController
                                      .reverse()
                                      .then((_) {
                                    setState(() {
                                      _showActions = false;
                                    });
                                    _mobileMenuOverlayEntry!.remove();
                                    _mobileMenuOverlayEntry = null;
                                  });
                                },
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: messagePosition.dx,
                              top: messageTopTween.value,
                              child: ScaleTransition(
                                alignment: Alignment.topCenter,
                                scale: _overlayMessageScaleAnimation,
                                child: Material(
                                    color: Colors.transparent,
                                    child: SelectionArea(
                                      child: widget.messageItem(
                                        renderOnMenuPreview: true,
                                      ),
                                    )),
                              ),
                            ),
                            Positioned(
                                left: menuLeft,
                                top: menuTop,
                                child: ScaleTransition(
                                  scale: _menuAnimation,
                                  child: _buildMobileMenuWidget(),
                                )),
                            // Positioned(
                            //   left: messagePosition.dx,
                            //   top: reactionBarTop,
                            //   child: ScaleTransition(
                            //     scale: _menuAnimation,
                            //     child: _buildReactionBar(),
                            //   ),
                            // ),
                          ],
                        )));
      });

      setState(() {
        _showActions = true;
      });
      Overlay.of(context).insert(_mobileMenuOverlayEntry!);
      _messageActionsAnimationController.forward();
      _overlayMessageScaleAnimationController.forward(from: 0);
    } else {
      _messageActionsAnimationController.reverse().then((_) {
        setState(() {
          _showActions = false;
        });
        _mobileMenuOverlayEntry!.remove();
        _mobileMenuOverlayEntry = null;
      });
    }
  }

  _onTapDownMessageOnMobile(TapDownDetails details) {
    if (widget.isMergeMessage) {
      return;
    }
    if (widget.inSelectMode) {
      widget.onSelectMessage();
      return true;
    } else {
      _listMessageScaleAnimationController.forward();
      _messageTapDownTimer = Timer(
          _listMessageScaleAnimationController.duration ??
              const Duration(milliseconds: 500), () async {
        if (TencentCloudChatPlatformAdapter().isIOS) {
          final canVibrate = await Haptics.canVibrate();
          if (canVibrate) {
            Haptics.vibrate(HapticsType.medium);
          }
        } else {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 10, amplitude: 10);
          }
        }
        _showMobileMessageActions();
        _messageTapDownTimer = null;
      });
      return true;
    }
  }

  _onTapUpMessageOnMobile([TapUpDetails? details]) {
    if (widget.isMergeMessage) {
      return;
    }
    _messageTapDownTimer?.cancel();
    _listMessageScaleAnimationController.reverse();
    _messageTapDownTimer = null;
    return true;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: _showActions ? 0 : 1,
          child: GestureDetector(
            key: _messageKey,
            onTapDown: _onTapDownMessageOnMobile,
            onTapUp: _onTapUpMessageOnMobile,
            onTapCancel: _onTapUpMessageOnMobile,
            child: ScaleTransition(
              scale: _listMessageScaleAnimation,
              child: widget.messageItem(
                renderOnMenuPreview: false,
              ),
            ),
          ),
        ),
        Offstage(
          offstage: true,
          child: _buildMobileMenuWidget(key: _menuKey),
        ),
      ],
    );
  }

  void _removeDesktopMenu() {
    _desktopMenuOverlayEntry?.remove();
    _desktopMenuOverlayEntry = null;
  }

  void _openDesktopMessageMenu(TapDownDetails tapDownDetails) {
    if (_desktopMenuOverlayEntry != null) {
      _removeDesktopMenu();
    }
    if (_menuHeight == null || _menuWidth == null) {
      // Get the menu height using GlobalKey
      final RenderBox menuBox =
          _menuKey.currentContext!.findRenderObject() as RenderBox;
      _menuHeight = menuBox.size.height;
      _menuWidth = menuBox.size.width;
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final tapDetails = tapDownDetails;
    final double dx =
        min(tapDetails.globalPosition.dx, screenWidth - (_menuWidth ?? 100));
    final double dy =
        min(tapDetails.globalPosition.dy, screenHeight - (_menuHeight ?? 320))
            .toDouble();

    _desktopMenuOverlayEntry = OverlayEntry(
        builder: (context) => TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _removeDesktopMenu();
                      },
                      onSecondaryTap: () {
                        _removeDesktopMenu();
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Positioned(left: dx, top: dy, child: _buildDesktopMenu())
                  ],
                )));
    Overlay.of(context).insert(_desktopMenuOverlayEntry!);
  }

  Widget _buildDesktopMenu({GlobalKey? key}) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => TencentCloudChatColumnMenu(
        key: key,
        data: widget.menuOptions
            .map((e) => ColumnMenuItem(
                  label: e.label,
                  onClick: () {
                    _removeDesktopMenu();
                    e.onTap();
                  },
                  icon: Icon(
                    e.icon,
                    size: textStyle.fontsize_14,
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onSecondaryTapDown: _openDesktopMessageMenu,
          child: widget.messageItem(renderOnMenuPreview: false),
        ),
        Offstage(
          offstage: true,
          child: _buildDesktopMenu(key: _menuKey),
        ),
      ],
    );
  }
}
