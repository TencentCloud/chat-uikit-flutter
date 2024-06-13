import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_contacts_info.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_group.dart';

class TencentCloudChatContactAddGroupInfo extends StatefulWidget {
  final V2TimGroupInfo groupInfo;

  const TencentCloudChatContactAddGroupInfo({super.key, required this.groupInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddGroupInfoState();
}

class TencentCloudChatContactAddGroupInfoState extends TencentCloudChatState<TencentCloudChatContactAddGroupInfo> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            height: getHeight(775),
            decoration: BoxDecoration(color: colorTheme.contactAddContactInfoBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(getWidth(10)))),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: const TencentCloudChatContactAddContactsInfoAppBar(),
              body: TencentCloudChatContactAddGroupInfoBody(groupInfo: widget.groupInfo),
            )));
  }
}

class TencentCloudChatContactAddGroupInfoBody extends StatefulWidget {
  final V2TimGroupInfo groupInfo;

  const TencentCloudChatContactAddGroupInfoBody({super.key, required this.groupInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAddGroupInfoBodyState();
}

class TencentCloudChatContactAddGroupInfoBodyState extends TencentCloudChatState<TencentCloudChatContactAddGroupInfoBody> {
  String verification = "";

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

  sendAddGroupApplication() {
    if (widget.groupInfo.groupType == "Work") {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent.call(
        TencentCloudChatComponentsEnum.contact,
        TencentCloudChatCodeInfo.cannotSendApplicationToWorkGroup,
      );
    } else if (widget.groupInfo.groupType == "Public") {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent.call(
        TencentCloudChatComponentsEnum.contact,
        TencentCloudChatCodeInfo.groupJoinedPermissionNeeded,
      );
      TencentCloudChat.instance.chatSDKInstance.contactSDK.joinGroup(widget.groupInfo.groupID, verification, widget.groupInfo.groupType as GroupType);
    } else {
      TencentCloudChat.instance.callbacks.onUserNotificationEvent.call(
        TencentCloudChatComponentsEnum.contact,
        TencentCloudChatCodeInfo.groupJoined,
      );
      TencentCloudChat.instance.chatSDKInstance.contactSDK.joinGroup(widget.groupInfo.groupID, verification, widget.groupInfo.groupType as GroupType);
    }
  }

  getVerification(String value) {
    safeSetState(() {
      verification = value;
    });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              color: colorTheme.contactApplicationBackgroundColor,
              child: Center(
                  child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: getHeight(10), horizontal: getWidth(16)),
                    color: colorTheme.contactBackgroundColor,
                    child: Row(
                      children: [
                        TencentCloudChatContactAddGroupListItemAvatar(groupInfo: widget.groupInfo),
                        TencentCloudChatContactAddGroupListItemContent(groupInfo: widget.groupInfo)
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      TencentCloudChatContactAddContactsInfoVerification(onVerificationChanged: getVerification),
                      TencentCloudChatContactAddContactsDetailInfoSendButton(addFriend: sendAddGroupApplication)
                    ],
                  )
                ],
              )),
            ));
  }
}
