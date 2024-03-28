## 1.2.0

### General

- Added support for tablet devices, including adaptive UI for iPad and various Android tablets. Now you can deploy to all platforms (mobile, pad, desktop, web) with a single codebase and code once.
- Introduced callback functionality, allowing handling of SDK API errors and specific UIKit events that require user attention with `eventCode` and `text` by default, on a global scale. Developers can initialize UIKit with `TencentCloudChatCoreController.initUIKit()` and set up the callbacks accordingly.
- Enhanced global dialog style for Apple devices with a more native-looking Cupertino style.
- Optimized global data storage structure and improved underlying performance.
- Ensured that all data from the previous account is removed from memory after logging out, and no data remains when logging in with a new account.
  Replaced the original `logout` method with the `resetUIKit({bool shouldLogout = false})` method in `TencentCloudChatCoreController` to ensure no data residue in UIKit after logging out and avoid logout twice after been kicked off. For specific usage, refer to the comment.
- Added SVG support for avatars.

### Conversation (TencentCloudChatConversation)

- Optimized time display in conversation items for better readability.
- Fixed the issue where the conversation unread count could not be updated dynamically.

### Message (TencentCloudChatMessage)

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

### Contact (TencentCloudChatContact)

- Resolved the issue of contact names being too long and overflowing the boundaries.

## 1.1.2

### General

- Further enhanced the integration process.

- Optimized screen type recognition for better adaptation to different screen types.

### Conversation *(TencentCloudChatConversation)*

- Added a new `onTap` event, `onTapConversationItem`, to `TencentCloudChatConversationUIEventHandlers` of `TencentCloudChatConversationEventHandlers` on the `eventHandlers`.This allows for custom event handling when a conversation item is clicked. If it returns false, the default navigation will be executed, to the corresponding `TencentCloudChatMessage` widget.

- Introduced a new builder, `conversationHeaderBuilder`, for customizing the header bar.

### Message *(TencentCloudChatMessage)*

- Enhanced message list with localized date and time indicators, adapting to user's language settings for a localization experience.

## 1.1.1

* Enhanced the integration process by reducing the number of steps, increasing the success rate of one-time integration, and lowering the barrier to entry.

## 1.1.0+1

* Open-sourced on [GitHub repo](https://github.com/TencentCloud/chat-uikit-flutter/tree/v2/tencent_cloud_chat_common).

## 1.1.0

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

