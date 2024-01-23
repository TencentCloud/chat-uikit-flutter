import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

Widget _floatContainer({
  String? text,
  IconData? iconData,
  bool isLoading = false,
}) {
  final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType ==
      DeviceScreenType.desktop;

  return MouseRegion(
    cursor: isDesktopScreen ? SystemMouseCursors.click : MouseCursor.defer,
    child: TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color: colorTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: colorTheme.dividerColor.withOpacity(0.8),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Row(
          children: [
            if (TencentCloudChatUtils.checkString(text) != null && !isLoading)
              SizedBox(
                height: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15),
                    child: Text(
                      text!,
                      style: TextStyle(color: colorTheme.primaryColor),
                    ),
                  ),
                ),
              ),
            if (iconData != null && !isLoading)
              SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8),
                    child: Icon(
                      iconData,
                      color: colorTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            if (isLoading)
              SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          colorTheme.primaryColor),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget defaultUnreadMsgButtonBuilder(
    BuildContext context, int unreadMsgCount, bool isLoading) {
  return _floatContainer(
      text: tL10n.unreadCount(unreadMsgCount), isLoading: isLoading);
}

Widget defaultMessageMentionedMeBuilder(
    BuildContext context, int messageCount, bool isLoading) {
  return _floatContainer(
      text: tL10n.mentionedMessages(messageCount), isLoading: isLoading);
}

Widget defaultReceivedMsgButtonBuilder(BuildContext context, int newMsgCount) {
  return _floatContainer(text: tL10n.newMsgCount(newMsgCount));
}

Widget defaultScrollToTopButtonBuilder(BuildContext context, bool isLoading) {
  return _floatContainer(
    iconData: Icons.keyboard_double_arrow_down_rounded,
    isLoading: isLoading,
  );
}

Widget defaultLoadPreviousProgressBuilder(
    BuildContext context, LoadStatus? mode, bool haveMorePreviousMessage) {
  Widget body;
  if (!haveMorePreviousMessage) {
    body = Container();
  } else if (mode == LoadStatus.idle) {
    body = Container();
  } else if (mode == LoadStatus.loading) {
    body = const CupertinoActivityIndicator();
  } else if (mode == LoadStatus.canLoading) {
    body = Text(tL10n.releaseToLoadMore);
  } else {
    body = Text(tL10n.noMoreMessage);
  }
  return SizedBox(
    height: haveMorePreviousMessage ? 55.0 : 0,
    child: Center(child: body),
  );
}

Widget defaultUnreadMsgTipBuilder(BuildContext context, int unreadMsgCount) {
  return TencentCloudChatThemeWidget(
    build: (context, colorTheme, textStyle) => Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: SizedBox(
              height: 1,
              width: 100,
              child: Container(
                  decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  colorTheme.primaryColor.withOpacity(0),
                  colorTheme.primaryColor,
                ]),
              )),
            ),
          ),
          Text(
            tL10n.unreadMessagesBelow,
            style: TextStyle(
              fontSize: textStyle.fontsize_12,
              fontWeight: FontWeight.w500,
              color: colorTheme.primaryColor,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 1,
              width: 100,
              child: Container(
                  decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  colorTheme.primaryColor,
                  colorTheme.primaryColor.withOpacity(0),
                ]),
              )),
            ),
          ),
        ],
      ),
    ),
  );
}
