import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatConversationAppBar extends StatefulWidget {
  const TencentCloudChatConversationAppBar({super.key});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatConversationAppBarState();
}

class TencentCloudChatConversationAppBarState
    extends TencentCloudChatState<TencentCloudChatConversationAppBar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: getWidth(15)),
      child: const Column(
        children: [
          TencentCloudChatConversationAppBarName(),
          TencentCloudChatAppBarSearchItem()
        ],
      ),
    );
  }
}

class TencentCloudChatConversationAppBarName extends StatefulWidget {
  const TencentCloudChatConversationAppBarName({super.key});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatConversationAppBarNameState();
}

class TencentCloudChatConversationAppBarNameState
    extends TencentCloudChatState<TencentCloudChatConversationAppBarName> {
  addContacts() {}

  newMessage() {}

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Row(
              children: [
                Container(
                  width: getWidth(8),
                ),
                Expanded(
                    child: Text(
                  tL10n.chat,
                  style: TextStyle(
                      color: colorTheme.contactItemFriendNameColor,
                      fontSize: textStyle.fontsize_34,
                      fontWeight: FontWeight.w600),
                )),
                IconButton(
                  icon: Icon(Icons.brightness_medium,
                      color: colorTheme.appBarIconColor),
                  onPressed: () {
                    TencentCloudChat.controller.toggleBrightnessMode();
                  },
                ),
                // IconButton(onPressed: addContacts, icon: Icon(Icons.person_add_alt, size: getSquareSize(20), color: colorTheme.contactAppBarIconColor)),
                // IconButton(onPressed: newMessage, icon: Icon(Icons.maps_ugc_outlined, size: getSquareSize(20), color: colorTheme.contactAppBarIconColor)),
              ],
            ));
  }
}

class TencentCloudChatAppBarSearchItem extends StatefulWidget {
  const TencentCloudChatAppBarSearchItem({super.key});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatAppBarSearchItemState();
}

class TencentCloudChatAppBarSearchItemState
    extends TencentCloudChatState<TencentCloudChatAppBarSearchItem> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Container();
  }
}
