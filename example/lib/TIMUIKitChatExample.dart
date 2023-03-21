// ignore_for_file: file_names

import 'package:example/TIMUIKitGroupProfileExample.dart';
import 'package:example/TIMUIKitProfileExample.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class TIMUIKitChatExample extends StatelessWidget {
  final V2TimConversation? selectedConversation;

  const TIMUIKitChatExample({Key? key, this.selectedConversation})
      : super(key: key);

  String? _getConversationID() {
    if(selectedConversation != null){
      return selectedConversation!.type == 1
          ? selectedConversation!.userID
          : selectedConversation!.groupID;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TIMUIKitChat(
      config: const TIMUIKitChatConfig(
        // 仅供演示，非全部配置项，实际使用中，可只传和默认项不同的参数，无需传入所有开关
        isAllowClickAvatar: true,
        isAllowLongPressMessage: true,
        isShowReadingStatus: true,
        isShowGroupReadingStatus: true,
        notificationTitle: "",
        isUseMessageReaction: true,
        groupReadReceiptPermissionList: [
          GroupReceiptAllowType.work,
          GroupReceiptAllowType.meeting,
          GroupReceiptAllowType.public
        ],
      ),
      conversation: selectedConversation ??
          V2TimConversation(
              conversationID: "c2c_10040818",
              userID: "10040818",
              showName: "Test Chat",
              type: 1),
        appBarConfig: AppBar(
          actions: [
          IconButton(
              padding: const EdgeInsets.only(left: 8, right: 16),
              onPressed: () async {
                final conversationType = selectedConversation?.type ?? 1;

                if (conversationType == 1) {
                  final String? userID = selectedConversation?.userID;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: Text(userID ?? "User Profile")),
                            body: TIMUIKitProfileExample(userID: userID)),
                      ));
                } else {
                  final String? groupID = selectedConversation?.groupID;
                  if (groupID != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                              appBar: AppBar(title: Text(groupID)),
                              body: TIMUIKitGroupProfileExample(
                            groupID: groupID,
                          )),
                        ));
                  }
                }
              },
              icon: Image.asset(
                'images/more.png',
                package: 'tencent_cloud_chat_uikit',
                  height: 34,
                  width: 34,
                ))
          ],
        ),
    );
  }
}
