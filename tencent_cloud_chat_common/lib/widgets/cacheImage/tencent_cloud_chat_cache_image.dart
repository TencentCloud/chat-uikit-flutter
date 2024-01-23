import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class TencentCloudChatCacheImage extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final BoxFit? fit;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, DownloadProgress)?
      progressIndicatorBuilder;
  final Widget Function(BuildContext, String, Object)? errorWidget;
  final int? memCacheWidth;
  final int? memCacheHeight;
  const TencentCloudChatCacheImage({
    super.key,
    required this.width,
    required this.height,
    required this.url,
    this.fit,
    this.errorWidget,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.memCacheHeight,
    this.memCacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      errorWidget: errorWidget,
      imageBuilder: imageBuilder,
      placeholder: placeholder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
    );
  }
}
