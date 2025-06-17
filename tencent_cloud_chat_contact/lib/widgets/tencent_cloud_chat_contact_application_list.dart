// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_import
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/chat_sdk/components/tencent_cloud_chat_contact_sdk.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_application_info.dart';

class TencentCloudChatContactApplicationList extends StatefulWidget {
  final List<V2TimFriendApplication> applicationList;

  const TencentCloudChatContactApplicationList({super.key, required this.applicationList});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactApplicationListState();
}

class TencentCloudChatContactApplicationListState
    extends TencentCloudChatState<TencentCloudChatContactApplicationList> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, fontSize) => widget.applicationList.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var application = widget.applicationList[index];
                  return TencentCloudChatContactApplicationItem(application: application);
                },
                itemCount: widget.applicationList.length,
              )
            : Center(
                child: Text(
                  tL10n.noNewApplication,
                  style: TextStyle(
                    fontSize: fontSize.fontsize_12,
                    color: colorTheme.secondaryTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ));
  }
}

class TencentCloudChatContactApplicationItem extends StatefulWidget {
  final V2TimFriendApplication application;

  const TencentCloudChatContactApplicationItem({super.key, required this.application});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactApplicationItemState();
}

class TencentCloudChatContactApplicationItemState
    extends TencentCloudChatState<TencentCloudChatContactApplicationItem> {
  ContactApplicationResult applicationResult = ContactApplicationResult(result: "", userID: "");

  void getApplicationResultFromButton(ContactApplicationResult result) {
    safeSetState(() {
      applicationResult = result;
    });
  }

  gotoApplicationInfoPage() async {
    // ApplicationResult applicationResult2 = (await navigateToNewContactApplicationDetail<ApplicationResult>(
    //     context: context, options: TencentCloudChatContactApplicationInfoData(application: widget.application, applicationResult: applicationResult)))!;
    ContactApplicationResult applicationResult2 = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TencentCloudChatContactApplicationInfo(
                  application: widget.application,
                  applicationResult: applicationResult,
                )));
    safeSetState(() {
      applicationResult = applicationResult2;
    });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return GestureDetector(
        onTap: gotoApplicationInfoPage,
        child: TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => Container(
                  color: colorTheme.backgroundColor,
                  margin: EdgeInsets.only(top: getHeight(16)),
                  padding: EdgeInsets.symmetric(
                    vertical: getHeight(8),
                    horizontal: getWidth(8),
                  ),
                  child: Row(
                    children: [
                      TencentCloudChat.instance.dataInstance.contact.contactBuilder
                          ?.getContactApplicationItemAvatarBuilder(widget.application),
                      TencentCloudChat.instance.dataInstance.contact.contactBuilder
                          ?.getContactApplicationItemContentBuilder(widget.application),
                      TencentCloudChat.instance.dataInstance.contact.contactBuilder
                          ?.getContactApplicationItemButtonBuilder(
                              widget.application, applicationResult, getApplicationResultFromButton)
                    ],
                  ),
                )));
  }
}

class TencentCloudChatContactApplicationItemAvatar extends StatefulWidget {
  final V2TimFriendApplication application;

  const TencentCloudChatContactApplicationItemAvatar({super.key, required this.application});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactApplicationItemAvatarState();
}

class TencentCloudChatContactApplicationItemAvatarState
    extends TencentCloudChatState<TencentCloudChatContactApplicationItemAvatar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: getWidth(8)),
        child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
          scene: TencentCloudChatAvatarScene.contacts,
          imageList: [widget.application.faceUrl],
          width: getSquareSize(40),
          height: getSquareSize(40),
          borderRadius: getSquareSize(29),
        ));
  }
}

class TencentCloudChatContactApplicationItemContent extends StatefulWidget {
  final V2TimFriendApplication application;

  const TencentCloudChatContactApplicationItemContent({super.key, required this.application});

  @override
  State<StatefulWidget> createState() => TencentCloudChatApplicationContentItemState();
}

class TencentCloudChatApplicationContentItemState
    extends TencentCloudChatState<TencentCloudChatContactApplicationItemContent> {
  Widget getAddWording(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    String addwording = "";
    if (widget.application.addWording != null) {
      addwording = widget.application.addWording!;
    }
    Widget w = addwording.isEmpty
        ? Container()
        : Text(
            addwording,
            style: TextStyle(
                color: colorTheme.contactItemTabItemNameColor,
                fontSize: textStyle.fontsize_12,
                fontWeight: FontWeight.w400),
          );
    return w;
  }

  String getName() {
    if (widget.application.nickname != null && widget.application.nickname!.isNotEmpty) {
      return widget.application.nickname ?? "";
    }
    return widget.application.userID;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Expanded(
        child: TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      getName(),
                      style: TextStyle(
                          fontSize: textStyle.fontsize_14,
                          fontWeight: FontWeight.w400,
                          color: colorTheme.contactItemFriendNameColor),
                    ),
                    getAddWording(colorTheme, textStyle)
                  ],
                )));
  }
}

class TencentCloudChatApplicationItemButton extends StatefulWidget {
  final V2TimFriendApplication application;
  final ContactApplicationResult? applicationResult;
  final Function? sendApplicationResult;

  const TencentCloudChatApplicationItemButton(
      {Key? key, required this.application, this.applicationResult, this.sendApplicationResult})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatApplicationItemButtonState();
}

class TencentCloudChatApplicationItemButtonState extends TencentCloudChatState<TencentCloudChatApplicationItemButton> {
  String userID = "";
  bool showButton = true;
  String showName = "";

  onAcceptApplication() async {
    V2TimFriendOperationResult res = await TencentCloudChat.instance.chatSDKInstance.contactSDK.acceptFriendApplication(
        widget.application.userID,
        FriendResponseTypeEnum.V2TIM_FRIEND_ACCEPT_AGREE_AND_ADD,
        FriendApplicationTypeEnum.values[widget.application.type]);
    String id = res.userID ?? "";
    int code = res.resultCode ?? -1;
    if (id == widget.application.userID && code == 0) {
      widget
          .sendApplicationResult!(ContactApplicationResult(result: tL10n.accepted, userID: widget.application.userID));
      safeSetState(() {
        widget.applicationResult?.result = tL10n.accepted;
        widget.applicationResult?.userID = widget.application.userID;
      });
    } else {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent(
          TencentCloudChatComponentsEnum.contact,
          TencentCloudChatUserNotificationEvent(
            eventCode: code,
            text: tL10n.invalidApplication,
          ));
    }

    // After operation, delete the application proactively (IMSDK does not give notification of application deletion in such case)
    TencentCloudChat.instance.dataInstance.contact
        .deleteApplicationList([widget.application.userID], 'onFriendApplicationListDeleted');
  }

  onRefuseApplication() async {
    V2TimFriendOperationResult res = await TencentCloudChat.instance.chatSDKInstance.contactSDK
        .refuseFriendApplication(widget.application.userID, FriendApplicationTypeEnum.values[widget.application.type]);
    String id = res.userID ?? "";
    int code = res.resultCode ?? -1;
    if (id == widget.application.userID && code == 0) {
      widget
          .sendApplicationResult!(ContactApplicationResult(result: tL10n.declined, userID: widget.application.userID));
      safeSetState(() {
        widget.applicationResult?.result = tL10n.declined;
        widget.applicationResult?.userID = widget.application.userID;
      });
    } else {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent(
          TencentCloudChatComponentsEnum.contact,
          TencentCloudChatUserNotificationEvent(
            eventCode: code,
            text: tL10n.invalidApplication,
          ));

      TencentCloudChat.instance.dataInstance.contact
          .deleteApplicationList([widget.application.userID], 'onFriendApplicationListDeleted');
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    if (widget.applicationResult!.userID == widget.application.userID) {
      return TencentCloudChatThemeWidget(
          build: (context, colorTheme, textStyle) => Container(
                padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(5)),
                child: Text(
                  widget.applicationResult!.result,
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
                      tL10n.accept,
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
