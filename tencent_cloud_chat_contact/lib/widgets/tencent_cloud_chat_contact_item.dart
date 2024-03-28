import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/components_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact_builders.dart';

class TencentCloudChatContactItem extends StatefulWidget {
  final V2TimFriendInfo friend;

  const TencentCloudChatContactItem({super.key, required this.friend});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactItemState();
}

// only avatar and text for now
class TencentCloudChatContactItemState extends TencentCloudChatState<TencentCloudChatContactItem> {
  final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;

  navigateToChat() {
    if (TencentCloudChat().dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.message)) {
      if (isDesktop) {
        TencentImSDKPlugin.v2TIMManager.emitUIKitEvent(
          UIKitEvent(
            type: "navigateToChat",
            detail: Map<String, dynamic>.from({
              "userID": widget.friend.userID,
              "groupID": null,
            }),
          ),
        );
      } else {
        navigateToMessage(
          context: context,
          options: TencentCloudChatMessageOptions(
            userID: widget.friend.userID,
            groupID: null,
          ),
        );
      }
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, color, textStyle) => Material(
        color: color.backgroundColor,
        child: InkWell(
          onTap: navigateToChat,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              vertical: getHeight(7),
              horizontal: getWidth(3),
            ),
            child: Row(children: [
              TencentCloudChatContactBuilders.getContactItemAvatarBuilder(widget.friend),
              TencentCloudChatContactBuilders.getContactItemContentBuilder(widget.friend),
              TencentCloudChatContactBuilders.getContactItemElseBuilder(widget.friend),
            ]),
          ),
        ),
      ),
    );
  }
}

// Avatar for friend list
class TencentCloudChatContactItemAvatar extends StatefulWidget {
  final V2TimFriendInfo friend;

  const TencentCloudChatContactItemAvatar({super.key, required this.friend});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactItemAvatarState();
}

class TencentCloudChatContactItemAvatarState extends TencentCloudChatState<TencentCloudChatContactItemAvatar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(13),
        ),
        child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
          scene: TencentCloudChatAvatarScene.contacts,
          imageList: [widget.friend.userProfile?.faceUrl ?? "https://comm.qq.com/im/static-files/im-demo/im_virtual_customer.png"],
          width: getSquareSize(40),
          height: getSquareSize(40),
          borderRadius: getSquareSize(34),
        ));
  }
}

class TencentCloudChatContactItemContent extends StatefulWidget {
  final V2TimFriendInfo friend;

  const TencentCloudChatContactItemContent({super.key, required this.friend});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactItemContentState();
}

class TencentCloudChatContactItemContentState extends TencentCloudChatState<TencentCloudChatContactItemContent> {
  _getShowName(V2TimFriendInfo item) {
    final friendRemark = item.friendRemark ?? "";
    final nickName = item.userProfile?.nickName ?? "";
    final userID = item.userID;
    final showName = nickName != "" ? nickName : userID;
    return friendRemark != "" ? friendRemark : showName;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => Text(
              _getShowName(widget.friend),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: textStyle.fontsize_14,
                fontWeight: FontWeight.w400,
                color: colorTheme.contactItemFriendNameColor,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

class TencentCloudChatContactItemElse extends StatefulWidget {
  final V2TimFriendInfo friend;

  const TencentCloudChatContactItemElse({super.key, required this.friend});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactItemElseState();
}

class TencentCloudChatContactItemElseState extends TencentCloudChatState<TencentCloudChatContactItemElse> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Container();
  }
}

class FriendListTag {
  final String tagName;

  FriendListTag({required this.tagName});
}

class TencentCloudChatContactListTag extends StatefulWidget {
  final String tag;

  const TencentCloudChatContactListTag({super.key, required this.tag});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactListTagState();
}

class TencentCloudChatContactListTagState extends TencentCloudChatState<TencentCloudChatContactListTag> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Container(
        height: getSquareSize(40),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 16.0, bottom: 5),
        // color: Color.fromARGB(255, 255, 255, 255),
        alignment: Alignment.bottomLeft,
        child: TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => Text(
                  widget.tag,
                  style: TextStyle(
                    fontSize: textStyle.fontsize_14,
                    fontWeight: FontWeight.w600,
                    color: colorTheme.contactItemFriendNameColor,
                  ),
                )));
  }
}
