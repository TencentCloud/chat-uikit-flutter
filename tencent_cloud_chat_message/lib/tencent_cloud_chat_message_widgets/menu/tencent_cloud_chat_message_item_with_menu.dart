// ignore_for_file: unused_element

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_column_menu/tencent_cloud_chat_column_menu.dart';
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
  final Stream<TencentCloudChatMessageData<dynamic>>? _messageDataStream =
  TencentCloudChat.instance.eventBusInstance.on<TencentCloudChatMessageData>("TencentCloudChatMessageData");
  late StreamSubscription<TencentCloudChatMessageData<dynamic>>? _messageDataSubscription;

  final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
  String? _selectedText;

  OverlayEntry? _mobileMenuOverlayEntry;
  OverlayEntry? _desktopMenuOverlayEntry;

  final GlobalKey _messageGestureKey = GlobalKey();
  final GlobalKey? _messageKey = null;
  final GlobalKey _selectionAreaKey = GlobalKey();
  final GlobalKey _reactionKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();
  bool _showActions = false;
  double? _menuHeight; // Store the actual menu height
  double? _menuWidth;

  double? _reactionHeight; // Store the actual menu height
  double? _reactionWidth;
  late AnimationController _messageActionsAnimationController;
  late AnimationController _listMessageScaleAnimationController;
  late AnimationController _overlayMessageScaleAnimationController;
  late AnimationController _menuAnimationController;

  late Animation<double> _listMessageScaleAnimation;
  late Animation<double> _menuAnimation;
  late Animation<double> _overlayMessageScaleAnimation;

  String? listenerID;

  List<TencentCloudChatMessageGeneralOptionItem> _menuOptions = [];

  void _messageDataHandler(TencentCloudChatMessageData messageData) {
    final msgID = widget.data.message.msgID ?? "";
    final TencentCloudChatMessageDataKeys messageDataKeys = messageData.currentUpdatedFields;
    final messageNeedUpdate = TencentCloudChat.instance.dataInstance.messageData.messageNeedUpdate;

    switch (messageDataKeys) {
      case TencentCloudChatMessageDataKeys.messageNeedUpdate:
        if (messageNeedUpdate != null && (
              (TencentCloudChatUtils.checkString(msgID) != null && msgID == messageNeedUpdate.msgID) ||
                  (TencentCloudChatUtils.checkString(messageNeedUpdate.id) != null && widget.data.message.id == messageNeedUpdate.id)
        )) {
          if (messageNeedUpdate.status == MessageStatus.V2TIM_MSG_STATUS_LOCAL_REVOKED) {
            if(!isDesktopScreen){
              _closeMobileMenu();
            } else {
              _removeDesktopMenu();
            }
          }
        }
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _addUIKitListener();
    if (isDesktopScreen) {
      if (TencentCloudChatPlatformAdapter().isMobile) {
        _mobileInit();
      }
    } else {
      _mobileInit();
    }

    _messageDataSubscription = _messageDataStream?.listen(_messageDataHandler);
  }

  @override
  void dispose() {
    _removeUIKitListener();
    _messageDataSubscription?.cancel();
    if (!isDesktopScreen) {
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

  void _addUIKitListener() {
    if(widget.data.useMessageReaction){
      listenerID ??= TencentCloudChat.instance.chatSDKInstance.messageSDK.addUIKitListener(listener: _uikitListener);
      return;
    }
  }

  void _removeUIKitListener() {
    if(listenerID != null && widget.data.useMessageReaction){
      TencentCloudChat.instance.chatSDKInstance.messageSDK.removeUIKitListener(listenerID: listenerID!);
    }
  }

  void _uikitListener(Map<String, dynamic> data) {
    if (data.containsKey("eventType")) {
      if (data["eventType"] == "onClickReactionSelector") {
        if (isDesktopScreen) {
          _removeDesktopMenu();
        } else {
          _cancelMobileMessageActions();
        }
      } else if (_showActions && data["eventType"] == "onShowMessageReactionDetail") {
        if (isDesktopScreen) {
          _removeDesktopMenu();
        } else {
          _cancelMobileMessageActions();
        }
      }
    }
  }

  void _closeMobileMenu() {
    safeSetState(() {
      _showActions = false;
    });
    _mobileMenuOverlayEntry?.remove();
    _mobileMenuOverlayEntry = null;
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
  Widget _buildReactionBar({GlobalKey? key}) {
    return TencentCloudChatUtils.checkString(widget.data.message.msgID) != null ? Container(
      color: Colors.transparent,
      key: key,
      child: TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) {
          final Map<String, String> data = {};
          data["msgID"] = widget.data.message.msgID!;
          data["backgroundColor"] = colorTheme.backgroundColor.value.toString();
          data["borderColor"] = colorTheme.dividerColor.value.toString();
          data["platformMode"] = isDesktopScreen ? "desktop" : "mobile";
          return widget.data.messageReactionPluginInstance?.getWidgetSync(
            methodName: "messageReactionSelector",
            data: data,
          ) ?? const SizedBox(
            width: 0,
            height: 0,
          );
        },
      ),
    ) : const SizedBox(
      width: 0,
      height: 0,
    );
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
                  e.onTap();
                },
                child: Container(
                  decoration: (i < menuOptions.length - 1)
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: colorTheme.dividerColor, width: 0.5),
                          ),
                        )
                      : null,
                  padding: EdgeInsets.symmetric(vertical: getSquareSize(8), horizontal: getSquareSize(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.label,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: colorTheme.primaryTextColor.withOpacity(0.94),
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
                                colorTheme.primaryTextColor.withOpacity(0.9),
                                ui.BlendMode.srcIn,
                              ),
                            );
                          }
                          return Image.asset(
                            e.iconAsset!.path,
                            package: e.iconAsset!.package,
                            width: getFontSize(16),
                            height: getFontSize(16),
                            color: colorTheme.primaryTextColor.withOpacity(0.9),
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
                    // boxShadow: const [
                    //   BoxShadow(
                    //     color: Color(0xCCbebebe),
                    //     offset: Offset(2, 2),
                    //     blurRadius: 10,
                    //     spreadRadius: 1,
                    //   ),
                    // ],
                    border: Border.all(
                      width: 1,
                      color: colorTheme.dividerColor,
                    ),
                    color: colorTheme.backgroundColor.withOpacity(0.8),
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

  void _cancelMobileMessageActions() {
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
  }

  void _showMobileMessageActions() {
    if (_mobileMenuOverlayEntry == null) {
      if (_menuHeight == null || _menuWidth == null) {
        // Get the menu height using GlobalKey
        final RenderBox menuBox = _reactionKey.currentContext!.findRenderObject() as RenderBox;
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

      // Calculate the available space and positions for the Message Reaction bar
      double reactionBarHeight = widget.data.useMessageReaction ? 54 : 0;
      double reactionBarWidth = widget.data.useMessageReaction ?  min(800, MediaQuery.of(context).size.width * 0.76) : 0;
      bool showReactionBarAbove = messagePosition.dy - messageOffset > reactionBarHeight + 16;

      double totalHeight = messageBox.size.height + 16 + _menuHeight! + 16 + reactionBarHeight;

      if (!showReactionBarAbove && totalHeight > screenHeight - messagePosition.dy) {
        messageOffset += (reactionBarHeight + 16);
      }

      if (messageOffset == 0) {
        _menuAnimationController.forward();
      }

      double reactionBarTop = showReactionBarAbove ? messagePosition.dy - messageOffset - 16 - reactionBarHeight : messagePosition.dy + messageBox.size.height - messageOffset + 32 + _menuHeight!;

      double menuTop = messagePosition.dy + messageBox.size.height + 16 - messageOffset;

      double menuLeft = textDirection == TextDirection.ltr
          ? ((widget.data.message.isSelf ?? true)
              ? messagePosition.dx + messageBox.size.width - _menuWidth!
              : messagePosition.dx)
          : ((widget.data.message.isSelf ?? true)
              ? messagePosition.dx
              : messagePosition.dx + messageBox.size.width - _menuWidth!);

      double reactionBarLeft = textDirection == TextDirection.ltr
          ? ((widget.data.message.isSelf ?? true)
          ? messagePosition.dx + messageBox.size.width - reactionBarWidth
          : messagePosition.dx)
          : ((widget.data.message.isSelf ?? true)
          ? messagePosition.dx
          : messagePosition.dx + messageBox.size.width - reactionBarWidth);

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
                              _cancelMobileMessageActions();
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
                        Positioned(
                          left: reactionBarLeft,
                          top: reactionBarTop,
                          child: ScaleTransition(
                            scale: _menuAnimation,
                            child: _buildReactionBar(),
                          ),
                        ),
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

  _onLongPressMessageOnMobile() async {
    if (widget.data.isMergeMessage) {
      return;
    }
    if (widget.data.inSelectMode) {
      widget.methods.onSelectMessage();
      return;
    }

    _listMessageScaleAnimationController.forward();
    // show menu
    _showMobileMessageActions();
    // hide keyboard
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: _showActions ? 0 : 1,
          child: GestureDetector(
            key: _messageGestureKey,
            onLongPress: _onLongPressMessageOnMobile,
            child: ScaleTransition(
              scale: _listMessageScaleAnimation,
              child: widget.methods.getMessageItemWidget(
                renderOnMenuPreview: false,
                key: _messageKey,
              ),
            ),
          ),
        ),
        Offstage(
          offstage: true,
          child: _buildMobileMenuWidget(key: _reactionKey),
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

    if (_reactionHeight == null || _reactionWidth == null) {
      // Get the reaction height using GlobalKey
      final RenderBox reactionBox = _reactionKey.currentContext!.findRenderObject() as RenderBox;
      _reactionHeight = reactionBox.size.height;
      _reactionWidth = reactionBox.size.width;
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final tapDetails = tapDownDetails;

    final double menuDx = min(tapDetails.dx, screenWidth - (_menuWidth ?? 100));
    final double menuDy = min(tapDetails.dy as double, screenHeight - (_menuHeight ?? 320)).toDouble();

    final double reactionDx = min(screenWidth - (_reactionWidth ?? 254) , max(tapDetails.dx - (_reactionWidth ?? 254) + _menuWidth, (_reactionWidth ?? 254) + 4));
    final double reactionDy = min((menuDy - (_reactionHeight ?? 50) - 4), max(tapDetails.dy - (_reactionHeight ?? 50) - 4, 8.toDouble()));

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
                    Positioned(left: menuDx, top: menuDy, child: _buildDesktopMenu()),
                    Positioned(left: reactionDx, top: reactionDy, child: _buildReactionBar()),

                  ],
                )));
    Overlay.of(context).insert(_desktopMenuOverlayEntry!);
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
          child: widget.methods.getMessageItemWidget(
            renderOnMenuPreview: false,
            key: _messageKey,
          ),
        ),
        Offstage(
          offstage: true,
          child: _buildDesktopMenu(key: _menuKey),
        ),
        Offstage(
          offstage: true,
          child: _buildReactionBar(key: _reactionKey),
        ),
      ],
    );
  }

  @override
  Widget tabletAppBuilder(BuildContext context) {
    return defaultBuilder(context);
  }
}
