## Features

This is a Message Reaction Plugin for Tencent Cloud Chat.

## Getting Started

To use this plugin, add the following code to the `plugins` array in `initUIKit`:

```dart
TencentCloudChatPluginItem(
  name: "messageReaction",
  pluginInstance: TencentCloudChatMessageReaction(
    context: context,
  ),
),
```
This will enable the use of the Message Reaction Plugin in your application.
