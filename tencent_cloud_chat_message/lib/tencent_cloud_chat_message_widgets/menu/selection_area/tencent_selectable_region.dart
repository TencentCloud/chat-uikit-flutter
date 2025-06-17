// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/menu/selection_area/tencent_platform_selectable_region_context_menu_io.dart'
if (dart.library.html) 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/menu/selection_area/tencent_platform_selectable_region_context_menu_web.dart';
import 'package:vector_math/vector_math_64.dart';


// Examples can assume:
// FocusNode _focusNode = FocusNode();
// late GlobalKey key;

const Set<PointerDeviceKind> _kLongPressSelectionDevices = <PointerDeviceKind>{
  PointerDeviceKind.touch,
  PointerDeviceKind.stylus,
  PointerDeviceKind.invertedStylus,
};

// In practice some selectables like widgetspan shift several pixels. So when
// the vertical position diff is within the threshold, compare the horizontal
// position to make the compareScreenOrder function more robust.
const double _kSelectableVerticalComparingThreshold = 3.0;

/// A widget that introduces an area for user selections.
///
/// Flutter widgets are not selectable by default. Wrapping a widget subtree
/// with a [TencentCloudChatSelectableRegion] widget enables selection within that subtree (for
/// example, [Text] widgets automatically look for selectable regions to enable
/// selection). The wrapped subtree can be selected by users using mouse or
/// touch gestures, e.g. users can select widgets by holding the mouse
/// left-click and dragging across widgets, or they can use long press gestures
/// to select words on touch devices.
///
/// A [TencentCloudChatSelectableRegion] widget requires configuration; in particular specific
/// [selectionControls] must be provided.
///
/// The [SelectionArea] widget from the [material] library configures a
/// [TencentCloudChatSelectableRegion] in a platform-specific manner (e.g. using a Material
/// toolbar on Android, a Cupertino toolbar on iOS), and it may therefore be
/// simpler to use that widget rather than using [TencentCloudChatSelectableRegion] directly.
///
/// ## An overview of the selection system.
///
/// Every [Selectable] under the [TencentCloudChatSelectableRegion] can be selected. They form a
/// selection tree structure to handle the selection.
///
/// The [TencentCloudChatSelectableRegion] is a wrapper over [SelectionContainer]. It listens to
/// user gestures and sends corresponding [SelectionEvent]s to the
/// [SelectionContainer] it creates.
///
/// A [SelectionContainer] is a single [Selectable] that handles
/// [SelectionEvent]s on behalf of child [Selectable]s in the subtree. It
/// creates a [SelectionRegistrarScope] with its [SelectionContainer.delegate]
/// to collect child [Selectable]s and sends the [SelectionEvent]s it receives
/// from the parent [SelectionRegistrar] to the appropriate child [Selectable]s.
/// It creates an abstraction for the parent [SelectionRegistrar] as if it is
/// interacting with a single [Selectable].
///
/// The [SelectionContainer] created by [TencentCloudChatSelectableRegion] is the root node of a
/// selection tree. Each non-leaf node in the tree is a [SelectionContainer],
/// and the leaf node is a leaf widget whose render object implements
/// [Selectable]. They are connected through [SelectionRegistrarScope]s created
/// by [SelectionContainer]s.
///
/// Both [SelectionContainer]s and the leaf [Selectable]s need to register
/// themselves to the [SelectionRegistrar] from the
/// [SelectionContainer.maybeOf] if they want to participate in the
/// selection.
///
/// An example selection tree will look like:
///
/// {@tool snippet}
///
/// ```dart
/// MaterialApp(
///   home: SelectableRegion(
///     selectionControls: materialTextSelectionControls,
///     focusNode: _focusNode, // initialized to FocusNode()
///     child: Scaffold(
///       appBar: AppBar(title: const Text('Flutter Code Sample')),
///       body: ListView(
///         children: const <Widget>[
///           Text('Item 0', style: TextStyle(fontSize: 50.0)),
///           Text('Item 1', style: TextStyle(fontSize: 50.0)),
///         ],
///       ),
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
///
///               SelectionContainer
///               (SelectableRegion)
///                  /         \
///                 /           \
///                /             \
///           Selectable          \
///      ("Flutter Code Sample")   \
///                                 \
///                          SelectionContainer
///                              (ListView)
///                              /       \
///                             /         \
///                            /           \
///                     Selectable        Selectable
///                     ("Item 0")         ("Item 1")
///
///
/// ## Making a widget selectable
///
/// Some leaf widgets, such as [Text], have all of the selection logic wired up
/// automatically and can be selected as long as they are under a
/// [TencentCloudChatSelectableRegion].
///
/// To make a custom selectable widget, its render object needs to mix in
/// [Selectable] and implement the required APIs to handle [SelectionEvent]s
/// as well as paint appropriate selection highlights.
///
/// The render object also needs to register itself to a [SelectionRegistrar].
/// For the most cases, one can use [SelectionRegistrant] to auto-register
/// itself with the register returned from [SelectionContainer.maybeOf] as
/// seen in the example below.
///
/// {@tool dartpad}
/// This sample demonstrates how to create an adapter widget that makes any
/// child widget selectable.
///
/// ** See code in examples/api/lib/material/selectable_region/selectable_region.0.dart **
/// {@end-tool}
///
/// ## Complex layout
///
/// By default, the screen order is used as the selection order. If a group of
/// [Selectable]s needs to select differently, consider wrapping them with a
/// [SelectionContainer] to customize its selection behavior.
///
/// {@tool dartpad}
/// This sample demonstrates how to create a [SelectionContainer] that only
/// allows selecting everything or nothing with no partial selection.
///
/// ** See code in examples/api/lib/material/selection_container/selection_container.0.dart **
/// {@end-tool}
///
/// In the case where a group of widgets should be excluded from selection under
/// a [TencentCloudChatSelectableRegion], consider wrapping that group of widgets using
/// [SelectionContainer.disabled].
///
/// {@tool dartpad}
/// This sample demonstrates how to disable selection for a Text in a Column.
///
/// ** See code in examples/api/lib/material/selection_container/selection_container_disabled.0.dart **
/// {@end-tool}
///
/// To create a separate selection system from its parent selection area,
/// wrap part of the subtree with another [TencentCloudChatSelectableRegion]. The selection of the
/// child selection area can not extend past its subtree, and the selection of
/// the parent selection area can not extend inside the child selection area.
///
/// ## Tests
///
/// In a test, a region can be selected either by faking drag events (e.g. using
/// [WidgetTester.dragFrom]) or by sending intents to a widget inside the region
/// that has been given a [GlobalKey], e.g.:
///
/// ```dart
/// Actions.invoke(key.currentContext!, const SelectAllTextIntent(SelectionChangedCause.keyboard));
/// ```
///
/// See also:
///
///  * [SelectionArea], which creates a [TencentCloudChatSelectableRegion] with
///    platform-adaptive selection controls.
///  * [SelectableText], which enables selection on a single run of text.
///  * [SelectionHandler], which contains APIs to handle selection events from the
///    [TencentCloudChatSelectableRegion].
///  * [Selectable], which provides API to participate in the selection system.
///  * [SelectionRegistrar], which [Selectable] needs to subscribe to receive
///    selection events.
///  * [SelectionContainer], which collects selectable widgets in the subtree
///    and provides api to dispatch selection event to the collected widget.
class TencentCloudChatSelectableRegion extends StatefulWidget {
  /// Create a new [TencentCloudChatSelectableRegion] widget.
  ///
  /// The [selectionControls] are used for building the selection handles and
  /// toolbar for mobile devices.
  const TencentCloudChatSelectableRegion({
    super.key,
    this.contextMenuBuilder,
    required this.focusNode,
    required this.selectionControls,
    required this.child,
    this.magnifierConfiguration = TextMagnifierConfiguration.disabled,
    this.onSelectionChanged,
  });

  /// The configuration for the magnifier used with selections in this region.
  ///
  /// By default, [TencentCloudChatSelectableRegion]'s [TextMagnifierConfiguration] is disabled.
  /// For a version of [TencentCloudChatSelectableRegion] that adapts automatically to the
  /// current platform, consider [SelectionArea].
  ///
  /// {@macro flutter.widgets.magnifier.intro}
  final TextMagnifierConfiguration magnifierConfiguration;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode focusNode;

  /// The child widget this selection area applies to.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// {@macro flutter.widgets.EditableText.contextMenuBuilder}
  final TencentCloudChatSelectableRegionContextMenuBuilder? contextMenuBuilder;

  /// The delegate to build the selection handles and toolbar for mobile
  /// devices.
  ///
  /// The [emptyTextSelectionControls] global variable provides a default
  /// [TextSelectionControls] implementation with no controls.
  final TextSelectionControls selectionControls;

  /// Called when the selected content changes.
  final ValueChanged<SelectedContent?>? onSelectionChanged;

  /// Returns the [ContextMenuButtonItem]s representing the buttons in this
  /// platform's default selection menu.
  ///
  /// For example, [TencentCloudChatSelectableRegion] uses this to generate the default buttons
  /// for its context menu.
  ///
  /// See also:
  ///
  /// * [TencentCloudChatSelectableRegionState.contextMenuButtonItems], which gives the
  ///   [ContextMenuButtonItem]s for a specific SelectableRegion.
  /// * [EditableText.getEditableButtonItems], which performs a similar role but
  ///   for content that is both selectable and editable.
  /// * [AdaptiveTextSelectionToolbar], which builds the toolbar itself, and can
  ///   take a list of [ContextMenuButtonItem]s with
  ///   [AdaptiveTextSelectionToolbar.buttonItems].
  /// * [AdaptiveTextSelectionToolbar.getAdaptiveButtons], which builds the button
  ///   Widgets for the current platform given [ContextMenuButtonItem]s.
  static List<ContextMenuButtonItem> getSelectableButtonItems({
    required final SelectionGeometry selectionGeometry,
    required final VoidCallback onCopy,
    required final VoidCallback onSelectAll,
    required final VoidCallback? onShare,
  }) {
    final bool canCopy = selectionGeometry.status == SelectionStatus.uncollapsed;
    final bool canSelectAll = selectionGeometry.hasContent;
    final bool platformCanShare = switch (defaultTargetPlatform) {
      TargetPlatform.android
        => selectionGeometry.status == SelectionStatus.uncollapsed,
      TargetPlatform.macOS
      || TargetPlatform.fuchsia
      || TargetPlatform.linux
      || TargetPlatform.windows
        => false,
      // TODO(bleroux): the share button should be shown on iOS but the share
      // functionality requires some changes on the engine side because, on iPad,
      // it needs an anchor for the popup.
      // See: https://github.com/flutter/flutter/issues/141775.
      TargetPlatform.iOS
        => false,
    };
    final bool canShare = onShare != null && platformCanShare;

    // On Android, the share button is before the select all button.
    final bool showShareBeforeSelectAll = defaultTargetPlatform == TargetPlatform.android;

    // Determine which buttons will appear so that the order and total number is
    // known. A button's position in the menu can slightly affect its
    // appearance.
    return <ContextMenuButtonItem>[
      if (canCopy)
        ContextMenuButtonItem(
          onPressed: onCopy,
          type: ContextMenuButtonType.copy,
        ),
      if (canShare && showShareBeforeSelectAll)
        ContextMenuButtonItem(
          onPressed: onShare,
          type: ContextMenuButtonType.share,
        ),
      if (canSelectAll)
        ContextMenuButtonItem(
          onPressed: onSelectAll,
          type: ContextMenuButtonType.selectAll,
        ),
      if (canShare && !showShareBeforeSelectAll)
        ContextMenuButtonItem(
          onPressed: onShare,
          type: ContextMenuButtonType.share,
        ),
    ];
  }

  @override
  State<StatefulWidget> createState() => TencentCloudChatSelectableRegionState();
}

/// State for a [TencentCloudChatSelectableRegion].
class TencentCloudChatSelectableRegionState extends State<TencentCloudChatSelectableRegion> with TextSelectionDelegate implements SelectionRegistrar {
  late final Map<Type, Action<Intent>> _actions = <Type, Action<Intent>>{
    SelectAllTextIntent: _makeOverridable(_SelectAllAction(this)),
    CopySelectionTextIntent: _makeOverridable(_CopySelectionAction(this)),
    ExtendSelectionToNextWordBoundaryOrCaretLocationIntent: _makeOverridable(_GranularlyExtendSelectionAction<ExtendSelectionToNextWordBoundaryOrCaretLocationIntent>(this, granularity: TextGranularity.word)),
    ExpandSelectionToDocumentBoundaryIntent: _makeOverridable(_GranularlyExtendSelectionAction<ExpandSelectionToDocumentBoundaryIntent>(this, granularity: TextGranularity.document)),
    ExpandSelectionToLineBreakIntent: _makeOverridable(_GranularlyExtendSelectionAction<ExpandSelectionToLineBreakIntent>(this, granularity: TextGranularity.line)),
    ExtendSelectionByCharacterIntent: _makeOverridable(_GranularlyExtendCaretSelectionAction<ExtendSelectionByCharacterIntent>(this, granularity: TextGranularity.character)),
    ExtendSelectionToNextWordBoundaryIntent: _makeOverridable(_GranularlyExtendCaretSelectionAction<ExtendSelectionToNextWordBoundaryIntent>(this, granularity: TextGranularity.word)),
    ExtendSelectionToLineBreakIntent: _makeOverridable(_GranularlyExtendCaretSelectionAction<ExtendSelectionToLineBreakIntent>(this, granularity: TextGranularity.line)),
    ExtendSelectionVerticallyToAdjacentLineIntent: _makeOverridable(_DirectionallyExtendCaretSelectionAction<ExtendSelectionVerticallyToAdjacentLineIntent>(this)),
    ExtendSelectionToDocumentBoundaryIntent: _makeOverridable(_GranularlyExtendCaretSelectionAction<ExtendSelectionToDocumentBoundaryIntent>(this, granularity: TextGranularity.document)),
  };

  final Map<Type, GestureRecognizerFactory> _gestureRecognizers = <Type, GestureRecognizerFactory>{};
  SelectionOverlay? _selectionOverlay;
  final LayerLink _startHandleLayerLink = LayerLink();
  final LayerLink _endHandleLayerLink = LayerLink();
  final LayerLink _toolbarLayerLink = LayerLink();
  final _SelectableRegionContainerDelegate _selectionDelegate = _SelectableRegionContainerDelegate();
  // there should only ever be one selectable, which is the SelectionContainer.
  Selectable? _selectable;

  bool get _hasSelectionOverlayGeometry => _selectionDelegate.value.startSelectionPoint != null
                                        || _selectionDelegate.value.endSelectionPoint != null;

  Orientation? _lastOrientation;
  SelectedContent? _lastSelectedContent;

  /// {@macro flutter.rendering.RenderEditable.lastSecondaryTapDownPosition}
  Offset? lastSecondaryTapDownPosition;

  /// The [SelectionOverlay] that is currently visible on the screen.
  ///
  /// Can be null if there is no visible [SelectionOverlay].
  @visibleForTesting
  SelectionOverlay? get selectionOverlay => _selectionOverlay;

  /// The text processing service used to retrieve the native text processing actions.
  final ProcessTextService _processTextService = DefaultProcessTextService();

  /// The list of native text processing actions provided by the engine.
  final List<ProcessTextAction> _processTextActions = <ProcessTextAction>[];

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChanged);
    _initMouseGestureRecognizer();
    _initTouchGestureRecognizer();
    // Taps and right clicks.
    _gestureRecognizers[TapGestureRecognizer] = GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(debugOwner: this),
          (TapGestureRecognizer instance) {
        instance.onTapUp = (TapUpDetails details) {
          if (defaultTargetPlatform == TargetPlatform.iOS && _positionIsOnActiveSelection(globalPosition: details.globalPosition)) {
            // On iOS when the tap occurs on the previous selection, instead of
            // moving the selection, the context menu will be toggled.
            final bool toolbarIsVisible = _selectionOverlay?.toolbarIsVisible ?? false;
            if (toolbarIsVisible) {
              hideToolbar(false);
            } else {
              _showToolbar(location: details.globalPosition);
            }
          } else {
            hideToolbar();
            _collapseSelectionAt(offset: details.globalPosition);
          }
        };
        instance.onSecondaryTapDown = _handleRightClickDown;
      },
    );
    _initProcessTextActions();
  }

  /// Query the engine to initialize the list of text processing actions to show
  /// in the text selection toolbar.
  Future<void> _initProcessTextActions() async {
    _processTextActions.clear();
    _processTextActions.addAll(await _processTextService.queryTextActions());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        break;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return;
    }

    // Hide the text selection toolbar on mobile when orientation changes.
    final Orientation orientation = MediaQuery.orientationOf(context);
    if (_lastOrientation == null) {
      _lastOrientation = orientation;
      return;
    }
    if (orientation != _lastOrientation) {
      _lastOrientation = orientation;
      hideToolbar(defaultTargetPlatform == TargetPlatform.android);
    }
  }

  @override
  void didUpdateWidget(TencentCloudChatSelectableRegion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChanged);
      widget.focusNode.addListener(_handleFocusChanged);
      if (widget.focusNode.hasFocus != oldWidget.focusNode.hasFocus) {
        _handleFocusChanged();
      }
    }
  }

  Action<T> _makeOverridable<T extends Intent>(Action<T> defaultAction) {
    return Action<T>.overridable(context: context, defaultAction: defaultAction);
  }

  void _handleFocusChanged() {
    if (!widget.focusNode.hasFocus) {
      if (kIsWeb) {
        TencentCloudChatPlatformSelectableRegionContextMenu.detach(_selectionDelegate);
      }
      _clearSelection();
    }
    if (kIsWeb) {
      TencentCloudChatPlatformSelectableRegionContextMenu.attach(_selectionDelegate);
    }
  }

  void _updateSelectionStatus() {
    final SelectionGeometry geometry = _selectionDelegate.value;
    final TextSelection selection = switch (geometry.status) {
      SelectionStatus.uncollapsed || SelectionStatus.collapsed => const TextSelection(baseOffset: 0, extentOffset: 1),
      SelectionStatus.none => const TextSelection.collapsed(offset: 1),
    };
    textEditingValue = TextEditingValue(text: '__', selection: selection);
    if (_hasSelectionOverlayGeometry) {
      _updateSelectionOverlay();
    } else {
      _selectionOverlay?.dispose();
      _selectionOverlay = null;
    }
  }

  // gestures.

  // Converts the details.consecutiveTapCount from a TapAndDrag*Details object,
  // which can grow to be infinitely large, to a value between 1 and the supported
  // max consecutive tap count. The value that the raw count is converted to is
  // based on the default observed behavior on the native platforms.
  //
  // This method should be used in all instances when details.consecutiveTapCount
  // would be used.
  static int _getEffectiveConsecutiveTapCount(int rawCount) {
    const int maxConsecutiveTap = 2;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
        // From observation, these platforms reset their tap count to 0 when
        // the number of consecutive taps exceeds the max consecutive tap supported.
        // For example on Debian Linux with GTK, when going past a triple click,
        // on the fourth click the selection is moved to the precise click
        // position, on the fifth click the word at the position is selected, and
        // on the sixth click the paragraph at the position is selected.
        return rawCount <= maxConsecutiveTap ? rawCount : (rawCount % maxConsecutiveTap == 0 ? maxConsecutiveTap : rawCount % maxConsecutiveTap);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        // From observation, these platforms either hold their tap count at the max
        // consecutive tap supported. For example on macOS, when going past a triple
        // click, the selection should be retained at the paragraph that was first
        // selected on triple click.
        return min(rawCount, maxConsecutiveTap);
    }
  }

  void _initMouseGestureRecognizer() {
    _gestureRecognizers[TapAndPanGestureRecognizer] = GestureRecognizerFactoryWithHandlers<TapAndPanGestureRecognizer>(
          () => TapAndPanGestureRecognizer(debugOwner:this, supportedDevices: <PointerDeviceKind>{ PointerDeviceKind.mouse }),
          (TapAndPanGestureRecognizer instance) {
        instance
          ..onTapDown = _startNewMouseSelectionGesture
          ..onTapUp = _handleMouseTapUp
          ..onDragStart = _handleMouseDragStart
          ..onDragUpdate = _handleMouseDragUpdate
          ..onDragEnd = _handleMouseDragEnd
          ..onCancel = _clearSelection
          ..dragStartBehavior = DragStartBehavior.down;
      },
    );
  }

  void _initTouchGestureRecognizer() {
    _gestureRecognizers[LongPressGestureRecognizer] = GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(debugOwner: this, supportedDevices: _kLongPressSelectionDevices),
          (LongPressGestureRecognizer instance) {
        instance
          ..onLongPressStart = _handleTouchLongPressStart
          ..onLongPressMoveUpdate = _handleTouchLongPressMoveUpdate
          ..onLongPressEnd = _handleTouchLongPressEnd;
      },
    );
  }

  void _startNewMouseSelectionGesture(TapDragDownDetails details) {
    switch (_getEffectiveConsecutiveTapCount(details.consecutiveTapCount)) {
      case 1:
        widget.focusNode.requestFocus();
        hideToolbar();
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.iOS:
            // On mobile platforms the selection is set on tap up.
            break;
          case TargetPlatform.macOS:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            _collapseSelectionAt(offset: details.globalPosition);
        }
      case 2:
        _selectWordAt(offset: details.globalPosition);
    }
    _updateSelectedContentIfNeeded();
  }

  void _handleMouseDragStart(TapDragStartDetails details) {
    switch (_getEffectiveConsecutiveTapCount(details.consecutiveTapCount)) {
      case 1:
        _selectStartTo(offset: details.globalPosition);
    }
    _updateSelectedContentIfNeeded();
  }

  void _handleMouseDragUpdate(TapDragUpdateDetails details) {
    switch (_getEffectiveConsecutiveTapCount(details.consecutiveTapCount)) {
      case 1:
        _selectEndTo(offset: details.globalPosition, continuous: true);
      case 2:
        _selectEndTo(offset: details.globalPosition, continuous: true, textGranularity: TextGranularity.word);
    }
    _updateSelectedContentIfNeeded();
  }

  void _handleMouseDragEnd(TapDragEndDetails details) {
    _finalizeSelection();
    _updateSelectedContentIfNeeded();
  }

  void _handleMouseTapUp(TapDragUpDetails details) {
    switch (_getEffectiveConsecutiveTapCount(details.consecutiveTapCount)) {
      case 1:
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.iOS:
            _collapseSelectionAt(offset: details.globalPosition);
          case TargetPlatform.macOS:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            // On desktop platforms the selection is set on tap down.
            break;
        }
    }
    _updateSelectedContentIfNeeded();
  }

  void _updateSelectedContentIfNeeded() {
    if (_lastSelectedContent?.plainText != _selectable?.getSelectedContent()?.plainText) {
      _lastSelectedContent = _selectable?.getSelectedContent();
      widget.onSelectionChanged?.call(_lastSelectedContent);
    }
  }

  void _handleTouchLongPressStart(LongPressStartDetails details) {
    HapticFeedback.selectionClick();
    widget.focusNode.requestFocus();
    _selectWordAt(offset: details.globalPosition);
    // Platforms besides Android will show the text selection handles when
    // the long press is initiated. Android shows the text selection handles when
    // the long press has ended, usually after a pointer up event is received.
    if (defaultTargetPlatform != TargetPlatform.android) {
      _showHandles();
    }
    _updateSelectedContentIfNeeded();
  }

  void _handleTouchLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _selectEndTo(offset: details.globalPosition, textGranularity: TextGranularity.word);
    _updateSelectedContentIfNeeded();
  }

  void _handleTouchLongPressEnd(LongPressEndDetails details) {
    _finalizeSelection();
    _updateSelectedContentIfNeeded();
    _showToolbar();
    if (defaultTargetPlatform == TargetPlatform.android) {
      _showHandles();
    }
  }

  bool _positionIsOnActiveSelection({required Offset globalPosition}) {
    for (final Rect selectionRect in _selectionDelegate.value.selectionRects) {
      final Matrix4 transform = _selectable!.getTransformTo(null);
      final Rect globalRect = MatrixUtils.transformRect(transform, selectionRect);
      if (globalRect.contains(globalPosition)) {
        return true;
      }
    }
    return false;
  }

  void _handleRightClickDown(TapDownDetails details) {
    final Offset? previousSecondaryTapDownPosition = lastSecondaryTapDownPosition;
    final bool toolbarIsVisible = _selectionOverlay?.toolbarIsVisible ?? false;
    lastSecondaryTapDownPosition = details.globalPosition;
    widget.focusNode.requestFocus();
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
        // If lastSecondaryTapDownPosition is within the current selection then
        // keep the current selection, if not then collapse it.
        final bool lastSecondaryTapDownPositionWasOnActiveSelection = _positionIsOnActiveSelection(globalPosition: details.globalPosition);
        if (!lastSecondaryTapDownPositionWasOnActiveSelection) {
          _collapseSelectionAt(offset: lastSecondaryTapDownPosition!);
        }
        _showHandles();
        _showToolbar(location: lastSecondaryTapDownPosition);
      case TargetPlatform.iOS:
        _selectWordAt(offset: lastSecondaryTapDownPosition!);
        _showHandles();
        _showToolbar(location: lastSecondaryTapDownPosition);
      case TargetPlatform.macOS:
        if (previousSecondaryTapDownPosition == lastSecondaryTapDownPosition && toolbarIsVisible) {
          hideToolbar();
          return;
        }
        _showHandles();
        _showToolbar(location: lastSecondaryTapDownPosition);
      case TargetPlatform.linux:
        if (toolbarIsVisible) {
          hideToolbar();
          return;
        }
        // If lastSecondaryTapDownPosition is within the current selection then
        // keep the current selection, if not then collapse it.
        final bool lastSecondaryTapDownPositionWasOnActiveSelection = _positionIsOnActiveSelection(globalPosition: details.globalPosition);
        if (!lastSecondaryTapDownPositionWasOnActiveSelection) {
          _collapseSelectionAt(offset: lastSecondaryTapDownPosition!);
        }
        _showHandles();
        _showToolbar(location: lastSecondaryTapDownPosition);
    }
    _updateSelectedContentIfNeeded();
  }

  // Selection update helper methods.

  Offset? _selectionEndPosition;
  bool get _userDraggingSelectionEnd => _selectionEndPosition != null;
  bool _scheduledSelectionEndEdgeUpdate = false;

  /// Sends end [SelectionEdgeUpdateEvent] to the selectable subtree.
  ///
  /// If the selectable subtree returns a [SelectionResult.pending], this method
  /// continues to send [SelectionEdgeUpdateEvent]s every frame until the result
  /// is not pending or users end their gestures.
  void _triggerSelectionEndEdgeUpdate({TextGranularity? textGranularity}) {
    // This method can be called when the drag is not in progress. This can
    // happen if the child scrollable returns SelectionResult.pending, and
    // the selection area scheduled a selection update for the next frame, but
    // the drag is lifted before the scheduled selection update is run.
    if (_scheduledSelectionEndEdgeUpdate || !_userDraggingSelectionEnd) {
      return;
    }
    if (_selectable?.dispatchSelectionEvent(
        SelectionEdgeUpdateEvent.forEnd(globalPosition: _selectionEndPosition!, granularity: textGranularity)) == SelectionResult.pending) {
      _scheduledSelectionEndEdgeUpdate = true;
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (!_scheduledSelectionEndEdgeUpdate) {
          return;
        }
        _scheduledSelectionEndEdgeUpdate = false;
        _triggerSelectionEndEdgeUpdate(textGranularity: textGranularity);
      }, debugLabel: 'SelectableRegion.endEdgeUpdate');
      return;
    }
 }

 void _onAnyDragEnd(DragEndDetails details) {
   if (widget.selectionControls is! TextSelectionHandleControls) {
    _selectionOverlay!.hideMagnifier();
    _selectionOverlay!.showToolbar();
   } else {
     _selectionOverlay!.hideMagnifier();
     _selectionOverlay!.showToolbar(
       context: context,
       contextMenuBuilder: (BuildContext context) {
         return widget.contextMenuBuilder!(context, this);
       },
     );
   }
  _stopSelectionStartEdgeUpdate();
  _stopSelectionEndEdgeUpdate();
  _updateSelectedContentIfNeeded();
 }

  void _stopSelectionEndEdgeUpdate() {
    _scheduledSelectionEndEdgeUpdate = false;
    _selectionEndPosition = null;
  }

  Offset? _selectionStartPosition;
  bool get _userDraggingSelectionStart => _selectionStartPosition != null;
  bool _scheduledSelectionStartEdgeUpdate = false;

  /// Sends start [SelectionEdgeUpdateEvent] to the selectable subtree.
  ///
  /// If the selectable subtree returns a [SelectionResult.pending], this method
  /// continues to send [SelectionEdgeUpdateEvent]s every frame until the result
  /// is not pending or users end their gestures.
  void _triggerSelectionStartEdgeUpdate({TextGranularity? textGranularity}) {
    // This method can be called when the drag is not in progress. This can
    // happen if the child scrollable returns SelectionResult.pending, and
    // the selection area scheduled a selection update for the next frame, but
    // the drag is lifted before the scheduled selection update is run.
    if (_scheduledSelectionStartEdgeUpdate || !_userDraggingSelectionStart) {
      return;
    }
    if (_selectable?.dispatchSelectionEvent(
        SelectionEdgeUpdateEvent.forStart(globalPosition: _selectionStartPosition!, granularity: textGranularity)) == SelectionResult.pending) {
      _scheduledSelectionStartEdgeUpdate = true;
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (!_scheduledSelectionStartEdgeUpdate) {
          return;
        }
        _scheduledSelectionStartEdgeUpdate = false;
        _triggerSelectionStartEdgeUpdate(textGranularity: textGranularity);
      }, debugLabel: 'SelectableRegion.startEdgeUpdate');
      return;
    }
  }

  void _stopSelectionStartEdgeUpdate() {
    _scheduledSelectionStartEdgeUpdate = false;
    _selectionEndPosition = null;
  }

  // SelectionOverlay helper methods.

  late Offset _selectionStartHandleDragPosition;
  late Offset _selectionEndHandleDragPosition;

  void _handleSelectionStartHandleDragStart(DragStartDetails details) {
    assert(_selectionDelegate.value.startSelectionPoint != null);

    final Offset localPosition = _selectionDelegate.value.startSelectionPoint!.localPosition;
    final Matrix4 globalTransform = _selectable!.getTransformTo(null);
    _selectionStartHandleDragPosition = MatrixUtils.transformPoint(globalTransform, localPosition);

    _selectionOverlay!.showMagnifier(_buildInfoForMagnifier(
      details.globalPosition,
      _selectionDelegate.value.startSelectionPoint!,
    ));
    _updateSelectedContentIfNeeded();
  }

  void _handleSelectionStartHandleDragUpdate(DragUpdateDetails details) {
    _selectionStartHandleDragPosition = _selectionStartHandleDragPosition + details.delta;
    // The value corresponds to the paint origin of the selection handle.
    // Offset it to the center of the line to make it feel more natural.
    _selectionStartPosition = _selectionStartHandleDragPosition - Offset(0, _selectionDelegate.value.startSelectionPoint!.lineHeight / 2);
    _triggerSelectionStartEdgeUpdate();

    _selectionOverlay!.updateMagnifier(_buildInfoForMagnifier(
      details.globalPosition,
      _selectionDelegate.value.startSelectionPoint!,
    ));
    _updateSelectedContentIfNeeded();
  }

  void _handleSelectionEndHandleDragStart(DragStartDetails details) {
    assert(_selectionDelegate.value.endSelectionPoint != null);
    final Offset localPosition = _selectionDelegate.value.endSelectionPoint!.localPosition;
    final Matrix4 globalTransform = _selectable!.getTransformTo(null);
    _selectionEndHandleDragPosition = MatrixUtils.transformPoint(globalTransform, localPosition);

    _selectionOverlay!.showMagnifier(_buildInfoForMagnifier(
      details.globalPosition,
      _selectionDelegate.value.endSelectionPoint!,
    ));
    _updateSelectedContentIfNeeded();
  }

  void _handleSelectionEndHandleDragUpdate(DragUpdateDetails details) {
    _selectionEndHandleDragPosition = _selectionEndHandleDragPosition + details.delta;
    // The value corresponds to the paint origin of the selection handle.
    // Offset it to the center of the line to make it feel more natural.
    _selectionEndPosition = _selectionEndHandleDragPosition - Offset(0, _selectionDelegate.value.endSelectionPoint!.lineHeight / 2);
    _triggerSelectionEndEdgeUpdate();

    _selectionOverlay!.updateMagnifier(_buildInfoForMagnifier(
      details.globalPosition,
      _selectionDelegate.value.endSelectionPoint!,
    ));
    _updateSelectedContentIfNeeded();
  }

  MagnifierInfo _buildInfoForMagnifier(Offset globalGesturePosition, SelectionPoint selectionPoint) {
      final Vector3 globalTransform = _selectable!.getTransformTo(null).getTranslation();
      final Offset globalTransformAsOffset = Offset(globalTransform.x, globalTransform.y);
      final Offset globalSelectionPointPosition = selectionPoint.localPosition + globalTransformAsOffset;
      final Rect caretRect = Rect.fromLTWH(
        globalSelectionPointPosition.dx,
        globalSelectionPointPosition.dy - selectionPoint.lineHeight,
        0,
        selectionPoint.lineHeight
      );

      return MagnifierInfo(
        globalGesturePosition: globalGesturePosition,
        caretRect: caretRect,
        fieldBounds: globalTransformAsOffset & _selectable!.size,
        currentLineBoundaries: globalTransformAsOffset & _selectable!.size,
      );
  }

  void _createSelectionOverlay() {
    assert(_hasSelectionOverlayGeometry);
    if (_selectionOverlay != null) {
      return;
    }
    final SelectionPoint? start = _selectionDelegate.value.startSelectionPoint;
    final SelectionPoint? end = _selectionDelegate.value.endSelectionPoint;
    _selectionOverlay = SelectionOverlay(
      context: context,
      debugRequiredFor: widget,
      startHandleType: start?.handleType ?? TextSelectionHandleType.left,
      lineHeightAtStart: start?.lineHeight ?? end!.lineHeight,
      onStartHandleDragStart: _handleSelectionStartHandleDragStart,
      onStartHandleDragUpdate: _handleSelectionStartHandleDragUpdate,
      onStartHandleDragEnd: _onAnyDragEnd,
      endHandleType: end?.handleType ?? TextSelectionHandleType.right,
      lineHeightAtEnd: end?.lineHeight ?? start!.lineHeight,
      onEndHandleDragStart: _handleSelectionEndHandleDragStart,
      onEndHandleDragUpdate: _handleSelectionEndHandleDragUpdate,
      onEndHandleDragEnd: _onAnyDragEnd,
      selectionEndpoints: selectionEndpoints,
      selectionControls: widget.selectionControls,
      selectionDelegate: this,
      clipboardStatus: null,
      startHandleLayerLink: _startHandleLayerLink,
      endHandleLayerLink: _endHandleLayerLink,
      toolbarLayerLink: _toolbarLayerLink,
      magnifierConfiguration: widget.magnifierConfiguration
    );
  }

  void _updateSelectionOverlay() {
    if (_selectionOverlay == null) {
      return;
    }
    assert(_hasSelectionOverlayGeometry);
    final SelectionPoint? start = _selectionDelegate.value.startSelectionPoint;
    final SelectionPoint? end = _selectionDelegate.value.endSelectionPoint;
    _selectionOverlay!
      ..startHandleType = start?.handleType ?? TextSelectionHandleType.left
      ..lineHeightAtStart = start?.lineHeight ?? end!.lineHeight
      ..endHandleType = end?.handleType ?? TextSelectionHandleType.right
      ..lineHeightAtEnd = end?.lineHeight ?? start!.lineHeight
      ..selectionEndpoints = selectionEndpoints;
  }

  /// Shows the selection handles.
  ///
  /// Returns true if the handles are shown, false if the handles can't be
  /// shown.
  bool _showHandles() {
    if (_selectionOverlay != null) {
      _selectionOverlay!.showHandles();
      return true;
    }

    if (!_hasSelectionOverlayGeometry) {
      return false;
    }

    _createSelectionOverlay();
    _selectionOverlay!.showHandles();
    return true;
  }

  /// Shows the text selection toolbar.
  ///
  /// If the parameter `location` is set, the toolbar will be shown at the
  /// location. Otherwise, the toolbar location will be calculated based on the
  /// handles' locations. The `location` is in the coordinates system of the
  /// [Overlay].
  ///
  /// Returns true if the toolbar is shown, false if the toolbar can't be shown.
  bool _showToolbar({Offset? location}) {
    if (!_hasSelectionOverlayGeometry && _selectionOverlay == null) {
      return false;
    }

    // Web is using native dom elements to enable clipboard functionality of the
    // context menu: copy, paste, select, cut. It might also provide additional
    // functionality depending on the browser (such as translate). Due to this,
    // we should not show a Flutter toolbar for the editable text elements
    // unless the browser's context menu is explicitly disabled.
    if (kIsWeb && BrowserContextMenu.enabled) {
      return false;
    }

    if (_selectionOverlay == null) {
      _createSelectionOverlay();
    }

    _selectionOverlay!.toolbarLocation = location;
    if (widget.selectionControls is! TextSelectionHandleControls) {
      _selectionOverlay!.showToolbar();
      return true;
    }

    _selectionOverlay!.hideToolbar();

    _selectionOverlay!.showToolbar(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder!(context, this);
      },
    );
    return true;
  }

  /// Sets or updates selection end edge to the `offset` location.
  ///
  /// A selection always contains a select start edge and selection end edge.
  /// They can be created by calling both [_selectStartTo] and [_selectEndTo], or
  /// use other selection APIs, such as [_selectWordAt] or [selectAll].
  ///
  /// This method sets or updates the selection end edge by sending
  /// [SelectionEdgeUpdateEvent]s to the child [Selectable]s.
  ///
  /// If `continuous` is set to true and the update causes scrolling, the
  /// method will continue sending the same [SelectionEdgeUpdateEvent]s to the
  /// child [Selectable]s every frame until the scrolling finishes or a
  /// [_finalizeSelection] is called.
  ///
  /// The `continuous` argument defaults to false.
  ///
  /// The `offset` is in global coordinates.
  ///
  /// Provide the `textGranularity` if the selection should not move by the default
  /// [TextGranularity.character]. Only [TextGranularity.character] and
  /// [TextGranularity.word] are currently supported.
  ///
  /// See also:
  ///  * [_selectStartTo], which sets or updates selection start edge.
  ///  * [_finalizeSelection], which stops the `continuous` updates.
  ///  * [_clearSelection], which clears the ongoing selection.
  ///  * [_selectWordAt], which selects a whole word at the location.
  ///  * [_collapseSelectionAt], which collapses the selection at the location.
  ///  * [selectAll], which selects the entire content.
  void _selectEndTo({required Offset offset, bool continuous = false, TextGranularity? textGranularity}) {
    if (!continuous) {
      _selectable?.dispatchSelectionEvent(SelectionEdgeUpdateEvent.forEnd(globalPosition: offset, granularity: textGranularity));
      return;
    }
    if (_selectionEndPosition != offset) {
      _selectionEndPosition = offset;
      _triggerSelectionEndEdgeUpdate(textGranularity: textGranularity);
    }
  }

  /// Sets or updates selection start edge to the `offset` location.
  ///
  /// A selection always contains a select start edge and selection end edge.
  /// They can be created by calling both [_selectStartTo] and [_selectEndTo], or
  /// use other selection APIs, such as [_selectWordAt] or [selectAll].
  ///
  /// This method sets or updates the selection start edge by sending
  /// [SelectionEdgeUpdateEvent]s to the child [Selectable]s.
  ///
  /// If `continuous` is set to true and the update causes scrolling, the
  /// method will continue sending the same [SelectionEdgeUpdateEvent]s to the
  /// child [Selectable]s every frame until the scrolling finishes or a
  /// [_finalizeSelection] is called.
  ///
  /// The `continuous` argument defaults to false.
  ///
  /// The `offset` is in global coordinates.
  ///
  /// Provide the `textGranularity` if the selection should not move by the default
  /// [TextGranularity.character]. Only [TextGranularity.character] and
  /// [TextGranularity.word] are currently supported.
  ///
  /// See also:
  ///  * [_selectEndTo], which sets or updates selection end edge.
  ///  * [_finalizeSelection], which stops the `continuous` updates.
  ///  * [_clearSelection], which clears the ongoing selection.
  ///  * [_selectWordAt], which selects a whole word at the location.
  ///  * [_collapseSelectionAt], which collapses the selection at the location.
  ///  * [selectAll], which selects the entire content.
  void _selectStartTo({required Offset offset, bool continuous = false, TextGranularity? textGranularity}) {
    if (!continuous) {
      _selectable?.dispatchSelectionEvent(SelectionEdgeUpdateEvent.forStart(globalPosition: offset, granularity: textGranularity));
      return;
    }
    if (_selectionStartPosition != offset) {
      _selectionStartPosition = offset;
      _triggerSelectionStartEdgeUpdate(textGranularity: textGranularity);
    }
  }

  /// Collapses the selection at the given `offset` location.
  ///
  /// See also:
  ///  * [_selectStartTo], which sets or updates selection start edge.
  ///  * [_selectEndTo], which sets or updates selection end edge.
  ///  * [_finalizeSelection], which stops the `continuous` updates.
  ///  * [_clearSelection], which clears the ongoing selection.
  ///  * [_selectWordAt], which selects a whole word at the location.
  ///  * [selectAll], which selects the entire content.
  void _collapseSelectionAt({required Offset offset}) {
    _selectStartTo(offset: offset);
    _selectEndTo(offset: offset);
  }

  /// Selects a whole word at the `offset` location.
  ///
  /// If the whole word is already in the current selection, selection won't
  /// change. One call [_clearSelection] first if the selection needs to be
  /// updated even if the word is already covered by the current selection.
  ///
  /// One can also use [_selectEndTo] or [_selectStartTo] to adjust the selection
  /// edges after calling this method.
  ///
  /// See also:
  ///  * [_selectStartTo], which sets or updates selection start edge.
  ///  * [_selectEndTo], which sets or updates selection end edge.
  ///  * [_finalizeSelection], which stops the `continuous` updates.
  ///  * [_clearSelection], which clears the ongoing selection.
  ///  * [_collapseSelectionAt], which collapses the selection at the location.
  ///  * [selectAll], which selects the entire content.
  void _selectWordAt({required Offset offset}) {
    // There may be other selection ongoing.
    _finalizeSelection();
    _selectable?.dispatchSelectionEvent(SelectWordSelectionEvent(globalPosition: offset));
  }

  /// Stops any ongoing selection updates.
  ///
  /// This method is different from [_clearSelection] that it does not remove
  /// the current selection. It only stops the continuous updates.
  ///
  /// A continuous update can happen as result of calling [_selectStartTo] or
  /// [_selectEndTo] with `continuous` sets to true which causes a [Selectable]
  /// to scroll. Calling this method will stop the update as well as the
  /// scrolling.
  void _finalizeSelection() {
    _stopSelectionEndEdgeUpdate();
    _stopSelectionStartEdgeUpdate();
  }

  /// Removes the ongoing selection.
  void _clearSelection() {
    _finalizeSelection();
    _directionalHorizontalBaseline = null;
    _adjustingSelectionEnd = null;
    _selectable?.dispatchSelectionEvent(const ClearSelectionEvent());
    _updateSelectedContentIfNeeded();
  }

  Future<void> _copy() async {
    final SelectedContent? data = _selectable?.getSelectedContent();
    if (data == null) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: data.plainText));
  }

  Future<void> _share() async {
    final SelectedContent? data = _selectable?.getSelectedContent();
    if (data == null) {
      return;
    }
    await SystemChannels.platform.invokeMethod('Share.invoke', data.plainText);
  }

  /// {@macro flutter.widgets.EditableText.getAnchors}
  ///
  /// See also:
  ///
  ///  * [contextMenuButtonItems], which provides the [ContextMenuButtonItem]s
  ///    for the default context menu buttons.
  TextSelectionToolbarAnchors get contextMenuAnchors {
    if (lastSecondaryTapDownPosition != null) {
      return TextSelectionToolbarAnchors(
        primaryAnchor: lastSecondaryTapDownPosition!,
      );
    }
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    return TextSelectionToolbarAnchors.fromSelection(
      renderBox: renderBox,
      startGlyphHeight: startGlyphHeight,
      endGlyphHeight: endGlyphHeight,
      selectionEndpoints: selectionEndpoints,
    );
  }

  bool? _adjustingSelectionEnd;
  bool _determineIsAdjustingSelectionEnd(bool forward) {
    if (_adjustingSelectionEnd != null) {
      return _adjustingSelectionEnd!;
    }
    final bool isReversed;
    final SelectionPoint start = _selectionDelegate.value
        .startSelectionPoint!;
    final SelectionPoint end = _selectionDelegate.value.endSelectionPoint!;
    if (start.localPosition.dy > end.localPosition.dy) {
      isReversed = true;
    } else if (start.localPosition.dy < end.localPosition.dy) {
      isReversed = false;
    } else {
      isReversed = start.localPosition.dx > end.localPosition.dx;
    }
    // Always move the selection edge that increases the selection range.
    return _adjustingSelectionEnd = forward != isReversed;
  }

  void _granularlyExtendSelection(TextGranularity granularity, bool forward) {
    _directionalHorizontalBaseline = null;
    if (!_selectionDelegate.value.hasSelection) {
      return;
    }
    _selectable?.dispatchSelectionEvent(
      GranularlyExtendSelectionEvent(
        forward: forward,
        isEnd: _determineIsAdjustingSelectionEnd(forward),
        granularity: granularity,
      ),
    );
    _updateSelectedContentIfNeeded();
  }

  double? _directionalHorizontalBaseline;

  void _directionallyExtendSelection(bool forward) {
    if (!_selectionDelegate.value.hasSelection) {
      return;
    }
    final bool adjustingSelectionExtend = _determineIsAdjustingSelectionEnd(forward);
    final SelectionPoint baseLinePoint = adjustingSelectionExtend
      ? _selectionDelegate.value.endSelectionPoint!
      : _selectionDelegate.value.startSelectionPoint!;
    _directionalHorizontalBaseline ??= baseLinePoint.localPosition.dx;
    final Offset globalSelectionPointOffset = MatrixUtils.transformPoint(context.findRenderObject()!.getTransformTo(null), Offset(_directionalHorizontalBaseline!, 0));
    _selectable?.dispatchSelectionEvent(
      DirectionallyExtendSelectionEvent(
        isEnd: _adjustingSelectionEnd!,
        direction: forward ? SelectionExtendDirection.nextLine : SelectionExtendDirection.previousLine,
        dx: globalSelectionPointOffset.dx,
      ),
    );
    _updateSelectedContentIfNeeded();
  }

  // [TextSelectionDelegate] overrides.

  /// Returns the [ContextMenuButtonItem]s representing the buttons in this
  /// platform's default selection menu.
  ///
  /// See also:
  ///
  /// * [TencentCloudChatSelectableRegion.getSelectableButtonItems], which performs a similar role,
  ///   but for any selectable text, not just specifically SelectableRegion.
  /// * [EditableTextState.contextMenuButtonItems], which performs a similar role
  ///   but for content that is not just selectable but also editable.
  /// * [contextMenuAnchors], which provides the anchor points for the default
  ///   context menu.
  /// * [AdaptiveTextSelectionToolbar], which builds the toolbar itself, and can
  ///   take a list of [ContextMenuButtonItem]s with
  ///   [AdaptiveTextSelectionToolbar.buttonItems].
  /// * [AdaptiveTextSelectionToolbar.getAdaptiveButtons], which builds the
  ///   button Widgets for the current platform given [ContextMenuButtonItem]s.
  List<ContextMenuButtonItem> get contextMenuButtonItems {
    return TencentCloudChatSelectableRegion.getSelectableButtonItems(
      selectionGeometry: _selectionDelegate.value,
      onCopy: () {
        _copy();

        // On Android copy should clear the selection.
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
            _clearSelection();
          case TargetPlatform.iOS:
            hideToolbar(false);
          case TargetPlatform.linux:
          case TargetPlatform.macOS:
          case TargetPlatform.windows:
            hideToolbar();
        }
      },
      onSelectAll: () {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
          case TargetPlatform.iOS:
          case TargetPlatform.fuchsia:
            selectAll(SelectionChangedCause.toolbar);
          case TargetPlatform.linux:
          case TargetPlatform.macOS:
          case TargetPlatform.windows:
            selectAll();
            hideToolbar();
        }
      },
      onShare: () {
        _share();

        // On Android, share should clear the selection.
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
            _clearSelection();
          case TargetPlatform.iOS:
            hideToolbar(false);
          case TargetPlatform.linux:
          case TargetPlatform.macOS:
          case TargetPlatform.windows:
            hideToolbar();
        }
      },
    )..addAll(_textProcessingActionButtonItems);
  }

  List<ContextMenuButtonItem> get _textProcessingActionButtonItems {
    final List<ContextMenuButtonItem> buttonItems = <ContextMenuButtonItem>[];
    final SelectedContent? data = _selectable?.getSelectedContent();
    if (data == null) {
      return buttonItems;
    }

    for (final ProcessTextAction action in _processTextActions) {
      buttonItems.add(ContextMenuButtonItem(
        label: action.label,
        onPressed: () async {
          final String selectedText = data.plainText;
          if (selectedText.isNotEmpty) {
            await _processTextService.processTextAction(action.id, selectedText, true);
            hideToolbar();
          }
        },
      ));
    }
    return buttonItems;
  }

  /// The line height at the start of the current selection.
  double get startGlyphHeight {
    return _selectionDelegate.value.startSelectionPoint!.lineHeight;
  }

  /// The line height at the end of the current selection.
  double get endGlyphHeight {
    return _selectionDelegate.value.endSelectionPoint!.lineHeight;
  }

  /// Returns the local coordinates of the endpoints of the current selection.
  List<TextSelectionPoint> get selectionEndpoints {
    final SelectionPoint? start = _selectionDelegate.value.startSelectionPoint;
    final SelectionPoint? end = _selectionDelegate.value.endSelectionPoint;
    late List<TextSelectionPoint> points;
    final Offset startLocalPosition = start?.localPosition ?? end!.localPosition;
    final Offset endLocalPosition = end?.localPosition ?? start!.localPosition;
    if (startLocalPosition.dy > endLocalPosition.dy) {
      points = <TextSelectionPoint>[
        TextSelectionPoint(endLocalPosition, TextDirection.ltr),
        TextSelectionPoint(startLocalPosition, TextDirection.ltr),
      ];
    } else {
      points = <TextSelectionPoint>[
        TextSelectionPoint(startLocalPosition, TextDirection.ltr),
        TextSelectionPoint(endLocalPosition, TextDirection.ltr),
      ];
    }
    return points;
  }

  // [TextSelectionDelegate] overrides.
  // TODO(justinmc): After deprecations have been removed, remove
  // TextSelectionDelegate from this class.
  // https://github.com/flutter/flutter/issues/111213

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  bool get cutEnabled => false;

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  bool get pasteEnabled => false;

  @override
  void hideToolbar([bool hideHandles = true]) {
    _selectionOverlay?.hideToolbar();
    if (hideHandles) {
      _selectionOverlay?.hideHandles();
    }
  }

  @override
  void selectAll([SelectionChangedCause? cause]) {
    _clearSelection();
    _selectable?.dispatchSelectionEvent(const SelectAllSelectionEvent());
    if (cause == SelectionChangedCause.toolbar) {
      _showToolbar();
      _showHandles();
    }
    _updateSelectedContentIfNeeded();
  }

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  void copySelection(SelectionChangedCause cause) {
    _copy();
    _clearSelection();
  }

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  TextEditingValue textEditingValue = const TextEditingValue(text: '_');

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  void bringIntoView(TextPosition position) {/* SelectableRegion must be in view at this point. */}

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  void cutSelection(SelectionChangedCause cause) {
    assert(false);
  }

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  void userUpdateTextEditingValue(TextEditingValue value, SelectionChangedCause cause) {/* SelectableRegion maintains its own state */}

  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  @override
  Future<void> pasteText(SelectionChangedCause cause) async {
    assert(false);
  }

  // [SelectionRegistrar] override.

  @override
  void add(Selectable selectable) {
    assert(_selectable == null);
    _selectable = selectable;
    _selectable!.addListener(_updateSelectionStatus);
    _selectable!.pushHandleLayers(_startHandleLayerLink, _endHandleLayerLink);
  }

  @override
  void remove(Selectable selectable) {
    assert(_selectable == selectable);
    _selectable!.removeListener(_updateSelectionStatus);
    _selectable!.pushHandleLayers(null, null);
    _selectable = null;
  }

  @override
  void dispose() {
    _selectable?.removeListener(_updateSelectionStatus);
    _selectable?.pushHandleLayers(null, null);
    _selectionDelegate.dispose();
    // In case dispose was triggered before gesture end, remove the magnifier
    // so it doesn't remain stuck in the overlay forever.
    _selectionOverlay?.hideMagnifier();
    _selectionOverlay?.dispose();
    _selectionOverlay = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasOverlay(context));
    Widget result = SelectionContainer(
      registrar: this,
      delegate: _selectionDelegate,
      child: widget.child,
    );
    if (kIsWeb) {
      result = TencentCloudChatPlatformSelectableRegionContextMenu(
        child: result,
      );
    }
    return CompositedTransformTarget(
      link: _toolbarLayerLink,
      child: RawGestureDetector(
        gestures: _gestureRecognizers,
        behavior: HitTestBehavior.translucent,
        excludeFromSemantics: true,
        child: Actions(
          actions: _actions,
          child: Focus(
            includeSemantics: false,
            focusNode: widget.focusNode,
            child: result,
          ),
        ),
      ),
    );
  }
}

/// An action that does not override any [Action.overridable] in the subtree.
///
/// If this action is invoked by an [Action.overridable], it will immediately
/// invoke the [Action.overridable] and do nothing else. Otherwise, it will call
/// [invokeAction].
abstract class _NonOverrideAction<T extends Intent> extends ContextAction<T> {
  Object? invokeAction(T intent, [BuildContext? context]);

  @override
  Object? invoke(T intent, [BuildContext? context]) {
    if (callingAction != null) {
      return callingAction!.invoke(intent);
    }
    return invokeAction(intent, context);
  }
}

class _SelectAllAction extends _NonOverrideAction<SelectAllTextIntent> {
  _SelectAllAction(this.state);

  final TencentCloudChatSelectableRegionState state;

  @override
  void invokeAction(SelectAllTextIntent intent, [BuildContext? context]) {
    state.selectAll(SelectionChangedCause.keyboard);
  }
}

class _CopySelectionAction extends _NonOverrideAction<CopySelectionTextIntent> {
  _CopySelectionAction(this.state);

  final TencentCloudChatSelectableRegionState state;

  @override
  void invokeAction(CopySelectionTextIntent intent, [BuildContext? context]) {
    state._copy();
  }
}

class _GranularlyExtendSelectionAction<T extends DirectionalTextEditingIntent> extends _NonOverrideAction<T> {
  _GranularlyExtendSelectionAction(this.state, {required this.granularity});

  final TencentCloudChatSelectableRegionState state;
  final TextGranularity granularity;

  @override
  void invokeAction(T intent, [BuildContext? context]) {
    state._granularlyExtendSelection(granularity, intent.forward);
  }
}

class _GranularlyExtendCaretSelectionAction<T extends DirectionalCaretMovementIntent> extends _NonOverrideAction<T> {
  _GranularlyExtendCaretSelectionAction(this.state, {required this.granularity});

  final TencentCloudChatSelectableRegionState state;
  final TextGranularity granularity;

  @override
  void invokeAction(T intent, [BuildContext? context]) {
    if (intent.collapseSelection) {
      // Selectable region never collapses selection.
      return;
    }
    state._granularlyExtendSelection(granularity, intent.forward);
  }
}

class _DirectionallyExtendCaretSelectionAction<T extends DirectionalCaretMovementIntent> extends _NonOverrideAction<T> {
  _DirectionallyExtendCaretSelectionAction(this.state);

  final TencentCloudChatSelectableRegionState state;

  @override
  void invokeAction(T intent, [BuildContext? context]) {
    if (intent.collapseSelection) {
      // Selectable region never collapses selection.
      return;
    }
    state._directionallyExtendSelection(intent.forward);
  }
}

class _SelectableRegionContainerDelegate extends MultiSelectableSelectionContainerDelegate {
  final Set<Selectable> _hasReceivedStartEvent = <Selectable>{};
  final Set<Selectable> _hasReceivedEndEvent = <Selectable>{};

  Offset? _lastStartEdgeUpdateGlobalPosition;
  Offset? _lastEndEdgeUpdateGlobalPosition;

  @override
  void remove(Selectable selectable) {
    _hasReceivedStartEvent.remove(selectable);
    _hasReceivedEndEvent.remove(selectable);
    super.remove(selectable);
  }

  void _updateLastEdgeEventsFromGeometries() {
    if (currentSelectionStartIndex != -1 && selectables[currentSelectionStartIndex].value.hasSelection) {
      final Selectable start = selectables[currentSelectionStartIndex];
      final Offset localStartEdge = start.value.startSelectionPoint!.localPosition +
          Offset(0, - start.value.startSelectionPoint!.lineHeight / 2);
      _lastStartEdgeUpdateGlobalPosition = MatrixUtils.transformPoint(start.getTransformTo(null), localStartEdge);
    }
    if (currentSelectionEndIndex != -1 && selectables[currentSelectionEndIndex].value.hasSelection) {
      final Selectable end = selectables[currentSelectionEndIndex];
      final Offset localEndEdge = end.value.endSelectionPoint!.localPosition +
          Offset(0, -end.value.endSelectionPoint!.lineHeight / 2);
      _lastEndEdgeUpdateGlobalPosition = MatrixUtils.transformPoint(end.getTransformTo(null), localEndEdge);
    }
  }

  @override
  SelectionResult handleSelectAll(SelectAllSelectionEvent event) {
    final SelectionResult result = super.handleSelectAll(event);
    for (final Selectable selectable in selectables) {
      _hasReceivedStartEvent.add(selectable);
      _hasReceivedEndEvent.add(selectable);
    }
    // Synthesize last update event so the edge updates continue to work.
    _updateLastEdgeEventsFromGeometries();
    return result;
  }

  /// Selects a word in a selectable at the location
  /// [SelectWordSelectionEvent.globalPosition].
  @override
  SelectionResult handleSelectWord(SelectWordSelectionEvent event) {
    final SelectionResult result = super.handleSelectWord(event);
    if (currentSelectionStartIndex != -1) {
      _hasReceivedStartEvent.add(selectables[currentSelectionStartIndex]);
    }
    if (currentSelectionEndIndex != -1) {
      _hasReceivedEndEvent.add(selectables[currentSelectionEndIndex]);
    }
    _updateLastEdgeEventsFromGeometries();
    return result;
  }

  @override
  SelectionResult handleClearSelection(ClearSelectionEvent event) {
    final SelectionResult result = super.handleClearSelection(event);
    _hasReceivedStartEvent.clear();
    _hasReceivedEndEvent.clear();
    _lastStartEdgeUpdateGlobalPosition = null;
    _lastEndEdgeUpdateGlobalPosition = null;
    return result;
  }

  @override
  SelectionResult handleSelectionEdgeUpdate(SelectionEdgeUpdateEvent event) {
    if (event.type == SelectionEventType.endEdgeUpdate) {
      _lastEndEdgeUpdateGlobalPosition = event.globalPosition;
    } else {
      _lastStartEdgeUpdateGlobalPosition = event.globalPosition;
    }
    return super.handleSelectionEdgeUpdate(event);
  }

  @override
  void dispose() {
    _hasReceivedStartEvent.clear();
    _hasReceivedEndEvent.clear();
    super.dispose();
  }

  @override
  SelectionResult dispatchSelectionEventToChild(Selectable selectable, SelectionEvent event) {
    switch (event.type) {
      case SelectionEventType.startEdgeUpdate:
        _hasReceivedStartEvent.add(selectable);
        ensureChildUpdated(selectable);
        break;
      case SelectionEventType.endEdgeUpdate:
        _hasReceivedEndEvent.add(selectable);
        ensureChildUpdated(selectable);
        break;
      case SelectionEventType.clear:
        _hasReceivedStartEvent.remove(selectable);
        _hasReceivedEndEvent.remove(selectable);
        break;
      case SelectionEventType.selectAll:
      case SelectionEventType.selectWord:
        break;
      case SelectionEventType.granularlyExtendSelection:
      case SelectionEventType.directionallyExtendSelection:
        _hasReceivedStartEvent.add(selectable);
        _hasReceivedEndEvent.add(selectable);
        ensureChildUpdated(selectable);
        break;
      default:
        break;
    }
    return super.dispatchSelectionEventToChild(selectable, event);
  }

  @override
  void ensureChildUpdated(Selectable selectable) {
    if (_lastEndEdgeUpdateGlobalPosition != null && _hasReceivedEndEvent.add(selectable)) {
      final SelectionEdgeUpdateEvent synthesizedEvent = SelectionEdgeUpdateEvent.forEnd(
        globalPosition: _lastEndEdgeUpdateGlobalPosition!,
      );
      if (currentSelectionEndIndex == -1) {
        handleSelectionEdgeUpdate(synthesizedEvent);
      }
      selectable.dispatchSelectionEvent(synthesizedEvent);
    }
    if (_lastStartEdgeUpdateGlobalPosition != null && _hasReceivedStartEvent.add(selectable)) {
      final SelectionEdgeUpdateEvent synthesizedEvent = SelectionEdgeUpdateEvent.forStart(
          globalPosition: _lastStartEdgeUpdateGlobalPosition!,
      );
      if (currentSelectionStartIndex == -1) {
        handleSelectionEdgeUpdate(synthesizedEvent);
      }
      selectable.dispatchSelectionEvent(synthesizedEvent);
    }
  }

  @override
  void didChangeSelectables() {
    if (_lastEndEdgeUpdateGlobalPosition != null) {
      handleSelectionEdgeUpdate(
        SelectionEdgeUpdateEvent.forEnd(
          globalPosition: _lastEndEdgeUpdateGlobalPosition!,
        ),
      );
    }
    if (_lastStartEdgeUpdateGlobalPosition != null) {
      handleSelectionEdgeUpdate(
        SelectionEdgeUpdateEvent.forStart(
          globalPosition: _lastStartEdgeUpdateGlobalPosition!,
        ),
      );
    }
    final Set<Selectable> selectableSet = selectables.toSet();
    _hasReceivedEndEvent.removeWhere((Selectable selectable) => !selectableSet.contains(selectable));
    _hasReceivedStartEvent.removeWhere((Selectable selectable) => !selectableSet.contains(selectable));
    super.didChangeSelectables();
  }

  @override
  // TODO: implement contentLength
  int get contentLength => throw UnimplementedError();

  @override
  SelectedContentRange? getSelection() {
    // TODO: implement getSelection
    throw UnimplementedError();
  }
}

/// An abstract base class for updating multiple selectable children.
///
/// This class provide basic [SelectionEvent] handling and child [Selectable]
/// updating. The subclass needs to implement [ensureChildUpdated] to ensure
/// child [Selectable] is updated properly.
///
/// This class optimize the selection update by keeping track of the
/// [Selectable]s that currently contain the selection edges.
abstract class MultiSelectableSelectionContainerDelegate extends SelectionContainerDelegate with ChangeNotifier {
  /// Creates an instance of [MultiSelectableSelectionContainerDelegate].
  MultiSelectableSelectionContainerDelegate() {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  /// Gets the list of selectables this delegate is managing.
  List<Selectable> selectables = <Selectable>[];

  /// The number of additional pixels added to the selection handle drawable
  /// area.
  ///
  /// Selection handles that are outside of the drawable area will be hidden.
  /// That logic prevents handles that get scrolled off the viewport from being
  /// drawn on the screen.
  ///
  /// The drawable area = current rectangle of [SelectionContainer] +
  /// _kSelectionHandleDrawableAreaPadding on each side.
  ///
  /// This was an eyeballed value to create smooth user experiences.
  static const double _kSelectionHandleDrawableAreaPadding = 5.0;

  /// The current selectable that contains the selection end edge.
  @protected
  int currentSelectionEndIndex = -1;

  /// The current selectable that contains the selection start edge.
  @protected
  int currentSelectionStartIndex = -1;

  LayerLink? _startHandleLayer;
  Selectable? _startHandleLayerOwner;
  LayerLink? _endHandleLayer;
  Selectable? _endHandleLayerOwner;

  bool _isHandlingSelectionEvent = false;
  bool _scheduledSelectableUpdate = false;
  bool _selectionInProgress = false;
  Set<Selectable> _additions = <Selectable>{};

  bool _extendSelectionInProgress = false;

  @override
  void add(Selectable selectable) {
    assert(!selectables.contains(selectable));
    _additions.add(selectable);
    _scheduleSelectableUpdate();
  }

  @override
  void remove(Selectable selectable) {
    if (_additions.remove(selectable)) {
      // The same selectable was added in the same frame and is not yet
      // incorporated into the selectables.
      //
      // Removing such selectable doesn't require selection geometry update.
      return;
    }
    _removeSelectable(selectable);
    _scheduleSelectableUpdate();
  }

  /// Notifies this delegate that layout of the container has changed.
  void layoutDidChange() {
    _updateSelectionGeometry();
  }

  void _scheduleSelectableUpdate() {
    if (!_scheduledSelectableUpdate) {
      _scheduledSelectableUpdate = true;
      void runScheduledTask([Duration? duration]) {
        if (!_scheduledSelectableUpdate) {
          return;
        }
        _scheduledSelectableUpdate = false;
        _updateSelectables();
      }

      if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.postFrameCallbacks) {
        // A new task can be scheduled as a result of running the scheduled task
        // from another MultiSelectableSelectionContainerDelegate. This can
        // happen if nesting two SelectionContainers. The selectable can be
        // safely updated in the same frame in this case.
        scheduleMicrotask(runScheduledTask);
      } else {
        SchedulerBinding.instance.addPostFrameCallback(
          runScheduledTask,
          debugLabel: 'SelectionContainer.runScheduledTask',
        );
      }
    }
  }

  void _updateSelectables() {
    // Remove offScreen selectable.
    if (_additions.isNotEmpty) {
      _flushAdditions();
    }
    didChangeSelectables();
  }

  void _flushAdditions() {
    final List<Selectable> mergingSelectables = _additions.toList()..sort(compareOrder);
    final List<Selectable> existingSelectables = selectables;
    selectables = <Selectable>[];
    int mergingIndex = 0;
    int existingIndex = 0;
    int selectionStartIndex = currentSelectionStartIndex;
    int selectionEndIndex = currentSelectionEndIndex;
    // Merge two sorted lists.
    while (mergingIndex < mergingSelectables.length || existingIndex < existingSelectables.length) {
      if (mergingIndex >= mergingSelectables.length ||
          (existingIndex < existingSelectables.length &&
              compareOrder(existingSelectables[existingIndex], mergingSelectables[mergingIndex]) < 0)) {
        if (existingIndex == currentSelectionStartIndex) {
          selectionStartIndex = selectables.length;
        }
        if (existingIndex == currentSelectionEndIndex) {
          selectionEndIndex = selectables.length;
        }
        selectables.add(existingSelectables[existingIndex]);
        existingIndex += 1;
        continue;
      }

      // If the merging selectable falls in the selection range, their selection
      // needs to be updated.
      final Selectable mergingSelectable = mergingSelectables[mergingIndex];
      if (existingIndex < max(currentSelectionStartIndex, currentSelectionEndIndex) &&
          existingIndex > min(currentSelectionStartIndex, currentSelectionEndIndex)) {
        ensureChildUpdated(mergingSelectable);
      }
      mergingSelectable.addListener(_handleSelectableGeometryChange);
      selectables.add(mergingSelectable);
      mergingIndex += 1;
    }
    assert(mergingIndex == mergingSelectables.length &&
        existingIndex == existingSelectables.length &&
        selectables.length == existingIndex + mergingIndex);
    assert(selectionStartIndex >= -1 || selectionStartIndex < selectables.length);
    assert(selectionEndIndex >= -1 || selectionEndIndex < selectables.length);
    // selection indices should not be set to -1 unless they originally were.
    assert((currentSelectionStartIndex == -1) == (selectionStartIndex == -1));
    assert((currentSelectionEndIndex == -1) == (selectionEndIndex == -1));
    currentSelectionEndIndex = selectionEndIndex;
    currentSelectionStartIndex = selectionStartIndex;
    _additions = <Selectable>{};
  }

  void _removeSelectable(Selectable selectable) {
    assert(selectables.contains(selectable), 'The selectable is not in this registrar.');
    final int index = selectables.indexOf(selectable);
    selectables.removeAt(index);
    if (index <= currentSelectionEndIndex) {
      currentSelectionEndIndex -= 1;
    }
    if (index <= currentSelectionStartIndex) {
      currentSelectionStartIndex -= 1;
    }
    selectable.removeListener(_handleSelectableGeometryChange);
  }

  /// Called when this delegate finishes updating the selectables.
  @protected
  @mustCallSuper
  void didChangeSelectables() {
    _updateSelectionGeometry();
  }

  @override
  SelectionGeometry get value => _selectionGeometry;
  SelectionGeometry _selectionGeometry = const SelectionGeometry(
    hasContent: false,
    status: SelectionStatus.none,
  );

  /// Updates the [value] in this class and notifies listeners if necessary.
  void _updateSelectionGeometry() {
    final SelectionGeometry newValue = getSelectionGeometry();
    if (_selectionGeometry != newValue) {
      _selectionGeometry = newValue;
      notifyListeners();
    }
    _updateHandleLayersAndOwners();
  }

  Rect _getBoundingBox(Selectable selectable) {
    Rect result = selectable.boundingBoxes.first;
    for (int index = 1; index < selectable.boundingBoxes.length; index += 1) {
      result = result.expandToInclude(selectable.boundingBoxes[index]);
    }
    return result;
  }

  /// The compare function this delegate used for determining the selection
  /// order of the selectables.
  ///
  /// Defaults to screen order.
  @protected
  Comparator<Selectable> get compareOrder => _compareScreenOrder;

  int _compareScreenOrder(Selectable a, Selectable b) {
    final Rect rectA = MatrixUtils.transformRect(
      a.getTransformTo(null),
      _getBoundingBox(a),
    );
    final Rect rectB = MatrixUtils.transformRect(
      b.getTransformTo(null),
      _getBoundingBox(b),
    );
    final int result = _compareVertically(rectA, rectB);
    if (result != 0) {
      return result;
    }
    return _compareHorizontally(rectA, rectB);
  }

  /// Compares two rectangles in the screen order solely by their vertical
  /// positions.
  ///
  /// Returns positive if a is lower, negative if a is higher, 0 if their
  /// order can't be determine solely by their vertical position.
  static int _compareVertically(Rect a, Rect b) {
    // The rectangles overlap so defer to horizontal comparison.
    if ((a.top - b.top < _kSelectableVerticalComparingThreshold && a.bottom - b.bottom > - _kSelectableVerticalComparingThreshold) ||
        (b.top - a.top < _kSelectableVerticalComparingThreshold && b.bottom - a.bottom > - _kSelectableVerticalComparingThreshold)) {
      return 0;
    }
    if ((a.top - b.top).abs() > _kSelectableVerticalComparingThreshold) {
      return a.top > b.top ? 1 : -1;
    }
    return a.bottom > b.bottom ? 1 : -1;
  }

  /// Compares two rectangles in the screen order by their horizontal positions
  /// assuming one of the rectangles enclose the other rect vertically.
  ///
  /// Returns positive if a is lower, negative if a is higher.
  static int _compareHorizontally(Rect a, Rect b) {
    // a encloses b.
    if (a.left - b.left < precisionErrorTolerance && a.right - b.right > - precisionErrorTolerance) {
      return -1;
    }
    // b encloses a.
    if (b.left - a.left < precisionErrorTolerance && b.right - a.right > - precisionErrorTolerance) {
      return 1;
    }
    if ((a.left - b.left).abs() > precisionErrorTolerance) {
      return a.left > b.left ? 1 : -1;
    }
    return a.right > b.right ? 1 : -1;
  }

  void _handleSelectableGeometryChange() {
    // Geometries of selectable children may change multiple times when handling
    // selection events. Ignore these updates since the selection geometry of
    // this delegate will be updated after handling the selection events.
    if (_isHandlingSelectionEvent) {
      return;
    }
    _updateSelectionGeometry();
  }

  /// Gets the combined selection geometry for child selectables.
  @protected
  SelectionGeometry getSelectionGeometry() {
    if (currentSelectionEndIndex == -1 ||
        currentSelectionStartIndex == -1 ||
        selectables.isEmpty) {
      // There is no valid selection.
      return SelectionGeometry(
        status: SelectionStatus.none,
        hasContent: selectables.isNotEmpty,
      );
    }

    if (!_extendSelectionInProgress) {
      currentSelectionStartIndex = _adjustSelectionIndexBasedOnSelectionGeometry(
        currentSelectionStartIndex,
        currentSelectionEndIndex,
      );
      currentSelectionEndIndex = _adjustSelectionIndexBasedOnSelectionGeometry(
        currentSelectionEndIndex,
        currentSelectionStartIndex,
      );
    }

    // Need to find the non-null start selection point.
    SelectionGeometry startGeometry = selectables[currentSelectionStartIndex].value;
    final bool forwardSelection = currentSelectionEndIndex >= currentSelectionStartIndex;
    int startIndexWalker = currentSelectionStartIndex;
    while (startIndexWalker != currentSelectionEndIndex && startGeometry.startSelectionPoint == null) {
      startIndexWalker += forwardSelection ? 1 : -1;
      startGeometry = selectables[startIndexWalker].value;
    }

    SelectionPoint? startPoint;
    if (startGeometry.startSelectionPoint != null) {
      final Matrix4 startTransform = getTransformFrom(selectables[startIndexWalker]);
      final Offset start = MatrixUtils.transformPoint(startTransform, startGeometry.startSelectionPoint!.localPosition);
      // It can be NaN if it is detached or off-screen.
      if (start.isFinite) {
        startPoint = SelectionPoint(
          localPosition: start,
          lineHeight: startGeometry.startSelectionPoint!.lineHeight,
          handleType: startGeometry.startSelectionPoint!.handleType,
        );
      }
    }

    // Need to find the non-null end selection point.
    SelectionGeometry endGeometry = selectables[currentSelectionEndIndex].value;
    int endIndexWalker = currentSelectionEndIndex;
    while (endIndexWalker != currentSelectionStartIndex && endGeometry.endSelectionPoint == null) {
      endIndexWalker += forwardSelection ? -1 : 1;
      endGeometry = selectables[endIndexWalker].value;
    }
    SelectionPoint? endPoint;
    if (endGeometry.endSelectionPoint != null) {
      final Matrix4 endTransform = getTransformFrom(selectables[endIndexWalker]);
      final Offset end = MatrixUtils.transformPoint(endTransform, endGeometry.endSelectionPoint!.localPosition);
      // It can be NaN if it is detached or off-screen.
      if (end.isFinite) {
        endPoint = SelectionPoint(
          localPosition: end,
          lineHeight: endGeometry.endSelectionPoint!.lineHeight,
          handleType: endGeometry.endSelectionPoint!.handleType,
        );
      }
    }

    // Need to collect selection rects from selectables ranging from the
    // currentSelectionStartIndex to the currentSelectionEndIndex.
    final List<Rect> selectionRects = <Rect>[];
    final Rect? drawableArea = hasSize ? Rect
      .fromLTWH(0, 0, containerSize.width, containerSize.height) : null;
    for (int index = currentSelectionStartIndex; index <= currentSelectionEndIndex; index++) {
      final List<Rect> currSelectableSelectionRects = selectables[index].value.selectionRects;
      final List<Rect> selectionRectsWithinDrawableArea = currSelectableSelectionRects.map((Rect selectionRect) {
        final Matrix4 transform = getTransformFrom(selectables[index]);
        final Rect localRect = MatrixUtils.transformRect(transform, selectionRect);
        return drawableArea?.intersect(localRect) ?? localRect;
      }).where((Rect selectionRect) {
        return selectionRect.isFinite && !selectionRect.isEmpty;
      }).toList();
      selectionRects.addAll(selectionRectsWithinDrawableArea);
    }

    return SelectionGeometry(
      startSelectionPoint: startPoint,
      endSelectionPoint: endPoint,
      selectionRects: selectionRects,
      status: startGeometry != endGeometry
        ? SelectionStatus.uncollapsed
        : startGeometry.status,
      // Would have at least one selectable child.
      hasContent: true,
    );
  }

  // The currentSelectionStartIndex or currentSelectionEndIndex may not be
  // the current index that contains selection edges. This can happen if the
  // selection edge is in between two selectables. One of the selectable will
  // have its selection collapsed at the index 0 or contentLength depends on
  // whether the selection is reversed or not. The current selection index can
  // be point to either one.
  //
  // This method adjusts the index to point to selectable with valid selection.
  int _adjustSelectionIndexBasedOnSelectionGeometry(int currentIndex, int towardIndex) {
    final bool forward = towardIndex > currentIndex;
    while (currentIndex != towardIndex &&
           selectables[currentIndex].value.status != SelectionStatus.uncollapsed) {
      currentIndex += forward ? 1 : -1;
    }
    return currentIndex;
  }

  @override
  void pushHandleLayers(LayerLink? startHandle, LayerLink? endHandle) {
    if (_startHandleLayer == startHandle && _endHandleLayer == endHandle) {
      return;
    }
    _startHandleLayer = startHandle;
    _endHandleLayer = endHandle;
    _updateHandleLayersAndOwners();
  }

  /// Pushes both handle layers to the selectables that contain selection edges.
  ///
  /// This method needs to be called every time the selectables that contain the
  /// selection edges change, i.e. [currentSelectionStartIndex] or
  /// [currentSelectionEndIndex] changes. Otherwise, the handle may be painted
  /// in the wrong place.
  void _updateHandleLayersAndOwners() {
    LayerLink? effectiveStartHandle = _startHandleLayer;
    LayerLink? effectiveEndHandle = _endHandleLayer;
    if (effectiveStartHandle != null || effectiveEndHandle != null) {
      final Rect? drawableArea = hasSize ? Rect
        .fromLTWH(0, 0, containerSize.width, containerSize.height)
        .inflate(_kSelectionHandleDrawableAreaPadding) : null;
      final bool hideStartHandle = value.startSelectionPoint == null || drawableArea == null || !drawableArea.contains(value.startSelectionPoint!.localPosition);
      final bool hideEndHandle = value.endSelectionPoint == null || drawableArea == null|| !drawableArea.contains(value.endSelectionPoint!.localPosition);
      effectiveStartHandle = hideStartHandle ? null : _startHandleLayer;
      effectiveEndHandle = hideEndHandle ? null : _endHandleLayer;
    }
    if (currentSelectionStartIndex == -1 || currentSelectionEndIndex == -1) {
      // No valid selection.
      if (_startHandleLayerOwner != null) {
        _startHandleLayerOwner!.pushHandleLayers(null, null);
        _startHandleLayerOwner = null;
      }
      if (_endHandleLayerOwner != null) {
        _endHandleLayerOwner!.pushHandleLayers(null, null);
        _endHandleLayerOwner = null;
      }
      return;
    }

    if (selectables[currentSelectionStartIndex] != _startHandleLayerOwner) {
      _startHandleLayerOwner?.pushHandleLayers(null, null);
    }
    if (selectables[currentSelectionEndIndex] != _endHandleLayerOwner) {
      _endHandleLayerOwner?.pushHandleLayers(null, null);
    }

    _startHandleLayerOwner = selectables[currentSelectionStartIndex];

    if (currentSelectionStartIndex == currentSelectionEndIndex) {
      // Selection edges is on the same selectable.
      _endHandleLayerOwner = _startHandleLayerOwner;
      _startHandleLayerOwner!.pushHandleLayers(effectiveStartHandle, effectiveEndHandle);
      return;
    }

    _startHandleLayerOwner!.pushHandleLayers(effectiveStartHandle, null);
    _endHandleLayerOwner = selectables[currentSelectionEndIndex];
    _endHandleLayerOwner!.pushHandleLayers(null, effectiveEndHandle);
  }

  /// Copies the selected contents of all selectables.
  @override
  SelectedContent? getSelectedContent() {
    final List<SelectedContent> selections = <SelectedContent>[];
    for (final Selectable selectable in selectables) {
      final SelectedContent? data = selectable.getSelectedContent();
      if (data != null) {
        selections.add(data);
      }
    }
    if (selections.isEmpty) {
      return null;
    }
    final StringBuffer buffer = StringBuffer();
    for (final SelectedContent selection in selections) {
      buffer.write(selection.plainText);
    }
    return SelectedContent(
      plainText: buffer.toString(),
    );
  }

  // Clears the selection on all selectables not in the range of
  // currentSelectionStartIndex..currentSelectionEndIndex.
  //
  // If one of the edges does not exist, then this method will clear the selection
  // in all selectables except the existing edge.
  //
  // If neither of the edges exist this method immediately returns.
  void _flushInactiveSelections() {
    if (currentSelectionStartIndex == -1 && currentSelectionEndIndex == -1) {
      return;
    }
    if (currentSelectionStartIndex == -1 || currentSelectionEndIndex == -1) {
      final int skipIndex = currentSelectionStartIndex == -1 ? currentSelectionEndIndex : currentSelectionStartIndex;
      selectables
        .where((Selectable target) => target != selectables[skipIndex])
        .forEach((Selectable target) => dispatchSelectionEventToChild(target, const ClearSelectionEvent()));
      return;
    }
    final int skipStart = min(currentSelectionStartIndex, currentSelectionEndIndex);
    final int skipEnd = max(currentSelectionStartIndex, currentSelectionEndIndex);
    for (int index = 0; index < selectables.length; index += 1) {
      if (index >= skipStart && index <= skipEnd) {
        continue;
      }
      dispatchSelectionEventToChild(selectables[index], const ClearSelectionEvent());
    }
  }

  /// Selects all contents of all selectables.
  @protected
  SelectionResult handleSelectAll(SelectAllSelectionEvent event) {
    for (final Selectable selectable in selectables) {
      dispatchSelectionEventToChild(selectable, event);
    }
    currentSelectionStartIndex = 0;
    currentSelectionEndIndex = selectables.length - 1;
    return SelectionResult.none;
  }

  /// Selects a word in a selectable at the location
  /// [SelectWordSelectionEvent.globalPosition].
  @protected
  SelectionResult handleSelectWord(SelectWordSelectionEvent event) {
    SelectionResult? lastSelectionResult;
    for (int index = 0; index < selectables.length; index += 1) {
      bool globalRectsContainsPosition = false;
      if (selectables[index].boundingBoxes.isNotEmpty) {
        for (final Rect rect in selectables[index].boundingBoxes) {
          final Rect globalRect = MatrixUtils.transformRect(selectables[index].getTransformTo(null), rect);
          if (globalRect.contains(event.globalPosition)) {
            globalRectsContainsPosition = true;
            break;
          }
        }
      }
      if (globalRectsContainsPosition) {
        final SelectionGeometry existingGeometry = selectables[index].value;
        lastSelectionResult = dispatchSelectionEventToChild(selectables[index], event);
        if (index == selectables.length - 1 && lastSelectionResult == SelectionResult.next) {
          return SelectionResult.next;
        }
        if (lastSelectionResult == SelectionResult.next) {
          continue;
        }
        if (index == 0 && lastSelectionResult == SelectionResult.previous) {
          return SelectionResult.previous;
        }
        if (selectables[index].value != existingGeometry) {
          // Geometry has changed as a result of select word, need to clear the
          // selection of other selectables to keep selection in sync.
          selectables
            .where((Selectable target) => target != selectables[index])
            .forEach((Selectable target) => dispatchSelectionEventToChild(target, const ClearSelectionEvent()));
          currentSelectionStartIndex = currentSelectionEndIndex = index;
        }
        return SelectionResult.end;
      } else {
        if (lastSelectionResult == SelectionResult.next) {
          currentSelectionStartIndex = currentSelectionEndIndex = index - 1;
          return SelectionResult.end;
        }
      }
    }
    assert(lastSelectionResult == null);
    return SelectionResult.end;
  }

  /// Removes the selection of all selectables this delegate manages.
  @protected
  SelectionResult handleClearSelection(ClearSelectionEvent event) {
    for (final Selectable selectable in selectables) {
      dispatchSelectionEventToChild(selectable, event);
    }
    currentSelectionEndIndex = -1;
    currentSelectionStartIndex = -1;
    return SelectionResult.none;
  }

  /// Extend current selection in a certain text granularity.
  @protected
  SelectionResult handleGranularlyExtendSelection(GranularlyExtendSelectionEvent event) {
    assert((currentSelectionStartIndex == -1) == (currentSelectionEndIndex == -1));
    if (currentSelectionStartIndex == -1) {
      if (event.forward) {
        currentSelectionStartIndex = currentSelectionEndIndex = 0;
      } else {
        currentSelectionStartIndex = currentSelectionEndIndex = selectables.length;
      }
    }
    int targetIndex = event.isEnd ? currentSelectionEndIndex : currentSelectionStartIndex;
    SelectionResult result = dispatchSelectionEventToChild(selectables[targetIndex], event);
    if (event.forward) {
      assert(result != SelectionResult.previous);
      while (targetIndex < selectables.length - 1 && result == SelectionResult.next) {
        targetIndex += 1;
        result = dispatchSelectionEventToChild(selectables[targetIndex], event);
        assert(result != SelectionResult.previous);
      }
    } else {
      assert(result != SelectionResult.next);
      while (targetIndex > 0 && result == SelectionResult.previous) {
        targetIndex -= 1;
        result = dispatchSelectionEventToChild(selectables[targetIndex], event);
        assert(result != SelectionResult.next);
      }
    }
    if (event.isEnd) {
      currentSelectionEndIndex = targetIndex;
    } else {
      currentSelectionStartIndex = targetIndex;
    }
    return result;
  }

  /// Extend current selection in a certain text granularity.
  @protected
  SelectionResult handleDirectionallyExtendSelection(DirectionallyExtendSelectionEvent event) {
    assert((currentSelectionStartIndex == -1) == (currentSelectionEndIndex == -1));
    if (currentSelectionStartIndex == -1) {
      currentSelectionStartIndex = currentSelectionEndIndex = switch (event.direction) {
        SelectionExtendDirection.previousLine || SelectionExtendDirection.backward => selectables.length,
        SelectionExtendDirection.nextLine || SelectionExtendDirection.forward => 0,
      };
    }
    int targetIndex = event.isEnd ? currentSelectionEndIndex : currentSelectionStartIndex;
    SelectionResult result = dispatchSelectionEventToChild(selectables[targetIndex], event);
    switch (event.direction) {
      case SelectionExtendDirection.previousLine:
        assert(result == SelectionResult.end || result == SelectionResult.previous);
        if (result == SelectionResult.previous) {
          if (targetIndex > 0) {
            targetIndex -= 1;
            result = dispatchSelectionEventToChild(
              selectables[targetIndex],
              event.copyWith(direction: SelectionExtendDirection.backward),
            );
            assert(result == SelectionResult.end);
          }
        }
      case SelectionExtendDirection.nextLine:
        assert(result == SelectionResult.end || result == SelectionResult.next);
        if (result == SelectionResult.next) {
          if (targetIndex < selectables.length - 1) {
            targetIndex += 1;
            result = dispatchSelectionEventToChild(
              selectables[targetIndex],
              event.copyWith(direction: SelectionExtendDirection.forward),
            );
            assert(result == SelectionResult.end);
          }
        }
      case SelectionExtendDirection.forward:
      case SelectionExtendDirection.backward:
        assert(result == SelectionResult.end);
    }
    if (event.isEnd) {
      currentSelectionEndIndex = targetIndex;
    } else {
      currentSelectionStartIndex = targetIndex;
    }
    return result;
  }

  /// Updates the selection edges.
  @protected
  SelectionResult handleSelectionEdgeUpdate(SelectionEdgeUpdateEvent event) {
    if (event.type == SelectionEventType.endEdgeUpdate) {
      return currentSelectionEndIndex == -1 ? _initSelection(event, isEnd: true) : _adjustSelection(event, isEnd: true);
    }
    return currentSelectionStartIndex == -1 ? _initSelection(event, isEnd: false) : _adjustSelection(event, isEnd: false);
  }

  @override
  SelectionResult dispatchSelectionEvent(SelectionEvent event) {
    final bool selectionWillBeInProgress = event is! ClearSelectionEvent;
    if (!_selectionInProgress && selectionWillBeInProgress) {
      // Sort the selectable every time a selection start.
      selectables.sort(compareOrder);
    }
    _selectionInProgress = selectionWillBeInProgress;
    _isHandlingSelectionEvent = true;
    late SelectionResult result;
    switch (event.type) {
      case SelectionEventType.startEdgeUpdate:
      case SelectionEventType.endEdgeUpdate:
        _extendSelectionInProgress = false;
        result = handleSelectionEdgeUpdate(event as SelectionEdgeUpdateEvent);
        break;
      case SelectionEventType.clear:
        _extendSelectionInProgress = false;
        result = handleClearSelection(event as ClearSelectionEvent);
        break;
      case SelectionEventType.selectAll:
        _extendSelectionInProgress = false;
        result = handleSelectAll(event as SelectAllSelectionEvent);
        break;
      case SelectionEventType.selectWord:
        _extendSelectionInProgress = false;
        result = handleSelectWord(event as SelectWordSelectionEvent);
        break;
      case SelectionEventType.granularlyExtendSelection:
        _extendSelectionInProgress = true;
        result = handleGranularlyExtendSelection(event as GranularlyExtendSelectionEvent);
        break;
      case SelectionEventType.directionallyExtendSelection:
        _extendSelectionInProgress = true;
        result = handleDirectionallyExtendSelection(event as DirectionallyExtendSelectionEvent);
        break;
      default:
        break;
    }
    _isHandlingSelectionEvent = false;
    _updateSelectionGeometry();
    return result;
  }

  @override
  void dispose() {
    for (final Selectable selectable in selectables) {
      selectable.removeListener(_handleSelectableGeometryChange);
    }
    selectables = const <Selectable>[];
    _scheduledSelectableUpdate = false;
    super.dispose();
  }

  /// Ensures the selectable child has received up to date selection event.
  ///
  /// This method is called when a new [Selectable] is added to the delegate,
  /// and its screen location falls into the previous selection.
  ///
  /// Subclasses are responsible for updating the selection of this newly added
  /// [Selectable].
  @protected
  void ensureChildUpdated(Selectable selectable);

  /// Dispatches a selection event to a specific selectable.
  ///
  /// Override this method if subclasses need to generate additional events or
  /// treatments prior to sending the selection events.
  @protected
  SelectionResult dispatchSelectionEventToChild(Selectable selectable, SelectionEvent event) {
    return selectable.dispatchSelectionEvent(event);
  }

  /// Initializes the selection of the selectable children.
  ///
  /// The goal is to find the selectable child that contains the selection edge.
  /// Returns [SelectionResult.end] if the selection edge ends on any of the
  /// children. Otherwise, it returns [SelectionResult.previous] if the selection
  /// does not reach any of its children. Returns [SelectionResult.next]
  /// if the selection reaches the end of its children.
  ///
  /// Ideally, this method should only be called twice at the beginning of the
  /// drag selection, once for start edge update event, once for end edge update
  /// event.
  SelectionResult _initSelection(SelectionEdgeUpdateEvent event, {required bool isEnd}) {
    assert((isEnd && currentSelectionEndIndex == -1) || (!isEnd && currentSelectionStartIndex == -1));
    int newIndex = -1;
    bool hasFoundEdgeIndex = false;
    SelectionResult? result;
    for (int index = 0; index < selectables.length && !hasFoundEdgeIndex; index += 1) {
      final Selectable child = selectables[index];
      final SelectionResult childResult = dispatchSelectionEventToChild(child, event);
      switch (childResult) {
        case SelectionResult.next:
        case SelectionResult.none:
          newIndex = index;
        case SelectionResult.end:
          newIndex = index;
          result = SelectionResult.end;
          hasFoundEdgeIndex = true;
        case SelectionResult.previous:
          hasFoundEdgeIndex = true;
          if (index == 0) {
            newIndex = 0;
            result = SelectionResult.previous;
          }
          result ??= SelectionResult.end;
        case SelectionResult.pending:
          newIndex = index;
          result = SelectionResult.pending;
          hasFoundEdgeIndex = true;
      }
    }

    if (newIndex == -1) {
      assert(selectables.isEmpty);
      return SelectionResult.none;
    }
    if (isEnd) {
      currentSelectionEndIndex = newIndex;
    } else {
      currentSelectionStartIndex = newIndex;
    }
    _flushInactiveSelections();
    // The result can only be null if the loop went through the entire list
    // without any of the selection returned end or previous. In this case, the
    // caller of this method needs to find the next selectable in their list.
    return result ?? SelectionResult.next;
  }

  /// Adjusts the selection based on the drag selection update event if there
  /// is already a selectable child that contains the selection edge.
  ///
  /// This method starts by sending the selection event to the current
  /// selectable that contains the selection edge, and finds forward or backward
  /// if that selectable no longer contains the selection edge.
  SelectionResult _adjustSelection(SelectionEdgeUpdateEvent event, {required bool isEnd}) {
    assert(() {
      if (isEnd) {
        assert(currentSelectionEndIndex < selectables.length && currentSelectionEndIndex >= 0);
        return true;
      }
      assert(currentSelectionStartIndex < selectables.length && currentSelectionStartIndex >= 0);
      return true;
    }());
    SelectionResult? finalResult;
    // Determines if the edge being adjusted is within the current viewport.
    //  - If so, we begin the search for the new selection edge position at the
    //    currentSelectionEndIndex/currentSelectionStartIndex.
    //  - If not, we attempt to locate the new selection edge starting from
    //    the opposite end.
    //  - If neither edge is in the current viewport, the search for the new
    //    selection edge position begins at 0.
    //
    // This can happen when there is a scrollable child and the edge being adjusted
    // has been scrolled out of view.
    final bool isCurrentEdgeWithinViewport = isEnd ? _selectionGeometry.endSelectionPoint != null : _selectionGeometry.startSelectionPoint != null;
    final bool isOppositeEdgeWithinViewport = isEnd ? _selectionGeometry.startSelectionPoint != null : _selectionGeometry.endSelectionPoint != null;
    int newIndex = switch ((isEnd, isCurrentEdgeWithinViewport, isOppositeEdgeWithinViewport)) {
      (true, true, true) => currentSelectionEndIndex,
      (true, true, false) => currentSelectionEndIndex,
      (true, false, true) => currentSelectionStartIndex,
      (true, false, false) => 0,
      (false, true, true) => currentSelectionStartIndex,
      (false, true, false) => currentSelectionStartIndex,
      (false, false, true) => currentSelectionEndIndex,
      (false, false, false) => 0,
    };
    bool? forward;
    late SelectionResult currentSelectableResult;
    // This loop sends the selection event to one of the following to determine
    // the direction of the search.
    //  - currentSelectionEndIndex/currentSelectionStartIndex if the current edge
    //    is in the current viewport.
    //  - The opposite edge index if the current edge is not in the current viewport.
    //  - Index 0 if neither edge is in the current viewport.
    //
    // If the result is `SelectionResult.next`, this loop look backward.
    // Otherwise, it looks forward.
    //
    // The terminate condition are:
    // 1. the selectable returns end, pending, none.
    // 2. the selectable returns previous when looking forward.
    // 2. the selectable returns next when looking backward.
    while (newIndex < selectables.length && newIndex >= 0 && finalResult == null) {
      currentSelectableResult = dispatchSelectionEventToChild(selectables[newIndex], event);
      switch (currentSelectableResult) {
        case SelectionResult.end:
        case SelectionResult.pending:
        case SelectionResult.none:
          finalResult = currentSelectableResult;
        case SelectionResult.next:
          if (forward == false) {
            newIndex += 1;
            finalResult = SelectionResult.end;
          } else if (newIndex == selectables.length - 1) {
            finalResult = currentSelectableResult;
          } else {
            forward = true;
            newIndex += 1;
          }
        case SelectionResult.previous:
          if (forward ?? false) {
            newIndex -= 1;
            finalResult = SelectionResult.end;
          } else if (newIndex == 0) {
            finalResult = currentSelectableResult;
          } else {
            forward = false;
            newIndex -= 1;
          }
      }
    }
    if (isEnd) {
      currentSelectionEndIndex = newIndex;
    } else {
      currentSelectionStartIndex = newIndex;
    }
    _flushInactiveSelections();
    return finalResult!;
  }
}

/// Signature for a widget builder that builds a context menu for the given
/// [TencentCloudChatSelectableRegionState].
///
/// See also:
///
///  * [EditableTextContextMenuBuilder], which performs the same role for
///    [EditableText].
typedef TencentCloudChatSelectableRegionContextMenuBuilder = Widget Function(
  BuildContext context,
  TencentCloudChatSelectableRegionState selectableRegionState,
);
