import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/base_life_cycle.dart';

class GroupProfileLifeCycle {
  /// In this case, you have better navigating to you home page or conversation list page,
  /// due to user request to leave the group, as quitting or disbanding.
  Future<void> Function() didLeaveGroup;

  GroupProfileLifeCycle({
    this.didLeaveGroup = DefaultLifeCycle.defaultPopBackRemind,
  });
}
