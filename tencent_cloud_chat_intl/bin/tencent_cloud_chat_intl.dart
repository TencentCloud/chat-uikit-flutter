// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:file/local.dart';
import 'package:path/path.dart' as p;
import 'package:tencent_cloud_chat_intl/common/utils.dart';
import 'package:yaml/yaml.dart';

void main(List<String> arguments) async {
  bool isPathValid = false;
  stdout.write("\n\nWelcome to Tencent Cloud Chat Internationalization (Intl) Tool Version 2.\n\n");

  stdout.write("Please refer to our documentation at https://www.tencentcloud.com/document/product/1047/52154 for detailed instructions on how to use this tool.\n\n");

  stdout.write(
      "If you require custom internationalization features, such as adding or modifying language entries, or even expanding support for additional languages, \nplease fork our package's GitHub repository located at https://github.com/RoleWong/tencentcloud_chat_uikit_intl. \nAfter forking, clone the repository to a directory of your choice. \nTo proceed with customization, provide the path to the directory containing your forked copy of the package.\n");

  // Read the user's pubspec.yaml file
  String pubspecContent = await File('pubspec.yaml').readAsString();
  final pubspec = loadYaml(pubspecContent);

  // Try to find the package path in the pubspec.yaml file
  String? packagePath;

  String currentWorkingDirectory = Directory.current.path;

  while (!isPathValid) {
    packagePath = null;
    try {
      packagePath ??= pubspec['dependency_overrides']['tencent_cloud_chat_intl']['path'];
    } catch (_) {}
    try {
      packagePath ??= pubspec['dependencies']['tencent_cloud_chat_intl']['path'];
    } catch (_) {}

    if (packagePath != null) {
      // If the packagePath is not an absolute path, combine it with the current working directory
      if (!p.isAbsolute(packagePath)) {
        // Combine the current working directory with the packagePath
        packagePath = p.normalize(p.join(currentWorkingDirectory, packagePath));
      }
    }

    if (packagePath != null) {
      // If the package path is found, display it to the user and ask for confirmation
      stdout.write("\n\nThe local path to your forked repository found in 'pubspec.yaml' is: $packagePath\n");
      stdout.write("Do you want to use this path? (Y/n): ");
      String? usePath = stdin.readLineSync();
      if (usePath == null || usePath.toLowerCase() == 'y') {
        isPathValid = await checkPackagePath(packagePath);
        if (!isPathValid) {
          stdout.write("\nThe specified package path is not valid. Please enter a new path.\n");
          continue;
        }
      } else {
        // If the user does not confirm, ask for a custom path
        stdout.write("\nPlease enter the local path (relative or absolute) to your forked repository for further customization: ");
        final inputPath = stdin.readLineSync();

        if (inputPath != null && inputPath.isNotEmpty) {
          // If the packagePath is not an absolute path, combine it with the current working directory
          if (!p.isAbsolute(inputPath)) {
            // Combine the current working directory with the packagePath
            packagePath = p.normalize(p.join(currentWorkingDirectory, inputPath));
          } else {
            packagePath = inputPath;
          }
        }

        if (packagePath.trim().isNotEmpty) {
          isPathValid = await checkPackagePath(packagePath);
          if (!isPathValid) {
            stdout.write("\nThe specified package path is not valid. Please enter a new path.\n");
            continue;
          }
        } else {
          stdout.write("Invalid input. Please enter a non-empty path.");
          continue;
        }
      }
    } else {
      // If the package path is not found, prompt the user to enter a custom path
      stdout.write("\nThe local path to your forked repository was not found in 'pubspec.yaml'.\n");
      stdout.write("If you do not specify a local path in 'pubspec.yaml', subsequent operations will not take effect.\n");
      stdout.write("Please enter the local path to your forked repository for further customization: ");
      packagePath = stdin.readLineSync();
      if (packagePath != null && packagePath.trim().isNotEmpty) {
        isPathValid = await checkPackagePath(packagePath);
        if (!isPathValid) {
          stdout.write("\nThe specified package path is not valid. Please enter a new path.\n");
          continue;
        }
      } else {
        stdout.write("\nInvalid input. Please enter a non-empty path.");
        continue;
      }
    }
  }

  // Inform the user that the package path has been successfully configured
  stdout.write("\nThe package path has been successfully configured as: $packagePath\n");
  stdout.write("You can now proceed with using the tool.\n");

  stdout.write("\nPlease select your desired action from the following options:\n");
  stdout.write("A. Add new language entries for internationalization. This action must be performed before using new entries.\n");
  stdout.write("B. Retrieve the tool's built-in language entries, including arb files for all supported languages, and save them to your project directory for further customization.\n");
  stdout.write("C. Inject your modified language arb files for all languages back into the tool, allowing the updated configuration to take effect.\n");
  stdout.write("Please select: (A/B/C) ");

  final option = stdin.readLineSync();

  switch (option) {
    case "A":
    case "a":
      addNewEntries(packagePath!);
      break;
    case "B":
    case "b":
      getOriginalLanguageArb(packagePath!);
      break;
    case "C":
    case "c":
      addLanguageToBase(packagePath!);
      break;
  }
}

void addNewEntries(String packagePath) async {
  stdout.write("\nNow, it will read new entries from the 'new_language_entries.txt' file in the project root directory.\n");
  readNewEntriesFromFile(packagePath);
}

void readNewEntriesFromFile(String packagePath) async {
  // Specify the path to the user's text file containing new entries
  String userTxtFilePath = './new_language_entries.txt';

  // Check if the file exists, and create it if it doesn't
  final file = File(userTxtFilePath);
  if (!file.existsSync()) {
    stdout.write("\nFile 'new_language_entries.txt' does not exist. Creating it...\n");
    await file.create();
  }

  stdout.write(
      "\nPlease confirm that you have added the new entries in the 'new_language_entries.txt' file in JSON format, following the Flutter intl syntax standard. \nYou can refer to the official documentation at https://docs.flutter.dev/ui/accessibility-and-localization/internationalization#adding-your-own-localized-messages.\n\nPress Enter to continue.");
  stdin.readLineSync();

  // Read the new entries from the user's text file
  Map<String, dynamic> newEntries = json.decode(await file.readAsString());

  // Add the new entries with their hash keys to each language JSON file
  Directory(p.join(packagePath, 'lib', 'language_arb')).listSync().where((element) => element is File && element.path.endsWith('.arb')).forEach((arbFile) {
    // Explicitly cast FileSystemEntity to File
    File file = arbFile as File;

    try {
      // Read the existing ARB file
      Map<String, dynamic> jsonContent = json.decode(file.readAsStringSync());

      // Add the new entries to the existing ARB content, without duplicating entries with the same key
      newEntries.forEach((key, value) {
        if (!jsonContent.containsKey(key)) {
          jsonContent[key] = value;
        }
      });

      // Create a JsonEncoder with indentation for pretty printing
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');

      // Write the updated content back to the JSON file
      file.writeAsStringSync(encoder.convert(jsonContent));
      stdout.write("\nSuccessfully added new entries to ${file.path}");
    } catch (e) {
      stdout.write("\nFailed to add new entries to ${file.path}: ${e.toString()}");
    }
  });
}

void getOriginalLanguageArb(String packagePath) async {
  const fs = LocalFileSystem();

  final languageDirectory = Directory(p.join(packagePath, "lib", "language_arb"));
  final templates = languageDirectory.listSync();
  final List<String> templatesPath = templates.map((e) => e.path).toList();

  if (!(fs.isDirectorySync("languages"))) {
    Directory("languages").create();
  }

  stdout.write("\n");
  for (var element in templatesPath) {
    final fileName = p.basename(element);
    if (fileName.contains(".arb")) {
      stdout.write("Copying: $fileName\n");
      final file = File(element);
      await file.copy(p.join("languages", fileName));
    }
  }

  stdout.write("\nThe language files have been successfully stored in the `languages` directory.\n");
}

void addLanguageToBase(String packagePath) async {
  final baseL10NARBPath = p.join(packagePath, "lib", "language_arb");

  final customLanguageDir = Directory("languages");
  final List<FileSystemEntity> files = customLanguageDir.listSync();
  List<String> filePaths = files.map((e) => e.path).toList();
  for (var value in filePaths) {
    final file = File(value);
    final fileName = p.basename(value);
    await file.copy(p.join(baseL10NARBPath, fileName));
  }

  // Run the 'flutter gen-l10n' command
  stdout.write("\nGenerating localization configs to apply your changes...\n");
  final result = await Process.run('flutter', ['gen-l10n'], workingDirectory: packagePath, runInShell: true);

  if (result.exitCode == 0) {
    stdout.write("\nSuccessfully generated localization configs.\n");
  } else {
    stdout.write("Failed to generate localization files. Please manually run 'flutter gen-l10n' in the tencentcloud_chat_uikit_intl package directory.\n");
  }
}
