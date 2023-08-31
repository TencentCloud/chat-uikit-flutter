<style>
.button-9 {
  appearance: button;
  backface-visibility: hidden;
  background-color: #1d52d9;
  border-radius: 6px;
  border-width: 0;
  box-shadow: rgba(50, 50, 93, .1) 0 0 0 1px inset,rgba(50, 50, 93, .1) 0 2px 5px 0,rgba(0, 0, 0, .07) 0 1px 1px 0;
  box-sizing: border-box;
  color: #fff;
  cursor: pointer;
  font-family: -apple-system,system-ui,"Segoe UI",Roboto,"Helvetica Neue",Ubuntu,sans-serif;
  font-size: 100%;
  height: 44px;
  line-height: 1.15;
  margin: 12px 0 0;
  outline: none;
  overflow: hidden;
  padding: 0 20px;
  position: relative;
  text-align: center;
  text-transform: none;
  transform: translateZ(0);
  transition: all .2s,box-shadow .08s ease-in;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
}

.button-9:disabled {
  cursor: default;
}

.button-9:focus {
  box-shadow: rgba(50, 50, 93, .1) 0 0 0 1px inset, rgba(50, 50, 93, .2) 0 6px 15px 0, rgba(0, 0, 0, .1) 0 2px 2px 0, rgba(50, 151, 211, .3) 0 0 0 4px;
}

</style>

<br>

<p align="center">
  <a href="https://www.tencentcloud.com/products/im?from=pub">
    <img src="https://qcloudimg.tencent-cloud.cn/raw/429a2f58678a1f5b150c6ae04aa0b569.png" width="320px" alt="Tencent Chat Logo" />
  </a>
</p>

<h1 align="center">Tencent Cloud Chat UIKit</h1>

<br>

<p align="center">
  Globally interconnected In-App Chat, user profile and relationship chains and offline push.
</p>

<br>

<p align="center">
More languages:
  <a href="https://cloud.tencent.com/document/product/269/70747">简体中文-TUIKit介绍</a>
  <a href="https://cloud.tencent.com/document/product/269/70746">简体中文-快速集成</a>
</p>

<br>

![](https://qcloudimg.tencent-cloud.cn/image/document/8fd972397eba8f56c8f294c8b042794c.jpg)

<p align="center">
    TUIKit has Chat SDK, UI components and basic business logic inside. You can choose our pure Chat SDK <a href="https://pub.dev/packages/tencent-cloud-chat-sdk">tencent-cloud-chat-sdk</a> if you tend to build the UI yourself.
</p>

<a target="_blank" href="https://comm.qq.com/im/doc/flutter/en/TUIKit/readme.html"><button type="button" class="button-9" role="button">
Official Documentation</button></a>

<br>

## Check Out Our Sample Apps

Experience our Chat and Voice/Video Call modules by trying out our sample apps.

**These apps have been created using the same Flutter project as our SDKs and extensions.**

| Platform | Link | Remark |
|---------|---------|---------|
| Android / iOS | <img src="https://qcloudimg.tencent-cloud.cn/raw/e791bd503ae267aa51234ad66e347f10.png" width="140px" alt="Tencent Chat Logo" /> | Scan to download app for both Android and iOS. Automatically identifies platform. |
| Web | <img src="https://qcloudimg.tencent-cloud.cn/raw/7908cf6f3c16e4059f8f21229d70a918.png" width="140px" alt="Tencent Chat Logo" /> | Supports both desktop and mobile browsers and automatically adjusts its layout accordingly. Same website as link below. |
| Web | [Visit Now](https://comm.qq.com/flutter/#/) | Supports both desktop and mobile browsers and automatically adjusts its layout accordingly. Same website as previous QR code. |
| macOS | [Download Now](https://comm.qq.com/im_demo_download/macos_flutter.dmg) | The macOS version of our sample app. Control-click the app icon, then choose "Open" from the shortcut menu. |
| Windows | [Download Now](https://comm.qq.com/im_demo_download/windows_flutter.appx) | The Windows version of our sample app, which is a UWP (Universal Windows Platform) application. |
| Linux | Coming Soon... | Will be available later this year. |

**Take a look at the screenshots of
TUIKit [here](https://www.tencentcloud.com/document/product/1047/50059?from=pub) to get an idea of
what to expect.**

## Introduction to TUIKit

Tencent Cloud Chat SDK comes
with [TUIKit](https://www.tencentcloud.com/document/product/1047/50059?from=pub), which is an
official set of UI components that have chat business logic built-in. TUIKit includes components
like conversation, chat, relationship chain, and group.

Developers can use these UI components to quickly and easily add In-APP chat modules to their mobile
applications.

![img](https://qcloudimg.tencent-cloud.cn/raw/f140dd76be01a65abfb7e6ba2bf50ed5.png)

Currently, Flutter [TUIKit](https://www.tencentcloud.com/document/product/1047/50059?from=pub)
contains the following main components:

- [TIMUIKitCore](https://comm.qq.com/im/doc/flutter/en/TUIKit/TIMUIKitCore/readme.html): Core entry
- [TIMUIKitConversation](https://www.tencentcloud.com/document/product/1047/50059?from=pub#timuikitconversation):
  Conversation list
- [TIMUIKitChat](https://www.tencentcloud.com/document/product/1047/50059?from=pub#timuikitchat):
  Chat module, includes historical message list and message sending area, with some other features
  like message reaction and URL preview, etc.
- [TIMUIKitContact](https://www.tencentcloud.com/document/product/1047/50059?from=pub#relationship-chain-components):
  Contacts list
- [TIMUIKitProfile](https://www.tencentcloud.com/document/product/1047/50059?from=pub#timuikitprofile):
  User profile and relationship management
- [TIMUIKitGroupProfile](https://www.tencentcloud.com/document/product/1047/50059?from=pub#timuikitgroupprofile):
  Group profile and management
- [TIMUIKitGroup](https://www.tencentcloud.com/document/product/1047/50059?from=pub#relationship-chain-components):
  The list of group self joined
- [TIMUIKitBlackList](https://www.tencentcloud.com/document/product/1047/50059?from=pub#relationship-chain-components):
  The list of user been blocked
- [TIMUIKitNewContact](https://www.tencentcloud.com/document/product/1047/50059?from=pub#relationship-chain-components):
  New contacts application list
- [TIMUIKitSearch](https://www.tencentcloud.com/document/product/1047/50036?from=pub): Search
  globally
- [TIMUIKitSearchMsgDetail](https://www.tencentcloud.com/document/product/1047/50036?from=pub):
  Search in specific conversation

In addition to these components, there are other useful components and widgets available to help
developers meet their business needs, such as group entry application list and group member list.

For the source code of the project shown in the image above, please refer
to [chat-demo-flutter](https://github.com/TencentCloud/chat-demo-flutter). This project is open
source and can be directly used by developers.

## Compatible Platforms

The platforms are compatible with the deployment of our Chat UIKit.

- Android
- iOS
- Web (version 0.1.4 and later)
- Windows (version 2.0.0 and later)
- macOS (version 2.0.0 and later)

## Get Started

Please refer to [this document](https://www.tencentcloud.com/document/product/1047/45907?from=pub) for a complete and detailed guide on getting started.

## Directions

The following guide describes how to quickly build a simple chat application using Flutter TUIKit.

Refer to the appendix if you want to learn about the details and parameters of each widget.

> If you want to directly add Flutter TUIKit to your existing application, refer to [this document](https://www.tencentcloud.com/document/product/1047/51456). You can add the Flutter module to your existing application, code once, and deploy to all platforms. This can significantly reduce the workload of adding chat and call modules to your existing application.

### Step 0: Create two accounts for testing

Sign up and log in to the [Tencent Cloud Chat console](https://console.tencentcloud.com/im?from=pub).

Create an application and enter it.

Select Auxiliary Tools > UserSig Generation and Verification on the left sidebar. Generate two pairs of "UserID" and the corresponding "UserSig," and copy the "key" information. Refer to [this document](https://www.tencentcloud.com/document/product/1047/34580?from=pub#usersig-generation-and-verification).

Tips: You can create "user1" and "user2" here.

> Note:
>
> The correct way to distribute `UserSig` is to integrate the calculation code for `UserSig` into your server and provide an application-oriented API. When `UserSig` is needed, your application can send a request to the business server for a dynamic `UserSig.` For more information, see [How do I calculate UserSig on the server?](https://www.tencentcloud.com/document/product/1047/34385?from=pub).

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

![](https://qcloudimg.tencent-cloud.cn/raw/a4d25e02c546e0878ba59fcda87f9c76.png)

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

Note: Importing UserSig to your application is only for debugging purposes and cannot be used for the release version. Before publishing your app, you should generate your UserSig from your server. Refer to: <https://www.tencentcloud.com/document/product/1047/34385?from=pub>

## Step 5. Implementing the conversation list page

You can use the conversation (channel) list page as the homepage of your Chat module, which includes all conversations with users and groups that have chat records.

```markdown
![Conversation List Page](https://qcloudimg.tencent-cloud.cn/raw/a27b131d555b1158d150bd9b337c1d9d.png)

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

```markdown
![Chat Page](https://qcloudimg.tencent-cloud.cn/raw/09b8b9b54fd0caa47069544343eba461.jpg)

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

```markdown
![User Profile Page](https://qcloudimg.tencent-cloud.cn/raw/03e88da6f1d63f688d2a8ee446da43ff.png)

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

### Do I need to integrate Chat SDK after integrating TUIKit?

No. You don't need to integrate Chat SDK again. If you want to use Chat SDK related APIs, you can
get them via `TIMUIKitCore.getSDKInstance()`. This method is recommended to ensure Chat SDK version
consistency.

### Why did force quit occur when I sent voice, image, file or other messages?

Check whether you have enabled the **camera**, **mic**, **album**, or other related permissions.

Refers to Step 1 above.

### What should I do if clicking Build And Run for an Android device triggers an error, stating no available device is found?

Check that the device is not occupied by other resources. Alternatively, click Build to generate an
APK package, drag it to the simulator, and run it.

### What should I do if an error occurs during the first run for an iOS device?

If an error occurs after the configuration, click **Product > Clean Build Folder** , clean the
product, and run `pod install` or `flutter run` again.

![](https://qcloudimg.tencent-cloud.cn/raw/d495b2e8be86dac4b430e8f46a15cef4.png)

### What should I do if an error occurs during debugging on a real iOS device when I am wearing an Apple Watch?

![](https://qcloudimg.tencent-cloud.cn/raw/1ffcfe39a18329c86849d7d3b34b9a0e.png)

Turn on Airplane Mode on your Apple Watch, and go to **Settings > Bluetooth** on your iPhone to turn
off Bluetooth.

Restart Xcode (if opened) and run `flutter run` again.

### What should I do when an error occurs on an Android device after TUIKit is imported into the application automatically generated by Flutter?

![](https://qcloudimg.tencent-cloud.cn/raw/d95efdd4ae50f13f38f4c383ca755ae7.png)

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

## Contact Us

Please do not hesitate to contact us in the following place, if you have any further questions or
tend to learn more about the use cases.

- Telegram Group: <https://t.me/+1doS9AUBmndhNGNl>
- WhatsApp Group: <https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A>
- QQ Group: 788910197, chat in Chinese

Our Website: <https://www.tencentcloud.com/products/im?from=pub>
