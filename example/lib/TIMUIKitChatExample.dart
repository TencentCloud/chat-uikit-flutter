// ignore_for_file: file_names

import 'package:example/TIMUIKitGroupProfileExample.dart';
import 'package:example/TIMUIKitProfileExample.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class TIMUIKitChatExample extends StatelessWidget {
  final V2TimConversation? selectedConversation;

  const TIMUIKitChatExample({Key? key, this.selectedConversation})
      : super(key: key);

  Widget renderCustomStickerPanel({
    sendTextMessage,
    sendFaceMessage,
    deleteText,
    addCustomEmojiText,
    addText,
    List<CustomEmojiFaceData> defaultCustomEmojiStickerList = const [],
    double? height,
    double? width
  }) {
    final defaultEmojiList =
    defaultCustomEmojiStickerList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
          isEmoji: customEmojiPackage.isEmoji,
          isDefaultEmoji: true,
          stickerList: customEmojiPackage.list
              .asMap()
              .keys
              .map((idx) =>
              CustomSticker(index: idx, name: customEmojiPackage.list[idx]))
              .toList(),
          menuItem: CustomSticker(
            index: 0,
            name: customEmojiPackage.icon,
          ));
    }).toList();
    return StickerPanel(
        sendTextMsg: sendTextMessage,
        sendFaceMsg: (index, data) =>
            sendFaceMessage(index + 1, (data.split("/")[3]).split("@")[0]),
        deleteText: deleteText,
        addText: addText,
        addCustomEmojiText: addCustomEmojiText,
        customStickerPackageList: [
          ...defaultEmojiList,
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return TIMUIKitChat(
      conversation: selectedConversation ??
          V2TimConversation(
              conversationID: "c2c_10040818",
              userID: "10040818",
              showName: "Test Chat",
              type: 1),
      customStickerPanel: renderCustomStickerPanel,
      config: const TIMUIKitChatConfig(
        // 仅供演示，非全部配置项，实际使用中，可只传和默认项不同的参数，无需传入所有开关
        isAllowClickAvatar: true,
        isUseDefaultEmoji: true,
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
