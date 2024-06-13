// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';

class TencentCloudChatContactAddContactsInfo extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatContactAddContactsInfo({
    Key? key,
    required this.userFullInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsInfoState();
}

class TencentCloudChatContactAddContactsInfoState extends TencentCloudChatState<TencentCloudChatContactAddContactsInfo> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              height: getHeight(775),
              decoration: BoxDecoration(color: colorTheme.contactAddContactInfoBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(getWidth(10)))),
              child: Scaffold(backgroundColor: Colors.transparent, appBar: const TencentCloudChatContactAddContactsInfoAppBar(), body: TencentCloudChatContactAddContactsInfoBody(userFullInfo: widget.userFullInfo)),
            ));
  }
}

class TencentCloudChatContactAddContactsInfoAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TencentCloudChatContactAddContactsInfoAppBar({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsInfoAppBarState();

  @override
  Size get preferredSize => const Size(15, 81);
}

class TencentCloudChatContactAddContactsInfoAppBarState extends TencentCloudChatState<TencentCloudChatContactAddContactsInfoAppBar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              tL10n.info,
              style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.contactItemFriendNameColor),
            ),
            centerTitle: true,
            leadingWidth: getWidth(100),
            leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: getWidth(15))),
                    Text(
                      tL10n.back,
                      style: TextStyle(
                        color: colorTheme.contactBackButtonColor,
                        fontSize: textStyle.fontsize_16,
                      ),
                    ),
                  ],
                ))));
  }
}

class TencentCloudChatContactAddContactsInfoBody extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatContactAddContactsInfoBody({
    Key? key,
    required this.userFullInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsInfoBodyState();
}

class TencentCloudChatContactAddContactsInfoBodyState extends TencentCloudChatState<TencentCloudChatContactAddContactsInfoBody> {
  bool showDetailAddInfo = false;


  _getToastIcon(bool check) {
    if (check) {
      return TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => Icon(
                Icons.check_circle_rounded,
                size: getSquareSize(16),
                color: colorTheme.contactAddContactToastCheckColor,
              ));
    }
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Icon(
              Icons.cancel_rounded,
              size: getSquareSize(16),
              color: colorTheme.contactAddContactToastRefuseColor,
            ));
  }

  openContactsDetailInfo() {
    safeSetState(() {
      showDetailAddInfo = true;
    });
  }

  String verification = "";
  String remark = "";
  String friendGroup = "";

  sendAddFriendApplication() {
    if (friendGroup.isEmpty || friendGroup == tL10n.none) {
      friendGroup = "";
    }
    TencentCloudChat.instance.chatSDKInstance.contactSDK.addFriend(widget.userFullInfo.userID ?? "", remark, friendGroup, verification, "flutter", FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH);
    int code = TencentCloudChat.instance.dataInstance.contact.addFriendCode;
    if (code == 0) {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent.call(
        TencentCloudChatComponentsEnum.contact,
        TencentCloudChatCodeInfo.contactAddedSuccessfully,
      );
    } else if (code == 30539) {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent.call(
        TencentCloudChatComponentsEnum.contact,
        TencentCloudChatCodeInfo.contactRequestSent,
      );
    } else {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent.call(
        TencentCloudChatComponentsEnum.contact,
        TencentCloudChatCodeInfo.cannotAddContact,
      );
    }
  }

  getVerification(String value) {
    safeSetState(() {
      verification = value;
    });
  }

  getRemarks(String value) {
    safeSetState(() {
      remark = value;
    });
  }

  getFriendGroup(String value) {
    safeSetState(() {
      friendGroup = value;
    });
  }

  Widget getAddFriendInfoWidget() {
    if (showDetailAddInfo == false) {
      return Row(
        children: [TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAddContactInfoButtonBuilder(widget.userFullInfo, openContactsDetailInfo)],
      );
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAddContactsInfoVerificationBuilder(getVerification),
        TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAddContactsInfoRemarksAndGroupBuilder(getRemarks, getFriendGroup),
        TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAddContactsDetailInfoSendButton(sendAddFriendApplication)
      ]);
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => ListView(children: [
              Container(
                  color: colorTheme.contactApplicationBackgroundColor,
                  child: Center(
                      child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: getHeight(10), horizontal: getWidth(16)),
                        color: colorTheme.contactBackgroundColor,
                        child: Row(children: [
                          TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAddContactInfoAvatarBuilder(widget.userFullInfo),
                          TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAddContactInfoContentBuilder(widget.userFullInfo),
                        ]),
                      ),
                      getAddFriendInfoWidget()
                    ],
                  )))
            ]));
  }
}

class TencentCloudChatContactAddContactsInfoAvatar extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatContactAddContactsInfoAvatar({
    Key? key,
    required this.userFullInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsInfoAvatarState();
}

class TencentCloudChatContactAddContactsInfoAvatarState extends TencentCloudChatState<TencentCloudChatContactAddContactsInfoAvatar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: getWidth(18)),
        child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
          scene: TencentCloudChatAvatarScene.contacts,
          imageList: [widget.userFullInfo.faceUrl],
          width: getSquareSize(60),
          height: getSquareSize(60),
          borderRadius: getSquareSize(4),
        ));
  }
}

class TencentCloudChatContactAddContactsInfoContent extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatContactAddContactsInfoContent({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsInfoContentState();
}

class TencentCloudChatContactAddContactsInfoContentState extends TencentCloudChatState<TencentCloudChatContactAddContactsInfoContent> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(widget.userFullInfo.nickName ?? widget.userFullInfo.userID ?? "", style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.contactItemFriendNameColor)),
                Text("ID: ${widget.userFullInfo.userID}", style: TextStyle(color: colorTheme.contactItemFriendNameColor, fontSize: textStyle.fontsize_12, fontWeight: FontWeight.w400)),
                Text("${tL10n.signature}: ${widget.userFullInfo.selfSignature}", style: TextStyle(color: colorTheme.contactItemFriendNameColor, fontSize: textStyle.fontsize_12, fontWeight: FontWeight.w400)),
              ],
            )));
  }
}

class TencentCloudChatContactAddContactsInfoButton extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;
  final Function? showDetailAddInfo;

  const TencentCloudChatContactAddContactsInfoButton({
    Key? key,
    required this.userFullInfo,
    this.showDetailAddInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsInfoButtonState();
}

class TencentCloudChatContactAddContactsInfoButtonState extends TencentCloudChatState<TencentCloudChatContactAddContactsInfoButton> {
  onClickAddContact() {
    if (widget.showDetailAddInfo != null) {
      widget.showDetailAddInfo!();
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: getHeight(20)),
              color: colorTheme.backgroundColor,
              padding: EdgeInsets.symmetric(vertical: getHeight(10), horizontal: getWidth(20)),
              child: GestureDetector(
                  onTap: onClickAddContact,
                  child: Text(
                    tL10n.addContact,
                    style: TextStyle(color: colorTheme.contactAgreeButtonColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400),
                  )),
            ));
  }
}

class TencentCloudChatContactAddContactsInfoVerification extends StatefulWidget {
  final Function onVerificationChanged;

  const TencentCloudChatContactAddContactsInfoVerification({super.key, required this.onVerificationChanged});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsInfoVerificationState();
}

class TencentCloudChatContactAddContactsInfoVerificationState extends TencentCloudChatState<TencentCloudChatContactAddContactsInfoVerification> {
  final TextEditingController _verificationController = TextEditingController();

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: getHeight(22)),
                  padding: EdgeInsets.only(left: getWidth(16), top: getHeight(4)),
                  child: Text(
                    tL10n.fillInTheVerificationInformation,
                    style: TextStyle(fontSize: textStyle.fontsize_14, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: getHeight(4), bottom: getHeight(20)),
                    padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(12)),
                    color: colorTheme.backgroundColor,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        // minLines: 1,
                        maxLines: 4,
                        controller: _verificationController,
                        onChanged: (String value) {
                          widget.onVerificationChanged(value);
                        },
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(color: colorTheme.contactItemTabItemNameColor),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '',
                        ),
                      ),
                    )),
              ],
            ));
  }
}

class TencentCloudChatContactAddContactsInfoRemarksAndGroup extends StatefulWidget {
  final Function onRemarksChanged;
  final Function onFriendGroupChanged;

  const TencentCloudChatContactAddContactsInfoRemarksAndGroup({super.key, required this.onRemarksChanged, required this.onFriendGroupChanged});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsInfoRemarksAndGroupState();
}

class TencentCloudChatContactAddContactsInfoRemarksAndGroupState extends TencentCloudChatState<TencentCloudChatContactAddContactsInfoRemarksAndGroup> {
  final TextEditingController _nickNameController = TextEditingController();

  List<String> friendGroup = [tL10n.none];
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();
    TencentCloudChat.instance.chatSDKInstance.contactSDK.getFriendGroup(null);
    List<V2TimFriendGroup> list = TencentCloudChat.instance.dataInstance.contact.friendGroup;
    for (final element in list) {
      if (element.name != null && element.name != "") {
        friendGroup.add(element.name ?? "");
      }
    }
    if (friendGroup.isNotEmpty) {
      dropdownValue = friendGroup.first;
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.only(left: getWidth(16), top: getHeight(4), bottom: getHeight(4)),
                child: Text(
                  tL10n.remarkAndGrouping,
                  style: TextStyle(fontSize: textStyle.fontsize_14, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: getHeight(5), horizontal: getWidth(16)),
                  decoration: BoxDecoration(color: colorTheme.backgroundColor, border: Border(bottom: BorderSide(color: colorTheme.contactItemTabItemBorderColor))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tL10n.remark,
                        style: TextStyle(fontSize: textStyle.fontsize_14, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: getWidth(70),
                        child: TextField(
                          controller: _nickNameController,
                          textAlign: TextAlign.end,
                          onChanged: (String value) {
                            widget.onRemarksChanged(value);
                          },
                          style: TextStyle(color: colorTheme.contactItemFriendNameColor),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '',
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                padding: EdgeInsets.symmetric(vertical: getHeight(12), horizontal: getWidth(16)),
                color: colorTheme.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      tL10n.group,
                      style: TextStyle(fontSize: textStyle.fontsize_14, fontWeight: FontWeight.w400),
                    )),
                    SizedBox(
                        width: getWidth(150),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: getSquareSize(12),
                          ),
                          style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400, color: colorTheme.contactItemFriendNameColor),
                          elevation: 16,
                          isDense: true,
                          isExpanded: true,
                          underline: Container(),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            safeSetState(() {
                              dropdownValue = value!;
                              widget.onFriendGroupChanged(value);
                            });
                          },
                          items: friendGroup.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(alignment: Alignment.centerRight, child: Text(value)),
                            );
                          }).toList(),
                        ))
                  ],
                ),
              )
            ]));
  }
}

class TencentCloudChatContactAddContactsDetailInfoSendButton extends StatefulWidget {
  final Function addFriend;

  const TencentCloudChatContactAddContactsDetailInfoSendButton({super.key, required this.addFriend});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddContactsDetailInfoSendButtonState();
}

class TencentCloudChatContactAddContactsDetailInfoSendButtonState extends TencentCloudChatState<TencentCloudChatContactAddContactsDetailInfoSendButton> {
  onTapSendButton() {
    widget.addFriend();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: getHeight(12), horizontal: getWidth(16)),
              color: colorTheme.backgroundColor,
              margin: EdgeInsets.only(top: getHeight(20)),
              child: GestureDetector(
                onTap: onTapSendButton,
                child: Text(
                  tL10n.send,
                  style: TextStyle(color: colorTheme.contactAgreeButtonColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400),
                ),
              ),
            ));
  }
}
