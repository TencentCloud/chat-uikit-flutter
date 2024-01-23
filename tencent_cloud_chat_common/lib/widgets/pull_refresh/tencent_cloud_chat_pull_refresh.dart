import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class TencentCloudChatPullRefresh extends StatefulWidget {
  const TencentCloudChatPullRefresh({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatPullRefreshState();
}

class TencentCloudChatPullRefreshState
    extends State<TencentCloudChatPullRefresh> {
  RefreshController controller = RefreshController();
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: controller,
    );
  }
}
