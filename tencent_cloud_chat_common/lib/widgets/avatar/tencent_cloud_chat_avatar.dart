import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';

enum TencentCloudChatAvatarScene {
  messageHeader,
  groupProfile,
  messageListForOthers,
  messageListForSelf,
  messageList,
  conversationList,
  chatsSelector,
  groupMemberSelector,
  contacts,
  custom,
  userProfile,
  settings,
  searchResult,
}

/// A customizable avatar widget that can display one or multiple images.
///
/// The TencentCloudChatUIKitAvatar widget is designed to display user avatars
/// in a chat application. It supports displaying a single image or multiple
/// images in a grid layout. The widget can handle both local file paths and
/// online image URLs.
///
/// The widget provides customization options for width, height, border radius,
/// and decoration.
///
/// Example usage:
///
/// ```dart
/// TencentCloudChatUIKitAvatar(
///   width: 48,
///   height: 48,
///   borderRadius: 8,
///   imageList: [
///     'https://example.com/sample-image-1.jpg',
///     'https://example.com/sample-image-2.jpg',
///     'https://example.com/sample-image-3.jpg',
///   ],
/// )
/// ```
class TencentCloudChatAvatar extends StatefulWidget {
  /// The total width of the avatar.
  /// Defaults to 48.
  final double? width;

  /// The total height of the avatar.
  /// Defaults to 48.
  final double? height;

  /// The border radius of the avatar.
  /// Defaults to 8.
  final double? borderRadius;

  /// A list of image paths (local or online) to be displayed as avatars.
  /// The list must contain at least 1 and at most 9 items.
  /// Each item in the list can be a local file path or an online image URL.
  final List<String?> imageList;

  /// The decoration to container where there are multiple images provided.
  final Decoration? decoration;

  final TencentCloudChatAvatarScene scene;

  const TencentCloudChatAvatar({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    required this.imageList,
    this.decoration,
    required this.scene,
  })  : assert(imageList.length >= 1 && imageList.length <= 9),
        super(key: key);

  @override
  State<TencentCloudChatAvatar> createState() => _TencentCloudChatAvatarState();
}

class _TencentCloudChatAvatarState extends TencentCloudChatState<TencentCloudChatAvatar> {
  final tag = "TencentCloudChatUIKitAvatar";
  List<String> _filteredImages = [];

  @override
  void initState() {
    super.initState();
    _filteredImages = _generateImageList(widget.imageList);
  }

  @override
  void didUpdateWidget(TencentCloudChatAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _filteredImages = _generateImageList(widget.imageList);
  }

  List<String> _generateImageList(List<String?> originalList) {
    return originalList.map((e) => TencentCloudChatUtils.checkString(e) != null ? e! : "images/default_user_icon.png").toList();
  }

  Widget _buildImage(String imagePath, double width, double height) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      if (imagePath.endsWith("svg") && !TencentCloudChatPlatformAdapter().isWeb) {
        return SvgPicture.network(
          imagePath,
          placeholderBuilder: (BuildContext context) => SizedBox(
            width: width,
            height: height,
            child: Image.asset(
              "images/default_user_icon.png",
              package: 'tencent_cloud_chat_common',
              width: width,
              height: height,
              fit: BoxFit.cover,),
          ),
          width: width,
          height: height,
        );
      }
      return CachedNetworkImage(
        placeholder: (context, url) {
          return Image.asset(
            "images/default_user_icon.png",
            package: 'tencent_cloud_chat_common',
            width: width,
            height: height,
            fit: BoxFit.cover,);
        },
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return SizedBox(
            width: width,
            height: height,
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        package: 'tencent_cloud_chat_common',
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildSkeletonAnimation(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? TencentCloudChatScreenAdapter.getRadius(6)),
        color: Colors.grey[300],
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final avatarHeight = widget.height ?? TencentCloudChatScreenAdapter.getSquareSize(36);
    final avatarWidth = widget.width ?? TencentCloudChatScreenAdapter.getSquareSize(36);
    final avatarRadius = widget.borderRadius ?? TencentCloudChatScreenAdapter.getRadius(6);

    final images = _filteredImages.getRange(0, min(_filteredImages.length, 9)).toList();

    if (_filteredImages.isEmpty) {
      return _buildSkeletonAnimation(avatarWidth, avatarHeight);
    }

    try {
      if (images.length == 1) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(avatarRadius),
          child: _buildImage(images[0], avatarWidth, avatarHeight),
        );
      } else {
        int gridCount = (images.length <= 4) ? 2 : 3;
        double spacing = 2.0;
        double imageSize = (avatarWidth - (gridCount - 1) * spacing) / gridCount;

        return Container(
          width: avatarWidth,
          height: avatarHeight,
          decoration: widget.decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(avatarRadius),
                color: Colors.grey[200],
              ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(avatarRadius),
            child: Flow(
              delegate: _AvatarFlowDelegate(
                gridCount: gridCount,
                imageSize: imageSize,
                spacing: spacing,
              ),
              children: images.map((imagePath) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: _buildImage(imagePath, imageSize, imageSize),
                );
              }).toList(),
            ),
          ),
        );
      }
    } catch (e) {
      return _buildSkeletonAnimation(avatarWidth, avatarHeight);
    }
  }
}

class _AvatarFlowDelegate extends FlowDelegate {
  final int gridCount;
  final double imageSize;
  final double spacing;

  _AvatarFlowDelegate({
    required this.gridCount,
    required this.imageSize,
    required this.spacing,
  });

  @override
  Size getSize(BoxConstraints constraints) {
    return const Size(double.infinity, double.infinity);
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: imageSize, height: imageSize);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    int rowCount = (context.childCount / gridCount).ceil();
    for (int i = 0; i < context.childCount; ++i) {
      int row = rowCount - 1 - (i ~/ gridCount);
      int col = i % gridCount;
      double rowSpacing = (context.size.height - rowCount * imageSize) / (rowCount + 1);
      double x = (context.size.width - gridCount * imageSize - (gridCount - 1) * spacing) / 2 + col * (imageSize + spacing);
      double y = rowSpacing + row * (imageSize + rowSpacing);
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0));
    }
  }

  @override
  bool shouldRepaint(_AvatarFlowDelegate oldDelegate) {
    return gridCount != oldDelegate.gridCount || imageSize != oldDelegate.imageSize || spacing != oldDelegate.spacing;
  }
}
