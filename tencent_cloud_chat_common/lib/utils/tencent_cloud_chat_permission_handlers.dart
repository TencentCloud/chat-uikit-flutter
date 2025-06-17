import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';

class TencentCloudChatPermissionHandler {
  static Future<Permission?> getPermissionEnum(String permissionString) async {
    switch (permissionString) {
      case 'camera':
        return Permission.camera;
      case 'microphone':
        return Permission.microphone;
      case 'storage':
        if (TencentCloudChatPlatformAdapter().isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt <= 32) {
            return Permission.storage;
          } else {
            return Permission.manageExternalStorage;
          }
        }
      case 'photos':
        if (TencentCloudChatPlatformAdapter().isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt <= 32) {
            return Permission.storage;
          } else {
            return Permission.photos;
          }
        }
        return Permission.photos;
      default:
        return null;
    }
  }

  static Future<bool> checkPermission(String permissionString, BuildContext context) async {
    final permission = await getPermissionEnum(permissionString);
    if (permission != null) {
      PermissionStatus prevStatus = await permission.status;
      PermissionStatus requestResult = await permission.request();
      if (requestResult.isDenied || requestResult.isPermanentlyDenied) {
        final permission = TencentCloudChat.instance.cache.getPermission();
        final exist = permission.contains(permissionString);
        if (!exist) {
          TencentCloudChat.instance.cache.cachePermission(permissionString);
          return false;
        } else {
          TencentCloudChatDialog.showAdaptiveDialog(
            context: context,
            title: Text(tL10n.permissionDeniedTitle),
            content: Text(tL10n.permissionDeniedContent(permissionString)),
            actions: [
              TextButton(
                child: Text(tL10n.goToSettingsButtonText),
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
              ),
              TextButton(
                child: Text(tL10n.cancel),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
          return false;
        }
      }

      /// Special case for `microphone`
      if (permission == Permission.microphone && (prevStatus.isDenied || prevStatus.isPermanentlyDenied)) {
        return false;
      }

      if (requestResult.isGranted || requestResult.isLimited || requestResult.isRestricted) {
        return true;
      } else {
        PermissionStatus newStatus = await permission.request();
        return newStatus.isGranted;
      }
    } else {
      return true;
    }
  }
}
