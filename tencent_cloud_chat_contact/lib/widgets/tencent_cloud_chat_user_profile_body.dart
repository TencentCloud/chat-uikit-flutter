import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/tuicore/tencent_cloud_chat_core.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_common/widgets/operation_bar/tencent_cloud_chat_operation_bar.dart';

class TencentCloudChatUserProfileBody extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;
  final VoidCallback? startVoiceCall;
  final VoidCallback? startVideoCall;
  final bool isNavigatedFromChat;

  const TencentCloudChatUserProfileBody(
      {super.key,
      required this.userFullInfo,
      this.startVoiceCall,
      this.startVideoCall,
      required this.isNavigatedFromChat});

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
                  TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getUserProfileAvatarBuilder(
                    userFullInfo: widget.userFullInfo,
                  ),
                  TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getUserProfileContentBuilder(
                    userFullInfo: widget.userFullInfo,
                  ),
                  TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getUserProfileChatButtonBuilder(
                    userFullInfo: widget.userFullInfo,
                    startVideoCall: widget.startVideoCall,
                    startVoiceCall: widget.startVoiceCall,
                    isNavigatedFromChat: widget.isNavigatedFromChat,
                  ),
                  TencentCloudChat.instance.dataInstance.contact.contactBuilder
                      ?.getUserProfileStateButtonBuilder(userFullInfo: widget.userFullInfo),
                  TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getUserProfileDeleteButtonBuilder(
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
            TencentCloudChatUtils.checkString(widget.userFullInfo.faceUrl),
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

  String _getFriendRemark() {
    var friendInfo = TencentCloudChat.instance.dataInstance.contact.contactList.firstWhere(
        (e) => e.userID == widget.userFullInfo.userID,
        orElse: () => V2TimFriendInfo(userID: widget.userFullInfo.userID!, userProfile: widget.userFullInfo));

    return friendInfo.friendRemark ?? widget.userFullInfo.nickName ?? widget.userFullInfo.userID ?? "";
  }

  @override
  initState() {
    super.initState();
    friendRemark = _getFriendRemark();
  }

  _onChangeFriendRemark(String value) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.contactSDK
        .setFriendInfo(userID: widget.userFullInfo.userID!, friendRemark: value);
    if (res.code == 0) {
      safeSetState(() {
        friendRemark = value;
      });
    }
  }

  changeFriendRemark() {
    String remark = "";

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(tL10n.modifyRemark),
            content: CupertinoTextField(
              maxLines: null,
              onChanged: (value) {
                remark = value;
              },
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(tL10n.cancel),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  _onChangeFriendRemark(remark);
                  Navigator.pop(context);
                },
                child: Text(tL10n.confirm),
              ),
            ],
          );
        });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    Set<String?> friendIDList = TencentCloudChat.instance.dataInstance.contact.contactList.map((e) => e.userID).toSet();
    friendRemark =
        friendRemark.isNotEmpty ? friendRemark : widget.userFullInfo.nickName ?? widget.userFullInfo.userID ?? "";
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
                      if (friendIDList.contains(widget.userFullInfo.userID))
                        FloatingActionButton.small(
                            onPressed: changeFriendRemark,
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
  final bool? isNavigatedFromChat;

  const TencentCloudChatUserProfileChatButton(
      {super.key, required this.userFullInfo, this.startVoiceCall, this.startVideoCall, this.isNavigatedFromChat});

  @override
  State<StatefulWidget> createState() => TencentCloudChatUserProfileChatButtonState();
}

class TencentCloudChatUserProfileChatButtonState extends TencentCloudChatState<TencentCloudChatUserProfileChatButton> {
  final isMobile = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.mobile;

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

  _navigateToChat() async {
    final tryUseOnNavigateToChat = await TencentCloudChat
            .instance.dataInstance.contact.contactEventHandlers?.uiEventHandlers.onNavigateToChat
            ?.call(userID: widget.userFullInfo.userID, groupID: null) ??
        false;
    if (!tryUseOnNavigateToChat) {
      if (TencentCloudChat.instance.dataInstance.basic.usedComponents
          .contains(TencentCloudChatComponentsEnum.message)) {
        if (isMobile) {
          if (mounted) {
            if (widget.isNavigatedFromChat ?? true) {
              Navigator.pop(context);
            } else {
              navigateToMessage(
                context: context,
                options: TencentCloudChatMessageOptions(
                  userID: widget.userFullInfo.userID,
                  groupID: null,
                ),
              );
            }
          }
        } else {
          final conv = await TencentCloudChat.instance.chatSDKInstance.conversationSDK.getConversation(
            userID: widget.userFullInfo.userID,
          );
          TencentCloudChat.instance.dataInstance.conversation.currentConversation = conv;
        }
      }
    }
  }

  _startVoiceCall() async {
    final useCallKit = TencentCloudChat.instance.dataInstance.basic.useCallKit;
    if (useCallKit) {
      if (widget.userFullInfo.userID != null) {
        TencentCloudChatTUICore.audioCall(
          userids: [widget.userFullInfo.userID ?? ""],
        );
      }
    }
  }

  _startVideoCall() async {
    final useCallKit = TencentCloudChat.instance.dataInstance.basic.useCallKit;
    if (useCallKit && widget.userFullInfo.userID != null) {
      TencentCloudChatTUICore.videoCall(
        userids: [widget.userFullInfo.userID ?? ""],
      );
    }
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
                Expanded(
                    child: _buildClickableItem(
                        icon: Icons.message_rounded,
                        label: tL10n.sendMsg,
                        onTap: () {
                          _navigateToChat();
                        })),
                const SizedBox(width: 18),
                Expanded(
                  child: _buildClickableItem(
                      icon: Icons.call,
                      label: tL10n.voiceCall,
                      onTap: () {
                        if (widget.startVoiceCall != null) {
                          widget.startVoiceCall!();
                        } else {
                          _startVoiceCall();
                        }
                      }),
                ),
                const SizedBox(width: 18),
                Expanded(
                    child: _buildClickableItem(
                        icon: Icons.videocam_outlined,
                        label: tL10n.videoCall,
                        onTap: () {
                          if (widget.startVideoCall != null) {
                            widget.startVideoCall!();
                          } else {
                            _startVideoCall();
                          }
                        })),
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

class TencentCloudChatUserProfileStateButtonState
    extends TencentCloudChatState<TencentCloudChatUserProfileStateButton> {
  bool disturb = false;
  bool pinChat = false;
  bool blockList = false;

  @override
  void initState() {
    super.initState();
    int index = TencentCloudChat.instance.dataInstance.conversation.conversationList
        .indexWhere((element) => element.conversationID == "c2c_${widget.userFullInfo.userID}");
    if (index > -1) {
      pinChat = TencentCloudChat.instance.dataInstance.conversation.conversationList[index].isPinned!;
      disturb = TencentCloudChat.instance.dataInstance.conversation.conversationList[index].recvOpt! == 2;
    }
    int indexBlock = TencentCloudChat.instance.dataInstance.contact.blockList
        .indexWhere((element) => element.userID == widget.userFullInfo.userID);
    if (indexBlock > -1) {
      blockList = true;
    }
  }

  void _notifyUserSetFailed(int code, String toast) {
    TencentCloudChat.instance.callbacks.onUserNotificationEvent(
        TencentCloudChatComponentsEnum.contact,
        TencentCloudChatUserNotificationEvent(
          eventCode: code,
          text: toast,
        ));
  }

  _setC2CReceiveOpt(bool value) async {
    var result = await TencentCloudChat.instance.chatSDKInstance.contactSDK.setC2CReceiveMessageOpt(
        userIDList: [widget.userFullInfo.userID!],
        opt: value ? ReceiveMsgOptEnum.V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE : ReceiveMsgOptEnum.V2TIM_RECEIVE_MESSAGE);

    if (result.code != 0) {
      setState(() {
        disturb = !value;
      });

      _notifyUserSetFailed(result.code, tL10n.setFailed);
    }
  }

  _setPinConversation(bool value) async {
    var result = await TencentCloudChat.instance.chatSDKInstance.conversationSDK
        .pinConversation(conversationID: "c2c_${widget.userFullInfo.userID}", isPinned: value);

    if (result.code != 0) {
      safeSetState(() {
        pinChat = !value;
      });

      _notifyUserSetFailed(result.code, tL10n.setFailed);
    }
  }

  _updateBlockList(bool value) async {
    V2TimValueCallback<List<V2TimFriendOperationResult>>? result;
    if (value) {
      result = await TencentCloudChat.instance.chatSDKInstance.contactSDK
          .addToBlackList(userIDList: [widget.userFullInfo.userID!]);
    } else {
      result = await TencentCloudChat.instance.chatSDKInstance.contactSDK
          .deleteFromBlackList(userIDList: [widget.userFullInfo.userID!]);
    }

    if (result.code != 0) {
      safeSetState(() {
        blockList = !value;
      });

      _notifyUserSetFailed(result.code, tL10n.setFailed);
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
                    _setC2CReceiveOpt(value);
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
                    _updateBlockList(value);
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

class TencentCloudChatUserProfileDeleteButtonState
    extends TencentCloudChatState<TencentCloudChatUserProfileDeleteButton> {
  showClearChatHistoryDialog() async {
    TencentCloudChatDialog.showAdaptiveDialog(
      context: context,
      title: Text(tL10n.clearMsgTip),
      actions: <Widget>[
        TextButton(
          child: Text(tL10n.cancel),
          onPressed: () => Navigator.of(context).pop(), // 关闭对话框
        ),
        TextButton(
          child: Text(tL10n.confirm),
          onPressed: () {
            //关闭对话框并返回true
            Navigator.of(context).pop(true);
            onClearChatHistory();
          },
        ),
      ],
    );
  }

  void onClearChatHistory() async {
    final result = await TencentCloudChat.instance.chatSDKInstance.messageSDK
        .clearC2CHistoryMessage(userID: widget.userFullInfo.userID!);
    if (result.code == 0) {
      TencentCloudChat.instance.dataInstance.messageData.clearMessageList(userID: widget.userFullInfo.userID!);
    }
  }

  void onDeleteContact() async {
    V2TimValueCallback<List<V2TimFriendOperationResult>> result = await TencentCloudChat
        .instance.chatSDKInstance.contactSDK
        .deleteFromFriendList([widget.userFullInfo.userID!], FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH);

    if (mounted) {
      String toast = tL10n.deleteFriendSuccess;
      if (result.code == 0 && result.data != null && result.data!.isNotEmpty && result.data![0].resultCode == 0) {
        toast = tL10n.deleteFriendSuccess;
        safeSetState(() {});
      } else {
        toast = tL10n.deleteFriendFailed;
      }

      int errorCode =
          result.data != null && result.data!.isNotEmpty ? result.data![0].resultCode ?? result.code : result.code;
      TencentCloudChat.instance.callbacks.onUserNotificationEvent(
          TencentCloudChatComponentsEnum.contact,
          TencentCloudChatUserNotificationEvent(
            eventCode: errorCode,
            text: toast,
          ));

      if (errorCode == 0) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    Set<String?> friendIDList = TencentCloudChat.instance.dataInstance.contact.contactList.map((e) => e.userID).toSet();
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
                      onTap: showClearChatHistoryDialog,
                      child: Text(
                        tL10n.deleteAllMessages,
                        style: TextStyle(
                            color: colorTheme.contactRefuseButtonColor,
                            fontSize: textStyle.fontsize_16,
                            fontWeight: FontWeight.w400),
                      ))),
              if (friendIDList.contains(widget.userFullInfo.userID))
                Container(
                    color: colorTheme.contactAddContactFriendInfoStateButtonBackgroundColor,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: getHeight(10), horizontal: getWidth(16)),
                    child: GestureDetector(
                        onTap: onDeleteContact,
                        child: Text(
                          tL10n.delete,
                          style: TextStyle(
                              color: colorTheme.contactRefuseButtonColor,
                              fontSize: textStyle.fontsize_16,
                              fontWeight: FontWeight.w400),
                        )))
            ]));
  }
}
