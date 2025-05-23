# 4.0.8
* Use the OfflinePushInfo constructor, not the fromJson function.

# 4.0.7
* Fixed the issue that modifying your own adding friend permissions does not take effect.
* Fixed the setGroupInfo exception problem.

# 4.0.6
* Solve the updateSelfInfo exception problem.
* The success of calling the initSDK interface is determined by the code of the return value. Avoid inaccurate judgment when calling the interface multiple times.

# 4.0.5
* Upgrade tencent_cloud_chat_sdk to the minimum version 8.5.6864+6.
* Changed the SDK interface call from getConversationListByConversaionIds to getConversationListByConversationIds.

# 4.0.4
* Remove the import of tencent_im_base plugin.
* Upgrade tencent_cloud_chat_sdk to the minimum version 8.5.6864+4.
* Fix compilation issues in tim_uikit_group.dart, tui_group_listener_model.dart, tui_conversation_view_model.dart.

# 4.0.3
* Fix compilation issues on Flutter 3.27.1

# 4.0.2
* Optimize the display of group notification page.
* Optimize the display of read receipt page.
* TIMUIKitChatController sendMessage interface supports isExcludedFromContentModeration parameter.
* Fixed abnormal playback and recording of videos on Huawei P30.
* Optimize the display of tips messages when they are too long.

# 4.0.1
* Upgraded the plugin tim_ui_kit_sticker_plugin to 4.0.1.
* Add the 'useTencentCloudChatStickerPackageOldKeys' parameter in StickerPanelConfig to control whether the emoticon is compatible with version 3.x.

# 4.0.0
## Breaking changes
* Upgraded the plugin tim_ui_kit_sticker_plugin to 4.0.0.
* Delete the isUseDefaultEmoji parameter in TIMUIKitChatConfig.
* Delete the isUseDefaultEmoji parameter in each widget.

## Bug Fixes
* Solve the problem that showReplyMessage and showForwardMessage in ToolTipsConfig do not take effect after being set to false.

# 3.1.0+2
* Replace the flutter_slidable library with flutter_slidable_plus_plus to solve the compatibility issue of flutter 3.27.0 version.

# 3.1.0+1
* Upgrade the third-party library version to adapt to Android AGP 8.0.

# 3.1.0
## Bug Fixes
* The interface for deleting messages is changed to the interface for deleting cloud messages.
* C2C messages support read receipts
* Fix and optimize some issues

# 3.0.0
## Breaking Changes
* Migrated to Flutter 3.24.0
## Bug Fixes
* Fix and optimize some issues

# 2.7.2
* Fix the issue where failed messages cannot be resent.
* Fix the issue where image messages that failed to send are not loaded using the local path.
* Fix the issue where the screen turns white after dissolving or leaving a group.
* Optimize the process of sending messages.
* Optimize the alignment of buttons in the long-press message menu.
* Limit the version range of the third-party library extended_image.

# 2.7.1
* Fixed the 'keepAspectRatio' parameter error.

# 2.7.0

## Breaking Changes

* Upgraded Low-Level Native Chat SDK to 8.0.

# 2.6.0

## Breaking Changes

* Migrated to Flutter 3.22. Support for Flutter 3.19 and earlier versions has been discontinued.



# 2.5.1

## Improvements

* Improved memory usage, enhancing performance.
* Improved the logger storage.

# 2.5.0

## Breaking Changes

* Migrated to Flutter 3.19. Support for Flutter 3.16 and earlier versions has been discontinued.

## Notes

* Starting from Flutter 3.19, it is recommended to apply Flutter's Gradle plugins using Gradle's declarative plugins {} block (also known as the Plugin DSL) ([see details](https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply)).
* In line with this, our sample app on the GitHub repo has also been migrated to this new approach. If you'd like to migrate to this new approach, please refer to our [sample app repo](https://github.com/TencentCloud/chat-demo-flutter).

# 2.4.3

## Bug Fixes

* Fixed an keyboard issue on Web.

# 2.4.2

## Bug Fixes

* Fixed an UI issue on Material3 mode.

# 2.4.1

## Improvements

* Enhanced stability for message reaction.

## Bug Fixes

* Fixed some bugs.

# 2.4.0

## Breaking Changes

* Migrated to Flutter 3.16. Support for Flutter 3.13 and earlier versions has been discontinued.
* Upgraded the minimum supported Android Gradle Plugin to 7.3 to meet Flutter requirements.

# 2.3.3

## New Features

* Added a new lifecycle hook, `messageListShouldMount`.

## Bug Fixes

* Fixed an issue on time tag creator.

# 2.3.2

## Improvements

* Enhanced message list performance.

## Bug Fixes

* Fixed an issue that prevented the group member addition/removal modal from closing.
* Addressed several other bugs.

# 2.3.1

## Bug Fixes

* Resolved an issue that prevented the clearing of history messages after deleting a conversation.
* Fixed an issue that prevented opening files sent by the user themselves on Android.

# 2.3.0

## Breaking Changes

* Upgraded and migrated to support Flutter 3.13. Support for Flutter 3.10 and earlier versions has been discontinued.

## Recommendations

* Customers who do not wish to upgrade to Flutter 3.13 are advised to continue using version 2.2.1 of our Chat UIKit. However, we strongly recommend upgrading to Flutter 3.13.0 as it includes numerous performance improvements and introduces cutting-edge features.

# 2.2.1

## New Features

* Introduced a new `groupMemberList` configuration in `TUIKitChat`; when specified, TUIKit will not load it automatically, optimizing network traffic usage.
* Added support for image copying on desktop platforms.

## Bug Fixes

* Fixed an issue preventing the removal of image loading status.
* Resolved a problem that prevented images from being saved to the device gallery.
* Addressed a potential issue causing the `mentionOtherMemberInGroup` function in `TIMUIKitChatController` to fail.
* Corrected an issue that could lead to improper image rendering.

# 2.2.0

## New Features

* Introduced a newly-designed set of Emoji image stickers, available for seamless integration within textual content, providing an enhanced user experience.
* Streamlined the implementation of stickers, removing the need for additional complex coding. Full functionality is enabled by default, with customization options available through the `stickerPanelConfig` configuration in `TIMUIKitChatConfig`.
* Extended support for rendering embedded image stickers within text messages when the `Markdown` parsing mode is activated, combining a rich, user-friendly experience with the ability to display formatted Markdown text.

## Improvements

* Enhanced group chat functionality on the Desktop, enabling mentions (`@` tag) to be inserted at any position within a composed message, rather than only at the end. Additionally, deleting `@` tags has been optimized.
* Maintained message sending permissions for the group owner and administrators during "mute all" scenarios.
* Enabled the use of a return `null` value for the `customHoverBar` to utilize the default.
* Refined the revoke button functionality for group administrators.
* Removed full-screen support for video previews on the Web and introduced an alternative "Open in New Window" button for an enlarged view.
* Implemented UIKit log recording to facilitate issue identification and troubleshooting.
* Introduced a delete button for the small PNG sticker selection panel on mobile devices, which previously was only available in the Unicode emoji selection panel.

## Bug Fixes

* Resolved an issue preventing photo capturing on devices running Android 12 or lower.
* Rectified display inaccuracies related to picture aspect ratios.
* Addressed several issues concerning voice and video calls.

# 2.1.3+1

## New Features

* Introduced [a new custom internationalization language scheme](https://www.tencentcloud.com/document/product/1047/52154?from=pub) that supports adding language packs, adding or modifying entries, and makes customizing i18n more accessible. This feature helps your app achieve a more convenient globalization process and easier customer acquisition worldwide.
* Provided a seamless experience for previewing large images and playing videos within desktop environments (applications and web) by avoiding frequent page transitions. Enhanced the user experience for image previews and video playback. Please note that video playback is currently supported only on the web and not in desktop applications.
* Supported to integrate with the new online customer service plugin (tencent_cloud_chat_customer_service_plugin).
* Added two new life cycle hooks, `messageDidSend` and `messageShouldMount` to `ChatLifeCycle`.

## Improvements

* Optimized the usage, interface, and interaction of the sticker panel.
* Enhanced mobile video playback interaction and UI.
* Refined the error prompt when sending a 0 KB file fails.
* Enabled users to close modals on desktop by clicking the bottom gray overlay area.
* Improved the UI and interaction of image and video messages in the message list.
* Added the ability to open self-sent file messages without downloading.
* Optimized the download status animation of file messages on the web.

## Bug Fixes

* Fixed an issue preventing mobile image previews from being dragged after zooming.
* Resolved an issue that might cause the message selection status not to be removed after canceling a message forward action.
* Addressed an issue that might cause the microphone usage not to end after sending a voice message, which means the microphone was not released.

# 2.1.2

## New Features

* Introduced a new message recall mode, which enables group administrators to recall any message from any group member. To enable this feature, set `isGroupAdminRecallEnabled` in `TIMUIKitChatConfig` to `true`.
* Added support for draft text functionality on the Web. Activate this feature by setting `isUseDraftOnWeb` in `TIMUIKitChatConfig` to `true`. Since the Chat SDK doesn't support this functionality, draft data will be stored in TUIKit's memory. Be aware that draft text will be lost upon refreshing the website.
* Enabled using the default message abstract text when `abstractMessageBuilder` returns `null`.

## Improvements

* The duration for video messages sent from the Web will no longer be displayed, as this type of video message does not contain an accurate video duration.
* Removed the hover color on the message input area on Desktop.
* Added auto-focus support for the message input area on Desktop.
* Enhanced the rendering of text messages in markdown mode, particularly for clickable link extraction and HTML tag handling.
* Limited the number of lines displayed for replied messages to a maximum of 2 lines to avoid occupying excessive space.
* Optimized the message replying process, ensuring that a message referencing another message can still display the replied message, even when it is too old.

## Bug Fixes

* Fixed an issue that could cause the profile page to display no data.
* Fixed an issue that could prevent the message sending button from being displayed after selecting an emoji on mobile Web.
* Fixed an issue that could prevent the message long-press menu from showing on mobile Web.
* Fixed an issue where editing a message would carry over to another conversation when switching between conversations.
* Fixed an issue that could prevent displaying the `Modal` on Desktop.
* Fixed an issue that caused the `iconImageAsset` from the `MessageToolTipItem` class to not work properly.

# 2.1.0+2

## Improvements

* Upgraded several dependencies to resolve conflicts with the Kotlin Gradle plugin.

## Bug Fixes

* Fixed an issue causing the message list to be displayed inaccurately when it contains a file without a suffix.

# 2.1.0+1

## Improvements

* Removed `disk_space` dependency as many customers reported difficulty in obtaining this dependency successfully.
* Replaced `fc_native_video_thumbnail_for_us` with its original version `fc_native_video_thumbnail`.

## Bug Fixes

* Fixed an issue where `universal_html` could be blocking the compilation.

# 2.1.0

## Breaking Changes

* Migrated to Flutter 3.10.0 and Dart 3.0.0, no longer supporting projects with Flutter < 3.10.0 and Dart < 3.0.0.
* Updated the minimum requirement for Android AGP to 7.0, projects with AGP < 7.0 are no longer supported.

We highly recommend updating to these new versions for a better experience.

## New Features

* Added several methods to `TIMUIKitChatController`, including `hideAllBottomPanelOnMobile`, `mentionOtherMemberInGroup`, `setInputTextField`, and `getGroupMemberList`. Please refer to the corresponding annotations for usage.
* Added more parameter fields to the `TIMUIKitChatController`'s `sendMessage` method. For details, please refer to the corresponding annotations.
* Added `onSecondaryTapAvatar` to `TIMUIKitChat`, serving as callback trigger for secondary avatar clicks in the message list.
* Introduced `isUseMessageHoverBarOnDesktop` and `desktopMessageInputFieldLines` to `TIMUIKitChatConfig`. For usage details, please refer to the corresponding annotations.

## Improvements

* Enhanced performance and user experience when switching conversations on Desktop, including features like text field auto-focus and draft text.
* Enabled displaying correct new lines in markdown mode.
* Changed the order of members in the mentioned member selection panel: Group Owner => Group Administrator => Member, sorted based on the code units' first differing position in the member show names.
* Implemented auto-focus after clicking a member in the mentioned member selection panel.
* Added text field auto-focus when replying to a message.
* Updated other members' display names in at-tag messages to use `namecard`, followed by `nickname` and `userId`.
* Widened Desktop message input area's control bar.
* Replaced the default icon in Desktop's message input area from `png` to `svg` for better performance and clarity. `DesktopControlBarConfig` now supports defining `svgPath` for each item as well.
* Improved Web platform detection.
* Mentioning "all" or "at all" can now only be used by group owners and administrators.
* Supported returning null for each message item builder in `MessageItemBuilder` to use the default message widget.
* Enhanced group members filtering in the group member mentioned selection panel with case-insensitive fuzzy matching, leading to increased filtering accuracy.
* For security purposes, downloading files by `fetch` and `blob` in the Web now replaces previewing files in a new browser tab, whereas previewing images and videos is displayed in a new tab on the Web.
* Changed the default order in the message tooltip menu.
* Previewing images and videos is set to open in a new tab on the Web.
* Improved the ratio for sending video messages.

## Bug Fixes

* Fixed issues when enabling the section function in markdown mode with `inEnableTextSelection` set to `true`.
* Addressed an issue where the replied message was removed when selecting all text in the message and clicking backspace.
* Fixed an issue where Chinese characters could not be entered while replying to a message.
* Resolved some console errors during debugging.
* Fixed an issue with links not opening in markdown mode.
* Fixed an issue that caused two `Scrollbar`s to appear in the message input field on Desktop.
* Solved an issue that might cause incorrect layout when the app is launched.
* Addressed an issue where messages were directly sent when the Enter key was pressed while entering Chinese text.
* Fixed related issues with the mentioned member selection panel on Desktop.
* Resolved an issue where images couldn't be pasted directly into the message input area for sending on the Web.
* Fixed an issue where files couldn't be sent on the Web.
* Remedied an issue where media and files couldn't be opened when local downloaded resources were deleted; now, resources will automatically re-download.
* Fixed an issue that caused the `iconImageAsset` of the `MessageToolTipItem` config to head internally to this chat UIKit.
* Improved the downloading process of media and files by avoiding frequent calls to `setState`, thus preventing the entire project from re-rendering.

# 2.0.0

If you are upgrading from version 1.7.0, please refer to the changelog of all 2.0.0-preview versions, ranging from preview.1 to preview.7.

The main feature of this new 2.0.0 version is Desktop Support. Tencent Cloud Chat UIKit now supports all platforms, including iOS, Android, Web, Windows, and macOS, which has resulted in significant changes to the codebase. The UI has been improved to adapt to screens of various widths, with different layouts for both wide and narrow screens.

In addition, there are some significant changes compared to version 2.0.0-preview.7.

## New Features

* Added drag and drop support for multiple files in `TIMUIKitChat`, allowing direct sending.
* Introduced functionality to open files or their containing folder (using `Finder` on `macOS` or `Explorer` on `Windows`) for file messages via the message operation tooltip menu on desktop.
* Implemented text selection and copying in messages on desktop.
* Added group joining application processing on Desktop.
* Introduced `isAutoReportRead` to `TIMUIKitChatConfig` for controlling read status reporting.

## Improvements

* Enhanced group members selection panel for mentioning someone in a group chat.
* Refined image display ratio on Desktop.
* The Reply or Quote button is now labeled as `Reply` when `isAtWhenReply` is set to true, and `Quote` otherwise.
* @ member tags can now be deleted at once.

## Bug Fixes

* Fixed UI layout issue causing the `translate` button to display on two lines.
* Addressed an issue causing the mute status not to change when switching to another conversation.
* Fixed several issues causing bugs when opening files.
* Resolved an issue causing secondary confirmation modal UI layout to be over-width on Desktop.
* Fixed an issue causing UI layout errors on the profile page.
* Addressed an issue where the `chatMessageItemFromSelfBgColor` configuration did not work.
* Fixed an issue preventing files from being opened when the path contained Chinese characters on Windows.
* Resolved an issue preventing images from being pasted and sent directly with Ctrl + V on Windows.
* Fixed an issue causing errors in the muting members list.

# 2.0.0-preview.7

## New Features

* Added `additionalMessageToolTips` to `ToolTipsConfig`. This new property allows developers to add additional message operation tooltip items, apart from the default ones. The previous `additionalItemBuilder` has been replaced by this new property. With `additionalMessageToolTips`, developers only need to specify the data for the tooltip items, rather than providing a whole widget. This makes usage easier, as you no longer need to worry about the UI display.
* Added `isPreloadMessagesAfterInit` to `TIMUIKitConfig`, allows determines whether TUIKit should preload some messages after initialization for faster message display.

## Improvements

* Message operation menu shows when long-pressing messages will not show if nothing operation item includes and do not use message sticker reaction module.
* Renamed `desktopMessageHoverBar` to `additionalDesktopMessageHoverBarItem` in `TIMUIKitChatConfig` to control only the addition of extra operation items displayed on the hover bar of messages on desktop (macOS, Windows, and desktop version of Web), without affecting the default ones. Previously, it controlled the entire message hover bar, including covering the default items.
* Renamed `showWideScreenModalFunc` to `showDesktopModalFunc` in `TIMUIKitConfig` for better clarity.
* Upgraded several dependencies to their latest versions, including `ffi` to ^2.0.1, `file_picker` to ^5.2.9 and `device_info_plus` to ^8.2.0.
* Added support for the new permission authorization schema on Android 13 and `targetSdkVersion` greater than 33.
* Corrected the `textHight` to `textHeight` in `TIMUIKitChatConfig`, and modified the default value to 1.3.

## Bug Fixes

* Fixed an issue where the `showVideoCall` and `showVoiceCall` configuration options were not working.
* Fixed potential `Windows` platform deployment prohibition issue.
* Fixed an issue that may cause `setLocalCustomData` to be triggered repeatedly.

# 2.0.0-preview.6

## Improvements

* Permission requests now feature a gray translucent overlay for secondary confirmations on first-time requests, which was reintroduced after being removed in version 2.0.0-preview.4. Additionally, the overlay can now be successfully hidden once the permission authorization is complete.".
* Time Divider on Message List: The default 12-hour display has been changed to a 24-hour display.
* Message translation now targets the language of TUIKit instead of relying on the system language directly. The language of TUIKit can be set as the system language automatically or defined by the user. For more information, please refer to this documentation: https://www.tencentcloud.com/document/product/1047/52154.
* Optimized the animation for message text input area.

## Bug Fixes

* Fixed an issue where the `Voice Call` and `Video Call` buttons were not working in group chat.
* Fixed several null-safety issues.
* Fixed a layout problem for the message operation menu when not using the message sticker reaction module.
* Addressed a problem where the time ago display was not correct on the conversation item.
* Fixed an issue where stickers could not be clicked in some cases.
* Resolved an overflow error that occurred when opening the sticker panel.

# 2.0.0-preview.5

## New Features

* New Chat Configuration: `isAllowLongPressAvatarToAt`. This option controls whether users are allowed to mention another user in the group by long-pressing on their avatar.

## Improvements

* Improved tool bar configuration on desktop: The tool bar can now be customized using `desktopControlBarConfig` for embedded default items and `additionalDesktopControlBarItems` for additional tool items. These configurations come from TIMUIKitChatConfig.
* Renamed the `wideMessageHoverBar` configuration option to `desktopMessageHoverBar` for better clarity.
* Eliminated the dependency on `fluttertoast`. All necessary customer reminders are now triggered through the `onTUIKitCallbackListener` info callback in your project. For more information, please see: https://www.tencentcloud.com/document/product/1047/50054#how-do-i-get-an-api-call-error.2Fflutter-layer-error.2Fpop-up-prompt-message.3F.3Ca-id.3D.22callback.22.3E.3C.2Fa.3E.
* Eliminated other six unnecessary dependency packages to reduce the size and improve performance.
* Improved the clarity of the `sendMessage` function in `TIMUIKitChatController` by replacing the use of `convID` to represent both `userID` and `groupID` with separate parameters.

## Bug Fixes

* Fixed an issue where the message operation menu may show inaccurately when the message is too long.
* Fixed a problem where the message operation menu had the potential to be too wide for certain types of messages, causing display issues.
* Corrected an issue where the button to remove group members was not functioning correctly.
* Addressed a problem where the message item could exceed the pixel limit and appear too wide.
* Fixed a bug where certain JSON decoding operations could potentially fail.
* Fixed an issue with sound messages on iOS devices playing only through earpiece instead of speaker by default.

# 2.0.0-preview.4

## New Features

* New Chat Configuration: `TIMUIKitChatConfig` now includes `offlinePushInfo`, which allows for customization of the entire `offlinePushInfo` for each message. This field has a higher priority than the previous separate configuration fields for this object.
* New Color Configuration: Added `appbarTextColor` and `appbarBgColor` to configure the color for the Appbar. Also added `selectPanelBgColor` and `selectPanelTextIconColor` to configure the color of the messages multi-select panel.

## Improvements

* Improved Group Management: Muting members on Work Group is now not allowed.
* Improved Avatar: Ensured that the avatar can be as small as possible while still covering the entire target box.
* Permission Requests: Removed the gray translucent overlay for secondary confirmations on first-time permission requests.

## Bug Fixes

* Fixed an issue where the color defined by `chatBgColor` could not cover the entire chat screen when messages did not cover the whole page.
* Fixed an issue where the history message list could not be scrolled in some cases.
* Fixed an issue where the ratio of sending messages was incorrect, resulting in the wrong position of the read status label on the left.
* Fixed an issue where loading messages could fail when the number of messages equaled the specified count.

# 2.0.0-preview.3

## New Features

* Integrated Callkit: The Calls button no longer needs to be added to `MorePanelConfig`. If `tencent_calls_uikit` is installed, the Video Call and Voice Call buttons will be displayed automatically.
* Paste Images on Desktop: Users can now paste an image on the text field on Desktop to send it.
* Screenshot Capture on Desktop: Users can now capture a screenshot on Desktop and send it.

## Improvements

* Improved Compatibility: The TUIKit is now compatible with Flutter versions 3.0.0 to 3.7.7.

## Bug Fixes

* Fixed an issue where the `businessID` type may not be correct.
* Fixed an issue where the `chatMessageItemFromSelfBgColor` configuration was not taking effect.

# 2.0.0-preview.2

## New Features

* Added support for opening files locally from file messages.

# 2.0.0-preview.1

## New Features

* Desktop Support: Tencent Cloud Chat UIKit now supports all platforms, including iOS, Android, Web, Windows, and macOS, resulting in significant changes to the codebase. The UI has been enhanced to adapt to screens of various widths, with different layouts for both wide and narrow screens.
* Information Copy: The ability to copy information, such as Group ID, from the screen has been added.

## Improvements

* Improved group management logic, with non-administrators no longer able to access the management interface.
* Optimized cursor positioning when sending messages.
* Improved and optimized scrollbar functionality.
* Enhanced clickable URL support in messages, with URLs now supporting both with and without the "https://" prefix.

# 1.7.0+1

* Fix: An issue that caused errors on mentioning all members.

# 1.7.0

* Addition: Support for quickly navigating to the first unread message in a group chat with more than 20 new unread messages, using the dynamic tongue located in the top right corner of the screen. This feature allows for swift movement through the messages, regardless of their quantity.
* Addition: Customize the border radius for all avatars is now supported. You can set the default avatar border radius using `defaultAvatarBorderRadius` in `TIMUIKitConfig`.
* Optimization: The delete button on the sticker sending panel has been improved for better usability.
* Optimization: Some English labels on the screen have been updated to better reflect local expressions.
* Fix: An issue causing errors when sending a large number of stickers has been resolved.
* Fix: Some errors that were occurring in the sticker panel have been addressed.

# 1.6.2

* Optimization: Remove `fluttertoast`.
* Fix: An issue that caused errors when sending files without extensions.

# 1.6.1

* Fix: A bug of muting someone in a group.
* Fix: A bug on Flutter 3.7.0.

# 1.6.0

* Addition: `scrollToConversation` on `TIMUIKitConversationController`. You can now easily navigate to a specific conversation in the conversation list and move to the next unread conversation by double-clicking the tab bar, [refers to our sample app](https://github.com/TencentCloud/chat-demo-flutter/blob/main/lib/src/conversation.dart).
* Optimization: The performance of the history message list while scrolling over a large distance.

# 1.5.0+1

* Fix: An issue with video messages being oversize.

# 1.5.0

* Addition: New configuration `defaultAvatarAssetPath` on global `TIMUIKitConfig` to define the default avatar.
* Addition: Supports Flutter 3.7.0.
* Fix: `chatBgColor` configuration.

# 1.4.0

* Addition: Text translation. Long press the text messages to choose `Translate`, which can be turned off by `showTranslation` from `ToolTipsConfig`.
* Optimization: The long press pop-up location and keyboard pop-up event.

# 1.3.2

* Fix: Text input field height, after choosing to mention someone.

# 1.3.1

* Optimization: Improve performance.

# 1.3.0

* Fix: A bug where group tips were not showing the nickname or remarks when transferring group owner.
* Optimization: Remove the confirmation pop-up before opening the file.

# 1.2.0

* Fix: An issue where the input area was not showing when switching from recording to keyboard on `TIMUIKitChat`.
* Fix: An issue where only the first receiver could receive the merged multiple forward messages.
* Optimization: `MessageItemBuilder` can now be used for shows on the merger message screen.

# 1.1.0 And 1.1.0+1

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

# 1.0.1

* Modification: Remove `groupTRTCTipsItemBuilder` from `MessageItemBuilder`, please use `customMessageItemBuilder` instead.
* Modification: Remove default rendering for calling messages, you can choose to use the default widgets, `CallMessageItem` and `GroupCallMessageItem`, from our call plugin `tim_ui_kit_calling_plugin` directly. Refer to the [Demo](https://github.com/TencentCloud/chat-demo-flutter/tree/main/lib/utils/custom_message/custom_message_element.dart).

# 1.0.0

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

# 0.1.8

* Optimization: File batch downloading queue now allows clicking on multiple file messages at once.
* Optimization: Group list widgets are now automatically updated.
* Optimization: Camera capture now supports relatively lower performance devices and adjusts resolution automatically.
* Optimization: Supports customization of the color and text style of the app bar, especially on TIMUIKitChat widget.
* Fix: Friend remark or nickname no longer fails to show on group tips.
* Fix: Resolved a crash when playing videos.
* Fix: Several bugs.

# 0.1.7

* Addition: Big and RAW images are now supported, especially for those captured from the latest version of iOS and iPhone 14 Pro series, with automatic compression and formatting before sending.
* Optimization: Improved performance and stability, especially for the history message list and launching.
* Optimization: Initializing the `TIMUIKitChat` is now an idempotent operation.
* Optimization: Loads the latest messages when scrolling back to the bottom.
* Optimization: Supports Flutter both 2.x and 3.x series.
* Fix: Resolved an issue with select photos permission.
* Fix: Several bugs.

# 0.1.5

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

# 0.1.3

* Addition: User inputting status is now available.
* Addition: Message reactions with emoji/stickers are now available.
* Addition: User online status is now available.

# 0.1.2

* Upgrade: flutter_record_plugin_plus to version 0.0.4.

# 0.1.1

* Addition: Lifecycle hooks are now available for the main widgets, referring to the parameter description for details.
* Addition: Mute status display is now available for group chat on the chat page.
* Addition: URL enrichment is now available for text messages.
* Addition: Callback for global information (Flutter Error, Tips for Reminds, API Error), and you can display toast as needed.
* Optimization: Image preview display has been improved.
* Rebuilt: TUIKitGroupProfile and TUIKitProfile have been simplified for ease of use.

# 0.1.0-bugfix

* Upgrade: Tencent IM Native SDK.

# 0.1.0

* Addition: Atomization widgets for TIMUIKitChat.
* Addition: Updating the UI when the message has been modified.
* Addition: The application page for joining the group.
* Addition: `updateMessage` API, users can refresh the view after modifying the local message.
* Addition: Support for Traditional Chinese.
* Addition: Customization for conversation list item.

# 0.0.9

* Addition: Offline push along with [tim_ui_kit_push_plugin](https://pub.dev/packages/tim_ui_kit_push_plugin).
* Adapt: Flutter 3.0.0.
* Optimization: Local preview of multimedia files.

# 0.0.8

* Addition: Group read receipt module.
* Addition: Little tongue on the message list.
* Addition: Examples.
* Fix: Several bugs.

# 0.0.7

* Fix: Several bugs.

# 0.0.6

* Addition: New `sendMessage` method to the controller `TIMUIKitChatController` for TIMUIKitChat.
* Addition: Configuration for TIMUIKitChat, which can control the functions for TIMUIKitChat components.
* Support: Customized for more panel customized ability to TIMUIKitChat.
* Optimization: User authorization standardized.

# 0.0.5

* Addition: Several new customized configs, includes, appBarConfig, morePanelConfig, and removed appBarActions config.
* Optimization: Image preview displaying.
* Upgrade: Tencent IM SDK.
* Fix: The issue of conversation item duplication for TIMUIKitConversation.

# 0.0.4

* Optimization: TIMUIKitChat, especially for media files selector.
* Optimization: Previewing of image messages, video messages.
* Optimization: Theme color.
* Optimization: UI for search components.
* Upgrade: Tencent IM SDK.

# 0.0.3

* Addition: TIMUIKitSearch and TIMUIKitSearchMsgDetail, supports searching both in conversation and globally.
* Addition: TIMUIKitAddFriend.
* Addition: TIMUIKitAddGroup.
* Addition: Theme style configuration.
* Optimization: Internationalization.

# 0.0.2

* Optimization: TIMUIKitChat.
* Fix: Bugs on Internationalization.

# 0.0.1

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
