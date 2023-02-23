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