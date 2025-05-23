// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_item.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_folder.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_search_view_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_showAll.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class TIMUIKitSearchFriend extends StatefulWidget {
  List<V2TimFriendInfoResult> friendResultList;
  final Function(V2TimConversation, V2TimMessage?) onTapConversation;

  TIMUIKitSearchFriend({required this.friendResultList, Key? key, required this.onTapConversation}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TIMUIKitSearchFriendState();
}

class TIMUIKitSearchFriendState extends TIMUIKitState<TIMUIKitSearchFriend> {
  bool isShowAll = false;
  int defaultShowLines = 3;

  Widget _renderShowALl(int currentLines) {
    return (isShowAll == false && currentLines > defaultShowLines)
        ? TIMUIKitSearchShowALl(
            textShow: TIM_t("全部联系人"),
            onClick: () => setState(() {
              isShowAll = true;
            }),
          )
        : Container();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    List<V2TimConversation?> _conversationList = Provider.of<TUISearchViewModel>(context).conversationList;

    List<V2TimFriendInfoResult> filteredFriendResultList = widget.friendResultList.where((friend) {
      int index = _conversationList.indexWhere((conv) => friend.friendInfo?.userID == conv?.userID);
      return index == -1 ? false : true;
    }).toList();

    List<V2TimFriendInfoResult> halfFilteredFriendResultList = isShowAll
        ? filteredFriendResultList
        : filteredFriendResultList.sublist(0, min(defaultShowLines, filteredFriendResultList.length));

    if (filteredFriendResultList.isNotEmpty) {
      return TIMUIKitSearchFolder(folderName: TIM_t("联系人"), children: [
        ...halfFilteredFriendResultList.map((conv) {
          int convIndex = _conversationList.indexWhere((item) => conv.friendInfo?.userID == item?.userID);
          V2TimConversation conversation = _conversationList[convIndex]!;
          late String? showNickName;
          if (conv.friendInfo?.friendRemark != null && conv.friendInfo?.friendRemark != "") {
            showNickName = conv.friendInfo?.friendRemark;
          } else if (conv.friendInfo?.userProfile?.nickName != null && conv.friendInfo?.userProfile?.nickName != "") {
            showNickName = conv.friendInfo?.userProfile?.nickName;
          } else {
            showNickName = conv.friendInfo?.userID;
          }

          return TIMUIKitSearchItem(
            onClick: () {
              widget.onTapConversation(conversation, null);
            },
            faceUrl: conv.friendInfo?.userProfile?.faceUrl ?? "",
            showName: "",
            lineOne: conversation.userID!,
            lineTwo: TIM_t("昵称") + ":" + showNickName!,
          );
        }).toList(),
        _renderShowALl(filteredFriendResultList.length),
      ]);
    } else {
      return Container();
    }
  }
}
