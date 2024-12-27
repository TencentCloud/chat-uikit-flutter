## 8.3.6498+1

* To resolve the issue of the main function being initialized twice

## 8.3.6498

* Add a notification bar click event listener method onNotificationClicked.
* Add a method createNotificationChannel to support creating notification channels.

## 8.2.6325

* Add support for the feature of non-persistent push messages.
* FCM supports custom redirection upon clicking the notification bar.
* Optimize the log printing functionality before registering for push notifications.

## 8.1.6907

* Resolve database concurrency issues.

## 8.1.6906

* Resolve the issue of Push user login type error.
* Fix the issue where APNs fails to receive push notifications due to proxy failure.
* Optimize the issue where APNs offline pass-through messages with an empty Ext do not trigger the click event callback.
* Resolve the issue of abnormal callback when parsing notifications in the foreground state for APNs.
* Optimize the issue of FCM data empty message pop-up.

## 8.1.6107

* Upgrade under layer Push SDK to 8.1.

## 8.0.6897

* Added `setXiaoMiPushStorageRegion` method for XiaoMi devices.
* Enhanced `registerPush` on Android devices by adding result return.
* Replaced `androidPushOEMConfig` setting for `registerPush` method with `setAndroidCustomConfigFile` method.
* Renamed `setAndroidCustomTIMPushConfigs` and `configFCMPrivateRing` to `setAndroidCustomConfigFile` and `setCustomFCMRing`, respectively.
* Introduced smart detection for available channel strategies.
* Implemented push registration timeout protection mechanism.
* Fixed issues with small icon settings.
* Resolved app launch failure when jump option configuration was set to the home page.
* Refined device model recognition logic.
* Boosted code stability and optimization.

## 7.9.5668+1

* Fixed an issue that may throw an exception during the `registerPush` process.
* Downgraded the minimum supported Flutter version to `flutter: '>=2.10.0'`.
* Fixed an issue that may cause an exception for FCM launching processes.

## 7.9.5668
* Implemented additional enhancements to our Native Push Plugin in version 7.9.5668.
* Fixed several bugs.

## 7.8.5484

* Introduced `registerOnAppWakeUpEvent` function to enable registering a listener when the app is activated due to a Google FCM high-priority background message, ensuring efficient handling of critical notifications.
* Lowered the minimum supported iOS version to iOS 11.
* Enhanced the `registerPush` and `unRegisterPush` processes for better performance.
* Implemented additional enhancements to our Native Push Plugin in version 7.8.5484.
* Fixed various bugs.

## 7.7.5283

* Introduced `setAndroidPushToken` and `getAndroidPushToken` methods for Android devices.
* Implemented `setAndroidCustomTIMPushConfigs` for Android devices, allowing customization of the
  push configuration file.
* Upgraded Push SDK version for Honor devices.
* Incorporated additional improvements in our Native Push Plugin for version 7.7.5283.

## 1.0.0

* First release of Tencent Cloud Chat Push Plug-in for Flutter.