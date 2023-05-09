import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/friend_list_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

export 'package:tencent_cloud_chat_uikit/ui/widgets/contact_list.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class TIMUIKitContact extends StatefulWidget {
  /// the callback after clicking contact item
  final void Function(V2TimFriendInfo item)? onTapItem;

  /// the list on top
  final List<TopListItem>? topList;

  /// the builder for the list on top
  final Widget? Function(TopListItem item)? topListItemBuilder;

  /// The widget shows when no contacts exists.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// the life cycle hooks for friend list or contacts list business logic
  final FriendListLifeCycle? lifeCycle;

  /// Control if shows the online status for each user on its avatar.
  final bool isShowOnlineStatus;

  const TIMUIKitContact(
      {Key? key,
      this.onTapItem,
      this.lifeCycle,
      this.topList,
      this.topListItemBuilder,
      this.emptyBuilder,
      this.isShowOnlineStatus = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitContactState();
}

class _TIMUIKitContactState extends TIMUIKitState<TIMUIKitContact> {
  final TUIFriendShipViewModel model = serviceLocator<TUIFriendShipViewModel>();
  String currentItem = "";


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    final isDesktopScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: model),
        ],
        builder: (context, w) {
          final model = Provider.of<TUIFriendShipViewModel>(context);
          model.contactListLifeCycle = widget.lifeCycle;
          final memberList = model.friendList ?? [];

          return ContactList(
            currentItem: currentItem,
            emptyBuilder: widget.emptyBuilder,
            isShowOnlineStatus: widget.isShowOnlineStatus,
            contactList: memberList,
            onTapItem: (item){
              if(isDesktopScreen){
                setState(() {
                  currentItem = item.userID;
                });
              }
              if(widget.onTapItem != null){
                widget.onTapItem!(item);
              }
            },
            bgColor: isDesktopScreen ? theme.wideBackgroundColor : null,
            topList: widget.topList,
            topListItemBuilder: widget.topListItemBuilder,
          );
        });
  }
}
