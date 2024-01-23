import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/widgets/loading/circle_stroke_spin.dart';
import 'package:tencent_cloud_chat_common/widgets/loading/decorate.dart';

enum Indicator {
  circleStrokeSpin,
}

class TencentCloudChatLoading extends StatelessWidget {
  /// Indicate which type.
  final Indicator indicatorType = Indicator.circleStrokeSpin;

  /// The color you draw on the shape.
  final List<Color>? colors;
  final Color? backgroundColor;

  /// The stroke width of line.
  final double? strokeWidth;

  /// Applicable to which has cut edge of the shape
  final Color? pathBackgroundColor;

  final double height;
  final double width;

  const TencentCloudChatLoading({
    Key? key,
    this.colors,
    this.backgroundColor,
    this.strokeWidth,
    this.pathBackgroundColor,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> safeColors = colors == null || colors!.isEmpty
        ? [Theme.of(context).primaryColor]
        : colors!;
    return DecorateContext(
      decorateData: TencentCloudChatDecorateData(
        colors: safeColors,
        strokeWidth: strokeWidth,
        pathBackgroundColor: pathBackgroundColor,
        pause: false,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: backgroundColor,
            child: const TencentCloudChatCircleStrokeSpin(),
          ),
        ),
      ),
    );
  }
}
