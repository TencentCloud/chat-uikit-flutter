import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class TencentCloudChatDesktopImageTools {
  static sendImageOnDesktop({
    Size? imageSize,
    required BuildContext context,
    required String imagePath,
    String? imageName,
    dynamic inputElement,
    required String currentConversationShowName,
    required Function({String? imagePath, String? imageName, dynamic inputElement}) sendImageMessage,
  }) async {
    final Size size = imageSize ?? await getImageSize(imagePath);

    TencentCloudChatDesktopPopup.showPopupWindow(
      operationKey: TencentCloudChatPopupOperationKey.sendResourcesOnDesktop,
      context: context,
      isDarkBackground: false,
      width: 500,
      height: min(500, size.height / 2 + 140),
      title: tL10n.sendToSomeChat(currentConversationShowName),
      child: (closeFunc) => Container(
        padding: const EdgeInsets.all(16),
        child: TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: min(360, size.height / 2),
                child: InkWell(
                  onTap: () {
                    launchUrl(TencentCloudChatPlatformAdapter().isWeb ? Uri.parse(imagePath) : Uri.file(imagePath));
                  },
                  child: TencentCloudChatPlatformAdapter().isWeb
                      ? Image.network(
                          imagePath,
                          height: min(360, size.height / 2),
                        )
                      : Image.file(
                          File(imagePath),
                          height: min(360, size.height / 2),
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
                          return BorderSide(color: colorTheme.dividerColor, width: 1);
                        }),
                      ),
                      onPressed: () {
                        closeFunc();
                      },
                      child: Text(tL10n.cancel)),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        sendImageMessage(
                          imagePath: imagePath,
                          imageName: imageName,
                          inputElement: inputElement,
                        );
                        closeFunc();
                      },
                      child: Text(tL10n.send))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<String?> captureScreen() async {
    await requestScreenRecordingPermission();
    String directory;

    if (TencentCloudChatPlatformAdapter().isWindows) {
      final String documentsDirectoryPath = "${Platform.environment['USERPROFILE']}";
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String pkgName = packageInfo.packageName;
      directory = Pertypath().join(documentsDirectoryPath, "Documents", ".TencentCloudChat", pkgName, "screenshots");
    } else {
      final dic = await getApplicationSupportDirectory();
      directory = dic.path;
    }
    final uuid = DateTime.now().microsecondsSinceEpoch;
    final fileName = 'screenshot_$uuid.png';
    final filePath = '$directory/$fileName';
    if (Platform.isMacOS) {
      // 在macOS平台上使用screencapture工具
      final result = await Process.run(
        'screencapture',
        ['-i', '-s', '-o', filePath],
      );
      if (result.exitCode == 0) {
        return filePath;
      } else {
        return null;
      }
    } else if (Platform.isWindows) {
      // 在Windows平台上使用snippingtool工具
      final result = await Process.run(
        'snippingtool',
        ['/clip', filePath],
      );
      if (result.exitCode == 0) {
        return filePath;
      } else {
        return null;
      }
    } else {
      // 不支持的平台
      return null;
    }
  }

  static Future<bool> requestScreenRecordingPermission() async {
    if (Platform.isMacOS) {
      final result = await Process.run('sh', ['-c', 'echo ${Platform.environment['USER']}']);
      final username = result.stdout.toString().trim();
      const script = 'tell application "System Events" to return exists (processes where name is "ControlCenter")';
      final process = await Process.run('osascript', ['-e', script]);
      final isControlCenterRunning = process.stdout.toString().trim() == 'true';

      if (!isControlCenterRunning) {
        await Process.run('open', ['-a', 'ControlCenter']);
        await Future.delayed(const Duration(seconds: 1));
      }

      final script2 = 'tell application "ControlCenter" to activate\n'
          'tell application "System Events"\n'
          '    tell process "ControlCenter"\n'
          '        click menu item "Screen Recording" of menu "File" of menu bar 1\n'
          '        delay 0.5\n'
          '        keystroke "$username" & return\n'
          '    end tell\n'
          'end tell\n';
      await Process.run('osascript', ['-e', script2]);

      await Future.delayed(const Duration(seconds: 1));
      final isScreenRecordingEnabled = await SystemChannels.platform.invokeMethod<bool>('isScreenRecordingEnabled');
      return isScreenRecordingEnabled ?? false;
    } else {
      return true;
    }
  }

  static Future<Size> getImageSize(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final completer = Completer<Size>();
    final imageStream = Image.memory(bytes).image.resolve(ImageConfiguration.empty);
    imageStream.addListener(ImageStreamListener((imageInfo, _) {
      completer.complete(Size(imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble()));
    }));
    return completer.future;
  }
}
