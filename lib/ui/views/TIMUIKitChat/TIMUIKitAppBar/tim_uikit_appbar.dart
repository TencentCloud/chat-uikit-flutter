// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/friendShip/friendship_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitAppBar/tim_uikit_appbar_title.dart';
import 'package:tuple/tuple.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class TIMUIKitAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Appbar config
  final AppBar? config;

  /// Allow show conversation total unread count
  final bool showTotalUnReadCount;

  /// Conversation id
  final String conversationID;

  /// conversation name
  final String conversationShowName;

  /// If allow update the conversation show name automatically.
  final bool isConversationShowNameFixed;

  final bool showC2cMessageEditStatus;

  final GestureTapDownCallback? onClickTitle;

  const TIMUIKitAppBar({
    Key? key,
    this.config,
    this.isConversationShowNameFixed = false,
    this.showTotalUnReadCount = true,
    this.conversationID = "",
    this.conversationShowName = "",
    this.showC2cMessageEditStatus = true,
    this.onClickTitle,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      config?.preferredSize ?? const Size.fromHeight(56.0);

  @override
  State<StatefulWidget> createState() => _TIMUIKitAppBarState();
}

class _TIMUIKitAppBarState extends TIMUIKitState<TIMUIKitAppBar> {
  final FriendshipServices _friendshipServices =
      serviceLocator<FriendshipServices>();
  final GroupServices _groupServices = serviceLocator<GroupServices>();

  V2TimFriendshipListener? _friendshipListener;
  V2TimGroupListener? _groupListener;

  String _conversationShowName = "";

  _addConversationShowNameListener() {
    _friendshipListener = V2TimFriendshipListener(
      onFriendInfoChanged: (infoList) {
        try {
          final changedInfo = infoList.firstWhere(
            (element) => element.userID == widget.conversationID,
          );
          if (changedInfo.friendRemark != null &&
              changedInfo.friendRemark!.isNotEmpty) {
            _conversationShowName = changedInfo.friendRemark!;
            setState(() {});
          } else {
            _conversationShowName = (changedInfo.userProfile?.nickName ??
                    changedInfo.userProfile?.userID) ??
                "";
          }
          // ignore: empty_catches
        } catch (e) {}
      },
    );
    if (_friendshipListener != null) {
      _friendshipServices.addFriendListener(listener: _friendshipListener!);
    }
  }

  _addGroupListener() {
    _groupListener = V2TimGroupListener(
      onGroupInfoChanged: (groupID, changeInfos) {
        try {
          if (groupID == widget.conversationID) {
            final groupNameChangeInfo = changeInfos.firstWhere((element) =>
                element.type ==
                GroupChangeInfoType.V2TIM_GROUP_INFO_CHANGE_TYPE_NAME);
            if (groupNameChangeInfo.value != null) {
              _conversationShowName = groupNameChangeInfo.value!;
              setState(() {});
            }
          }
          // ignore: empty_catches
        } catch (e) {}
      },
    );
    if (_groupListener != null) {
      _groupServices.addGroupListener(listener: _groupListener!);
    }
  }

  String _getTotalUnReadCount(int unreadCount) {
    return unreadCount < 99 ? unreadCount.toString() : "99";
  }

  @override
  void initState() {
    super.initState();
    _conversationShowName = widget.conversationShowName;
    if (!widget.isConversationShowNameFixed) {
      _addConversationShowNameListener();
      _addGroupListener();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget.isConversationShowNameFixed) {
      _groupServices.removeGroupListener(listener: _groupListener);
      _friendshipServices.removeFriendListener(listener: _friendshipListener);
    }
  }

  @override
  void didUpdateWidget(TIMUIKitAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversationShowName != widget.conversationShowName) {
      if (widget.conversationShowName.isNotEmpty) {
        setState(() {
          _conversationShowName = widget.conversationShowName;
        });
      } else {
        updateTitleFuture();
      }
    }
  }

  void updateTitleFuture() async {
    try {
      final res = await _friendshipServices
          .getFriendsInfo(userIDList: [widget.conversationID]);
      if (res != null && res.isNotEmpty && res.first.resultCode == 0) {
        setState(() {
          _conversationShowName = res.first.friendInfo?.userProfile?.nickName ??
              res.first.friendInfo?.userProfile?.userID ??
              "";
        });
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    final setAppbar = widget.config;
    final TUIChatSeparateViewModel chatVM =
        Provider.of<TUIChatSeparateViewModel>(context);
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return AppBar(
      backgroundColor: setAppbar?.backgroundColor ??
          theme.chatHeaderBgColor ??
          theme.appbarBgColor ??
          theme.primaryColor,
      actionsIconTheme: setAppbar?.actionsIconTheme,
      foregroundColor: setAppbar?.foregroundColor,
      elevation: setAppbar?.elevation ?? (isDesktopScreen ? 0 : 1),
      bottom: setAppbar?.bottom,
      bottomOpacity: setAppbar?.bottomOpacity ?? 1.0,
      titleSpacing: setAppbar?.titleSpacing,
      automaticallyImplyLeading: setAppbar?.automaticallyImplyLeading ?? false,
      shadowColor: setAppbar?.shadowColor ?? theme.weakDividerColor,
      excludeHeaderSemantics: setAppbar?.excludeHeaderSemantics ?? false,
      toolbarHeight: setAppbar?.toolbarHeight,
      titleTextStyle: setAppbar?.titleTextStyle,
      toolbarOpacity: setAppbar?.toolbarOpacity ?? 1.0,
      toolbarTextStyle: setAppbar?.toolbarTextStyle,

      // textTheme: setAppbar?.textTheme,
      iconTheme: setAppbar?.iconTheme ??
          const IconThemeData(
            color: Colors.white,
          ),
      title: TIMUIKitAppBarTitle(
        title: setAppbar?.title,
        onClick: widget.onClickTitle,
        textStyle: TextStyle(
            color: theme.appbarTextColor ?? hexToColor("010000"), fontSize: 16),
        conversationShowName: _conversationShowName,
        showC2cMessageEditStatus: widget.showC2cMessageEditStatus,
        fromUser: widget.conversationID,
      ),
      centerTitle: setAppbar?.centerTitle ?? (isDesktopScreen ? false : true),
      leadingWidth: setAppbar?.leadingWidth ?? (isDesktopScreen ? 8 : 70),
      leading: Selector<TUIChatGlobalModel, Tuple2<bool, int>>(
          builder: (context, data, _) {
            final isMultiSelect = data.item1;
            final unReadCount = data.item2;
            return (!isDesktopScreen && isMultiSelect)
                ? TextButton(
                    onPressed: () {
                      chatVM.updateMultiSelectStatus(false);
                    },
                    child: Text(
                      TIM_t('取消'),
                      style: TextStyle(
                        color: theme.appbarTextColor ?? hexToColor("010000"),
                        fontSize: 16,
                      ),
                    ),
                  )
                : setAppbar?.leading ??
                    (isDesktopScreen
                        ? Container()
                        : Row(
                            children: [
                              IconButton(
                                padding: const EdgeInsets.only(left: 16),
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: hexToColor("010000"),
                                  size: 17,
                                ),
                                onPressed: () async {
                                  chatVM.repliedMessage = null;
                                  Navigator.pop(context);
                                },
                              ),
                              if (widget.showTotalUnReadCount &&
                                  unReadCount > 0)
                                Container(
                                  width: 22,
                                  height: 22,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.cautionColor,
                                  ),
                                  child:
                                      Text(_getTotalUnReadCount(unReadCount)),
                                ),
                            ],
                          ));
          },
          shouldRebuild: (prev, next) =>
              prev.item1 != next.item1 || prev.item2 != next.item2,
          selector: (_, model) =>
              Tuple2(chatVM.isMultiSelect, model.totalUnReadCount)),
      actions: setAppbar?.actions,
    );
  }
}
