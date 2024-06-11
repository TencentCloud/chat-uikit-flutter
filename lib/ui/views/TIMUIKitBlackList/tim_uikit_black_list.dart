import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/block_list_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';

import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

typedef BlackListItemBuilder = Widget Function(
    BuildContext context, V2TimFriendInfo friendInfo);

class TIMUIKitBlackList extends StatefulWidget {
  final void Function(V2TimFriendInfo friendInfo)? onTapItem;
  final Widget Function(BuildContext context)? emptyBuilder;
  final BlackListItemBuilder? itemBuilder;

  /// The life cycle hooks for block list business logic
  final BlockListLifeCycle? lifeCycle;

  const TIMUIKitBlackList(
      {Key? key,
      this.onTapItem,
      this.emptyBuilder,
      this.itemBuilder,
      this.lifeCycle})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitBlackListState();
}

class _TIMUIKitBlackListState extends TIMUIKitState<TIMUIKitBlackList> {
  final TUIFriendShipViewModel _friendshipViewModel =
      serviceLocator<TUIFriendShipViewModel>();

  _getShowName(V2TimFriendInfo item) {
    final friendRemark = item.friendRemark ?? "";
    final nickName = item.userProfile?.nickName ?? "";
    final userID = item.userID;
    final showName = nickName != "" ? nickName : userID;
    return friendRemark != "" ? friendRemark : showName;
  }

  Widget _itemBuilder(BuildContext context, V2TimFriendInfo friendInfo) {
    final theme = Provider.of<TUIThemeViewModel>(context).theme;
    final showName = _getShowName(friendInfo);
    final faceUrl = friendInfo.userProfile?.faceUrl ?? "";
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    Widget itemWidget() {
      return Material(
        color: theme.wideBackgroundColor,
        child: InkWell(
          onTap: () {
            if (widget.onTapItem != null) {
              widget.onTapItem!(friendInfo);
            }
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: theme.weakDividerColor ??
                            CommonColor.weakDividerColor))),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  margin: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    height: isDesktopScreen ? 30 : 40,
                    width: isDesktopScreen ? 30 : 40,
                    child: Avatar(faceUrl: faceUrl, showName: showName),
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    showName,
                    style: TextStyle(
                        color: theme.black, fontSize: isDesktopScreen ? 14 : 18),
                  ),
                )),
                if (isDesktopScreen)
                  OutlinedButton(
                      onPressed: () {
                        _friendshipViewModel
                            .deleteFromBlockList([friendInfo.userID]);
                      },
                      child: Text(
                        TIM_t("移出黑名单"),
                        style: TextStyle(color: theme.primaryColor),
                      ))
              ],
            ),
          ),
        ),
      );
    }

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: itemWidget(),
        defaultWidget: Slidable(
          endActionPane: ActionPane(motion: const DrawerMotion(), children: [
            SlidableAction(
              onPressed: (context) async {
                await _friendshipViewModel
                    .deleteFromBlockList([friendInfo.userID]);
              },
              backgroundColor: theme.cautionColor ?? CommonColor.cautionColor,
              foregroundColor: theme.white,
              label: TIM_t("删除"),
              autoClose: true,
            )
          ]),
          child: itemWidget(),
        ));
  }

  BlackListItemBuilder _getItemBuilder() {
    return widget.itemBuilder ?? _itemBuilder;
  }


  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _friendshipViewModel),
      ],
      builder: (BuildContext context, Widget? w) {
        final model = Provider.of<TUIFriendShipViewModel>(context);
        model.blockListLifeCycle = widget.lifeCycle;
        final blockList = model.blockList;
        if (blockList.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: blockList.length,
            itemBuilder: (context, index) {
              final friendInfo = blockList[index];
              final itemBuilder = _getItemBuilder();
              return itemBuilder(context, friendInfo);
            },
          );
        }

        if (widget.emptyBuilder != null) {
          return widget.emptyBuilder!(context);
        }

        return Container();
      },
    );
  }
}
