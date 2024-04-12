import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:wb_flutter_tool/wb_flutter_tool.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

extension Wbfileext on String {

  Future<String> decryptPath({ String fileName = "", bool isImg = true}) async {
    String? fileFormat;
    var hasFormat = false;
    List<String> imgFormats = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'webp'];
    if (!isImg) {
      imgFormats = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'mpeg', 'webm', '3gp',"MP4"];
    }
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
      fileFormat = isImg ? ".jpg":".mp4";
    }
    var str = "/";
    if (PlatformUtils().isWindows) {
      str = "\\";
    }

    String lastdierName = this.split(str)[max(this
        .split(str)
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



  static Future<String?> compressImage(String imagePath, double scale) {
    // 替换为你的图像文件路径
    final File imageFile = File(imagePath);

    final img.Image? originalImage = img.decodeImage(imageFile.readAsBytesSync());
    if (originalImage == null) {
      print('无法解码图像文件');
      return Future(() => null);
    }

    final img.Image compressedImage = img.copyResize(originalImage, width: originalImage!.width,
        height: originalImage!.height
    ); // 调整图像尺寸
    final String compressedImagePath = path.join(path.dirname(imagePath),
        '${path.basenameWithoutExtension(imagePath)}_compressed_image.jpg');
    if (!File(compressedImagePath).existsSync()) {
      File(compressedImagePath).writeAsBytesSync(img.encodeJpg(compressedImage, quality: 60)); // 压缩质量（0-100）
    }
    // 压缩后的图像文件
    print('压缩后的图像文件路径：$compressedImagePath');
    return Future(() => compressedImagePath);
  }
  Future<String> encryptVideo(String fileFormat) async {
    File file = File(this!);
    final int size = file.lengthSync();
    final String savePath = file.path;
    var fileFormat = savePath.split(".")[max(savePath.split(".").length - 1, 0)];
    var encryptPath = savePath.replaceAll(".${fileFormat}", "_encrypt.${fileFormat}");
    var aescode = Uint8List.fromList( aesKey.codeUnits);
    if (!File(encryptPath).existsSync()) {
      var filedata =  file.readAsBytesSync();
      var imgFile = Uint8List.fromList(aescode + filedata);
      print("video file data: ${imgFile}");

      int fileSize = imgFile.lengthInBytes;
      File(encryptPath)..createSync(recursive: true)..writeAsBytesSync(imgFile);
    }
    print("video file path:${encryptPath},file name:${this}");



    return Future.value(encryptPath);
  }
  Future<String> encrypyPath(String fileFormat) async{
    var path = await compressImage(this, 0.6);
    if (path == null) {
      print("压缩失败");
      return Future.value("");
    }
    File file = File(path!);
    final int size = file.lengthSync();
    final String savePath = file.path;
    var aescode = Uint8List.fromList( aesKey.codeUnits);
    var filedata =  file.readAsBytesSync();
    var imgFile = Uint8List.fromList(aescode + filedata);
    print("file data: ${imgFile}");
    var fileFormat = savePath.split(".")[max(savePath.split(".").length - 1, 0)];
    var encryptPath = savePath.replaceAll(".${fileFormat}", "_encrypt.${fileFormat}");
    print("file path:${encryptPath},file name:${this}");
    int fileSize = imgFile.lengthInBytes;
    if (!File(encryptPath).existsSync()) {
      File(encryptPath)..createSync(recursive: true)..writeAsBytesSync(imgFile);
    }
    return Future.value(encryptPath);


  }
}