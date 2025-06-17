import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_contact/widgets/create_group.dart';
import 'package:azlistview_all_platforms/azlistview_all_platforms.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_azlist.dart';

class StartGroupChat extends StatefulWidget {
  const StartGroupChat({super.key});

  @override
  State<StartGroupChat> createState() {
    return _StartGroupChatState();
  }
}

class _StartGroupChatState extends TencentCloudChatState<StartGroupChat> {
  List<V2TimFriendInfo> friendInfoList = [];
  List<V2TimFriendInfo> selectedMembers = [];

  List<ISuspensionBeanImpl> _getSortedFriendList() {
    final List<ISuspensionBeanImpl> showList = List.empty(growable: true);
    for (var item in friendInfoList) {
      final showName = _getMemberName(item);
      String tag = showName.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: tag));
      } else {
        showList.add(ISuspensionBeanImpl(friendInfo: item, tagIndex: "#"));
      }
    }
    SuspensionUtil.sortListBySuspensionTag(showList);
    SuspensionUtil.setShowSuspensionStatus(showList);
    return showList;
  }

  Widget _buildSelectedList(TencentCloudChatTextStyle textStyle) {
    return Visibility(
      visible: selectedMembers.isNotEmpty,
      child: Container(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectedMembers.length,
          itemBuilder: (context, index) {
            final member = selectedMembers[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: FadeInImage(
                            placeholder: const AssetImage(
                              'images/default_user_icon.png',
                              package: 'tencent_cloud_chat_common',
                            ),
                            image: NetworkImage(member.userProfile?.faceUrl ?? ''),
                            fit: BoxFit.cover,
                            imageErrorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Image.asset(
                                'images/default_user_icon.png',
                                package: 'tencent_cloud_chat_common',
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMembers.removeAt(index);
                            });
                          },
                          child: const CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 8, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 50,
                    child: Text(
                      _getMemberName(member),
                      style: TextStyle(fontSize: textStyle.fontsize_12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getMemberName(V2TimFriendInfo friendInfo) {
    if (friendInfo.friendRemark != null && friendInfo.friendRemark!.isNotEmpty) {
      return friendInfo.friendRemark!;
    } else if (friendInfo.userProfile != null) {
      if (friendInfo.userProfile!.nickName != null &&
          friendInfo.userProfile!.nickName != null &&
          friendInfo.userProfile!.nickName!.isNotEmpty) {
        return friendInfo.userProfile!.nickName!;
      }
    }

    return friendInfo.userID;
  }

  Widget _buildMemberList(colorTheme, textStyle) {
    final sortedFriendList = _getSortedFriendList();

    return AzListView(
      data: sortedFriendList,
      itemCount: sortedFriendList.length,
      indexBarData: SuspensionUtil.getTagIndexList(sortedFriendList).where((element) => element != "@").toList(),
      itemBuilder: (context, index) {
        V2TimFriendInfo friendInfo = sortedFriendList[index].friendInfo;
        final isSelected = selectedMembers.any((friend) => friend.userID == friendInfo.userID);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedMembers.removeWhere((friend) => friend.userID == friendInfo.userID);
              } else {
                selectedMembers.add(friendInfo);
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: getHeight(8),
              horizontal: getWidth(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                      scene: TencentCloudChatAvatarScene.contacts,
                      imageList: [friendInfo.userProfile?.faceUrl ?? ''],
                      width: getSquareSize(40),
                      height: getSquareSize(40),
                      borderRadius: getSquareSize(58),
                    ),
                    SizedBox(width: getWidth(8)),
                    Text(
                      _getMemberName(friendInfo),
                      style: TextStyle(
                        color: colorTheme.contactItemFriendNameColor,
                        fontSize: textStyle.fontsize_14,
                      ),
                    ),
                  ],
                ),
                _buildCustomCheckbox(isSelected),
              ],
            ),
          ),
        );
      },
      susItemBuilder: (context, index) {
        ISuspensionBeanImpl tag = sortedFriendList[index];
        if (tag.getSuspensionTag() == "@") {
          return Container();
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: colorTheme.backgroundColor,
          child: Text(
            tag.getSuspensionTag(),
            style: TextStyle(fontSize: textStyle.fontsize_14, fontWeight: FontWeight.bold),
          ),
        );
      },
      physics: const ClampingScrollPhysics(),
    );
  }

  Widget _buildCustomCheckbox(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.blue : Colors.transparent,
        border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            )
          : null,
    );
  }

  void _createGroupChat() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateGroupChat(selectedMembers: selectedMembers),
      ),
    );
  }

  void _fetchMembers() async {
    List<V2TimFriendInfo> friendList = TencentCloudChat.instance.dataInstance.contact.contactList;
    setState(() {
      friendInfoList = friendList;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              backgroundColor: colorTheme.backgroundColor,
              appBar: AppBar(
                backgroundColor: colorTheme.contactBackgroundColor,
                leading: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    tL10n.cancel,
                    style: TextStyle(color: colorTheme.primaryColor),
                  ),
                ),
                title: Center(
                    child: Text(tL10n.createGroupChat,
                        style: TextStyle(fontSize: textStyle.fontsize_16, color: colorTheme.primaryTextColor))),
                actions: [
                  TextButton(
                    onPressed: selectedMembers.isNotEmpty ? _createGroupChat : null,
                    child: Text(
                      tL10n.next,
                      style: TextStyle(color: selectedMembers.isNotEmpty ? colorTheme.primaryColor : Colors.grey),
                    ),
                  ),
                ],
                scrolledUnderElevation: 0.0,
              ),
              body: Column(
                children: [
                  Divider(height: 1, color: Colors.grey[300]),
                  _buildSelectedList(textStyle),
                  Expanded(child: _buildMemberList(colorTheme, textStyle)),
                ],
              ),
            ));
  }
}
