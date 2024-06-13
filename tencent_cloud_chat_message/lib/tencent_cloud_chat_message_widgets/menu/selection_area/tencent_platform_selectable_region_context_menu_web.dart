// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/src/web.dart' as web;


const String _viewType = 'Browser__WebContextMenuViewType__';
const String _kClassName = 'web-electable-region-context-menu';
// These css rules hides the dom element with the class name.
const String _kClassSelectionRule = '.$_kClassName::selection { background: transparent; }';
const String _kClassRule = '''
.$_kClassName {
  color: transparent;
  user-select: text;
  -webkit-user-select: text; /* Safari */
  -moz-user-select: text; /* Firefox */
  -ms-user-select: text; /* IE10+ */
}
''';

typedef _WebSelectionCallBack = void Function(web.HTMLElement, web.MouseEvent);

/// Function signature for `ui_web.platformViewRegistry.registerViewFactory`.
@visibleForTesting
typedef RegisterViewFactory = void Function(String, Object Function(int viewId), {bool isVisible});

/// See `tencent_platform_selectable_region_context_menu_io.dart` for full
/// documentation.
class TencentCloudChatPlatformSelectableRegionContextMenu extends StatelessWidget {
  /// See `tencent_platform_selectable_region_context_menu_io.dart`.
  TencentCloudChatPlatformSelectableRegionContextMenu({
    required this.child,
    super.key,
  }) {
    if (_registeredViewType == null) {
      _register();
    }
  }

  /// See `tencent_platform_selectable_region_context_menu_io.dart`.
  final Widget child;

  /// See `tencent_platform_selectable_region_context_menu_io.dart`.
  // ignore: use_setters_to_change_properties
  static void attach(SelectionContainerDelegate client) {
    _activeClient = client;
  }

  /// See `tencent_platform_selectable_region_context_menu_io.dart`.
  static void detach(SelectionContainerDelegate client) {
    if (_activeClient != client) {
      _activeClient = null;
    }
  }

  static SelectionContainerDelegate? _activeClient;

  // Keeps track if this widget has already registered its view factories or not.
  static String? _registeredViewType;

  static RegisterViewFactory get _registerViewFactory =>
      debugOverrideRegisterViewFactory ?? ui_web.platformViewRegistry.registerViewFactory;

  /// Override this to provide a custom implementation of [ui_web.platformViewRegistry.registerViewFactory].
  ///
  /// This should only be used for testing.
  // See `tencent_platform_selectable_region_context_menu_io.dart`.
  @visibleForTesting
  static RegisterViewFactory? debugOverrideRegisterViewFactory;

  // Registers the view factories for the interceptor widgets.
  static void _register() {
    assert(_registeredViewType == null);
  }

  static String _registerWebSelectionCallback(_WebSelectionCallBack callback) {
    _registerViewFactory(_viewType, (int viewId) {
      final web.HTMLElement htmlElement = web.document.createElement('div') as web.HTMLElement;
      htmlElement
        ..style.width = '100%'
        ..style.height = '100%'
        ..classList.add(_kClassName);

      // Create css style for _kClassName.
      final web.HTMLStyleElement styleElement = web.document.createElement('style') as web.HTMLStyleElement;
      web.document.head!.append(styleElement as JSAny);
      final web.CSSStyleSheet sheet = styleElement.sheet!;
      sheet.insertRule(_kClassRule, 0);
      sheet.insertRule(_kClassSelectionRule, 1);
      return htmlElement;
    }, isVisible: false);
    return _viewType;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        const Positioned.fill(
          child: HtmlElementView(
            viewType: _viewType,
          ),
        ),
        child,
      ],
    );
  }
}
