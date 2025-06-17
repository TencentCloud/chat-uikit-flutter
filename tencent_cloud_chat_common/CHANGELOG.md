# 4.1.0
## General
* Migrate to Flutter 3.29.0.

# 3.2.1+1
## General
* Compatible with audio and video signaling analysis.

# 3.2.1
## General
### Breaking changes
* Depends on the refactored tencent_cloud_chat_sdk 8.5.6864-beta.3 version
### Message (TencentCloudChatMessage)
* Optimize multimedia message download logic.

# 3.2.0
## General
### Breaking changes
* Starting from version 3.2.0, tencent_cloud_chat, tencent_cloud_chat_group_profile, tencent_cloud_chat_user_profile are no longer maintained or depended on.
* Merge the logic in tencent_cloud_chat into tencent_cloud_chat_common, and merge the logic in tencent_cloud_chat_group_profile and tencent_cloud_chat_user_profile into tencent_cloud_chat_contact.

## New features and bug fixes
* Added "start a conversation" and "create a group chat" entrances.
* Added group management related functions: modify group avatars, transfer group owners, set administrators, modify "active group joining method", modify "invite group method", etc.
* Fixed the issue that the group details page and chat page were not updated in time after modifying the group information.
* Fixed the issue where the list of joined groups was not updated when creating a group, joining, leaving, being kicked, etc.

# 2.1.0

## General
* Optimize multiple issues.

# 1.6.2
## General
* Modify the permission issue to adapt to Android 13

# 1.6.0
## General

* Added support to Customer Service Plug-in.

# 1.5.0

## General

* Upgraded the underlying Flutter Chat SDK, as well as the iOS and Android Chat SDKs, to version 8.0.
* Migrated group data storage to a global LRU-optimized cache, improving the integration between TencentCloudChatMessage
  and TencentCloudChatGroupProfile components.

## Message (TencentCloudChatMessage)

* Added the ability to display sender avatars in offline push notifications when applicable.
* Fixed an issue affecting the message sending workflow.
* Fixed a problem with video previews and playback functionality.
* Fixed a bug in the offline message push data handling that could result in the `onNotificationClicked` event
  malfunctioning.

## Group Profile (TencentCloudChatGroupProfile)

* Improved Desktop platform compatibility and performance.
* Fixed several issues to enhance overall stability.

# 1.4.1

## General
* Enhanced performance on the Web.

## Message (TencentCloudChatMessage)
* **[Breakthrough]**: Integrated the new **Message Reaction Plugin**, enabling users to react to messages with stickers.
* **[Breakthrough]**: Integrated the new **Message Translation Plugin**, enabling users to translate messages.
* Added copy, save as, and open in a new window functionality for image messages.
* Added support for navigating to specific messages on the Web.
* Added support for navigating to specific messages in Communities.
* Optimized memory usage for the message list on the Web.
* Improved the styling of the message context menu.

# 1.4.0

## General

* **[Breakthrough]**: Added comprehensive support for **Web**, including both Mobile and Desktop browsers.
* Added support to return the login status for the `initUIKit` method.
* Added `addGlobalCallback` and `removeGlobalCallback` to `TencentCloudChatCoreController`, enabling the integration and management of custom `TencentCloudChatCallbacks` throughout your codebase.
* Improved device screen recognition logic.

# 1.3.1

## General

- Added support to Flutter 3.22.

# 1.3.0

## General

- Enhanced the `initUIKit` function with several improvements, streamlining the configuration process and increasing overall usability. Key updates include:
    - A new `components` parameter that consolidates component-related configurations, including the required `usedComponentsRegister` for manually declaring utilized components. It also allows for optional global configurations, builders, controllers, and event handlers for each component, affecting all instances of each component.
    - A new `onTencentCloudChatSDKEvent` callback within the `callbacks` parameter handles SDK-related events, replacing the previous `sdkListener` from `options`.
    - The `config` parameter now focuses on global configurations for the UIKit, removing `usedComponentsRegister` and `preloadDataConfig`. The `usedComponentsRegister` has been moved to the `components` parameter.
    - Removed the requirement for passing in `context`.
    - Enabled automatic initialization of CallKit during this process, eliminating the need of invoking `TUICallKit.instance.login` manually for using voice and video calls.
- Introduced a new manager for each component, named by appending `Manager` to the component's name (e.g., `TencentCloudChatMessageManager`), providing the following functions for better and easier integration:
    - `register`: [Manually declares the usage of each component](https://pub.dev/packages/tencent_cloud_chat#basic-usage) during the `initUIKit` call.
    - `controller`: [Taking control of each component](https://pub.dev/packages/tencent_cloud_chat#global-taking-control-of-each-component) on a global scale.
    - `eventHandlers`: [Handling component-level events](https://pub.dev/packages/tencent_cloud_chat#global-handling-component-level-events) on a global scale.
    - `builder`: [Dynamically updating UI builders](https://pub.dev/packages/tencent_cloud_chat#dynamically-updating-ui-builders) for all instances.
    - `config`: [Configuring components](https://pub.dev/packages/tencent_cloud_chat#global-configuring-components) for all instances dynamically.
- Migrated the `register` from the `Instance` of each component to the `Manager`, as described in the previous point.
- Refined the core data storage structure and performance, paving the way for future feature enhancements.

## Message (TencentCloudChatMessage)

- Changed the default configurations for `enabledGroupTypesForMessageReadReceipt` to be empty. This requires specifying the group types for which the message read receipt feature should be enabled, after enabling them in the Console.
- Fixed an issue where the message read status could not be updated dynamically for one-to-one chats.
- Reduced the number of rebuilds for message list items to improve performance.
- Resolved an issue where initiating voice or video calls might not be possible in group chats.

# 1.2.1

## Conversation (TencentCloudChatConversation)

- Fixed an issue where the main widget was being disposed on desktop after switching login accounts.
- Changed the button `Mark as Unread` to `Mark as Read` and its functionality has been implemented.

## Message (TencentCloudChatMessage)

- Fixed an issue where some configurations from `TencentCloudChatMessageConfig` were not working.
- Fixed a permission request failure on both iOS and Android devices when the app is installed for the first time. Also resolved an issue where permissions could not be manually enabled in settings.
- Improved the message locating for the original message of a replied message.
- Fixed an issue where messages could not be received and displayed on the message list dynamically in some cases, especially after login account switching.
- Fixed issues related to voice message playback.
- Displayed a default avatar for users without a profile picture.

# 1.2.0

## General

- Added support for tablet devices, including adaptive UI for iPad and various Android tablets. Now you can deploy to all platforms (mobile, pad, desktop, web) with a single codebase and code once.
- Introduced callback functionality, allowing handling of SDK API errors and specific UIKit events that require user attention with `eventCode` and `text` by default, on a global scale. Developers can initialize UIKit with `TencentCloudChatCoreController.initUIKit()` and set up the callbacks accordingly.
- Enhanced global dialog style for Apple devices with a more native-looking Cupertino style.
- Optimized global data storage structure and improved underlying performance.
- Ensured that all data from the previous account is removed from memory after logging out, and no data remains when logging in with a new account.
  Replaced the original `logout` method with the `resetUIKit({bool shouldLogout = false})` method in `TencentCloudChatCoreController` to ensure no data residue in UIKit after logging out and avoid logout twice after been kicked off. For specific usage, refer to the comment.
- Added SVG support for avatars.

## Conversation (TencentCloudChatConversation)

- Optimized time display in conversation items for better readability.
- Fixed the issue where the conversation unread count could not be updated dynamically.

## Message (TencentCloudChatMessage)

- Added support for navigating to the original message for quoted messages on mobile devices by long-pressing and on desktop devices by clicking.
- Improved message positioning and navigation capabilities, including jumping to specific messages. Optimized performance and user experience. Exposed this capability through the `scrollToSpecificMessage` method in `TencentCloudChatMessageController`, which allows controlling navigation to specific messages with the option to highlight the target message.
- Removed the ability to download large images and view original images in image preview mode.
- Optimized the calculation of message long-press menu height for greater accuracy, avoiding situations where menu items are not fully displayed. Also improved animation performance.
- Added `showMessageTimeIndicator`, `showMessageStatusIndicator`, `defaultMessageSelectionOperationsConfig`, and `defaultMessageMenuConfig` to `TencentCloudChatMessageConfig` for better customization of message bubbles, message selection menus, and message menus. For specific usage, refer to the comments for each parameter.
- Removed `useGroupMessageReadReceipt` from `TencentCloudChatMessageConfig`. Please use `enabledGroupTypesForMessageReadReceipt` instead.
- Improved the display position of text message status and time indicators, no longer occupying a separate column.
- Enhanced the default time divider in the message list to support localized and internationalized date and time representations.
- Resolved issues related to media preview and voice message functionality.
- Fixed several bugs, reduced redundant page builds, enhanced performance, and minimized CPU and memory resource usage.

## Contact (TencentCloudChatContact)

- Resolved the issue of contact names being too long and overflowing the boundaries.

# 1.1.2

## General

- Further enhanced the integration process.

- Optimized screen type recognition for better adaptation to different screen types.

## Conversation *(TencentCloudChatConversation)*

- Added a new `onTap` event, `onTapConversationItem`, to `TencentCloudChatConversationUIEventHandlers` of `TencentCloudChatConversationEventHandlers` on the `eventHandlers`.This allows for custom event handling when a conversation item is clicked. If it returns false, the default navigation will be executed, to the corresponding `TencentCloudChatMessage` widget.

- Introduced a new builder, `conversationHeaderBuilder`, for customizing the header bar.

## Message *(TencentCloudChatMessage)*

- Enhanced message list with localized date and time indicators, adapting to user's language settings for a localization experience.

# 1.1.1

* Enhanced the integration process by reducing the number of steps, increasing the success rate of one-time integration, and lowering the barrier to entry.

# 1.1.0+1

* Open-sourced on [GitHub repo](https://github.com/TencentCloud/chat-uikit-flutter/tree/v2/tencent_cloud_chat_common).

# 1.1.0

Introducing the first release of the brand new Tencent Cloud Chat UIKit.

Compared with the old version, this release brings several noteworthy enhancements:

1. **Theme Customization**: Switch between **light and dark mode** on the fly, or customize your own theme with our rich set of options.

2. **Internationalization**: We've added support for more languages including Arabic, and introduced **a Middle Eastern UI**. Our powerful and user-friendly [localization tools](https://pub.dev/packages/tencent_cloud_chat_intl) make it easier than ever to [customize the localization configuration and the translation](https://pub.dev/packages/tencent_cloud_chat_intl), and provide a localized user experience.

3. **Performance Enhancements**: We've made significant improvements to the **performance of the message list**, and introduced efficient and precise message positioning capabilities.

4. **Multimedia Support**: Experience improved multimedia and file message handling, with continuous playback for voice messages and **swipeable multimedia message previews**.

5. **Detail Optimizations**: We've added numerous detail optimizations including rich animations, haptic feedback, and refined interfaces to enhance the user experience.

6. **New Features**: Enjoy new features like a grid-style avatar, redesigned forwarding panel, group member selector, and a new message long-press menu.

7. **Modular Packages**: Components are broken down into **modular packages**, allowing for on-demand imports and reducing unnecessary bloat.
   Each modular package supports built-in navigation transitions. For instance, you can automatically navigate from a Conversation to a Message to start a chat,
   without the need to manually instantiate multiple pages and handle the transitions yourself. This greatly simplifies the complexity of development and integration.

8. **Developer-friendly Design**: We've introduced a more unified, standardized component parameter design, clearer code naming, and more detailed comments to make development easier and more efficient.

We're excited for you to try out our new Flutter Chat UIKit and look forward to seeing the amazing applications you'll create with it!

