import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_class.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';

class TIMUIKitProfileWidget extends TIMUIKitClass {
  static final bool isDesktopScreen =
      TUIKitScreenUtils.getFormFactor() == DeviceType.Desktop;

  static Widget operationDivider(
      {Color? color, double? height, EdgeInsetsGeometry? margin}) {
    return Container(
      color: color,
      margin: margin,
      height: height ?? 10,
    );
  }

  /// Remarks
  static Widget remarkBar(
      BuildContext context,
      String remark,
      Function({Offset? offset, String? initText})? handleTap,
      bool smallCardMode) {
    final GlobalKey key = GlobalKey();
    return InkWell(
      onTapDown: (details) {
        if (handleTap != null) {
          handleTap(
              offset: Offset(
                  min(details.globalPosition.dx,
                      MediaQuery.of(context).size.width - 400),
                  min(details.globalPosition.dy,
                      MediaQuery.of(context).size.height - 100)),
              initText: remark);
        }
      },
      child: TIMUIKitOperationItem(
        smallCardMode: smallCardMode,
        itemBoxKey: key,
        isEmpty: remark.isEmpty,
        wideEditText: TIM_t("设置备注名"),
        operationName: TIM_t("备注名"),
        operationRightWidget:
            Text(remark, textAlign: isDesktopScreen ? null : TextAlign.end),
      ),
    );
  }

  /// add to block list
  static Widget addToBlackListBar(bool value, BuildContext context,
      Function(bool value)? onChanged, bool smallCardMode) {
    return TIMUIKitOperationItem(
      smallCardMode: smallCardMode,
      isEmpty: false,
      operationName: TIM_t("加入黑名单"),
      type: "switch",
      operationValue: value,
      onSwitchChange: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
      },
    );
  }

  /// pin the conversation to the top
  static Widget pinConversationBar(bool value, BuildContext context,
      Function(bool value)? onChanged, bool smallCardMode) {
    return TIMUIKitOperationItem(
      smallCardMode: smallCardMode,
      isEmpty: false,
      operationName: TIM_t("置顶聊天"),
      type: "switch",
      operationValue: value,
      onSwitchChange: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
      },
    );
  }

  /// message disturb
  static Widget messageDisturb(BuildContext context, bool isDisturb,
      Function(bool value)? onChanged, bool smallCardMode) {
    return TIMUIKitOperationItem(
      smallCardMode: smallCardMode,
      isEmpty: false,
      operationName: TIM_t("消息免打扰"),
      type: "switch",
      operationValue: isDisturb,
      onSwitchChange: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
      },
    );
  }

  static Widget operationItem(
      {required String operationName,
      required String type,
      bool? operationValue,
      String? operationText,
      required bool isEmpty,
      void Function(bool newValue)? onSwitchChange,
      required bool smallCardMode}) {
    return TIMUIKitOperationItem(
      smallCardMode: smallCardMode,
      isEmpty: isEmpty,
      operationName: operationName,
      type: type,
      operationRightWidget: Text(operationText ?? "",
          textAlign: isDesktopScreen ? null : TextAlign.end),
      operationValue: operationValue,
      onSwitchChange: onSwitchChange,
    );
  }

  /// find history message
  static Widget searchBar(
    BuildContext context,
    V2TimConversation conversation,
    bool smallCardMode, {
    Function()? handleTap,
  }) {
    return InkWell(
      onTap: () {
        if (handleTap != null) {
          handleTap();
        }
      },
      child: TIMUIKitOperationItem(
        isEmpty: true,
        wideEditText: TIM_t("立即搜索"),
        operationName: TIM_t("查找聊天内容"),
      ),
    );
  }

  /// portrait
  static Widget portraitBar(Widget portraitWidget, bool smallCardMode) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        smallCardMode: smallCardMode,
        isEmpty: false,
        operationName: TIM_t("头像"),
        operationRightWidget: portraitWidget,
        showAllowEditStatus: false,
      ),
    );
  }

  /// defaultPortraitWidget
  static Widget defaultPortraitWidget(
      V2TimUserFullInfo? userInfo, bool smallCardMode) {
    return SizedBox(
      width: 48,
      height: 48,
      child: userInfo != null
          ? Avatar(
              faceUrl: userInfo.faceUrl ?? "",
              showName: userInfo.nickName ?? "",
              type: 1,
            )
          : Container(),
    );
  }

  /// nickname
  static Widget nicknameBar(
    String nickName,
    bool smallCardMode,
  ) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        smallCardMode: smallCardMode,
        isEmpty: nickName.isEmpty,
        showAllowEditStatus: false,
        operationName: TIM_t("昵称"),
        operationRightWidget:
            Text(nickName, textAlign: isDesktopScreen ? null : TextAlign.end),
      ),
    );
  }

  /// user account
  static Widget userAccountBar(String userNum, bool smallCardMode) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        smallCardMode: smallCardMode,
        isEmpty: false,
        showAllowEditStatus: false,
        operationName: TIM_t("账号"),
        operationRightWidget: SelectableText(userNum,
            textAlign: isDesktopScreen ? null : TextAlign.end),
      ),
    );
  }

  /// signature
  static Widget signatureBar(String signature, bool smallCardMode) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        smallCardMode: smallCardMode,
        isEmpty: false,
        showAllowEditStatus: false,
        operationName: TIM_t("个性签名"),
        operationRightWidget:
            Text(signature, textAlign: isDesktopScreen ? null : TextAlign.end),
      ),
    );
  }

  /// gender
  static Widget genderBar(int gender, bool smallCardMode) {
    Map genderMap = {
      0: TIM_t("未填写"),
      1: TIM_t("男"),
      2: TIM_t("女"),
    };
    return SizedBox(
      child: TIMUIKitOperationItem(
        smallCardMode: smallCardMode,
        isEmpty: false,
        showAllowEditStatus: false,
        operationName: TIM_t("性别"),
        operationRightWidget: Text(genderMap[gender],
            textAlign: isDesktopScreen ? null : TextAlign.end),
      ),
    );
  }

  /// gender
  static Widget genderBarWithArrow(int gender, bool smallCardMode) {
    Map genderMap = {
      0: TIM_t("未填写"),
      1: TIM_t("男"),
      2: TIM_t("女"),
    };
    return SizedBox(
      child: TIMUIKitOperationItem(
        smallCardMode: smallCardMode,
        isEmpty: false,
        operationName: TIM_t("性别"),
        operationRightWidget: Text(genderMap[gender],
            textAlign: isDesktopScreen ? null : TextAlign.end),
      ),
    );
  }

  /// birthday
  static Widget birthdayBar(int? birthday, bool smallCardMode) {
    try {
      final date = DateTime.parse(birthday.toString());
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      return TIMUIKitOperationItem(
        smallCardMode: smallCardMode,
        isEmpty: false,
        showAllowEditStatus: false,
        operationName: TIM_t("生日"),
        operationRightWidget: Text(formatter.format(date),
            textAlign: isDesktopScreen ? null : TextAlign.end),
      );
    } catch (e) {
      return TIMUIKitOperationItem(
        smallCardMode: smallCardMode,
        isEmpty: false,
        showAllowEditStatus: false,
        operationName: TIM_t("生日"),
        operationRightWidget:
            Text(TIM_t("未填写"), textAlign: isDesktopScreen ? null : TextAlign.end),
      );
    }
  }

  /// default button area
  static Widget addAndDeleteArea(
      V2TimFriendInfo friendInfo,
      V2TimConversation conversation,
      int friendType,
      bool isDisturb,
      bool isBlocked,
      TUITheme theme,
      VoidCallback handleAddFriend,
      VoidCallback handleDeleteFriend,
      bool smallCardMode) {
    _buildDeleteFriend(V2TimConversation conversation, theme) {
      return InkWell(
        onTap: () {
          handleDeleteFriend();
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(color: theme.weakDividerColor))),
          child: Text(
            TIM_t("清除好友"),
            style: TextStyle(color: theme.cautionColor, fontSize: 17),
          ),
        ),
      );
    }

    _buildAddOperation() {
      return Container(
        alignment: Alignment.center,
        // padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: theme.weakDividerColor ??
                        CommonColor.weakDividerColor))),
        child: Row(children: [
          Expanded(
            child: TextButton(
                child: Text(TIM_t("加为好友"),
                    style: TextStyle(color: theme.primaryColor, fontSize: 17)),
                onPressed: () {
                  handleAddFriend();
                }),
          )
        ]),
      );
    }

    return Column(
      children: [
        if (friendType != 0) _buildDeleteFriend(conversation, theme),
        if (friendType == 0 && !isBlocked) _buildAddOperation()
      ],
    );
  }

  static Widget wideButton({
    required VoidCallback onPressed,
    required String text,
    required Color color,
    required bool smallCardMode,
    EdgeInsets? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 10),
      child: smallCardMode
          ? OutlinedButton(
              onPressed: onPressed,
              child: Text(
                text,
                style: TextStyle(color: color),
              ),
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(160, 40)),
              ))
          : ElevatedButton(
              onPressed: onPressed,
              child: Text(text),
              style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(180, 46)),
                  backgroundColor: MaterialStateProperty.all<Color>(color)),
            ),
    );
  }

  /// default button area
  static Widget addAndDeleteAreaWide(
    V2TimFriendInfo friendInfo,
    V2TimConversation conversation,
    int friendType,
    bool isDisturb,
    bool isBlocked,
    TUITheme theme,
    VoidCallback handleAddFriend,
    VoidCallback handleDeleteFriend,
    bool smallCardMode,
  ) {
    _buildDeleteFriend(V2TimConversation conversation, theme) {
      return wideButton(
        smallCardMode: smallCardMode,
        onPressed: () {
          handleDeleteFriend();
        },
        color: theme.cautionColor ?? Colors.red,
        text: TIM_t("清除好友"),
      );
    }

    _buildAddOperation() {
      return wideButton(
        smallCardMode: smallCardMode,
        onPressed: handleAddFriend,
        color: theme.primaryColor ?? hexToColor("3e4b67"),
        text: TIM_t("加为好友"),
      );
    }

    return Column(
      children: [
        if (friendType != 0) _buildDeleteFriend(conversation, theme),
        if (friendType == 0 && !isBlocked) _buildAddOperation()
      ],
    );
  }
}
