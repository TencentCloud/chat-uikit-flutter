# Flutter UIKit V2 升级指南

## 背景

从`tencent_cloud_chat_uikit`发布两年以来，得到了大量的用户的使用和认可，我们也在持续不断的优化和迭代`uikit`，致力于帮助用户能够快速创建功能丰富的聊天应用程序，因此我们很高兴推出了全新的`Flutter Chat UIKit`。它完全从头开始构建，提供了全面的能力，并且采用模块化方法构建，用户可根据需要选择所需的组件，同时保持应用的轻量级和高效性。

本文主要帮助使用老版本的`UIKit`如何升级到全新版本.

## 初始化登录

在使用老版本`UIKit`的时候，通常我们需要先`初始化`，再`登录`, 这个流程和`无UI SDK`的使用是一致的。所以在实际的应用程序中代码如下:

1: 在您应用的上层组见中初始化`uikit`,同时注册`listener`来处理用户信息更新，userSig 过期等全局事件。

```
// 初始化uikit
final coreInstance = TIMUIKitCore.getInstance();
coreInstance.init(
    sdkAppID: 123,
    loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
    listener: V2TimSDKListener(
        onConnectSuccess: () {},
        onUserSigExpired: () {},
        onSelfInfoUpdated: (info) {}
    ),
    ...
);
```

2: 在您的登录界面中登录`uikit`

```
// 登录uikit
final coreInstance = TIMUIKitCore.getInstance();
coreInstance.login(
    userID: userId,
    userSig: userSig,
);
```

在全新`UIKit`中, 我们不再对外暴露`登录`这一步。因为我们更想容用户关注到，只需要初始化`UIKit`即可。所以我们的接入流程如下:

1: 在您应用的上层组件中添加全局的`listener`来处理用户信息更新，userSig 过期等全局事件。这是可选的，您也可以不注册。

```
TencentCloudChat.controller.addGlobalCallback(
        callbacks: TencentCloudChatCallbacks(
            onTencentCloudChatSDKEvent: V2TimSDKListener(
      onConnectSuccess: () {
      },
      onConnectFailed: (code, error) {},
      onKickedOffline: () {

      },
      onSelfInfoUpdated: (info) {

      },
      onUserSigExpired: () {

      },
    )));
```

您只需要将老版本初始化添加的`listener`用`addGlobalCallback`注册即可。

2: 在您的登录界面中初始化`UIKit`

```
TencentCloudChat.controller.initUIKit(
        options: TencentCloudChatInitOptions(
            sdkAppID: Config.sdkappid, userID: userID, userSig: userSig),
        plugins: [
            // 注册插件, 例如翻译，表情，消息回应等
          TencentCloudChatPluginItem(
            name: "messageReaction",
            pluginInstance: TencentCloudChatMessageReaction(
              context: context!,
            ),
          ),
          TencentCloudChatPluginItem(
              name: "textTranslate",
              pluginInstance: TencentCloudChatTextTranslate(
                onTranslateFailed: () {
                },
                onTranslateSuccess: () {
                },
              )),
          TencentCloudChatPluginItem(
              name: "sticker",
              initData: TencentCloudChatStickerInitData(
                      userID: userID,
                      useDefaultSticker: true,
                      useDefaultCustomFace_4350: true)
                  .toJson(),
              pluginInstance: TencentCloudChatStickerPlugin(context: context!))
        ],
        callbacks: TencentCloudChatCallbacks(
          onTencentCloudChatSDKFailedCallback: (apiName, code, desc) {
            // onError
          },
          onTencentCloudChatUIKitUserNotificationEvent: (component, event) {
          },
        ),
        config: TencentCloudChatConfig(
            themeConfig: TencentCloudChatThemeModel(),
            userConfig: TencentCloudChatUserConfig(),
        components: const TencentCloudChatInitComponentsRelated(
            usedComponentsRegister: [
                // 消息组件注册
              TencentCloudChatMessageManager.register,
            ])));
```

## 组件使用

在老版本中,会话列表、消息、联系人列表等组件都是在同一个包里面的, 因此在使用部分组件的情况下，会导致代码冗余。在全新版本的`UIKit`您可以根据您的业务需要选择不同的组件集成到您的项目中。下面以消息组件为例, 如何使用.

1: 在您的项目中安装`tencent_cloud_chat_message `;

2: 安装完成后，您需要在 TencentCloudChat.controller.initUIKit 方法的 components 的 usedComponentsRegister 参数中注册此 UI 组件。

```
    await TencentCloudChat.controller.initUIKit(
      components: TencentCloudChatInitComponentsRelated(
        usedComponentsRegister: [
          TencentCloudChatMessageManager.register, /// 添加这一行
          /// ...
        ],
      /// ...
      ),
      /// ...
    );
```

3: 使用`TencentCloudChatMessage` 组件.

具体组件的参数以及`controller`可以参考对应组件的使用方式.

## 插件使用

在全新版本的`UIKit`中我们新增了诸多插件, 您可选择使用。例如消息翻译插件，表情插件，消息回应插件，语音转文字插件等。您只需要将对应的插件添加到项目中，然后注册即可。下面以消息翻译插件为例:

1: 安装对应的插件到项目中: `tencent_cloud_chat_text_translate`.

2: 安装完成后，您需要在 TencentCloudChat.controller.initUIKit 方法的 plugins 参数中注册此插件。

```
await TencentCloudChat.controller.initUIKit(
      plugins: [
        TencentCloudChatPluginItem(
          name: "textTranslate",
          pluginInstance: TencentCloudChatTextTranslate(
            onTranslateFailed: () {
            },
            onTranslateSuccess: () {
            },
          ),
        ),]
      /// ...
    );
```
