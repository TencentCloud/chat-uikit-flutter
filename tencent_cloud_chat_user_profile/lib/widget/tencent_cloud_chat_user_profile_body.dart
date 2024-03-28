import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_contact_sdk.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_conversation_sdk.dart';
import 'package:tencent_cloud_chat/chat_sdk/components/tencent_cloud_chat_message_sdk.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';
import 'package:tencent_cloud_chat_common/widgets/operation_bar/tencent_cloud_chat_operation_bar.dart';
import 'package:tencent_cloud_chat_user_profile/tencent_cloud_chat_user_profile_builders.dart';

class TencentCloudChatUserProfileBody extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  const TencentCloudChatUserProfileBody({super.key, required this.userFullInfo, this.startVoiceCall, this.startVideoCall});

  @override
  State<StatefulWidget> createState() => TencentCloudChatUserProfileBodyState();
}

class TencentCloudChatUserProfileBodyState extends TencentCloudChatState<TencentCloudChatUserProfileBody> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Center(
              child: ListView(
                children: [
                  SizedBox(
                    height: getHeight(40),
                  ),
                  TencentCloudChatUserProfileBuilders.getUserProfileAvatarBuilder(
                    userFullInfo: widget.userFullInfo,
                  ),
                  TencentCloudChatUserProfileBuilders.getUserProfileContentBuilder(
                    userFullInfo: widget.userFullInfo,
                  ),
                  TencentCloudChatUserProfileBuilders.getUserProfileChatButtonBuilder(
                    userFullInfo: widget.userFullInfo,
                    startVideoCall: widget.startVideoCall,
                    startVoiceCall: widget.startVoiceCall,
                  ),
                  TencentCloudChatUserProfileBuilders.getUserProfileStateButtonBuilder(userFullInfo: widget.userFullInfo),
                  TencentCloudChatUserProfileBuilders.getUserProfileDeleteButtonBuilder(
                    userFullInfo: widget.userFullInfo,
                  )
                ],
              ),
            ));
  }
}

class TencentCloudChatUserProfileAvatar extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatUserProfileAvatar({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatUserProfileAvatarState();
}

class TencentCloudChatUserProfileAvatarState extends TencentCloudChatState<TencentCloudChatUserProfileAvatar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
          scene: TencentCloudChatAvatarScene.userProfile,
          imageList: [
            TencentCloudChatUtils.checkString(widget.userFullInfo.faceUrl) ?? "https://comm.qq.com/im/static-files/im-demo/im_virtual_customer.png",
          ],
          width: getSquareSize(94),
          height: getSquareSize(94),
          borderRadius: getSquareSize(48),
        )
      ],
    );
  }
}

class TencentCloudChatUserProfileContent extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatUserProfileContent({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatUserProfileContentState();
}

class TencentCloudChatUserProfileContentState extends TencentCloudChatState<TencentCloudChatUserProfileContent> {
  String friendRemark = "";

  @override
  initState() {
    super.initState();
    friendRemark = widget.userFullInfo.nickName ?? widget.userFullInfo.userID ?? "";
  }

  _onChangeGroupName(String value) async {
    final res = await TencentCloudChatContactSDK.setFriendInfo(userID: widget.userFullInfo.userID!, friendRemark: value);
    if (res.code == 0) {
      safeSetState(() {
        friendRemark = value;
      });
    }
  }

  changeNickName() {
    String mid = "";

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(tL10n.setNickname),
            content: CupertinoTextField(
              maxLines: null,
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
                      Text(
                        friendRemark,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: textStyle.fontsize_24, fontWeight: FontWeight.w600),
                      ),
                      FloatingActionButton.small(
                          onPressed: changeNickName,
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
                    "ID: ${widget.userFullInfo.userID}",
                    style: TextStyle(fontSize: textStyle.fontsize_12),
                  )
                ],
              ),
            ));
  }
}

class TencentCloudChatUserProfileChatButton extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  const TencentCloudChatUserProfileChatButton({super.key, required this.userFullInfo, this.startVoiceCall, this.startVideoCall});

  @override
  State<StatefulWidget> createState() => TencentCloudChatUserProfileChatButtonState();
}

class TencentCloudChatUserProfileChatButtonState extends TencentCloudChatState<TencentCloudChatUserProfileChatButton> {
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
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(getSquareSize(12)),
                ),
                child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(getSquareSize(12)),
                    child: InkWell(
                      onTap: onTap,
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
                                style: TextStyle(color: colorTheme.primaryTextColor, fontSize: textStyle.fontsize_16),
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
                _buildClickableItem(icon: Icons.search_outlined, label: tL10n.search, onTap: () {}),
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

class TencentCloudChatUserProfileStateButton extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatUserProfileStateButton({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatUserProfileStateButtonState();
}

class TencentCloudChatUserProfileStateButtonState extends TencentCloudChatState<TencentCloudChatUserProfileStateButton> {
  bool disturb = false;
  bool pinChat = false;
  bool blockList = false;

  @override
  void initState() {
    super.initState();
    if (_getC2CReceiveOpt() == 2) {
      disturb = true;
    }
    int index = TencentCloudChat().dataInstance.conversation.conversationList.indexWhere((element) => element.conversationID == "c2c_${widget.userFullInfo.userID}");
    if (index > -1) {
      pinChat = TencentCloudChat().dataInstance.conversation.conversationList[index].isPinned!;
    }
    int indexBlock = TencentCloudChat().dataInstance.contact.blockList.indexWhere((element) => element.userID == "c2c_${widget.userFullInfo.userID}");
    if (indexBlock > -1) {
      blockList = true;
    }
  }

  _getC2CReceiveOpt() async {
    int opt = await TencentCloudChatContactSDK.getC2CReceiveMessageOpt(userIDList: [widget.userFullInfo.userID!]);
    return opt;
  }

  _setC2CReceiveOpt() async {
    await TencentCloudChatContactSDK.setC2CReceiveMessageOpt(userIDList: [widget.userFullInfo.userID!], opt: disturb ? ReceiveMsgOptEnum.V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE : ReceiveMsgOptEnum.V2TIM_RECEIVE_MESSAGE);
  }

  _setPinConversation(bool value) async {
    await TencentCloudChatConversationSDK.pinConversation(conversationID: "c2c_${widget.userFullInfo.userID}", isPinned: value);
    safeSetState(() {
      pinChat = value;
    });
  }

  _addToBlockList(bool value) async {
    if (value) {
      await TencentCloudChatContactSDK.addToBlackList(userIDList: [widget.userFullInfo.userID!]);
    } else {
      await TencentCloudChatContactSDK.deleteFromBlackList(userIDList: [widget.userFullInfo.userID!]);
    }
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
                    _setC2CReceiveOpt();
                    setState(() {
                      disturb = value;
                    });
                  },
                ),
                TencentCloudChatOperationBar(
                  label: tL10n.pin,
                  operationBarType: OperationBarType.switchControl,
                  value: pinChat,
                  onChange: (bool value) {
                    _setPinConversation(value);
                    setState(() {
                      pinChat = value;
                    });
                  },
                ),
                TencentCloudChatOperationBar(
                  label: tL10n.blackUser,
                  operationBarType: OperationBarType.switchControl,
                  value: blockList,
                  onChange: (bool value) {
                    _addToBlockList(value);
                    setState(() {
                      blockList = value;
                    });
                  },
                ),
              ],
            ));
  }
}

class TencentCloudChatUserProfileDeleteButton extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatUserProfileDeleteButton({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatUserProfileDeleteButtonState();
}

class TencentCloudChatUserProfileDeleteButtonState extends TencentCloudChatState<TencentCloudChatUserProfileDeleteButton> {
  @override
  Widget defaultBuilder(BuildContext context) {
    onClearChatHistory() async {
      await TencentCloudChatMessageSDK.clearC2CHistoryMessage(userID: widget.userFullInfo.userID!);
    }

    onDeleteContact() async {
      await TencentCloudChatContactSDK.deleteFromFriendList([widget.userFullInfo.userID!], FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH);
    }

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
                      color: colorTheme.contactAddContactFriendInfoStateButtonBackgroundColor),
                  padding: EdgeInsets.symmetric(vertical: getHeight(10), horizontal: getWidth(16)),
                  child: GestureDetector(
                      onTap: onClearChatHistory,
                      child: Text(
                        tL10n.deleteAllMessages,
                        style: TextStyle(color: colorTheme.contactRefuseButtonColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400),
                      ))),
              Container(
                  color: colorTheme.contactAddContactFriendInfoStateButtonBackgroundColor,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: getHeight(10), horizontal: getWidth(16)),
                  child: GestureDetector(
                      onTap: onDeleteContact,
                      child: Text(
                        tL10n.delete,
                        style: TextStyle(color: colorTheme.contactRefuseButtonColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400),
                      )))
            ]));
  }
}
