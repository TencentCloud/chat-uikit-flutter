import 'dart:io';
import 'dart:math';

import 'package:chewie_for_us/chewie_for_us.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'bottom_actions.dart';
import 'browser_hero_wrapper.dart';
import 'fijk_panel.dart';
import 'video_custom_controls.dart';

class IMMediaMsgBrowser extends StatefulWidget {
  const IMMediaMsgBrowser({
    super.key,
    required this.pictureSrcs,
    this.initianIndex = 0,
    this.onDownloadFile,
    this.onImgLongPress,
    this.url = '',
    this.coverUrl = '',
    this.heroTag = '',
    this.isVideo = false,
  });

  final String url;
  final String coverUrl;
  final String heroTag;
  final bool isVideo;
  final int initianIndex;
  final List<String> pictureSrcs;
  final ValueChanged<String>? onDownloadFile;
  final ValueChanged<String>? onImgLongPress;

  @override
  IMMediaMsgBrowserState createState() => IMMediaMsgBrowserState();
}

class IMMediaMsgBrowserState extends State<IMMediaMsgBrowser>
    with TickerProviderStateMixin {
  late AnimationController _slideEndAnimationController;
  late Animation<double> _slideEndAnimation;
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  bool _showSwiper = true;
  double _imageDetailY = 0;
  Rect? imageDRect;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  bool isInit = false;
  bool get isTest {
    return Platform.isAndroid;
  }

  final FijkPlayer fijkPlayer = FijkPlayer();

  void _safeSetState(void Function() fn) {
    if (mounted) setState(fn);
  }

  late final ValueNotifier<int> _currentIndex;

  _onDownloadImg() {
    widget.onDownloadFile?.call(
      widget.pictureSrcs[_currentIndex.value],
    );
  }

  Future<void> _onLongPress() async {
    widget.onImgLongPress?.call(
      widget.pictureSrcs[_currentIndex.value],
    );
  }

  @override
  void initState() {
    if (widget.isVideo) {
      setVideoPlayerController();
      // 允许横屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    _currentIndex = ValueNotifier(widget.initianIndex);
    _slideEndAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _slideEndAnimationController.addListener(() {
      _imageDetailY = _slideEndAnimation.value;
      if (_imageDetailY == 0) {
        _showSwiper = true;
      }
    });
    super.initState();
  }

  setVideoPlayerController() async {
    if (isTest) {
      fijkPlayer.addListener(
        () {
          if (fijkPlayer.state == FijkState.started) {
            _safeSetState(() {
              isInit = true;
            });
          }
        },
      );

      fijkPlayer.setDataSource(widget.url, autoPlay: true);
      // await fijkPlayer.prepareAsync();
    } else {
      VideoPlayerController player = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );
      await player.initialize();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ChewieController controller = ChewieController(
            videoPlayerController: player,
            autoPlay: true,
            looping: false,
            showControlsOnInitialize: false,
            allowPlaybackSpeedChanging: false,
            customControls: VideoCustomControls(
              downloadFn: () async => widget.onDownloadFile?.call(widget.url),
            ),
          );
          _safeSetState(
            () {
              videoPlayerController = player;
              chewieController = controller;
              isInit = true;
            },
          );
        },
      );
    }
  }

  @override
  didUpdateWidget(oldWidget) {
    if (widget.isVideo) {
      if (oldWidget.url != widget.url) {
        setVideoPlayerController();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.isVideo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      if (isTest) {
        fijkPlayer.dispose();
      }
      if (isInit) {
        videoPlayerController?.dispose();
        chewieController?.dispose();
      }
    }

    _currentIndex.dispose();
    _slideEndAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    imageDRect = Offset.zero & size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ExtendedImageSlidePage(
              key: slidePagekey,
              slideAxis: SlideAxis.vertical,
              slideScaleHandler: (
                Offset offset, {
                ExtendedImageSlidePageState? state,
              }) {
                if (state != null && state.scale == 1.0) {
                  if (state.imageGestureState!.gestureDetails!.totalScale! >
                      1.0) {
                    return 1.0;
                  }
                  if (offset.dy < 0 || _imageDetailY < 0) {
                    return 1.0;
                  }
                }

                return null;
              },
              slideOffsetHandler: (
                Offset offset, {
                ExtendedImageSlidePageState? state,
              }) {
                if (state != null && state.scale == 1.0) {
                  if (state.imageGestureState!.gestureDetails!.totalScale! >
                      1.0) {
                    return Offset.zero;
                  }

                  if (offset.dy < 0 || _imageDetailY < 0) {
                    return Offset.zero;
                  }

                  if (_imageDetailY != 0) {
                    _imageDetailY = 0;
                    _showSwiper = true;
                  }
                }
                return null;
              },
              slideEndHandler: (
                Offset offset, {
                ExtendedImageSlidePageState? state,
                ScaleEndDetails? details,
              }) {
                if (_imageDetailY != 0 && state!.scale == 1) {
                  if (!_slideEndAnimationController.isAnimating) {
                    final double magnitude =
                        details!.velocity.pixelsPerSecond.distance;
                    if (magnitude.greaterThanOrEqualTo(minMagnitude)) {
                      final Offset direction =
                          details.velocity.pixelsPerSecond / magnitude * 1000;
                      _slideEndAnimation = _slideEndAnimationController.drive(
                        Tween<double>(
                          begin: _imageDetailY,
                          end: _imageDetailY + direction.dy,
                        ),
                      );
                      _slideEndAnimationController.reset();
                      _slideEndAnimationController.forward();
                    }
                  }
                  return false;
                }

                return null;
              },
              onSlidingPage: (ExtendedImageSlidePageState state) {
                final bool showSwiper = !state.isSliding;
                if (showSwiper != _showSwiper) {
                  _showSwiper = showSwiper;
                }
              },
              child: Material(
                color: Colors.black,
                shadowColor: Colors.transparent,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ExtendedImageGesturePageView.builder(
                      controller: ExtendedPageController(
                        initialPage: widget.initianIndex,
                      ),
                      physics: const BouncingScrollPhysics(),
                      canScrollPage: (GestureDetails? gestureDetails) {
                        return _imageDetailY >= 0;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        if (widget.isVideo) {
                          return ExtendedImageSlidePageHandler(
                            child: Container(
                              color: Colors.black,
                              child: isInit
                                  ? isTest
                                      ? FijkView(
                                          player: fijkPlayer,
                                          color: Colors.black,
                                          panelBuilder: (player, data, context,
                                              viewSize, texturePos) {
                                            return kangXunFijkPanelBuilder(
                                                player,
                                                data,
                                                context,
                                                viewSize,
                                                texturePos, () async {
                                              widget.onDownloadFile
                                                  ?.call(widget.url);
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
                                          widget.coverUrl,
                                          fit: BoxFit.contain,
                                          enableSlideOutPage: true,
                                          gaplessPlayback: false,
                                          mode: ExtendedImageMode.gesture,
                                        ),
                                        const UnconstrainedBox(
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                            ),
                            heroBuilderForSlidingPage: (Widget result) {
                              return Hero(
                                tag: widget.heroTag,
                                child: result,
                                flightShuttleBuilder: (
                                  BuildContext flightContext,
                                  Animation<double> animation,
                                  HeroFlightDirection flightDirection,
                                  BuildContext fromHeroContext,
                                  BuildContext toHeroContext,
                                ) {
                                  final Hero hero = (flightDirection ==
                                          HeroFlightDirection.pop
                                      ? fromHeroContext.widget
                                      : toHeroContext.widget) as Hero;
                                  return hero.child;
                                },
                              );
                            },
                          );
                        }
                        final String item = widget.pictureSrcs[index];

                        Widget image = ExtendedImage.network(
                          item,
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
                                    state.extendedImageInfo!.image.width
                                        .toDouble(),
                                  ),
                                  min(
                                    size.height,
                                    state.extendedImageInfo!.image.height
                                        .toDouble(),
                                  ),
                                ),
                              );
                            }
                            return GestureConfig(
                              inPageView: true,
                              initialScale: initialScale ?? 1.0,
                              maxScale: max(initialScale ?? 1.0, 5.0),
                              animationMaxScale: max(initialScale ?? 1.0, 5.0),
                            );
                          },
                          loadStateChanged: (ExtendedImageState state) {
                            if (state.extendedImageLoadState ==
                                LoadState.completed) {
                              return ExtendedImageGesture(
                                state,
                                canScaleImage: (_) => _imageDetailY == 0,
                                imageBuilder: (Widget image) {
                                  return Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                        top: _imageDetailY,
                                        bottom: -_imageDetailY,
                                        child: image,
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            return null;
                          },
                        );

                        if (index < min(9, widget.pictureSrcs.length)) {
                          image = BrowserHeroWrapper(
                            tag: widget.heroTag,
                            slidePagekey: slidePagekey,
                            child: image,
                          );
                        }

                        // ignore: join_return_with_assignment
                        image = GestureDetector(
                          onTap: () {
                            if (_imageDetailY != 0) {
                              _imageDetailY = 0;
                            } else {
                              slidePagekey.currentState?.popPage();
                              Navigator.pop(context);
                            }
                          },
                          onLongPress: _onLongPress,
                          child: image,
                        );
                        return image;
                      },
                      itemCount: widget.pictureSrcs.length,
                      onPageChanged: (int index) {
                        _currentIndex.value = index;
                        if (_imageDetailY != 0) {
                          _imageDetailY = 0;
                        }
                        _showSwiper = true;
                      },
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.1),
                        child: SafeArea(
                          bottom: false,
                          minimum: const EdgeInsets.only(top: 30),
                          child: ValueListenableBuilder(
                            valueListenable: _currentIndex,
                            builder: (BuildContext context, int currentIndex,
                                Widget? child) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  '${currentIndex + 1}/${widget.pictureSrcs.length}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 0,
                      child: SafeArea(
                        top: false,
                        child: BottomActions(
                          onDownload: _onDownloadImg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
