// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_common/widgets/operation_bar/tencent_cloud_chat_operation_bar.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_member_info.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_member_list.dart';

class TencentCloudChatGroupProfileBody extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> groupMemberList;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;

  const TencentCloudChatGroupProfileBody(
      {super.key,
      required this.groupInfo,
      required this.groupMemberList,
      this.startVoiceCall,
      this.startVideoCall});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileBodyState();
}

class TencentCloudChatGroupProfileBodyState
    extends TencentCloudChatState<TencentCloudChatGroupProfileBody> {
  List<V2TimFriendInfo> contactList = [];
  @override
  void initState() {
    super.initState();
    contactList = TencentCloudChat.instance.dataInstance.contact.contactList;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Center(
              child: ListView(
                children: [
                  SizedBox(
                    height: getHeight(40),
                  ),
                  TencentCloudChat
                      .instance.dataInstance.groupProfile.groupProfileBuilder
                      ?.getGroupProfileAvatarBuilder(
                          groupInfo: widget.groupInfo,
                          groupMember: widget.groupMemberList),
                  TencentCloudChat
                      .instance.dataInstance.groupProfile.groupProfileBuilder
                      ?.getGroupProfileContentBuilder(
                          groupInfo: widget.groupInfo),
                  TencentCloudChat
                      .instance.dataInstance.groupProfile.groupProfileBuilder
                      ?.getGroupProfileChatButtonBuilder(
                          groupInfo: widget.groupInfo,
                          startVideoCall: widget.startVideoCall,
                          startVoiceCall: widget.startVoiceCall),
                  TencentCloudChat
                      .instance.dataInstance.groupProfile.groupProfileBuilder
                      ?.getGroupProfileStateButtonBuilder(
                          groupInfo: widget.groupInfo),
                  TencentCloudChat
                      .instance.dataInstance.groupProfile.groupProfileBuilder
                      ?.getGroupProfileMuteMemberBuilder(
                          groupInfo: widget.groupInfo,
                          groupMember: widget.groupMemberList),
                  TencentCloudChat
                      .instance.dataInstance.groupProfile.groupProfileBuilder
                      ?.getGroupProfileSetNameCardBuilder(
                    groupInfo: widget.groupInfo,
                    groupMember: widget.groupMemberList,
                  ),
                  TencentCloudChat
                      .instance.dataInstance.groupProfile.groupProfileBuilder
                      ?.getGroupProfileMemberBuilder(
                    groupInfo: widget.groupInfo,
                    groupMember: widget.groupMemberList,
                    contactList: contactList,
                  ),
                  SizedBox(
                    height: getHeight(16),
                  ),
                  TencentCloudChat
                      .instance.dataInstance.groupProfile.groupProfileBuilder
                      ?.getGroupProfileDeleteButtonBuilder(
                          groupInfo: widget.groupInfo)
                ],
              ),
            ));
  }
}

class TencentCloudChatGroupProfileAvatar extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> groupMemberList;
  const TencentCloudChatGroupProfileAvatar(
      {super.key, required this.groupInfo, required this.groupMemberList});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileAvatarState();
}

class TencentCloudChatGroupProfileAvatarState
    extends TencentCloudChatState<TencentCloudChatGroupProfileAvatar> {
  List<String?> _getAvatarList() {
    var list = widget.groupMemberList
        .takeWhile(
            (value) => TencentCloudChatUtils.checkString(value.faceUrl) != null)
        .toList();
    if (list.isNotEmpty) {
      if (list.length > 9) {
        list = list.sublist(0, 9);
      }
      return list.map((e) => e.faceUrl!).toList();
    }
    return [
      widget.groupInfo.faceUrl,
    ];
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
          scene: TencentCloudChatAvatarScene.groupProfile,
          imageList: _getAvatarList(),
          width: getSquareSize(94),
          height: getSquareSize(94),
          borderRadius: getSquareSize(48),
        )
      ],
    );
  }
}

class TencentCloudChatGroupProfileContent extends StatefulWidget {
  final V2TimGroupInfo groupInfo;

  const TencentCloudChatGroupProfileContent(
      {super.key, required this.groupInfo});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileContentState();
}

class TencentCloudChatGroupProfileContentState
    extends TencentCloudChatState<TencentCloudChatGroupProfileContent> {
  String groupName = "";

  @override
  initState() {
    super.initState();
    groupName = widget.groupInfo.groupName ?? widget.groupInfo.groupID;
  }

  _onChangeGroupName(String value) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.groupSDK
        .setGroupInfo(
            groupID: widget.groupInfo.groupID,
            groupType: widget.groupInfo.groupType,
            groupName: value);
    if (res.code == 0) {
      safeSetState(() {
        groupName = value;
      });
    }
  }

  changeGroupName() {
    String mid = "";
    TextEditingController controller = TextEditingController(text: groupName);
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(tL10n.setGroupName),
            content: CupertinoTextField(
              maxLines: null,
              autofocus: true,
              controller: controller,
              onChanged: (value) {
                mid = value;
              },
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  _onChangeGroupName(mid);
                  Navigator.pop(context);
                },
                child: Text(tL10n.confirm),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(tL10n.cancel),
              ),
            ],
          );
        });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              padding: EdgeInsets.all(getSquareSize(16)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                        groupName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: textStyle.fontsize_24,
                            fontWeight: FontWeight.w600),
                      )),
                      FloatingActionButton.small(
                          onPressed: changeGroupName,
                          elevation: 0,
                          backgroundColor: colorTheme.contactBackgroundColor,
                          child: Icon(
                            Icons.border_color_rounded,
                            color: colorTheme.contactBackButtonColor,
                            size: getSquareSize(15),
                          ))
                    ],
                  ),
                  Text(
                    "ID: ${widget.groupInfo.groupID}",
                    style: TextStyle(fontSize: textStyle.fontsize_12),
                  )
                ],
              ),
            ));
  }
}

class TencentCloudChatGroupProfileChatButton extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  const TencentCloudChatGroupProfileChatButton(
      {super.key,
      required this.groupInfo,
      this.startVoiceCall,
      this.startVideoCall});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileChatButtonState();
}

class TencentCloudChatGroupProfileChatButtonState
    extends TencentCloudChatState<TencentCloudChatGroupProfileChatButton> {
  Widget _buildClickableItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
              color: Colors.transparent,
              child: Container(
                width: getWidth(110),
                decoration: BoxDecoration(
                  color: colorTheme.profileChatButtonBackground,
                  boxShadow: [
                    BoxShadow(
                      color: colorTheme.profileChatButtonBoxShadow,
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(getSquareSize(12)),
                ),
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(getSquareSize(12)),
                      child: Container(
                          padding: EdgeInsets.all(getSquareSize(16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: getHeight(8)),
                                child: Icon(
                                  icon,
                                  size: getSquareSize(30),
                                  color: colorTheme.primaryColor,
                                ),
                              ),
                              Text(
                                label,
                                style: TextStyle(
                                    color: colorTheme.primaryTextColor,
                                    fontSize: textStyle.fontsize_16),
                              )
                            ],
                          )),
                    )),
              ),
            ));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            margin: EdgeInsets.only(top: getHeight(14), bottom: getHeight(40)),
            padding: EdgeInsets.symmetric(horizontal: getSquareSize(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildClickableItem(
                    icon: Icons.search_outlined,
                    label: tL10n.search,
                    onTap: () {}),
                _buildClickableItem(
                    icon: Icons.call,
                    label: tL10n.voiceCall,
                    onTap: () {
                      if (widget.startVoiceCall != null) {
                        widget.startVoiceCall!();
                      }
                    }),
                _buildClickableItem(
                    icon: Icons.videocam_outlined,
                    label: tL10n.videoCall,
                    onTap: () {
                      if (widget.startVideoCall != null) {
                        widget.startVideoCall!();
                      }
                    }),
              ],
            )));
  }
}

class TencentCloudChatGroupProfileStateButton extends StatefulWidget {
  final V2TimGroupInfo groupInfo;

  const TencentCloudChatGroupProfileStateButton(
      {super.key, required this.groupInfo});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileStateButtonState();
}

class TencentCloudChatGroupProfileStateButtonState
    extends TencentCloudChatState<TencentCloudChatGroupProfileStateButton> {
  bool disturb = false;
  bool pinChat = false;

  @override
  void initState() {
    super.initState();
    if (widget.groupInfo.recvOpt ==
        ReceiveMsgOptEnum.V2TIM_RECEIVE_MESSAGE.index) {
      disturb = false;
    } else {
      disturb = true;
    }

    int index = TencentCloudChat
        .instance.dataInstance.conversation.conversationList
        .indexWhere((element) =>
            element.conversationID == "group_${widget.groupInfo.groupID}");
    if (index > -1) {
      pinChat = TencentCloudChat
          .instance.dataInstance.conversation.conversationList[index].isPinned!;
    }
  }

  _setGroupMessageReceiveOpt(bool value) async {
    ReceiveMsgOptEnum opt;
    if (value == true) {
      opt = ReceiveMsgOptEnum.V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE;
    } else {
      opt = ReceiveMsgOptEnum.V2TIM_RECEIVE_MESSAGE;
    }
    final res = await TencentCloudChat.instance.chatSDKInstance.groupSDK
        .setGroupReceiveMessageOpt(groupID: widget.groupInfo.groupID, opt: opt);
    if (res.code == 0) {
      safeSetState(() {
        disturb = value;
      });
    }
  }

  _setPinConversation(bool value) async {
    await TencentCloudChat.instance.chatSDKInstance.conversationSDK
        .pinConversation(
            conversationID: "group_${widget.groupInfo.groupID}",
            isPinned: value);
    safeSetState(() {
      pinChat = value;
    });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                TencentCloudChatOperationBar(
                  label: tL10n.doNotDisturb,
                  operationBarType: OperationBarType.switchControl,
                  value: disturb,
                  onChange: (bool value) {
                    _setGroupMessageReceiveOpt(value);
                  },
                ),
                TencentCloudChatOperationBar(
                  label: tL10n.pin,
                  operationBarType: OperationBarType.switchControl,
                  value: pinChat,
                  onChange: (bool value) {
                    _setPinConversation(value);
                  },
                )
              ],
            ));
  }
}

class TencentCloudChatGroupProfileDeleteButton extends StatefulWidget {
  final V2TimGroupInfo groupInfo;

  const TencentCloudChatGroupProfileDeleteButton(
      {super.key, required this.groupInfo});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileDeleteButtonState();
}

class TencentCloudChatGroupProfileDeleteButtonState
    extends TencentCloudChatState<TencentCloudChatGroupProfileDeleteButton> {
  bool quitGroup = true;

  onClearChatHistory() async {
    final res = TencentCloudChat.instance.chatSDKInstance.groupSDK
        .clearGroupHistoryMessage(groupID: widget.groupInfo.groupID);
  }

  onDeleteContact() async {
    checkIfQuitGroup();
    if (quitGroup == true) {
      await TencentCloudChat.instance.chatSDKInstance.groupSDK
          .quitGroup(groupID: widget.groupInfo.groupID);
    } else {
      await TencentCloudChat.instance.chatSDKInstance.groupSDK
          .dismissGroup(groupID: widget.groupInfo.groupID);
    }
  }

  checkIfQuitGroup() {
    if (widget.groupInfo.groupType != GroupType.Work &&
        widget.groupInfo.role ==
            GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      quitGroup = false;
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        width: 1,
                        color: colorTheme.backgroundColor,
                      )),
                      color: colorTheme
                          .contactAddContactFriendInfoStateButtonBackgroundColor),
                  padding: EdgeInsets.symmetric(
                      vertical: getHeight(10), horizontal: getWidth(16)),
                  child: GestureDetector(
                      onTap: onClearChatHistory,
                      child: Text(
                        tL10n.deleteAllMessages,
                        style: TextStyle(
                            color: colorTheme.contactRefuseButtonColor,
                            fontSize: textStyle.fontsize_16,
                            fontWeight: FontWeight.w400),
                      ))),
              Container(
                  color: colorTheme
                      .contactAddContactFriendInfoStateButtonBackgroundColor,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      vertical: getHeight(10), horizontal: getWidth(16)),
                  child: GestureDetector(
                      onTap: onDeleteContact,
                      child: Text(
                        quitGroup ? tL10n.quit : tL10n.quitAndDelete,
                        style: TextStyle(
                            color: colorTheme.contactRefuseButtonColor,
                            fontSize: textStyle.fontsize_16,
                            fontWeight: FontWeight.w400),
                      )))
            ]));
  }
}

class TencentCloudChatGroupProfileGroupManagement extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberInfo;
  const TencentCloudChatGroupProfileGroupManagement(
      {super.key, required this.groupInfo, required this.memberInfo});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileGroupManagementState();
}

class TencentCloudChatGroupProfileGroupManagementState
    extends TencentCloudChatState<TencentCloudChatGroupProfileGroupManagement> {
  String addopt = "";

  @override
  initState() {
    super.initState();
    addopt = getGroupAddOpt(widget.groupInfo.groupAddOpt);
  }

  bool checkIsAdminOrOwner() {
    if (widget.groupInfo.role ==
            GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN ||
        widget.groupInfo.role ==
            GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      return true;
    }
    return false;
  }

  openAnnouncementPage() {
    final isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
    Widget notificationPage = TencentCloudChat
        .instance.dataInstance.groupProfile.groupProfileBuilder
        ?.getGroupProfileNotificationPageBuilder(groupInfo: widget.groupInfo);
    if (isDesktop) {
      TencentCloudChatDialog.showCustomDialog(
          context: context,
          title: tL10n.groupOfAnnouncement,
          builder: (context) => notificationPage);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => notificationPage));
    }
  }

  openGroupManagement() {
    final isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
    Widget groupManagementPage = TencentCloudChat
        .instance.dataInstance.groupProfile.groupProfileBuilder
        ?.getGroupProfileMutePageBuilder(
            groupInfo: widget.groupInfo, groupMember: widget.memberInfo);
    if (isDesktop) {
      TencentCloudChatDialog.showCustomDialog(
          context: context,
          title: tL10n.groupManagement,
          builder: (context) => groupManagementPage);
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => groupManagementPage));
    }
  }

  String getGroupAddOpt(int? opt) {
    String option = tL10n.unknown;
    if (opt != null) {
      switch (opt) {
        case GroupAddOptType.V2TIM_GROUP_ADD_ANY:
          option = tL10n.groupAddAny;
          break;
        case GroupAddOptType.V2TIM_GROUP_ADD_AUTH:
          option = tL10n.groupAddAuth;
          break;
        case GroupAddOptType.V2TIM_GROUP_ADD_FORBID:
          option = tL10n.groupAddForbid;
          break;
      }
    }
    return option;
  }

  _onChangeGroupApplicationType(int opt) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.groupSDK
        .setGroupInfo(
            groupID: widget.groupInfo.groupID,
            groupType: widget.groupInfo.groupType,
            groupAddOpt: opt);
    if (res.code == 0) {
      safeSetState(() {
        addopt = getGroupAddOpt(opt);
      });
    }
  }

  changeGroupApplicationType() {
    List<CupertinoActionSheetAction> action = [
      CupertinoActionSheetAction(
        isDefaultAction: false,
        onPressed: () {
          _onChangeGroupApplicationType(GroupAddOptType.V2TIM_GROUP_ADD_ANY);
          Navigator.pop(context);
        },
        child: Text(tL10n.groupAddAny),
      ),
      CupertinoActionSheetAction(
        isDefaultAction: false,
        onPressed: () {
          _onChangeGroupApplicationType(GroupAddOptType.V2TIM_GROUP_ADD_FORBID);
          Navigator.pop(context);
        },
        child: Text(tL10n.groupAddForbid),
      ),
    ];
    if (widget.groupInfo.groupType != GroupType.Work) {
      action.insert(
        1,
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () {
            _onChangeGroupApplicationType(GroupAddOptType.V2TIM_GROUP_ADD_AUTH);
            Navigator.pop(context);
          },
          child: Text(tL10n.groupAddAuth),
        ),
      );
    }
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => CupertinoActionSheet(
                  actions: action,
                  cancelButton: CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(tL10n.cancel),
                  ),
                )));
  }

  Widget buildGroupManagement(colorTheme, textStyle) {
    if (widget.groupInfo.groupType != GroupType.Work && checkIsAdminOrOwner()) {
      return GestureDetector(
        onTap: openGroupManagement,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: getWidth(16), vertical: getHeight(12)),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: colorTheme.groupProfileTabBackground,
            border: Border(
                bottom: BorderSide(
                    color: colorTheme.dividerColor, width: getWidth(1))),
          ),
          child: Row(children: [
            Expanded(
                child: Text(tL10n.groupManagement,
                    style: TextStyle(
                        color: colorTheme.groupProfileTabTextColor,
                        fontSize: textStyle.fontsize_16))),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: getSquareSize(18),
              color: colorTheme.groupProfileTabTextColor,
            )
          ]),
        ),
      );
    }
    return Container();
  }

  Widget buildGroupType(colorTheme, textStyle) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getWidth(16), vertical: getHeight(12)),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: colorTheme.groupProfileTabBackground,
          border: Border(
              bottom: BorderSide(
                  color: colorTheme.dividerColor, width: getWidth(1)))),
      child: Row(
        children: [
          Expanded(
            child: Text(tL10n.groupOfType,
                style: TextStyle(
                    color: colorTheme.groupProfileTabTextColor,
                    fontSize: textStyle.fontsize_16)),
          ),
          Text(widget.groupInfo.groupType,
              style: TextStyle(
                  color: colorTheme.groupProfileTextColor,
                  fontSize: textStyle.fontsize_16))
        ],
      ),
    );
  }

  Widget buildGroupOpt(colorTheme, textStyle) {
    return Container(
      margin: EdgeInsets.only(top: getHeight(1)),
      padding: EdgeInsets.symmetric(
          horizontal: getWidth(16), vertical: getHeight(12)),
      width: MediaQuery.of(context).size.width,
      color: colorTheme.groupProfileTabBackground,
      child: Row(
        children: [
          Expanded(
            child: Text(tL10n.addGroupWay,
                style: TextStyle(
                    color: colorTheme.groupProfileTabTextColor,
                    fontSize: textStyle.fontsize_16)),
          ),
          GestureDetector(
              onTap: changeGroupApplicationType,
              child: Text(addopt,
                  style: TextStyle(
                      color: colorTheme.groupProfileTextColor,
                      fontSize: textStyle.fontsize_16)))
        ],
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(16), vertical: getHeight(8)),
                      margin: EdgeInsets.only(top: getHeight(16)),
                      width: MediaQuery.of(context).size.width,
                      color: colorTheme.groupProfileTabBackground,
                      child: Text(
                        tL10n.groupOfAnnouncement,
                        style: TextStyle(
                            color: colorTheme.groupProfileTabTextColor,
                            fontSize: textStyle.fontsize_16),
                      ),
                    ),
                    GestureDetector(
                      onTap: openAnnouncementPage,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: getWidth(16),
                            right: getWidth(16),
                            bottom: getHeight(8)),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: colorTheme.groupProfileTabBackground,
                            border: Border(
                                bottom: BorderSide(
                                    color: colorTheme.dividerColor,
                                    width: getWidth(1)))),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                            widget.groupInfo.notification ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: colorTheme.groupProfileTabTextColor,
                                fontSize: textStyle.fontsize_14),
                          )),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: getSquareSize(18),
                            color: colorTheme.groupProfileTabTextColor,
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
                buildGroupManagement(colorTheme, textStyle),
                buildGroupType(colorTheme, textStyle),
                buildGroupOpt(colorTheme, textStyle),
              ],
            ));
  }
}

class TencentCloudChatGroupProfileNickName extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> groupMembersInfo;

  const TencentCloudChatGroupProfileNickName({
    Key? key,
    required this.groupInfo,
    required this.groupMembersInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileNickNameState();
}

class TencentCloudChatGroupProfileNickNameState
    extends TencentCloudChatState<TencentCloudChatGroupProfileNickName> {
  String myNickname = "";
  String? loginID;
  String currentUserId =
      TencentCloudChat.instance.dataInstance.basic.currentUser!.userID ?? "";
  @override
  initState() {
    super.initState();
    loginID = currentUserId;

    myNickname = TencentCloudChatUtils.checkString(widget.groupMembersInfo
            .firstWhere((element) => element.userID == loginID)
            .nameCard) ??
        loginID ??
        "";
  }

  _onChangeGrouopNameCard(String value) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.groupSDK
        .setGroupMemberInfo(
            groupID: widget.groupInfo.groupID,
            userID: loginID!,
            nameCard: value);
    if (res.code == 0) {
      safeSetState(() {
        myNickname = value;
      });
    }
  }

  onChangeNickName() {
    String mid = "";
    TextEditingController textEditingController =
        TextEditingController(text: myNickname);
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(tL10n.setNickName),
            content: CupertinoTextField(
              controller: textEditingController,
              autofocus: true,
              maxLines: null,
              onChanged: (value) {
                mid = value;
              },
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  _onChangeGrouopNameCard(mid);
                  Navigator.pop(context);
                },
                child: Text(tL10n.confirm),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(tL10n.cancel),
              ),
            ],
          );
        });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            margin: EdgeInsets.symmetric(vertical: getHeight(16)),
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(16), vertical: getHeight(12)),
            width: MediaQuery.of(context).size.width,
            color: colorTheme.groupProfileTabBackground,
            child: GestureDetector(
              onTap: onChangeNickName,
              child: Row(
                children: [
                  Expanded(
                    child: Text(tL10n.myGroupNickName,
                        style: TextStyle(
                            color: colorTheme.groupProfileTabTextColor,
                            fontSize: textStyle.fontsize_16,
                            fontWeight: FontWeight.w400)),
                  ),
                  Row(children: [
                    Text(myNickname,
                        style: TextStyle(
                            color: colorTheme.groupProfileTextColor,
                            fontSize: textStyle.fontsize_16,
                            fontWeight: FontWeight.w400)),
                    SizedBox(
                      width: getWidth(8),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: getSquareSize(18),
                      color: colorTheme.groupProfileTabTextColor,
                    )
                  ]),
                ],
              ),
            )));
  }
}

class TencentCloudChatGroupProfileGroupMember extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> groupMembersInfo;
  final List<V2TimFriendInfo> contactList;
  const TencentCloudChatGroupProfileGroupMember(
      {super.key,
      required this.groupInfo,
      required this.groupMembersInfo,
      required this.contactList});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupProfileGroupMemberState();
}

class TencentCloudChatGroupProfileGroupMemberState
    extends TencentCloudChatState<TencentCloudChatGroupProfileGroupMember> {
  openGroupMemberList() {
    final isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
    if (isDesktop) {
      TencentCloudChatDialog.showCustomDialog(
          context: context,
          builder: (c) => TencentCloudChatGroupProfileMemberList(
                groupInfo: widget.groupInfo,
                memberInfoList: widget.groupMembersInfo,
              ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TencentCloudChatGroupProfileMemberList(
                    groupInfo: widget.groupInfo,
                    memberInfoList: widget.groupMembersInfo,
                  )));
    }
  }

  addGroupMembers() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TencentCloudChat
                    .instance.dataInstance.groupProfile.groupProfileBuilder
                    ?.getGroupProfileAddMemberPageBuilder(
                  groupMember: widget.groupMembersInfo,
                  contactList: widget.contactList,
                  groupInfo: widget.groupInfo,
                )));
  }

  String loginID = "";
  List<V2TimGroupMemberFullInfo> top3 = [];
  String currentUserId =
      TencentCloudChat.instance.dataInstance.basic.currentUser!.userID ?? "";
  getTop3GroupMember() {
    top3 = widget.groupMembersInfo.length > 3
        ? widget.groupMembersInfo.sublist(0, 3)
        : widget.groupMembersInfo;
    loginID = currentUserId;
    final myInfo = widget.groupMembersInfo
        .firstWhere((element) => element.userID == loginID);
    int index = top3.indexWhere((element) => element.userID == loginID);
    if (index > -1) {
      top3.removeAt(index);
    } else {
      top3.removeAt(top3.length - 1);
    }
    top3.insert(0, myInfo);
  }

  @override
  void initState() {
    super.initState();
    getTop3GroupMember();
  }

  String getGroupRole() {
    if (widget.groupInfo.role ==
        GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN) {
      return tL10n.admin;
    } else if (widget.groupInfo.role ==
        GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      return tL10n.groupOwner;
    }
    return tL10n.groupMember;
  }

  Widget avatar(V2TimGroupMemberFullInfo info) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth(4)),
        child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
          scene: TencentCloudChatAvatarScene.groupProfile,
          imageList: [info.faceUrl],
          width: getWidth(24),
          height: getHeight(24),
          borderRadius: getSquareSize(24),
        ));
  }

  Widget name(V2TimGroupMemberFullInfo info) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Expanded(
            child: Text(
                TencentCloudChatUtils.checkString(info.nickName) ?? info.userID,
                style: TextStyle(
                    color: colorTheme.groupProfileTextColor,
                    fontSize: textStyle.fontsize_16,
                    fontWeight: FontWeight.w400))));
  }

  Widget buildGroupMemberItem(V2TimGroupMemberFullInfo info) {
    // build 1 item
    if (info.userID == loginID) {
      return TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => Container(
                padding: EdgeInsets.symmetric(
                    horizontal: getWidth(16), vertical: getHeight(8)),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: colorTheme.groupProfileTabBackground,
                    border: Border(
                        bottom: BorderSide(
                            color: colorTheme.groupProfileTabBorderColor))),
                child: Row(
                  children: [
                    avatar(info),
                    Expanded(
                        child: Text(tL10n.you,
                            style: TextStyle(
                                color: colorTheme.groupProfileTextColor,
                                fontSize: textStyle.fontsize_16,
                                fontWeight: FontWeight.w400))),
                    Text(getGroupRole(),
                        style: TextStyle(
                            color: colorTheme.groupProfileTabTextColor,
                            fontSize: textStyle.fontsize_16,
                            fontWeight: FontWeight.w400))
                  ],
                ),
              ));
    } else {
      return TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => GestureDetector(
                onTap: () {
                  final isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
                  if (isDesktop) {
                    TencentCloudChatDialog.showCustomDialog(
                        context: context,
                        builder: (c) => TencentCloudChatGroupProfileMemberInfo(
                              memberFullInfo: info,
                            ));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TencentCloudChatGroupProfileMemberInfo(
                                  memberFullInfo: info,
                                )));
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(16), vertical: getHeight(8)),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: colorTheme.groupProfileTabBackground,
                      border: Border(
                          bottom: BorderSide(
                              color: colorTheme.groupProfileTabBorderColor))),
                  child: Row(
                    children: [
                      avatar(info),
                      name(info),
                      // Expanded(child: name(info)),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: getSquareSize(18),
                        color: colorTheme.groupProfileTabTextColor,
                      )
                    ],
                  ),
                ),
              ));
    }
  }

  Widget getGroupMemberListSample() {
    getTop3GroupMember();
    List<Widget> widgetlist = [];
    for (var element in top3) {
      widgetlist.add(buildGroupMemberItem(element));
    }
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: top3.isEmpty ? [Container()] : [...widgetlist],
    );
  }

  bool checkCanAddMember() {
    if (widget.groupInfo.groupType == GroupType.Work ||
        widget.groupInfo.groupType == GroupType.Community) {
      return true;
    }
    return false;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(16), vertical: getHeight(8)),
                    width: MediaQuery.of(context).size.width,
                    color: colorTheme.groupProfileTabBackground,
                    child: GestureDetector(
                      onTap: openGroupMemberList,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                "${tL10n.groupMembers} (${widget.groupMembersInfo.length})",
                                style: TextStyle(
                                    color: colorTheme.groupProfileTextColor,
                                    fontSize: textStyle.fontsize_16,
                                    fontWeight: FontWeight.w400)),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: getSquareSize(18),
                            color: colorTheme.groupProfileTabTextColor,
                          )
                        ],
                      ),
                    )),
                checkCanAddMember()
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidth(16), vertical: getHeight(12)),
                        width: MediaQuery.of(context).size.width,
                        color: colorTheme.groupProfileTabBackground,
                        child: GestureDetector(
                            onTap: addGroupMembers,
                            child: Text("+ ${tL10n.addMembers}",
                                style: TextStyle(
                                    color: colorTheme
                                        .groupProfileAddMemberTextColor,
                                    fontSize: textStyle.fontsize_16,
                                    fontWeight: FontWeight.w400))))
                    : Container(),
                Container(
                  height: getHeight(1),
                  color: colorTheme.dividerColor,
                ),
                getGroupMemberListSample()
              ],
            ));
  }
}
