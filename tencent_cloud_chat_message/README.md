# Tencent Cloud Chat UIKit Message Component

Welcome to the Message component of the Tencent Cloud Chat UIKit. This component is engineered to enrich your chat applications with a comprehensive messaging experience, offering both essential and advanced chat functionalities.

The Message component is composed of several key elements, including a header for displaying conversation information, a message list view for showcasing message history, and a message input for facilitating message sending. To elevate the user experience, it comes packed with rich animations and interactive details.

At its foundation, the component provides essential chat functionalities such as sending, receiving, copying, forwarding, previewing, and deleting messages, ensuring a seamless chat experience. 

To accommodate diverse user needs, it also includes advanced features. Such as message context menu, marking messages as read, displaying group read receipt details, and supporting emoji reactions, to facilitating precise navigation to specific messages, enabling message multi-selection, and offering extensive customization capabilities.

When used in conjunction with the [tencent_cloud_chat_conversation](https://pub.dev/packages/tencent_cloud_chat_conversation) and [tencent_cloud_chat_contact](https://pub.dev/packages/tencent_cloud_chat_contact) components, the Message component enables seamless navigation, eliminating the need for manual navigation implementation. Furthermore, when integrated with the [tencent_calls_uikit](https://pub.dev/packages/tencent_calls_uikit), it provides the ability to initiate voice/video calls, thus enhancing the overall communication experience.

In essence, the Message component empowers you to create engaging, feature-rich chat applications that cater to various user requirements and deliver a delightful user experience.

## Getting Started

### Import and Declare

To begin, add the [tencent_cloud_chat_message](https://pub.dev/packages/tencent_cloud_chat_message) UI module to your project.

Once installed, you'll need to register this UI component within the `usedComponentsRegister` parameter of the `TencentCloudChat.controller.initUIKit` method's `components`. Here's an example:

```dart
    await TencentCloudChat.controller.initUIKit(
      components: TencentCloudChatInitComponentsRelated(
        usedComponentsRegister: [
          TencentCloudChatMessageManager.register, /// Add this line
          /// ...
        ],
      /// ...
      ),
      /// ...
    );
```

If your project incorporates modular components like [tencent_cloud_chat_conversation](https://pub.dev/packages/tencent_cloud_chat_conversation) or [tencent_cloud_chat_contact](https://pub.dev/packages/tencent_cloud_chat_contact) for displaying conversation, contact, or group lists, they will automatically navigate to the Message component from those lists. 

If navigation is only required from these built-in components and not from your custom pages, the `Message` component integration is complete with this single step. The UIKit handles navigation transitions internally, eliminating the need for manual coding.

For projects that require navigation from custom pages, refer to the following steps.

### Navigating to the Message Component

Before navigating, prepare a `TencentCloudChatMessageOptions` instance to specify the conversation for the chat:

```dart
final messageOptions = TencentCloudChatMessageOptions(
      // Provide either userID or groupID, indicating the conversation for the chat.
      userID: "", // For one-on-one chats, provide the other user's userID
      groupID: "", // For group chats, provide the groupID
    );
```

#### Easy Navigation with One Line of Code

Simply call the `navigateToMessage` method to navigate to the Message component effortlessly:

```dart
/// Use the messageOptions constructed above
navigateToMessage(context: context, options: messageOptions);
```

#### Manual Navigation

If you need to manually handle navigation, wrap the component within your custom page, or utilize custom features such as `TencentCloudChatMessageController`, start by instantiating a `TencentCloudChatMessage` component. 

This provides you with greater control and flexibility when integrating the Message component into your application:

```dart
// If you need to use the controller, maintain a TencentCloudChatMessageController instance.
final TencentCloudChatMessageController messageController = TencentCloudChatMessageController();

final message = TencentCloudChatMessage(
      // Be sure to provide options. Use the messageOptions constructed above.
      options: messageOptions,

      // If you need to use the controller, provide a controller instance.
      controller: messageController,

      // Other parameters, such as builders, can be specified globally or passed in statically here, depending on your requirements. For detailed usage, refer to the parameter and method comments.
    );
```

You can place this instantiated component in the `build` method of a separate page or use it directly for navigation like using `Navigator.push`.

If you use `TencentCloudChatMessageController`, it is recommended to maintain it within the `State` of a `StatefulWidget`, using a single instance to control the component. For specific usage, refer to the internal comments.

### Customizing Details

You can use `builders` and `config` to customize various aspects of the Message component. Both options provide different levels of customization, allowing you to tailor the component to your specific needs.

#### Using config

For simple and basic configurations, you can use the `config` parameter. The `config` for the Message component is provided by the `TencentCloudChatMessageConfig` class.

It includes control options for various data types such as booleans, integers, and custom parameters. Each control option is a method `T Function({String? userID, String? groupID})` that provides the current conversation's `userID` or `groupID` information. You can use these fields to return the appropriate configuration values.

This approach allows you to define a global `TencentCloudChatMessageConfig` class that will be effective during the automatic navigation process, without the need to manually instantiate a `TencentCloudChatMessage` instance and pass it in. This is because, in most cases, different types of conversations require different configuration parameters.

Here's an example:

```dart
    final messageConfig = TencentCloudChatMessageConfig(
        // Demonstrating one configuration option.
        // Whether to show other users' avatars in the message list.
        showOthersAvatar: ({userID, groupID}){
          if(userID!=null&&userID.isNotEmpty){
            // If it's a one-on-one chat, don't show the other user's avatar since it's already in the header.
            return false;
          }
          // If it's a group chat, show other users' avatars.
          return true;
        }
    );
```

#### Using builders

For more in-depth UI customization, you can use custom builders. The builders for the Message component are provided by the `TencentCloudChatMessageBuilders` class.

The Message component provides an overall `MessageLayoutBuilder`, which is further divided into three main builders: `MessageListViewBuilder` for displaying the message list, `MessageInputBuilder` for displaying the message input area, and `MessageHeaderBuilder` for displaying the top area. They all basically expose the `String? userID` and `String? groupID` parameters, helping you determine different UI styles based on the conversation type during the automatic navigation process same as `config`.

In addition to these, there are more granular builders to help you customize finer details, such as message rendering and message layout.

Additionally, each builder comes with the required parameters and methods, making data and logic layer methods readily available for use. For example, the `messageInputBuilder` exposes various parameters such as methods for sending different types of messages, current conversation details, group member lists, and more. This allows you to focus on the input area's UI development and directly call the methods we provide for sending messages, speeding up your development process.

## Conclusion

We hope this documentation provides you with a comprehensive understanding of the Message component within the Tencent Cloud Chat UIKit. 

By leveraging the customization options and features available, you can create a tailored chat experience that meets your specific requirements. 

Should you have any questions or need additional information, please feel free to reach out us.

- [Telegram](https://t.me/+gvScYl0uQ3U4MTRl)
- [X (Twitter)](https://x.com/runlin_wang95)
