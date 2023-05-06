// ignore_for_file: avoid_print, file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class TIMUIKitSearchExample extends StatelessWidget {
  const TIMUIKitSearchExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TIMUIKitSearch(
      onTapConversation: (conv, message) {
      },
      onEnterConversation: (V2TimConversation conversation, String keyword) {},
    );
  }
}
