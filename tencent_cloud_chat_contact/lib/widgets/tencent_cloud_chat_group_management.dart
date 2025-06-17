// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_common/widgets/operation_bar/tencent_cloud_chat_operation_bar.dart';
import 'package:tencent_cloud_chat_contact/model/contact_presenter.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_group_add_member.dart';

class TencentCloudChatGroupManagement extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberList;

  const TencentCloudChatGroupManagement({
    Key? key,
    required this.groupInfo,
    required this.memberList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupManagementState();
}

class TencentCloudChatGroupManagementState extends TencentCloudChatState<TencentCloudChatGroupManagement> {
  ContactPresenter contactPresenter = ContactPresenter();
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    isMuted = widget.groupInfo.isAllMuted ?? false;
  }

  _onGroupMemberMute(bool value) async {
    final res = await contactPresenter.setGroupInfo(
        groupID: widget.groupInfo.groupID, groupType: widget.groupInfo.groupType, isAllMuted: value);
    if (res.code == 0) {
      safeSetState(() {
        isMuted = value;
      });
    }
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
                body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: getHeight(8)),
                  child: Column(children: [
                    TencentCloudChatOperationBar(
                      label: tL10n.enabledGroupMute,
                      operationBarType: OperationBarType.switchControl,
                      value: isMuted,
                      onChange: (bool value) {
                        _onGroupMemberMute(value);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: getWidth(17), vertical: getHeight(7)),
                      child: Text(
                        tL10n.onlyGroupOwnerAndAdminsCanSendMessages,
                        style: TextStyle(fontSize: textStyle.fontsize_12),
                      ),
                    ),
                  ]),
                ),
                isMuted
                    ? Container()
                    : Expanded(
                        child: TencentCloudChatGroupProfileAddMuteMember(
                        groupInfo: widget.groupInfo,
                        memberList: widget.memberList,
                      ))
              ],
            )));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
            appBar: AppBar(
              title: Text(tL10n.groupManagement,
                  style: TextStyle(
                    fontSize: textStyle.fontsize_16,
                    color: colorTheme.groupProfileTextColor,
                  )),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: getHeight(8)),
                  child: Column(children: [
                    TencentCloudChatOperationBar(
                      label: tL10n.enabledGroupMute,
                      operationBarType: OperationBarType.switchControl,
                      value: isMuted,
                      onChange: (bool value) {
                        _onGroupMemberMute(value);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: getWidth(17), vertical: getHeight(7)),
                      child: Text(
                        tL10n.onlyGroupOwnerAndAdminsCanSendMessages,
                        style: TextStyle(fontSize: textStyle.fontsize_12),
                      ),
                    ),
                  ]),
                ),
                isMuted
                    ? Container()
                    : Expanded(
                        child: TencentCloudChatGroupProfileAddMuteMember(
                        groupInfo: widget.groupInfo,
                        memberList: widget.memberList,
                      ))
              ],
            )));
  }
}

class TencentCloudChatGroupProfileAddMuteMember extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberList;

  const TencentCloudChatGroupProfileAddMuteMember({
    Key? key,
    required this.groupInfo,
    required this.memberList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfileAddMuteMemberState();
}

class TencentCloudChatGroupProfileAddMuteMemberState
    extends TencentCloudChatState<TencentCloudChatGroupProfileAddMuteMember> {
  ContactPresenter contactPresenter = ContactPresenter();
  List<V2TimGroupMemberFullInfo> silencedMember = [];
  List<V2TimGroupMemberFullInfo> _memberList = [];

  @override
  void initState() {
    super.initState();
    final currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < widget.memberList.length; i++) {
      if (widget.memberList[i].muteUntil != null && widget.memberList[i].muteUntil! > 0) {
        final muteUntil = widget.memberList[i].muteUntil! * 1000;
        if (muteUntil > currentTimeStamp) {
          silencedMember.add(widget.memberList[i]);
        }
      }
    }
    _memberList = widget.memberList;
  }

  onChanged(items) {
    safeSetState(() {
      for (var item in items) {
        final targetIndex = _memberList.indexWhere((i) => i.userID == item.userID);
        if (targetIndex != -1) {
          _memberList[targetIndex] = item;
        }
      }
      silencedMember.addAll(items);
    });
  }

  submitDelete(String userID) async {
    final res = await contactPresenter.muteGroupMember(groupID: widget.groupInfo.groupID, userID: userID, seconds: 0);
    if (res.code == 0) {
      safeSetState(() {
        final targetIndex = _memberList.indexWhere((i) => i.userID == userID);
        if (targetIndex != -1) {
          _memberList[targetIndex].muteUntil = 0;
        }
        silencedMember.removeWhere((item) => item.userID == userID);
      });
    }
  }

  Widget _buildSilencedMemberItem(V2TimGroupMemberFullInfo info, colorTheme, textStyle) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: getHeight(5), horizontal: getWidth(16)),
      width: MediaQuery.of(context).size.width,
      color: colorTheme.inputAreaBackground,
      margin: EdgeInsets.only(bottom: getHeight(1)),
      child: Row(children: [
        TencentCloudChatAvatar(
          imageList: [TencentCloudChatUtils.checkString(info.faceUrl)],
          scene: TencentCloudChatAvatarScene.groupProfile,
          width: getWidth(40),
          height: getHeight(40),
          borderRadius: getSquareSize(4),
        ),
        SizedBox(
          width: getWidth(13),
        ),
        Text(
          TencentCloudChatUtils.checkString(info.nameCard) ?? info.userID,
          style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.groupProfileTextColor),
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
              onTap: () {
                submitDelete(info.userID);
              },
              child: const Icon(
                Icons.remove_circle,
                color: Colors.red,
              )),
        ))
      ]),
    );
  }

  openSilenceMemberList() {
    final isDesktop = TencentCloudChatPlatformAdapter().isDesktop;
    if (isDesktop) {
      TencentCloudChatDialog.showCustomDialog(
          context: context,
          builder: (c) => TencentCloudChatGroupProfileAddSilenceMemberList(
                groupInfo: widget.groupInfo,
                memberList: _memberList,
                onChanged: onChanged,
              ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TencentCloudChatGroupProfileAddSilenceMemberList(
                    groupInfo: widget.groupInfo,
                    memberList: _memberList,
                    onChanged: onChanged,
                  )));
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                GestureDetector(
                    onTap: openSilenceMemberList,
                    child: Container(
                      margin: EdgeInsets.only(bottom: getHeight(1)),
                      padding: EdgeInsets.symmetric(vertical: getHeight(12), horizontal: getWidth(16)),
                      color: colorTheme.inputAreaBackground,
                      child: Row(children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          size: getSquareSize(20),
                          color: colorTheme.groupProfileAddMemberTextColor,
                        ),
                        SizedBox(
                          width: getWidth(5),
                        ),
                        Text(
                          tL10n.addSilencedMember,
                          style: TextStyle(
                              fontSize: textStyle.fontsize_14, color: colorTheme.groupProfileAddMemberTextColor),
                        )
                      ]),
                    )),
                Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: silencedMember.length,
                        itemBuilder: (context, index) {
                          return _buildSilencedMemberItem(silencedMember[index], colorTheme, textStyle);
                        }))
              ],
            ));
  }
}

class TencentCloudChatGroupProfileAddSilenceMemberList extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberList;
  final Function onChanged;

  const TencentCloudChatGroupProfileAddSilenceMemberList({
    Key? key,
    required this.groupInfo,
    required this.memberList,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfileAddSilenceMemberListState();
}

class TencentCloudChatGroupProfileAddSilenceMemberListState
    extends TencentCloudChatState<TencentCloudChatGroupProfileAddSilenceMemberList> {
  ContactPresenter contactPresenter = ContactPresenter();

  submitAdd() async {
    List<V2TimGroupMemberFullInfo> success = [];
    for (int i = 0; i < selectedContacts.length; i++) {
      final res = await contactPresenter.muteGroupMember(
          groupID: widget.groupInfo.groupID, userID: selectedContacts[i].userID, seconds: 60 * 60 * 24 * 7);
      if (res.code == 0) {
        final muteUntil = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
        selectedContacts[i].muteUntil = muteUntil + 60 * 60 * 24 * 7;
        success.add(selectedContacts[i]);
      }
    }
    widget.onChanged(success);
  }

  List<V2TimGroupMemberFullInfo> selectedContacts = [];

  onChanged(selected) {
    selectedContacts = selected;
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(build: (context, colorTheme, textStyle) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                submitAdd();
                Navigator.pop(context);
              },
              child: Text(
                tL10n.confirm,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: TencentCloudChatGroupProfileAddMemberList(
              memberList: widget.memberList,
              onSelectedMemberItemChange: onChanged,
            ),
          )
        ],
      );
    });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              appBar: AppBar(
                title: Text(
                  tL10n.addSilencedMember,
                  style: const TextStyle(fontSize: 17),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      submitAdd();
                      Navigator.pop(context);
                    },
                    child: Text(
                      tL10n.confirm,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              body: TencentCloudChatGroupProfileAddMemberList(
                memberList: widget.memberList,
                onSelectedMemberItemChange: onChanged,
              ),
            ));
  }
}
