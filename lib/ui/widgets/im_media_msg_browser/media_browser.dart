import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'browser_page_routes.dart';
import 'im_media_msg_browser.dart';

class MediaBrowser {
  MediaBrowser._();

  static void showIMMediaMsg(
    BuildContext context, {
    required V2TimMessage curMsg,
    required String? userID,
    required String? groupID,
    required String? isFrom,
    ValueChanged<String>? onDownloadFile,
    ValueChanged<V2TimMessage>? onImgLongPress,
    ValueChanged<V2TimMessage>? onDownloadImage,
  }) {
    Navigator.push(
      context,
      BrowserTransparentPageRoute(
        pageBuilder: (_, __, ___) => IMMediaMsgBrowser(
          curMsg: curMsg,
          userID: userID,
          groupID: groupID,
          isFrom: isFrom,
          onDownloadFile: onDownloadFile,
          onImgLongPress: onImgLongPress,
          onDownloadImage: onDownloadImage,
        ),
      ),
    );
  }
}
