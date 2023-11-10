import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/image_hero.dart';

class ImageItem extends StatelessWidget {
  const ImageItem({
    super.key,
    required this.imgUrl,
    required this.size,
    required this.canScaleImage,
    required this.heroTag,
    required this.slidePagekey,
    required this.onImgTap,
    required this.onLongPress,
    required this.imageDetailY,
    // 暂时不使用 hero，滑动返回的时候会有点问题
    this.useHero = false,
  });

  final bool Function(GestureDetails? details) canScaleImage;
  final String imgUrl;
  final String heroTag;
  final Size size;
  final double imageDetailY;
  final GlobalKey<ExtendedImageSlidePageState> slidePagekey;
  final VoidCallback onImgTap;
  final VoidCallback onLongPress;
  final bool useHero;

  @override
  Widget build(BuildContext context) {
    Widget image = ExtendedImage.network(
      imgUrl,
      fit: BoxFit.contain,
      enableSlideOutPage: true,
      gaplessPlayback: false,
      mode: ExtendedImageMode.gesture,
      initGestureConfigHandler: (ExtendedImageState state) {
        double? initialScale = 1.0;
        if (state.extendedImageInfo != null) {
          initialScale = _initScale(
            size: size,
            initialScale: initialScale,
            imageSize: Size(
              min(
                size.width,
                state.extendedImageInfo!.image.width.toDouble(),
              ),
              min(
                size.height,
                state.extendedImageInfo!.image.height.toDouble(),
              ),
            ),
          );
        }
        return GestureConfig(
          inPageView: true,
          initialScale: 1.0,
          maxScale: max(initialScale ?? 1.0, 5.0),
          animationMaxScale: max(initialScale ?? 1.0, 5.0),
        );
      },
      loadStateChanged: (ExtendedImageState state) {
        if (state.extendedImageLoadState == LoadState.completed) {
          return ExtendedImageGesture(
            state,
            canScaleImage: canScaleImage,
            imageBuilder: (Widget image) {
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    top: imageDetailY,
                    bottom: -imageDetailY,
                    child: image,
                  ),
                ],
              );
            },
          );
        }
        return InkWell(
          onTap: onImgTap,
          child: const UnconstrainedBox(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      },
    );

    if (useHero) {
      image = HeroWidget(
        tag: heroTag,
        slidePagekey: slidePagekey,
        child: image,
      );
    }
    return GestureDetector(
      onTap: onImgTap,
      onLongPress: onLongPress,
      child: image,
    );
  }

  double? _initScale({
    required Size imageSize,
    required Size size,
    double? initialScale,
  }) {
    final double n1 = imageSize.height / imageSize.width;
    final double n2 = size.height / size.width;
    if (n1 > n2) {
      final FittedSizes fittedSizes =
          applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      final Size destinationSize = fittedSizes.destination;
      return size.width / destinationSize.width;
    } else if (n1 / n2 < 1 / 4) {
      final FittedSizes fittedSizes =
          applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      final Size destinationSize = fittedSizes.destination;
      return size.height / destinationSize.height;
    }

    return initialScale;
  }
}
