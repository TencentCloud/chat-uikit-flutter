import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:better_player_plus/better_player_plus.dart';

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
  final String _tag = "TencentCloudChatMessageVideoPlayer";

  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final info = await getMessageInfo();
      if (info != null && mounted) {
        BetterPlayerDataSource dataSource;
        if (info.type == CurrentVideoType.online) {
          dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            info.path,
          );
        } else {
          dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            info.path,
          );
        }

        final betterPlayerConfiguration = BetterPlayerConfiguration(
          aspectRatio: info.aspectRatio,
          fit: BoxFit.contain,
          autoPlay: true,
          allowedScreenSleep: false,
          fullScreenByDefault: false,
          controlsConfiguration: const BetterPlayerControlsConfiguration(
            enableFullscreen: false,
            enablePlayPause: true,
            enableProgressBar: true,
            enableProgressText: true,
            showControlsOnInitialize: false,
            enableMute:false,
            enableOverflowMenu:false,
            enableSkips:false,
          ),
        );

        _betterPlayerController = BetterPlayerController(
          betterPlayerConfiguration,
          betterPlayerDataSource: dataSource,
        );

        if (mounted) {
          setState(() {
          });
        }
      }
    } catch (e) {
      debugPrint("Video initialization error: $e");
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  Future<CurrentVideoInfo?> getMessageInfo() async {
    if (widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      double aspectRatio = (9 / 16);

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

      if (TencentCloudChatUtils.checkString(widget.message.videoElem!.videoPath) != null) {
        // 先查本地发送的视频地址
        if (File(widget.message.videoElem!.videoPath!).existsSync()) {
          console("video: local video path exists");
          return CurrentVideoInfo(path: widget.message.videoElem!.videoPath!, type: CurrentVideoType.local, aspectRatio: aspectRatio);
        }
      } else if (TencentCloudChatUtils.checkString(widget.message.videoElem!.localVideoUrl) != null) {
        // 再查本地下载的视频地址
        if (File(widget.message.videoElem!.localVideoUrl!).existsSync()) {
          console("video: local url exists");
          return CurrentVideoInfo(path: widget.message.videoElem!.localVideoUrl!, type: CurrentVideoType.local, aspectRatio: aspectRatio);
        }
      } else {
        // 最后再查在线地址(todo 使用 getMessageOnlineUrl 查询)
        if (widget.message.videoElem != null) {
          if (widget.message.videoElem!.snapshotUrl != null) {
            console("video: online url ${widget.message.videoElem!.videoUrl}");
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

    if (_betterPlayerController == null) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: _betterPlayerController!.videoPlayerController?.value.aspectRatio ?? 9 / 16,
      child: BetterPlayer(
        controller: _betterPlayerController!,
      ),
    );
  }
}
