import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';

class TencentCloudChatGroupNotification extends StatefulWidget {
  final V2TimGroupInfo groupInfo;

  const TencentCloudChatGroupNotification(
      {super.key, required this.groupInfo});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatGroupNotificationState();
}

class TencentCloudChatGroupNotificationState
    extends TencentCloudChatState<TencentCloudChatGroupNotification> {
  String notification = "";

  @override
  initState() {
    super.initState();
    notification = widget.groupInfo.notification ?? "";
  }

  bool canEditNotification() {
    String groupType = widget.groupInfo.groupType;
    int role = widget.groupInfo.role!;
    if (groupType == GroupType.Work) {
      return true;
    } else if ((groupType == GroupType.Public ||
            groupType == GroupType.Community) &&
        (role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN ||
            role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER)) {
      return true;
    } else if (role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER) {
      return true;
    }
    return false;
  }

  _onSetGroupNotification(String value) async {
    final res = await TencentCloudChat.instance.chatSDKInstance.groupSDK
        .setGroupInfo(
            groupID: widget.groupInfo.groupID,
            groupType: widget.groupInfo.groupType,
            notification: value);
    if (res.code == 0) {
      safeSetState(() {
        notification = value;
      });
    }
  }

  onEditNotification() {
    String mid = "";

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(tL10n.setGroupAnnouncement),
            content: CupertinoTextField(
              maxLines: null,
              onChanged: (value) {
                mid = value;
              },
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  _onSetGroupNotification(mid);
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
  Widget? desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(16), vertical: getHeight(12)),
                    child: Text(
                      notification,
                      style: TextStyle(
                          color: colorTheme.groupProfileTextColor,
                          fontSize: textStyle.fontsize_14),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: getHeight(16),
                                  horizontal: getWidth(16)),
                              child: Text(
                                tL10n.cancel,
                                style: TextStyle(
                                    color: colorTheme
                                        .groupProfileAddMemberTextColor,
                                    fontSize: textStyle.fontsize_14),
                              )),
                        ),
                        canEditNotification()
                            ? GestureDetector(
                                onTap: onEditNotification,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: getHeight(16),
                                        horizontal: getWidth(16)),
                                    child: Text(
                                      tL10n.edit,
                                      style: TextStyle(
                                          color: colorTheme
                                              .groupProfileAddMemberTextColor,
                                          fontSize: textStyle.fontsize_14),
                                    )),
                              )
                            : Container()
                      ],
                    ),
                  )
                ]));
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              appBar: AppBar(
                leadingWidth: getWidth(100),
                leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getHeight(16), horizontal: getWidth(16)),
                        child: Text(
                          tL10n.cancel,
                          style: TextStyle(
                              color: colorTheme.groupProfileAddMemberTextColor,
                              fontSize: textStyle.fontsize_14),
                        ))),
                actions: [
                  canEditNotification()
                      ? GestureDetector(
                          onTap: onEditNotification,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: getHeight(16),
                                  horizontal: getWidth(16)),
                              child: Text(
                                tL10n.edit,
                                style: TextStyle(
                                    color: colorTheme
                                        .groupProfileAddMemberTextColor,
                                    fontSize: textStyle.fontsize_14),
                              )),
                        )
                      : Container()
                ],
                title: Text(tL10n.announcement,
                    style: TextStyle(
                      fontSize: textStyle.fontsize_16,
                      color: colorTheme.groupProfileTextColor,
                    )),
                centerTitle: true,
              ),
              body: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: getWidth(16), vertical: getHeight(12)),
                child: Text(
                  notification,
                  style: TextStyle(
                      color: colorTheme.groupProfileTextColor,
                      fontSize: textStyle.fontsize_14),
                ),
              ),
            ));
  }
}
