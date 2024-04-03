import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';

Future<List<V2TimGroupMemberFullInfo>> showGroupMemberSelector({
  required List<V2TimGroupMemberFullInfo> groupMemberList,
  int? maxSelectionAmount,
  required BuildContext context,
  bool includeSelf = false,
  String? title,
  String? onSelectLabel,
}) async {
  final Completer<List<V2TimGroupMemberFullInfo>> completer = Completer<List<V2TimGroupMemberFullInfo>>();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext _) {
      return TencentCloudChatGroupMemberSelector(
        groupMemberList: includeSelf ? groupMemberList : groupMemberList.where((element) => element.userID != (TencentCloudChat().dataInstance.basic.currentUser?.userID ?? "")).toList(),
        maxSelectionAmount: maxSelectionAmount,
        title: title,
        onSelect: (list) => completer.complete(list),
        onSelectLabel: onSelectLabel,
        onCancel: () => completer.complete([]),
      );
    },
  );

  return completer.future;
}

class TencentCloudChatGroupMemberSelector extends StatefulWidget {
  final List<V2TimGroupMemberFullInfo> groupMemberList;
  final int? maxSelectionAmount;
  final String? title;
  final ValueChanged<List<V2TimGroupMemberFullInfo>> onSelect;
  final String? onSelectLabel;
  final VoidCallback onCancel;

  const TencentCloudChatGroupMemberSelector({
    super.key,
    required this.groupMemberList,
    this.maxSelectionAmount,
    this.title,
    this.onSelectLabel,
    required this.onSelect,
    required this.onCancel,
  });

  @override
  State<TencentCloudChatGroupMemberSelector> createState() => _TencentCloudChatGroupMemberSelectorState();
}

class _TencentCloudChatGroupMemberSelectorState extends TencentCloudChatState<TencentCloudChatGroupMemberSelector> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<V2TimGroupMemberFullInfo> _selectMembers = [];
  List<V2TimGroupMemberFullInfo> _filteredMemberList = [];

  double _actualHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _filteredMemberList = widget.groupMemberList;
    _focusNode.addListener(_updateHeight);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _actualHeight = _updateHeight();
  }

  double _updateHeight() {
    double keyboardHeight = _focusNode.hasPrimaryFocus ? TencentCloudChat().dataInstance.basic.keyboardHeight ?? getHeight(280) : 0;

    double headerHeight = getHeight(160);
    double listItemHeight = getHeight(46);
    double listHeight = widget.groupMemberList.length * listItemHeight;
    double maxHeight = headerHeight + listHeight + keyboardHeight;

    if (_actualHeight != maxHeight) {
      setState(() {
        _actualHeight = maxHeight;
      });
    }
    return maxHeight;
  }

  void _updateSearch(String searchText) {
    setState(() {
      _filteredMemberList = widget.groupMemberList.where((member) {
        final searchStr = (member.friendRemark ?? '') + (member.nameCard ?? '') + (member.nickName ?? '') + member.userID;
        return searchStr.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  void _addMember(V2TimGroupMemberFullInfo memberInfo) {
    if (widget.maxSelectionAmount != null && _selectMembers.length > widget.maxSelectionAmount! - 1) {
      _selectMembers.removeRange(0, _selectMembers.length - widget.maxSelectionAmount! + 1);
    }
    _selectMembers.add(memberInfo);
  }

  Widget _renderHeader() => TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
          decoration: BoxDecoration(
            // border: Border(bottom: BorderSide(color: colorTheme.dividerColor)),
            color: colorTheme.backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: getHeight(8), left: getWidth(4), right: getWidth(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onCancel();
                    Navigator.pop(context);
                  },
                  child: Text(
                    tL10n.cancel,
                    style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.primaryColor),
                  ),
                ),
                const Spacer(),
                Text(
                  widget.title ?? (widget.maxSelectionAmount == 1 ? tL10n.selectMembers : tL10n.numSelectMembers(_selectMembers.length)),
                  style: TextStyle(fontSize: textStyle.fontsize_16),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    widget.onSelect(_selectMembers);
                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.onSelectLabel ?? tL10n.confirm,
                    style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _renderSearchBar() {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              color: colorTheme.backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(0)),
              child: TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: tL10n.searchMembers,
                  contentPadding: EdgeInsets.symmetric(horizontal: getWidth(12), vertical: getHeight(12)),
                  hintStyle: TextStyle(
                    color: colorTheme.secondaryTextColor,
                    fontSize: textStyle.fontsize_14,
                  ),
                  isDense: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  fillColor: colorTheme.messageBeenChosenBackgroundColor,
                  filled: true,
                ),
                onChanged: _updateSearch,
              ),
            ));
  }

  Widget _memberItem({required V2TimGroupMemberFullInfo member}) {
    final isSelected = _selectMembers.any((element) => element.userID == member.userID);
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: getWidth(8), vertical: getHeight(8)),
        color: isSelected ? colorTheme.messageBeenChosenBackgroundColor : colorTheme.backgroundColor,
        duration: const Duration(milliseconds: 300),
        child: InkWell(
            onTap: () {
              if (!isSelected) {
                _addMember(member);
              } else {
                _selectMembers.removeWhere((element) => element.userID == member.userID);
              }
              setState(() {});
            },
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  visualDensity: const VisualDensity(vertical: -4, horizontal: -2),
                  activeColor: colorTheme.primaryColor,
                  checkColor: colorTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onChanged: (bool? value) {
                    if (!isSelected) {
                      _addMember(member);
                    } else {
                      _selectMembers.removeWhere((element) => element.userID == member.userID);
                    }
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: getWidth(8),
                ),
                TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                    scene: TencentCloudChatAvatarScene.groupMemberSelector,
                    width: getHeight(40),
                    height: getHeight(40),
                    borderRadius: getHeight(20),
                    imageList: [TencentCloudChatUtils.checkString(member.faceUrl)]),
                SizedBox(
                  width: getWidth(8),
                ),
                Text(
                  TencentCloudChatUtils.checkString(member.friendRemark) ?? TencentCloudChatUtils.checkString(member.nameCard) ?? TencentCloudChatUtils.checkString(member.nickName) ?? member.userID,
                ),
              ],
            )),
      ),
    );
  }

  Widget _renderMemberList() {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scrollbar(
          controller: _scrollController,
          child: Container(
            color: colorTheme.backgroundColor,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _filteredMemberList.length,
              itemBuilder: (context, index) {
                final memberInfo = _filteredMemberList[index];
                return _memberItem(member: memberInfo);
              },
            ),
          )),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    double contentHeight = MediaQuery.of(context).size.height * 0.8;
    double heightFactor = _actualHeight < contentHeight ? _actualHeight / MediaQuery.of(context).size.height : 0.8;

    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: FractionallySizedBox(
          heightFactor: heightFactor,
          child: DefaultTabController(
            length: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _renderHeader(),
                _renderSearchBar(),
                Expanded(child: _renderMemberList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
