import 'dart:io' show Platform;

bool get isTencentCloudChatFlutterTestEnvironment =>
    Platform.environment.containsKey('FLUTTER_TEST');
