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

Upload your iOS APNs push certificate to the Tencent Cloud Chat console and obtain the certificate ID. Call
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

```Swift
import UIKit
import Flutter

// Add these two import lines
import TIMPush
import tencent_cloud_chat_push

// Add `, TIMPushDelegate` to the following line
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, TIMPushDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Add this function
    func offlinePushCertificateID() -> Int32 {
        return TencentCloudChatPushFlutterModal.shared.offlinePushCertificateID();
    }
    
    // Add this function
    func applicationGroupID() -> String {
        return TencentCloudChatPushFlutterModal.shared.applicationGroupID()
    }
    
    // Add this function
    func onRemoteNotificationReceived(_ notice: String?) -> Bool {
        TencentCloudChatPushPlugin.shared.tryNotifyDartOnNotificationClickEvent(notice)
        return true
    }
}
```

#### Android

Create a new `Application` class file in the `android` directory of your project, for
example, `MyApplication.java`. If you have already created a custom `Application` class for other
purposes, you can reuse it without creating a new one.

```java
import com.tencent.chat.flutter.push.tencent_cloud_chat_push.application.TencentCloudChatPushApplication;
public class MyApplication extends TencentCloudChatPushApplication {
    @Override
    public void onCreate() {
        super.onCreate();
    }
}
```

Declare it in `AndroidManifest.xml` file, like:

```xml
<application
        android:name="${Package Name}.MyApplication"
... more
```

### Step 4: Configure push notification providers

#### iOS

No additional configuration is required for iOS in this step.

#### Android

Open the `android/app/build.gradle` file and add the dependencies for the push notification
providers you want to support. You can include all or some of the providers listed below:

```plaintext
dependencies {
     // Huawei
     implementation 'com.tencent.timpush:huawei:${The version of this package}'
     
     // XiaoMi
     implementation 'com.tencent.timpush:xiaomi:${The version of this package}'
     
     // OPPO
     implementation 'com.tencent.timpush:oppo:${The version of this package}'
     
     // vivo
     implementation 'com.tencent.timpush:vivo:${The version of this package}'
     
     // Honor
     implementation 'com.tencent.timpush:honor:${The version of this package}'
     
     // Meizu
     implementation 'com.tencent.timpush:meizu:${The version of this package}'
     
     // Google Firebase Cloud Messaging (Google FCM)
     implementation 'com.tencent.timpush:fcm:${The version of this package}'
}

```

### Step 5: Handle notification click events and parse parameters

Define a function to handle push notification click events. This function should have the following
signature:

```dart
void onNotificationClicked({required String ext, String? userID, String? groupID})
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
successfully logging in to the Tencent Cloud Chat module and before using any other plugins (such as CallKit).
Pass in the click callback function defined in the previous step.

Optionally, you can also pass in the `apnsCertificateID` for iOS and `androidPushOEMConfig` for
Android if needed:

```dart
TencentCloudChatPush().registerPush(onNotificationClicked: _onNotificationClicked);
```

If you have any questions or need further information, feel free to reach out us.

- [Telegram](https://t.me/+gvScYl0uQ3U4MTRl)
- [X (Twitter)](https://x.com/runlin_wang95)
