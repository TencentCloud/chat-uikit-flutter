import 'dart:io';

import 'package:flutter/cupertino.dart';

/// Type for a function that creates image widgets.
typedef ImageBuilder = Widget Function(
    Uri uri, String? imageDirectory, double? width, double? height);

Widget _handleDataSchemeUri(
    Uri uri, final double? width, final double? height) {
  final String mimeType = uri.data!.mimeType;
  if (mimeType.startsWith('image/')) {
    return Image.memory(
      uri.data!.contentAsBytes(),
      width: width,
      height: height,
    );
  } else if (mimeType.startsWith('text/')) {
    return Text(uri.data!.contentAsString());
  }
  return const SizedBox();
}

class MDImageRenderer extends StatelessWidget{
  final String src;
  final String? title;
  final String? alt;
  MDImageRenderer({super.key, required this.src, this.title, this.alt});

  /// A default image builder handling http/https, resource, and file URLs.
// ignore: prefer_function_declarations_over_variables
  final ImageBuilder kDefaultImageBuilder = (
      Uri uri,
      String? imageDirectory,
      double? width,
      double? height,
      ) {
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return Image.network(uri.toString(), width: width, height: height);
    } else if (uri.scheme == 'data') {
      return _handleDataSchemeUri(uri, width, height);
    } else if (uri.scheme == 'resource') {
      return Image.asset(uri.path, width: width, height: height);
    } else {
      final Uri fileUri = imageDirectory != null
          ? Uri.parse(imageDirectory + uri.toString())
          : uri;
      if (fileUri.scheme == 'http' || fileUri.scheme == 'https') {
        return Image.network(fileUri.toString(), width: width, height: height);
      } else {
        return Image.file(File.fromUri(fileUri), width: width, height: height);
      }
    }
  };

  Widget _buildImage(String src, String? title, String? alt) {
    final List<String> parts = src.split('#');
    if (parts.isEmpty) {
      return const SizedBox();
    }

    final String path = parts.first;
    double? width;
    double? height;
    if (parts.length == 2) {
      final List<String> dimensions = parts.last.split('x');
      if (dimensions.length == 2) {
        width = double.parse(dimensions[0]);
        height = double.parse(dimensions[1]);
      }
    }

    final Uri uri = Uri.parse(path);
    Widget child;
    if (false) {
      // child = imageBuilder!(uri, title, alt);
    } else {
      child = kDefaultImageBuilder(uri, "", width, height);
    }

    return GestureDetector(onTap:(){

    }, child: child);
  }

  @override
  Widget build(BuildContext context) {
    throw _buildImage(src, title, alt);
  }

}