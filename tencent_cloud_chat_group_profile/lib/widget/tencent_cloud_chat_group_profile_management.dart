// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_group_sdk.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/operation_bar/tencent_cloud_chat_operation_bar.dart';
import 'package:tencent_cloud_chat_group_profile/widget/tencent_cloud_chat_group_profile_add_member.dart';

class TencentCloudChatGroupProfileManagement extends StatefulWidget {
  final V2TimGroupInfo groupInfo;
  final List<V2TimGroupMemberFullInfo> memberList;
  const TencentCloudChatGroupProfileManagement({
    Key? key,
    required this.groupInfo,
    required this.memberList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfileManagementState();
}

class TencentCloudChatGroupProfileManagementState extends TencentCloudChatState<TencentCloudChatGroupProfileManagement> {
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    isMuted = widget.groupInfo.isAllMuted ?? false;
  }

  _onGroupMemberMute(bool value) async {
    final res = await TencentCloudChatGroupSDK.setGroupInfo(groupID: widget.groupInfo.groupID, groupType: widget.groupInfo.groupType, isAllMuted: value);
    if (res.code == 0) {
      safeSetState(() {
        isMuted = value;
      });
    }
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

class TencentCloudChatGroupProfileAddMuteMemberState extends TencentCloudChatState<TencentCloudChatGroupProfileAddMuteMember> {
  List<V2TimGroupMemberFullInfo> silencedMember = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.memberList.length; i++) {
      if (widget.memberList[i].muteUntil != null && widget.memberList[i].muteUntil! > 0) {
        silencedMember.add(widget.memberList[i]);
      }
    }
  }

  onChanged(items) {
    safeSetState(() {
      silencedMember.addAll(items);
    });
  }

  Widget _buildSilencedMemberItem(V2TimGroupMemberFullInfo info, colorTheme, textStyle) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: getHeight(5), horizontal: getWidth(16)),
      width: MediaQuery.of(context).size.width,
      color: colorTheme.inputAreaBackground,
      margin: EdgeInsets.only(bottom: getHeight(1)),
      child: Row(children: [
        TencentCloudChatAvatar(
          imageList: [TencentCloudChatUtils.checkString(info.faceUrl) ?? "https://comm.qq.com/im/static-files/im-demo/im_virtual_customer.png"],
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
        )
      ]),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TencentCloudChatGroupProfileAddSilenceMemberList(
                                    groupInfo: widget.groupInfo,
                                    memberList: widget.memberList,
                                    onChanged: onChanged,
                                  )));
                    },
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
                          style: TextStyle(fontSize: textStyle.fontsize_14, color: colorTheme.groupProfileAddMemberTextColor),
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

class TencentCloudChatGroupProfileAddSilenceMemberListState extends TencentCloudChatState<TencentCloudChatGroupProfileAddSilenceMemberList> {
  submitAdd() async {
    List<V2TimGroupMemberFullInfo> success = [];
    for (int i = 0; i < selectedContacts.length; i++) {
      final res = await TencentCloudChatGroupSDK.muteGroupMember(groupID: widget.groupInfo.groupID, userID: selectedContacts[i].userID, seconds: 60);
      if (res.code == 0) {
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
              body: TencentCloudChatGroupProfilAddMemberList(
                memberList: widget.memberList,
                onSelectedMemberItemChange: onChanged,
              ),
            ));
  }
}
