import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_contacts.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_group.dart';

enum AddContact { addFriend, addGroup }

class TencentCloudChatContactAppBar extends StatefulWidget {
  final String? title;

  const TencentCloudChatContactAppBar({super.key, this.title});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAppBarState();
}

class TencentCloudChatContactAppBarState extends TencentCloudChatState<TencentCloudChatContactAppBar> {
  @override
  Widget tabletAppBuilder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: desktopBuilder(context),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Column(
        children: [
          TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAppBarNameBuilder(),
          const TencentCloudChatAppBarSearchItem()
        ],
      );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            width: 1,
            color: colorTheme.dividerColor,
          )),
        ),
        padding: EdgeInsets.symmetric(
          vertical: getHeight(11.4),
          horizontal: getWidth(16),
        ),
        child: Column(
          children: [
            TencentCloudChat.instance.dataInstance.contact.contactBuilder?.getContactAppBarNameBuilder(
              title: widget.title,
            ),
            const TencentCloudChatAppBarSearchItem()
          ],
        ),
      ),
    );
  }
}

class TencentCloudChatContactAppBarName extends StatefulWidget {
  final String? title;

  const TencentCloudChatContactAppBarName({super.key, this.title});

  @override
  State<StatefulWidget> createState() => TencentCloudChatContactAppBarNameState();
}

class TencentCloudChatContactAppBarNameState extends TencentCloudChatState<TencentCloudChatContactAppBarName> {
  AddContact? selectedMenu;

  addContacts() {
    showModalBottomSheet<void>(
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return const TencentCloudChatContactAddContacts();
        });
  }

  addGroup() {
    showModalBottomSheet<void>(
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return const TencentCloudChatContactAddGroup();
        });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Row(
        children: [
          Expanded(
              child: Text(widget.title ?? tL10n.contacts,
                  style: TextStyle(
                      color: colorTheme.contactItemFriendNameColor,
                      fontSize: textStyle.fontsize_34,
                      fontWeight: FontWeight.w600))),
          MenuAnchor(
            builder: (BuildContext context, MenuController controller, Widget? child) {
              return IconButton(
                icon: Icon(Icons.maps_ugc_outlined, size: getSquareSize(20), color: colorTheme.contactAppBarIconColor),
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                tooltip: 'Show menu',
              );
            },
            menuChildren: [
              MenuItemButton(onPressed: addContacts, child: Text(tL10n.addContact)),
              MenuItemButton(onPressed: addGroup, child: Text(tL10n.addGroup))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Row(
        children: [
          Expanded(
              child: Text(
            widget.title ?? tL10n.contacts,
            style: TextStyle(
                color: colorTheme.contactItemFriendNameColor,
                fontSize: textStyle.fontsize_24 + 4,
                fontWeight: FontWeight.w600),
          )),
          MenuAnchor(
            builder: (BuildContext context, MenuController controller, Widget? child) {
              return IconButton(
                icon: Icon(Icons.maps_ugc_outlined, size: getSquareSize(20), color: colorTheme.contactAppBarIconColor),
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                tooltip: 'Show menu',
              );
            },
            menuChildren: [
              MenuItemButton(onPressed: addContacts, child: Text(tL10n.addContact)),
              MenuItemButton(onPressed: addGroup, child: Text(tL10n.addGroup))
            ],
          ),
        ],
      ),
    );
  }
}

class TencentCloudChatAppBarSearchItem extends StatefulWidget {
  const TencentCloudChatAppBarSearchItem({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatAppBarSearchItemState();
}

class TencentCloudChatAppBarSearchItemState extends TencentCloudChatState<TencentCloudChatAppBarSearchItem> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Container();
  }
}
