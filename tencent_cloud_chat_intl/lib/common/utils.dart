import 'dart:io';

Future<bool> checkPackagePath(String packagePath) async {
  Directory packageDirectory = Directory(packagePath);
  if (await packageDirectory.exists()) {
    return true;
  } else {
    return false;
  }
}
