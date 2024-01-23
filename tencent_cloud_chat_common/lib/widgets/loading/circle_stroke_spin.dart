import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/widgets/loading/decorate.dart';

/// CircleStrokeSpin.
class TencentCloudChatCircleStrokeSpin extends StatelessWidget {
  const TencentCloudChatCircleStrokeSpin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = DecorateContext.of(context)!.decorateData.colors.first;
    return CircularProgressIndicator(
      strokeWidth: DecorateContext.of(context)!.decorateData.strokeWidth,
      color: color,
      backgroundColor:
          DecorateContext.of(context)!.decorateData.pathBackgroundColor,
    );
  }
}
