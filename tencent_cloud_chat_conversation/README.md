# Tencent Cloud Chat UIKit Conversation Component

Introducing the Conversation component of the Tencent Cloud Chat UIKit, designed to provide a versatile conversation list for your chat applications that seamlessly adapts to both desktop and mobile environments.

The Conversation component offers a conversation list that displays all participated conversations, sorted by the last active time. It also supports managing conversation information, ensuring a smooth and organized chat experience.

When used in conjunction with the [tencent_cloud_chat_message](https://pub.dev/packages/tencent_cloud_chat_message) component, the Conversation component enables automatic navigation to the corresponding message chat page upon tapping a conversation on mobile devices. On desktop environments, the Message chat page appears in the right-side area, allowing for dynamic switching between conversations.

## Getting Started

### Import and Declare

To begin, add the [tencent_cloud_chat_conversation](https://pub.dev/packages/tencent_cloud_chat_conversation) UI module to your project.

Once installed, you'll need to register this UI component within the `usedComponentsRegister` parameter of the `TencentCloudChat.controller.initUIKit` method's `config`. Here's an example:

```dart
    await TencentCloudChat.controller.initUIKit(
      config: TencentCloudChatConfig(
        usedComponentsRegister: [
          TencentCloudChatConversationInstance.register, /// Add this line
          /// ...
        ],
      /// ...
      ),
      /// ...
    );
```

### Instantiate and Use the Component

Using the Conversation component is straightforward. Simply instantiate a `TencentCloudChatConversation` instance and render it on the desired page.

By default, the component will automatically fetch and display all conversation information without requiring any additional parameters.

You can use this instance in the `build` method of the page where you want to display the conversation list.

```dart
  @override
  Widget build(BuildContext context) {
    return const TencentCloudChatConversation();
  }
```

With just a few lines of code, you can easily integrate the Conversation component into your chat application and display a list of conversations for users to interact with.

### Customizing Details

#### Using config

For simple and basic configurations, you can use the `config` parameter. The `config` for the Conversation component is provided by the `TencentCloudChatConversationConfig` class.

It includes control options for various data types such as booleans, integers, and custom parameters. 

For instance, the `useDesktopMode` configuration determines whether, in a desktop environment and when used in conjunction with the [tencent_cloud_chat_message](https://pub.dev/packages/tencent_cloud_chat_message) component, the component should span the full horizontal space, displaying the conversation list on the left and the `Message` component for the currently selected conversation on the right, with support for dynamic switching.

#### Using builders

For more in-depth UI customization, you can use custom builders. The builders for the Conversation component are provided by the `TencentCloudChatConversationBuilders` class.

The Conversation component provides several builders, like `ConversationItemAvatarBuilder` for displaying the avatar on conversation items, `ConversationItemContentBuilder` for displaying content in conversation items, and `ConversationItemInfoBuilder` for displaying the info within conversation items.

## Conclusion

We hope this documentation provides you with a comprehensive understanding of the Conversation component within the Tencent Cloud Chat UIKit. By leveraging the customization options and features available, you can create a tailored chat experience that meets your specific requirements.
