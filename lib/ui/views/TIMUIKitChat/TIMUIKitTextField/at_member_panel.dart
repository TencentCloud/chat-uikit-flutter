import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';

class AtMemberPanel extends StatefulWidget {
  /// messageList widget scroll controller
  final AutoScrollController atMemberPanelScroll;

  final ValueChanged<V2TimGroupMemberFullInfo> onSelectMember;

  // final TextFieldWebController textFieldWebController;
  const AtMemberPanel(
      // this.textFieldWebController,
      {Key? key,
      required this.atMemberPanelScroll,
      required this.onSelectMember})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AtMemberPanelState();
  }
}

_getShowName(V2TimGroupMemberFullInfo? item) {
  return TencentUtils.checkStringWithoutSpace(item?.nameCard) ??
      TencentUtils.checkStringWithoutSpace(item?.nickName) ??
      TencentUtils.checkStringWithoutSpace(item?.userID);
}

class _AtMemberPanelState extends TIMUIKitState<AtMemberPanel> {
  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    final chatModal = Provider.of<TUIChatSeparateViewModel>(context);
    final List<V2TimGroupMemberFullInfo?> groupMemberList =
        chatModal.showAtMemberList;
    final double positionX = chatModal.atPositionX;
    final double positionY = chatModal.atPositionY;
    final int activeIndex = chatModal.activeAtIndex;

    if (groupMemberList.isEmpty) {
      return Container();
    }
    return Positioned(
      left: positionX,
      bottom: positionY,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 170, maxWidth: 170),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: const Color(0xFFE5E6E9))),
        child: Scrollbar(
          controller: widget.atMemberPanelScroll,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: groupMemberList.length,
              controller: widget.atMemberPanelScroll,
              itemBuilder: ((context, index) {
                final memberItem = groupMemberList[index];
                if (memberItem == null) {
                  return AutoScrollTag(
                      key: ValueKey(index),
                      controller: widget.atMemberPanelScroll,
                      index: index);
                }
                final showName = _getShowName(memberItem);
                final isAtAll = memberItem.userID == "__kImSDK_MesssageAtALL__";
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: widget.atMemberPanelScroll,
                  index: index,
                  child: Material(
                    color: theme.wideBackgroundColor,
                    child: InkWell(
                      onTap: () {
                        chatModal.activeAtIndex = index;
                        widget.onSelectMember(memberItem);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        color: activeIndex == index
                            ? theme.weakBackgroundColor
                            : theme.wideBackgroundColor,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Avatar(
                                  faceUrl: memberItem.faceUrl ?? "",
                                  type: 1,
                                  showName: showName),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(child: Text(
                              isAtAll
                                  ? "$showName(${groupMemberList.length - 1})"
                                  : showName,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: memberItem.role == 400 ||
                                      memberItem.role == 300
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                  color: memberItem.role == 400 ||
                                      memberItem.role == 300
                                      ? theme.primaryColor
                                      : theme.darkTextColor),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
        ),
      ),
    );
  }
}
