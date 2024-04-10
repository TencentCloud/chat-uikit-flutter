import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:wb_flutter_tool/wb_flutter_tool.dart';

extension Wbfileext on String {

  Future<String> decryptImgPath(String fileName) async {
    String? fileFormat;
    var hasFormat = false;
    List<String> imgFormats = [".jpg", ".png", ".gif", ".webp"];

    for (String form in imgFormats) {
      if (this.contains(form)) {
        hasFormat = true;
      }
    }
    if (hasFormat) {
      fileFormat = this.split(".")[max(this
          .split(".")
          .length - 1, 0)];
    } else {
      fileFormat = ".jpg";
    }
    String lastdierName = this.split("/")[max(this
        .split("/")
        .length - 1, 0)];
    String saveDirec = this.replaceAll(lastdierName, "");

    String saveNewName = lastdierName.replaceAll(
        ".${fileFormat}", "_decrypt.${fileFormat}");
    if (!hasFormat) {
      saveNewName = lastdierName + fileFormat!;
    }

      if (!File("${saveDirec}/${saveNewName}").existsSync()) {
        var aescode = Uint8List.fromList(aesKey.codeUnits);
        var file = File(this).readAsBytesSync();
        var imgfile = file.sublist(aescode.length, file.length);
        print("file path:${this},file name:${fileName}");
       await File("${saveDirec}/${saveNewName}")
          ..createSync(recursive: true)
          ..writeAsBytesSync(imgfile);
      }

    return Future.value("${saveDirec}/${saveNewName}");
  }
}