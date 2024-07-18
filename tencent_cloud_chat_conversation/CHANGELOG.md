## 1.5.0

### General

* Upgraded the underlying Flutter Chat SDK, as well as the iOS and Android Chat SDKs, to version 8.0.
* Migrated group data storage to a global LRU-optimized cache, improving the integration between TencentCloudChatMessage
  and TencentCloudChatGroupProfile components.

## 1.4.1

### General
* Enhanced performance on the Web.

## 1.4.0

### General

* **[Breakthrough]**: Added comprehensive support for **Web**, including both Mobile and Desktop browsers.
* Added support to return the login status for the `initUIKit` method.
* Added `addGlobalCallback` and `removeGlobalCallback` to `TencentCloudChatCoreController`, enabling the integration and management of custom `TencentCloudChatCallbacks` throughout your codebase.
* Improved device screen recognition logic.

## 1.3.1

### General

- Added support to Flutter 3.22.

## 1.3.0

### General

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

## 1.2.1

### Conversation (TencentCloudChatConversation)

- Fixed an issue where the main widget was being disposed on desktop after switching login accounts.
- Changed the button `Mark as Unread` to `Mark as Read` and its functionality has been implemented.

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

## 1.1.2

### General

- Further enhanced the integration process.

- Optimized screen type recognition for better adaptation to different screen types.

### Conversation *(TencentCloudChatConversation)*

- Added a new `onTap` event, `onTapConversationItem`, to `TencentCloudChatConversationUIEventHandlers` of `TencentCloudChatConversationEventHandlers` on the `eventHandlers`.This allows for custom event handling when a conversation item is clicked. If it returns false, the default navigation will be executed, to the corresponding `TencentCloudChatMessage` widget.

- Introduced a new builder, `conversationHeaderBuilder`, for customizing the header bar.

## 1.1.1

* Enhanced the integration process by reducing the number of steps, increasing the success rate of one-time integration, and lowering the barrier to entry.

## 1.1.0+1

* Open-sourced on [GitHub repo](https://github.com/TencentCloud/chat-uikit-flutter/tree/v2/tencent_cloud_chat_conversation).

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

