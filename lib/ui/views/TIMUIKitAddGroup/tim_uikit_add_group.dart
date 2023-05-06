import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/add_group_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/conversation/conversation_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';

import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitAddGroup/tim_uikit_send_application.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class TIMUIKitAddGroup extends StatefulWidget {
  /// The life cycle hooks for adding group business logic
  final AddGroupLifeCycle? lifeCycle;

  /// Navigate to group chat, if user is already a member of the current group.
  final Function(String groupID, V2TimConversation conversation)
      onTapExistGroup;

  final VoidCallback? closeFunc;

  const TIMUIKitAddGroup(
      {Key? key, this.lifeCycle, required this.onTapExistGroup, this.closeFunc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIMUIKitAddGroupState();
}

class _TIMUIKitAddGroupState extends TIMUIKitState<TIMUIKitAddGroup> {
  final TextEditingController _controller = TextEditingController();
  final GroupServices _groupServices = serviceLocator<GroupServices>();
  final ConversationService _conversationService =
      serviceLocator<ConversationService>();
  final TUIFriendShipViewModel friendShipViewModel =
      serviceLocator<TUIFriendShipViewModel>();
  List<V2TimGroupInfo>? _addedGroupList;
  List<V2TimGroupInfo>? groupResult = [];
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;
  bool showResult = false;

  String _getGroupType(String type) {
    String groupType;
    switch (type) {
      case GroupType.AVChatRoom:
        groupType = TIM_t("聊天室");
        break;
      case GroupType.Meeting:
        groupType = TIM_t("会议群");
        break;
      case GroupType.Public:
        groupType = TIM_t("公开群");
        break;
      case GroupType.Work:
        groupType = TIM_t("工作群");
        break;
      default:
        groupType = TIM_t("未知群");
        break;
    }
    return groupType;
  }

  Widget _searchResultItemBuilder(V2TimGroupInfo groupInfo, TUITheme theme) {
    final faceUrl = groupInfo.faceUrl ?? "";
    final groupID = groupInfo.groupID;
    final showName = groupInfo.groupName ?? groupID;
    final groupType = _getGroupType(groupInfo.groupType);
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return InkWell(
      onTap: () async {
        final V2TimConversation? groupConversation =
            await getGroupConversation(groupID);
        if (groupConversation != null) {
          onTIMCallback(TIMCallback(
              type: TIMCallbackType.INFO,
              infoRecommendText: TIM_t("您已是群成员"),
              infoCode: 6660202));
          if (widget.closeFunc != null) {
            widget.closeFunc!();
          }
          widget.onTapExistGroup(groupID, groupConversation);
          return;
        }

        if(isDesktopScreen){
          if (widget.closeFunc != null) {
            widget.closeFunc!();
          }
          TUIKitWidePopup.showPopupWindow(
            operationKey: TUIKitWideModalOperationKey.addGroup,
            context: context,
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.4,
            title: TIM_t("添加群聊"),
            child: (closeFuncSendApplication) => SendJoinGroupApplication(
                lifeCycle: widget.lifeCycle,
                groupInfo: groupInfo,
            ),
          );
        }else{
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SendJoinGroupApplication(
                    lifeCycle: widget.lifeCycle,
                    groupInfo: groupInfo,
                  )));
        }

      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isDesktopScreen ? 38 : 48,
              height: isDesktopScreen ? 38 : 48,
              margin: const EdgeInsets.only(right: 16),
              child: Avatar(faceUrl: faceUrl, showName: showName),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showName,
                  style: TextStyle(fontSize: isDesktopScreen ? 16 : 18),
                ),
                Text(
                  "ID: $groupID",
                  style: TextStyle(fontSize: 12, color: theme.weakTextColor),
                ),
                Text(
                  "群类型: $groupType",
                  style: TextStyle(fontSize: 12, color: theme.weakTextColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _searchResultBuilder(
      List<V2TimGroupInfo>? searchResult, TUITheme theme) {
    final noResult = searchResult != null && searchResult.isEmpty;
    if (noResult) {
      return [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Center(
            child: Text(TIM_t("该群聊不存在"),
                style: TextStyle(color: theme.weakTextColor, fontSize: 14)),
          ),
        )
      ];
    }
    return searchResult
            ?.map((e) => _searchResultItemBuilder(e, theme))
            .toList() ??
        [];
  }

  Future<V2TimConversation?> getGroupConversation(String groupID) async {
    if (_addedGroupList == null || _addedGroupList!.isEmpty) {
      _addedGroupList = await _groupServices.getJoinedGroupList();
    }
    try {
      if ((_addedGroupList?.firstWhere((groupItem) {
            return groupItem.groupID == groupID;
          })) !=
          null) {
        V2TimConversation? conversation;
        conversation = await _conversationService
            .getConversationListByConversationId(convID: "group_$groupID");
        if (conversation == null) {
          await friendShipViewModel.loadGroupListData();
          if (friendShipViewModel.groupList
                  .indexWhere((element) => element.groupID == groupID) >
              -1) {
            final V2TimGroupInfo groupInfo = friendShipViewModel.groupList
                .firstWhere((element) => element.groupID == groupID);
            conversation = V2TimConversation(
              conversationID: "group_$groupID",
              type: 2,
              groupID: groupID,
              showName: groupInfo.groupName,
              groupType: groupInfo.groupType,
            );
          }
        }
        return conversation;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      final _isFocused = _focusNode.hasFocus;
      isFocused = _isFocused;
      setState(() {});
    });
    initGroupList();
  }

  void initGroupList() async {
    // Get the joined group list in previous
    _addedGroupList = await _groupServices.getJoinedGroupList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  searchGroup(String params) async {
    final res = await _groupServices.getGroupsInfo(groupIDList: [params]);
    if (res != null) {
      setState(() {
        groupResult = res
            .where((e) => e.resultCode == 0)
            .map((e) => e.groupInfo!)
            .toList();
      });
    } else {
      setState(() {
        groupResult = [];
      });
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                autofocus: true,
                focusNode: _focusNode,
                controller: _controller,
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    setState(() {
                      showResult = false;
                    });
                  }
                },
                textInputAction: TextInputAction.search,
                onSubmitted: (_) {
                  final searchParams = _controller.text;
                  if (searchParams.trim().isNotEmpty) {
                    searchGroup(searchParams);
                    showResult = true;
                    _focusNode.requestFocus();
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: theme.weakTextColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(
                      color: theme.weakTextColor,
                    ),
                    fillColor: theme.inputFillColor,
                    filled: true,
                    hintText: TIM_t("搜索群ID")),
              )),
            ],
          ),
        ),
        if (showResult)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: _searchResultBuilder(groupResult, theme),
                ),
              ),
            ),
          )
      ],
    );
  }
}
