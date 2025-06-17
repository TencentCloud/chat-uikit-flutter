import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_permission_handlers.dart';
import 'package:tencent_cloud_chat_common/widgets/modal/bottom_modal.dart';

class TencentCloudChatMessageCamera {
  static Future<void> _cameraPicker({
    required BuildContext context,
    required ImageSource source,
    required bool isVideo,
    required Function({required String imagePath}) onSendImage,
    required Function({required String videoPath}) onSendVideo,
  }) async {
    if (TencentCloudChatPlatformAdapter().isMobile &&
        await TencentCloudChatPermissionHandler.checkPermission("camera", context)) {
      final ImagePicker picker = ImagePicker();
      if (isVideo) {
        final file = await picker.pickVideo(source: source);
        onSendVideo(videoPath: file?.path ?? "");
      } else {
        final file = await picker.pickImage(source: source);
        onSendImage(imagePath: file?.path ?? "");
      }
    }
  }

  static Future<void> showCameraOptions({
    required BuildContext context,
    required Function({required String imagePath}) onSendImage,
    required Function({required String videoPath}) onSendVideo,
  }) async {
    showTencentCloudChatBottomModal(
      context: context,
      actions: [
        TencentCloudChatModalAction(
          label: tL10n.takeAPhoto,
          icon: Icons.photo_camera,
          onTap: () => _cameraPicker(
              source: ImageSource.camera,
              context: context,
              isVideo: false,
              onSendImage: onSendImage,
              onSendVideo: onSendVideo),
        ),
        TencentCloudChatModalAction(
          label: tL10n.recordAVideo,
          icon: Icons.videocam,
          onTap: () => _cameraPicker(
              source: ImageSource.camera,
              isVideo: true,
              onSendImage: onSendImage,
              context: context,
              onSendVideo: onSendVideo),
        ),
      ],
    );
  }
}
