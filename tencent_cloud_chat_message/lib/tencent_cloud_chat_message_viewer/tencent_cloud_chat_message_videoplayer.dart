import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:video_player/video_player.dart';

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({required this.controller});
  final VideoPlayerController controller;
  @override
  State<StatefulWidget> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  // static const List<Duration> _exampleCaptionOffsets = <Duration>[
  //   Duration(seconds: -10),
  //   Duration(seconds: -3),
  //   Duration(seconds: -1, milliseconds: -500),
  //   Duration(milliseconds: -250),
  //   Duration.zero,
  //   Duration(milliseconds: 250),
  //   Duration(seconds: 1, milliseconds: 500),
  //   Duration(seconds: 3),
  //   Duration(seconds: 10),
  // ];
  // static const List<double> _examplePlaybackRates = <double>[
  //   0.25,
  //   0.5,
  //   1.0,
  //   1.5,
  //   2.0,
  //   3.0,
  //   5.0,
  //   10.0,
  // ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
            setState(() {
              if (mounted) {}
            });
          },
        ),
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: PopupMenuButton<Duration>(
        //     initialValue: controller.value.captionOffset,
        //     tooltip: 'Caption Offset',
        //     onSelected: (Duration delay) {
        //       controller.setCaptionOffset(delay);
        //     },
        //     itemBuilder: (BuildContext context) {
        //       return <PopupMenuItem<Duration>>[
        //         for (final Duration offsetDuration in _exampleCaptionOffsets)
        //           PopupMenuItem<Duration>(
        //             value: offsetDuration,
        //             child: Text('${offsetDuration.inMilliseconds}ms'),
        //           )
        //       ];
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(
        //         // Using less vertical padding as the text is also longer
        //         // horizontally, so it feels like it would need more spacing
        //         // horizontally (matching the aspect ratio of the video).
        //         vertical: 12,
        //         horizontal: 16,
        //       ),
        //       child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
        //     ),
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.topRight,
        //   child: PopupMenuButton<double>(
        //     initialValue: controller.value.playbackSpeed,
        //     tooltip: 'Playback speed',
        //     onSelected: (double speed) {
        //       controller.setPlaybackSpeed(speed);
        //     },
        //     itemBuilder: (BuildContext context) {
        //       return <PopupMenuItem<double>>[
        //         for (final double speed in _examplePlaybackRates)
        //           PopupMenuItem<double>(
        //             value: speed,
        //             child: Text('${speed}x'),
        //           )
        //       ];
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(
        //         // Using less vertical padding as the text is also longer
        //         // horizontally, so it feels like it would need more spacing
        //         // horizontally (matching the aspect ratio of the video).
        //         vertical: 12,
        //         horizontal: 16,
        //       ),
        //       child: Text('${controller.value.playbackSpeed}x'),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class TencentCloudChatMessageVideoPlayer extends StatefulWidget {
  final V2TimMessage message;
  final bool controller;
  final bool isSending;

  const TencentCloudChatMessageVideoPlayer({
    super.key,
    required this.message,
    required this.controller,
    required this.isSending,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatMessageVideoPlayerState();
}

enum CurrentVideoType {
  online,
  local,
}

class CurrentVideoInfo {
  final String path;
  final CurrentVideoType type;
  final double aspectRatio;

  CurrentVideoInfo({
    required this.path,
    required this.type,
    required this.aspectRatio,
  });
}

class TencentCloudChatMessageVideoPlayerState extends State<TencentCloudChatMessageVideoPlayer> {
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  late VideoPlayerController _controller;

  final String _tag = "TencentCloudChatMessageVideoPlayer";

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: json.encode(
        {
          "msgID": widget.message.msgID ?? "",
          "log": log,
        },
      ),
    );
  }

  bool isGetMessageInfoEnd = false;

  Future<CurrentVideoInfo?> getMessageInfo() async {
    if (widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      double aspectRatio = (16 / 9);

      if (widget.isSending) {
        var lp = widget.message.videoElem!.videoPath ?? "";
        if (lp.isNotEmpty) {
          console("view sending message video path");
          if (File(lp).existsSync() && !kIsWeb) {
            return CurrentVideoInfo(path: lp, type: CurrentVideoType.local, aspectRatio: aspectRatio);
          }
        }
      }

      if (widget.message.videoElem!.snapshotWidth != null && widget.message.videoElem!.snapshotHeight != null) {
        if (widget.message.videoElem!.snapshotHeight != 0) {
          aspectRatio = (widget.message.videoElem!.snapshotWidth!) / (widget.message.videoElem!.snapshotHeight!);
        }
      }
      if (TencentCloudChatUtils.checkString(widget.message.videoElem!.localVideoUrl) != null) {
        if (File(widget.message.videoElem!.localVideoUrl!).existsSync()) {
          console("view video local url");
          return CurrentVideoInfo(path: widget.message.videoElem!.localVideoUrl!, type: CurrentVideoType.local, aspectRatio: aspectRatio);
        }
      } else {
        if (widget.message.videoElem != null) {
          if (widget.message.videoElem!.snapshotUrl != null) {
            console("view video online url ${widget.message.videoElem!.videoUrl}");
            return CurrentVideoInfo(
              path: widget.message.videoElem!.videoUrl!,
              type: CurrentVideoType.online,
              aspectRatio: aspectRatio,
            );
          }
        }
        if (!kIsWeb) {
          V2TimMessageOnlineUrl? urlres = await TencentCloudChat.instance.chatSDKInstance.messageSDK.getMessageOnlineUrl(msgID: widget.message.msgID ?? "");
        if (urlres != null) {
          if (urlres.videoElem != null) {
            if (TencentCloudChatUtils.checkString(urlres.videoElem!.videoUrl) != null) {
              console("view video online url ${urlres.videoElem!.videoUrl}");
              return CurrentVideoInfo(path: urlres.videoElem!.videoUrl!, type: CurrentVideoType.online, aspectRatio: aspectRatio);
            }
          }
        }
        }
        
      }
    } else {
      console("The component received a non-video message parameter. please check");
    }
    console("has no view video source. please check");
    return null;
  }

  setSateState(void Function() fn) {
    if (mounted) {
      setState(fn);
    } else {
      console("set state after unmounted");
    }
  }

  @override
  void initState() {
    super.initState();
    getMessageInfo().then((info) {
      if (info != null) {
        console("get message info end ${info.aspectRatio} ${info.path} ${info.type.name}");
        if (info.type == CurrentVideoType.online) {
          _controller = VideoPlayerController.networkUrl(Uri.parse(info.path))
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setSateState(() {
                isGetMessageInfoEnd = true;
              });
            });
        } else {
          _controller = VideoPlayerController.file(File(info.path))
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setSateState(() {
                isGetMessageInfoEnd = true;
              });
            });
        }
        Future.delayed(const Duration(milliseconds: 300), () {
          _controller.play();
          setSateState(() {});
        });
      }
    });
  }

  bool startedPlaying = false;

  start() async {}

  @override
  Widget build(BuildContext context) {
    if (widget.message.hasRiskContent == true) {
      return const Center(
        child: Text(
          "Risk Video",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    if (isGetMessageInfoEnd == false) {
      return const Center(
        child: Text(
          "Loading...",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(_controller),
            _ControlsOverlay(controller: _controller),
            VideoProgressIndicator(_controller, allowScrubbing: true),
          ],
        ),
      ),
    );
  }
}
