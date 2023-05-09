import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/unread_message.dart';

class TIMUIKitUnreadCount extends StatefulWidget {
  final double width;
  final double height;

  const TIMUIKitUnreadCount({Key? key, this.width = 22.0, this.height = 22.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitUnreadCountState();
}

class _TIMUIKitUnreadCountState extends TIMUIKitState<TIMUIKitUnreadCount> {
  final TUIFriendShipViewModel model = serviceLocator<TUIFriendShipViewModel>();


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return ChangeNotifierProvider.value(
        value: model,
        child:
            Consumer<TUIFriendShipViewModel>(builder: (context, value, child) {
          final friendApplicationAmount = value.friendApplicationAmount;
          if (friendApplicationAmount > 0) {
            return UnreadMessage(
                width: widget.width,
                height: widget.height,
                unreadCount: friendApplicationAmount);
          }
          return Container();
        }));
  }
}
