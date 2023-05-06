## 2.0.0

If you are upgrading from version 1.7.0, please refer to the changelog of all 2.0.0-preview versions, ranging from preview.1 to preview.7.

The main feature of this new 2.0.0 version is Desktop Support. Tencent Cloud Chat UIKit now supports all platforms, including iOS, Android, Web, Windows, and macOS, which has resulted in significant changes to the codebase. The UI has been improved to adapt to screens of various widths, with different layouts for both wide and narrow screens.

In addition, there are some significant changes compared to version 2.0.0-preview.7.

### New Features

* Added drag and drop support for multiple files in `TIMUIKitChat`, allowing direct sending.
* Introduced functionality to open files or their containing folder (using `Finder` on `macOS` or `Explorer` on `Windows`) for file messages via the message operation tooltip menu on desktop.
* Implemented text selection and copying in messages on desktop.
* Added group joining application processing on Desktop.
* Introduced `isAutoReportRead` to `TIMUIKitChatConfig` for controlling read status reporting.

### Improvements

* Enhanced group members selection panel for mentioning someone in a group chat.
* Refined image display ratio on Desktop.
* The Reply or Quote button is now labeled as `Reply` when `isAtWhenReply` is set to true, and `Quote` otherwise.
* @ member tags can now be deleted at once.

### Bug Fixes

* Fixed UI layout issue causing the `translate` button to display on two lines.
* Addressed an issue causing the mute status not to change when switching to another conversation.
* Fixed several issues causing bugs when opening files.
* Resolved an issue causing secondary confirmation modal UI layout to be over-width on Desktop.
* Fixed an issue causing UI layout errors on the profile page.
* Addressed an issue where the `chatMessageItemFromSelfBgColor` configuration did not work.
* Fixed an issue preventing files from being opened when the path contained Chinese characters on Windows.
* Resolved an issue preventing images from being pasted and sent directly with Ctrl + V on Windows.
* Fixed an issue causing errors in the muting members list.

## 2.0.0-preview.7

### New Features

* Added `additionalMessageToolTips` to `ToolTipsConfig`. This new property allows developers to add additional message operation tooltip items, apart from the default ones. The previous `additionalItemBuilder` has been replaced by this new property. With `additionalMessageToolTips`, developers only need to specify the data for the tooltip items, rather than providing a whole widget. This makes usage easier, as you no longer need to worry about the UI display.
* Added `isPreloadMessagesAfterInit` to `TIMUIKitConfig`, allows determines whether TUIKit should preload some messages after initialization for faster message display.

### Improvements

* Message operation menu shows when long-pressing messages will not show if nothing operation item includes and do not use message sticker reaction module.
* Renamed `desktopMessageHoverBar` to `additionalDesktopMessageHoverBarItem` in `TIMUIKitChatConfig` to control only the addition of extra operation items displayed on the hover bar of messages on desktop (macOS, Windows, and desktop version of Web), without affecting the default ones. Previously, it controlled the entire message hover bar, including covering the default items.
* Renamed `showWideScreenModalFunc` to `showDesktopModalFunc` in `TIMUIKitConfig` for better clarity.
* Upgraded several dependencies to their latest versions, including `ffi` to ^2.0.1, `file_picker` to ^5.2.9 and `device_info_plus` to ^8.2.0.
* Added support for the new permission authorization schema on Android 13 and `targetSdkVersion` greater than 33.
* Corrected the `textHight` to `textHeight` in `TIMUIKitChatConfig`, and modified the default value to 1.3.

### Bug Fixes

* Fixed an issue where the `showVideoCall` and `showVoiceCall` configuration options were not working.
* Fixed potential `Windows` platform deployment prohibition issue.
* Fixed an issue that may cause `setLocalCustomData` to be triggered repeatedly.

## 2.0.0-preview.6

### Improvements

* Permission requests now feature a gray translucent overlay for secondary confirmations on first-time requests, which was reintroduced after being removed in version 2.0.0-preview.4. Additionally, the overlay can now be successfully hidden once the permission authorization is complete.".
* Time Divider on Message List: The default 12-hour display has been changed to a 24-hour display.
* Message translation now targets the language of TUIKit instead of relying on the system language directly. The language of TUIKit can be set as the system language automatically or defined by the user. For more information, please refer to this documentation: https://www.tencentcloud.com/document/product/1047/52154.
* Optimized the animation for message text input area.

### Bug Fixes

* Fixed an issue where the `Voice Call` and `Video Call` buttons were not working in group chat.
* Fixed several null-safety issues.
* Fixed a layout problem for the message operation menu when not using the message sticker reaction module.
* Addressed a problem where the time ago display was not correct on the conversation item.
* Fixed an issue where stickers could not be clicked in some cases.
* Resolved an overflow error that occurred when opening the sticker panel.

## 2.0.0-preview.5

### New Features

* New Chat Configuration: `isAllowLongPressAvatarToAt`. This option controls whether users are allowed to mention another user in the group by long-pressing on their avatar.

### Improvements

* Improved tool bar configuration on desktop: The tool bar can now be customized using `desktopControlBarConfig` for embedded default items and `additionalDesktopControlBarItems` for additional tool items. These configurations come from TIMUIKitChatConfig.
* Renamed the `wideMessageHoverBar` configuration option to `desktopMessageHoverBar` for better clarity.
* Eliminated the dependency on `fluttertoast`. All necessary customer reminders are now triggered through the `onTUIKitCallbackListener` info callback in your project. For more information, please see: https://www.tencentcloud.com/document/product/1047/50054#how-do-i-get-an-api-call-error.2Fflutter-layer-error.2Fpop-up-prompt-message.3F.3Ca-id.3D.22callback.22.3E.3C.2Fa.3E.
* Eliminated other six unnecessary dependency packages to reduce the size and improve performance.
* Improved the clarity of the `sendMessage` function in `TIMUIKitChatController` by replacing the use of `convID` to represent both `userID` and `groupID` with separate parameters.

### Bug Fixes

* Fixed an issue where the message operation menu may show inaccurately when the message is too long.
* Fixed a problem where the message operation menu had the potential to be too wide for certain types of messages, causing display issues.
* Corrected an issue where the button to remove group members was not functioning correctly.
* Addressed a problem where the message item could exceed the pixel limit and appear too wide.
* Fixed a bug where certain JSON decoding operations could potentially fail.
* Fixed an issue with sound messages on iOS devices playing only through earpiece instead of speaker by default.

## 2.0.0-preview.4

### New Features

* New Chat Configuration: `TIMUIKitChatConfig` now includes `offlinePushInfo`, which allows for customization of the entire `offlinePushInfo` for each message. This field has a higher priority than the previous separate configuration fields for this object.
* New Color Configuration: Added `appbarTextColor` and `appbarBgColor` to configure the color for the Appbar. Also added `selectPanelBgColor` and `selectPanelTextIconColor` to configure the color of the messages multi-select panel.

### Improvements

* Improved Group Management: Muting members on Work Group is now not allowed.
* Improved Avatar: Ensured that the avatar can be as small as possible while still covering the entire target box.
* Permission Requests: Removed the gray translucent overlay for secondary confirmations on first-time permission requests.

### Bug Fixes

* Fixed an issue where the color defined by `chatBgColor` could not cover the entire chat screen when messages did not cover the whole page.
* Fixed an issue where the history message list could not be scrolled in some cases.
* Fixed an issue where the ratio of sending messages was incorrect, resulting in the wrong position of the read status label on the left.
* Fixed an issue where loading messages could fail when the number of messages equaled the specified count.

## 2.0.0-preview.3

### New Features

* Integrated Callkit: The Calls button no longer needs to be added to `MorePanelConfig`. If `tencent_calls_uikit` is installed, the Video Call and Voice Call buttons will be displayed automatically.
* Paste Images on Desktop: Users can now paste an image on the text field on Desktop to send it.
* Screenshot Capture on Desktop: Users can now capture a screenshot on Desktop and send it.

### Improvements

* Improved Compatibility: The TUIKit is now compatible with Flutter versions 3.0.0 to 3.7.7.

### Bug Fixes

* Fixed an issue where the `businessID` type may not be correct.
* Fixed an issue where the `chatMessageItemFromSelfBgColor` configuration was not taking effect.

## 2.0.0-preview.2

### New Features

* Added support for opening files locally from file messages.

## 2.0.0-preview.1

### New Features

* Desktop Support: Tencent Cloud Chat UIKit now supports all platforms, including iOS, Android, Web, Windows, and macOS, resulting in significant changes to the codebase. The UI has been enhanced to adapt to screens of various widths, with different layouts for both wide and narrow screens.
* Information Copy: The ability to copy information, such as Group ID, from the screen has been added.

### Improvements

* Improved group management logic, with non-administrators no longer able to access the management interface.
* Optimized cursor positioning when sending messages.
* Improved and optimized scrollbar functionality.
* Enhanced clickable URL support in messages, with URLs now supporting both with and without the "https://" prefix.

## 1.7.0+1

* Fix: An issue that caused errors on mentioning all members.

## 1.7.0

* Addition: Support for quickly navigating to the first unread message in a group chat with more than 20 new unread messages, using the dynamic tongue located in the top right corner of the screen. This feature allows for swift movement through the messages, regardless of their quantity.
* Addition: Customize the border radius for all avatars is now supported. You can set the default avatar border radius using `defaultAvatarBorderRadius` in `TIMUIKitConfig`.
* Optimization: The delete button on the sticker sending panel has been improved for better usability.
* Optimization: Some English labels on the screen have been updated to better reflect local expressions.
* Fix: An issue causing errors when sending a large number of stickers has been resolved.
* Fix: Some errors that were occurring in the sticker panel have been addressed.

## 1.6.2

* Optimization: Remove `fluttertoast`.
* Fix: An issue that caused errors when sending files without extensions.

## 1.6.1

* Fix: A bug of muting someone in a group.
* Fix: A bug on Flutter 3.7.0.

## 1.6.0

* Addition: `scrollToConversation` on `TIMUIKitConversationController`. You can now easily navigate to a specific conversation in the conversation list and move to the next unread conversation by double-clicking the tab bar, [refers to our sample app](https://github.com/TencentCloud/chat-demo-flutter/blob/main/lib/src/conversation.dart).
* Optimization: The performance of the history message list while scrolling over a large distance.

## 1.5.0+1

* Fix: An issue with video messages being oversize.

## 1.5.0

* Addition: New configuration `defaultAvatarAssetPath` on global `TIMUIKitConfig` to define the default avatar.
* Addition: Supports Flutter 3.7.0.
* Fix: `chatBgColor` configuration.

## 1.4.0

* Addition: Text translation. Long press the text messages to choose `Translate`, which can be turned off by `showTranslation` from `ToolTipsConfig`.
* Optimization: The long press pop-up location and keyboard pop-up event.

## 1.3.2

* Fix: Text input field height, after choosing to mention someone.

## 1.3.1

* Optimization: Improve performance.

## 1.3.0

* Fix: A bug where group tips were not showing the nickname or remarks when transferring group owner.
* Optimization: Remove the confirmation pop-up before opening the file.

## 1.2.0

* Fix: An issue where the input area was not showing when switching from recording to keyboard on `TIMUIKitChat`.
* Fix: An issue where only the first receiver could receive the merged multiple forward messages.
* Optimization: `MessageItemBuilder` can now be used for shows on the merger message screen.

## 1.1.0 And 1.1.0+1

* Addition: We have added support for two new languages - Japanese and Korean.
* Addition: You can now add other languages apart from our default ones, such as English, Chinese (Simplified and Traditional), Japanese, and Korean. You can also modify the translations using the instructions provided in [this documentation](https://www.tencentcloud.com/document/product/1047/52154?from=pub).
* Addition: The sticker plug-in is now embedded in TUIKit by default. We support three types of stickers - Unicode Emoji, small image emoji, and big image stickers. You can refer to [this documentation](https://www.tencentcloud.com/document/product/1047/52227?from=pub) for optimized usage.
* Optimization: Themes are now more customizable.
* Optimization: We have optimized the animation of the input area, keyboard, sticker panel, and more panel.
* Optimization: You can now insert both Unicode and small image emojis at any position in text messages.
* Optimization: You can now preview profile avatars with a large image by clicking it, and copy UserIDs in profile.
* Optimization: We have improved several UI details, including `TIMUIKitAddFriend`, `TIMUIKitAddGroup`, `TIMUIKitGroupProfile`, and `TIMUIKitProfile`.
* Optimization: `TIMUIKitGroupProfile` and `TIMUIKitProfile` can now update automatically after the `ID` is changed.
* Optimization: We have added a new loading animation when downloading images or videos on `TIMUIKitGroupChat`.
* Fix: We have fixed some bugs.

## 1.0.1

* Modification: Remove `groupTRTCTipsItemBuilder` from `MessageItemBuilder`, please use `customMessageItemBuilder` instead.
* Modification: Remove default rendering for calling messages, you can choose to use the default widgets, `CallMessageItem` and `GroupCallMessageItem`, from our call plugin `tim_ui_kit_calling_plugin` directly. Refer to the [Demo](https://github.com/TencentCloud/chat-demo-flutter/tree/main/lib/utils/custom_message/custom_message_element.dart).

## 1.0.0

* Addition: We have added support for adding Flutter module to Native APP. For implementation details, please refer to [this documentation](https://www.tencentcloud.com/document/product/1047/51456?from=pub).
* Addition: You can now customize stickers and emojis for text messages. For more information, please refer to [this documentation](https://cloud.tencent.com/document/product/269/80882).
* Optimization: We have improved the loading duration for history message lists, especially those with lots of media and file messages.
* Optimization: More panel area now supports scrolling.
* Optimization: We have made loading latest messages when scrolling back to the bottom smoother.
* Modification: It is now required to provide the call record widget to `messageItemBuilder` => `customMessageItemBuilder` of `TIMUIKitChat`. You can choose to use the default widget, `CallMessageItem`, from our call plugin `tim_ui_kit_calling_plugin` directly. Please refer to the [Demo](https://github.com/TencentCloud/chat-demo-flutter/tree/main/lib/utils/custom_message/custom_message_element.dart).
* Fix: We have fixed the issue with the number of photos from the album on Android.
* Fix: We have fixed the issue with long text going out of bounds in the group profile info card.
* Fix: We have resolved some bugs.

> **Please note that modifications are required for the second and sixth lines**. Otherwise, the modules for stickers/emojis/call records will not work.

## 0.1.8

* Optimization: File batch downloading queue now allows clicking on multiple file messages at once.
* Optimization: Group list widgets are now automatically updated.
* Optimization: Camera capture now supports relatively lower performance devices and adjusts resolution automatically.
* Optimization: Supports customization of the color and text style of the app bar, especially on TIMUIKitChat widget.
* Fix: Friend remark or nickname no longer fails to show on group tips.
* Fix: Resolved a crash when playing videos.
* Fix: Several bugs.

## 0.1.7

* Addition: Big and RAW images are now supported, especially for those captured from the latest version of iOS and iPhone 14 Pro series, with automatic compression and formatting before sending.
* Optimization: Improved performance and stability, especially for the history message list and launching.
* Optimization: Initializing the `TIMUIKitChat` is now an idempotent operation.
* Optimization: Loads the latest messages when scrolling back to the bottom.
* Optimization: Supports Flutter both 2.x and 3.x series.
* Fix: Resolved an issue with select photos permission.
* Fix: Several bugs.

## 0.1.5

* Addition: Web support is now available, allowing TUIKit to be implemented on iOS/Android/Web platforms.
* Addition: Disk storage checking is now performed after login, with controls available in `config` of `init`.
* Addition: `timeDividerConfig`, `notificationAndroidSound`, `isSupportMarkdownForTextMessage`, and `onTapLink` are added to `TIMUIKitChatConfig`.
* Remove: The default Emoji list has been removed due to copyright issues. You can provide your own sticker list to the panel using [tim_ui_kit_sticker_plugin](https://pub.dev/packages/tim_ui_kit_sticker_plugin).
* Optimization: You can now choose to disable Markdown parsing for text messages.
* Optimization: You can now choose to disable shows for @ messages in the conversation list.
* Optimization: You can now return `null` for `notificationExt`/`notificationBody` in `TIMUIKitChatConfig` and `messageRowBuilder` in `MessageItemBuilder` to use default values based on your needs in a specific case. This means you can control whether to use customized settings based on the provided situation, without having to redefine the same logic as TUIKit in your code.
* Optimization: Supports multiple lines for text messages.
* Optimization: Rebuilt and improved the experience of `TIMUIKitChat`. Note that `TIMUIKitChatController` needs to be specified to `controller`, as shown in the [Demo](https://github.com/TencentCloud/tc-chat-demo-flutter/lib/src/chat.dart).
* Fix: Several bugs.

## 0.1.3

* Addition: User inputting status is now available.
* Addition: Message reactions with emoji/stickers are now available.
* Addition: User online status is now available.

## 0.1.2

* Upgrade: flutter_record_plugin_plus to version 0.0.4.

## 0.1.1

* Addition: Lifecycle hooks are now available for the main widgets, referring to the parameter description for details.
* Addition: Mute status display is now available for group chat on the chat page.
* Addition: URL enrichment is now available for text messages.
* Addition: Callback for global information (Flutter Error, Tips for Reminds, API Error), and you can display toast as needed.
* Optimization: Image preview display has been improved.
* Rebuilt: TUIKitGroupProfile and TUIKitProfile have been simplified for ease of use.

## 0.1.0-bugfix

* Upgrade: Tencent IM Native SDK.

## 0.1.0

* Addition: Atomization widgets for TIMUIKitChat.
* Addition: Updating the UI when the message has been modified.
* Addition: The application page for joining the group.
* Addition: `updateMessage` API, users can refresh the view after modifying the local message.
* Addition: Support for Traditional Chinese.
* Addition: Customization for conversation list item.

## 0.0.9

* Addition: Offline push along with [tim_ui_kit_push_plugin](https://pub.dev/packages/tim_ui_kit_push_plugin).
* Adapt: Flutter 3.0.0.
* Optimization: Local preview of multimedia files.

## 0.0.8

* Addition: Group read receipt module.
* Addition: Little tongue on the message list.
* Addition: Examples.
* Fix: Several bugs.

## 0.0.7

* Fix: Several bugs.

## 0.0.6

* Addition: New `sendMessage` method to the controller `TIMUIKitChatController` for TIMUIKitChat.
* Addition: Configuration for TIMUIKitChat, which can control the functions for TIMUIKitChat components.
* Support: Customized for more panel customized ability to TIMUIKitChat.
* Optimization: User authorization standardized.

## 0.0.5

* Addition: Several new customized configs, includes, appBarConfig, morePanelConfig, and removed appBarActions config.
* Optimization: Image preview displaying.
* Upgrade: Tencent IM SDK.
* Fix: The issue of conversation item duplication for TIMUIKitConversation.

## 0.0.4

* Optimization: TIMUIKitChat, especially for media files selector.
* Optimization: Previewing of image messages, video messages.
* Optimization: Theme color.
* Optimization: UI for search components.
* Upgrade: Tencent IM SDK.

## 0.0.3

* Addition: TIMUIKitSearch and TIMUIKitSearchMsgDetail, supports searching both in conversation and globally.
* Addition: TIMUIKitAddFriend.
* Addition: TIMUIKitAddGroup.
* Addition: Theme style configuration.
* Optimization: Internationalization.

## 0.0.2

* Optimization: TIMUIKitChat.
* Fix: Bugs on Internationalization.

## 0.0.1

The first released of TUIKit for Flutter of Tencent Cloud IM, the component of the first phase includes:

* TIMUIKitCore: The main entrance of the whole TUIKit.
* TIMUIKitConversation: Conversation list.
* TIMUIKitChat: Chat and historical message list.
* TIMUIKitProfile: User detail profile and relationship management.
* TIMUIKitGroupProfile: Group details and management.
* TIMUIKitGroup: Joined group list.
* TIMUIKitBlackList: Blocklist.
* TIMUIKitContact: Contacts list.
* TIMUIKitNewContact: New contact application list.