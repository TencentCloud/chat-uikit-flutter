import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

final outputLogger = Logger(
  output: _outputLogger ?? logOutputGenerator(null),
);

TUIKitOutput? _outputLogger;

TUIKitOutput logOutputGenerator(String? path) {
  _outputLogger = TUIKitOutput(path);
  return _outputLogger!;
}

class TUIKitOutput extends LogOutput {
  Future<void> createDirectoryIfNotExists(String path) async {
    final directory = Directory(p.dirname(path));

    if (await directory.exists() == false) {
      await directory.create(recursive: true);
    }
  }

  Future<void> deleteFilesOlderThanDays(String directoryPath, int days) async {
    final directory = Directory(directoryPath);
    final threshold = DateTime.now().subtract(Duration(days: days));

    await for (var fileEntity in directory.list(followLinks: false)) {
      if (fileEntity is File) {
        final lastModified = await fileEntity.lastModified();
        if (lastModified.isBefore(threshold)) {
          await fileEntity.delete();
        }
      }
    }
  }

  Future<String> getPlatformLogPath({String? path}) async {
    if (TencentUtils.checkString(path) != null) {
      print("The path to local log: $path");
      return path!;
    }

    final String documentsDirectoryPath =
        "${Platform.environment['USERPROFILE']}";
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String pkgName = packageInfo.packageName;
    var timeName =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    final logPath = p.join(documentsDirectoryPath, "Documents", ".TencentCloudChat",
        pkgName, "uikit_log", 'Flutter-TUIKit-$timeName.log');
    print("The path to local log: $logPath");

    return logPath;
  }

  File? logFile;

  TUIKitOutput(String? path) {
    if (!PlatformUtils().isWeb) {
      getPlatformLogPath(path: path).then((logFilePath) async {
        await createDirectoryIfNotExists(logFilePath);
        deleteFilesOlderThanDays(p.dirname(logFilePath), 7);
        logFile = File(logFilePath);
        if (logFile != null) {
          if (!logFile!.existsSync()) {
            logFile!.createSync(recursive: true);
          }
        }
      });
    }
  }

  @override
  void output(OutputEvent event) {
    var msg = "\n";
    for (var line in event.lines) {
      msg += "$line \n";
    }
    if (!PlatformUtils().isWeb) {
      if (logFile != null) {
        final sink = logFile!.openWrite(
          mode: FileMode.append,
          encoding: const SystemEncoding(),
        );
        sink.write(utf8.decode(utf8.encode(msg)));
        sink.close();
      } else {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          if (logFile != null) {
            final sink = logFile!.openWrite(
              mode: FileMode.append,
              encoding: const SystemEncoding(),
            );
            sink.write(msg);
            sink.close();
          }
        });
      }
    }
  }
}
