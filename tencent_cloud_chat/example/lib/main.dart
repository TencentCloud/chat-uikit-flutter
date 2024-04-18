import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/widget/app/material_app.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation.dart';
import 'package:tencent_cloud_chat_group_profile/tencent_cloud_chat_group_profile.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message.dart';
import 'package:tencent_cloud_chat_user_profile/tencent_cloud_chat_user_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const TencentCloudChatMaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> pages = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      const TencentCloudChatConversation(),
      const TencentCloudChatContact(),
    ];

    TencentCloudChat.controller.initUIKit(
      options: const TencentCloudChatInitOptions(
        sdkAppID: ,

        /// [Required]: The SDKAppID of your Tencent Cloud Chat application
        userID: "",

        /// [Required]: The userID of the logged-in user
        userSig:
            "",

        /// [Required]: The userSig of the logged-in user
      ),
      components: const TencentCloudChatInitComponentsRelated(
        /// [Required]: The modular UI components related settings, taking effects on a global scale.
        usedComponentsRegister: [
          /// [Required]: List of registration functions for the components used in the Chat UIKit.
          TencentCloudChatConversationManager.register,
          TencentCloudChatMessageManager.register,
          TencentCloudChatUserProfileManager.register,
          TencentCloudChatGroupProfileManager.register,
          TencentCloudChatContactManager.register,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) async {
          if (index != currentIndex) {
            setState(
              () {
                currentIndex = index;
              },
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: "Chats"),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts), label: "Contacts"),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
