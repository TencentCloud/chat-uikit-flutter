# It is recommended to download the source code from [pub.dev](https://pub.dev/packages/tencent_cloud_chat_uikit/versions)

## Product Introduction
You only need to integrate Chat SDK to easily gain chat, conversation, group capabilities, and you can also communicate with other products such as whiteboards through signaling messages. Chat can cover various business scenarios, support the access and use of various platforms, and fully meet the communication needs.

## Check Out Our Sample Apps
This document introduces how to quickly run the Chat demo on the iOS platform.
[<img src="https://im.sdk.qcloud.com/tools/resource/GitHubResource/build_flutter_chat_app.png" width="800"/>](https://www.youtube.com/watch?v=lawzmfW9vls)

For the other platforms, please refer to document：
- [**chat-uikit-android**](https://github.com/TencentCloud/chat-uikit-android)
- [**chat-uikit-ios**](https://github.com/TencentCloud/chat-uikit-ios)
- [**chat-uikit-vue**](https://github.com/TencentCloud/chat-uikit-vue)
- [**chat-uikit-react**](https://github.com/TencentCloud/chat-uikit-react)
- [**chat-uikit-uniapp**](https://github.com/TencentCloud/chat-uikit-uniapp)
- [**chat-uikit-wechat**](https://github.com/TencentCloud/chat-uikit-wechat)
  
## Introduction to TUIKit
Chat SDK comes with TUIKit, which is an official set of UI components that have chat business logic built-in. TUIKit includes components like conversation, chat, relationship chain, and group.
See [TUIKit Library Overview](https://trtc.io/document/50059?platform=flutter&product=chat&menulabel=uikit) for more details.

Developers can use these UI components to quickly and easily add In-APP chat modules to their mobile applications.
<img src="https://qcloudimg.tencent-cloud.cn/raw/f140dd76be01a65abfb7e6ba2bf50ed5.png" width="1000"/>

Currently, Flutter TUIKit
contains the following main components:

- TIMUIKitCore: Core entry
- TIMUIKitConversation: Conversation list
- TIMUIKitChat: Chat module, includes historical message list and message sending area, with some other features
  like message reaction and URL preview, etc.
- TIMUIKitContact: Contacts list
- TIMUIKitProfile: User profile and relationship management
- TIMUIKitGroupProfile: Group profile and management
- TIMUIKitGroup: The list of group self joined
- TIMUIKitBlackList: The list of user been blocked
- TIMUIKitNewContact: New contacts application list
- TIMUIKitSearch: Search globally
- TIMUIKitSearchMsgDetail: Search in specific conversation

In addition to these components, there are other useful components and widgets available to help
developers meet their business needs, such as group entry application list and group member list.

## Compatible Platforms

The platforms are compatible with the deployment of our Chat UIKit.

- Android
- iOS
- Web (version 0.1.4 and later)
- Windows (version 2.0.0 and later)
- macOS (version 2.0.0 and later)

## Get Started

Please refer to [Run Demo](https://trtc.io/document/45907?platform=flutter&product=chat&menulabel=uikit) for a complete and detailed guide on getting started.

## Directions

The following guide describes how to quickly build a simple chat application using Flutter TUIKit.
Refer to the appendix if you want to learn about the details and parameters of each widget.

### Step 0: Create two accounts for testing

Sign up and log in to the [Chat console](https://console.trtc.io/).

Create an application and enter it. Click Users and create two accounts.

> The correct way to distribute `UserSig` is to integrate the calculation code for `UserSig` into your server and provide an application-oriented API. When `UserSig` is needed, your application can send a request to the business server for a dynamic `UserSig.` For more information, see [How do I calculate UserSig on the server?](https://trtc.io/document/34385?product=chat&menulabel=serverapis).

### Step 1: Create a Flutter app and add permission configuration

Create a Flutter app quickly by following the [Flutter documentation](https://docs.flutter.dev/get-started/install).

TUIKit needs the permissions of shooting/album/recording/network for basic messaging functions. You need to declare these permissions manually to use the relevant capabilities normally.

#### Android

Open `android/app/src/main/AndroidManifest.xml` and add the following lines between `<manifest>` and `</manifest>`.

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
```

#### iOS

Open `ios/Podfile` and add the following lines to the end of the file.

```pod
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
            config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
        end
    target.build_configurations.each do |config|
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
            '$(inherited)',
            'PERMISSION_MICROPHONE=1',
            'PERMISSION_CAMERA=1',
            'PERMISSION_PHOTOS=1',
          ]
        end
  end
end
```

### Step 2: Install dependencies

Add `tencent_cloud_chat_uikit` under `dependencies` in the `pubspec.yaml` file, or run the following command:

```shell
flutter pub add tencent_cloud_chat_uikit
```

It supports Android and iOS by default. If you also want to use it on the web, refer to the following guide.

#### Web Support

Version 0.1.4 or later is required to support web.

If your existing Flutter project does not support web, run `flutter create .` in the project root directory to add web support.

Install JavaScript dependencies to `web/` using `npm` or `yarn`.

```shell
cd web

npm init

npm i tim-js-sdk

npm i tim-upload-plugin
```

Open `web/index.html` and add the following two lines between `<head>` and `</head>` to import them.

```html
<script src="./node_modules/tim-upload-plugin/index.js"></script>
<script src="./node_modules/tim-js-sdk/tim-js-friendship.js"></script>
```

<img src="https://qcloudimg.tencent-cloud.cn/raw/a4d25e02c546e0878ba59fcda87f9c76.png" width="800"/>


### Step 3: Initialize TUIKit

Initialize TUIKit when your app starts. You only need to perform the initialization once for the project to start.

Get the instance of TUIKit first using `TIMUIKitCore.getInstance()`, followed by initializing it with your `sdkAppID`.

```dart
/// main.dart
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

@override
void initState() {
  _coreInstance.init(
      sdkAppID: 0, // Replace 0 with the SDKAppID of your Tencent Cloud Chat application
      loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
      listener: V2TimSDKListener());
  super.initState();
}}
```

> **You may also want to register a callback function for `onTUIKitCallbackListener` here. Refer to the appendix.**

### Step 4: Get the signature and log in

You can now log in one of the testing accounts generated in Step 0 to start the Tencent Cloud Chat module.

Log in using `_coreInstance.login`.

```dart
/// main.dart
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
_coreInstance.login(userID: userID, userSig: userSig);
```

Note: Importing UserSig to your application is only for debugging purposes and cannot be used for the release version. Before publishing your app, you should generate your UserSig from your server. Refer to: [Generate Signature](https://trtc.io/document/34385?product=chat&menulabel=serverapis).

## Step 5. Implementing the conversation list page

You can use the conversation (channel) list page as the homepage of your Chat module, which includes all conversations with users and groups that have chat records.

<img src="https://qcloudimg.tencent-cloud.cn/raw/a27b131d555b1158d150bd9b337c1d9d.png" width="300"/>

You can create a `Conversation` class, with `TIMUIKitConversation` as its body, to render the conversation list. You only need to provide the `onTapItem` callback, which allows users to navigate to the Chat page for each conversation. In the next step, we'll introduce the `Chat` class.

```dart
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class Conversation extends StatelessWidget {
  const Conversation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Message",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: TIMUIKitConversation(
        onTapItem: (selectedConv) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Chat(
                      selectedConversation: selectedConv,
                    ),
              ));
        },
      ),
    );
  }
}
```
## Step 6. Implementing the chat page

The chat page consists of the main message list and a message sending bar at the bottom.

<img src="https://qcloudimg.tencent-cloud.cn/raw/09b8b9b54fd0caa47069544343eba461.jpg" width="600"/>

You can create a `Chat` class, with `TIMUIKitChat` as its body, to render the chat page. We recommend providing an `onTapAvatar` callback function to navigate to the profile page for the current contact, which we'll introduce in the next step.

```dart
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class Chat extends StatelessWidget {
  final V2TimConversation selectedConversation;

  const Chat({Key? key, required this.selectedConversation}) : super(key: key);

  String? _getConvID() {
    return selectedConversation.type == 1
        ? selectedConversation.userID
        : selectedConversation.groupID;
  }

  @override
  Widget build(BuildContext context) {
    return TIMUIKitChat(
      conversationID: _getConvID() ?? '', 
      conversationType: selectedConversation.type ?? 1, 
      conversationShowName: selectedConversation.showName ?? "", 
      onTapAvatar: (_) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(userID: userID),
            ));
      }, 
    );
  }
```
## Step 7. Implementing the user profile page

This page shows the profile of a specific user and maintains the relationship between the current logged-in user and the other user.

<img src="https://qcloudimg.tencent-cloud.cn/raw/03e88da6f1d63f688d2a8ee446da43ff.png" width="600"/>

You can create a `UserProfile` class, with `TIMUIKitProfile` as its body, to render the user profile page.

The only parameter you have to provide is `userID`, while this component automatically generates the profile and relationship maintenance page based on the existence of friendship.

> **TIP**: Please use `profileWidgetBuilder` first to customize some profile widgets and determine their vertical sequence using `profileWidgetsOrder` if you want to customize this page. If this method cannot meet your business needs, you may consider using `builder` instead.

```dart
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class UserProfile extends StatelessWidget {
  final String userID;

  const UserProfile({required this.userID, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Message",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: TIMUIKitProfile(
        userID: widget.userID,
      ),
    );
  }
}
```

Now your app can send and receive messages, display the conversation list, and manage contact friendships. You can use other components from TUIKit to quickly and easily implement the complete Chat module.

## FAQs

#### Do I need to integrate Chat SDK after integrating TUIKit?

No. You don't need to integrate Chat SDK again. If you want to use Chat SDK related APIs, you can
get them via `TIMUIKitCore.getSDKInstance()`. This method is recommended to ensure Chat SDK version
consistency.

#### Why did force quit occur when I sent voice, image, file or other messages?

Check whether you have enabled the **camera**, **mic**, **album**, or other related permissions.

Refers to Step 1 above.

#### What should I do if clicking Build And Run for an Android device triggers an error, stating no available device is found?

Check that the device is not occupied by other resources. Alternatively, click Build to generate an
APK package, drag it to the simulator, and run it.

#### What should I do if an error occurs during the first run for an iOS device?

If an error occurs after the configuration, click **Product > Clean Build Folder** , clean the
product, and run `pod install` or `flutter run` again.
<img src="https://qcloudimg.tencent-cloud.cn/raw/d495b2e8be86dac4b430e8f46a15cef4.png" width="800"/>

#### What should I do if an error occurs during debugging on a real iOS device when I am wearing an Apple Watch?
<img src="https://qcloudimg.tencent-cloud.cn/raw/1ffcfe39a18329c86849d7d3b34b9a0e.png" width="800"/>

Turn on Airplane Mode on your Apple Watch, and go to **Settings > Bluetooth** on your iPhone to turn
off Bluetooth.

Restart Xcode (if opened) and run `flutter run` again.

#### What should I do when an error occurs on an Android device after TUIKit is imported into the application automatically generated by Flutter?
<img src="https://qcloudimg.tencent-cloud.cn/raw/d95efdd4ae50f13f38f4c383ca755ae7.png" width="800"/>

1. Open `android\app\src\main\AndroidManifest.xml` and
   complete `xmlns:tools="http://schemas.android.com/tools" / android:label="@string/android_label" / tools:replace="android:label"`
   as follows.

```xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="Replace it with your Android package name"
    xmlns:tools="http://schemas.android.com/tools">
    <application android:label="@string/android_label" tools:replace="android:label"
        android:icon="@mipmap/ic_launcher"
    // Specify an icon path
    android:usesCleartextTraffic="true"
    android:requestLegacyExternalStorage="true">
```

2. Open `android\app\build.gradle` and complete `minSdkVersion` and `targetSdkVersion`
   in `defaultConfig`.

```gradle
defaultConfig {
  applicationId "" // Replace it with your Android package name
  minSdkVersion 21
  targetSdkVersion 30
}
```

---

## Recommended Resources

For those who require real-time voice and video call capabilities alongside our Chat UIKit, 
we highly recommend our dedicated voice and video call UI component package, [tencent\_calls\_uikit](https://pub.dev/packages/tencent_calls_uikit).
This robust and feature-rich package is specifically designed to complement our existing solution and seamlessly integrate with it, 
providing a comprehensive, unified communication experience for your users.
