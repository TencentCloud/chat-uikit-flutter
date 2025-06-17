import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';

Widget unreadMsgButtonBuilder(
    VoidCallback triggerDefaultButtonTappedEvent, BuildContext context, int unreadMsgCount, bool isLoading) {
  return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageDynamicButtonBuilder(
            data: MessageDynamicButtonBuilderData(
              text: tL10n.unreadCount(unreadMsgCount),
              isLoading: isLoading,
              eventType: MessageDynamicButtonEventType.navigateToTheLatestReadMessage,
            ),
            methods: MessageDynamicButtonBuilderMethods(
              triggerDefaultButtonTappedEvent: triggerDefaultButtonTappedEvent,
            ),
          ) ??
      Container();
}

Widget messageMentionedMeBuilder(
    VoidCallback triggerDefaultButtonTappedEvent, BuildContext context, int messageCount, bool isLoading) {
  return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageDynamicButtonBuilder(
            data: MessageDynamicButtonBuilderData(
              text: tL10n.mentionedMessages(messageCount),
              isLoading: isLoading,
              eventType: MessageDynamicButtonEventType.navigateToTheLatestMessageMentionedMe,
            ),
            methods: MessageDynamicButtonBuilderMethods(
              triggerDefaultButtonTappedEvent: triggerDefaultButtonTappedEvent,
            ),
          ) ??
      Container();
}

Widget receivedMsgButtonBuilder(VoidCallback triggerDefaultButtonTappedEvent, BuildContext context, int newMsgCount) {
  return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageDynamicButtonBuilder(
            data: MessageDynamicButtonBuilderData(
              text: tL10n.newMsgCount(newMsgCount),
              isLoading: false,
              eventType: MessageDynamicButtonEventType.navigateToTheLatestReceivedMessage,
            ),
            methods: MessageDynamicButtonBuilderMethods(
              triggerDefaultButtonTappedEvent: triggerDefaultButtonTappedEvent,
            ),
          ) ??
      Container();
}

Widget scrollToTopButtonBuilder(VoidCallback triggerDefaultButtonTappedEvent, BuildContext context, bool isLoading) {
  return TencentCloudChatMessageDataProviderInherited.of(context).messageBuilders?.getMessageDynamicButtonBuilder(
            data: MessageDynamicButtonBuilderData(
              iconData: Icons.keyboard_double_arrow_down_rounded,
              isLoading: isLoading,
              eventType: MessageDynamicButtonEventType.navigateToTheBottomOfMessageList,
            ),
            methods: MessageDynamicButtonBuilderMethods(
              triggerDefaultButtonTappedEvent: triggerDefaultButtonTappedEvent,
            ),
          ) ??
      Container();
}

Widget defaultLoadPreviousProgressBuilder(BuildContext context, LoadStatus? mode, bool haveMorePreviousMessage) {
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
