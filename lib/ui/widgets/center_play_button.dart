import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class CenterPlayButton extends TIMUIKitStatelessWidget {
  CenterPlayButton({
    Key? key,
    required this.show,
    required this.isPlaying,
    this.onPressed,
  }) : super(key: key);

  final bool show;
  final bool isPlaying;
  final VoidCallback? onPressed;

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: AnimatedOpacity(
            opacity: show ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              child: IconButton(
                iconSize: 86,
                icon: Image.asset('images/play.png', package: 'tencent_cloud_chat_uikit',width: 86, height: 86),
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
