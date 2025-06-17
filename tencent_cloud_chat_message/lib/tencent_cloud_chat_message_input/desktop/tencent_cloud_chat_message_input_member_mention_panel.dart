import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/utils/sdk_const.dart';

class TencentCloudChatDesktopMemberMentionPanel extends StatefulWidget {
  /// messageList widget scroll controller
  final AutoScrollController atMemberPanelScroll;

  final double desktopMentionBoxPositionX;
  final double desktopMentionBoxPositionY;
  final int activeMentionIndex;
  final List<V2TimGroupMemberFullInfo?> currentFilteredMembersListForMention;

  final ValueChanged<({V2TimGroupMemberFullInfo memberFullInfo, int index})> onSelectMember;

  // final TextFieldWebController textFieldWebController;
  const TencentCloudChatDesktopMemberMentionPanel( // this.textFieldWebController,
      {
    Key? key,
    required this.atMemberPanelScroll,
    required this.onSelectMember,
    required this.desktopMentionBoxPositionX,
    required this.desktopMentionBoxPositionY,
    required this.activeMentionIndex,
    required this.currentFilteredMembersListForMention,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TencentCloudChatDesktopMemberMentionPanelState();
  }
}

class _TencentCloudChatDesktopMemberMentionPanelState
    extends TencentCloudChatState<TencentCloudChatDesktopMemberMentionPanel> {
  _getShowName(V2TimGroupMemberFullInfo? item) {
    return TencentCloudChatUtils.checkStringWithoutSpace(item?.nameCard) ??
        TencentCloudChatUtils.checkStringWithoutSpace(item?.nickName) ??
        TencentCloudChatUtils.checkStringWithoutSpace(item?.userID);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final List<V2TimGroupMemberFullInfo?> groupMemberList = widget.currentFilteredMembersListForMention;
    final double positionX = widget.desktopMentionBoxPositionX;
    final double positionY = widget.desktopMentionBoxPositionY;
    final int activeIndex = widget.activeMentionIndex;

    if (groupMemberList.isEmpty) {
      return Container();
    }
    return Positioned(
      left: positionX,
      bottom: positionY,
      child: TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
          constraints: const BoxConstraints(maxHeight: 170, maxWidth: 170),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: colorTheme.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: colorTheme.dividerColor,
            ),
          ),
          child: Scrollbar(
            controller: widget.atMemberPanelScroll,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: groupMemberList.length,
                controller: widget.atMemberPanelScroll,
                itemBuilder: ((context, index) {
                  final memberItem = groupMemberList[index];
                  if (memberItem == null) {
                    return AutoScrollTag(key: ValueKey(index), controller: widget.atMemberPanelScroll, index: index);
                  }
                  final showName = _getShowName(memberItem);
                  final isAtAll = memberItem.userID == SDKConst.sdkAtAllUserID;
                  return AutoScrollTag(
                    key: ValueKey(index),
                    controller: widget.atMemberPanelScroll,
                    index: index,
                    child: Material(
                      color: colorTheme.backgroundColor,
                      child: InkWell(
                        onTap: () {
                          widget.onSelectMember((memberFullInfo: memberItem, index: index));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: activeIndex == index ? colorTheme.primaryColor : colorTheme.backgroundColor,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TencentCloudChatAvatar(
                                imageList: [TencentCloudChatUtils.checkString(memberItem.faceUrl)],
                                height: 24,
                                width: 24,
                                scene: TencentCloudChatAvatarScene.groupMemberSelector,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  isAtAll ? "$showName(${groupMemberList.length - 1})" : showName,
                                  softWrap: false,
                                  style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: memberItem.role == 400 || memberItem.role == 300
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                      color: activeIndex == index
                                          ? colorTheme.onPrimary
                                          : (memberItem.role == 400 || memberItem.role == 300
                                              ? colorTheme.primaryColor
                                              : colorTheme.primaryTextColor)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ),
      ),
    );
  }
}
