import 'package:chewie_for_us/chewie_for_us.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

import 'fijk_panel.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({
    super.key,
    required this.isInit,
    required this.isTest,
    required this.fijkPlayer,
    required this.chewieController,
    this.onDownloadFile,
    this.onImgLongPress,
    required this.videoUrl,
    required this.coverUrl,
    required this.heroTag,
  });

  final bool isInit;
  final bool isTest;
  final FijkPlayer fijkPlayer;
  final ChewieController? chewieController;
  final ValueChanged<String>? onDownloadFile;
  final ValueChanged<String>? onImgLongPress;
  final String videoUrl;
  final String coverUrl;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return ExtendedImageSlidePageHandler(
      child: Container(
        color: Colors.black,
        child: isInit
            ? isTest
                ? FijkView(
                    player: fijkPlayer,
                    color: Colors.black,
                    panelBuilder:
                        (player, data, context, viewSize, texturePos) {
                      return kangXunFijkPanelBuilder(
                          player, data, context, viewSize, texturePos,
                          () async {
                        onDownloadFile?.call(videoUrl);
                      });
                    },
                  )
                : Chewie(
                    controller: chewieController!,
                  )
            : Stack(
                fit: StackFit.expand,
                children: [
                  ExtendedImage.network(
                    coverUrl,
                    fit: BoxFit.contain,
                    enableSlideOutPage: true,
                    gaplessPlayback: false,
                    mode: ExtendedImageMode.gesture,
                  ),
                  const UnconstrainedBox(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                ],
              ),
      ),
      heroBuilderForSlidingPage: (Widget result) {
        return Hero(
          tag: heroTag,
          child: result,
          flightShuttleBuilder: (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            final Hero hero = (flightDirection == HeroFlightDirection.pop
                ? fromHeroContext.widget
                : toHeroContext.widget) as Hero;
            return hero.child;
          },
        );
      },
    );
  }
}
