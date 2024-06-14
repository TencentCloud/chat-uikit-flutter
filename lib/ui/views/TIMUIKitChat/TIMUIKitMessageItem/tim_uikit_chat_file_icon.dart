// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhaopin/im/base_widgets/tim_ui_kit_base.dart';
import 'package:zhaopin/im/base_widgets/tim_ui_kit_statelesswidget.dart';

class TIMUIKitFileIcon extends TIMUIKitStatelessWidget {
  final String? fileFormat;
  final double? size;

  TIMUIKitFileIcon( {this.size, this.fileFormat, Key? key}) : super(key: key);

  Map fileMap = {
    "doc": "assets/im_images/word.png",
    "docx": "assets/im_images/word.png",
    "ppt": "assets/im_images/ppt.png",
    "pptx": "assets/im_images/ppt.png",
    "xls": "assets/im_images/excel.png",
    "xlsx": "assets/im_images/excel.png",
    "pdf": "assets/im_images/pdf.png",
    "zip": "assets/im_images/zip.png",
    "rar": "assets/im_images/zip.png",
    "7z": "assets/im_images/zip.png",
    "tar": "assets/im_images/zip.png",
    "gz": "assets/im_images/zip.png",
    "xz": "assets/im_images/zip.png",
    "bz2": "assets/im_images/zip.png",
    "txt": "assets/im_images/txt.png",
    "jpg": "assets/im_images/image_icon.png",
    "bmp": "assets/im_images/image_icon.png",
    "gif": "assets/im_images/image_icon.png",
    "png": "assets/im_images/image_icon.png",
    "jpeg": "assets/im_images/image_icon.png",
    "tif": "assets/im_images/image_icon.png",
    "wmf": "assets/im_images/image_icon.png",
    "dib": "assets/im_images/image_icon.png",
    "mp4": "assets/im_images/video_icon.png",
    "avi": "assets/im_images/video_icon.png",
    "mov": "assets/im_images/video_icon.png",
    "wmv": "assets/im_images/video_icon.png",
    "flv": "assets/im_images/video_icon.png",
  };

  Widget _getFileIcon() {
    return Image.asset(
      fileMap[fileFormat?.toLowerCase()] ?? "assets/im_images/unknown.png",
    );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return SizedBox(
      height: size ?? 50,
      width: size ?? 50,
      child: Container(padding: const EdgeInsets.all(4), child: _getFileIcon()),
    );
  }
}
