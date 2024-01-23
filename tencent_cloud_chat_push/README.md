# Tencent Cloud Chat Push Plugin

The `tencent_cloud_chat_push` plugin is a Flutter plugin that enables developers to integrate push
notifications for their Flutter applications. This plugin supports both iOS and Android platforms
and allows for seamless integration with various native push notification providers, such as Huawei,
Xiaomi, OPPO, Vivo, Honor, Meizu, and Google Firebase Cloud Messaging (FCM).

## Features

- Easy integration with native push notification providers for both iOS and Android
- Automatic handling of push notification events, such as receiving notifications and clicking on
  notifications
- Customizable push notification handling through user-defined callback functions

## Getting Started

### Step 1: Add the plugin to your project

To add the `tencent_cloud_chat_push` plugin to your Flutter project, include it as a dependency in
your `pubspec.yaml` file or run the following command:

```bash
flutter pub add tencent_cloud_chat_push
```

### Step 2: Configure push notification parameters

#### iOS

Upload your iOS APNs push certificate to the IM console and obtain the certificate ID. Call
the `TencentCloudChatPush().setApnsCertificateID` method as early as possible in your app's
lifecycle and pass in the certificate ID:

```plaintext
TencentCloudChatPush().setApnsCertificateID(apnsCertificateID: CertificateID);
```

#### Android

After completing the push notification provider configuration in the console, download
the `timpush-configs.json` file and add it to the `android/app/src/main/assets` directory of your
project. If the directory does not exist, create it manually.

### Step 3: Configure client-side code

In this step, you will need to write some native code, such as Swift, Java, and XML. Follow the
instructions provided and copy the provided code snippets to the specified files.

#### iOS

Edit the `ios/Runner/AppDelegate.swift` file and paste the provided code snippet as shown in the
example.

#### Android

Create a new `Application` class file in the `android` directory of your project, for
example, `MyApplication.java`. If you have already created a custom `Application` class for other
purposes, you can reuse it without creating a new one.

### Step 4: Configure push notification providers

#### iOS

No additional configuration is required for iOS in this step.

#### Android

Open the `android/app/build.gradle` file and add the dependencies for the push notification
providers you want to support. You can include all or some of the providers listed below:

```plaintext
dependencies {
    // Huawei
    implementation 'com.tencent.testaar:huawei:1.2.1'

    // XiaoMi
    implementation 'com.tencent.testaar:xiaomi:1.2.1'

    // OPPO
    implementation 'com.tencent.testaar:oppo:1.2.1'

    // Vivo
    implementation 'com.tencent.testaar:vivo:1.2.1'

    // Honor
    implementation 'com.tencent.testaar:honor:1.2.1'

    // Meizu
    implementation 'com.tencent.testaar:meizu:1.2.1'

    // Google Firebase Cloud Messaging (Google FCM)
    implementation 'com.tencent.testaar:fcm:1.2.1'
}
```

### Step 5: Handle notification click events and parse parameters

Define a function to handle push notification click events. This function should have the following
signature:

```dart
void onNotificationClicked
(
{
required
String
ext, String? userID, String? groupID})
```

The `ext` parameter contains the full ext information for the message, as specified by the sender.
If not specified, a default value will be used. You can parse this parameter to navigate to the
corresponding page.

The `userID` and `groupID` parameters are automatically parsed from the ext JSON string by the
plugin, containing the userID of the chat partner and the groupID of the group chat, respectively.
If the default ext field is used (specified by the SDK or UIKit), you can use these default values.
If parsing fails, they will be null.

### Step 6: Register the push plugin

Register the push plugin by calling the `TencentCloudChatPush().registerPush` method after
successfully logging in to the IM module and before using any other plugins (such as CallKit). Pass
in the click callback function defined in the previous step.

Optionally, you can also pass in the `apnsCertificateID` for iOS and `androidPushOEMConfig` for
Android if needed:

```dart
TencentCloudChatPush
().registerPush
(
onNotificationClicked
:
_onNotificationClicked
);
```
