<p align="center">
  <a href="https://www.tencentcloud.com/products/im?from=pub">
    <img src="https://qcloudimg.tencent-cloud.cn/raw/429a2f58678a1f5b150c6ae04aa0b569.png" width="320px" alt="Tencent Chat Logo" />
  </a>
</p>

<h1 align="center">Tencent Cloud Chat Sample App V2 - Basic</h1>

<br>

<p align="center">
  Showcase our the simplified integration of restructured and redesigned version of UIKit, V2, offering an enhanced development and user experience.
</p>

<br>

<br>

![](https://qcloudimg.tencent-cloud.cn/raw/193ec650f17da6bb33edf5df5d978091.png)

## Notice

This Basic Sample App aims to showcase **a simplified integration process** for Chat UIKit V2. 

If you're interested in exploring **a fully-fledged app** with an extensive range of features, advanced capabilities, and customization options,
please check out [this Repo](https://github.com/TencentCloud/chat-demo-flutter/tree/v2).

## Compatible Platforms

The platforms are compatible with the deployment of our Chat UIKit.

- Android
- iOS
- _Web (Will be supported later)_
- Windows
- macOS

## Environment Requirements

|   | Version                                                                        |
|---------|--------------------------------------------------------------------------------|
| Flutter | Flutter 3.16.0 or later                                                        |
| Android | Android Studio 3.5 or later; devices with Android 4.1 or later for apps        |
| iOS | Xcode 11.0 or later. Ensure that your project has a valid developer signature. |

## Preparation

1. Ensure you have [signed up](https://intl.cloud.tencent.com/document/product/378/17985) for a Tencent Cloud account and completed [identity verification](https://intl.cloud.tencent.com/document/product/378/3629).
2. Follow the instructions in [Creating and Upgrading an Application](https://intl.cloud.tencent.com/document/product/1047/34577) to create an application, and note down the `SDKAppID`.
3. Generate several UserID and UserSig pairs from the Chat Console for subsequent logins. Click **Auxiliary Tools > UserSig Generation & Verification** on the left sidebar.

## Running the sample app

1. Download the source code and install dependencies:

```shell
# Clone the code
git https://github.com/TencentCloud/chat-uikit-flutter.git

# Checkout the 'v2' branch
git checkout v2

# Navigate to the sample app
cd tencent_cloud_chat/example

# Clean the project. Important
flutter clean

# Install dependencies
flutter pub get
```

2. Configure the user info for login.

Open `lib/main.dart`, and specify the `sdkappid`, `userid`, and `usersig` obtained and generated in the previous step 
during the `TencentCloudChat.controller.initUIKit` call.

3. Run the app.

```shell
flutter run
```

## About Tencent Cloud Chat UIKit V2

![uikit.png](https://comm.qq.com/im/static-files/uikit.jpg)

This sample app demonstrates the usage of our restructured and redesigned version of UIKit, V2, which offers an enhanced development and user experience.

The V2 UIKit is designed to provide developers with a comprehensive set of tools to easily create feature-rich chat applications.

Built with a modular approach, it allows you to pick and choose the components you need while keeping your application lightweight and efficient.

The UIKit includes a wide range of capabilities, such as [Conversation List](https://pub.dev/packages/tencent_cloud_chat_conversation), [Message handling](https://pub.dev/packages/tencent_cloud_chat_message),
[Contact lists](https://pub.dev/packages/tencent_cloud_chat_contact), [User](https://pub.dev/packages/tencent_cloud_chat_user_profile) and [Group Profiles](https://pub.dev/packages/tencent_cloud_chat_group_profile), Search functionality, and more.

This sample app showcases each component of our brand-new UIKit.

For more information, [please refer to this documentation](https://www.tencentcloud.com/document/product/1047/58585).
