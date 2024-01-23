#### What's this?

This pub package is a plug-in for Tencent Cloud Chat. You can use this plug-in to process robot messages, which supports robot messages with connection jumps and streaming messages similar to chatGPT.

#### How to use?

Install the package

```html
flutter pub add tencent_cloud_chat_robot
```

Determine whether the message is a robot message

```dart
TencentCloudChatRobotPlugin.isRobotMessage(message);
```

Render bot messages

```dart
TencentCloudChatRobotPlugin.renderRobotMessage(message);
```



#### Api list

| apiName             | Describe                                              | Param                                                        |
| ------------------- | ----------------------------------------------------- | ------------------------------------------------------------ |
| renderRobotMessage  | Render the message to the message List                | [V2TimMessage Instance](https://pub.dev/documentation/tencent_cloud_chat_sdk/latest/models_v2_tim_message/V2TimMessage-class.html) |
| isRobotMessage      | Determine whether the message is a robot message      | [V2TimMessage Instance](https://pub.dev/documentation/tencent_cloud_chat_sdk/latest/models_v2_tim_message/V2TimMessage-class.html) |
| ignoreRenderMessage | Determine whether the message need  ignore for render | [V2TimMessage Instance](https://pub.dev/documentation/tencent_cloud_chat_sdk/latest/models_v2_tim_message/V2TimMessage-class.html) |

#### Dependency package

[Tencent_cloud_chat_sdk](https://pub.dev/packages/tencent_cloud_chat_sdk)

#### Backend interface

Send a Stream message from backend, use Tencent cloud chat，use this api [SendMessage To Person](https://cloud.tencent.com/document/product/269/2282)，you need to send a custom message. The Data field is a json string like this.

```json
{
	"chatbotPlugin": 1,
	"src": 2,
  "isFinished": 1,// When this field is 0, it means it is not over, and when it is 1, it means it is over.
	"chunks": ['hello']
}
```

Then you need add chunks，by [ModifyMessage](https://cloud.tencent.com/document/product/269/74740) like this

```json
{
	"chatbotPlugin": 1,
	"src": 2,
  "isFinished": 1,// When this field is 0, it means it is not over, and when it is 1, it means it is over.
	"chunks": ['hello','this','is','a','robot']
}
```

