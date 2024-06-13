import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';

class TencentCloudChatMessageRowMessageSenderAvatar extends StatefulWidget {
  final MessageRowMessageSenderAvatarBuilderData data;
  final MessageRowMessageSenderAvatarBuilderMethods methods;

  const TencentCloudChatMessageRowMessageSenderAvatar({super.key, required this.data, required this.methods});

  @override
  State<TencentCloudChatMessageRowMessageSenderAvatar> createState() =>
      _TencentCloudChatMessageRowMessageSenderAvatarState();
}

class _TencentCloudChatMessageRowMessageSenderAvatarState
    extends TencentCloudChatState<TencentCloudChatMessageRowMessageSenderAvatar> {
  TapDownDetails? _tapDownDetails;

  @override
  Widget defaultBuilder(BuildContext context) {
    final bool touchScreen = TencentCloudChatPlatformAdapter().isMobile ||
        (TencentCloudChatPlatformAdapter().isWeb &&
            TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.mobile);
    return GestureDetector(
      onTapDown: (details) {
        _tapDownDetails = details;
      },
      onSecondaryTapDown: ((details) {
        _tapDownDetails = details;
      }),
      onTap: () {
        if (_tapDownDetails != null) {
          widget.methods.onCustomUIEventPrimaryTapAvatar?.call(
            message: widget.data.message,
            tapDownDetails: _tapDownDetails!,
            userID: widget.data.userID,
            groupID: widget.data.groupID,
          );
        }
      },
      onLongPress: () {
        if (touchScreen && _tapDownDetails != null) {
          widget.methods.onCustomUIEventSecondaryTapAvatar?.call(
            message: widget.data.message,
            tapDownDetails: _tapDownDetails!,
            userID: widget.data.userID,
            groupID: widget.data.groupID,
          );
        }
      },
      onSecondaryTap: () {
        if (!touchScreen && _tapDownDetails != null) {
          widget.methods.onCustomUIEventSecondaryTapAvatar?.call(
            message: widget.data.message,
            tapDownDetails: _tapDownDetails!,
            userID: widget.data.userID,
            groupID: widget.data.groupID,
          );
        }
      },
      child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
        scene: (widget.data.message.isSelf ?? true)
            ? TencentCloudChatAvatarScene.messageListForSelf
            : TencentCloudChatAvatarScene.messageListForOthers,
        imageList: [widget.data.message.faceUrl ?? ""],
        width: getSquareSize(36),
        height: getSquareSize(36),
        borderRadius: getSquareSize(18),
      ),
    );
  }
}
