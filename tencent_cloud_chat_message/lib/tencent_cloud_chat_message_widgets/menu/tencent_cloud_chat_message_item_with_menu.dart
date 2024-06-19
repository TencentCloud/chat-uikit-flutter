// ignore_for_file: unused_element

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_column_menu/tencent_cloud_chat_column_menu.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/menu/selection_area/tencent_selection_area.dart';
import 'package:vibration/vibration.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/svg.dart';

class TencentCloudChatMessageItemWithMenu extends StatefulWidget {
  final MessageItemMenuBuilderWidgets? widgets;
  final MessageItemMenuBuilderData data;
  final MessageItemMenuBuilderMethods methods;

  const TencentCloudChatMessageItemWithMenu({
    super.key,
    this.widgets,
    required this.data,
    required this.methods,
  });

  @override
  State<TencentCloudChatMessageItemWithMenu> createState() => _TencentCloudChatMessageItemWithMenuState();
}

class _TencentCloudChatMessageItemWithMenuState extends TencentCloudChatState<TencentCloudChatMessageItemWithMenu>
    with TickerProviderStateMixin {
  final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
  String? _selectedText;

  OverlayEntry? _mobileMenuOverlayEntry;
  OverlayEntry? _desktopMenuOverlayEntry;

  final GlobalKey _messageKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();
  bool _showActions = false;
  double? _menuHeight; // Store the actual menu height
  double? _menuWidth;
  final bool _reactionBarExpanded = false; // Whether the Message Reaction bar is expanded
  late AnimationController _messageActionsAnimationController;
  late AnimationController _listMessageScaleAnimationController;
  late AnimationController _overlayMessageScaleAnimationController;
  late AnimationController _menuAnimationController;

  late Animation<double> _listMessageScaleAnimation;
  late Animation<double> _menuAnimation;
  late Animation<double> _overlayMessageScaleAnimation;
  Timer? _messageTapDownTimer;

  List<TencentCloudChatMessageGeneralOptionItem> _menuOptions = [];

  @override
  void initState() {
    super.initState();
    if (isDesktopScreen) {
      if (TencentCloudChatPlatformAdapter().isMobile) {
        _mobileInit();
      }
    } else {
      _mobileInit();
    }
  }

  @override
  void dispose() {
    if (isDesktopScreen) {
    } else {
      _mobileDispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TencentCloudChatMessageItemWithMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newOptions = widget.methods.getMenuOptions(selectedText: _selectedText);
    if (_menuOptions.length != newOptions.length && _menuHeight != null) {
      _menuHeight = null;
    }
    _menuOptions = newOptions;
  }

  void _closeMobileMenu() {
    _menuAnimationController.reverse();
    _messageActionsAnimationController.reverse().then((_) {
      safeSetState(() {
        _showActions = false;
      });
      _mobileMenuOverlayEntry!.remove();
      _mobileMenuOverlayEntry = null;
    });
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

    final menuCurve = CurvedAnimation(parent: _menuAnimationController, curve: Curves.ease);
    _menuAnimation = Tween<double>(begin: 0, end: 1).animate(menuCurve);
    _listMessageScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_listMessageScaleAnimationController);
    _overlayMessageScaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(_overlayMessageScaleAnimationController);
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
              height: _reactionBarExpanded ? 200 : 50, // Adjust height based on _reactionBarExpanded
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

    final menuOptions = widget.methods.getMenuOptions();
    for (int i = 0; i < menuOptions.length; i++) {
      final e = menuOptions[i];

      menuItems.add(
        TableRow(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _closeMobileMenu();
                  Future.delayed(const Duration(milliseconds: 301), () {
                    e.onTap();
                  });
                },
                child: Container(
                  decoration: (i < menuOptions.length - 1)
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: colorTheme.dividerColor, width: 0.5),
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
                      Builder(builder: (ctx) {
                        if (e.iconAsset != null) {
                          final type = e.iconAsset!.path.split(".")[e.iconAsset!.path.split(".").length - 1];
                          if (type == "svg") {
                            return SvgPicture.asset(
                              e.iconAsset!.path,
                              package: e.iconAsset!.package,
                              width: 16,
                              height: 16,
                              colorFilter: ui.ColorFilter.mode(
                                colorTheme.primaryColor,
                                ui.BlendMode.srcIn,
                              ),
                            );
                          }
                          return Image.asset(
                            e.iconAsset!.path,
                            package: e.iconAsset!.package,
                            width: getFontSize(16),
                            height: getFontSize(16),
                            color: colorTheme.primaryColor,
                          );
                        }
                        if (e.icon != null) {
                          return Icon(
                            e.icon,
                            size: getFontSize(16),
                          );
                        }
                        return Container();
                      }),
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
                    children: _buildMobileMenuItems(colorTheme: colorTheme, textStyle: textStyle),
                  ),
                ),
              ),
            ));
  }

  void _showMobileMessageActions() {
    if (_mobileMenuOverlayEntry == null) {
      if (_menuHeight == null || _menuWidth == null) {
        // Get the menu height using GlobalKey
        final RenderBox menuBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
        _menuHeight = menuBox.size.height;
        _menuWidth = menuBox.size.width;
      }

      final textDirection = Directionality.of(context);

      double screenHeight = MediaQuery.of(context).size.height;
      // double screenWidth = MediaQuery.of(context).size.width;

      RenderBox messageBox = context.findRenderObject() as RenderBox;
      Offset messagePosition = messageBox.localToGlobal(Offset.zero);
      Size messageSize = messageBox.size;
      double availableSpace = screenHeight - messagePosition.dy - messageBox.size.height - 32;

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

      double menuTop = messagePosition.dy + messageBox.size.height + 16 - messageOffset;

      double menuLeft = textDirection == TextDirection.ltr
          ? ((widget.data.message.isSelf ?? true)
              ? messagePosition.dx + messageBox.size.width - _menuWidth!
              : messagePosition.dx)
          : ((widget.data.message.isSelf ?? true)
              ? messagePosition.dx
              : messagePosition.dx + messageBox.size.width - _menuWidth!);

      Animation<double> messageTopTween = Tween<double>(
        begin: messagePosition.dy,
        end: messagePosition.dy - messageOffset,
      ).animate(CurvedAnimation(parent: _messageActionsAnimationController, curve: Curves.easeOut));

      _mobileMenuOverlayEntry = OverlayEntry(builder: (BuildContext context) {
        return AnimatedBuilder(
            animation: _messageActionsAnimationController,
            builder: (BuildContext context, Widget? child) => TencentCloudChatThemeWidget(
                build: (context, colorTheme, textStyle) => Stack(
                      children: [
                        AnimatedOpacity(
                          opacity: _messageActionsAnimationController.value,
                          duration: _messageActionsAnimationController.duration!,
                          child: GestureDetector(
                            onTap: () {
                              try {
                                _menuAnimationController.reverse();
                                _messageActionsAnimationController.reverse().then((_) {
                                  safeSetState(() {
                                    _showActions = false;
                                  });
                                  _mobileMenuOverlayEntry!.remove();
                                  _mobileMenuOverlayEntry = null;
                                });
                              } catch (e) {
                                try {
                                  _messageActionsAnimationController.reverse().then((_) {
                                    safeSetState(() {
                                      _showActions = false;
                                    });
                                    _mobileMenuOverlayEntry!.remove();
                                    _mobileMenuOverlayEntry = null;
                                  });
                                } catch (e) {
                                  safeSetState(() {
                                    _showActions = false;
                                  });
                                  _mobileMenuOverlayEntry!.remove();
                                  _mobileMenuOverlayEntry = null;
                                }
                              }
                            },
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: messageSize.width,
                                ),
                                child: SelectionArea(
                                  child: widget.methods.getMessageItemWidget(
                                    renderOnMenuPreview: true,
                                  ),
                                ),
                              ),
                            ),
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

      safeSetState(() {
        _showActions = true;
      });
      Overlay.of(context).insert(_mobileMenuOverlayEntry!);
      _messageActionsAnimationController.forward();
      _overlayMessageScaleAnimationController.forward(from: 0);
    } else {
      _messageActionsAnimationController.reverse().then((_) {
        safeSetState(() {
          _showActions = false;
        });
        _mobileMenuOverlayEntry!.remove();
        _mobileMenuOverlayEntry = null;
      });
    }
  }

  _onTapDownMessageOnMobile(TapDownDetails details) {
    if (widget.data.isMergeMessage) {
      return;
    }
    if (widget.data.inSelectMode) {
      widget.methods.onSelectMessage();
      return true;
    } else {
      _listMessageScaleAnimationController.forward();
      _messageTapDownTimer =
          Timer(_listMessageScaleAnimationController.duration ?? const Duration(milliseconds: 500), () async {
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
    if (widget.data.isMergeMessage) {
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
              child: widget.methods.getMessageItemWidget(
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

  void _openDesktopMessageMenu(tapDownDetails) async {
    if (_desktopMenuOverlayEntry != null) {
      _removeDesktopMenu();
    }
    if (_menuHeight == null || _menuWidth == null) {
      // Get the menu height using GlobalKey
      final RenderBox menuBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
      _menuHeight = menuBox.size.height;
      _menuWidth = menuBox.size.width;
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final tapDetails = tapDownDetails;
    final double dx = min(tapDetails.dx, screenWidth - (_menuWidth ?? 100));
    final double dy = min(tapDetails.dy as double, screenHeight - (_menuHeight ?? 320)).toDouble();

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
    final list = widget.methods.getMenuOptions(selectedText: _selectedText);
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => TencentCloudChatColumnMenu(
        key: key,
        data: list
            .map((e) => TencentCloudChatMessageGeneralOptionItem(
                  label: e.label,
                  onTap: ({Offset? offset}) {
                    _removeDesktopMenu();
                    e.onTap();
                  },
                  iconAsset: e.iconAsset,
                  icon: e.icon,
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return Column(
      children: [
        Listener(
          onPointerDown: (PointerDownEvent event) {
            if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {
              _openDesktopMessageMenu(event.position);
            }
          },
          child: TencentCloudChatSelectionArea(
            onSelectionChanged: (SelectedContent? selectedContent) {
              _selectedText = selectedContent?.plainText;
            },
            contextMenuBuilder: (ctx, selectableRegionState) {
              return Container();
            },
            child: widget.methods.getMessageItemWidget(renderOnMenuPreview: false),
          ),
        ),
        Offstage(
          offstage: true,
          child: _buildDesktopMenu(key: _menuKey),
        ),
      ],
    );
  }

  @override
  Widget tabletAppBuilder(BuildContext context) {
    return defaultBuilder(context);
  }
}
