import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/widgets/loading/tencent_cloud_chat_loading.dart';

const double _kDefaultStrokeWidth = 2;

/// Information about a piece of animation (e.g., color).
@immutable
class TencentCloudChatDecorateData {
  final Color? backgroundColor;
  final Indicator indicator = Indicator.circleStrokeSpin;

  /// It will promise at least one value in the collection.
  final List<Color> colors;
  final double? _strokeWidth;

  /// Applicable to which has cut edge of the shape
  final Color? pathBackgroundColor;

  /// Animation status, true will pause the animation
  final bool pause;

  const TencentCloudChatDecorateData({
    required this.colors,
    this.backgroundColor,
    double? strokeWidth,
    this.pathBackgroundColor,
    required this.pause,
  })  : _strokeWidth = strokeWidth,
        assert(colors.length > 0);

  double get strokeWidth => _strokeWidth ?? _kDefaultStrokeWidth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TencentCloudChatDecorateData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          indicator == other.indicator &&
          _strokeWidth == other._strokeWidth &&
          pathBackgroundColor == other.pathBackgroundColor &&
          pause == other.pause;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      indicator.hashCode ^
      colors.hashCode ^
      _strokeWidth.hashCode ^
      pathBackgroundColor.hashCode ^
      pause.hashCode;

  @override
  String toString() {
    return 'DecorateData{backgroundColor: $backgroundColor, indicator: $indicator, colors: $colors, strokeWidth: $_strokeWidth, pathBackgroundColor: $pathBackgroundColor, pause: $pause}';
  }
}

/// Establishes a subtree in which decorate queries resolve to the given data.
class DecorateContext extends InheritedWidget {
  final TencentCloudChatDecorateData decorateData;

  const DecorateContext({
    Key? key,
    required this.decorateData,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(DecorateContext oldWidget) =>
      oldWidget.decorateData != decorateData;

  static DecorateContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }
}
