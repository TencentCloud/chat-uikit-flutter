import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:uuid/uuid.dart';

class ScreenshotHelper {
  static Future<String?> captureScreen() async {
    await requestScreenRecordingPermission();
    String directory;

    if(PlatformUtils().isWindows){
      final String documentsDirectoryPath =
          "${Platform.environment['USERPROFILE']}";
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String pkgName = packageInfo.packageName;
      directory = p.join(documentsDirectoryPath, "Documents", ".TencentCloudChat",
          pkgName, "screenshots");
    }else{
      final dic = await getApplicationSupportDirectory();
      directory = dic.path;
    }

    const uuid = Uuid();
    final fileName = 'screenshot_${uuid.v4()}.png';
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
      final result = await Process.run(
          'sh', ['-c', 'echo ${Platform.environment['USER']}']);
      final username = result.stdout.toString().trim();
      const script =
          'tell application "System Events" to return exists (processes where name is "ControlCenter")';
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
      final isScreenRecordingEnabled = await SystemChannels.platform
          .invokeMethod<bool>('isScreenRecordingEnabled');
      return isScreenRecordingEnabled ?? false;
    } else {
      return true;
    }
  }

  static Future<Size> getImageSize(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final completer = Completer<Size>();
    final imageStream =
        Image.memory(bytes).image.resolve(ImageConfiguration.empty);
    imageStream.addListener(ImageStreamListener((imageInfo, _) {
      completer.complete(Size(
          imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble()));
    }));
    return completer.future;
  }

}
