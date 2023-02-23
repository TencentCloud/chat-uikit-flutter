import 'package:flutter/cupertino.dart';

class TIMUIKitConfig {
  /// Control if show online status of friends or contacts.
  /// This only works with [Ultimate Edition].
  /// [Default]: true.
  final bool isShowOnlineStatus;

  /// Controls if allows to check the disk memory after login.
  /// If the storage space is less than 1GB,
  /// an callback from `onTUIKitCallbackListener` will be invoked,
  /// type is `INFO`, while code is 6661403.
  final bool isCheckDiskStorageSpace;

  /// The asset path of the default avatar image.
  final String? defaultAvatarAssetPath;

  /// The configuration of border radius for all the avatar shows in TUIKit.
  final BorderRadius? defaultAvatarBorderRadius;

  const TIMUIKitConfig({
    this.defaultAvatarAssetPath,
    this.defaultAvatarBorderRadius,
    this.isCheckDiskStorageSpace = true,
    this.isShowOnlineStatus = true,
  });
}
