class TencentCloudChatUserConfig {
  /// Whether to use the user's online status. Note that using this function requires the Premium edition of Tencent Cloud Chat.
  bool? useUserOnlineStatus;
  /// Deprecated.
  @Deprecated("Deprecated")
  bool? autoDownloadMultimediaMessage;

  TencentCloudChatUserConfig({
    this.useUserOnlineStatus,
    this.autoDownloadMultimediaMessage,
  });
}
