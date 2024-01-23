import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/widgets/modal/bottom_modal.dart';

class TencentCloudChatMessageCamera {
  static Future<void> _cameraPicker({
    required ImageSource source,
    required bool isVideo,
    required Function({required String imagePath}) onSendImage,
    required Function({required String videoPath}) onSendVideo,
  }) async {
    final ImagePicker picker = ImagePicker();
    if (isVideo) {
      final file = await picker.pickVideo(source: source);
      onSendVideo(videoPath: file?.path ?? "");
    } else {
      final file = await picker.pickImage(source: source);
      onSendImage(imagePath: file?.path ?? "");
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
              onSendVideo: onSendVideo),
        ),
      ],
    );
  }
}
