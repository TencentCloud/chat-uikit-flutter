
# Tencent Cloud Chat UIKit V2

This is the brand new Flutter Chat UIKit V2 developed by Tencent Cloud Chat. We're excited to introduce this completely redesigned and redeveloped toolkit, built from the ground up, two years after the release of our previous version, [tencent_cloud_chat_uikit](https://pub.dev/packages/tencent_cloud_chat_uikit) (named [tim_ui_kit](https://pub.dev/packages/tim_ui_kit) previously).

Tencent Cloud new Flutter Chat UIKit is designed to provide developers with a comprehensive set of tools to create feature-rich chat applications with ease. 

It is built with a modular approach, allowing you to pick and choose the components you need while keeping your application lightweight and efficient. 

The UIKit includes a wide range of capabilities, such as [Conversation List](https://pub.dev/packages/tencent_cloud_chat_conversation), [Message handling](https://pub.dev/packages/tencent_cloud_chat_message), 
[Contact lists](https://pub.dev/packages/tencent_cloud_chat_contact), [User](https://pub.dev/packages/tencent_cloud_chat_user_profile) and [Group Profiles](https://pub.dev/packages/tencent_cloud_chat_group_profile), Search functionality, and more.

![uikit.png](https://comm.qq.com/im/static-files/uikit.jpg)

## Features

1. **Personalized Appearance**: With built-in **dark and light** modes, the UIKit offers a variety of **theme and appearance customization** options to meet your business needs.
2. **Multi-Platform Compatibility**: The adaptable single codebase ensures compatibility across various platforms, including **Mobile** devices (iOS/Android), **Tablets** (iPad and Android tablets), **Web** browsers, and **Desktop** environments (Windows/macOS).
3. **Localization Support**: Developed with native English and additional language options, including Arabic, Japanese, Korean, Simplified Chinese, and Traditional Chinese. The internationalization features ensure a localized interface language and support custom and **supplementary language**, with Arabic support for **RTL** UI.
4. **Enhanced Performance**: The UIKit delivers improved message list **performance**, **memory usage**, and precise message positioning capabilities, catering to scenarios with large message volumes and navigation to older messages.
5. **Advanced Features**: Boasting numerous advanced capabilities, the UIKit includes continuous voice message playback, enhanced multimedia and file message experiences, and intuitive left-right swiping for multimedia message previews.
6. **Refined User Experience**: Detail optimizations such as rich **animations**, **haptic feedback**, and **a polished interface** contribute to an improved user experience. New features like grid-style avatars, redesigned forwarding panels, group member selectors, and revamped long-press message menus further enrich the experience.
7. **Modular Design**: Components are organized into modular packages, allowing for selective importing and reducing unnecessary bloat. Each package supports **built-in navigation transitions**, streamlining development and integration by automatically handling transitions, such as between Conversation and Message.
8. **Developer-Friendly Approach**: A more unified, standardized component parameter design, clearer code naming conventions, and detailed comments, combined with the flexibility to choose **global or instance-level configuration** management, make development easier and more efficient.

## Compatibility

This UIKit supports mobile, tablet, and desktop UI styles, and is compatible with Android, iOS, macOS, Windows, and Web *(support coming in future versions)*.

It comes with built-in support for English, Simplified Chinese, Traditional Chinese, Japanese, Korean, and Arabic languages (with support for Arabic RTL interface), and light and dark appearance styles.

## Requirements

- Flutter version: 3.16 or above
- Dart version: 3.0 or above

## Getting Started

To start using our UIKit, first import the base package, [tencent_cloud_chat](https://pub.dev/packages/tencent_cloud_chat).

Next, import the required UI component packages that suit your needs from the following list:

- [tencent_cloud_chat_message](https://pub.dev/packages/tencent_cloud_chat_message)
- [tencent_cloud_chat_conversation](https://pub.dev/packages/tencent_cloud_chat_conversation)
- [tencent_cloud_chat_contact](https://pub.dev/packages/tencent_cloud_chat_contact)
- [tencent_cloud_chat_user_profile](https://pub.dev/packages/tencent_cloud_chat_user_profile) 
- [tencent_cloud_chat_group_profile](https://pub.dev/packages/tencent_cloud_chat_group_profile) 
- [tencent_cloud_chat_search](https://pub.dev/packages/tencent_cloud_chat_search) _(Coming Soon)_

The architecture of our UIKit is shown below:

![](https://comm.qq.com/im/static-files/uikit_structure.png)

## Basic Usage

Before you start using each Modular Package UI component, there are some initial setup steps you need to follow in your project.

1. Prepare the necessary Tencent Cloud Chat configuration information, such as sdkappid, test userID, userSig, etc. You can refer to this document: [https://www.tencentcloud.com/document/product/1047/45907#.E5.89.8D.E5.BA.8F.E5.B7.A5.E4.BD.9C](https://www.tencentcloud.com/document/product/1047/45907#.E5.89.8D.E5.BA.8F.E5.B7.A5.E4.BD.9C)
2. **Packages installing:**
  In your Flutter project, install the main package and the optional modular packages mentioned in the Getting Started section.
3. **Global configuration:**
  Import `TencentCloudChatMaterialApp`: Replace your project's `MaterialApp` with `TencentCloudChatMaterialApp`. This enables automatic management and configuration of the language, theme *(with material3)*, theme mode, and other settings, ensuring that the UIKit's interface parameters are consistent with your project.
  This step will take over the language, theme, and theme mode configuration of your project. 
  If you do not want the automatic management of the configuration for your project, you can manually import the features you need into your project according to the **[Implement the global configuration for UIKit manually](https://www.tencentcloud.com/document/product/1047/58585#ab6bd508-218a-4002-9b76-0ee081e8929a)**.
4. **Initialization and Login**:

Call the `TencentCloudChat.controller.initUIKit` method to initialize and log in. The instructions and reference code are as follows, paying attention to description:
```dart
await TencentCloudChat.controller.initUIKit(
  config: TencentCloudChatConfig(), /// [Optional]: The global configurations that affecting the whole Chat UIKit, including user-related configs, theme-related configs, etc.
  options: TencentCloudChatInitOptions(
    sdkAppID: , /// [Required]: The SDKAppID of your Tencent Cloud Chat application
    userID: , /// [Required]: The userID of the logged-in user
    userSig: , /// [Required]: The userSig of the logged-in user
  ),

  components: TencentCloudChatInitComponentsRelated( /// [Required]: The modular UI components related settings, taking effects on a global scale.
    usedComponentsRegister: [
      /// [Required]: List of registration functions for the components used in the Chat UIKit.
      TencentCloudChatConversationManager.register,
      TencentCloudChatMessageManager.register,
      /// ...... 
      /// The above registers are examples. In this field, pass in the register of each sub Modular UI Package.
      /// After installing each sub Modular UI Package, you need to declare it here before you can use it.
    ],
    componentConfigs: TencentCloudChatComponentConfigs(
      /// [Optional]: Provide your custom configurations for each UI modular component here. These builders will be applied globally.
    ),
    componentBuilders: TencentCloudChatComponentBuilders(
      /// [Optional]: Provide your custom UI builders for each UI modular component here. These builders will be applied globally.
    ),
    componentEventHandlers: TencentCloudChatComponentEventHandlers(
      /// [Optional]: Provide your custom event handlers for UI component-related events here. These builders will be applied globally.
    ),
  ),

  /// **[Critical]**: It's strongly advised to incorporate the following callback listeners for effectively managing SDK events, SDK API errors and specific UIKit events that demand user attention.
  /// For detailed usage, please refer to the 'Introducing Callbacks for UIKit' section at the end of this README.
  callbacks: TencentCloudChatCallbacks(
    onTencentCloudChatSDKEvent: V2TimSDKListener(),  /// [Optional]: Handles SDK events, such as `onKickedOffline` and `onUserSigExpired`, etc.
    onTencentCloudChatSDKFailCallback: (apiName, code, desc) {}, /// [Optional]: Handles SDK API errors.
    onTencentCloudChatUIKitUserNotificationEvent: (TencentCloudChatComponentsEnum component, TencentCloudChatUserNotificationEvent event) {}, /// [Optional]: Handles specific UIKit events that require user attention on a global scale.
  ),
  
  plugins: [],  /// [Optional]: Used plugins, such as tencent_cloud_chat_robot, etc. For specific usage, please refer to the README of each plugin.
);
```

Once you have completed the basic integration process of the UIKit, you can proceed to explore the READMEs of each Modular Package to complete the integration of the individual UI components. 

This will help you understand the specific usage and customization options for each component, allowing you to create a tailored chat application that meets your requirements.

### Common Usage for Modular UI Packages

In most use cases, you'll need to manually instantiate and add the`TencentCloudChatConversation` and `TencentCloudChatContact` components to a widget, if necessary.
Other components are automatically navigated based on user actions, as long as they have been declared in the `usedComponentsRegister` within the `components` parameter during the `initUIKit` call.

To integrate these two basic components, simply instantiate them and return them in a `build` method without any additional configuration parameters.

## Advanced Usage

### Advanced Usage for Modular UI Packages

#### Component Input Parameters

Each Modular UI Component Package provides four unified input parameters:

- **options**: Component-specific parameters that ensure proper functionality. Some generic components might not need this parameter.
- **config**: A set of component-specific configurations for fine-grained customization, such as adjusting the attachment area configuration for the Message component.
- **builders**: A collection of methods for building widgets within the component, enabling external UI customization. Each builder includes the necessary parameters and methods, making data and logic layer methods readily available. _For details, please refer to the following **Customizing UI Widgets** section._
- **eventHandlers**: Callbacks for handling component-specific events, including `uiEventHandlers` (e.g., various `onTap`-like events) and `lifeCycleEventHandlers` (e.g., events triggered after a message has been sent). These handlers allow for custom behavior in response to user interactions and component lifecycle changes.

Note:

The `options` parameters should be specified in the component constructor. Currently, only `TencentCloudChatMessage`, `TencentCloudChatUserProfile`, and `TencentCloudChatGroupProfile` components require this parameter, used for specifying a target user or group.

The other three parameters can be specified either in the component constructor for a specific component instance or globally in the `components` parameter during the `initUIKit` call or managed from the Manager of each Component, affecting all instances of the corresponding component. 
For the integration process, we recommend using the global configuration approach, as described in the following sections.

#### Global: Configuring Components

Each component offers a set of component-specific configurations for fine-grained customization, such as adjusting the attachment area configuration for the Message component.

There are two methods for customizing configurations on a global scale: during `initUIKit` and using the manager.

- **During init**: Define configurations during the `initUIKit` call using the `components` parameter with `componentConfigs` specified for each modular UI component.
- **By Manager**: Utilize each component's manager to dynamically modify configurations from any location within the codebase.

To dynamically modify the configurations for all instances of the corresponding component, follow these steps:

1. Access the global `config` instance from the component's manager by appending `Manager` to the component's name (e.g., `TencentCloudChatMessageManager`).
2. Invoke the `setConfigs` method and pass any configurations to be modified. This will replace the previous configuration and apply changes immediately.

For example, you can use the `config` from the `TencentCloudChatConversation` component by accessing it through the `TencentCloudChatConversationManager` object (e.g., `TencentCloudChatConversationManager.controller`) to modify some configurations:

```dart
TencentCloudChatConversationManager.config.setConfigs(
    useDesktopMode: true,
);
```

#### Global: Customizing UI Widgets

UI Builders enable external UI customization. If no builder is defined, the built-in UI widgets will be used. Each builder comes with the required parameters and methods, allowing easy access to the data and logic layer methods. This means that you can use the provided context data, such as a specific conversation, to return a builder tailored to that context.

There are two modes for defining custom builders on a global scale: During `initUIKit` and by using manager.

- **During init**: Defined during the `initUIKit` call using the `components` parameter with `componentBuilders` specified for each modular UI component.
- **By Manager**: Usage instructions shows on the next section **Dynamically Updating UI Builders**.

We recommend using the following dynamic definition method, allows modifications from any location within the codebase.

##### Dynamically Updating UI Builders

Please note that this approach is only applicable for modifying global builders that are defined during the `initUIKit` call using the `components` parameter or the default builders when no custom builders are specified. This method cannot be used to modify builders at the component instance level, i.e., the `builders` parameter passed when instantiating a component.

To dynamically update the UI builders that affect all instances of a specific component, follow these steps:

1. Retrieve the global `builder` instance from the component's manager by appending `Manager` to the component's name (e.g., `TencentCloudChatMessageManager`).
2. Call the `setBuilders` method on the retrieved instance and provide your custom builders.

For instance, to customize the UI widgets of the `TencentCloudChatConversation` component, you can use the following code:

```dart
TencentCloudChatConversationManager.builder.setBuilders(
  conversationItemContentBuilder: (V2TimConversation conversation) => Container(),
  conversationHeaderBuilder: () => Container(),
);
```

In this example, you only need to specify the builders you want to customize, while the others remain unchanged.

With this approach, you can dynamically update global builders anywhere in your application.

Each Modular UI Component has a `builder` associated with its specific UI widgets, and the usage remains consistent across all components.

#### Global: Handling Component-Level Events

Each component is equipped with two types of events: `uiEventHandlers` (e.g., onTap-like events) and `lifeCycleEventHandlers` (business-related events).

In general, events provide a comprehensive set of information parameters to help you implement custom business logic. For events returning a boolean value (which is the majority), returning `true` prevents the execution of default business logic, while returning `false` allows it to proceed.

Custom event handling allows for seamless integration of your business logic with the default UIKit actions. For instance, you can customize component navigation, as demonstrated in the **Case: Manual Navigation between Components** section below.

There are two methods for attaching your event handlers globally:

1. During the `initUIKit` call, use the `components` parameter and specify `componentEventHandlers` for each modular UI component.
2. Employ each component's manager to dynamically attach and update event handlers from any location within the codebase.

To dynamically attach and update event handlers that listen to events from all instances, follow these steps:

1. Access the global `eventHandlers` instance from the component's manager by appending `Manager` to the component's name (e.g., `TencentCloudChatMessageManager`).
2. Invoke `setEventHandlers` for `uiEventHandlers` or `lifeCycleEventHandlers` to update specific event handlers.
_Note: This will cause the corresponding event's previously attached handlers to be invalidated, i.e., overridden._

For example usage, refer to the **Case: Manual Navigation between Components** section.

Whichever method you choose, you only need to attach the event handlers you wish, while the others remain unspecified.

##### Case: Manual Navigation between Components

As previously mentioned, our components support automatic navigation between them, provided they have been declared. However, if your business logic is incompatible with automatic navigation (e.g., you need to navigate to other components or implement additional business logic), you can manually handle events by listening to click events and blocking default navigation to meet your requirements.

For manual navigation between provided components, it's advised to attach corresponding `onTap`-like event handlers and return `true` or `false` to decide whether to proceed with built-in auto-navigation.

For example, when clicking a contact item in the `TencentCloudChatContact` component, you can execute custom navigation as shown in the following sample:

```dart
TencentCloudChatContactManager.eventHandlers.uiEventHandlers.setEventHandlers(
    onTapContactItem: ({
    String? userID,
    String? groupID,
    }) async {
        // Determine whether manual navigation is needed based on the provided userID, groupID, and your business logic.
        if (needed) {
            // Execute your custom business logic
            return true;
        } else {
            // Continue with the built-in logic
            return false;
        }
    },
);
```

#### Global: Taking Control of Each Component

Each component is associated with a set of control methods. These provide enhanced functionality and control over the component's behavior.

To use these control methods, first retrieve the `controller` instance from the respective component's manager, which is formed by appending `Manager` to the component's name (e.g., `TencentCloudChatMessageManager`). You can then call the methods provided by the `controller` instance.

For example, you can use the controller from the `TencentCloudChatMessage` component by accessing it through the `TencentCloudChatMessageManager` object(e.g., `TencentCloudChatMessageManager.controller`). To send a message and add it to the message list UI, use the following code:

```dart
// Create a message using the Chat SDK.
final res = await TencentCloudChat.instance.chatSDKInstance.messageSDK.createTextMessage(text: "Sample Message", mentionedUsers: []);
if(res != null ){
  // Then send the created message using the controller obtained from TencentCloudChatMessageManager.
  TencentCloudChatMessageManager.controller.sendMessage(createdMessage: res, userID: "admin");
}
```

Each Modular UI Component has a controller associated with its specific functionality. The usage is consistent with the sample controller as shown above.

For detailed explanations of each controller method, please refer to the comments provided with each method.


### Additional Methods in TencentCloudChat.controller

In the Basic Usage section above, we explained how to initialize the UIKit and log in using the `TencentCloudChat.controller`.

This controller also contains several other methods that can be used to control some global aspects of the UIKit. For example:

- **toggleBrightnessMode**: This method allows you to switch between dark and light modes.
- **getThemeData**: This method returns the built-in theme configuration in the form of a material3 ThemeData class. This can be used to configure the `theme` parameter for your `MaterialApp`, ensuring that our UIKit and the other components of your project have a consistent appearance.
- **setThemeColors**: This method allows you to customize the color configurations for both dark and light modes in the UIKit. This ensures that our UIKit and the other components of your project have a consistent appearance. The configurations set by this method will take effect across all our UI components.
- **setBrightnessMode**: This method allows you to set the current Brightness Mode.

For more methods and their descriptions, please refer to the annotations for each method. This allows you to have more control over the behavior and appearance of the UIKit, enabling you to fine-tune it to perfectly fit the needs of your project.

### Introducing Callbacks for UIKit

To enhance the user experience, we have added callback functionality to UIKit. Initialize UIKit with `TencentCloudChatCoreController.initUIKit()` and set up the `callbacks` accordingly.

These callbacks serve to notify users and your program about SDK events, SDK API errors and specific UIKit events that require user attention.

The `onTencentCloudChatSDKEvent` is employed to handle Chat SDK events returns, the `onTencentCloudChatSDKFailedCallback` is employed to handle Chat SDK API error returns, while the `onTencentCloudChatUIKitUserNotificationEvent` manages UIKit events that may necessitate displaying a dialog or toast to the user.

#### Handling SDK Events with `onTencentCloudChatSDKEvent`

The `onTencentCloudChatSDKEvent` callback is a tool that allows you to handle a variety of events triggered by the Chat SDK. 

This callback is directly integrated with the Chat SDK and is defined by the `V2TimSDKListener`.

The `onTencentCloudChatSDKEvent` callback covers a range of user and system-related events, including but not limited to:

```dart
    ErrorCallback? onConnectFailed, // Triggered when the connection to the server fails
    VoidCallback? onConnectSuccess, // Triggered when the connection to the server is successful
    VoidCallback? onConnecting, // Triggered when the SDK is attempting to connect to the server
    VoidCallback? onKickedOffline, // Triggered when the user is kicked offline
    V2TimUserFullInfoCallback? onSelfInfoUpdated, // Triggered when the user's information is updated
    VoidCallback? onUserSigExpired, // Triggered when the user's signature has expired
    OnUserStatusChanged? onUserStatusChanged, // Triggered when the user's status changes
    OnLog? onLog, // Triggered when a new log message is generated
    OnUserInfoChanged? onUserInfoChanged, // Triggered when a user's information changes
    OnAllReceiveMessageOptChanged? onAllReceiveMessageOptChanged, // Triggered when the option to receive all messages changes
```

For example, the `onKickedOffline` and `onUserSigExpired` events are triggered when the current user has been logged out from Tencent Cloud Chat for various reasons. 
In response to these events, your program may need to navigate the user back to the login page or perform other actions based on your specific business requirements.

#### Handling SDK Failures with `onTencentCloudChatSDKFailedCallback`

The callback is defined as `typedef OnTencentCloudChatSDKFailedCallback = void Function(String apiName, int code, String desc);`

In this definition, 
- `apiName` refers to the invoked SDK method, 
- `code` denotes the SDK error code (further information can be found in [SDK Error Codes Doc](https://www.tencentcloud.com/document/product/1047/34348)).
- `desc` provides an explanation of the error.

#### Handling UIKit Events with `onTencentCloudChatUIKitUserNotificationEvent`

This callback is responsible for addressing all UIKit component events that warrant user notification, such as navigation issues with origin messages.

It is defined as `typedef OnTencentCloudChatUIKitUserNotificationEvent = void Function(TencentCloudChatComponentsEnum component, TencentCloudChatUserNotificationEvent event);`

- The `component` parameter, represented by `TencentCloudChatComponentsEnum`, indicates the source component of the event. Specifically, `TencentCloudChatComponentsEnum.global` refers to global events that are not associated with any particular child component, such as being disconnected.
- The `TencentCloudChatUserNotificationEvent` consists of two parameters, `eventCode` and `text`.
    - The `eventCode` is unique to the UIKit and consists of five digits in negative starting with `-1`. The first three digits identify the associated component, while the last two digits represent the event. A comprehensive list of event codes is provided below.
    - The `text` parameter contains a predefined, localized message that can be displayed to users via a dialog or toast. Developers can either display the `text` content directly or create custom messages based on the `eventCode`.

##### Event Code Structure

| Start of `eventCode` | Component                      |
|----------------------|--------------------------------|
| -101                 | Global                         |
| -102                 | `TencentCloudChatConversation` |
| -103                 | `TencentCloudChatMessage`      |
| -104                 | `TencentCloudChatContact`      |
| -105                 | `TencentCloudChatUserProfile`  |
| -106                 | `TencentCloudChatGroupProfile` |
| -107                 | `TencentCloudChatSearch`       |
| -108                 | `TencentCloudChatSearch`       |
| -108                 | Others...                      |

##### Comprehensive List of Event Codes

| `eventCode` | `text` by default (Localized to Supported Languages) | Description (Not included in event, for documentation purposes only)                                                                                                                                                                                                                                                                                                                                      |
|-------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| -10101      | You have been kicked off                             | The current user has been kicked off from the online session.                                                                                                                                                                                                                                                                                                                                             |
| -10301      | Original message not found                           | The original message for a replied message cannot be found when the user attempts to navigate to it.                                                                                                                                                                                                                                                                                                      |
| -10302      | Just a moment, retrieving group members.             | Upon first entering a group, if the group has a large number of members, it takes some time to load the member list. During this loading period, if a user wants to mention other users, the data may not be available. For extremely large groups, this process can last a few seconds. If a user attempts to open the mentioning panel during this time, they will encounter this notification message. |
| -10401      | Contact Added Successfully                           | Success in adding a user as contact after send adding request.                                                                                                                                                                                                                                                                                                                                            |
| -10402      | Request Sent                                         | Success in sending the request to a a user as contact, but waiting for process by the other user.                                                                                                                                                                                                                                                                                                         |
| -10403      | Cannot Add Contact                                   | Failed in adding a user as contact after send adding request.                                                                                                                                                                                                                                                                                                                                             |
| -10404      | Cannot send application to work group                | User attend to join a work group, that can not joined manually without invitation.                                                                                                                                                                                                                                                                                                                        |
| -10405      | Permission needed                                    | User attend to join a group, where permission needed.                                                                                                                                                                                                                                                                                                                                                     |
| -10406      | Group Joined                                         | User attend to join an already joined group, where permission needed.                                                                                                                                                                                                                                                                                                                                     |

## Conclusion

We hope that this documentation will help you understand the power and flexibility of our new Flutter Chat UIKit. 
With its modular design and a wide range of customizable options, it provides a comprehensive solution for building chat applications. 
Its advanced features, such as Conversation management, Message handling, and built-in navigation transitions, make it a robust tool for developers.

We look forward to seeing the amazing applications you will create with our UIKit. If you have any questions or need further information, feel free to reach out us.

- [Telegram](https://t.me/+gvScYl0uQ3U4MTRl)
- [X (Twitter)](https://x.com/runlin_wang95)
