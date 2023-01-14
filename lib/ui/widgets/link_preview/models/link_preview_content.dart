import 'dart:convert';

import 'package:flutter/cupertino.dart';

typedef LinkPreviewText = Widget Function({TextStyle? style});

class LocalCustomDataModel {
  final String? description;
  final String? image;
  final String? url;
  final String? title;
  String? translatedText;

  LocalCustomDataModel(
      {this.description, this.image, this.url, this.title, this.translatedText});

  Map<String, String?> toMap() {
    final Map<String, String?> data = {};
    data['url'] = url;
    data['image'] = image;
    data['title'] = title;
    data['description'] = description;
    data['translatedText'] = translatedText;
    return data;
  }

  LocalCustomDataModel.fromMap(Map map)
      : description = map['description'],
        image = map['image'],
        url = map['url'],
        translatedText = map['translatedText'],
        title = map['title'];

  @override
  String toString() {
    return json.encode(toMap());
  }

  bool isLinkPreviewEmpty() {
    if ((image == null || image!.isEmpty) &&
        (title == null || title!.isEmpty) &&
        (description == null || description!.isEmpty)) {
      return true;
    }
    return false;
  }
}

class LinkPreviewContent {
  const LinkPreviewContent({
    this.linkInfo,
    this.linkPreviewWidget,
  });

  final LocalCustomDataModel? linkInfo;
  final Widget? linkPreviewWidget;
}
