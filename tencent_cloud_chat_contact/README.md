# Tencent Cloud Chat UIKit Contact Component

Introducing the Contact component of the Tencent Cloud Chat UIKit, designed to provide a versatile contact list for your chat applications.

The Contact component offers a contact list that displays all added contacts, sorted by the initial letter of their names. It also supports displaying additional information such as joined group lists, blocked user lists, users who have requested to add you as a contact, and group message notifications.

When used in conjunction with the [tencent_cloud_chat_message](https://pub.dev/packages/tencent_cloud_chat_message) component, the Contact component enables automatic navigation to the corresponding message chat page upon tapping a contact or a group on both mobile and desktop environments. This seamless integration ensures a smooth and organized chat experience for your users.

## Getting Started

### Import and Declare

To begin, add the [tencent_cloud_chat_conversation](https://pub.dev/packages/tencent_cloud_chat_conversation) UI module to your project.

Once installed, you'll need to register this UI component within the `usedComponentsRegister` parameter of the `TencentCloudChat.controller.initUIKit` method's `config`. Here's an example:

```dart
    await TencentCloudChat.controller.initUIKit(
      config: TencentCloudChatConfig(
        usedComponentsRegister: [
          TencentCloudChatContactInstance.register, /// Add this line
          /// ...
        ],
      /// ...
      ),
      /// ...
    );
```

### Instantiate and Use the Component

Using the Contact component is straightforward. Simply instantiate a `TencentCloudChatContact` instance and render it on the desired page.

By default, the component will automatically fetch and display all contact information without requiring any additional parameters.

You can use this instance in the `build` method of the page where you want to display the contact list, along with the entry to joined group lists, blocked user lists, users who have requested to add you as a contact, and group message notifications.

```dart
  @override
  Widget build(BuildContext context) {
    return const TencentCloudChatContact();
  }
```

With just a few lines of code, you can easily integrate the Contact component into your chat application for users to interact with.

### Customizing Details

#### Using config

For simple and basic configurations, you can use the `config` parameter. The `config` for the Contact component is provided by the `TencentCloudChatContactConfig` class.

It includes control options for various data types such as booleans, integers, and custom parameters.

#### Using builders

For more in-depth UI customization, you can use custom builders. The builders for the Contact component are provided by the `TencentCloudChatContactBuilders` class.

## Conclusion

We hope this documentation provides you with a comprehensive understanding of the Contact component within the Tencent Cloud Chat UIKit. By leveraging the customization options and features available, you can create a tailored chat experience that meets your specific requirements.

