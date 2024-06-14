import 'package:flutter/material.dart';
import 'package:zhaopin/im/base_widgets/tim_ui_kit_base.dart';
import 'package:zhaopin/im/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:zhaopin/im/tencent_cloud_chat_uikit.dart';

class TIMUIKitSearchFolder extends TIMUIKitStatelessWidget {
  final String folderName;
  final List<Widget> children;

  TIMUIKitSearchFolder(
      {Key? key, required this.folderName, required this.children})
      : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: hexToColor("DBDBDB"), width: 0.5))),
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
            child: Text(
              folderName,
              style: TextStyle(
                  color: theme.weakTextColor, height: 1.5, fontSize: 14),
            ),
          ),
          ...children
        ],
      ),
    );
  }
}
