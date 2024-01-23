import 'dart:io';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_message_sdk.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';

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
  State<StatefulWidget> createState() =>
      TencentCloudChatMessageVideoPlayerState();
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

class TencentCloudChatMessageVideoPlayerState
    extends State<TencentCloudChatMessageVideoPlayer> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<CurrentVideoInfo?> getMessageInfo() async {
    if (widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      double aspectRatio = (16 / 9);

      if (widget.isSending) {
        var lp = widget.message.videoElem!.videoPath ?? "";
        if (lp.isNotEmpty) {
          if (File(lp).existsSync()) {
            return CurrentVideoInfo(
                path: lp,
                type: CurrentVideoType.local,
                aspectRatio: aspectRatio);
          }
        }
      }

      if (widget.message.videoElem!.snapshotWidth != null &&
          widget.message.videoElem!.snapshotHeight != null) {
        if (widget.message.videoElem!.snapshotHeight != 0) {
          aspectRatio = (widget.message.videoElem!.snapshotWidth!) /
              (widget.message.videoElem!.snapshotHeight!);
        }
      }
      if (TencentCloudChatUtils.checkString(
              widget.message.videoElem!.localVideoUrl) !=
          null) {
        if (File(widget.message.videoElem!.localVideoUrl!).existsSync()) {
          return CurrentVideoInfo(
              path: widget.message.videoElem!.localVideoUrl!,
              type: CurrentVideoType.local,
              aspectRatio: aspectRatio);
        }
      } else {
        V2TimMessageOnlineUrl? urlres =
            await TencentCloudChatMessageSDK.getMessageOnlineUrl(
                msgID: widget.message.msgID ?? "");
        if (urlres != null) {
          if (urlres.videoElem != null) {
            if (TencentCloudChatUtils.checkString(urlres.videoElem!.videoUrl) !=
                null) {
              return CurrentVideoInfo(
                  path: urlres.videoElem!.videoUrl!,
                  type: CurrentVideoType.online,
                  aspectRatio: aspectRatio);
            }
          }
        }
      }
    } else {
      debugPrint(
          "The component received a non-video message parameter. please check");
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  bool startedPlaying = false;

  start() async {}

  @override
  Widget build(BuildContext context) {
    if (widget.message.hasRiskContent == true) {
      return const Center(
        child: Text(
          "视频存在风险",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return FutureBuilder(
      future: getMessageInfo(),
      builder:
          (BuildContext context, AsyncSnapshot<CurrentVideoInfo?> snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: Text(
              "加载中...",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        if (snapshot.data!.type == CurrentVideoType.local) {
          return Center(
            child: BetterPlayer.file(
              snapshot.data!.path,
              betterPlayerConfiguration: BetterPlayerConfiguration(
                aspectRatio: snapshot.data!.aspectRatio,
                autoPlay: true,
                controlsConfiguration: const BetterPlayerControlsConfiguration(
                  enableFullscreen: false,
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: BetterPlayer.network(
              snapshot.data!.path,
              betterPlayerConfiguration: BetterPlayerConfiguration(
                aspectRatio: snapshot.data!.aspectRatio,
                autoPlay: true,
                controlsConfiguration: const BetterPlayerControlsConfiguration(
                  enableFullscreen: false,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
