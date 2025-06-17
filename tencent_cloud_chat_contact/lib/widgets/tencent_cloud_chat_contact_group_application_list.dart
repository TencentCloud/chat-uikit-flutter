import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/utils/error_message_converter.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_leading.dart';

class TencentCloudChatContactGroupApplicationList extends StatefulWidget {
  final List<V2TimGroupApplication> groupApplicationList;

  const TencentCloudChatContactGroupApplicationList({super.key, required this.groupApplicationList});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupApplicationListState();
}

class TencentCloudChatContactGroupApplicationListState
    extends TencentCloudChatState<TencentCloudChatContactGroupApplicationList> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: AppBar(
          leadingWidth: getWidth(100),
          leading: const TencentCloudChatContactLeading(),
          title: Text(
            tL10n.groupChatNotifications,
            style: TextStyle(
                fontSize: textStyle.fontsize_16,
                fontWeight: FontWeight.w600,
                color: colorTheme.contactItemFriendNameColor),
          ),
          centerTitle: true,
          backgroundColor: colorTheme.contactBackgroundColor,
        ),
        body: Container(
          color: colorTheme.contactApplicationBackgroundColor,
          child: Center(
            child: TencentCloudChatThemeWidget(
              build: (context, colorTheme, textStyle) => widget.groupApplicationList.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        var application = widget.groupApplicationList[index];
                        return TencentCloudChatContactGroupApplicationItem(
                          groupApplication: application,
                        );
                      },
                      itemCount: widget.groupApplicationList.length,
                    )
                  : Center(
                      child: Text(
                        tL10n.noNewApplication,
                        style: TextStyle(
                          fontSize: textStyle.fontsize_12,
                          color: colorTheme.secondaryTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        body: Container(
          color: colorTheme.contactApplicationBackgroundColor,
          child: Center(
            child: TencentCloudChatThemeWidget(
              build: (context, colorTheme, textStyle) => widget.groupApplicationList.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        var application = widget.groupApplicationList[index];
                        return TencentCloudChatContactGroupApplicationItem(
                          groupApplication: application,
                        );
                      },
                      itemCount: widget.groupApplicationList.length,
                    )
                  : Center(
                      child: Text(
                        tL10n.noNewApplication,
                        style: TextStyle(
                          fontSize: textStyle.fontsize_12,
                          color: colorTheme.secondaryTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class TencentCloudChatContactGroupApplicationItem extends StatefulWidget {
  final V2TimGroupApplication groupApplication;

  const TencentCloudChatContactGroupApplicationItem({super.key, required this.groupApplication});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupApplicationItemState();
}

class TencentCloudChatContactGroupApplicationItemState
    extends TencentCloudChatState<TencentCloudChatContactGroupApplicationItem> {
  String _getGroupIDContent() {
    return "groupID:${widget.groupApplication.groupID}";
  }

  String _getJoinGroupContent() {
    V2TimGroupInfo? groupInfo =
        TencentCloudChat.instance.dataInstance.contact.getGroupInfo(widget.groupApplication.groupID);
    if (groupInfo != null) {
      return "${tL10n.applyToJoin}${groupInfo.groupName}";
    } else {
      return "${tL10n.applyToJoin}${widget.groupApplication.groupID}";
    }
  }

  String _getJoinUser() {
    if (widget.groupApplication.type == GroupApplicationTypeEnum.V2TIM_GROUP_APPLICATION_NEED_ADMIN_APPROVE.index) {
      return widget.groupApplication.toUser ?? '';
    } else {
      return TencentCloudChatUtils.checkString(widget.groupApplication.fromUserNickName) ??
          widget.groupApplication.fromUser!;
    }
  }

  String _getReason() {
    if (widget.groupApplication.type == GroupApplicationTypeEnum.V2TIM_GROUP_APPLICATION_NEED_ADMIN_APPROVE.index) {
      return tL10n.inviteToGroupFrom(TencentCloudChatUtils.checkString(widget.groupApplication.fromUserNickName) ??
          widget.groupApplication.fromUser!);
    } else {
      return widget.groupApplication.requestMsg ?? "";
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              color: colorTheme.backgroundColor,
              margin: EdgeInsets.only(top: getHeight(16)),
              padding: EdgeInsets.symmetric(vertical: getHeight(8), horizontal: getWidth(8)),
              child: Row(
                children: [
                  TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                    scene: TencentCloudChatAvatarScene.contacts,
                    imageList: [widget.groupApplication.fromUserFaceUrl],
                    width: getSquareSize(40),
                    height: getSquareSize(40),
                    borderRadius: getSquareSize(34),
                  ),
                  SizedBox(width: getWidth(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getJoinUser(),
                          style:
                              TextStyle(fontSize: textStyle.fontsize_16, color: colorTheme.contactItemFriendNameColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          _getJoinGroupContent(),
                          style: TextStyle(
                              color: colorTheme.contactItemTabItemNameColor,
                              fontSize: textStyle.fontsize_12,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          _getGroupIDContent(),
                          style: TextStyle(
                              color: colorTheme.contactItemTabItemNameColor,
                              fontSize: textStyle.fontsize_12,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        if (TencentCloudChatUtils.checkString(_getReason()) != null)
                          Text(
                            _getReason(),
                            style: TextStyle(
                                color: colorTheme.contactItemTabItemNameColor,
                                fontSize: textStyle.fontsize_12,
                                fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                      ],
                    ),
                  ),
                  TencentCloudChatContactGroupApplicationItemButton(
                    application: widget.groupApplication,
                  )
                ],
              ),
            ));
  }
}

class TencentCloudChatContactGroupApplicationItemGroupName extends StatefulWidget {
  final V2TimGroupApplication application;

  const TencentCloudChatContactGroupApplicationItemGroupName({super.key, required this.application});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupApplicationItemGroupNameState();
}

class TencentCloudChatContactGroupApplicationItemGroupNameState
    extends TencentCloudChatState<TencentCloudChatContactGroupApplicationItemGroupName> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Text(
              widget.application.groupID,
              style: TextStyle(
                  fontSize: textStyle.fontsize_16,
                  fontWeight: FontWeight.w600,
                  color: colorTheme.contactItemFriendNameColor),
            ));
  }
}

class TencentCloudChatContactGroupApplicationItemButton extends StatefulWidget {
  final V2TimGroupApplication application;

  const TencentCloudChatContactGroupApplicationItemButton({super.key, required this.application});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactGroupApplicationItemButtonState();
}

class TencentCloudChatContactGroupApplicationItemButtonState
    extends TencentCloudChatState<TencentCloudChatContactGroupApplicationItemButton> {
  bool showButton = true;
  String showName = "";

  onAcceptApplication() async {
    var result = await TencentCloudChat.instance.chatSDKInstance.contactSDK.acceptGroupApplication(widget.application);
    if (result.code == 0) {
      safeSetState(() {
        showButton = false;
        showName = tL10n.accepted;
      });
    } else {
      TencentCloudChat.instance.callbacks.onSDKFailed(
        "acceptGroupApplication",
        result.code,
        ErrorMessageConverter.getErrorMessage(result.code, result.desc),
      );
    }
  }

  onRefuseApplication() async {
    var result = await TencentCloudChat.instance.chatSDKInstance.contactSDK.refuseGroupApplication(widget.application);
    if (result.code == 0) {
      safeSetState(() {
        showButton = false;
        showName = tL10n.declined;
      });
    } else {
      TencentCloudChat.instance.callbacks.onSDKFailed(
        "refuseGroupApplication",
        result.code,
        ErrorMessageConverter.getErrorMessage(result.code, result.desc),
      );
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    if (showButton == false) {
      return TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => Container(
                padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(5)),
                child: Text(
                  showName,
                  style: TextStyle(
                      color: colorTheme.contactItemTabItemNameColor,
                      fontSize: textStyle.fontsize_12,
                      fontWeight: FontWeight.w400),
                ),
              ));
    }
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: getWidth(10)),
                  padding: EdgeInsets.symmetric(horizontal: getWidth(12), vertical: getHeight(5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSquareSize(8)),
                    color: colorTheme.contactAgreeButtonColor,
                  ),
                  child: GestureDetector(
                    onTap: onAcceptApplication,
                    child: Text(
                      tL10n.agree,
                      style: TextStyle(
                          color: colorTheme.contactBackgroundColor,
                          fontSize: textStyle.fontsize_14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(12), vertical: getHeight(5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getSquareSize(8)),
                    border: Border.all(color: colorTheme.contactTabItemIconColor),
                    color: colorTheme.contactBackgroundColor,
                  ),
                  child: GestureDetector(
                    onTap: onRefuseApplication,
                    child: Text(
                      tL10n.refuse,
                      style: TextStyle(
                          color: colorTheme.contactRefuseButtonColor,
                          fontSize: textStyle.fontsize_14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                )
              ],
            ));
  }
}

class TencentCloudChatContactGroupApplicationListData {
  final List<V2TimGroupApplication> applicationList;

  TencentCloudChatContactGroupApplicationListData({required this.applicationList});

  Map<String, dynamic> toMap() {
    return {'applicationList': applicationList.toString()};
  }

  static TencentCloudChatContactGroupApplicationListData fromMap(Map<String, dynamic> map) {
    return TencentCloudChatContactGroupApplicationListData(
        applicationList: map['applicationList'] as List<V2TimGroupApplication>);
  }
}
