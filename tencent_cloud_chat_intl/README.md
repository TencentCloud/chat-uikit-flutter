# TencentCloudChat Internationalization (i18n) Tool

Welcome to
the [TencentCloudChat](https://trtc.io/products/chat?utm_source=gfs&utm_medium=link&utm_campaign=%E6%B8%A0%E9%81%93&_channel_track_key=k6WgfCKn)
Internationalization (i18n) Tool, a dedicated package developed by
the [Chat](https://trtc.io/products/chat?utm_source=gfs&utm_medium=link&utm_campaign=%E6%B8%A0%E9%81%93&_channel_track_key=k6WgfCKn)
team.

This package offers a lightweight, powerful, and developer-friendly internationalization language
tool tailored for
our [TencentCloudChat](https://www.tencentcloud.com/document/product/1047/50059?from=pub) and the
applications from our customers.

Built upon
the [official Flutter `intl` solution](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization)
, this tool has been further developed and encapsulated to better suit our needs.

It is recommended to familiarize yourself with
the [official internationalization solution](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization)
before using this tool. For coding on language template `.arb` files and other factors not covered
by this tool, the process is the same as
the [official solution](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization)
.

With this package, you can easily manage multi-language translation entries, add new entries, modify
existing ones, and even integrate new languages into your projects. It greatly simplifies the
process of creating a multilingual user experience for chat applications, as well as other
applications with internationalization needs.

![Sample Image](https://qcloudimg.tencent-cloud.cn/raw/cfdebbe4f935fe73bc8fafd205faa4a9.png)

## Features

- Manage translation entries in an easy and organized manner, based on the Flutter official `intl`
  solution with a similar usage.
- Seamlessly add new language entries or modify existing ones.
- Default support for English, Chinese(Both simplified and traditional), Japanese, Korean, and Arabic with
  the flexibility to extend support for additional languages as needed.
- Integrates smoothly with TencentCloudChat or other projects.
- Supports third-party developers in implementing internationalization for their apps.
- Comprehensive documentation and support.
- Based on `intl`, further developed, and tailored to better suit our needs and improve usability.

## Accessing Predefined Localized Strings

Since our UIKit libraries have already included this package as a dependency, there is no need for
you to add it manually.

With this setup, you can easily use our built-in language key entries in the five default languages
without any further implementation.

1. Import the `tencentcloud_chat_uikit_intl.dart` file in your project:

```dart
import 'package:tencentcloud_chat_uikit_intl/tencentcloud_chat_uikit_intl.dart';
```

2. Initialize the `TencentCloudChatUIKitIntl` in your main widget tree using the `BuildContext`,
   before navigating to the home page:

```dart
TencentCloudChatUIKitIntl.init
(
context
);
```

3. Use the `tL10n` global variable to access localized strings:

```dart

String album = tL10n.album;
```

By following these steps, you can easily access and use the existing localized strings provided by
the `tencentcloud_chat_uikit_intl` package in your project.

## Customizing Internationalization

If you want to customize the internationalization features, such as adding new supported languages
or modifying existing translations, follow these steps:

1. Fork the `tencentcloud_chat_uikit_intl` repository
   on [tool's GitHub repository](https://github.com/RoleWong/tencent_chat_intl_tool): https://github.com/RoleWong/tencent_chat_intl_tool
   . This will create a copy of the repository under your GitHub account.

2. Clone the forked repository to a directory of your choice on your local machine. You can do this
   using the following Git command:

```
git clone https://github.com/<your-username>/tencentcloud_chat_uikit_intl.git
```

3. Add the local path of your forked repository to your project's `pubspec.yaml` file
   using `dependency_overrides`:

```yaml
dependency_overrides:
  tencentcloud_chat_uikit_intl:
    path: /path/to/your/forked/repository
```

Replace `/path/to/your/local/repository` with the actual path to the cloned repository on your local
machine.

4. Run the following command in your project directory:

```sh
dart run tencent_cloud_chat_intl
```

This script will guide you through the process of customizing internationalization, including adding
new language entries and modifying existing translations.

### Adding New Language Entries

1. Add the new language entries in JSON format to the `new_language_entries.txt` file in your
   project's root directory.

   Ensure that you follow the Flutter intl syntax standard. You can refer to the official
   documentation
   at https://docs.flutter.dev/ui/accessibility-and-localization/internationalization#adding-your-own-localized-messages
   .

2. Run the `dart run tencent_cloud_chat_intl` command and select option `A` to incorporate the
   new entries into the tool's built-in ARB files.

3. After adding new entries, proceed to the next step to translate them.

### Modifying Existing Translations and Adding Support for New Languages

1. Run the `dart run tencent_cloud_chat_intl` command and select option `B` to copy the
   built-in language entries (ARB files) to your project directory.

2. Modify the ARB files in the `languages` directory as needed.

3. To add support for a new language, follow these steps:

    - Navigate to the `languages` directory in your project.
    - Choose a locale `.arb` file that you are familiar with and make a copy of it.
    - Rename the copied file to `l10n_${language code}_${script code}_${country code}.arb`,
      where `language code` is required, and `script code` and `country code` are optional,
      e.g., `l10n_fr.arb` for French and `l10n_zh_Hant_HK.arb` for Traditional Chinese for Hong
      Kong.
    - If adding a new locale specifying a script code or country code, also create a base locale
      file (without the script code or country code).
    - Translate all the entries in the new locale files to the corresponding language.

4. Run the `dart run tencent_cloud_chat_intl` command and select option `C` to apply your
   changes.

## License

This project is licensed under the [MIT License](LICENSE).