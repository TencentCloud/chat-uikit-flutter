import 'dart:async';

import 'package:chewie_for_us/chewie_for_us.dart';
import 'package:chewie_for_us/src/animated_play_pause.dart';
import 'package:chewie_for_us/src/material/material_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'center_play_button.dart';

class VideoCustomControls extends StatefulWidget {
  const VideoCustomControls({required this.downloadFn, Key? key})
      : super(key: key);
  final Future<void> Function() downloadFn;

  @override
  State<StatefulWidget> createState() {
    return _VideoCustomControlsState();
  }
}

class _VideoCustomControlsState extends State<VideoCustomControls>
    with SingleTickerProviderStateMixin {
  late VideoPlayerValue _latestValue;
  bool _hideStuff = true;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;
  bool isLoading = false;

  final barHeight = 48.0;
  final marginSize = 5.0;

  late VideoPlayerController controller;
  ChewieController? _chewieController;
  // We know that _chewieController is set in didChangeDependencies
  ChewieController get chewieController => _chewieController!;

  void _safeSetState(void Function() fn) {
    if (mounted) setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return Container(
        color: Colors.transparent,
        child: chewieController.errorBuilder?.call(
              context,
              chewieController.videoPlayerController.value.errorDescription!,
            ) ??
            const Center(
              child: Text(
                '视频加载出错，换一个试试',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
      );
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: () => _cancelAndRestartTimer(),
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (_latestValue.isBuffering)
                const Center(
                    child: CircularProgressIndicator(color: Colors.white))
              else
                _buildHitArea(),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: AnimatedOpacity(
                  opacity: _hideStuff ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      _buildVideoControlBar(context),
                      _buildBottomBar()
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Color(0xB22b2b2b),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const CupertinoActivityIndicator(
                    radius: 35,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final oldController = _chewieController;
    _chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  Widget _buildBottomBar() {
    return Container(
      height: barHeight,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_latestValue.isPlaying) {
                _playPause();
              }
              Navigator.of(context).pop();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                color: Colors.black12,
                shape: CircleBorder(),
              ),
              width: 44,
              height: 44,
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () async {
              _safeSetState(() {
                isLoading = true;
              });
              await widget.downloadFn();
              Future.delayed(
                const Duration(milliseconds: 200),
                () {
                  _safeSetState(
                    () {
                      isLoading = false;
                    },
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                color: Colors.black26,
                shape: CircleBorder(),
              ),
              width: 44,
              height: 44,
              child: const Icon(
                Icons.arrow_downward_sharp,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoControlBar(
    BuildContext context,
  ) {
    const iconColor = Colors.white;
    return SizedBox(
      height: barHeight,
      child: Row(
        children: <Widget>[
          _buildPlayPause(controller, iconColor),
          if (chewieController.isLive)
            const Expanded(child: Text('LIVE'))
          else
            _buildPositionStart(iconColor),
          if (chewieController.isLive)
            const SizedBox()
          else
            _buildProgressBar(),
          if (!chewieController.isLive) _buildPositionEnd(iconColor),
        ],
      ),
    );
  }

  Widget _buildHitArea() {
    // final bool isFinished = _latestValue.position >= _latestValue.duration;
    return GestureDetector(
      onTap: () {
        if (_latestValue.isPlaying) {
          if (_displayTapped) {
            _safeSetState(() {
              _hideStuff = true;
            });
          } else {
            _cancelAndRestartTimer();
          }
        } else {
          _playPause();

          _safeSetState(() {
            _hideStuff = true;
          });
        }
      },
      child: CenterPlayButton(
        isPlaying: controller.value.isPlaying,
        show: !_latestValue.isPlaying && !_dragging,
        onPressed: _playPause,
      ),
    );
  }

  GestureDetector _buildPlayPause(
      VideoPlayerController controller, Color color) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: const EdgeInsets.only(left: 8.0, right: 4.0),
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: AnimatedPlayPause(
          playing: controller.value.isPlaying,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPositionStart(Color? iconColor) {
    final position = _latestValue.position;

    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Text(
        formatDuration(position),
        style: TextStyle(fontSize: 14.0, color: iconColor),
      ),
    );
  }

  Widget _buildPositionEnd(Color? iconColor) {
    final duration = _latestValue.duration;

    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Text(
        formatDuration(duration),
        style: TextStyle(fontSize: 14.0, color: iconColor),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    _safeSetState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<void> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if (controller.value.isPlaying || chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        _safeSetState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _playPause() {
    final isFinished = _latestValue.position >= _latestValue.duration;

    _safeSetState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.isInitialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(const Duration());
          }
          Timer(const Duration(milliseconds: 100), () => controller.play());
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      _safeSetState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    _safeSetState(() {
      _latestValue = controller.value;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            _safeSetState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            _safeSetState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: chewieController.materialProgressColors ??
              ChewieProgressColors(
                playedColor: Colors.white,
                handleColor: Colors.white,
                bufferedColor: Colors.white38,
                backgroundColor: Colors.white24,
              ),
        ),
      ),
    );
  }
}

String formatDuration(Duration position) {
  final ms = position.inMilliseconds;

  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  final minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';

  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';

  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';

  final formattedTime =
      '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

  return formattedTime;
}
