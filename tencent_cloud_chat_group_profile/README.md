# Tencent Cloud Chat UIKit Group Profile Component

Welcome to the Group Profile component of the Tencent Cloud Chat UIKit. This component is designed to enhance your chat applications with a detailed and interactive group profile page.

The Group Profile component provides a comprehensive view of group information, such as group avatar, group ID, member list, group type, and group announcements, among other features.

In addition to displaying group information, this component also facilitates various group management tasks. For group owners or administrators, it offers functionalities such as managing the member list (including inviting or removing members), editing group announcements, and performing other group management operations like group muting, to name a few.

Moreover, it allows users to manage conversation settings related to the group, including but not limited to pinning conversations, managing message notifications, and leaving the group chat.

When used in conjunction with the [tencent_cloud_chat_message](https://pub.dev/packages/tencent_cloud_chat_message) component, the Group Profile component ensures seamless navigation between the Message and Group Profile pages, eliminating the need for manual navigation implementation.

With its intuitive design and robust features, the Group Profile component caters to a wide range of user requirements and preferences, ensuring a smooth and engaging group chat experience.

## Getting Started

### Import and Declare

To begin, add the [tencent_cloud_chat_group_profile](https://pub.dev/packages/tencent_cloud_chat_group_profile) UI module to your project.

Once installed, you'll need to register this UI component within the `usedComponentsRegister` parameter of the `TencentCloudChat.controller.initUIKit` method's `config`. Here's an example:

```dart
    await TencentCloudChat.controller.initUIKit(
      config: TencentCloudChatConfig(
        usedComponentsRegister: [
          TencentCloudChatGroupProfileInstance.register, /// Add this line
          /// ...
        ],
      /// ...
      ),
      /// ...
    );
```

If your project incorporates modular components like [tencent_cloud_chat_message](https://pub.dev/packages/tencent_cloud_chat_message) for displaying conversation, they will automatically navigate to this Group Profile component.

If navigation is only required from these built-in components and not from your custom pages, the `Group Profile` component integration is complete with this single step. The UIKit handles navigation transitions internally, eliminating the need for manual coding.

For projects that require navigation from custom pages, refer to the following steps.

### Navigating to the Group Profile Component

Before navigating, prepare a `TencentCloudChatGroupProfileOptions` instance to specify the target user:

```dart
final groupProfileOptions = TencentCloudChatGroupProfileOptions(
  groupID: "", // Provide the groupID
    );
```

#### Easy Navigation with One Line of Code

Simply call the `navigateToUserProfile` method to navigate to the Group Profile component effortlessly:

```dart
/// Use the userProfileOptions constructed above
navigateToGroupProfile(context: context, options: groupProfileOptions);
```

#### Manual Navigation

If you need to manually handle navigation, or wrap the component within your custom page, start by instantiating a `TencentCloudChatUserProfile` component.

This provides you with greater control and flexibility when integrating the Group Profile component into your application:

```dart
    final groupProfile = TencentCloudChatGroupProfile(
      // Be sure to provide options. Use the groupProfileOptions constructed above.
      options: groupProfileOptions,

      // Other parameters, such as builders, can be specified globally or passed in statically here, depending on your requirements. For detailed usage, refer to the parameter and method comments.
    );
```

You can place this instantiated component in the `build` method of a separate page or use it directly for navigation like using `Navigator.push`.

### Customizing Details

#### Using config

For simple and basic configurations, you can use the `config` parameter. The `config` for the Contact component is provided by the `TencentCloudChatGroupProfileConfig` class.

It includes control options for various data types such as booleans, integers, and custom parameters.

#### Using builders

For more in-depth UI customization, you can use custom builders. The builders for the Contact component are provided by the `TencentCloudChatGroupProfileBuilders` class.

## Conclusion

We hope this documentation provides you with a comprehensive understanding of the Group Profile component within the Tencent Cloud Chat UIKit. By leveraging the customization options and features available, you can create a tailored chat experience that meets your specific requirements.
