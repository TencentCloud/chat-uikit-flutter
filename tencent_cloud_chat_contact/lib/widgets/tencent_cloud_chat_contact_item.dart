import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';

class TencentCloudChatContactItem extends StatefulWidget {
  final V2TimFriendInfo friend;

  const TencentCloudChatContactItem({super.key, required this.friend});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactItemState();
}

// only avatar and text for now
class TencentCloudChatContactItemState extends TencentCloudChatState<TencentCloudChatContactItem> {
  final isDesktop = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;

  navigateToChat() async {
    final tryUseOnNavigateToChat = await TencentCloudChat.instance.dataInstance.contact.contactEventHandlers?.uiEventHandlers.onNavigateToChat?.call(userID: widget.friend.userID, groupID: null) ?? false;
    if(!tryUseOnNavigateToChat){
      if (TencentCloudChat.instance.dataInstance.basic.usedComponents.contains(TencentCloudChatComponentsEnum.message)) {
        if(!isDesktop){
          navigateToMessage(
            context: context,
            options: TencentCloudChatMessageOptions(
              userID: widget.friend.userID,
              groupID: "",
            ),
          );
        }else{
          final conv = await TencentCloudChat.instance.chatSDKInstance.conversationSDK.getConversation(
            userID: widget.friend.userID,
          );
          TencentCloudChat.instance.dataInstance.conversation.currentConversation = conv;
        }
      }
    }
  }

  Future<void> _copyToxId() async {
    await Clipboard.setData(ClipboardData(text: widget.friend.userID));
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('Tox ID copied'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showDesktopContextMenu(Offset globalPosition) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        overlay == null ? globalPosition.dx : overlay.size.width - globalPosition.dx,
        overlay == null ? globalPosition.dy : overlay.size.height - globalPosition.dy,
      ),
      items: const <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'open',
          child: ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text('Open chat'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem<String>(
          value: 'copy',
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('Copy Tox ID'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
    if (selected == null) return;
    switch (selected) {
      case 'open':
        await navigateToChat();
        break;
      case 'copy':
        await _copyToxId();
        break;
    }
  }

  Future<void> _showMobileContextMenu() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext sheetContext) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              navigateToChat();
            },
            child: const Text('Open chat'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              _copyToxId();
            },
            child: const Text('Copy Tox ID'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetContext),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final platformIsDesktop = TencentCloudChatPlatformAdapter().isDesktop;
    return TencentCloudChatThemeWidget(
      build: (context, color, textStyle) => Material(
        color: color.backgroundColor,
        child: InkWell(
          onTap: navigateToChat,
          onLongPress: platformIsDesktop ? null : _showMobileContextMenu,
          onSecondaryTapDown: platformIsDesktop
              ? (TapDownDetails details) {
                  _showDesktopContextMenu(details.globalPosition);
                }
              : null,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              vertical: getHeight(7),
              horizontal: getWidth(3),
            ),
            child: Row(children: [
              TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactItemAvatarBuilder(widget.friend),
              TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactItemContentBuilder(widget.friend),
              TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactItemElseBuilder(widget.friend),
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
  TencentCloudChatThemeColors colorTheme = TencentCloudChat.instance.dataInstance.theme.colorTheme;

  @override
  Widget defaultBuilder(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(13),
        ),
        child: SizedBox(
          width: getSquareSize(40),
          height: getSquareSize(40),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                  scene: TencentCloudChatAvatarScene.contacts,
                  imageList: [widget.friend.userProfile?.faceUrl],
                  width: getSquareSize(40),
                  height: getSquareSize(40),
                  borderRadius: getSquareSize(34),
                ),
              ),
              if (TencentCloudChat.instance.dataInstance.basic.userConfig.useUserOnlineStatus ?? true)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    width: getSquareSize(10),
                    height: getSquareSize(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: TencentCloudChat.instance.dataInstance.contact.getOnlineStatusByUserId(userID: widget.friend.userID) ?colorTheme.conversationItemUserStatusBgColor : Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            getSquareSize(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ]
          ),
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
