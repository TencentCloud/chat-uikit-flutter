
English, Simplified Chinese, Traditional Chinese, Japanese and Korean have been embedded in Tencent Cloud Chat TUIKit as the default interface languages.

Adding other interface languages or modifying the current language items are available for you, according to the instructions of this tutorial.

![](https://qcloudimg.tencent-cloud.cn/raw/2df62f8a62453c063c396cb656dd07bc.png)

## Using the default languages

If only Chinese(both traditional and simplified), English, Japanese and Korean are needed for your application, please refer to this section.

### Choosing device language

No further steps are needed, as meeting device language can be automatically.

### Pre-set the language manually

If you tend to specify the language manually, please provide the target language Enum to `init()` in `TIMUIKitCore.getInstance()`.

```dart
import 'package:tim_ui_kit/tim_ui_kit.dart';

final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

final isInitSuccess = await _coreInstance.init(
 language: LanguageEnum.en, // Enums as below
// ...Other configurations
);
```

Enum options for language：


```dart
enum LanguageEnum {
 zhHant, // Chinese, traditional
 zhHans, // Chinese, simplified
 en, // English
 ko, // korean
 ja // Japanese
}
```

### Modify language dynamically

Please just invoking `I18nUtils(null, language);`, while the `language` here should be set as the [ISO 639 Language codes](#code).

Example code:

```dart
I18nUtils(null, "en");
```

## Need more languages / customize translation items

Adding languages, apart from English, Simplified Chinese, Traditional Chinese, Japanese and Korean, or modifying some translation items words, can be referred to this section.

>? This solution only works for languages with a left-to-right reading direction. For small languages that read from right to left, such as Arabic, please fork our source code from [our GitHub repository](https://github.com/TencentCloud/chat-uikit-flutter) to complete the custom left and right mirroring Development adaptation, and import to your project manually.

### Adding language translation files

The key of this section is this part, that is, inject your custom internationalized language file into the Tencent Cloud Chat.

#### Get the language template

Run the following command, and choose `A` as instruction.

```shell
flutter pub run tencent_im_base
```

![](https://qcloudimg.tencent-cloud.cn/raw/01215e7861ed2736c0155c456ad2d0d6.png)

Now, all the pre-set default language files, as JSON, have been generated to your project, `languages/` directory.

![](https://qcloudimg.tencent-cloud.cn/raw/2618d546ece854d93cfe21d1ad342ade.png)

Duplicate for language files, based on the template you are most familiar with.

The newly duplicated language files should be named as `strings_${language code}.i18n.json`. While, `${language code}` should be replaced by [ISO 639 Language Codes](#code). Such as, the file containing Danish language items should be named as `strings_da.i18n.json`.

Duplicate multiple language files, if you need to support multiple other languages.

#### Customize translations

Now, you can modify the language files generated in the previous step.

Open each language file, including the files you just duplicated, except `strings_zh-Hans.i18n.json`, translate or modify each `value` to target language, while keeping the md5 key unchanged.

![](https://qcloudimg.tencent-cloud.cn/raw/540536815ec579ca4343a7013a768178.png)

After translation and modification, all the supported languages files, including those you duplicated and default, should be in the `languages/` directory.

![](https://qcloudimg.tencent-cloud.cn/raw/0b409d05e26b81b60a4babed07936cda.png)

#### Activate those language files

Run the following command, and choose `B` as instruction.

```dart
flutter pub run tencent_im_base
```

After the script has finished, those customization languages are activated on your local Flutter environment.

![](https://qcloudimg.tencent-cloud.cn/raw/7823200ee5f323bc254aad61be122907.png)

>? If you are developing with a team collaboratively, or using DevOps pipeline compilation. You also need to execute this solution on your colleague's computer or in the DevOps pipeline compilation command script.

### Choosing device language

No further steps are needed, as meeting device language can be automatically.

### Pre-set the language manually

If you tend to specify the language manually, please provide the [ISO 639 Language Codes](#code) of the language to `init()` in `TIMUIKitCore.getInstance()`.

```dart
import 'package:tim_ui_kit/tim_ui_kit.dart';

final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

final isInitSuccess = await _coreInstance.init(
 extraLanguage: "ja", // ISO 639 Language Codes
// ...Other configurations
);
```

### Modify language dynamically

Please just invoking `I18nUtils(null, language);`, while the `language` here should be set as the [ISO 639 Language codes](#code).

Example code:

```dart
I18nUtils(null, "en");
```

[](id:code)

## Appendix: Language codes

| Language     | Code     | Language     | Code     |
|--------|--------|--------|--------|
| Arabic   | ar  | Bulgarian  | bg     |
| Croatian  | hr     | Czech    | cs     |
| Danish    | da     | German     | de     |
| Greek    | el     | English     | en     |
| Estonian  | et     | Spanish   | es     |
| Finnish    | fi     | French     | fr     |
| Irish   | ga     | Hindi    | hi     |
| Hungarian   | hu     | Hebrew   | he     |
| Italian   | it     | Japanese     | ja     |
| Korean    | ko     | Latvian  | lv     |
| Lithuanian   | lt     | Dutch    | nl     |
| Norwegian    | no     | Polish    | pl     |
| Portuguese   | pt     | Swedish    | sv     |
| Romanian  | ro     | Russian     | ru     |
| Serbian  | sr  | Slovak  | sk     |
| Slovenian | sl     | Thai     | th     |
| Turkish   | tr     | Ukrainian   | uk  |
| Chinese (Simplified)） | zh-Hans | Chinese (Traditional) | zh-Hant |

## Contact us[](id:contact)

If there's anything unclear or you have more ideas, feel free to contact us!

- [Telegram Group](https://t.me/+1doS9AUBmndhNGNl)
- [WhatsApp Group](https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A)
