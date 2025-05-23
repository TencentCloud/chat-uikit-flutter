// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_item.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_folder.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_search_view_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_showAll.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class TIMUIKitSearchGroup extends StatefulWidget {
  List<V2TimGroupInfo> groupList;
  final Function(V2TimConversation, V2TimMessage?) onTapConversation;

  TIMUIKitSearchGroup({required this.groupList, Key? key, required this.onTapConversation}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TIMUIKitSearchGroupState();
}

class TIMUIKitSearchGroupState extends TIMUIKitState<TIMUIKitSearchGroup> {
  bool isShowAll = false;
  int defaultShowLines = 3;

  Widget _renderShowALl(int currentLines) {
    return (isShowAll == false && currentLines > defaultShowLines)
        ? TIMUIKitSearchShowALl(
            textShow: TIM_t("全部群聊"),
            onClick: () => setState(() {
              isShowAll = true;
            }),
          )
        : Container();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    List<V2TimConversation?> _conversationList = Provider.of<TUISearchViewModel>(context).conversationList;

    List<V2TimGroupInfo> filteredGroupResultList = widget.groupList.where((group) {
      int index = _conversationList.indexWhere((conv) => group.groupID == conv?.groupID);
      return index == -1 ? false : true;
    }).toList();

    List<V2TimGroupInfo> halfFilteredGroupResultList = isShowAll
        ? filteredGroupResultList
        : filteredGroupResultList.sublist(0, min(defaultShowLines, filteredGroupResultList.length));

    if (filteredGroupResultList.isNotEmpty) {
      return TIMUIKitSearchFolder(folderName: TIM_t("群聊"), children: [
        ...halfFilteredGroupResultList.map((group) {
          int convIndex = _conversationList.indexWhere((item) => group.groupID == item?.groupID);
          V2TimConversation conversation = _conversationList[convIndex]!;
          return TIMUIKitSearchItem(
            onClick: () {
              widget.onTapConversation(conversation, null);
            },
            faceUrl: conversation.faceUrl ?? group.faceUrl ?? "",
            showName: "",
            lineOne: conversation.showName ?? group.groupName ?? conversation.groupID ?? "",
          );
        }).toList(),
        _renderShowALl(filteredGroupResultList.length),
      ]);
    } else {
      return Container();
    }
  }
}
