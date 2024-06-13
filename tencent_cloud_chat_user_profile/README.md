# Tencent Cloud Chat UIKit User Profile Component

The User Profile component of the Tencent Cloud Chat UIKit is designed to enrich your chat applications with a detailed user profile page. 

This component not only displays user information such as avatar, nickname, and other basic details, but also provides a wide range of functionalities for relationship management and more. 

Users can set remarks for their contacts, add or remove contacts, block users, and perform various other actions. The component also facilitates the configuration of conversation settings, including pinning conversations and managing message notifications.

When integrated with the [tencent_cloud_chat_message](https://pub.dev/packages/tencent_cloud_chat_message) component, the User Profile component ensures seamless navigation between the Message and User Profile pages, eliminating the need for manual navigation implementation.

Additionally, when paired with the [tencent_calls_uikit](https://pub.dev/packages/tencent_calls_uikit), it allows users to initiate voice and video calls directly from the User Profile page, further enhancing the overall communication experience.

With its intuitive design and robust features, the User Profile component caters to a wide range of user requirements and preferences, ensuring a smooth and engaging user experience.

## Getting Started

### Import and Declare

To begin, add the [tencent_cloud_chat_user_profile](https://pub.dev/packages/tencent_cloud_chat_user_profile) UI module to your project.

Once installed, you'll need to register this UI component within the `usedComponentsRegister` parameter of the `TencentCloudChat.controller.initUIKit` method's `components`. Here's an example:

```dart
    await TencentCloudChat.controller.initUIKit(
      components: TencentCloudChatInitComponentsRelated(
        usedComponentsRegister: [
          TencentCloudChatUserProfileManager.register, /// Add this line
          /// ...
        ],
      /// ...
      ),
      /// ...
    );
```

If your project incorporates modular components like [tencent_cloud_chat_message](https://pub.dev/packages/tencent_cloud_chat_message) for displaying conversation, they will automatically navigate to this User Profile component.

If navigation is only required from these built-in components and not from your custom pages, the `User Profile` component integration is complete with this single step. The UIKit handles navigation transitions internally, eliminating the need for manual coding.

For projects that require navigation from custom pages, refer to the following steps.

### Navigating to the User Profile Component

Before navigating, prepare a `TencentCloudChatUserProfileOptions` instance to specify the target user:

```dart
final userProfileOptions = TencentCloudChatUserProfileOptions(
      userID: "", // Provide the user's userID
    );
```

#### Easy Navigation with One Line of Code

Simply call the `navigateToUserProfile` method to navigate to the User Profile component effortlessly:

```dart
/// Use the userProfileOptions constructed above
navigateToUserProfile(context: context, options: userProfileOptions);
```

#### Manual Navigation

If you need to manually handle navigation, or wrap the component within your custom page, start by instantiating a `TencentCloudChatUserProfile` component.

This provides you with greater control and flexibility when integrating the User Profile component into your application:

```dart
    final userProfile = TencentCloudChatUserProfile(
      // Be sure to provide options. Use the userProfileOptions constructed above.
      options: userProfileOptions,

      // Other parameters, such as builders, can be specified globally or passed in statically here, depending on your requirements. For detailed usage, refer to the parameter and method comments.
    );
```

You can place this instantiated component in the `build` method of a separate page or use it directly for navigation like using `Navigator.push`.

### Customizing Details

#### Using config

For simple and basic configurations, you can use the `config` parameter. The `config` for the Contact component is provided by the `TencentCloudChatUserProfileConfig` class.

It includes control options for various data types such as booleans, integers, and custom parameters.

#### Using builders

For more in-depth UI customization, you can use custom builders. The builders for the Contact component are provided by the `TencentCloudChatUserProfileBuilders` class.

## Conclusion

We hope this documentation provides you with a comprehensive understanding of the User Profile component within the Tencent Cloud Chat UIKit. By leveraging the customization options and features available, you can create a tailored chat experience that meets your specific requirements.

If you have any questions or need further information, feel free to reach out us.

- [Telegram](https://t.me/+gvScYl0uQ3U4MTRl)
- [X (Twitter)](https://x.com/runlin_wang95)
