import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';

class TencentCloudChatGroupProfileMemberInfo extends StatefulWidget {
  final V2TimGroupMemberFullInfo memberFullInfo;

  const TencentCloudChatGroupProfileMemberInfo({super.key, required this.memberFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfileMemberInfoState();
}

class TencentCloudChatGroupProfileMemberInfoState extends TencentCloudChatState<TencentCloudChatGroupProfileMemberInfo> {
  _getShowName() {
    String name = TencentCloudChatUtils.checkString(widget.memberFullInfo.nameCard) ?? widget.memberFullInfo.nickName ?? widget.memberFullInfo.userID;
    return name;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
            appBar: AppBar(
              title: Text(
                _getShowName(),
                style: const TextStyle(fontSize: 17),
              ),
              centerTitle: true,
            ),
            body: TencentCloudChatGroupProfileMemberInfoBody(
              memberFullInfo: widget.memberFullInfo,
            )));
  }
}

class TencentCloudChatGroupProfileMemberInfoBody extends StatefulWidget {
  final V2TimGroupMemberFullInfo memberFullInfo;

  const TencentCloudChatGroupProfileMemberInfoBody({super.key, required this.memberFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatGroupProfileMemberInfoBodyState();
}

class TencentCloudChatGroupProfileMemberInfoBodyState extends TencentCloudChatState<TencentCloudChatGroupProfileMemberInfoBody> {
  _getShowName() {
    String name = TencentCloudChatUtils.checkString(widget.memberFullInfo.nameCard) ?? widget.memberFullInfo.nickName ?? widget.memberFullInfo.userID;
    return name;
  }

  _getGroupRole() {
    String role = tL10n.groupMember;
    switch (widget.memberFullInfo.role) {
      case 2:
        role = tL10n.admin;
        break;
      case 3:
        role = tL10n.groupOwner;
        break;
      default:
        role = tL10n.groupMember;
        break;
    }
    return role;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Center(
              child: ListView(
                children: [
                  SizedBox(
                    height: getHeight(40),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                        scene: TencentCloudChatAvatarScene.groupProfile,
                        imageList: [TencentCloudChatUtils.checkString(widget.memberFullInfo.faceUrl)],
                        width: getSquareSize(94),
                        height: getSquareSize(94),
                        borderRadius: getSquareSize(48),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(getSquareSize(16)),
                    child: Column(
                      children: [
                        Text(
                          _getShowName(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: textStyle.fontsize_24, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "ID: ${widget.memberFullInfo.userID}",
                          style: TextStyle(fontSize: textStyle.fontsize_12),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(12)),
                        width: MediaQuery.of(context).size.width,
                        color: colorTheme.groupProfileTabBackground,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(tL10n.myAliasInGroup, style: TextStyle(color: colorTheme.groupProfileTabTextColor, fontSize: textStyle.fontsize_16)),
                            ),
                            Text(_getGroupRole(), style: TextStyle(color: colorTheme.groupProfileTextColor, fontSize: textStyle.fontsize_16))
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(12)),
                        width: MediaQuery.of(context).size.width,
                        color: colorTheme.groupProfileTabBackground,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Joined time", style: TextStyle(color: colorTheme.groupProfileTabTextColor, fontSize: textStyle.fontsize_16)),
                            ),
                            Text(DateTime.fromMicrosecondsSinceEpoch(widget.memberFullInfo.joinTime ?? 0).toString(), style: TextStyle(color: colorTheme.groupProfileTextColor, fontSize: textStyle.fontsize_16))
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
  }
}
